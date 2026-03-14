{
  u_maintenance_db.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-03-14
  UPDATED: 2026-03-14
  AUTHOR : Christof Kempinski
  DB-Schemaverwaltung fuer das Companion-Modul `betankungen-maintenance`.

  Verantwortlichkeiten:
  - Aufloesung eines stabilen Default-DB-Pfads fuer das Modul.
  - Idempotente Initialisierung/Migration des Modul-Schemas.
  - Persistenz einer separaten Modul-Schema-Version (`module_meta.schema_version`).
  ---------------------------------------------------------------------------
}
unit u_maintenance_db;

{$mode objfpc}{$H+}

interface

function ResolveMaintenanceDbPath(const OverridePath: string): string;
function CurrentModuleSchemaVersion: Integer;
procedure EnsureMaintenanceSchema(const DbPath: string; out Changed: Boolean);

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

end.
