{
  u_painter.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-04-08
  UPDATED: 2026-04-08
  AUTHOR : Christof Kempinski
  Kleine Painter-Helfer fuer read-only Referenzscreens im Terminal.

  Verantwortlichkeiten:
  - Liefert leichte Layout-Helfer fuer Screen-Headlines und Fact-Lines.
  - Kapselt einfache Trennlinien und umbrochene Label/Value-Ausgabe.
  - Bleibt neutral und ohne eigene Fachlogik.

  Design-Entscheidungen:
  - ASCII-/Unicode-neutrale API; konkrete Zeichen werden vom Aufrufer gesetzt.
  - Nutzt vorhandene UTF-8-sichere Texthelfer aus `u_table`.
  - Fokus bewusst klein: nur die Helfer, die der erste Referenzscreen braucht.
  ---------------------------------------------------------------------------
}

unit u_painter;

{$mode objfpc}{$H+}

interface

procedure PaintHeading(const Width: Integer; const Eyebrow, Title, Meta: string);
procedure PaintRule(const Width: Integer; const FillChar: string = '─');
procedure PaintInlineFacts(const Width: Integer; const LeftText, RightText: string);
procedure PaintWrappedFact(const Width: Integer; const LabelText, ValueText: string);

implementation

uses
  SysUtils,
  StrUtils,
  u_table;

function ConsumeWrappedLine(var Remaining: string; const Width: Integer): string;
var
  Candidate: string;
  BreakPos: Integer;
begin
  Remaining := TrimLeft(Remaining);
  if Remaining = '' then
    Exit('');

  Candidate := Cut(Remaining, Width);
  if Candidate = Remaining then
  begin
    Result := Remaining;
    Remaining := '';
    Exit;
  end;

  if (Candidate <> '') and (Candidate[Length(Candidate)] = '…') then
    Delete(Candidate, Length(Candidate), 1);

  BreakPos := RPos(' ', Candidate);
  if BreakPos > 0 then
  begin
    Result := TrimRight(Copy(Candidate, 1, BreakPos - 1));
    Delete(Remaining, 1, BreakPos);
  end
  else
  begin
    Result := Candidate;
    Delete(Remaining, 1, Length(Candidate));
  end;

  Remaining := TrimLeft(Remaining);
end;

procedure PaintHeading(const Width: Integer; const Eyebrow, Title, Meta: string);
begin
  if Trim(Eyebrow) <> '' then
    WriteLn(Cut(Eyebrow, Width));
  if Trim(Title) <> '' then
    WriteLn(Cut(Title, Width));
  if Trim(Meta) <> '' then
    WriteLn(Cut(Meta, Width));
end;

procedure PaintRule(const Width: Integer; const FillChar: string = '─');
begin
  if Width <= 0 then
    Exit;
  WriteLn(DupeString(FillChar, Width));
end;

procedure PaintInlineFacts(const Width: Integer; const LeftText, RightText: string);
var
  LeftWidth, RightWidth: Integer;
  L, R: string;
begin
  if Trim(RightText) = '' then
  begin
    WriteLn(Cut(LeftText, Width));
    Exit;
  end;

  LeftWidth := (Width - 3) div 2;
  RightWidth := Width - LeftWidth - 3;

  L := PadR(Cut(LeftText, LeftWidth), LeftWidth);
  R := Cut(RightText, RightWidth);
  WriteLn(L + '   ' + R);
end;

procedure PaintWrappedFact(const Width: Integer; const LabelText, ValueText: string);
var
  Prefix, Continuation, Remaining, LineText: string;
  LineWidth: Integer;
  FirstLine: Boolean;
begin
  Prefix := LabelText + ': ';
  Continuation := StringOfChar(' ', Length(Prefix));
  Remaining := Trim(ValueText);
  FirstLine := True;

  repeat
    if FirstLine then
      LineWidth := Width - Length(Prefix)
    else
      LineWidth := Width - Length(Continuation);

    if LineWidth < 8 then
      LineWidth := 8;

    if Remaining = '' then
      LineText := '-'
    else
      LineText := ConsumeWrappedLine(Remaining, LineWidth);

    if FirstLine then
      WriteLn(Cut(Prefix + LineText, Width))
    else
      WriteLn(Cut(Continuation + LineText, Width));

    if Remaining = '' then
      Break;

    FirstLine := False;
  until False;
end;

end.
