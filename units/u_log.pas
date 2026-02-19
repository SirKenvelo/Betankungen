{
  u_log.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Zentrale Logging- und Laufzeitdiagnose-Unit fuer die CLI.

  Verantwortlichkeiten:
  - Steuert Status-, Trace- und Debug-Ausgaben ueber globale Flags.
  - Liefert einheitliche Debug-Tabellenzeilen fuer technische Diagnosen.
  - Kapselt die Quiet-Policy als globales Ausgabe-Gate.

  Design-Entscheidungen:
  - Global Flags statt Context-Passing fuer geringe Integrationskosten.
  - Quiet priorisiert: unterdrueckt Status, Trace und Debug konsistent.
  - Schlanke API: bewusst klein, damit Aufrufer einfach bleiben.

  Verwendung:
  - Msg(): Statusmeldungen (respektiert Quiet).
  - Dbg(): Trace-Meldungen mit Prefix [TRC] (nur bei Trace).
  - DbgRow/DbgSep: strukturierte Debug-Tabellen (nur bei Debug).
  ---------------------------------------------------------------------------
}
unit u_log;

{$mode objfpc}{$H+}

interface

// ----------------
// Aktiviert oder deaktiviert Debug-Tabellen global
procedure SetDebug(Value: boolean);

// Aktiviert oder deaktiviert Trace-Ausgaben global
procedure SetTrace(Value: boolean);

// Unterdrueckt alle Ausgaben (Status, Trace, Debug)
procedure SetQuiet(Value: boolean);

// Normale Statusmeldung (respektiert Quiet)
procedure Msg(const S: string);

// Gibt eine einfache Trace-Nachricht aus (Prefix [TRC], respektiert Quiet)
procedure Dbg(const S: string);

// Gibt eine formatierte Tabellenzeile im Debug-Modus aus (respektiert Quiet)
procedure DbgRow(const Key, Value: string);

// Gibt eine Trennlinie fuer Debug-Tabellen aus (respektiert Quiet)
procedure DbgSep;

const
  // Spaltenbreiten fuer Debug-Tabellen
  COL_KEY = 20;
  COL_VAL = 60;

implementation

uses
  SysUtils,
  u_fmt;

var
  // Globaler Debug-Schalter (DbgRow/DbgSep)
  GDebug: boolean = False;

  // Globaler Trace-Schalter (Dbg)
  GTrace: boolean = False;

  // Globaler Quiet-Schalter (unterdrueckt alle Ausgaben)
  GQuiet: boolean = False;

procedure SetDebug(Value: boolean);
begin
  GDebug := Value;
end;

procedure SetQuiet(Value: boolean);
begin
  GQuiet := Value;
end;

procedure SetTrace(Value: boolean);
begin
  GTrace := Value;
end;

procedure Msg(const S: string);
begin
  if not GQuiet then
    WriteLn(S);
end;

procedure Dbg(const S: string);
begin
  if GQuiet then Exit;
  if GTrace then
    WriteLn('[TRC] ', S);
end;

procedure DbgRow(const Key, Value: string);
begin
  if GQuiet then Exit;
  if GDebug then
    WriteLn(Format('| %-*s | %-*s |', [COL_KEY, Key, COL_VAL, Value]));
end;

procedure DbgSep;
begin
  if GQuiet then Exit;
  if GDebug then
    WriteLn(
      C_CYAN + '+' + StringOfChar('-', COL_KEY + 2) + '+' +
      StringOfChar('-', COL_VAL + 2) + '+' + C_RESET
    );
end;

end.
