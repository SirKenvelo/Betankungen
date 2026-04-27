{
  u_stations.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-04-27
  AUTHOR : Christof Kempinski
  Fachmodul fuer Stammdatenverwaltung von Tankstellen (stations).

  Verantwortlichkeiten:
  - Implementiert Add/List/Edit/Delete fuer stations.
  - Bietet kompakte und detaillierte Listendarstellung.
  - Sichert Adress-Eindeutigkeit ueber DB-Constraints + Fehlermapping.
  - Validiert Stammdaten, Geokoordinaten und Plus-Codes gemaess `P-080..P-088`.
  - Normalisiert volle und lokale Plus-Codes ueber vorhandene Koordinaten.

  Design-Entscheidungen:
  - Atomare Schreiboperationen per Transaktion.
  - Konsistentes CLI-Layout via feste Spaltenbreiten.
  - Defensive Eingabepruefung vor DB-Schreibvorgaengen.
  - Bewusst kein vollstaendiger Open-Location-Code-Decoder ausserhalb des aktuellen CLI-Contracts.

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
  MIN_LATITUDE_E6 = -90000000;
  MAX_LATITUDE_E6 = 90000000;
  MIN_LONGITUDE_E6 = -180000000;
  MAX_LONGITUDE_E6 = 180000000;
  COORD_SCALE_E6 = 1000000;
  PLUS_CODE_ALPHABET = '23456789CFGHJMPQRVWX';
  FULL_PLUS_SEPARATOR_POS = 9;
  FULL_PLUS_CODE_EXAMPLE = '9F4MGC2M+H4';
  SHORT_PLUS_CODE_EXAMPLE = 'GC2M+H4 Dortmund';
  PAIR_RESOLUTIONS: array[0..4] of Double =
    (20.0, 1.0, 0.05, 0.0025, 0.000125);

function HasDigit(const S: string): boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(S) do
    if S[I] in ['0'..'9'] then
      Exit(True);
end;

function HasAsciiLetter(const S: string): boolean;
var
  I: Integer;
  C: Char;
begin
  Result := False;
  for I := 1 to Length(S) do
  begin
    C := UpCase(S[I]);
    if C in ['A'..'Z'] then
      Exit(True);
  end;
end;

function IsDigitsOnly(const S: string): boolean;
var
  I: Integer;
begin
  if S = '' then
    Exit(False);
  for I := 1 to Length(S) do
    if not (S[I] in ['0'..'9']) then
      Exit(False);
  Result := True;
end;

procedure ValidateStationMasterDataOrFail(
  const Brand, Street, HouseNo, Zip, City, Phone: string);
begin
  EnsureNotEmpty('brand', Brand);
  EnsureNotEmpty('street', Street);
  EnsureNotEmpty('house_no', HouseNo);
  EnsureNotEmpty('zip', Zip);
  EnsureNotEmpty('city', City);

  if IsDigitsOnly(City) and HasAsciiLetter(Zip) then
    raise Exception.Create(
      'P-080: Feldverschiebung vermutet (zip/city). Bitte Eingaben pruefen.'
    );

  if (not IsDigitsOnly(Zip)) then
    raise Exception.Create(
      'P-081: zip ungueltig (nur Ziffern erlaubt).'
    );

  if (Length(Zip) < 4) or (Length(Zip) > 10) then
    raise Exception.Create(
      'P-081: zip ungueltig (erwartet 4..10 Ziffern).'
    );

  if IsDigitsOnly(City) then
    raise Exception.Create(
      'P-082: city ungueltig (enthaelt nur Ziffern).'
    );

  if not HasAsciiLetter(City) then
    raise Exception.Create(
      'P-082: city ungueltig (keine Buchstaben gefunden).'
    );

  if not HasDigit(HouseNo) then
    raise Exception.Create(
      'P-083: house_no ungueltig (mindestens eine Ziffer erwartet).'
    );

  if (Trim(Phone) <> '') and (not HasDigit(Phone)) then
    raise Exception.Create(
      'P-084: phone ungueltig (mindestens eine Ziffer erwartet).'
    );
end;

function NormalizePlusCode(const S: string): string;
var
  I: Integer;
  C: Char;
  Trimmed: string;
  FirstToken: string;
begin
  Trimmed := Trim(S);
  if Trimmed = '' then
    Exit('');

  FirstToken := '';
  I := 1;
  while (I <= Length(Trimmed)) and not (Trimmed[I] in [' ', #9]) do
  begin
    FirstToken := FirstToken + UpCase(Trimmed[I]);
    Inc(I);
  end;

  if Pos('+', FirstToken) > 0 then
    Exit(FirstToken);

  Result := '';
  for I := 1 to Length(Trimmed) do
  begin
    C := Trimmed[I];
    if (C = ' ') or (C = #9) then
      Continue;
    Result := Result + UpCase(C);
  end;
end;

function IsValidPlusCodeChar(const C: Char): boolean;
begin
  Result := Pos(UpCase(C), PLUS_CODE_ALPHABET) > 0;
end;

function NormalizeLongitudeDegrees(const Value: Double): Double;
begin
  Result := Value;
  while Result < -180.0 do
    Result := Result + 360.0;
  while Result >= 180.0 do
    Result := Result - 360.0;
end;

function PlusCodeInvalidMessage: string;
begin
  Result :=
    'P-088: plus_code ungueltig (erwartet vollen Open Location Code, z.B. ' +
    FULL_PLUS_CODE_EXAMPLE + ', oder lokalen/short Code mit gesetzter latitude/longitude, z.B. ' +
    SHORT_PLUS_CODE_EXAMPLE + ').';
end;

function ShortPlusCodeNeedsCoordinatesMessage: string;
begin
  Result :=
    'P-088: lokaler plus_code erfordert gesetzte latitude und longitude oder einen vollen Open Location Code, z.B. ' +
    FULL_PLUS_CODE_EXAMPLE + '.';
end;

function HasSinglePlusSeparator(const Code: string; out PlusPos: Integer): boolean;
begin
  PlusPos := Pos('+', Code);
  Result := (PlusPos > 0) and
    (Pos('+', Copy(Code, PlusPos + 1, MaxInt)) = 0);
end;

function HasOnlyValidPlusCodeChars(const Code: string): boolean;
var
  I: Integer;
begin
  for I := 1 to Length(Code) do
  begin
    if Code[I] = '+' then
      Continue;
    if not IsValidPlusCodeChar(Code[I]) then
      Exit(False);
  end;
  Result := True;
end;

function IsFullPlusCode(const Code: string; out PlusPos: Integer): boolean;
begin
  if not HasSinglePlusSeparator(Code, PlusPos) then
    Exit(False);
  Result :=
    (PlusPos = FULL_PLUS_SEPARATOR_POS) and
    (Length(Code) >= 11) and
    (Length(Code) <= 15) and
    HasOnlyValidPlusCodeChars(Code);
end;

function IsShortPlusCode(const Code: string; out PlusPos: Integer): boolean;
var
  MissingPrefixChars, SignificantChars: Integer;
begin
  if not HasSinglePlusSeparator(Code, PlusPos) then
    Exit(False);

  MissingPrefixChars := FULL_PLUS_SEPARATOR_POS - PlusPos;
  SignificantChars := Length(Code) - 1;

  Result :=
    (PlusPos > 0) and
    (PlusPos < FULL_PLUS_SEPARATOR_POS) and
    (MissingPrefixChars > 0) and
    ((MissingPrefixChars mod 2) = 0) and
    ((Length(Code) - PlusPos) >= 2) and
    (SignificantChars >= 6) and
    (SignificantChars < 10) and
    HasOnlyValidPlusCodeChars(Code);
end;

function EncodeFullPlusCodeFromCoordinates(
  const LatitudeE6, LongitudeE6: Int64
): string;
var
  LatitudeDegrees, LongitudeDegrees: Double;
  LatitudeValue, LongitudeValue, Place: Double;
  I, Digit: Integer;
begin
  LatitudeDegrees := LatitudeE6 / COORD_SCALE_E6;
  LongitudeDegrees := LongitudeE6 / COORD_SCALE_E6;

  if LatitudeDegrees < -90.0 then
    LatitudeDegrees := -90.0
  else if LatitudeDegrees > 90.0 then
    LatitudeDegrees := 90.0;

  if LatitudeDegrees = 90.0 then
    LatitudeDegrees := LatitudeDegrees - (PAIR_RESOLUTIONS[High(PAIR_RESOLUTIONS)] / 2.0);

  LongitudeDegrees := NormalizeLongitudeDegrees(LongitudeDegrees);

  LatitudeValue := LatitudeDegrees + 90.0;
  LongitudeValue := LongitudeDegrees + 180.0;
  Result := '';

  for I := 0 to High(PAIR_RESOLUTIONS) do
  begin
    Place := PAIR_RESOLUTIONS[I];

    Digit := Trunc(LatitudeValue / Place);
    if Digit < 0 then
      Digit := 0
    else if Digit > 19 then
      Digit := 19;
    LatitudeValue := LatitudeValue - (Digit * Place);
    Result := Result + PLUS_CODE_ALPHABET[Digit + 1];

    Digit := Trunc(LongitudeValue / Place);
    if Digit < 0 then
      Digit := 0
    else if Digit > 19 then
      Digit := 19;
    LongitudeValue := LongitudeValue - (Digit * Place);
    Result := Result + PLUS_CODE_ALPHABET[Digit + 1];

    if Length(Result) = 8 then
      Result := Result + '+';
  end;
end;

// Der Recovery-Pfad deckt bewusst nur die fuer den aktuellen Contract
// benoetigte Short-/Pair-Code-Ergaenzung ueber Referenzkoordinaten ab und
// ist kein allgemeiner Open-Location-Code-Decoder.
function RecoverFullPlusCodeFromCoordinates(
  const ShortCode: string;
  const LatitudeE6, LongitudeE6: Int64
): string;
var
  PlusPos, MissingPrefixChars: Integer;
  ReferenceFullCode: string;
begin
  if not IsShortPlusCode(ShortCode, PlusPos) then
    raise Exception.Create(PlusCodeInvalidMessage);

  MissingPrefixChars := FULL_PLUS_SEPARATOR_POS - PlusPos;
  ReferenceFullCode := EncodeFullPlusCodeFromCoordinates(
    LatitudeE6, LongitudeE6
  );
  Result := Copy(ReferenceFullCode, 1, MissingPrefixChars) + ShortCode;
end;

function ParseCoordinateToE6OrFail(
  const Raw, PolicyId, FieldName: string;
  const MinValueE6, MaxValueE6: Int64
): Int64;
var
  T, IntPart, FracPart: string;
  P, I, Sign: Integer;
  IntValue, FracValue: Int64;
begin
  T := Trim(Raw);
  if T = '' then
    raise Exception.Create(
      PolicyId + ': ' + FieldName +
      ' ungueltig (erwartet Dezimalgrad mit max. 6 Nachkommastellen).'
    );

  T := StringReplace(T, ',', '.', [rfReplaceAll]);
  Sign := 1;

  if T[1] in ['+', '-'] then
  begin
    if T[1] = '-' then
      Sign := -1;
    Delete(T, 1, 1);
  end;

  if T = '' then
    raise Exception.Create(
      PolicyId + ': ' + FieldName +
      ' ungueltig (erwartet Dezimalgrad mit max. 6 Nachkommastellen).'
    );

  P := Pos('.', T);
  if (P > 0) and (Pos('.', Copy(T, P + 1, MaxInt)) > 0) then
    raise Exception.Create(
      PolicyId + ': ' + FieldName +
      ' ungueltig (erwartet Dezimalgrad mit max. 6 Nachkommastellen).'
    );

  if P > 0 then
  begin
    IntPart := Copy(T, 1, P - 1);
    FracPart := Copy(T, P + 1, MaxInt);
  end
  else
  begin
    IntPart := T;
    FracPart := '';
  end;

  if IntPart = '' then
    IntPart := '0';

  for I := 1 to Length(IntPart) do
    if not (IntPart[I] in ['0'..'9']) then
      raise Exception.Create(
        PolicyId + ': ' + FieldName +
        ' ungueltig (erwartet Dezimalgrad mit max. 6 Nachkommastellen).'
      );

  for I := 1 to Length(FracPart) do
    if not (FracPart[I] in ['0'..'9']) then
      raise Exception.Create(
        PolicyId + ': ' + FieldName +
        ' ungueltig (erwartet Dezimalgrad mit max. 6 Nachkommastellen).'
      );

  if Length(FracPart) > 6 then
    raise Exception.Create(
      PolicyId + ': ' + FieldName +
      ' ungueltig (erwartet Dezimalgrad mit max. 6 Nachkommastellen).'
    );

  while Length(FracPart) < 6 do
    FracPart := FracPart + '0';

  if not TryStrToInt64(IntPart, IntValue) then
    raise Exception.Create(
      PolicyId + ': ' + FieldName +
      ' ungueltig (erwartet Dezimalgrad mit max. 6 Nachkommastellen).'
    );

  if not TryStrToInt64(FracPart, FracValue) then
    raise Exception.Create(
      PolicyId + ': ' + FieldName +
      ' ungueltig (erwartet Dezimalgrad mit max. 6 Nachkommastellen).'
    );

  Result := (IntValue * COORD_SCALE_E6) + FracValue;
  if Sign < 0 then
    Result := -Result;

  if (Result < MinValueE6) or (Result > MaxValueE6) then
    raise Exception.Create(
      PolicyId + ': ' + FieldName +
      ' ungueltig (ausserhalb des erlaubten Bereichs).'
    );
end;

function FormatCoordinateE6(const Value: Int64): string;
var
  AbsValue: Int64;
begin
  AbsValue := Abs(Value);
  Result := IntToStr(AbsValue div COORD_SCALE_E6) + '.' +
    Format('%.6d', [AbsValue mod COORD_SCALE_E6]);
  if Value < 0 then
    Result := '-' + Result;
end;

function CoordinateFieldOrEmpty(Q: TSQLQuery; const FieldName: string): string;
begin
  if Q.FieldByName(FieldName).IsNull then
    Exit('');
  Result := FormatCoordinateE6(Q.FieldByName(FieldName).AsLargeInt);
end;

function BuildStationGeoSummary(
  const Latitude, Longitude, PlusCode: string
): string;
begin
  Result := '';

  if Latitude <> '' then
    Result := 'lat=' + Latitude;

  if Longitude <> '' then
  begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + 'lon=' + Longitude;
  end;

  if PlusCode <> '' then
  begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + 'plus_code=' + PlusCode;
  end;
end;

procedure NormalizeStationGeodataOrFail(
  const LatitudeRaw, LongitudeRaw, PlusCodeRaw: string;
  out HasCoordinates: boolean;
  out LatitudeE6, LongitudeE6: Int64;
  out NormalizedPlusCode: string
);
var
  HasLatitude, HasLongitude: boolean;
  PlusPos: Integer;
begin
  HasLatitude := Trim(LatitudeRaw) <> '';
  HasLongitude := Trim(LongitudeRaw) <> '';
  HasCoordinates := False;
  LatitudeE6 := 0;
  LongitudeE6 := 0;

  if HasLatitude <> HasLongitude then
    raise Exception.Create(
      'P-085: latitude/longitude muessen gemeinsam gesetzt oder gemeinsam leer sein.'
    );

  if HasLatitude and HasLongitude then
  begin
    LatitudeE6 := ParseCoordinateToE6OrFail(
      LatitudeRaw, 'P-086', 'latitude', MIN_LATITUDE_E6, MAX_LATITUDE_E6
    );
    LongitudeE6 := ParseCoordinateToE6OrFail(
      LongitudeRaw, 'P-087', 'longitude', MIN_LONGITUDE_E6, MAX_LONGITUDE_E6
    );
    HasCoordinates := True;
  end;

  NormalizedPlusCode := NormalizePlusCode(PlusCodeRaw);
  if NormalizedPlusCode = '' then
    Exit;

  if IsFullPlusCode(NormalizedPlusCode, PlusPos) then
    Exit;

  if IsShortPlusCode(NormalizedPlusCode, PlusPos) then
  begin
    if not HasCoordinates then
      raise Exception.Create(ShortPlusCodeNeedsCoordinatesMessage);
    NormalizedPlusCode := RecoverFullPlusCodeFromCoordinates(
      NormalizedPlusCode, LatitudeE6, LongitudeE6
    );
    if not IsFullPlusCode(NormalizedPlusCode, PlusPos) then
      raise Exception.Create(PlusCodeInvalidMessage);
    Exit;
  end;

  raise Exception.Create(PlusCodeInvalidMessage);
end;

procedure SetNullableLargeIntParam(
  Q: TSQLQuery;
  const ParamName: string;
  const HasValue: boolean;
  const Value: Int64
);
begin
  if HasValue then
    Q.ParamByName(ParamName).AsLargeInt := Value
  else
    Q.ParamByName(ParamName).Clear;
end;

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
  SLatitude, SLongitude, SPlusCode, GeoSummary: string;
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
        'SELECT id, brand, street, house_no, zip, city, phone, owner, ' +
        'latitude_e6, longitude_e6, plus_code ' +
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
        SLatitude := CoordinateFieldOrEmpty(Q, 'latitude_e6');
        SLongitude := CoordinateFieldOrEmpty(Q, 'longitude_e6');
        SPlusCode := Q.FieldByName('plus_code').AsString;
        GeoSummary := BuildStationGeoSummary(SLatitude, SLongitude, SPlusCode);

        if Detailed then
        begin
          PrintRow(SId, SBrand, SStreet, SHouseNo, SZip, SCity, SPhone, SOwner)
          ;
          if GeoSummary <> '' then
            WriteLn('      geodata: ', GeoSummary);
        end
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
  LatitudeRaw, LongitudeRaw, PlusCodeRaw: string;
  LatitudeE6, LongitudeE6: Int64;
  HasCoordinates: boolean;
  NormalizedPlusCode: string;
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
  LatitudeRaw := AskOptional('Latitude (Optional, Dezimalgrad): ');
  LongitudeRaw := AskOptional('Longitude (Optional, Dezimalgrad): ');
  PlusCodeRaw := AskOptional(
    'Plus code (Optional; full OLC or local/short with Latitude+Longitude): '
  );

  ValidateStationMasterDataOrFail(Brand, Street, HouseNo, Zip, City, Phone);
  NormalizeStationGeodataOrFail(
    LatitudeRaw, LongitudeRaw, PlusCodeRaw,
    HasCoordinates, LatitudeE6, LongitudeE6, NormalizedPlusCode
  );

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
        'INSERT INTO stations(' +
        '  brand, street, house_no, zip, city, phone, owner, latitude_e6, longitude_e6, plus_code' +
        ') VALUES (' +
        '  :brand, :street, :house_no, :zip, :city, :phone, :owner, :latitude_e6, :longitude_e6, :plus_code' +
        ');';

      Q.Params.ParamByName('brand').AsString := Brand;
      Q.Params.ParamByName('street').AsString := Street;
      Q.Params.ParamByName('house_no').AsString := HouseNo;
      Q.Params.ParamByName('zip').AsString := Zip;
      Q.Params.ParamByName('city').AsString := City;
      Q.Params.ParamByName('phone').AsString := Phone;
      Q.Params.ParamByName('owner').AsString := Owner;
      SetNullableLargeIntParam(Q, 'latitude_e6', HasCoordinates, LatitudeE6);
      SetNullableLargeIntParam(Q, 'longitude_e6', HasCoordinates, LongitudeE6);
      if NormalizedPlusCode = '' then
        Q.Params.ParamByName('plus_code').Clear
      else
        Q.Params.ParamByName('plus_code').AsString := NormalizedPlusCode;

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
  Owner, GeoSummary: string): string;
begin
  Result := Format('%s (%s %s, %s %s %s %s)', [Brand, Street, HouseNo,
    Zip, City, Phone, Owner]);
  if GeoSummary <> '' then
    Result := Result + ' [' + GeoSummary + ']';
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
  TmpLatitude, TmpLongitude, TmpPlusCode, TmpGeoSummary: string;
  OldBrand, OldStreet, OldHouseNo, OldZip, OldCity, OldPhone, OldOwner: string;
  OldLatitude, OldLongitude, OldPlusCode, OldGeoSummary: string;
  NewBrand, NewStreet, NewHouseNo, NewZip, NewCity, NewPhone, NewOwner: string;
  NewLatitudeRaw, NewLongitudeRaw, NewPlusCodeRaw, NewGeoSummary: string;
  NewLatitudeNormalized, NewLongitudeNormalized: string;
  NewLatitudeE6, NewLongitudeE6: Int64;
  HasCoordinates: boolean;
  NormalizedPlusCode: string;
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
        'SELECT id, brand, street, house_no, zip, city, phone, owner, ' +
        'latitude_e6, longitude_e6, plus_code ' +
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
        TmpLatitude := CoordinateFieldOrEmpty(Q, 'latitude_e6');
        TmpLongitude := CoordinateFieldOrEmpty(Q, 'longitude_e6');
        TmpPlusCode := Q.FieldByName('plus_code').AsString;
        TmpGeoSummary := BuildStationGeoSummary(TmpLatitude, TmpLongitude, TmpPlusCode);

        WriteLn(Q.FieldByName('id').AsString, ': ',
          ReplaceLine(TmpBrand, TmpStreet, TmpHouseNo, TmpZip, TmpCity,
          TmpPhone, TmpOwner, TmpGeoSummary));
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
        'SELECT brand, street, house_no, zip, city, phone, owner, ' +
        'latitude_e6, longitude_e6, plus_code ' +
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
      OldLatitude := CoordinateFieldOrEmpty(Q, 'latitude_e6');
      OldLongitude := CoordinateFieldOrEmpty(Q, 'longitude_e6');
      OldPlusCode := Q.FieldByName('plus_code').AsString;
      OldGeoSummary := BuildStationGeoSummary(OldLatitude, OldLongitude, OldPlusCode);

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
      NewLatitudeRaw := AskKeep('Latitude: (ENTER=behalten)', OldLatitude);
      NewLongitudeRaw := AskKeep('Longitude: (ENTER=behalten)', OldLongitude);
      NewPlusCodeRaw := AskKeep(
        'Plus code: (ENTER=behalten; full OLC or local/short with Latitude+Longitude)',
        OldPlusCode
      );

      ValidateStationMasterDataOrFail(
        NewBrand, NewStreet, NewHouseNo, NewZip, NewCity, NewPhone
      );
      NormalizeStationGeodataOrFail(
        NewLatitudeRaw, NewLongitudeRaw, NewPlusCodeRaw,
        HasCoordinates, NewLatitudeE6, NewLongitudeE6, NormalizedPlusCode
      );
      if HasCoordinates then
      begin
        NewLatitudeNormalized := FormatCoordinateE6(NewLatitudeE6);
        NewLongitudeNormalized := FormatCoordinateE6(NewLongitudeE6);
      end
      else
      begin
        NewLatitudeNormalized := '';
        NewLongitudeNormalized := '';
      end;
      NewGeoSummary := BuildStationGeoSummary(
        NewLatitudeNormalized,
        NewLongitudeNormalized,
        NormalizedPlusCode
      );
      Q.Close;

      WriteLn('Ausgewählt: ', ReplaceLine(OldBrand, OldStreet, OldHouseNo,
        OldZip, OldCity, OldPhone, OldOwner, OldGeoSummary));
      Writeln('Ändern in: ', ReplaceLine(NewBrand, NewStreet,
        NewHouseNo, NewZip, NewCity, NewPhone, NewOwner, NewGeoSummary));
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
        'phone=:phone, owner=:owner, latitude_e6=:latitude_e6, ' +
        'longitude_e6=:longitude_e6, plus_code=:plus_code ' +
        'WHERE id = :id;';

      // Parameter zuweisen
      Q.Params.ParamByName('brand').AsString := NewBrand;
      Q.Params.ParamByName('street').AsString := NewStreet;
      Q.Params.ParamByName('house_no').AsString := NewHouseNo;
      Q.Params.ParamByName('zip').AsString := NewZip;
      Q.Params.ParamByName('city').AsString := NewCity;
      Q.Params.ParamByName('phone').AsString := NewPhone;
      Q.Params.ParamByName('owner').AsString := NewOwner;
      SetNullableLargeIntParam(Q, 'latitude_e6', HasCoordinates, NewLatitudeE6);
      SetNullableLargeIntParam(Q, 'longitude_e6', HasCoordinates, NewLongitudeE6);
      if NormalizedPlusCode = '' then
        Q.Params.ParamByName('plus_code').Clear
      else
        Q.Params.ParamByName('plus_code').AsString := NormalizedPlusCode;
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
