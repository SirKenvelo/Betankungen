{
  u_cli_help.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-03-10
  AUTHOR : Christof Kempinski
  Zentrale Help-/Usage-/About-Ausgabe fuer die CLI.

  Verantwortlichkeiten:
  - Rendert den strukturierten Voll-Help-Text fuer die CLI.
  - Bietet einen Kompatibilitaets-Alias `PrintUsage` auf `PrintHelp`.
  - Rendert eine kurze, kontextsensitive One-Line-Usage fuer Fehlerpfade.
  - Rendert die About-Ausgabe (inkl. Danksagung).
  - Bietet einen einheitlichen FailUsage-Pfad mit Fokus-Mapping.

  Design-Entscheidungen:
  - Nutzt `TErrorFocus` aus `u_cli_types` als Single Source of Truth
    fuer kontextsensitiven Usage-Fokus.
  - Enthaelt nur Ausgabe-/Exit-Logik, keine Parser- oder Fachlogik.
  ---------------------------------------------------------------------------
}

unit u_cli_help;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, u_cli_types;

// Vollstaendige Usage-Ausgabe.
procedure PrintUsage(const FocusFlag: string = '');
// Kurz-Usage fuer Fehlerpfad (1 Zeile, kontextsensitiv).
procedure PrintUsageShort(const Focus: TErrorFocus = efNone);
// Alias fuer PrintUsage (Kompatibilitaet/Lesbarkeit).
procedure PrintHelp;
// About-Ausgabe inkl. Danksagung.
procedure PrintAbout(const AppName, AppVersion, AppAuthor: string);
// Standardisierter Fehlerpfad (Fehler + kontextbezogene Usage + Exit).
procedure FailUsage(const Msg: string; const Focus: TErrorFocus = efNone; ExitCode: Integer = 1);

implementation

procedure PrintUsage(const FocusFlag: string = '');
begin
  // Kompatibilitaets-Alias: Voll-Help sitzt in PrintHelp.
  // FocusFlag wird hier absichtlich ignoriert (Voll-Help ist fix strukturiert).
  PrintHelp;
end;

procedure PrintUsageShort(const Focus: TErrorFocus = efNone);
var
  FocusFlag: string;
begin
  // Genau 1 Zeile im Fehlerpfad (damit FailUsage insgesamt 3 Zeilen bleibt).
  FocusFlag := ErrorFocusToFlag(Focus);

  if FocusFlag = '--seed' then
    Writeln('Usage: Betankungen --seed [--stations N] [--fuelups N] [--seed-value N] [--force]')
  else if FocusFlag = '--car-id' then
    Writeln('Usage: Betankungen --add fuelups [--car-id <id>] | --list fuelups [--car-id <id>] | --stats fuelups [--car-id <id>] (required for multiple cars) | --edit cars --car-id <id> | --delete cars --car-id <id>')
  else if FocusFlag = '--db-set' then
    Writeln('Usage: Betankungen --db-set <pfad>')
  else if FocusFlag = '--stats' then
    Writeln('Usage: Betankungen --stats fuelups [--car-id <id>] [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--monthly] [--yearly] [--dashboard] [--json [--pretty]] [--csv] | --stats fleet [--json [--pretty]]')
  else if (FocusFlag = '--from') then
    Writeln('Usage: Betankungen --stats fuelups [--car-id <id>] [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--monthly] [--yearly] [--dashboard] [--json [--pretty]] [--csv]')
  else if FocusFlag = '--db' then
    Writeln('Usage: Betankungen [--db <pfad>|--demo] <command> [options]')
  else if FocusFlag = '--demo' then
    Writeln('Usage: Betankungen --demo <command> [options]')
  else if (FocusFlag = '--add') or (FocusFlag = '--list') then
    Writeln('Usage: Betankungen --add|--list stations|fuelups|cars [--db <pfad>|--demo] [--detail] [--debug|--trace|--quiet]')
  else if FocusFlag = '--about' then
    Writeln('Usage: Betankungen --about')
  else
    Writeln('Usage: Betankungen [--db <pfad>|--demo] <command> [options]');
end;

procedure PrintHelp;
  procedure Sec(const Title: string);
  begin
    Writeln;
    Writeln(Title, ':');
  end;

  procedure Line(const S: string);
  begin
    Writeln(S);
  end;

  procedure Item(const Left, Right: string);
  begin
    // Kleine Formatierungshilfe: links Flag, rechts Mini-Halbsatz.
    Writeln('  ', Left:20, ' ', Right);
  end;

begin
  Line('Betankungen – CLI-Tool zur Verwaltung von Tankstellen und Betankungen (SQLite).');

  Sec('Usage');
  Line('  Betankungen [--db <pfad>|--demo] <command> [options]');
  Line('  Betankungen --db-set <pfad>');
  Line('  Betankungen --seed [--stations N] [--fuelups N] [--seed-value N] [--force]');
  Line('  Betankungen --help | --version | --about');

  Sec('Commands');
  Item('--add stations|fuelups|cars','Datensatz interaktiv erfassen.');
  Item('--list stations|fuelups|cars','Auflisten (optional mit --detail).');
  Item('--edit stations|cars',       'Datensatz bearbeiten (fuelups ist verboten).');
  Item('--delete stations|cars',     'Datensatz loeschen (fuelups ist verboten).');
  Item('--stats fuelups|fleet',      'Auswertung fuer fuelups oder aggregierte Fleet-Basis (MVP, Text/JSON).');
  Item('--seed',                     'Demo-DB erzeugen/auffuellen (exklusiv).');
  Item('--about',                    'Projekt-/Autor-Informationen anzeigen.');
  Item('--help',                     'Voll-Help anzeigen und beenden.');
  Item('--version',                  'Versionsausgabe anzeigen und beenden.');

  Sec('Common options');
  Item('--db <pfad>',                'DB nur fuer diesen Lauf (nicht mit --db-set).');
  Item('--demo',                     'Demo-DB fuer diesen Lauf (nicht mit --seed).');
  Item('--car-id <id>',              'Bei --add/--list/--stats fuelups sowie --edit/--delete cars; fuer fuelups Pflicht bei mehreren Fahrzeugen.');
  Item('--detail',                   'Detailausgabe fuer Listen.');

  Sec('Advanced options');
  Item('--db-set <pfad>',            'DB-Pfad speichern und beenden (nicht mit --db).');
  Item('--show-config',              'Konfiguration anzeigen und beenden.');
  Item('--reset-config',             'Konfiguration zuruecksetzen und beenden.');
  Item('--debug',                    'Debug-Logging aktivieren.');
  Item('--trace',                    'Verbose Trace-Logging aktivieren.');
  Item('--quiet',                    'Ausgaben reduzieren (Fehler bleiben sichtbar).');

  Sec('Stats options');
  Item('--from <YYYY-MM|YYYY-MM-DD>','Startzeitraum (nur bei --stats fuelups).');
  Item('--to <YYYY-MM|YYYY-MM-DD>',  'Endzeitraum (nur fuelups; exklusive Obergrenze).');
  Item('--monthly',                  'Monatliche Aggregation (nur fuelups; nicht mit --yearly).');
  Item('--yearly',                   'Jaehrliche Aggregation (nur fuelups; nicht mit --monthly/--csv/--dashboard).');
  Item('--json',                     'JSON-Ausgabe (fuelups/fleet).');
  Item('--pretty',                   'Pretty-JSON (nur zusammen mit --json; fuelups/fleet).');
  Item('--csv',                      'CSV-Ausgabe (nur fuelups; nicht mit --json; nicht bei --yearly).');
  Item('--dashboard',                'Kompakt-Dashboard (nur fuelups; nicht mit --json/--csv; nicht bei --yearly).');

  Sec('Examples');
  Line('  Betankungen --add stations');
  Line('  Betankungen --add cars');
  Line('  Betankungen --add fuelups');
  Line('  Betankungen --add fuelups --car-id 1');
  Line('  Betankungen --list fuelups --car-id 1');
  Line('  Betankungen --list cars --detail');
  Line('  Betankungen --edit cars --car-id 2');
  Line('  Betankungen --delete cars --car-id 3');
  Line('  Betankungen --list fuelups --detail');
  Line('  Betankungen --stats fuelups');
  Line('  Betankungen --stats fuelups --from 2025-01 --to 2025-03');
  Line('  Betankungen --stats fuelups --monthly');
  Line('  Betankungen --stats fuelups --json --monthly');
  Line('  Betankungen --stats fuelups --yearly');
  Line('  Betankungen --stats fuelups --json --pretty --yearly');
  Line('  Betankungen --stats fleet');
  Line('  Betankungen --stats fleet --json --pretty');
  Line('  Betankungen --seed --fuelups 400 --force');
end;

procedure PrintAbout(const AppName, AppVersion, AppAuthor: string);
begin
  Writeln(AppName, ' ', AppVersion);
  Writeln('Autor: ', AppAuthor);
  Writeln('');
  Writeln('Danksagung:');
  Writeln('  Mein besonderer Dank waehrend der Entwicklungsphase geht an:');
  Writeln('  CFO Cookie - meine 2 Jahre alte Shih-Tzu-Huendin.');
  Writeln('  Mit ihrer Art hat sie mir oft mentale und konstruktive');
  Writeln('  Unterstuetzung gegeben: mal ablenkend, mal erdend, aber');
  Writeln('  vor allem mit viel Zuwendung auch in stressigen Phasen.');
end;

procedure FailUsage(const Msg: string; const Focus: TErrorFocus = efNone; ExitCode: Integer = 1);
var
  Line: string;
begin
  // 3-Zeilen-Standard:
  // 1) Fehler
  // 2) Kontext-Usage (1 Zeile)
  // 3) Tipp
  Line := Trim(Msg);
  if Line = '' then
    Line := 'Unbekannter Fehler.';
  if (Pos('Fehler:', Line) <> 1) and (Pos('Interner Fehler:', Line) <> 1) then
    Line := 'Fehler: ' + Line;

  Writeln(StdErr, Line);
  PrintUsageShort(Focus);
  Writeln(StdErr, 'Tipp: Betankungen --help');
  Halt(ExitCode);
end;

end.
