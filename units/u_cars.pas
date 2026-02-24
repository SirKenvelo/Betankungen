{
  u_cars.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-02-24
  UPDATED: 2026-02-24
  AUTHOR : Christof Kempinski
  Domain-Unit fuer DB-basiertes CRUD auf der Tabelle `cars`.

  Verantwortlichkeiten:
  - Fuegt Fahrzeuge hinzu und liefert die neue ID zurueck.
  - Listet Fahrzeuge als strukturierte Datensaetze.
  - Bearbeitet Fahrzeug-Stammdaten (name/plate/note).
  - Loescht Fahrzeuge (mit Schutz vor bestehenden fuelups-Referenzen).
  - Liefert Pruef-Helfer fuer Existenz und fuelup-Referenzen.

  Design:
  - Keine CLI-Abhaengigkeit.
  - Keine direkte Konsolenausgabe.
  - Eindeutige Returncodes (Integer/Boolean), DB-Fehler als Exceptions.
  ---------------------------------------------------------------------------
}
unit u_cars;

{$mode objfpc}{$H+}

interface

type
  TCar = record
    Id: Integer;
    Name: string;
    Plate: string;
    Note: string;
    OdometerStartKm: Integer;
    OdometerStartDate: string;
    CreatedAt: string;
    UpdatedAt: string;
  end;

  TCarsArray = array of TCar;

function CarsAdd(
  const DbPath: string;
  const Name, Plate, Note: string;
  const OdometerStartKm: Integer;
  const OdometerStartDate: string
): Integer;

function CarsList(const DbPath: string): TCarsArray;

function CarsEdit(
  const DbPath: string;
  const Id: Integer;
  const Name, Plate, Note: string
): Boolean;

function CarsDelete(const DbPath: string; const Id: Integer): Boolean;

function CarsExists(const DbPath: string; const Id: Integer): Boolean;
function CarsHasFuelups(const DbPath: string; const Id: Integer): Boolean;

implementation

uses
  SysUtils, SQLite3Conn, SQLDB;

procedure PrepareDb(
  const DbPath: string;
  const ForWrite: Boolean;
  out Conn: TSQLite3Connection;
  out Tran: TSQLTransaction;
  out Q: TSQLQuery
);
begin
  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);

  Conn.DatabaseName := DbPath;
  Conn.Transaction := Tran;
  Q.DataBase := Conn;
  Q.Transaction := Tran;

  Conn.Open;
  if ForWrite then
  begin
    if not Tran.Active then
      Tran.StartTransaction;
    Q.SQL.Text := 'PRAGMA foreign_keys = ON;';
    Q.ExecSQL;
  end;
end;

procedure FinishDb(
  var Conn: TSQLite3Connection;
  var Tran: TSQLTransaction;
  var Q: TSQLQuery
);
begin
  Q.Free;
  Tran.Free;
  Conn.Free;
end;

function CarsAdd(
  const DbPath: string;
  const Name, Plate, Note: string;
  const OdometerStartKm: Integer;
  const OdometerStartDate: string
): Integer;
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
begin
  if Trim(Name) = '' then
    raise Exception.Create('CarsAdd: name darf nicht leer sein.');
  if OdometerStartKm <= 0 then
    raise Exception.Create('CarsAdd: odometer_start_km muss > 0 sein.');
  if Trim(OdometerStartDate) = '' then
    raise Exception.Create('CarsAdd: odometer_start_date darf nicht leer sein.');

  Result := 0;
  PrepareDb(DbPath, True, Conn, Tran, Q);
  try
    try
      Q.SQL.Text :=
        'INSERT INTO cars(name, plate, note, odometer_start_km, odometer_start_date) ' +
        'VALUES(:name, :plate, :note, :odometer_start_km, :odometer_start_date);';
      Q.Params.ParamByName('name').AsString := Trim(Name);
      Q.Params.ParamByName('plate').AsString := Trim(Plate);
      Q.Params.ParamByName('note').AsString := Trim(Note);
      Q.Params.ParamByName('odometer_start_km').AsInteger := OdometerStartKm;
      Q.Params.ParamByName('odometer_start_date').AsString := Trim(OdometerStartDate);
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Text := 'SELECT last_insert_rowid() AS id;';
      Q.Open;
      if Q.EOF then
        raise Exception.Create('CarsAdd: neue ID konnte nicht ermittelt werden.');
      Result := Q.FieldByName('id').AsInteger;
      Q.Close;

      Tran.Commit;
    except
      on E: Exception do
      begin
        if Tran.Active then
          Tran.Rollback;

        if Pos('UNIQUE', UpperCase(E.Message)) > 0 then
          raise Exception.Create('CarsAdd: UNIQUE constraint verletzt.')
        else
          raise Exception.Create('CarsAdd fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    FinishDb(Conn, Tran, Q);
  end;
end;

function CarsList(const DbPath: string): TCarsArray;
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  N: Integer;
  Cars: TCarsArray;
begin
  Result := nil;
  SetLength(Cars, 0);
  PrepareDb(DbPath, False, Conn, Tran, Q);
  try
    try
      Q.SQL.Text :=
        'SELECT id, name, plate, note, odometer_start_km, odometer_start_date, created_at, updated_at ' +
        'FROM cars ' +
        'ORDER BY id;';
      Q.Open;

      N := 0;
      while not Q.EOF do
      begin
        SetLength(Cars, N + 1);
        Cars[N].Id := Q.FieldByName('id').AsInteger;
        Cars[N].Name := Q.FieldByName('name').AsString;
        Cars[N].Plate := Q.FieldByName('plate').AsString;
        Cars[N].Note := Q.FieldByName('note').AsString;
        Cars[N].OdometerStartKm := Q.FieldByName('odometer_start_km').AsInteger;
        Cars[N].OdometerStartDate := Q.FieldByName('odometer_start_date').AsString;
        Cars[N].CreatedAt := Q.FieldByName('created_at').AsString;
        Cars[N].UpdatedAt := Q.FieldByName('updated_at').AsString;
        Inc(N);
        Q.Next;
      end;

      Q.Close;
      Result := Cars;
    except
      on E: Exception do
      begin
        raise Exception.Create('CarsList fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    if Tran.Active then
      Tran.Rollback;
    FinishDb(Conn, Tran, Q);
  end;
end;

function CarsEdit(
  const DbPath: string;
  const Id: Integer;
  const Name, Plate, Note: string
): Boolean;
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
begin
  if Id <= 0 then
    raise Exception.Create('CarsEdit: id muss > 0 sein.');
  if Trim(Name) = '' then
    raise Exception.Create('CarsEdit: name darf nicht leer sein.');

  Result := False;
  PrepareDb(DbPath, True, Conn, Tran, Q);
  try
    try
      Q.SQL.Text :=
        'UPDATE cars ' +
        'SET name = :name, plate = :plate, note = :note, updated_at = datetime(''now'') ' +
        'WHERE id = :id;';
      Q.Params.ParamByName('name').AsString := Trim(Name);
      Q.Params.ParamByName('plate').AsString := Trim(Plate);
      Q.Params.ParamByName('note').AsString := Trim(Note);
      Q.Params.ParamByName('id').AsInteger := Id;
      Q.ExecSQL;

      Result := Q.RowsAffected > 0;
      Tran.Commit;
    except
      on E: Exception do
      begin
        if Tran.Active then
          Tran.Rollback;

        if Pos('UNIQUE', UpperCase(E.Message)) > 0 then
          raise Exception.Create('CarsEdit: UNIQUE constraint verletzt.')
        else
          raise Exception.Create('CarsEdit fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    FinishDb(Conn, Tran, Q);
  end;
end;

function CarsDelete(const DbPath: string; const Id: Integer): Boolean;
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
begin
  if Id <= 0 then
    raise Exception.Create('CarsDelete: id muss > 0 sein.');

  Result := False;
  PrepareDb(DbPath, True, Conn, Tran, Q);
  try
    try
      Q.Close;
      Q.SQL.Text := 'SELECT 1 FROM fuelups WHERE car_id = :id LIMIT 1;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Q.Open;
      if not Q.EOF then
        raise Exception.Create('CarsDelete: Fahrzeug hat verknuepfte fuelups.');
      Q.Close;

      Q.SQL.Text := 'DELETE FROM cars WHERE id = :id;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Q.ExecSQL;

      Result := Q.RowsAffected > 0;
      Tran.Commit;
    except
      on E: Exception do
      begin
        if Tran.Active then
          Tran.Rollback;
        raise Exception.Create('CarsDelete fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    FinishDb(Conn, Tran, Q);
  end;
end;

function CarsExists(const DbPath: string; const Id: Integer): Boolean;
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
begin
  if Id <= 0 then
    Exit(False);

  Result := False;
  PrepareDb(DbPath, False, Conn, Tran, Q);
  try
    try
      Q.SQL.Text := 'SELECT 1 FROM cars WHERE id = :id LIMIT 1;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Q.Open;
      Result := not Q.EOF;
      Q.Close;
    except
      on E: Exception do
      begin
        raise Exception.Create('CarsExists fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    if Tran.Active then
      Tran.Rollback;
    FinishDb(Conn, Tran, Q);
  end;
end;

function CarsHasFuelups(const DbPath: string; const Id: Integer): Boolean;
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
begin
  if Id <= 0 then
    Exit(False);

  Result := False;
  PrepareDb(DbPath, False, Conn, Tran, Q);
  try
    try
      Q.SQL.Text := 'SELECT 1 FROM fuelups WHERE car_id = :id LIMIT 1;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Q.Open;
      Result := not Q.EOF;
      Q.Close;
    except
      on E: Exception do
      begin
        raise Exception.Create('CarsHasFuelups fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    if Tran.Active then
      Tran.Rollback;
    FinishDb(Conn, Tran, Q);
  end;
end;

end.
