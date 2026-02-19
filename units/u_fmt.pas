{
  u_fmt.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Zentrales Modul fuer CLI-Formatierung, Tabellenlayout und Dashboard-Rendering.

  Verantwortlichkeiten:
  - Fixed-Point-Formatter (Cents/ml/milli-EUR) fuer fachliche Ausgaben.
  - Tabellenrenderer fuer Fuelup-Listen inklusive Detailzeilen.
  - Unicode-Box-Engine fuer Dashboards und kompakte Statusbloecke.
  - Strikte CSV-Helfer fuer maschinenlesbare Zeilen.

  Design-Entscheidungen:
  - Int64-first: keine Float-Abhaengigkeit in den Kernformattern.
  - UTF-8-bewusste Layouthelfer fuer stabile Zeichenbreiten.
  - Trennung von Darstellung und Fachlogik.

  Hinweis:
  - Dezimaltrennzeichen ist bewusst fix ',' (locale-unabhaengig).
  ---------------------------------------------------------------------------
}

unit u_fmt;

{$mode objfpc}{$H+}

interface

uses SysUtils, u_table, StrUtils;

// ----------------
// Oeffentliche Formatter fuer fachliche Basiswerte.

// Wandelt Cents in EUR-Text (z. B. 1234 -> "12,34 EUR").
function FmtEuroFromCents(const V: Int64): string;
// Wandelt Milliliter in Liter-Text (z. B. 12345 -> "12,345 L").
function FmtLiterFromMl(const V: Int64): string;
// Wandelt milli-EUR in EUR/L-Text.
function FmtEurPerLiterFromMilli(const V: Int64): string;
// Wandelt 0/1 in "N"/"Y".
function FmtBoolYN(const V: Integer): string;
// Universeller Scaled-Integer-Formatter.
function FmtScaledInt(const V: Int64; const Decimals: Integer; const Suffix: string): string;


// ----------------
// CSV Helper (maschinenlesbar, strikt & simpel)

// Validiert Token fuer CSV (keine Kommas/Quotes/CRLF), gibt Token unveraendert zurueck
function CsvTokenStrict(const S: string): string;

// Baut eine CSV-Zeile aus Strings (Strings muessen bereits safe sein, z.B. via CsvTokenStrict)
function CsvJoin(const Values: array of string): string;

// Baut eine CSV-Zeile aus Int64 (reines IntToStr + Komma-Separierung)
function CsvJoinInt64(const Values: array of Int64): string;

// ----------------
// Prozeduren fuer die Tabellen-Ausgabe (CLI)

// Zeichnet den oberen Rahmen und die Spaltenueberschriften
procedure PrintFuelupHeader;

// Zeichnet den unteren Rahmen (Simple=True fuer durchgehende Linie ohne Spaltentrenner)
procedure PrintFuelupFooter(Simple: Boolean = False);

// Zeichnet eine einfache Trennlinie innerhalb der Tabelle
procedure PrintFuelupSeparator;

// Zeichnet eine dicke (doppelte) Trennlinie (fuer Standardansicht)
procedure PrintFuelupSeparatorDouble;

// Gibt eine einzelne Datensatz-Zeile formatiert aus
procedure PrintFuelupRow(
  const AId: Integer; 
  const AFueledAt: string; 
  const AOdometerKm: Int64; 
  const ALitersMl: Int64; 
  const APriceMilli: Int64; 
  const ATotalCents: Int64; 
  const AStation: string
);

// Gibt Detail-Informationen (Notizen, Adresse) unter einer Zeile aus
procedure PrintFuelupDetail(
  const AIsFull, AMissedPrevious: Boolean;
  const ACarName, AFuelType, APayment, APump, ANote, AAddress: string
);

// ----------------
// Unicode Box-Engine (Basis fuer Dashboards/kompakte Statusausgaben)

// Schreibt eine Unicode-Box-Kante (Top/Separator/Bottom) ueber die volle Breite.
procedure BoxTop(const Width: Integer);
procedure BoxSep(const Width: Integer);
procedure BoxBottom(const Width: Integer);

// Schreibt eine einzelne Box-Zeile. Text wird bei Bedarf abgeschnitten.
procedure BoxLine(const Width: Integer; const Text: string);

// ANSI-sichere Zeilenfunktion.
procedure BoxLineAnsi(const Width: Integer; const Text: string);

// Key/Value-Zeile ("Label: Value"). Label wird links ausgerichtet.
procedure BoxKV(const Width: Integer; const LabelText, ValueText: string);

// ----------------
// Dashboard-Bar (Kosten, optional farbig)

type
  TDashColorMode = (
    dcmStatic,   // absolute Schwellen in Cent
    dcmRelative  // relative Schwellen in Promille (bezogen auf MaxCents)
  );

// Schwellen und Darstellung (in Cent / Zeichen).
// Global gehalten fuer einfache Justierbarkeit ohne Rebuild der Aufruferlogik.
var
  // Farblogik
  DashColorMode: TDashColorMode = dcmRelative;

  // Statisch (Cent): nur genutzt, wenn DashColorMode = dcmStatic
  DashGreenMaxCents: Int64 = 50 * 100;
  DashYellowMaxCents: Int64 = 100 * 100;

  // Relativ (Promille): nur genutzt, wenn DashColorMode = dcmRelative
  // Default: 33% / 66%
  DashRelGreenMaxPermille: Integer = 333;
  DashRelYellowMaxPermille: Integer = 666;

  DashBarWidth: Integer = 12;
  DashUseColor: Boolean = True;
  DashUseUnicode: Boolean = True;

function ResolveDashColor(const Cents, MaxCents: Int64): string;
function RenderCostBar(const Cents, MaxCents: Int64): string;

// ----------------
// Farbkodierung

const
  // ANSI Escape Codes fuer Farben
  C_RESET  = #27 + '[0m';
  C_RED    = #27 + '[31m';
  C_GREEN  = #27 + '[32m';
  C_YELLOW = #27 + '[33m';
  C_CYAN   = #27 + '[36m';

const
  // Definition der Spaltenbreiten (Zeichenanzahl ohne Padding)
  COL_ID      = 3;
  COL_DATE    = 19;
  COL_KM      = 8;
  COL_LITER   = 10;
  COL_EUR_L   = 12;
  COL_TOTAL   = 10;
  COL_STATION = 26;

  // Anzahl der Daten-Spalten
  FUELUP_COLS = 7;

  // Berechnung der Gesamtbreite anhand Aussenraendern, Spaltenbreiten, Leerzeichen und Trennern
  FUELUP_TABLE_WIDTH = 2 + (COL_ID + 2) + (COL_DATE + 2) + (COL_KM + 2) + 
                       (COL_LITER + 2) + (COL_EUR_L + 2) + (COL_TOTAL + 2) + 
                       (COL_STATION + 2) + (FUELUP_COLS - 1);

  // Nutzbare Breite fuer Text-Details innerhalb der Box
  FUELUP_DETAIL_WIDTH = FUELUP_TABLE_WIDTH - 4;

implementation

const
  // Unicode Box-Zeichen (Mischung aus doppelten und einfachen Linien)
  U_HORIZ = '═'; U_VERT  = '║'; 
  U_TOP_L = '╔'; U_TOP_R = '╗'; U_T_DWN = '╦';
  U_BOT_L = '╚'; U_BOT_R = '╝'; U_B_UP  = '╩'; 
  U_CROSS = '╬'; U_L_T   = '╠'; U_R_T   = '╣';
  U_SEP_L = '╟'; U_SEP_R = '╢'; U_DASH  = '─';

// ----------------
// Farbentscheidung + Balken-Renderer (ohne Float)

function ResolveDashColor(const Cents, MaxCents: Int64): string;
var
  P: Integer;
  Num: Int64;
begin
  if not DashUseColor then
    Exit('');

  // Relative Mode: Farbe anhand Anteil von MaxCents
  if DashColorMode = dcmRelative then
  begin
    if MaxCents <= 0 then
      Exit(C_GREEN); // fallback: wenn kein Max, dann "harmlos"

    // P = round(Cents / MaxCents * 1000) in Promille, ohne Float
    Num := Cents * 1000;
    P := Integer((Num + (MaxCents div 2)) div MaxCents);

    if P <= DashRelGreenMaxPermille then
      Exit(C_GREEN)
    else if P <= DashRelYellowMaxPermille then
      Exit(C_YELLOW)
    else
      Exit(C_RED);
  end;

  // Static Mode: absolute Schwellen
  if Cents <= DashGreenMaxCents then
    Exit(C_GREEN)
  else if Cents <= DashYellowMaxCents then
    Exit(C_YELLOW)
  else
    Exit(C_RED);
end;

function RenderCostBar(const Cents, MaxCents: Int64): string;
var
  BarLen: Integer;
  Color, Ch: string;
  Num: Int64;
begin
  if (DashBarWidth <= 0) or (Cents <= 0) or (MaxCents <= 0) then
    Exit('');

  // Rundung ohne Float:
  // BarLen = round((Cents / MaxCents) * DashBarWidth)
  Num := Cents * Int64(DashBarWidth);
  BarLen := Integer((Num + (MaxCents div 2)) div MaxCents);

  if BarLen < 1 then BarLen := 1;
  if BarLen > DashBarWidth then BarLen := DashBarWidth;

  if DashUseUnicode then
    Ch := '█'
  else
    Ch := '#';

  Color := ResolveDashColor(Cents, MaxCents);
  if Color <> '' then
    Result := Color + DupeString(Ch, BarLen) + C_RESET
  else
    Result := DupeString(Ch, BarLen);
end;

// ----------------
// Unicode Box-Engine (generisch, wiederverwendbar)

function BoxInnerWidth(const Width: Integer): Integer;
begin
  // Layout: LeftBorder + Space + <content> + Space + RightBorder
  // => contentBreite = Width - 4
  Result := Width - 4;
  if Result < 0 then
    Result := 0;
end;

procedure BoxTop(const Width: Integer);
begin
  if Width <= 2 then
    WriteLn(U_TOP_L + U_TOP_R)
  else
    WriteLn(U_TOP_L + DupeString(U_HORIZ, Width - 2) + U_TOP_R);
end;

procedure BoxSep(const Width: Integer);
begin
  if Width <= 2 then
    WriteLn(U_L_T + U_R_T)
  else
    WriteLn(U_L_T + DupeString(U_HORIZ, Width - 2) + U_R_T);
end;

procedure BoxBottom(const Width: Integer);
begin
  if Width <= 2 then
    WriteLn(U_BOT_L + U_BOT_R)
  else
    WriteLn(U_BOT_L + DupeString(U_HORIZ, Width - 2) + U_BOT_R);
end;

procedure BoxLine(const Width: Integer; const Text: string);
var
  Inner: Integer;
  S: string;
begin
  Inner := BoxInnerWidth(Width);
  S := Cut(Text, Inner);
  WriteLn(U_VERT + ' ' + PadR(S, Inner) + ' ' + U_VERT);
end;

procedure BoxKV(const Width: Integer; const LabelText, ValueText: string);
var
  Inner, LabelW: Integer;
  L, V, S: string;
begin
  Inner := BoxInnerWidth(Width);

  // einfache Heuristik: Label links, Value rechts; Label bekommt ca. 40% der Innenbreite
  LabelW := Inner * 4 div 10;
  if LabelW < 8 then LabelW := 8;
  if LabelW > Inner - 3 then LabelW := Inner - 3;

  L := Cut(LabelText, LabelW);
  V := Cut(ValueText, Inner - LabelW - 2);

  // Format: "<label>: <value>"
  S := PadR(L, LabelW) + ': ' + V;
  BoxLine(Width, S);
end;

function StripAnsi(const S: string): string;
var
  I, N: Integer;
  InEsc: Boolean;
begin
  Result := '';
  N := Length(S);
  I := 1;
  InEsc := False;

  while I <= N do
  begin
    if (not InEsc) and (S[I] = #27) and (I < N) and (S[I+1] = '[') then
    begin
      InEsc := True;
      Inc(I, 2); // skip ESC[
      Continue;
    end;

    if InEsc then
    begin
      // ANSI sequence ends at 'm'
      if S[I] = 'm' then
        InEsc := False;
      Inc(I);
      Continue;
    end;

    Result := Result + S[I];
    Inc(I);
  end;
end;

function Utf8CharLen(const B: Byte): Integer;
begin
  if (B and $80) = 0 then Exit(1);         // 0xxxxxxx
  if (B and $E0) = $C0 then Exit(2);       // 110xxxxx
  if (B and $F0) = $E0 then Exit(3);       // 1110xxxx
  if (B and $F8) = $F0 then Exit(4);       // 11110xxx
  Result := 1;                              // fallback
end;

// ----------------
// TO-DO:
// lokal dupliziert, weil u_table helper nicht exportiert; 
// ggf. später nach u_textwidth extrahieren
function Utf8VisibleLen(const S: string): Integer;
var
  I, N, Step: Integer;
begin
  Result := 0;
  I := 1;
  N := Length(S);
  while I <= N do
  begin
    Step := Utf8CharLen(Byte(S[I]));
    Inc(I, Step);
    Inc(Result);
  end;
end;

function AnsiVisibleLen(const S: string): Integer;
begin
  // Wichtig: UTF-8 sichtbar zaehlen (Length() zaehlt Bytes!),
  // sonst verrutscht Padding bei Zeichen wie '█', 'Ø', '–', '…'
  Result := Utf8VisibleLen(StripAnsi(S));
end;

procedure BoxLineAnsi(const Width: Integer; const Text: string);
var
  Inner, Vis, Pad: Integer;
  S: string;
begin
  Inner := BoxInnerWidth(Width);

  // Wenn die sichtbare Laenge zu lang ist, lieber ANSI entfernen,
  // statt Escape-Sequenzen kaputt zu cutten.
  Vis := AnsiVisibleLen(Text);
  if Vis > Inner then
  begin
    BoxLine(Width, StripAnsi(Text));
    Exit;
  end;

  S := Text;
  Pad := Inner - Vis;
  if Pad > 0 then
    S := S + DupeString(' ', Pad);

  WriteLn(U_VERT + ' ' + S + ' ' + U_VERT);
end;

// Integer-basiertes Fixed-Point-Format (ohne Double/Rundung)
function FmtScaledInt(const V: Int64; const Decimals: Integer; const Suffix: string): string;
var
  AbsV, Scale, IntPart, FracPart: Int64;
  FracStr: string;
  Sign: string;

  // Ganzzahl-Potenz fuer Zehnerpotenzen (ohne Float-Konvertierung)
  function Pow10Int64(const N: Integer): Int64;
  var
    I: Integer;
    R: Int64;
  begin
    R := 1;
    for I := 1 to N do
      R := R * 10;
    Result := R;
  end;

begin
  if Decimals < 0 then
    raise Exception.Create('Decimals darf nicht negativ sein');

  AbsV := Abs(V);
  Scale := Pow10Int64(Decimals);

  IntPart := AbsV div Scale;
  FracPart := AbsV mod Scale;

  FracStr := IntToStr(FracPart);
  while Length(FracStr) < Decimals do
    FracStr := '0' + FracStr;

  if V < 0 then
    Sign := '-'
  else
    Sign := '';

  if Decimals = 0 then
    Result := Sign + IntToStr(IntPart) + ' ' + Suffix
  else
    Result := Sign + IntToStr(IntPart) + ',' + FracStr + ' ' + Suffix;
end;

// Formatiert Cents als EUR mit zwei Nachkommastellen
function FmtEuroFromCents(const V: Int64): string;
begin Result := FmtScaledInt(V, 2, 'EUR'); end;

// Formatiert Milliliter als Liter mit drei Nachkommastellen
function FmtLiterFromMl(const V: Int64): string;
begin Result := FmtScaledInt(V, 3, 'L'); end;

// Formatiert milli-EUR pro Liter mit drei Nachkommastellen
function FmtEurPerLiterFromMilli(const V: Int64): string;
begin Result := FmtScaledInt(V, 3, 'EUR/L'); end;

function FmtBoolYN(const V: Integer): string;
begin
  if V <> 0 then Result := 'Y' else Result := 'N';
end;

// ----------------
// CSV Helper (maschinenlesbar, strikt & simpel)

function CsvTokenStrict(const S: string): string;
begin
  // Strikt: Wir erlauben keinerlei CSV-Sonderzeichen, weil wir bewusst ohne Escaping arbeiten.
  if S = '' then
    raise Exception.Create('CsvTokenStrict: Token darf nicht leer sein');

  if (Pos(',', S) > 0) or (Pos('"', S) > 0) or (Pos(#10, S) > 0) or (Pos(#13, S) > 0) then
    raise Exception.Create('CsvTokenStrict: Token enthaelt unzulaessige CSV-Zeichen');

  Result := S;
end;

function CsvJoin(const Values: array of string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(Values) do
  begin
    if I > 0 then
      Result := Result + ',';
    Result := Result + Values[I];
  end;
end;

function CsvJoinInt64(const Values: array of Int64): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(Values) do
  begin
    if I > 0 then
      Result := Result + ',';
    Result := Result + IntToStr(Values[I]);
  end;
end;

{
  Zentrale Zeichenfunktion fuer horizontale Linien.
  IsSimple = True  -> Erzeugt eine durchgehende Linie (z. B. fuer Separatoren)
  IsSimple = False -> Beruecksichtigt die Spaltenbreiten fuer Kreuzungspunkte
}
procedure DrawLine(const Left, Cross, Right, Char: string; IsSimple: Boolean = False);
var
  s: string;
  function Fill(Len: Integer): string;
  begin 
    // DupeString sorgt dafuer, dass UTF-8 Zeichen korrekt wiederholt werden
    Result := DupeString(Char, Len + 2); 
  end;
begin
  if IsSimple then
    // DupeString statt StringOfChar verwenden
    s := Left + DupeString(Char, FUELUP_TABLE_WIDTH - 2) + Right
  else
    s := Left + Fill(COL_ID) + Cross + Fill(COL_DATE) + Cross + Fill(COL_KM) + Cross + 
         Fill(COL_LITER) + Cross + Fill(COL_EUR_L) + Cross + Fill(COL_TOTAL) + Cross + 
         Fill(COL_STATION) + Right;
  WriteLn(s);
end;

procedure PrintFuelupHeader;
begin
  // Obere Kante
  DrawLine(U_TOP_L, U_T_DWN, U_TOP_R, U_HORIZ);
  // Spaltentitel (Format: %-*s sorgt fuer Linksbundigkeit mit fester Breite)
  WriteLn(Format(U_VERT + ' %-*s ' + U_VERT + ' %-*s ' + U_VERT + ' %-*s ' + U_VERT + 
    ' %-*s ' + U_VERT + ' %-*s ' + U_VERT + ' %-*s ' + U_VERT + ' %-*s ' + U_VERT,
    [COL_ID, 'ID', COL_DATE, 'Datum', COL_KM, 'KM', COL_LITER, 'Liter', 
     COL_EUR_L, 'EUR/L', COL_TOTAL, 'Gesamt', COL_STATION, 'Stations']));
  // Trenner nach Header
  DrawLine(U_L_T, U_CROSS, U_R_T, U_HORIZ);
end;

procedure PrintFuelupFooter(Simple: Boolean = False);
begin
  if Simple then 
    DrawLine(U_BOT_L, '', U_BOT_R, U_HORIZ, True)
  else 
    DrawLine(U_BOT_L, U_B_UP, U_BOT_R, U_HORIZ);
end;

procedure PrintFuelupSeparator;
begin
  // Nutzt duenne Linie (DASH) innerhalb der dicken Box
  DrawLine(U_SEP_L, U_DASH, U_SEP_R, U_DASH, True);
end;

procedure PrintFuelupSeparatorDouble;
begin
  // Nutzt dicke Linie (HORIZ) mit dicken Kreuzungen (fuer Standard-Ansicht)
  DrawLine(U_L_T, U_CROSS, U_R_T, U_HORIZ, False);
end;

procedure PrintFuelupRow(const AId: Integer; const AFueledAt: string; const AOdometerKm, ALitersMl, APriceMilli, ATotalCents: Int64; const AStation: string);
begin
  // Zusammensetzen der Zeile mit Padding-Helfern aus u_table
  WriteLn(U_VERT, ' ', PadL(IntToStr(AId), COL_ID), ' ', 
          U_VERT, ' ', PadR(AFueledAt, COL_DATE), ' ', 
          U_VERT, ' ', PadL(IntToStr(AOdometerKm), COL_KM), ' ', 
          U_VERT, ' ', PadL(FmtLiterFromMl(ALitersMl), COL_LITER), ' ', 
          U_VERT, ' ', PadL(FmtEurPerLiterFromMilli(APriceMilli), COL_EUR_L), ' ', 
          U_VERT, ' ', PadL(FmtEuroFromCents(ATotalCents), COL_TOTAL), ' ', 
          U_VERT, ' ', PadR(AStation, COL_STATION), ' ', U_VERT);
end;

procedure PrintFuelupDetail(const AIsFull, AMissedPrevious: Boolean; const ACarName, AFuelType, APayment, APump, ANote, AAddress: string);
  // Lokale Hilfsfunktion zum Zeichnen einer Detail-Zeile
  function DetailLine(const S: string): string;
  begin 
    Result := U_VERT + ' ' + PadR(Cut(S, FUELUP_DETAIL_WIDTH), FUELUP_DETAIL_WIDTH) + ' ' + U_VERT; 
  end;
begin
  // Zusammenfassende Info-Zeile
  WriteLn(DetailLine(
    'Car: ' + ACarName +
    ' | Full: ' + FmtBoolYN(Ord(AIsFull)) +
    ' | MissPrev: ' + FmtBoolYN(Ord(AMissedPrevious)) +
    ' | Fuel: ' + AFuelType +
    ' | Pay: ' + APayment +
    ' | Pump: ' + APump
  ));
  
  // Optional: Notiz nur anzeigen, wenn Text vorhanden
  if Trim(ANote) <> '' then 
    WriteLn(DetailLine('Note: ' + ANote));

  // Adresse
  WriteLn(DetailLine('Addr: ' + AAddress));
end;

end.
