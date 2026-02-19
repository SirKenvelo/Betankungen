{
  u_table.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Leichter Tabellen- und Textlayout-Renderer fuer die CLI.

  Verantwortlichkeiten:
  - Liefert Padding- und Cutting-Helfer fuer Textzellen.
  - Beruecksichtigt UTF-8-Sichtbreite fuer stabiles Layout.
  - Stellt mit TTable einen einfachen Tabellen-Builder bereit.

  Design-Entscheidungen:
  - Unicode-sicheres Cut/Padding anhand sichtbarer Zeichenlaenge.
  - Keine Farblogik: Ausgabe bleibt neutral und wiederverwendbar.
  - Kleine API fuer geringe Kopplung zu Fachmodulen.

  Verwendung:
  - PadR/PadL/Cut fuer Einzelzellen.
  - TTable fuer mehrzeilige, spaltenbasierte Konsolenausgabe.
  ---------------------------------------------------------------------------
}

unit u_table;

{$mode objfpc}{$H+}

interface

uses SysUtils,
     Math;

// Rechts auffuellen (linksbuendig darstellen).
function PadR(const S: string; W: Integer): string;
// Links auffuellen (rechtsbuendig darstellen).
function PadL(const S: string; W: Integer): string;
// Sichtbar auf Breite W kuerzen (mit Ellipse, falls noetig).
function Cut(const S: string; W: Integer): string;

type
  // Horizontale Ausrichtung je Spalte.
  TTextAlign = (taLeft, taRight);

  // Minimaler Tabellenrenderer fuer CLI-Listen/Reports.
  TTable = class
  private
    type
      TCol = record
        Title: string;
        Align: TTextAlign;
        Width: Integer;
      end;
      TRowKind = (rkRow, rkSep);
      TRow = record
        Kind: TRowKind;
        Cells: array of string;
      end;
    var
      FCols: array of TCol;
      FRows: array of TRow;
    procedure EnsureColCount(const Count: Integer);
    procedure UpdateWidths(const Cells: array of string);
    function PadCell(const S: string; W: Integer; Align: TTextAlign): string;
    function BuildLine(const SepChar: Char): string;
  public
    // Fuegt eine Spalte mit Titel und Ausrichtung hinzu.
    procedure AddCol(const Title: string; const Align: TTextAlign);
    // Fuegt eine Datenzeile hinzu (fehlende Zellen werden leer aufgefuellt).
    procedure AddRow(const Cells: array of string);
    // Fuegt eine horizontale Trennzeile ein.
    procedure AddSep;
    // Rendert die Tabelle auf STDOUT.
    procedure Write;
  end;

implementation

// ---------------------------------------------------------------------------
// UTF-8 helpers (sichtbare Laenge / Cut nach Codepoints)
//
// Warum:
// - Length(S) zaehlt Bytes, nicht sichtbare Zeichen.
// - Unicode-Zeichen wie '–', 'Ø', '…' sind mehrbyte -> Layout verrutscht.
// - Wir brauchen fuer Console-Layouts eine "visible width" in Codepoints.
//
// Hinweis:
// - Das ist kein vollstaendiger East-Asian-Width-Algorithmus (CJK double-width),
//   aber fuer unsere Zwecke (deutsch/latin, Boxdrawing, Ellipsis) ausreichend.
// ---------------------------------------------------------------------------

function Utf8CharLen(const B: Byte): Integer;
begin
  if (B and $80) = 0 then Exit(1);         // 0xxxxxxx
  if (B and $E0) = $C0 then Exit(2);       // 110xxxxx
  if (B and $F0) = $E0 then Exit(3);       // 1110xxxx
  if (B and $F8) = $F0 then Exit(4);       // 11110xxx
  Result := 1;                              // fallback
end;

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

function Utf8Cut(const S: string; W: Integer): string;
var
  I, N, Step, Count, CutPos: Integer;
begin
  if W <= 0 then Exit('');
  N := Length(S);
  I := 1;
  Count := 0;
  CutPos := 1;

  while (I <= N) and (Count < W) do
  begin
    Step := Utf8CharLen(Byte(S[I]));
    Inc(Count);
    Inc(I, Step);
    CutPos := I;
  end;

  // CutPos zeigt auf das Byte direkt nach dem letzten aufgenommenen Codepoint
  Result := Copy(S, 1, CutPos - 1);
end;

function Cut(const S: string; W: Integer): string;
begin
  if W <= 0 then Exit('');
  if Utf8VisibleLen(S) <= W then Exit(S);
  if W <= 1 then Exit(Utf8Cut(S, W));
  Result := Utf8Cut(S, W-1) + '…';
end;

function PadR(const S: string; W: Integer): string;
var T: string;
begin
  T := Cut(S, W);
  Result := T + StringOfChar(' ', Max(0, W - Utf8VisibleLen(T)));
end;

function PadL(const S: string; W: Integer): string;
var T: string;
begin
  T := Cut(S, W);
  Result := StringOfChar(' ', Max(0, W - Utf8VisibleLen(T))) + T;
end;

{ TTable }

procedure TTable.EnsureColCount(const Count: Integer);
var
  I: Integer;
begin
  if Length(FCols) >= Count then Exit;
  SetLength(FCols, Count);
  for I := 0 to High(FCols) do
    if FCols[I].Width = 0 then
      FCols[I].Width := Utf8VisibleLen(FCols[I].Title);
end;

procedure TTable.UpdateWidths(const Cells: array of string);
var
  I: Integer;
  L: Integer;
begin
  for I := 0 to High(Cells) do
  begin
    L := Utf8VisibleLen(Cells[I]);
    if L > FCols[I].Width then
      FCols[I].Width := L;
  end;
end;

function TTable.PadCell(const S: string; W: Integer; Align: TTextAlign): string;
begin
  if Align = taRight then
    Result := PadL(S, W)
  else
    Result := PadR(S, W);
end;

function TTable.BuildLine(const SepChar: Char): string;
var
  I: Integer;
begin
  Result := '+';
  for I := 0 to High(FCols) do
    Result := Result + StringOfChar(SepChar, FCols[I].Width + 2) + '+';
end;

procedure TTable.AddCol(const Title: string; const Align: TTextAlign);
var
  N: Integer;
begin
  N := Length(FCols);
  SetLength(FCols, N + 1);
  FCols[N].Title := Title;
  FCols[N].Align := Align;
  FCols[N].Width := Utf8VisibleLen(Title);
end;

procedure TTable.AddRow(const Cells: array of string);
var
  R: TRow;
  I, ColCount: Integer;
begin
  ColCount := Length(FCols);
  EnsureColCount(ColCount);
  R.Kind := rkRow;
  SetLength(R.Cells, ColCount);
  for I := 0 to ColCount - 1 do
  begin
    if I <= High(Cells) then
      R.Cells[I] := Cells[I]
    else
      R.Cells[I] := '';
  end;
  UpdateWidths(R.Cells);
  SetLength(FRows, Length(FRows) + 1);
  FRows[High(FRows)] := R;
end;

procedure TTable.AddSep;
var
  R: TRow;
begin
  R.Kind := rkSep;
  SetLength(R.Cells, 0);
  SetLength(FRows, Length(FRows) + 1);
  FRows[High(FRows)] := R;
end;

procedure TTable.Write;
var
  I, J: Integer;
  Line: string;
  R: TRow;
begin
  if Length(FCols) = 0 then Exit;

  Line := BuildLine('=');
  WriteLn(Line);

  Line := '|';
  for I := 0 to High(FCols) do
    Line := Line + ' ' + PadCell(FCols[I].Title, FCols[I].Width, FCols[I].Align) + ' |';
  WriteLn(Line);

  Line := BuildLine('-');
  WriteLn(Line);

  for I := 0 to High(FRows) do
  begin
    R := FRows[I];
    if R.Kind = rkSep then
    begin
      Line := BuildLine('=');
      WriteLn(Line);
      Continue;
    end;

    Line := '|';
    for J := 0 to High(FCols) do
      Line := Line + ' ' + PadCell(R.Cells[J], FCols[J].Width, FCols[J].Align) + ' |';
    WriteLn(Line);
  end;

  Line := BuildLine('-');
  WriteLn(Line);
end;

end.
