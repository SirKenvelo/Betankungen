{
  u_db_common.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-03-21
  AUTHOR : Christof Kempinski
  Zentrale Eingabe- und Parse-Utilities fuer den CLI-Dialogfluss.

  Verantwortlichkeiten:
  - Kapselt konsistente Konsolenabfragen (Pflicht/Optional/Keep/YesNo).
  - Liefert robuste Validierung fuer Pflichtfelder vor Persistenz.
  - Implementiert strict Fixed-Point-Parsing fuer Geld-/Mengenwerte.

  Design-Entscheidungen:
  - Fixed-Point-First: Int64 statt Float fuer deterministische Werte.
  - Strict Input: Nachkommastellen werden explizit erzwungen.
  - DB-frei: Keine SQL-Logik, nur UI-nahe Vorvalidierung.

  Hinweis:
  - Parse-Funktionen normalisieren Komma auf Punkt vor der Auswertung.
  ---------------------------------------------------------------------------
}

unit u_db_common;

{$mode objfpc}{$H+}

interface

type
  // Parser-Signatur fuer dialoggefuehrte Zahleneingaben.
  TParseInt64Func = function(const S: string): Int64;
  // Formatter-Signatur fuer Bestaetigungsausgaben.
  TFormatInt64Func = function(const V: Int64): string;

const
  // Rueckgabewert fuer "leer" bei optionalen Zahlenfeldern
  EMPTY_INT64 = Low(Int64);

// ----------------
// Eingabe-Helfer fuer interaktive Dialoge

// Liest ein Pflichtfeld (wiederholt bis nicht-leer).
function AskRequired(const Prompt: string): string;
// Liest ein optionales Feld (trimmed, darf leer sein).
function AskOptional(const Prompt: string): string;
// Liest eine Dialogzeile EOF-sicher von stdin.
function ReadInteractiveLine(const Prompt: string): string;

// Eingabetaste = aktuellen Wert behalten (Edit-Flow).
function AskKeep(const Prompt, Current: string): string;

// Validiert, dass ein Wert nicht leer ist.
procedure EnsureNotEmpty(const FieldName, Value: string);

// Standardisierte Ja/Nein-Abfrage mit konfigurierbarem Default.
function AskYesNo(const Prompt: string; DefaultNo: boolean = True): boolean;

// ----------------
// Parsing-Helfer fuer skalierte Int64-Werte

// Erzwingt exakt eines von zwei Dezimalformaten.
function ParseScaledIntExactOneOf(const S: string; const ADecimals1, ADecimals2: Integer; const AName: string): Int64;
// Erzwingt exakt eine feste Anzahl Nachkommastellen.
function ParseScaledIntExact(const S: string; const ADecimals: Integer; const AName: string): Int64;
// Spezialparser: Liter -> Milliliter (Int64).
function ParseLitersToMl(const S: string): int64;
// Spezialparser: Euro -> Cents (Int64).
function ParseEuroToCents(const S: string): int64;
// Spezialparser: EUR/L -> milli-EUR (Int64).
function ParseEurPerLiterToMilli(const S: string): int64;
// Kombinierter Ask+Parse-Loop inkl. Bestaetigung und Retry.
function AskAndParseInt64(
  const Prompt: string;
  ParseFunc: TParseInt64Func;
  FormatFunc: TFormatInt64Func;
  const LabelName: string;
  AllowEmpty: boolean = False // wenn True: Rueckgabe EMPTY_INT64 bei leerer Eingabe
): Int64;

implementation

uses
  SysUtils, Math;

function ReadInteractiveLine(const Prompt: string): string;
begin
  Write(Prompt);
  if EOF(Input) then
    raise Exception.Create('Eingabe abgebrochen (EOF).');
  ReadLn(Result);
end;

function AskRequired(const Prompt: string): string;
var
  Input: string;
begin
  repeat
    Input := ReadInteractiveLine(Prompt);
    Input := Trim(Input);
    if Input = '' then
      WriteLn('Fehler: Diese Eingabe darf nicht leer sein!');
  until Input <> '';
  Result := Input;
end;

function AskOptional(const Prompt: string): string;
var
  Input: string;
begin
  Input := ReadInteractiveLine(Prompt);
  Result := Trim(Input);
end;

function AskKeep(const Prompt, Current: string): string;
var
  Input: string;
begin
  Input := ReadInteractiveLine(Prompt + ' [' + Current + ']: ');
  Input := Trim(Input);
  if Input = '' then
    Result := Current
  else
    Result := Input;
end;

procedure EnsureNotEmpty(const FieldName, Value: string);
begin
  if Trim(Value) = '' then
    raise Exception.Create('Pflichtfeld darf nicht leer sein: ' + FieldName);
end;

function AskYesNo(const Prompt: string; DefaultNo: boolean): boolean;
var
  S: string;
begin
  if DefaultNo then
    S := ReadInteractiveLine(Prompt + ' (y/N): ')
  else
    S := ReadInteractiveLine(Prompt + ' (Y/n): ');
  S := LowerCase(Trim(S));

  if S = '' then
    Exit(not DefaultNo);

  Result := (S = 'y') or (S = 'yes') or (S = 'j') or (S = 'ja');
end;

function AskAndParseInt64(
  const Prompt: string;
  ParseFunc: TParseInt64Func;
  FormatFunc: TFormatInt64Func;
  const LabelName: string;
  AllowEmpty: boolean = False
): Int64;
var
  S: string;
begin
  while True do
  begin
    S := ReadInteractiveLine(Prompt);
    S := Trim(S);

    // Abbruch
    if (LowerCase(S) = 'q') or (LowerCase(S) = 'quit') then
      raise Exception.Create(LabelName + ': Abgebrochen durch Benutzer.');

    // Optionales Feld
    if AllowEmpty and (S = '') then
      Exit(EMPTY_INT64); // Konvention: "leer" ist eindeutig von Null unterscheidbar

    if (not AllowEmpty) and (S = '') then
    begin
      WriteLn('Fehler: Eingabe darf nicht leer sein. (oder q zum Abbrechen)');
      Continue;
    end;

    try
      Result := ParseFunc(S);

      // Bestaetigung: zeigt formatierten und rohen Wert
      WriteLn('OK: ', LabelName, ' = ', FormatFunc(Result),
              '  [raw=', Result, ']');

      Exit;
    except
      on E: Exception do
      begin
        WriteLn('Fehler: ', E.Message);
        WriteLn('Bitte erneut eingeben (oder q zum Abbrechen).');
      end;
    end;
  end;
end;

function ParseScaledIntExact(const S: string; const ADecimals: Integer; const AName: string): Int64;
var
  T, IntPart, FracPart: string;
  P, I: Integer;
  Scale: Int64;
begin
  T := Trim(S);
  if T = '' then
    raise Exception.Create(AName + ': Eingabe ist leer');

  if T[1] = '-' then
    raise Exception.Create(AName + ': Wert darf nicht negativ sein');

  // Normalisieren: Komma wird zu Punkt
  T := StringReplace(T, ',', '.', [rfReplaceAll]);

  // Split an Punkt
  P := Pos('.', T);
  if P > 0 then
  begin
    IntPart := Copy(T, 1, P-1);
    FracPart := Copy(T, P+1, Length(T));
  end
  else
  begin
    IntPart := T;
    FracPart := '';
  end;

  if IntPart = '' then IntPart := '0';

  // Nur Ziffern erlauben
  for I := 1 to Length(IntPart) do
    if not (IntPart[I] in ['0'..'9']) then
      raise Exception.Create(AName + ': Ungültige Zahl "' + S + '"');

  for I := 1 to Length(FracPart) do
    if not (FracPart[I] in ['0'..'9']) then
      raise Exception.Create(AName + ': Ungültige Zahl "' + S + '"');

  // Exakt ADecimals Nachkommastellen verlangen
  if Length(FracPart) <> ADecimals then
    raise Exception.Create(AName + ': Erwartet genau ' + IntToStr(ADecimals) +
      ' Nachkommastellen (z.B. 1.' + StringOfChar('0', ADecimals) + ')');

  Scale := Trunc(IntPower(10, ADecimals));
  Result := StrToInt64(IntPart) * Scale;

  if ADecimals > 0 then
    Result := Result + StrToInt64(FracPart);
end;

function ParseScaledIntExactOneOf(const S: string; const ADecimals1, ADecimals2: Integer; const AName: string): Int64;
var
  T: string;
  P: Integer;
  FracLen: Integer;
begin
  T := Trim(S);
  if T = '' then
    raise Exception.Create(AName + ': Eingabe ist leer');

  if T[1] = '-' then
    raise Exception.Create(AName + ': Wert darf nicht negativ sein');

  T := StringReplace(T, ',', '.', [rfReplaceAll]);

  P := Pos('.', T);
  if P > 0 then
    FracLen := Length(T) - P
  else
    FracLen := 0;

  if not ((FracLen = ADecimals1) or (FracLen = ADecimals2)) then
    raise Exception.Create(AName + ': Erwartet genau ' + IntToStr(ADecimals1) +
      ' oder ' + IntToStr(ADecimals2) + ' Nachkommastellen.');

  // Wir speichern auf drei Dezimalstellen skaliert (ml).
  if FracLen = 2 then
    Result := ParseScaledIntExact(T + '0', 3, AName)
  else
    Result := ParseScaledIntExact(T, 3, AName);
end;

// ----------------
// Oeffentliche Wrapper

function ParseEuroToCents(const S: string): Int64;
begin
  // Exakt zwei Nachkommastellen
  Result := ParseScaledIntExact(S, 2, 'EUR');
end;

function ParseEurPerLiterToMilli(const S: string): Int64;
begin
  // Exakt drei Nachkommastellen
  Result := ParseScaledIntExact(S, 3, 'EUR/L');
end;

function ParseLitersToMl(const S: string): Int64;
begin
  // P-020: Liter muessen > 0 sein; ungueltige Werte (z. B. NaN) sind Hard Error.
  try
    Result := ParseScaledIntExactOneOf(S, 2, 3, 'Liter');
  except
    on E: Exception do
      raise Exception.Create('P-020: liters <= 0 oder NaN.');
  end;

  if Result <= 0 then
    raise Exception.Create('P-020: liters <= 0 oder NaN.');
end;
end.
