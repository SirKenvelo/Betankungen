{
  u_db_init.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-03-31
  AUTHOR : Christof Kempinski
  Datenbank-Bootstrapper und Schema-Verwaltung fuer SQLite.

  Verantwortlichkeiten:
  - Automatisches Provisioning: Erstellt die SQLite-Datei bei Erststart.
  - Idempotentes Schema-Design: Stellt Tabellen, Indizes und Trigger bereit,
    ohne bestehende Daten zu gefaehrden (IF NOT EXISTS / IF EXISTS).
  - Metadaten-Management: Initialisiert und aktualisiert technische Kennzahlen
    (Schema-Versionen, Start-KM-Stände, Zeitstempel) in der 'meta'-Tabelle.
  - Datenintegritaet: Erzwingt Constraints (FK, CHECK) und nutzt atomare
    Transaktionen für den gesamten Initialisierungsprozess.

  Design-Entscheidungen:
  - Transaktionssicherheit: Alles oder Nichts. Schlaegt ein Teil des Schemas
    fehl, wird die gesamte DB in den Vorzustand versetzt (Rollback).
  - Robustheit: Explizite Trennung von technischem Fehlerhandling (try-except)
    und Ressourcen-Bereinigung (try-finally).
  - Skalierbarkeit: Vorbereitet fuer zukuenftige Migrations-Logik durch
    zentrale Speicherung der 'schema_version'.

  Hinweis: Die Unit nutzt die SQLDB-Komponenten von Free Pascal (TSQLite3Connection).

  Schema-Historie:
  v1: Basis-Metadaten (meta-Tabelle)
  v2: Stammdaten für Tankstellen (stations)
  v3: Transaktionsdaten für Betankungen (fuelups) inkl. Start-KM Logik
  v4: Fuelups erweitert um car_id + missed_previous, neue cars-Tabelle
  v5: cars erweitert um vin, reg_doc_path, reg_doc_sha256
  v5a: fuelups erweitert um receipt_link (additiv via ALTER, schema_version bleibt 5)
  v6: stations erweitert um latitude_e6, longitude_e6, plus_code

  Hinweis: Bei Schema-Änderungen bitte die 'schema_version' in der 
  EnsureDatabase-Prozedur UND hier im Header inkrementieren.
  ---------------------------------------------------------------------------
}
unit u_db_init;

{$mode objfpc}{$H+}

interface

// ----------------
// Stellt sicher, dass die DB existiert und das Schema aktuell ist.
// Rueckgabewert: True, wenn die DB-Datei neu angelegt wurde.
function EnsureDatabase(const DbPath: string): boolean;

// Liest einen Wert aus der meta-Tabelle (technische Key-Value Metadaten).
function ReadMetaValue(const DbPath, AKey: string): string;

implementation

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, u_log;

// ----------------
// Stellt sicher, dass die DB existiert und das Schema aktuell ist.
// Rueckgabewert: True, wenn die DB-Datei neu angelegt wurde.
function EnsureDatabase(const DbPath: string): boolean;
var
  CreatedNow: boolean;
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  HasFuelupsTable: boolean;
  HasCarsTable: boolean;
  HasStationLatitudeE6: boolean;
  HasStationLongitudeE6: boolean;
  HasStationPlusCode: boolean;
  HasCarPlate: boolean;
  HasCarNote: boolean;
  HasCarOdometerStartKm: boolean;
  HasCarOdometerStartDate: boolean;
  HasCarId: boolean;
  HasMissedPrevious: boolean;
  HasReceiptLink: boolean;
  DefaultCarId: integer;
  MetaOdoStartKm: integer;
  MetaOdoStartDate: string;
  MetaTmp: string;
  CarIdExpr: string;
  MissedPreviousExpr: string;
  ReceiptLinkExpr: string;

  function TableExists(const TableName: string): boolean;
  begin
    Q.Close;
    Q.SQL.Text :=
      'SELECT 1 ' +
      'FROM sqlite_master ' +
      'WHERE type = ''table'' AND name = :name ' +
      'LIMIT 1;';
    Q.Params.ParamByName('name').AsString := TableName;
    Q.Open;
    Result := not Q.EOF;
    Q.Close;
  end;

  function ColumnExists(const TableName, ColumnName: string): boolean;
  begin
    Result := False;
    Q.Close;
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
    Q.Close;
  end;
begin
  // Existiert die Datei bereits? (Conn.Open legt sie an, falls nicht vorhanden)
  CreatedNow := not FileExists(DbPath);

  Dbg('EnsureDatabase: ' + ExpandFileName(DbPath));
  Dbg('CreatedNow=' + BoolToStr(CreatedNow, True));

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);

  try
    try
      // Verbindung und Transaktion verdrahten
      Conn.DatabaseName := DbPath;
      Conn.Transaction := Tran;
      Q.DataBase := Conn;
      Q.Transaction := Tran;

      // Verbindung oeffnen und Transaktion starten
      Dbg('Opening connection...');
      Conn.Open;
      Dbg('Connection open.');

      Dbg('Starting transaction...');
      // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
      if not Tran.Active then
        Tran.StartTransaction;

      // Technische Metadaten-Tabelle
      Dbg('Ensuring meta table...');
      Q.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS meta (' + '  key   TEXT PRIMARY KEY,' +
        '  value TEXT' + ');';
      Q.ExecSQL;

      // Schema-Version setzen (fuer spaetere Migrationen)
      Q.SQL.Text := 'INSERT OR REPLACE INTO meta(key, value) VALUES(:k, :v);';
      Q.Params.ParamByName('k').AsString := 'schema_version';
      Q.Params.ParamByName('v').AsString := '6';
      Q.ExecSQL;

      // App-Name (rein informativ)
      Q.SQL.Text := 'INSERT OR REPLACE INTO meta(key, value) VALUES(:k, :v);';
      Q.Params.ParamByName('k').AsString := 'app_name';
      Q.Params.ParamByName('v').AsString := 'Betankungen';
      Q.ExecSQL;

      // v3-Altlast: Startwerte lagen frueher in meta.
      // Ab v4 werden sie in cars persistiert, meta gilt nur noch als Migrationsquelle.
      // Fuer neue DBs legen wir konservative Defaults an (werden spaeter in cars uebernommen).
      if CreatedNow then
      begin
        Q.SQL.Text := 'INSERT OR IGNORE INTO meta(key, value) VALUES("odometer_start_km", "1");';
        Q.ExecSQL;

        Q.SQL.Text := 'INSERT OR IGNORE INTO meta(key, value) VALUES("odometer_start_date", date("now"));';
        Q.ExecSQL;
      end;

      // Erst-Erstellungsdatum nur beim ersten Anlegen
      if CreatedNow then
      begin
        Q.SQL.Text :=
          'INSERT OR IGNORE INTO meta(key, value) ' +
          'VALUES("db_created_at", date("now"));';
        Q.ExecSQL;
      end;

      // Letzte Ausfuehrung immer aktualisieren
      Q.SQL.Text :=
        'INSERT OR REPLACE INTO meta(key, value) ' +
        'VALUES("db_last_run", datetime("now"));';
      Q.ExecSQL;

      // Fach-Tabelle: stations
      Dbg('Ensuring stations table...');
      Q.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS stations (' +
        '  id         INTEGER PRIMARY KEY,' + 
        '  brand      TEXT NOT NULL,' +
        '  street     TEXT NOT NULL,' + 
        '  house_no   TEXT NOT NULL,' +
        '  zip        TEXT NOT NULL,' + 
        '  city       TEXT NOT NULL,' +
        '  phone      TEXT,' + 
        '  owner      TEXT,' +
        '  latitude_e6  INTEGER,' +
        '  longitude_e6 INTEGER,' +
        '  plus_code    TEXT,' +
        '  created_at TEXT NOT NULL DEFAULT (datetime(''now'')),' +
        '  updated_at TEXT,' +
        '  CHECK (latitude_e6 IS NULL OR (latitude_e6 BETWEEN -90000000 AND 90000000)),' +
        '  CHECK (longitude_e6 IS NULL OR (longitude_e6 BETWEEN -180000000 AND 180000000))' +
        ');';
      Q.ExecSQL;

      HasStationLatitudeE6 := ColumnExists('stations', 'latitude_e6');
      HasStationLongitudeE6 := ColumnExists('stations', 'longitude_e6');
      HasStationPlusCode := ColumnExists('stations', 'plus_code');

      if not HasStationLatitudeE6 then
      begin
        Q.SQL.Text := 'ALTER TABLE stations ADD COLUMN latitude_e6 INTEGER;';
        Q.ExecSQL;
      end;

      if not HasStationLongitudeE6 then
      begin
        Q.SQL.Text := 'ALTER TABLE stations ADD COLUMN longitude_e6 INTEGER;';
        Q.ExecSQL;
      end;

      if not HasStationPlusCode then
      begin
        Q.SQL.Text := 'ALTER TABLE stations ADD COLUMN plus_code TEXT;';
        Q.ExecSQL;
      end;

      // Indizes und Unique-Constraint fuer Duplikate (Adresse)
      Dbg('Ensuring stations indexes...');

      Q.SQL.Text :=
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_stations_unique_location ' +
        'ON stations(street, house_no, zip, city);';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_stations_brand ON stations(brand);';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_stations_city ON stations(city);';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_stations_geo_pair ' +
        'ON stations(latitude_e6, longitude_e6);';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_stations_plus_code ON stations(plus_code);';
      Q.ExecSQL;

      MetaOdoStartKm := 1;
      MetaOdoStartDate := FormatDateTime('yyyy"-"mm"-"dd', Date);

      Q.Close;
      Q.SQL.Text := 'SELECT value FROM meta WHERE key = ''odometer_start_km'' LIMIT 1;';
      Q.Open;
      if not Q.EOF then
      begin
        MetaTmp := Trim(Q.FieldByName('value').AsString);
        if not TryStrToInt(MetaTmp, MetaOdoStartKm) then
          MetaOdoStartKm := 1;
      end;
      Q.Close;

      Q.SQL.Text := 'SELECT value FROM meta WHERE key = ''odometer_start_date'' LIMIT 1;';
      Q.Open;
      if not Q.EOF then
      begin
        MetaTmp := Trim(Q.FieldByName('value').AsString);
        if MetaTmp <> '' then
          MetaOdoStartDate := MetaTmp;
      end;
      Q.Close;

      // Fach-Tabelle: cars (v5, Migrationen bleiben ALTER-basiert)
      HasCarsTable := TableExists('cars');
      HasCarPlate := HasCarsTable and ColumnExists('cars', 'plate');
      HasCarNote := HasCarsTable and ColumnExists('cars', 'note');
      HasCarOdometerStartKm := HasCarsTable and ColumnExists('cars', 'odometer_start_km');
      HasCarOdometerStartDate := HasCarsTable and ColumnExists('cars', 'odometer_start_date');

      if not HasCarsTable then
      begin
        Dbg('Ensuring cars table (v5 fresh create)...');
        Q.SQL.Text :=
          'CREATE TABLE IF NOT EXISTS cars (' +
          '  id                  INTEGER PRIMARY KEY,' +
          '  name                TEXT    NOT NULL,' +
          '  plate               TEXT,' +
          '  note                TEXT,' +
          '  vin                 TEXT,' +
          '  reg_doc_path        TEXT,' +
          '  reg_doc_sha256      TEXT,' +
          '  odometer_start_km   INTEGER NOT NULL CHECK (odometer_start_km > 0),' +
          '  odometer_start_date TEXT    NOT NULL,' +
          '  created_at          TEXT    NOT NULL DEFAULT (datetime(''now'')),' +
          '  updated_at          TEXT,' +
          '  UNIQUE(name)' +
          ');';
        Q.ExecSQL;
      end
      else if (not HasCarPlate) or (not HasCarNote) or
              (not HasCarOdometerStartKm) or (not HasCarOdometerStartDate) then
      begin
        Dbg('Migrating cars schema to full v4...');

        Q.SQL.Text := 'DROP TABLE IF EXISTS cars_new;';
        Q.ExecSQL;

        Q.SQL.Text :=
          'CREATE TABLE cars_new (' +
          '  id                  INTEGER PRIMARY KEY,' +
          '  name                TEXT    NOT NULL,' +
          '  plate               TEXT,' +
          '  note                TEXT,' +
          '  odometer_start_km   INTEGER NOT NULL CHECK (odometer_start_km > 0),' +
          '  odometer_start_date TEXT    NOT NULL,' +
          '  created_at          TEXT    NOT NULL DEFAULT (datetime(''now'')),' +
          '  updated_at          TEXT,' +
          '  UNIQUE(name)' +
          ');';
        Q.ExecSQL;

        Q.SQL.Text :=
          'INSERT INTO cars_new (' +
          '  id, name, plate, note, odometer_start_km, odometer_start_date, created_at, updated_at' +
          ') ' +
          'SELECT ' +
          '  id, name, NULL, NULL, :start_km, :start_date, ' +
          '  COALESCE(created_at, datetime(''now'')), updated_at ' +
          'FROM cars;';
        Q.Params.ParamByName('start_km').AsInteger := MetaOdoStartKm;
        Q.Params.ParamByName('start_date').AsString := MetaOdoStartDate;
        Q.ExecSQL;

        Q.SQL.Text := 'DROP TABLE cars;';
        Q.ExecSQL;

        Q.SQL.Text := 'ALTER TABLE cars_new RENAME TO cars;';
        Q.ExecSQL;
      end;

      if not ColumnExists('cars', 'vin') then
      begin
        Q.SQL.Text := 'ALTER TABLE cars ADD COLUMN vin TEXT;';
        Q.ExecSQL;
      end;

      if not ColumnExists('cars', 'reg_doc_path') then
      begin
        Q.SQL.Text := 'ALTER TABLE cars ADD COLUMN reg_doc_path TEXT;';
        Q.ExecSQL;
      end;

      if not ColumnExists('cars', 'reg_doc_sha256') then
      begin
        Q.SQL.Text := 'ALTER TABLE cars ADD COLUMN reg_doc_sha256 TEXT;';
        Q.ExecSQL;
      end;

      Q.SQL.Text :=
        'INSERT OR IGNORE INTO cars(' +
        '  id, name, odometer_start_km, odometer_start_date' +
        ') VALUES(' +
        '  1, ''Hauptauto'', :start_km, :start_date' +
        ');';
      Q.Params.ParamByName('start_km').AsInteger := MetaOdoStartKm;
      Q.Params.ParamByName('start_date').AsString := MetaOdoStartDate;
      Q.ExecSQL;

      // Startwerte duerfen vor dem ersten Fuelup noch korrigiert werden,
      // bleiben danach aber auch auf DB-Ebene gesperrt.
      Dbg('Ensuring cars start-value lock triggers...');
      Q.SQL.Text := 'DROP TRIGGER IF EXISTS trg_cars_immutable_start_km;';
      Q.ExecSQL;
      Q.SQL.Text := 'DROP TRIGGER IF EXISTS trg_cars_immutable_start_date;';
      Q.ExecSQL;
      Q.SQL.Text := 'DROP TRIGGER IF EXISTS trg_cars_lock_start_km_after_fuelups;';
      Q.ExecSQL;
      Q.SQL.Text := 'DROP TRIGGER IF EXISTS trg_cars_lock_start_date_after_fuelups;';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE TRIGGER IF NOT EXISTS trg_cars_lock_start_km_after_fuelups ' +
        'BEFORE UPDATE OF odometer_start_km ON cars ' +
        'FOR EACH ROW ' +
        'WHEN NEW.odometer_start_km <> OLD.odometer_start_km ' +
        ' AND EXISTS(SELECT 1 FROM fuelups WHERE car_id = OLD.id LIMIT 1) ' +
        'BEGIN ' +
        '  SELECT RAISE(ABORT, ''P-071: odometer_start_km locked after first fuelup''); ' +
        'END;';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE TRIGGER IF NOT EXISTS trg_cars_lock_start_date_after_fuelups ' +
        'BEFORE UPDATE OF odometer_start_date ON cars ' +
        'FOR EACH ROW ' +
        'WHEN NEW.odometer_start_date <> OLD.odometer_start_date ' +
        ' AND EXISTS(SELECT 1 FROM fuelups WHERE car_id = OLD.id LIMIT 1) ' +
        'BEGIN ' +
        '  SELECT RAISE(ABORT, ''P-071: odometer_start_date locked after first fuelup''); ' +
        'END;';
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Text := 'SELECT id FROM cars ORDER BY id LIMIT 1;';
      Q.Open;
      if not Q.EOF then
        DefaultCarId := Q.FieldByName('id').AsInteger
      else
        DefaultCarId := 1;
      Q.Close;

      // Fach-Tabelle: fuelups (v4 inkl. Migration von v3)
      HasFuelupsTable := TableExists('fuelups');
      HasCarId := HasFuelupsTable and ColumnExists('fuelups', 'car_id');
      HasMissedPrevious := HasFuelupsTable and ColumnExists('fuelups', 'missed_previous');
      HasReceiptLink := HasFuelupsTable and ColumnExists('fuelups', 'receipt_link');

      if not HasFuelupsTable then
      begin
        Dbg('Ensuring fuelups table (v4 fresh create)...');
        Q.SQL.Text :=
          'CREATE TABLE IF NOT EXISTS fuelups (' +
          '  id         INTEGER PRIMARY KEY,' +
          '  station_id                  INTEGER NOT NULL,' +
          '  car_id                      INTEGER NOT NULL,' +
          '  fueled_at                   TEXT    NOT NULL,' +
          '  odometer_km                 INTEGER NOT NULL,' +
          '  liters_ml                   INTEGER NOT NULL,' +
          '  total_cents                 INTEGER NOT NULL,' +
          '  price_per_liter_milli_eur   INTEGER NOT NULL,' +
          '  is_full_tank                INTEGER NOT NULL DEFAULT 0,' +
          '  missed_previous             INTEGER NOT NULL DEFAULT 0,' +
          '  fuel_type                   TEXT,' +
          '  payment_type                TEXT,' +
          '  pump_no                     TEXT,' +
          '  note                        TEXT,' +
          '  receipt_link                TEXT,' +
          '  created_at                  TEXT NOT NULL DEFAULT (datetime(''now'')),' +
          '  updated_at                  TEXT,' +
          '  FOREIGN KEY(station_id) REFERENCES stations(id) ON DELETE RESTRICT,' +
          '  FOREIGN KEY(car_id)     REFERENCES cars(id)     ON DELETE RESTRICT,' +
          '  CHECK (odometer_km > 0),' +
          '  CHECK (liters_ml > 0),' +
          '  CHECK (total_cents >= 0),' +
          '  CHECK (price_per_liter_milli_eur >= 0),' +
          '  CHECK (is_full_tank IN (0,1)),' +
          '  CHECK (missed_previous IN (0,1))' +
          ');';
        Q.ExecSQL;
      end
      else if (not HasCarId) or (not HasMissedPrevious) then
      begin
        Dbg('Migrating fuelups schema: v3 -> v4');

        Q.SQL.Text := 'DROP TRIGGER IF EXISTS trg_fuelups_set_updated_at;';
        Q.ExecSQL;

        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_station_id;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_fueled_at;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_odometer_km;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_car_fueled_at;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_car_odometer_km;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_unique;';
        Q.ExecSQL;

        Q.SQL.Text := 'DROP TABLE IF EXISTS fuelups_new;';
        Q.ExecSQL;

        Q.SQL.Text :=
          'CREATE TABLE fuelups_new (' +
          '  id         INTEGER PRIMARY KEY,' +
          '  station_id                  INTEGER NOT NULL,' +
          '  car_id                      INTEGER NOT NULL,' +
          '  fueled_at                   TEXT    NOT NULL,' +
          '  odometer_km                 INTEGER NOT NULL,' +
          '  liters_ml                   INTEGER NOT NULL,' +
          '  total_cents                 INTEGER NOT NULL,' +
          '  price_per_liter_milli_eur   INTEGER NOT NULL,' +
          '  is_full_tank                INTEGER NOT NULL DEFAULT 0,' +
          '  missed_previous             INTEGER NOT NULL DEFAULT 0,' +
          '  fuel_type                   TEXT,' +
          '  payment_type                TEXT,' +
          '  pump_no                     TEXT,' +
          '  note                        TEXT,' +
          '  receipt_link                TEXT,' +
          '  created_at                  TEXT NOT NULL DEFAULT (datetime(''now'')),' +
          '  updated_at                  TEXT,' +
          '  FOREIGN KEY(station_id) REFERENCES stations(id) ON DELETE RESTRICT,' +
          '  FOREIGN KEY(car_id)     REFERENCES cars(id)     ON DELETE RESTRICT,' +
          '  CHECK (odometer_km > 0),' +
          '  CHECK (liters_ml > 0),' +
          '  CHECK (total_cents >= 0),' +
          '  CHECK (price_per_liter_milli_eur >= 0),' +
          '  CHECK (is_full_tank IN (0,1)),' +
          '  CHECK (missed_previous IN (0,1))' +
          ');';
        Q.ExecSQL;

        if HasCarId then
          CarIdExpr := 'car_id'
        else
          CarIdExpr := ':car_id';

        if HasMissedPrevious then
          MissedPreviousExpr := 'missed_previous'
        else
          MissedPreviousExpr := '0';

        if HasReceiptLink then
          ReceiptLinkExpr := 'receipt_link'
        else
          ReceiptLinkExpr := 'NULL';

        Q.SQL.Text :=
          'INSERT INTO fuelups_new (' +
          '  id, station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents,' +
          '  price_per_liter_milli_eur, is_full_tank, missed_previous, fuel_type, payment_type,' +
          '  pump_no, note, receipt_link, created_at, updated_at' +
          ') ' +
          'SELECT ' +
          '  id, station_id, ' + CarIdExpr + ', fueled_at, odometer_km, liters_ml, total_cents,' +
          '  price_per_liter_milli_eur, is_full_tank, ' + MissedPreviousExpr + ', fuel_type, payment_type,' +
          '  pump_no, note, ' + ReceiptLinkExpr + ', created_at, updated_at ' +
          'FROM fuelups;';
        if not HasCarId then
          Q.Params.ParamByName('car_id').AsInteger := DefaultCarId;
        Q.ExecSQL;

        Q.SQL.Text := 'DROP TABLE fuelups;';
        Q.ExecSQL;

        Q.SQL.Text := 'ALTER TABLE fuelups_new RENAME TO fuelups;';
        Q.ExecSQL;
      end;

      if not ColumnExists('fuelups', 'receipt_link') then
      begin
        Q.SQL.Text := 'ALTER TABLE fuelups ADD COLUMN receipt_link TEXT;';
        Q.ExecSQL;
      end;

      // Indizes fuer typische Abfragen
      Dbg('Ensuring fuelups indexes...');
      
      Q.SQL.Text := 
        'CREATE INDEX IF NOT EXISTS idx_fuelups_station_id ON fuelups(station_id);';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_fuelups_car_fueled_at ON fuelups(car_id, fueled_at);';
      Q.ExecSQL;

      Q.SQL.Text := 
        'CREATE INDEX IF NOT EXISTS idx_fuelups_car_odometer_km ON fuelups(car_id, odometer_km);';
      Q.ExecSQL;

      // Duplikat-Schutz (pro Auto + Station + Zeit + Kilometerstand)
      Q.SQL.Text := 
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_fuelups_unique ' +
        'ON fuelups(car_id, station_id, fueled_at, odometer_km);';
      Q.ExecSQL;

      // Trigger fuer automatisches updated_at
      Dbg('Ensuring fuelups triggers...');
      Q.SQL.Text := 
        'CREATE TRIGGER IF NOT EXISTS trg_fuelups_set_updated_at ' +
        'AFTER UPDATE ON fuelups ' +
        'FOR EACH ROW ' +
        'WHEN NEW.updated_at IS OLD.updated_at OR NEW.updated_at IS NULL ' +
        'BEGIN ' +
        '  UPDATE fuelups ' +
        '  SET updated_at = datetime(''now'') ' + 
        '  WHERE id = NEW.id; ' +
        'END; ';
      Q.ExecSQL;

      // Schema-Version final absichern (nach evtl. Migration)
      Q.SQL.Text := 'INSERT OR REPLACE INTO meta(key, value) VALUES(:k, :v);';
      Q.Params.ParamByName('k').AsString := 'schema_version';
      Q.Params.ParamByName('v').AsString := '6';
      Q.ExecSQL;

      // Transaktion abschliessen
      Dbg('Commit...');
      Tran.Commit;
      Dbg('Commit: OK');

      Result := CreatedNow;

    except
      on E: Exception do
      begin
        Dbg('Error: ' + E.Message);
        if Assigned(Tran) and Tran.Active then
        begin
          Dbg('Rollback...');
          Tran.Rollback;
        end;
        raise Exception.Create('DB-Init fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

// ----------------
// Liest einen Wert aus der meta-Tabelle (technische Key-Value Metadaten).
function ReadMetaValue(const DbPath, AKey: string): string;
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
begin
  Result := '';

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);

  try
    try
      Conn.DatabaseName := DbPath;
      Conn.Transaction := Tran;
      Q.DataBase := Conn;
      Q.Transaction := Tran;

      Conn.Open;
      // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
      if not Tran.Active then
        Tran.StartTransaction;

      Q.SQL.Text := 'SELECT value FROM meta WHERE key = :k;';
      Q.Params.ParamByName('k').AsString := AKey;
      Q.Open;

      if not Q.EOF then
        Result := Q.Fields[0].AsString;

      Q.Close;
      Tran.Commit;

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;
        raise Exception.Create('ReadMetaValue fehlgeschlagen (' +
          AKey + '): ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

end.
