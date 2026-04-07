{
  u_cli_help.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-04-07
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
    Writeln('Usage: Betankungen --add fuelups [--car-id <id>] [--receipt-link <path|uri>] [--missed-previous] | --list fuelups [--car-id <id>] | --stats fuelups [--car-id <id>] (required for multiple cars) | --stats cost [--car-id <id>] [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--maintenance-source none|module] | --edit cars --car-id <id> | --delete cars --car-id <id>')
  else if (FocusFlag = '--receipt-link') or (FocusFlag = '--missed-previous') then
    Writeln('Usage: Betankungen --add fuelups [--car-id <id>] [--receipt-link <path|uri>] [--missed-previous]')
  else if FocusFlag = '--db-set' then
    Writeln('Usage: Betankungen --db-set <pfad>')
  else if FocusFlag = '--stats' then
    Writeln('Usage: Betankungen --stats fuelups [--car-id <id>] [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--monthly] [--yearly] [--dashboard] [--json [--pretty]] [--csv] | --stats fleet [--json [--pretty]] | --stats cost [--car-id <id>] [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--maintenance-source none|module] [--json [--pretty]]')
  else if FocusFlag = '--maintenance-source' then
    Writeln('Usage: Betankungen --stats cost [--car-id <id>] [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--maintenance-source none|module] [--json [--pretty]]')
  else if (FocusFlag = '--from') then
    Writeln('Usage: Betankungen --stats fuelups [--car-id <id>] [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--monthly] [--yearly] [--dashboard] [--json [--pretty]] [--csv] | --stats cost [--car-id <id>] [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--maintenance-source none|module] [--json [--pretty]]')
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
  Item('--stats fuelups|fleet|cost', 'Auswertung fuer fuelups, Fleet-MVP (Text/JSON) oder Cost-MVP (Text/JSON).');
  Item('--seed',                     'Demo-DB erzeugen/auffuellen (exklusiv).');
  Item('--about',                    'Projekt-/Autor-Informationen anzeigen.');
  Item('--help',                     'Voll-Help anzeigen und beenden.');
  Item('--version',                  'Versionsausgabe anzeigen und beenden.');

  Sec('Common options');
  Item('--db <pfad>',                'DB nur fuer diesen Lauf (nicht mit --db-set).');
  Item('--demo',                     'Demo-DB fuer diesen Lauf (nicht mit --seed).');
  Item('--car-id <id>',              'Bei --add/--list/--stats fuelups, --stats cost sowie --edit/--delete cars; bei >1 Cars Pflicht (IDs via --list cars).');
  Item('--receipt-link <path|uri>',  'Optionaler externer Beleg-Link (nur bei --add fuelups; lokale absolute Pfade werden als file:// gespeichert).');
  Item('--missed-previous',          'Expliziter Ausnahme-Opt-in fuer kleinen Distanz-Reset (`P-050`) bei --add fuelups.');
  Item('--detail',                   'Detailausgabe fuer Listen.');

  Sec('Car resolver (fuelups)');
  Line('  0 Cars ohne --car-id: Hard Error (zuerst --add cars).');
  Line('  1 Car ohne --car-id: automatische Auswahl.');
  Line('  >1 Cars ohne --car-id: Hard Error mit Hinweis auf --car-id und --list cars.');

  Sec('Fuelup input');
  Line('  Zu Beginn von --add fuelups wird der aktive Fahrzeugkontext explizit angezeigt.');
  Line('  Bei --add fuelups ist der Kilometerstand immer der aktuelle Gesamt-Kilometerstand');
  Line('  des Fahrzeugs (odometer_km), nicht die Strecke seit der letzten Tankung.');
  Line('  Wenn ein Receipt-Link gespeichert werden soll, muss --receipt-link vor dem Start');
  Line('  gesetzt werden; fuelups bleiben append-only und koennen spaeter nicht editiert werden.');
  Line('  Lokale absolute Receipt-Pfade werden vor dem Speichern auf einen kanonischen');
  Line('  file://-Wert normalisiert; fehlt die lokale Datei, folgt eine Warnung mit Confirm.');
  Line('  Normale kurze Distanzen loesen keine P-050-Rueckfrage mehr aus.');
  Line('  Nur mit --missed-previous wird bei kleiner Distanz ein expliziter Ausnahme-Reset');
  Line('  fuer missed_previous=1 mit bestaetigender Rueckfrage angeboten.');

  Sec('Advanced options');
  Item('--db-set <pfad>',            'DB-Pfad speichern und beenden (nicht mit --db).');
  Item('--show-config',              'Konfiguration anzeigen und beenden.');
  Item('--reset-config',             'Konfiguration zuruecksetzen und beenden.');
  Item('--debug',                    'Debug-Logging aktivieren.');
  Item('--trace',                    'Verbose Trace-Logging aktivieren.');
  Item('--quiet',                    'Ausgaben reduzieren (Fehler bleiben sichtbar).');

  Sec('Stats options');
  Item('--from <YYYY-MM|YYYY-MM-DD>','Startzeitraum (bei --stats fuelups und --stats cost).');
  Item('--to <YYYY-MM|YYYY-MM-DD>',  'Endzeitraum (fuelups/cost; exklusive Obergrenze).');
  Item('--maintenance-source <none|module>','Kostenquelle fuer Maintenance im Cost-Pfad (aktuell aktiv: none).');
  Item('--monthly',                  'Monatliche Aggregation (nur fuelups; nicht mit --yearly).');
  Item('--yearly',                   'Jaehrliche Aggregation (nur fuelups; nicht mit --monthly/--csv/--dashboard).');
  Item('--json',                     'JSON-Ausgabe (fuelups/fleet/cost).');
  Item('--pretty',                   'Pretty-JSON (nur zusammen mit --json; fuelups/fleet/cost).');
  Item('--csv',                      'CSV-Ausgabe (nur fuelups; nicht mit --json; nicht bei --yearly).');
  Item('--dashboard',                'Kompakt-Dashboard (nur fuelups; nicht mit --json/--csv; nicht bei --yearly).');

  Sec('Examples');
  Line('  Betankungen --add stations');
  Line('  Betankungen --add cars');
  Line('  Betankungen --add fuelups');
  Line('  Betankungen --add fuelups --car-id 1');
  Line('  Betankungen --add fuelups --car-id 1 --missed-previous');
  Line('  Betankungen --list cars');
  Line('  Betankungen --add fuelups --car-id 1 --receipt-link /data/receipts/2026-03-18.jpg');
  Line('  Betankungen --add fuelups --car-id 1 --receipt-link file:///data/receipts/2026-03-18.jpg');
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
  Line('  Betankungen --stats cost');
  Line('  Betankungen --stats cost --from 2025-01 --to 2025-03');
  Line('  Betankungen --stats cost --maintenance-source none');
  Line('  Betankungen --stats cost --maintenance-source module');
  Line('  Betankungen --stats cost --car-id 1 --from 2025-01');
  Line('  Betankungen --stats cost --json --pretty');
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
