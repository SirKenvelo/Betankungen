{
  u_maintenance_db.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-03-14
  UPDATED: 2026-04-27
  AUTHOR : Christof Kempinski
  DB-Schema-, CRUD- und Stats-Helfer fuer `betankungen-maintenance`.

  Verantwortlichkeiten:
  - Aufloesung eines stabilen Default-DB-Pfads fuer das Modul.
  - Idempotente Initialisierung/Migration des Modul-Schemas.
  - Persistenz einer separaten Modul-Schema-Version (`module_meta.schema_version`).
  - Event-CRUD fuer `maintenance_events`.
  - Listen- und Stats-Abfragen fuer die CLI-/Companion-Ausgabe.
  ---------------------------------------------------------------------------
}
unit u_maintenance_db;

{$mode objfpc}{$H+}

interface

type
  TMaintenanceEventRow = record
    Id: Int64;
    CarId: Integer;
    EventDate: string;
    EventType: string;
    CostCents: Int64;
    Notes: string;
    CreatedAt: string;
  end;

  TMaintenanceEventRows = array of TMaintenanceEventRow;

  TMaintenanceStats = record
    EventsTotal: Int64;
    CarsTotal: Int64;
    TotalCostCents: Int64;
    AvgCostPerEventCents: Int64;
    FirstEventDate: string;
    LastEventDate: string;
  end;

function ResolveMaintenanceDbPath(const OverridePath: string): string;
function CurrentModuleSchemaVersion: Integer;
procedure EnsureMaintenanceSchema(const DbPath: string; out Changed: Boolean);
function AddMaintenanceEvent(
  const DbPath: string;
  const CarId: Integer;
  const EventDate: string;
  const EventType: string;
  const CostCents: Int64;
  const Notes: string): Int64;
procedure ListMaintenanceEvents(
  const DbPath: string;
  const CarIdFilter: Integer;
  out Rows: TMaintenanceEventRows);
procedure CollectMaintenanceStats(
  const DbPath: string;
  const CarIdFilter: Integer;
  out Stats: TMaintenanceStats);

implementation

uses
  SysUtils, sqlite3conn, sqldb;

const
  MODULE_SCHEMA_VERSION = 1;

function CurrentModuleSchemaVersion: Integer;
begin
  Result := MODULE_SCHEMA_VERSION;
end;

function ResolveMaintenanceDbPath(const OverridePath: string): string;
var
  BaseDir: string;
  HomeDir: string;
begin
  if Trim(OverridePath) <> '' then
    Exit(OverridePath);

  BaseDir := Trim(GetEnvironmentVariable('XDG_DATA_HOME'));
  if BaseDir = '' then
  begin
    HomeDir := Trim(GetEnvironmentVariable('HOME'));
    if HomeDir <> '' then
      BaseDir := IncludeTrailingPathDelimiter(HomeDir) + '.local/share';
  end;

  if BaseDir = '' then
    BaseDir := GetCurrentDir;

  Result := IncludeTrailingPathDelimiter(BaseDir) +
    'Betankungen' + DirectorySeparator + 'maintenance_module.db';
end;

procedure EnsureParentDir(const DbPath: string);
var
  DirPath: string;
begin
  DirPath := ExtractFileDir(DbPath);
  if DirPath = '' then
    Exit;

  if not DirectoryExists(DirPath) then
    if not ForceDirectories(DirPath) then
      raise Exception.Create('Konnte Modul-DB-Verzeichnis nicht anlegen: ' + DirPath);
end;

function ReadSchemaVersion(const Q: TSQLQuery): Integer;
var
  Raw: string;
begin
  Q.Close;
  Q.SQL.Text := 'SELECT value FROM module_meta WHERE key = :k LIMIT 1;';
  Q.Params.ParamByName('k').AsString := 'schema_version';
  Q.Open;
  try
    if Q.EOF then
      Exit(0);

    Raw := Trim(Q.Fields[0].AsString);
    if Raw = '' then
      Exit(0);

    if not TryStrToInt(Raw, Result) then
      raise Exception.Create('Ungueltige module_meta.schema_version: "' + Raw + '"');
  finally
    Q.Close;
  end;
end;

procedure EnsureMaintenanceSchema(const DbPath: string; out Changed: Boolean);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  StoredVersion: Integer;
begin
  Changed := False;
  EnsureParentDir(DbPath);

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;
    Q.Database := Conn;
    Q.Transaction := Tran;
    Conn.Open;
    Tran.StartTransaction;

    try
      Q.SQL.Text := 'PRAGMA foreign_keys = ON;';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS module_meta (' +
        '  key TEXT PRIMARY KEY,' +
        '  value TEXT NOT NULL' +
        ');';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS maintenance_events (' +
        '  id INTEGER PRIMARY KEY AUTOINCREMENT,' +
        '  car_id INTEGER NOT NULL,' +
        '  event_date TEXT NOT NULL,' +
        '  event_type TEXT NOT NULL,' +
        '  cost_cents INTEGER NOT NULL CHECK(cost_cents >= 0),' +
        '  notes TEXT,' +
        '  created_at TEXT NOT NULL DEFAULT (datetime(''now'')),' +
        '  updated_at TEXT NOT NULL DEFAULT (datetime(''now''))' +
        ');';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_maintenance_events_car_date ' +
        'ON maintenance_events(car_id, event_date);';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_maintenance_events_type ' +
        'ON maintenance_events(event_type);';
      Q.ExecSQL;

      StoredVersion := ReadSchemaVersion(Q);
      if StoredVersion = 0 then
      begin
        Q.SQL.Text :=
          'INSERT INTO module_meta(key, value) VALUES (:k, :v) ' +
          'ON CONFLICT(key) DO UPDATE SET value = excluded.value;';
        Q.Params.ParamByName('k').AsString := 'schema_version';
        Q.Params.ParamByName('v').AsString := IntToStr(MODULE_SCHEMA_VERSION);
        Q.ExecSQL;
        Changed := True;
      end
      else if StoredVersion > MODULE_SCHEMA_VERSION then
        raise Exception.Create(
          'Modul-Schema ist neuer als dieses Binary unterstuetzt ' +
          '(db=' + IntToStr(StoredVersion) + ', supported=' + IntToStr(MODULE_SCHEMA_VERSION) + ').'
        );

      Tran.Commit;
    except
      on E: Exception do
      begin
        if Tran.Active then
          Tran.Rollback;
        raise Exception.Create('Maintenance-Migration fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

function AddMaintenanceEvent(
  const DbPath: string;
  const CarId: Integer;
  const EventDate: string;
  const EventType: string;
  const CostCents: Int64;
  const Notes: string): Int64;
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  SchemaChanged: Boolean;
begin
  EnsureMaintenanceSchema(DbPath, SchemaChanged);

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;
    Q.Database := Conn;
    Q.Transaction := Tran;
    Conn.Open;
    Tran.StartTransaction;

    try
      Q.SQL.Text :=
        'INSERT INTO maintenance_events(' +
        '  car_id, event_date, event_type, cost_cents, notes' +
        ') VALUES(:car_id, :event_date, :event_type, :cost_cents, :notes);';
      Q.Params.ParamByName('car_id').AsInteger := CarId;
      Q.Params.ParamByName('event_date').AsString := EventDate;
      Q.Params.ParamByName('event_type').AsString := EventType;
      Q.Params.ParamByName('cost_cents').AsLargeInt := CostCents;
      Q.Params.ParamByName('notes').AsString := Notes;
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Text := 'SELECT last_insert_rowid() AS id;';
      Q.Open;
      try
        Result := Q.FieldByName('id').AsLargeInt;
      finally
        Q.Close;
      end;

      Tran.Commit;
    except
      on E: Exception do
      begin
        if Tran.Active then
          Tran.Rollback;
        raise Exception.Create('Maintenance-Insert fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

procedure ListMaintenanceEvents(
  const DbPath: string;
  const CarIdFilter: Integer;
  out Rows: TMaintenanceEventRows);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  N: Integer;
  SchemaChanged: Boolean;
begin
  SetLength(Rows, 0);
  EnsureMaintenanceSchema(DbPath, SchemaChanged);

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;
    Q.Database := Conn;
    Q.Transaction := Tran;
    Conn.Open;

    if CarIdFilter > 0 then
    begin
      Q.SQL.Text :=
        'SELECT id, car_id, event_date, event_type, cost_cents, ' +
        '       COALESCE(notes, '''') AS notes, created_at ' +
        'FROM maintenance_events ' +
        'WHERE car_id = :car_id ' +
        'ORDER BY event_date DESC, id DESC;';
      Q.Params.ParamByName('car_id').AsInteger := CarIdFilter;
    end
    else
      Q.SQL.Text :=
        'SELECT id, car_id, event_date, event_type, cost_cents, ' +
        '       COALESCE(notes, '''') AS notes, created_at ' +
        'FROM maintenance_events ' +
        'ORDER BY event_date DESC, id DESC;';

    Q.Open;
    try
      N := 0;
      while not Q.EOF do
      begin
        SetLength(Rows, N + 1);
        Rows[N].Id := Q.FieldByName('id').AsLargeInt;
        Rows[N].CarId := Q.FieldByName('car_id').AsInteger;
        Rows[N].EventDate := Q.FieldByName('event_date').AsString;
        Rows[N].EventType := Q.FieldByName('event_type').AsString;
        Rows[N].CostCents := Q.FieldByName('cost_cents').AsLargeInt;
        Rows[N].Notes := Q.FieldByName('notes').AsString;
        Rows[N].CreatedAt := Q.FieldByName('created_at').AsString;
        Inc(N);
        Q.Next;
      end;
    finally
      Q.Close;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

procedure CollectMaintenanceStats(
  const DbPath: string;
  const CarIdFilter: Integer;
  out Stats: TMaintenanceStats);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  SchemaChanged: Boolean;
begin
  FillChar(Stats, SizeOf(Stats), 0);
  EnsureMaintenanceSchema(DbPath, SchemaChanged);

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;
    Q.Database := Conn;
    Q.Transaction := Tran;
    Conn.Open;

    if CarIdFilter > 0 then
    begin
      Q.SQL.Text :=
        'SELECT ' +
        '  COUNT(*) AS events_total, ' +
        '  COUNT(DISTINCT car_id) AS cars_total, ' +
        '  COALESCE(SUM(cost_cents), 0) AS total_cost_cents, ' +
        '  COALESCE(MIN(event_date), '''') AS first_event_date, ' +
        '  COALESCE(MAX(event_date), '''') AS last_event_date ' +
        'FROM maintenance_events WHERE car_id = :car_id;';
      Q.Params.ParamByName('car_id').AsInteger := CarIdFilter;
    end
    else
      Q.SQL.Text :=
        'SELECT ' +
        '  COUNT(*) AS events_total, ' +
        '  COUNT(DISTINCT car_id) AS cars_total, ' +
        '  COALESCE(SUM(cost_cents), 0) AS total_cost_cents, ' +
        '  COALESCE(MIN(event_date), '''') AS first_event_date, ' +
        '  COALESCE(MAX(event_date), '''') AS last_event_date ' +
        'FROM maintenance_events;';

    Q.Open;
    try
      Stats.EventsTotal := Q.FieldByName('events_total').AsLargeInt;
      Stats.CarsTotal := Q.FieldByName('cars_total').AsLargeInt;
      Stats.TotalCostCents := Q.FieldByName('total_cost_cents').AsLargeInt;
      Stats.FirstEventDate := Q.FieldByName('first_event_date').AsString;
      Stats.LastEventDate := Q.FieldByName('last_event_date').AsString;
      if Stats.EventsTotal > 0 then
        Stats.AvgCostPerEventCents :=
          (Stats.TotalCostCents + (Stats.EventsTotal div 2)) div Stats.EventsTotal
      else
        Stats.AvgCostPerEventCents := 0;
    finally
      Q.Close;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

end.
