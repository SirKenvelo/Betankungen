{
  u_stations.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Fachmodul fuer Stammdatenverwaltung von Tankstellen (stations).

  Verantwortlichkeiten:
  - Implementiert Add/List/Edit/Delete fuer stations.
  - Bietet kompakte und detaillierte Listendarstellung.
  - Sichert Adress-Eindeutigkeit ueber DB-Constraints + Fehlermapping.

  Design-Entscheidungen:
  - Atomare Schreiboperationen per Transaktion.
  - Konsistentes CLI-Layout via feste Spaltenbreiten.
  - Defensive Eingabepruefung vor DB-Schreibvorgaengen.

  Hinweis:
  - Jede Betankung referenziert stations; diese Unit ist daher
    zentrale Stammdatenbasis fuer u_fuelups.
  ---------------------------------------------------------------------------
}
unit u_stations;

{$mode objfpc}{$H+}

interface

// ----------------
// Oeffentliche Schnittstelle
// Listet alle Tankstellen (optional als Detail-Tabelle)
procedure ListStations(const DbPath: string; Detailed: boolean);

// Fuegt interaktiv eine neue Tankstelle hinzu
procedure AddStationInteractive(const DbPath: string);

// Loescht eine Tankstelle nach expliziter Bestaetigung
procedure DeleteStationInteractive(const DbPath: string);

// Bearbeitet eine bestehende Tankstelle interaktiv
procedure EditStationInteractive(const DbPath: string);

implementation

uses
  SysUtils, Classes, SQLite3Conn, SQLDB, u_fmt, u_db_common, u_log;

const
  // ----------------
  // Spaltenlayout
  // Spaltenbreiten fuer Detail-Tabelle (anpassbar)
  COL_ID = 4;
  COL_BRAND = 12;
  COL_STREET = 22;
  COL_HNO = 6;
  COL_ZIP = 6;
  COL_CITY = 16;
  COL_PHONE = 14;
  COL_OWNER = 16;

procedure PrintSep;
begin
  // Optik wie Debug-Rahmen (C_CYAN/C_RESET kommen aus u_fmt)
  WriteLn(C_CYAN + '+' + StringOfChar('-', COL_ID + 2) + '+' +
    StringOfChar('-', COL_BRAND + 2) + '+' + StringOfChar('-', COL_STREET + 2) +
    '+' + StringOfChar('-', COL_HNO + 2) + '+' + StringOfChar('-', COL_ZIP + 2) +
    '+' + StringOfChar('-', COL_CITY + 2) + '+' + StringOfChar('-', COL_PHONE + 2) +
    '+' + StringOfChar('-', COL_OWNER + 2) + '+' + C_RESET);
end;

procedure PrintRow(const AId, ABrand, AStreet, AHouseNo, AZip, ACity,
  APhone, AOwner: string);
begin
  WriteLn(Format('| %-*s | %-*s | %-*s | %-*s | %-*s | %-*s | %-*s | %-*s |',
    [COL_ID, AId, COL_BRAND, ABrand, COL_STREET, AStreet, COL_HNO,
    AHouseNo, COL_ZIP, AZip, COL_CITY, ACity, COL_PHONE, APhone, COL_OWNER, AOwner]));
end;

function StationLine(const Brand, Street, HouseNo, Zip, City: string): string;
begin
  Result := Format('%s (%s %s, %s %s)', [Brand, Street, HouseNo, Zip, City]);
end;

procedure ListStations(const DbPath: string; Detailed: boolean);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  SId, SBrand, SStreet, SHouseNo, SZip, SCity, SPhone, SOwner: string;
  RowCount: integer;
begin
  Dbg('ListStations: detailed=' + BoolToStr(Detailed, True));
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

      Q.SQL.Text :=
        'SELECT id, brand, street, house_no, zip, city, phone, owner ' +
        'FROM stations ' + 'ORDER BY brand, city, street, house_no;';
      Q.Open;

      if Q.EOF then
      begin
        WriteLn('Keine Tankstellen vorhanden.');
        Q.Close;
        Tran.Commit;
        Exit;
      end;

      if Detailed then
      begin
        PrintSep;
        PrintRow('id', 'brand', 'street', 'nr', 'zip', 'city', 'phone', 'owner');
        PrintSep;
      end;

      RowCount := 0;
      while not Q.EOF do
      begin
        Inc(RowCount);
        SId := Q.FieldByName('id').AsString;
        SBrand := Q.FieldByName('brand').AsString;
        SStreet := Q.FieldByName('street').AsString;
        SHouseNo := Q.FieldByName('house_no').AsString;
        SZip := Q.FieldByName('zip').AsString;
        SCity := Q.FieldByName('city').AsString;
        SPhone := Q.FieldByName('phone').AsString;
        SOwner := Q.FieldByName('owner').AsString;

        if Detailed then
          PrintRow(SId, SBrand, SStreet, SHouseNo, SZip, SCity, SPhone, SOwner)
        else
          WriteLn(StationLine(SBrand, SStreet, SHouseNo, SZip, SCity));

        Q.Next;
      end;

      if Detailed then
        PrintSep;

      Dbg('ListStations: rows=' + IntToStr(RowCount));
      Q.Close;
      Tran.Commit;

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;
        raise Exception.Create('ListStations fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

procedure AddStationInteractive(const DbPath: string);
var
  Brand, Street, HouseNo, Zip, City, Phone, Owner: string;
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
begin
  WriteLn('Tankstelle hinzufügen');
  WriteLn('---------------------');

  Brand := AskRequired('Brand: ');
  Street := AskRequired('Street: ');
  HouseNo := AskRequired('HouseNo: ');
  Zip := AskRequired('Plz: ');
  City := AskRequired('City: ');
  Phone := AskOptional('Phone (Optional): ');
  Owner := AskOptional('Owner (Optional): ');

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

      Q.SQL.Text :=
        'INSERT INTO stations(brand, street, house_no, zip, city, phone, owner) ' +
        'VALUES(:brand, :street, :house_no, :zip, :city, :phone, :owner);';

      Q.Params.ParamByName('brand').AsString := Brand;
      Q.Params.ParamByName('street').AsString := Street;
      Q.Params.ParamByName('house_no').AsString := HouseNo;
      Q.Params.ParamByName('zip').AsString := Zip;
      Q.Params.ParamByName('city').AsString := City;
      Q.Params.ParamByName('phone').AsString := Phone;
      Q.Params.ParamByName('owner').AsString := Owner;

      Dbg('AddStation: brand=' + Brand + ' city=' + City);
      Q.ExecSQL;
      Tran.Commit;

      WriteLn('OK: Tankstelle - ' + C_YELLOW + StationLine(Brand,
        Street, HouseNo, Zip, City) + C_RESET + ' - gespeichert.');

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;

        // UNIQUE-Constraint freundlich abfangen (Adresse schon vorhanden)
        if Pos('UNIQUE', UpperCase(E.Message)) > 0 then
          raise Exception.Create(
            'Diese Tankstelle existiert bereits (Adresse ist schon gespeichert).')
        else
          raise Exception.Create('AddStation fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

procedure DeleteStationInteractive(const DbPath: string);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;

  IdStr: string;
  Id: integer;
  Confirm: string;

  Brand, Street, HouseNo, Zip, City: string;
begin
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

      // Liste anzeigen (nur id und Anzeigezeile)
      Q.SQL.Text :=
        'SELECT id, brand, street, house_no, zip, city ' + 'FROM stations ' +
        'ORDER BY brand, city, street, house_no;';
      Q.Open;

      if Q.EOF then
      begin
        WriteLn('Keine Tankstellen vorhanden.');
        Q.Close;
        Tran.Commit;
        Exit;
      end;

      WriteLn('Tankstellen (ID):');
      while not Q.EOF do
      begin
        Brand := Q.FieldByName('brand').AsString;
        Street := Q.FieldByName('street').AsString;
        HouseNo := Q.FieldByName('house_no').AsString;
        Zip := Q.FieldByName('zip').AsString;
        City := Q.FieldByName('city').AsString;

        WriteLn(Q.FieldByName('id').AsString, ': ',
          StationLine(Brand, Street, HouseNo, Zip, City));
        Q.Next;
      end;
      Q.Close;

      // ID abfragen
      WriteLn;
      Write('ID (oder q): ');
      ReadLn(IdStr);
      IdStr := Trim(LowerCase(IdStr));

      if (IdStr = 'q') then
      begin
        WriteLn('Abgebrochen.');
        Tran.Commit;
        Exit;
      end;

      if not TryStrToInt(IdStr, Id) then
      begin
        Tran.Rollback;
        raise Exception.Create('Ungültige ID. Bitte eine Zahl oder q eingeben.');
      end;

      // Station zur ID laden (damit wir bestaetigen koennen)
      Q.SQL.Text :=
        'SELECT brand, street, house_no, zip, city ' +
        'FROM stations WHERE id = :id;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Q.Open;

      if Q.EOF then
      begin
        Q.Close;
        Tran.Commit;
        WriteLn('Keine Tankstelle mit dieser ID gefunden.');
        Exit;
      end;

      Brand := Q.FieldByName('brand').AsString;
      Street := Q.FieldByName('street').AsString;
      HouseNo := Q.FieldByName('house_no').AsString;
      Zip := Q.FieldByName('zip').AsString;
      City := Q.FieldByName('city').AsString;
      Q.Close;

      WriteLn('Ausgewählt: ', StationLine(Brand, Street, HouseNo, Zip, City));
      Write('Sicher löschen (y/n)? ');
      ReadLn(Confirm);
      Confirm := Trim(LowerCase(Confirm));

      if (Confirm <> 'y') and (Confirm <> 'yes') then
      begin
        WriteLn('Abgebrochen.');
        Tran.Commit;
        Exit;
      end;

      // Loeschen
      Q.SQL.Text := 'DELETE FROM stations WHERE id = :id;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Dbg('DeleteStation: id=' + IntToStr(Id));
      Q.ExecSQL;

      if Q.RowsAffected = 0 then
      begin
        Tran.Rollback;
        raise Exception.Create('Löschen fehlgeschlagen (keine Zeile betroffen).');
      end;

      Tran.Commit;
      WriteLn('OK: Tankstelle gelöscht.');

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;
        raise Exception.Create('DeleteStation fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

// Helfer: Anzeige fuer Aenderungen
function ReplaceLine(const Brand, Street, HouseNo, Zip, City, Phone,
  Owner: string): string;
begin
  Result := Format('%s (%s %s, %s %s %s %s)', [Brand, Street, HouseNo,
    Zip, City, Phone, Owner]);
end;

procedure EditStationInteractive(const DbPath: string);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;

  IdStr: string;
  Id: integer;
  Confirm: string;

  TmpBrand, TmpStreet, TmpHouseNo, TmpZip, TmpCity, TmpPhone, TmpOwner: string;
  OldBrand, OldStreet, OldHouseNo, OldZip, OldCity, OldPhone, OldOwner: string;
  NewBrand, NewStreet, NewHouseNo, NewZip, NewCity, NewPhone, NewOwner: string;
begin
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

      // Liste anzeigen (nur id und Anzeigezeile)
      Q.SQL.Text :=
        'SELECT id, brand, street, house_no, zip, city, phone, owner ' +
        'FROM stations ' +
        'ORDER BY brand, city, street, house_no, phone, owner;';
      Q.Open;

      if Q.EOF then
      begin
        WriteLn('Keine Tankstellen vorhanden.');
        Q.Close;
        Tran.Commit;
        Exit;
      end;

      WriteLn('Tankstellen (ID):');
      while not Q.EOF do
      begin
        TmpBrand := Q.FieldByName('brand').AsString;
        TmpStreet := Q.FieldByName('street').AsString;
        TmpHouseNo := Q.FieldByName('house_no').AsString;
        TmpZip := Q.FieldByName('zip').AsString;
        TmpCity := Q.FieldByName('city').AsString;
        TmpPhone := Q.FieldByName('phone').AsString;
        TmpOwner := Q.FieldByName('owner').AsString;

        WriteLn(Q.FieldByName('id').AsString, ': ',
          ReplaceLine(TmpBrand, TmpStreet, TmpHouseNo, TmpZip, TmpCity,
          TmpPhone, TmpOwner));
        Q.Next;
      end;

      Q.Close;

      // ID abfragen
      WriteLn;
      Write('ID (oder q): ');
      ReadLn(IdStr);
      IdStr := Trim(LowerCase(IdStr));

      if (IdStr = 'q') then
      begin
        WriteLn('Abgebrochen.');
        Tran.Commit;
        Exit;
      end;

      if not TryStrToInt(IdStr, Id) then
      begin
        Tran.Rollback;
        raise Exception.Create('Ungültige ID. Bitte eine Zahl oder q eingeben.');
      end;

      // Station zur ID laden
      Q.SQL.Text :=
        'SELECT brand, street, house_no, zip, city, phone, owner ' +
        'FROM stations WHERE id = :id;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Q.Open;

      if Q.EOF then
      begin
        Q.Close;
        Tran.Commit;
        WriteLn('Keine Tankstelle mit dieser ID gefunden.');
        Exit;
      end;

      // Auswahl speichern
      OldBrand := Q.FieldByName('brand').AsString;
      OldStreet := Q.FieldByName('street').AsString;
      OldHouseNo := Q.FieldByName('house_no').AsString;
      OldZip := Q.FieldByName('zip').AsString;
      OldCity := Q.FieldByName('city').AsString;
      OldPhone := Q.FieldByName('phone').AsString;
      OldOwner := Q.FieldByName('owner').AsString;

      // Aenderungen abfragen und eintragen
      NewBrand := AskKeep('Brand*: (ENTER=behalten)', Q.FieldByName('brand').AsString);
      NewStreet := AskKeep('Street*: (ENTER=behalten)',
        Q.FieldByName('street').AsString);
      NewHouseNo := AskKeep('HouseNo*: (ENTER=behalten)',
        Q.FieldByName('house_no').AsString);
      NewZip := AskKeep('Zip*: (ENTER=behalten)', Q.FieldByName('zip').AsString);
      NewCity := AskKeep('City*: (ENTER=behalten)', Q.FieldByName('city').AsString);
      NewPhone := AskKeep('Phone: (ENTER=behalten)', Q.FieldByName('phone').AsString);
      NewOwner := AskKeep('Owner: (ENTER=behalten)', Q.FieldByName('owner').AsString);

      // Sicherheitspruefung: Pflichtfeld leer?
      EnsureNotEmpty('brand', NewBrand);
      EnsureNotEmpty('street', NewStreet);
      EnsureNotEmpty('house_no', NewHouseNo);
      EnsureNotEmpty('zip', NewZip);
      EnsureNotEmpty('city', NewCity);
      Q.Close;

      WriteLn('Ausgewählt: ', ReplaceLine(OldBrand, OldStreet, OldHouseNo,
        OldZip, OldCity, OldPhone, OldOwner));
      Writeln('Ändern in: ', ReplaceLine(NewBrand, NewStreet,
        NewHouseNo, NewZip, NewCity, NewPhone, NewOwner));
      Write('Sicher ändern (y/n)? ');
      ReadLn(Confirm);
      Confirm := Trim(LowerCase(Confirm));

      if (Confirm <> 'y') and (Confirm <> 'yes') then
      begin
        WriteLn('Abgebrochen.');
        Tran.Commit;
        Exit;
      end;

      // Aendern
      Q.SQL.Text :=
        'UPDATE stations ' +
        'SET brand=:brand, street=:street, house_no=:house_no, zip=:zip, city=:city, ' +
        'phone=:phone, owner=:owner ' + 'WHERE id = :id;';

      // Parameter zuweisen
      Q.Params.ParamByName('brand').AsString := NewBrand;
      Q.Params.ParamByName('street').AsString := NewStreet;
      Q.Params.ParamByName('house_no').AsString := NewHouseNo;
      Q.Params.ParamByName('zip').AsString := NewZip;
      Q.Params.ParamByName('city').AsString := NewCity;
      Q.Params.ParamByName('phone').AsString := NewPhone;
      Q.Params.ParamByName('owner').AsString := NewOwner;
      Q.Params.ParamByName('id').AsInteger := Id;
      Dbg('EditStation: id=' + IntToStr(Id));
      Q.ExecSQL;

      if Q.RowsAffected = 0 then
      begin
        Tran.Rollback;
        raise Exception.Create('Änderung fehlgeschlagen (keine Zeile betroffen).');
      end;

      Tran.Commit;
      WriteLn('OK: Änderungen vorgenommen.');

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;
        raise Exception.Create('Edit fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

end.
