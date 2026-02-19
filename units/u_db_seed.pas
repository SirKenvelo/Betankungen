{
  u_db_seed.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Demo-Datenbank-Seeding fuer Betankungen.

  Verantwortlichkeiten:
  - Erzeugt reproduzierbare Demo-Daten fuer stations/cars/fuelups.
  - Erstellt Schema bei Bedarf (CREATE TABLE IF NOT EXISTS).
  - Optionales Zuruecksetzen per Force-Option (idempotent).

  Design-Entscheidungen:
  - Daten werden pseudozufaellig erzeugt, aber via SeedValue reproduzierbar.
  - Keine Fachlogik aus den Haupt-Units; reines Test/Seed-Modul.

  Hinweis:
  - Standard-Demo-DB: ~/.local/share/Betankungen/betankungen_demo.db
  ---------------------------------------------------------------------------
}
unit u_db_seed;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

procedure SeedDemoDatabase(
  const DemoDbPath: string;
  StationCount, FuelupCount: integer;
  SeedValue: integer;
  Force: boolean
);

// Liefert den Standardpfad der Demo-Datenbank (XDG-konform).
function GetDefaultDemoDbPath: string;

implementation

uses
  SQLite3Conn, SQLDB, DateUtils, u_log;

const
  // Zielkorridor fuer realistische Demo-Datensatzgroesse.
  DEMO_FUELUPS_MIN = 300;
  DEMO_FUELUPS_MAX = 500;
  // Zielkorridor fuer historische Zeitspanne der Demo-Daten.
  DEMO_YEAR_SPAN_MIN = 3;
  DEMO_YEAR_SPAN_MAX = 5;

function GetDefaultDemoDbPath: string;
var
  BaseDir: string;
begin
  BaseDir := GetUserDir + '.local/share/Betankungen/';
  Result := BaseDir + 'betankungen_demo.db';
end;

// Stellt sicher, dass das Verzeichnis zum Dateipfad existiert.
procedure EnsureDirForFile(const FilePath: string);
var
  DirPath: string;
begin
  DirPath := ExtractFileDir(FilePath);
  if (DirPath <> '') and (not DirectoryExists(DirPath)) then
    if not ForceDirectories(DirPath) then
      raise Exception.Create('Konnte Verzeichnis nicht erstellen: ' + DirPath);
end;

// Fuehrt ein beliebiges SQL-Statement ohne Resultset aus.
procedure ExecSQL(Conn: TSQLite3Connection; Tran: TSQLTransaction; const S: string);
var
  Q: TSQLQuery;
begin
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text := S;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

// Prueft, ob die Tabelle mindestens eine Zeile enthaelt.
function TableHasRows(Conn: TSQLite3Connection; Tran: TSQLTransaction; const TableName: string): boolean;
var
  Q: TSQLQuery;
begin
  Result := False;
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text := 'SELECT 1 FROM ' + TableName + ' LIMIT 1;';
    Q.Open;
    Result := not Q.EOF;
  finally
    Q.Free;
  end;
end;

// Prueft, ob eine Spalte in einer Tabelle vorhanden ist.
function ColumnExists(Conn: TSQLite3Connection; Tran: TSQLTransaction; const TableName, ColumnName: string): boolean;
var
  Q: TSQLQuery;
begin
  Result := False;
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text := 'PRAGMA table_info(' + TableName + ');';
    Q.Open;
    while not Q.EOF do
    begin
      if SameText(Q.FieldByName('name').AsString, ColumnName) then
      begin
        Result := True;
        Break;
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

// Erstellt das benoetigte Schema, falls Tabellen fehlen.
procedure CreateSchemaIfMissing(Conn: TSQLite3Connection; Tran: TSQLTransaction);
begin
  // stations
  ExecSQL(Conn, Tran,
    'CREATE TABLE IF NOT EXISTS stations (' +
    '  id         INTEGER PRIMARY KEY,' +
    '  brand      TEXT NOT NULL,' +
    '  street     TEXT NOT NULL,' +
    '  house_no   TEXT NOT NULL,' +
    '  zip        TEXT NOT NULL,' +
    '  city       TEXT NOT NULL,' +
    '  phone      TEXT,' +
    '  owner      TEXT,' +
    '  created_at TEXT NOT NULL DEFAULT (datetime(''now'')),' +
    '  updated_at TEXT' +
    ');'
  );

  // cars (v4)
  ExecSQL(Conn, Tran,
    'CREATE TABLE IF NOT EXISTS cars (' +
    '  id                  INTEGER PRIMARY KEY,' +
    '  name                TEXT    NOT NULL,' +
    '  plate               TEXT,' +
    '  note                TEXT,' +
    '  odometer_start_km   INTEGER NOT NULL CHECK (odometer_start_km > 0),' +
    '  odometer_start_date TEXT    NOT NULL,' +
    '  created_at          TEXT    NOT NULL DEFAULT (datetime(''now'')),' +
    '  updated_at          TEXT,' +
    '  UNIQUE(name)' +
    ');'
  );

  // Kompatibel fuer bestehende cars-Tabellen (v4-light -> v4-full)
  if not ColumnExists(Conn, Tran, 'cars', 'plate') then
    ExecSQL(Conn, Tran, 'ALTER TABLE cars ADD COLUMN plate TEXT;');
  if not ColumnExists(Conn, Tran, 'cars', 'note') then
    ExecSQL(Conn, Tran, 'ALTER TABLE cars ADD COLUMN note TEXT;');
  if not ColumnExists(Conn, Tran, 'cars', 'odometer_start_km') then
    ExecSQL(Conn, Tran, 'ALTER TABLE cars ADD COLUMN odometer_start_km INTEGER NOT NULL DEFAULT 1;');
  if not ColumnExists(Conn, Tran, 'cars', 'odometer_start_date') then
    ExecSQL(Conn, Tran, 'ALTER TABLE cars ADD COLUMN odometer_start_date TEXT NOT NULL DEFAULT ''1970-01-01'';');

  ExecSQL(Conn, Tran,
    'UPDATE cars SET odometer_start_km = 1 WHERE odometer_start_km IS NULL OR odometer_start_km <= 0;'
  );
  ExecSQL(Conn, Tran,
    'UPDATE cars SET odometer_start_date = date(''now'') WHERE odometer_start_date IS NULL OR odometer_start_date = '''' OR odometer_start_date = ''1970-01-01'';'
  );

  ExecSQL(Conn, Tran,
    'INSERT OR IGNORE INTO cars(id, name, odometer_start_km, odometer_start_date) ' +
    'VALUES(1, ''Hauptauto'', 1, date(''now''));'
  );

  // fuelups
  ExecSQL(Conn, Tran,
    'CREATE TABLE IF NOT EXISTS fuelups (' +
    '  id         INTEGER PRIMARY KEY,' +
    '  station_id                INTEGER NOT NULL,' +
    '  car_id                    INTEGER NOT NULL,' +
    '  fueled_at                 TEXT    NOT NULL,' +
    '  odometer_km               INTEGER NOT NULL,' +
    '  liters_ml                 INTEGER NOT NULL,' +
    '  total_cents               INTEGER NOT NULL,' +
    '  price_per_liter_milli_eur INTEGER NOT NULL,' +
    '  is_full_tank              INTEGER NOT NULL DEFAULT 0,' +
    '  missed_previous           INTEGER NOT NULL DEFAULT 0,' +
    '  fuel_type                 TEXT,' +
    '  payment_type              TEXT,' +
    '  pump_no                   TEXT,' +
    '  note                      TEXT,' +
    '  created_at                TEXT NOT NULL DEFAULT (datetime(''now'')),' +
    '  updated_at                TEXT,' +
    '  FOREIGN KEY(station_id) REFERENCES stations(id) ON DELETE RESTRICT,' +
    '  FOREIGN KEY(car_id)     REFERENCES cars(id)     ON DELETE RESTRICT,' +
    '  CHECK (odometer_km > 0),' +
    '  CHECK (liters_ml > 0),' +
    '  CHECK (total_cents >= 0),' +
    '  CHECK (price_per_liter_milli_eur >= 0),' +
    '  CHECK (is_full_tank IN (0,1)),' +
    '  CHECK (missed_previous IN (0,1))' +
    ');'
  );

  // Kompatibel fuer bestehende Demo-DBs (v3 -> v4 lite per ALTER)
  if not ColumnExists(Conn, Tran, 'fuelups', 'car_id') then
    ExecSQL(Conn, Tran, 'ALTER TABLE fuelups ADD COLUMN car_id INTEGER NOT NULL DEFAULT 1;');
  if not ColumnExists(Conn, Tran, 'fuelups', 'missed_previous') then
    ExecSQL(Conn, Tran, 'ALTER TABLE fuelups ADD COLUMN missed_previous INTEGER NOT NULL DEFAULT 0;');

  ExecSQL(Conn, Tran, 'DROP INDEX IF EXISTS idx_fuelups_fueled_at;');
  ExecSQL(Conn, Tran, 'DROP INDEX IF EXISTS idx_fuelups_odometer_km;');
  ExecSQL(Conn, Tran, 'DROP INDEX IF EXISTS idx_fuelups_unique;');
  ExecSQL(Conn, Tran, 'CREATE INDEX IF NOT EXISTS idx_fuelups_station_id ON fuelups(station_id);');
  ExecSQL(Conn, Tran, 'CREATE INDEX IF NOT EXISTS idx_fuelups_car_fueled_at ON fuelups(car_id, fueled_at);');
  ExecSQL(Conn, Tran, 'CREATE INDEX IF NOT EXISTS idx_fuelups_car_odometer_km ON fuelups(car_id, odometer_km);');
  ExecSQL(Conn, Tran, 'CREATE UNIQUE INDEX IF NOT EXISTS idx_fuelups_unique ON fuelups(car_id, station_id, fueled_at, odometer_km);');
end;

// Formatiert TDateTime im von SQLite akzeptierten ISO-Format.
function ISODateTime(const DT: TDateTime): string;
begin
  // SQLite akzeptiert "YYYY-MM-DD HH:NN:SS"
  Result := FormatDateTime('yyyy"-"mm"-"dd" "hh":"nn":"ss', DT);
end;

// Fuegt eine Anzahl Stations-Datensaetze mit plausiblen Demo-Werten ein.
procedure SeedStations(Conn: TSQLite3Connection; Tran: TSQLTransaction; StationCount: integer);
const
  BRANDS: array[0..9] of string = ('Aral','Shell','TotalEnergies','Esso','Jet','AVIA','HEM','ORLEN','Star','Q1');
  STREETS: array[0..9] of string = ('Hauptstr.','Bahnhofstr.','Dortmunder Str.','Muensterstr.','Bismarckstr.','Ringstr.','Kaiserstr.','Nordstr.','Suedstr.','Hagenstr.');
  CITIES: array[0..9] of string = ('Unna','Dortmund','Hamm','Kamen','Schwerte','Luenen','Bochum','Essen','Wuppertal','Muenster');
  ZIPS: array[0..9] of string = ('59423','44135','59065','59174','58239','44532','44787','45127','42103','48143');
var
  Q: TSQLQuery;
  i, bi: integer;
  brand, street, houseNo, zip, city, phone, owner: string;
begin
  Dbg('SeedStations: count=' + IntToStr(StationCount));
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text :=
      'INSERT INTO stations (brand, street, house_no, zip, city, phone, owner) ' +
      'VALUES (:brand, :street, :house_no, :zip, :city, :phone, :owner);';

    for i := 1 to StationCount do
    begin
      bi := Random(Length(BRANDS));
      brand := BRANDS[bi];
      street := STREETS[Random(Length(STREETS))];
      houseNo := IntToStr(1 + Random(180));
      city := CITIES[Random(Length(CITIES))];
      zip := ZIPS[Random(Length(ZIPS))];

      if Random(100) < 60 then phone := '+49 23' + IntToStr(10 + Random(90)) + ' ' + IntToStr(100000 + Random(900000))
      else phone := '';

      if Random(100) < 40 then owner := 'Inhaber ' + IntToStr(i)
      else owner := '';

      Q.ParamByName('brand').AsString := brand;
      Q.ParamByName('street').AsString := street;
      Q.ParamByName('house_no').AsString := houseNo;
      Q.ParamByName('zip').AsString := zip;
      Q.ParamByName('city').AsString := city;

      if phone = '' then Q.ParamByName('phone').Clear else Q.ParamByName('phone').AsString := phone;
      if owner = '' then Q.ParamByName('owner').Clear else Q.ParamByName('owner').AsString := owner;

      Q.ExecSQL;
    end;
  finally
    Q.Free;
  end;
end;

// Fuegt Fuelups ein, verteilt ueber mehrere Jahre mit plausiblen Werten.
procedure SeedFuelups(
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  StationCount, FuelupCount, YearSpanYears: integer
);
const
  FUEL_TYPES: array[0..3] of string = ('E5','E10','Diesel','Super+');
  PAY_TYPES: array[0..2] of string = ('EC','Kreditkarte','Bar');
var
  Q: TSQLQuery;
  i: integer;
  stationId: integer;
  carId: integer;
  odometer: integer;
  litersMl: int64;
  pplMilli: int64;
  totalCents: int64;
  fullTank: integer;
  missedPrevious: integer;
  fueledAt: TDateTime;
  dtStart: TDateTime;
  spanDays: integer;
  fuelType, payType, pumpNo, note: string;
  kmStep: integer;
begin
  Dbg(
    'SeedFuelups: stations=' + IntToStr(StationCount) +
    ' fuelups=' + IntToStr(FuelupCount) +
    ' years=' + IntToStr(YearSpanYears)
  );
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text :=
      'INSERT INTO fuelups (' +
      ' station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents, price_per_liter_milli_eur,' +
      ' is_full_tank, missed_previous, fuel_type, payment_type, pump_no, note' +
      ') VALUES (' +
      ' :station_id, :car_id, :fueled_at, :odometer_km, :liters_ml, :total_cents, :ppl_milli,' +
      ' :is_full, :missed_previous, :fuel_type, :payment_type, :pump_no, :note' +
      ');';

    // “Realistisch”: 3-5 Jahre zurück
    dtStart := IncYear(Now, -YearSpanYears);
    spanDays := DaysBetween(DateOf(Now), DateOf(dtStart));
    if spanDays <= 0 then spanDays := 1;
    odometer := 50000 + Random(2000); // Start

    for i := 1 to FuelupCount do
    begin
      // Zeitraum: zufaellig ueber die letzten Jahre verteilt, aber chronologisch steigend
      fueledAt := dtStart + ((i - 1) * (spanDays / FuelupCount)) + (Random * 0.8); // etwas jitter

      // Kilometer: pro Tankung +280..620km
      kmStep := 280 + Random(341);
      odometer := odometer + kmStep;

      stationId := 1 + Random(StationCount);
      carId := 1; // aktueller CLI-Workflow: ein Default-Fahrzeug

      // liters: 30..70L in ml
      litersMl := int64(30000 + Random(40001)); // 30000..70000 ml

      // price per liter in milli-eur: 1.55..2.05 EUR -> 1550..2050 milli-eur
      pplMilli := int64(1550 + Random(501));

      // total cents = liters(L) * eur/L * 100
      // litersMl/1000 = Liter; pplMilli/1000 = EUR/L
      // total EUR = litersMl * pplMilli / 1_000_000
      // total cents = total EUR * 100 = litersMl * pplMilli / 10_000
      totalCents := (litersMl * pplMilli) div 10000;

      // Volltank: 70% true (damit Zyklen entstehen)
      if Random(100) < 70 then fullTank := 1 else fullTank := 0;

      // Golden Information: selten gesetzt
      if Random(100) < 10 then missedPrevious := 1 else missedPrevious := 0;

      fuelType := FUEL_TYPES[Random(Length(FUEL_TYPES))];
      payType := PAY_TYPES[Random(Length(PAY_TYPES))];

      if Random(100) < 60 then pumpNo := IntToStr(1 + Random(12)) else pumpNo := '';
      if Random(100) < 25 then note := 'Demo ' + IntToStr(i) else note := '';

      Q.ParamByName('station_id').AsInteger := stationId;
      Q.ParamByName('car_id').AsInteger := carId;
      Q.ParamByName('fueled_at').AsString := ISODateTime(fueledAt);
      Q.ParamByName('odometer_km').AsInteger := odometer;
      Q.ParamByName('liters_ml').AsLargeInt := litersMl;
      Q.ParamByName('total_cents').AsLargeInt := totalCents;
      Q.ParamByName('ppl_milli').AsLargeInt := pplMilli;
      Q.ParamByName('is_full').AsInteger := fullTank;
      Q.ParamByName('missed_previous').AsInteger := missedPrevious;

      if fuelType = '' then Q.ParamByName('fuel_type').Clear else Q.ParamByName('fuel_type').AsString := fuelType;
      if payType = '' then Q.ParamByName('payment_type').Clear else Q.ParamByName('payment_type').AsString := payType;
      if pumpNo = '' then Q.ParamByName('pump_no').Clear else Q.ParamByName('pump_no').AsString := pumpNo;
      if note = '' then Q.ParamByName('note').Clear else Q.ParamByName('note').AsString := note;

      Q.ExecSQL;
    end;
  finally
    Q.Free;
  end;
end;

// Orchestriert das Befuellen der Demo-DB inkl. Schema und optionalem Zuruecksetzen.
procedure SeedDemoDatabase(
  const DemoDbPath: string;
  StationCount, FuelupCount: integer;
  SeedValue: integer;
  Force: boolean
);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  HasData: boolean;
  EffectiveFuelupCount: integer;
  EffectiveYearSpanYears: integer;
begin
  Dbg('SeedDemo: path=' + DemoDbPath);
  Dbg(
    'SeedDemo: stations=' + IntToStr(StationCount) +
    ' fuelups=' + IntToStr(FuelupCount) +
    ' seed_value=' + IntToStr(SeedValue) +
    ' force=' + BoolToStr(Force, True)
  );
  if StationCount <= 0 then raise Exception.Create('StationCount muss > 0 sein.');
  if FuelupCount <= 0 then raise Exception.Create('FuelupCount muss > 0 sein.');

  EnsureDirForFile(DemoDbPath);

  if SeedValue <> 0 then
    RandSeed := SeedValue
  else
    Randomize;

  if (FuelupCount < DEMO_FUELUPS_MIN) or (FuelupCount > DEMO_FUELUPS_MAX) then
    EffectiveFuelupCount := DEMO_FUELUPS_MIN + Random(DEMO_FUELUPS_MAX - DEMO_FUELUPS_MIN + 1)
  else
    EffectiveFuelupCount := FuelupCount;

  EffectiveYearSpanYears := DEMO_YEAR_SPAN_MIN + Random(DEMO_YEAR_SPAN_MAX - DEMO_YEAR_SPAN_MIN + 1);

  Dbg(
    'SeedDemo: effective_fuelups=' + IntToStr(EffectiveFuelupCount) +
    ' year_span_years=' + IntToStr(EffectiveYearSpanYears)
  );

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  try
    Conn.DatabaseName := DemoDbPath;
    Conn.Transaction := Tran;
    Conn.Open;
    Tran.StartTransaction;

    CreateSchemaIfMissing(Conn, Tran);

    HasData := TableHasRows(Conn, Tran, 'stations') or TableHasRows(Conn, Tran, 'fuelups');
    Dbg('SeedDemo: vorhandene Daten=' + BoolToStr(HasData, True));

    if HasData and (not Force) then
      raise Exception.Create('Demo-DB enthält bereits Daten. Nutze --force zum Überschreiben.');

    if Force then
    begin
      ExecSQL(Conn, Tran, 'DELETE FROM fuelups;');
      ExecSQL(Conn, Tran, 'DELETE FROM stations;');
      ExecSQL(Conn, Tran, 'DELETE FROM cars WHERE id <> 1;');
      // SQLite Autoincrement reset (nur vorhanden, wenn AUTOINCREMENT genutzt wird)
      try
        ExecSQL(Conn, Tran, 'DELETE FROM sqlite_sequence WHERE name IN (''fuelups'',''stations'',''cars'');');
      except
        // sqlite_sequence existiert nicht in jeder DB-Konfiguration -> ignorieren
      end;
    end;

    SeedStations(Conn, Tran, StationCount);
    SeedFuelups(Conn, Tran, StationCount, EffectiveFuelupCount, EffectiveYearSpanYears);

    Tran.Commit;
  except
    on E: Exception do
    begin
      if Tran.Active then Tran.Rollback;
      raise;
    end;
  end;

  Conn.Free;
  Tran.Free;
end;

end.
