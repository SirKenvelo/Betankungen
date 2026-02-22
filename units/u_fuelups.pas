{
  u_fuelups.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-22
  AUTHOR : Christof Kempinski
  Fachmodul fuer Erfassung und Auflistung von Betankungsvorgaengen.

  Verantwortlichkeiten:
  - Fuehrt den interaktiven Add-Flow fuer fuelups aus.
  - Listet fuelups in Standard- oder Detailansicht.
  - Validiert Odometer-/Lueckenlogik und Pflichtfelder vor Persistenz.

  Design-Prinzipien:
  - Datentransfer: `TFuelupInput` entkoppelt Dialogdaten von SQL-Schreibvorgaengen.
  - Praezision: Werte werden als skalierte Integer verarbeitet.
  - UI-Konsistenz: Ausgabeformat liegt in `u_fmt`.

  Hinweis:
  - Erfordert foreign_keys=ON und eine valide stations/cars-Datenbasis.
  ---------------------------------------------------------------------------
}

unit u_fuelups;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, DateUtils, SQLDB, SQLite3Conn;

// ----------------
// Oeffentliche Schnittstelle

// Startet den interaktiven Dialog zum Hinzufuegen einer Betankung.
procedure AddFuelupInteractive(const DbPath: string; const CarIdProvided: boolean = False; const CarId: integer = 0);

// Zeigt die Liste aller Betankungen an (Detailed steuert Zusatzinfos).
procedure ListFuelups(const DbPath: string; Detailed: boolean);

implementation

uses
  u_db_common,
  u_fmt,
  u_log;

type
  // ----------------
  // Datenstrukturen

  // Datensatz zur temporaeren Speicherung der Benutzereingaben
  TFuelupInput = record
    StationId: integer;
    CarId: integer;
    FueledAt: string;     // Format: "YYYY-MM-DD HH:MM:SS"
    OdometerKm: integer;
    LitersMl: int64;      // Menge in Millilitern
    TotalCents: int64;    // Gesamtbetrag in Cents
    PricePerLiterMilliEur: int64; // Preis/Liter in Milli-Cents
    IsFullTank: boolean;
    MissedPrevious: boolean;
    FuelType: string;
    PaymentType: string;
    PumpNo: string;
    Note: string;
  end;

const
  // Abstandsschwelle fuer die Rueckfrage "fehlende vorherige Betankung?".
  GAP_THRESHOLD_KM = 1500;
  // Warnschwelle fuer aussergewoehnlich grosse Tankmengen.
  MAX_TANK_ML_WARNING = 150000; // 150 L

// Prueft strikt das erwartete ISO-Format "YYYY-MM-DD HH:MM:SS".
function TryParseFueledAtIso(const S: string; out DT: TDateTime): boolean;
var
  T: string;
  Y, M, D, H, N, Sec: Integer;
begin
  Result := False;
  T := Trim(S);

  if Length(T) <> 19 then Exit;
  if (T[5] <> '-') or (T[8] <> '-') or (T[11] <> ' ') or (T[14] <> ':') or (T[17] <> ':') then Exit;

  if not TryStrToInt(Copy(T, 1, 4), Y) then Exit;
  if not TryStrToInt(Copy(T, 6, 2), M) then Exit;
  if not TryStrToInt(Copy(T, 9, 2), D) then Exit;
  if not TryStrToInt(Copy(T, 12, 2), H) then Exit;
  if not TryStrToInt(Copy(T, 15, 2), N) then Exit;
  if not TryStrToInt(Copy(T, 18, 2), Sec) then Exit;

  try
    DT := EncodeDateTime(Y, M, D, H, N, Sec, 0);
    Result := True;
  except
    on E: Exception do
      Exit(False);
  end;
end;

// ----------------
// Interne Hilfsfunktion: Listet alle verfuegbaren Tankstellen zur Auswahl auf
procedure PrintStations(Q: TSQLQuery);
begin
  Q.Close;
  Q.SQL.Text :=
    'SELECT id, brand, city, street, house_no ' +
    'FROM stations ' +
    'ORDER BY brand, city, street, house_no;';
  Q.Open;

  if Q.EOF then
  begin
    WriteLn('Keine Tankstellen vorhanden. Bitte zuerst --add stations ausführen.');
    Exit;
  end;

  WriteLn;
  WriteLn('Verfügbare Tankstellen:');
  WriteLn(DupeString('-', 50));

  while not Q.EOF do
  begin
    WriteLn(
      Format('%3s: %s [%s, %s %s]', [
        Q.FieldByName('id').AsString,
        Q.FieldByName('brand').AsString,
        Q.FieldByName('city').AsString,
        Q.FieldByName('street').AsString,
        Q.FieldByName('house_no').AsString
      ])
    );
    Q.Next;
  end;
  WriteLn;
end;

// Interne Hilfsfunktion: Listet alle verfuegbaren Fahrzeuge zur Auswahl auf
procedure PrintCars(Q: TSQLQuery);
begin
  Q.Close;
  Q.SQL.Text :=
    'SELECT id, name ' +
    'FROM cars ' +
    'ORDER BY id;';
  Q.Open;

  if Q.EOF then
  begin
    WriteLn('Keine Fahrzeuge vorhanden. Bitte DB-Migration pruefen.');
    Exit;
  end;

  WriteLn;
  WriteLn('Verfügbare Fahrzeuge:');
  WriteLn(DupeString('-', 50));

  while not Q.EOF do
  begin
    WriteLn(
      Format('%3s: %s', [
        Q.FieldByName('id').AsString,
        Q.FieldByName('name').AsString
      ])
    );
    Q.Next;
  end;
  WriteLn;
end;

// Prüft, ob eine eingegebene Car-ID in der DB existiert
function CarExists(Q: TSQLQuery; const ACarId: Integer): boolean;
begin
  Q.Close;
  Q.SQL.Text := 'SELECT 1 FROM cars WHERE id = :id LIMIT 1;';
  Q.ParamByName('id').AsInteger := ACarId;
  Q.Open;
  Result := not Q.EOF;
end;

function GetCarOdometerStartKm(Q: TSQLQuery; const ACarId: integer): integer;
begin
  Q.Close;
  Q.SQL.Text := 'SELECT odometer_start_km FROM cars WHERE id = :id;';
  Q.ParamByName('id').AsInteger := ACarId;
  Q.Open;
  if Q.EOF then
    raise Exception.Create('Car nicht gefunden (id=' + IntToStr(ACarId) + ').');
  Result := Q.FieldByName('odometer_start_km').AsInteger;
  Q.Close;
end;

function GetLastOdometerKm(Q: TSQLQuery; const ACarId: integer): integer;
begin
  Q.Close;
  Q.SQL.Text :=
    'SELECT odometer_km ' +
    'FROM fuelups ' +
    'WHERE car_id = :car_id ' +
    'ORDER BY odometer_km DESC, fueled_at DESC, id DESC ' +
    'LIMIT 1;';
  Q.ParamByName('car_id').AsInteger := ACarId;
  Q.Open;
  if Q.EOF then Result := -1
  else Result := Q.FieldByName('odometer_km').AsInteger;
  Q.Close;
end;

// Interaktive Auswahl des Fahrzeugs mit Validierungsschleife.
// Bei genau einem vorhandenen Fahrzeug wird dieses automatisch verwendet.
function SelectCarIdInteractive(Q: TSQLQuery): Integer;
var
  S: string;
  Id: Integer;
  Cnt: Integer;
begin
  Q.Close;
  Q.SQL.Text := 'SELECT COUNT(*) AS cnt FROM cars;';
  Q.Open;
  Cnt := Q.FieldByName('cnt').AsInteger;
  Q.Close;

  if Cnt <= 0 then
    raise Exception.Create('Keine Fahrzeuge vorhanden. Migration/Seed prüfen.');

  if Cnt = 1 then
  begin
    Q.SQL.Text := 'SELECT id, name FROM cars ORDER BY id LIMIT 1;';
    Q.Open;
    Result := Q.FieldByName('id').AsInteger;
    WriteLn('Fahrzeug: ', Q.FieldByName('name').AsString, ' (ID ', Result, ')');
    Q.Close;
    Exit;
  end;

  PrintCars(Q);
  while True do
  begin
    Write('Car-ID (oder "l"=Liste, "q"=Abbruch): ');
    ReadLn(S);
    S := Trim(LowerCase(S));

    if (S = 'q') or (S = 'quit') then
      raise Exception.Create('Abbruch durch Benutzer.');

    if (S = 'l') or (S = 'list') then
    begin
      PrintCars(Q);
      Continue;
    end;

    if not TryStrToInt(S, Id) then
    begin
      WriteLn('Fehler: Bitte eine gültige Zahl eingeben.');
      Continue;
    end;

    if (Id <= 0) or not CarExists(Q, Id) then
    begin
      WriteLn('Fehler: Ungueltige Car-ID. ("l" fuer Liste)');
      Continue;
    end;

    Result := Id;
    Exit;
  end;
end;

// Prüft, ob eine eingegebene Station-ID in der DB existiert
function StationExists(Q: TSQLQuery; const AStationId: Integer): boolean;
begin
  Q.Close;
  Q.SQL.Text := 'SELECT 1 FROM stations WHERE id = :id LIMIT 1;';
  Q.ParamByName('id').AsInteger := AStationId;
  Q.Open;
  Result := not Q.EOF;
end;

// Interaktive Auswahl der Tankstelle mit Validierungsschleife
function SelectStationIdInteractive(Q: TSQLQuery): Integer;
var
  S: string;
  Id: Integer;
begin
  PrintStations(Q);

  while True do
  begin
    Write('Stations-ID (oder "l"=Liste, "q"=Abbruch): ');
    ReadLn(S);
    S := Trim(LowerCase(S));

    if (S = 'q') or (S = 'quit') then
      raise Exception.Create('Abbruch durch Benutzer.');

    if (S = 'l') or (S = 'list') then
    begin
      PrintStations(Q);
      Continue;
    end;

    if not TryStrToInt(S, Id) then
    begin
      WriteLn('Fehler: Bitte eine gültige Zahl eingeben.');
      Continue;
    end;

    if (Id <= 0) or not StationExists(Q, Id) then
    begin
      WriteLn('Fehler: Ungueltige Stations-ID. ("l" fuer Liste)');
      Continue;
    end;

    Result := Id;
    Exit;
  end;
end;

// Hauptprozedur zum Erfassen neuer Daten
procedure AddFuelupInteractive(const DbPath: string; const CarIdProvided: boolean; const CarId: integer);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q, QS: TSQLQuery;
  Inp: TFuelupInput;
  S: string;
  FueledAtDt: TDateTime;
  StartKm: integer;
  LastKm: integer;
  DiffKm: integer;

  // Setzt optionale String-Parameter (leerer String wird zu NULL)
  procedure SetOptStr(const P, V: string);
  begin
    if V = '' then
      Q.ParamByName(P).Clear
    else
      Q.ParamByName(P).AsString := V;
  end;
  
  // Rollback und Fehler weiterreichen
  procedure Fail(const Prefix: string; E: Exception);
  begin
    if Tran.Active then
      Tran.Rollback;
    raise Exception.Create(Prefix + E.Message);
  end;
begin
  WriteLn('--- Neue Betankung erfassen ---');

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  QS := TSQLQuery.Create(nil);

  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    QS.DataBase := Conn;
    QS.Transaction := Tran;

    Conn.Open;
    Conn.ExecuteDirect('PRAGMA foreign_keys = ON;');
    // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
    if not Tran.Active then
      Tran.StartTransaction;
    
    try
      if CarIdProvided then
      begin
        if CarId <= 0 then
          raise Exception.Create('P-001: car_id fehlt/ungueltig (erwartet > 0).');
        if not CarExists(QS, CarId) then
          raise Exception.Create('P-002: car_id existiert nicht (FK).');
        Inp.CarId := CarId;
      end
      else
        Inp.CarId := 1; // v4 Minimalumfang: Default-Car (Hauptauto)

      Inp.StationId := SelectStationIdInteractive(QS);
      Inp.FueledAt := AskRequired('Datum+Uhrzeit (YYYY-MM-DD HH:MM:SS): ');
      if not TryParseFueledAtIso(Inp.FueledAt, FueledAtDt) then
        raise Exception.Create('P-040: Datum/Zeit fehlt/ungueltig (erwartet YYYY-MM-DD HH:MM:SS).');

      if FueledAtDt > (Now + (10.0 / 1440.0)) then
      begin
        if not AskYesNo(
          Format('P-041: Warnung: Datum liegt in der Zukunft (%s). Trotzdem speichern?', [Inp.FueledAt]),
          False
        ) then
          raise Exception.Create('P-041: Abbruch durch Benutzer (Datum in der Zukunft).');
      end;

      S := AskRequired('Kilometerstand (km): ');
      if not TryStrToInt(S, Inp.OdometerKm) then
        raise Exception.Create('Ungültiger Kilometerstand.');

      // Domain-Validation: Startpunkt + Monotonie pro Fahrzeug
      StartKm := GetCarOdometerStartKm(QS, Inp.CarId);
      if Inp.OdometerKm < StartKm then
        raise Exception.Create(Format('P-010: odometer_km < cars.odometer_start_km (start=%d, current=%d).', [StartKm, Inp.OdometerKm]));

      LastKm := GetLastOdometerKm(QS, Inp.CarId);
      if (LastKm >= 0) and (Inp.OdometerKm = LastKm) then
        raise Exception.Create(Format('P-013: odometer_km - last_odometer_km = 0 (duplicate-km, current=%d, last=%d).', [Inp.OdometerKm, LastKm]));

      if (LastKm >= 0) and (Inp.OdometerKm < LastKm) then
        raise Exception.Create(Format('P-011: odometer_km <= last_odometer_km (pro car, current=%d, last=%d).', [Inp.OdometerKm, LastKm]));

      DiffKm := 0;
      if LastKm >= 0 then
        DiffKm := Inp.OdometerKm - LastKm;

      // P-030 (Hard Error): negativer Gesamtpreis fuehrt zum direkten Abbruch.
      S := AskRequired('Gesamtpreis (EUR, z.B. 50,01): ');
      if (Length(S) > 0) and (Trim(S)[1] = '-') then
        raise Exception.Create('P-030: cost_cents < 0.');
      Inp.TotalCents := ParseEuroToCents(S);
      WriteLn('OK: Gesamtpreis = ', FmtEuroFromCents(Inp.TotalCents),
              '  [raw=', Inp.TotalCents, ']');

      // P-031 (Warning+Confirm): Gesamtpreis=0 ist erlaubt, muss aber bestaetigt werden.
      if Inp.TotalCents = 0 then
      begin
        if not AskYesNo(
          'P-031: Warnung: Gesamtpreis ist 0,00 EUR. Sonderfall? Trotzdem speichern?',
          False
        ) then
          raise Exception.Create('P-031: Abbruch durch Benutzer (Gesamtpreis=0).');
      end;

      // P-020 (Hard Error): Liter <= 0 oder NaN fuehren zum direkten Abbruch.
      S := AskRequired('Getankte Menge (Liter, z.B. 28,76): ');
      Inp.LitersMl := ParseLitersToMl(S);
      WriteLn('OK: Liter = ', FmtLiterFromMl(Inp.LitersMl),
              '  [raw=', Inp.LitersMl, ']');

      // Plausibilitaet: sehr grosse Tankmenge (Warning + Confirm)
      if Inp.LitersMl > MAX_TANK_ML_WARNING then
      begin
        if not AskYesNo(
          Format('P-021: Warnung: Sehr grosse Tankmenge (%s L). Tippfehler? Trotzdem speichern?', [FmtLiterFromMl(Inp.LitersMl)]),
          False
        ) then
          raise Exception.Create('P-021: Abbruch durch Benutzer (Tankmenge).');
      end;

      Inp.PricePerLiterMilliEur := AskAndParseInt64(
        'Preis pro Liter (EUR/L, z.B. 1,739): ',
        @ParseEurPerLiterToMilli, @FmtEurPerLiterFromMilli, 'Preis/L', False
      );

      // P-032 (Warning+Confirm): Preis/Liter <= 0 ist erlaubt, aber unplausibel.
      if Inp.PricePerLiterMilliEur <= 0 then
      begin
        if not AskYesNo(
          Format('P-032: Warnung: Preis/Liter <= 0 (%s EUR/L). Trotzdem speichern?', [FmtEurPerLiterFromMilli(Inp.PricePerLiterMilliEur)]),
          False
        ) then
          raise Exception.Create('P-032: Abbruch durch Benutzer (Preis/Liter<=0).');
      end;

      Inp.IsFullTank := AskYesNo('Vollgetankt?', True);

      // Golden Information: nur bei grosser Distanz nachfragen
      Inp.MissedPrevious := False;
      if (LastKm >= 0) and (DiffKm > GAP_THRESHOLD_KM) then
      begin
        if not AskYesNo(
          Format('Warnung: Distanz seit letzter Betankung ist %d km (> %d). Hast du evtl. eine Betankung vergessen?', [DiffKm, GAP_THRESHOLD_KM]),
          False
        ) then
          raise Exception.Create('Abbruch durch Benutzer (Distanzluecke).');
        Inp.MissedPrevious := True;
      end;

      Inp.FuelType    := AskOptional('Spritart (optional, z.B. E10): ');
      Inp.PaymentType := AskOptional('Bezahlart (optional, z.B. EC): ');
      Inp.PumpNo      := AskOptional('Zapfsäule (optional): ');
      Inp.Note        := AskOptional('Notiz (optional): ');

      Q.SQL.Text :=
        'INSERT INTO fuelups(' +
        '  station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents, price_per_liter_milli_eur,' +
        '  is_full_tank, missed_previous, fuel_type, payment_type, pump_no, note' +
        ') VALUES(' +
        '  :station_id, :car_id, :fueled_at, :odometer_km, :liters_ml, :total_cents, :ppl_milli,' +
        '  :is_full_tank, :missed_previous, :fuel_type, :payment_type, :pump_no, :note' +
        ');';

      Q.ParamByName('station_id').AsInteger := Inp.StationId;
      Q.ParamByName('car_id').AsInteger := Inp.CarId;
      Q.ParamByName('fueled_at').AsString   := Inp.FueledAt;
      Q.ParamByName('odometer_km').AsInteger := Inp.OdometerKm;
      Q.ParamByName('liters_ml').AsLargeInt := Inp.LitersMl;
      Q.ParamByName('total_cents').AsLargeInt := Inp.TotalCents;
      Q.ParamByName('ppl_milli').AsLargeInt := Inp.PricePerLiterMilliEur;
      Q.ParamByName('is_full_tank').AsInteger := Ord(Inp.IsFullTank);
      Q.ParamByName('missed_previous').AsInteger := Ord(Inp.MissedPrevious);

      SetOptStr('fuel_type', Inp.FuelType);
      SetOptStr('payment_type', Inp.PaymentType);
      SetOptStr('pump_no', Inp.PumpNo);
      SetOptStr('note', Inp.Note);

      Dbg('AddFuelup: station_id=' + IntToStr(Inp.StationId) +
        ' car_id=' + IntToStr(Inp.CarId) +
        ' full=' + BoolToStr(Inp.IsFullTank, True) +
        ' missed_previous=' + BoolToStr(Inp.MissedPrevious, True));
      Q.ExecSQL;
      Tran.Commit;
      WriteLn('OK: Betankung erfolgreich gespeichert.');

    except
      on E: Exception do
        Fail('AddFuelup fehlgeschlagen: ', E);
    end;
  finally
    QS.Free; Q.Free; Tran.Free; Conn.Free;
  end;
end;

// Listet die Tankhistorie tabellarisch auf
procedure ListFuelups(const DbPath: string; Detailed: boolean);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  IsFirstRow: boolean;
  RowCount: integer;

  // Rollback und Fehler weiterreichen
  procedure Fail(const Prefix: string; E: Exception);
  begin
    if Tran.Active then
      Tran.Rollback;
    raise Exception.Create(Prefix + E.Message);
  end;
begin
  Dbg('ListFuelups: detailed=' + BoolToStr(Detailed, True));
  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;
    Q.DataBase := Conn;
    Q.Transaction := Tran;

    Conn.Open;
    Conn.ExecuteDirect('PRAGMA foreign_keys = ON;');
    if not Tran.Active then
      Tran.StartTransaction;

    try
      Q.SQL.Text :=
        'SELECT f.id, f.fueled_at, f.odometer_km, f.liters_ml, f.total_cents, ' +
        '       f.price_per_liter_milli_eur, f.is_full_tank, f.missed_previous, ' +
        '       COALESCE(f.fuel_type, '''') AS fuel_type, ' +
        '       COALESCE(f.payment_type, '''') AS payment_type, ' +
        '       COALESCE(f.pump_no, '''') AS pump_no, ' +
        '       COALESCE(f.note, '''') AS note, ' +
        '       COALESCE(c.name, ''(unbekannt)'') AS car_name, ' +
        '       s.brand, s.city, s.street, s.house_no ' +
        'FROM fuelups f ' +
        'LEFT JOIN cars c ON c.id = f.car_id ' +
        'JOIN stations s ON s.id = f.station_id ' +
        'ORDER BY f.fueled_at DESC, f.id DESC;';
      Q.Open;

      if Q.EOF then
      begin
        WriteLn('Keine Betankungsdaten gefunden.');
        if Tran.Active then
          Tran.Commit;
        Exit;
      end;

      PrintFuelupHeader;

      IsFirstRow := True;
      RowCount := 0;
      while not Q.EOF do
      begin
        Inc(RowCount);
        if not IsFirstRow then
          if Detailed then
            // Duenne Linie fuer den Detail-Block-Trenner
            PrintFuelupSeparator
          else
            // Dicke Linie fuer den Standard-Zeilentrenner
            PrintFuelupSeparatorDouble;

        PrintFuelupRow(
          Q.FieldByName('id').AsInteger,
          Q.FieldByName('fueled_at').AsString,
          Q.FieldByName('odometer_km').AsLargeInt,
          Q.FieldByName('liters_ml').AsLargeInt,
          Q.FieldByName('price_per_liter_milli_eur').AsLargeInt,
          Q.FieldByName('total_cents').AsLargeInt,
          Q.FieldByName('brand').AsString + ' (' + Q.FieldByName('city').AsString + ') / ' + Q.FieldByName('car_name').AsString
        );
    
        if Detailed then
        begin
          PrintFuelupDetail(
            Q.FieldByName('is_full_tank').AsInteger = 1,
            Q.FieldByName('missed_previous').AsInteger = 1,
            Q.FieldByName('car_name').AsString,
            Q.FieldByName('fuel_type').AsString,
            Q.FieldByName('payment_type').AsString,
            Q.FieldByName('pump_no').AsString,
            Q.FieldByName('note').AsString,
            Q.FieldByName('street').AsString + ' ' + Q.FieldByName('house_no').AsString + ', ' + Q.FieldByName('city').AsString
          );
        end;
        
        IsFirstRow := False;
        Q.Next;
      end;

      PrintFuelupFooter(Detailed);
      Dbg('ListFuelups: rows=' + IntToStr(RowCount));
      Tran.Commit;
    except
      on E: Exception do
        Fail('Fehler beim Laden der Liste: ', E);
    end;
  finally
    Q.Free; Tran.Free; Conn.Free;
  end;
end;

end.
