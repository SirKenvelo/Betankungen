{
  u_cli_types.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-03-18
  AUTHOR : Christof Kempinski
  Zentrale CLI-Typdefinitionen fuer Betankungen.

  Verantwortlichkeiten:
  - Definiert die kanonischen Enums fuer Kommando/Target/Fehlerfokus.
  - Definiert den Parser-Zustand (`TCommand`) als einheitliches
    Transportobjekt zwischen CLI-Parser und Orchestrator.
  - Stellt kleine Mapping-Helper bereit, um interne Enum-Werte
    in textuelle CLI-Token zu ueberfuehren.

  Design-Entscheidungen:
  - Single Source of Truth:
    CLI-Typen liegen ausschliesslich in dieser Unit, damit im
    Hauptprogramm keine Typduplikate und keine Drift entstehen.
  - Schlanker Parser-Transport:
    `TCommand` enthaelt nur Laufzeitdaten fuer Parsing/Validierung/
    Dispatch, keine Fach- oder DB-Logik.
  - Deterministischer Fehlerfokus:
    `TErrorFocus` kapselt "wohin die Hilfe zeigen soll", sodass
    Parser und Help-Ausgabe lose gekoppelt bleiben.

  Hinweis:
  - Bei neuen CLI-Flags oder Targets immer zuerst diese Unit erweitern
    und erst danach Parser/Usage/Dispatch anpassen.
  ---------------------------------------------------------------------------
}

unit u_cli_types;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  // Quelle fuer Maintenance-Kosten im Cost-Stats-Pfad.
  TMaintenanceSource = (
    // Core-only Modus (keine Maintenance-Integration).
    msNone,
    // Expliziter Integrationspfad via Companion-Modul.
    msModule
  );

  // Gueltige Datenziele der Hauptkommandos.
  // Wichtig: Kein tkNone, da der Orchestrator nur gueltige Targets
  // nach erfolgreichem Parsing weiterverarbeitet.
  TTableKind = (
    tkStations,
    tkFuelups,
    tkCars,
    tkFleet,
    tkCost
  );

  // Hauptkommandos der CLI.
  // Meta-Flags wie --help/--version/--about werden bewusst als
  // eigene Bool-Flags im TCommand gefuehrt (nicht als CommandKind).
  TCommandKind = (
    ckNone,
    ckAdd,
    ckList,
    ckEdit,
    ckDelete,
    ckSeed,
    ckStats
  );

  // Fehlerfokus fuer kontextsensitive Usage-Hinweise.
  // Dieser Enum wird bei Parser-Fehlern gesetzt und spaeter auf ein
  // passendes "Focus-Flag" (z. B. --db, --stats) gemappt.
  TErrorFocus = (
    // Kein spezifischer Fokus.
    efNone,
    // Fehler in der Auswahl des Hauptkommandos.
    efCommand,
    // Fehler bei stations/fuelups-Target.
    efTarget,
    // Fehler bei --car-id.
    efCarId,
    // Fehler bei --db.
    efDb,
    // Fehler bei --db-set.
    efDbSet,
    // Fehler bei --maintenance-source.
    efMaintenanceSource,
    // Fehler bei --receipt-link.
    efReceiptLink,
    // Fehler im Demo-Workflow.
    efDemo,
    // Fehler im Seed-Workflow.
    efSeed,
    // Allgemeiner Stats-Kontext.
    efStats,
    // Fehlerhafte Stats-Formatkombinationen (json/csv/dashboard/...).
    efStatsFormat,
    // Fehler in --from/--to Eingaben.
    efStatsPeriod,
    // Fehlerhafte Stats-Bereichslogik (z. B. from >= to).
    efStatsRange,
    // Meta-Kontext (z. B. --about).
    efMeta
  );

  // Zentrales Parser-Ergebnis.
  // Der Record wird in BuildCommand gefuellt und danach im
  // Hauptprogramm fuer Validierung, Meta-Pfade und Dispatch genutzt.
  TCommand = record
    // Hauptkommando + Ziel.
    Kind: TCommandKind;
    Target: TTableKind;
    HasCommand: boolean;

    // Ausgabe-/Stats-Flags.
    Detail: boolean;
    Json: boolean;
    Monthly: boolean;
    Yearly: boolean;
    Csv: boolean;
    Dashboard: boolean;
    Pretty: boolean;

    // Zeitraum-Status und normalisierte ISO-Grenzen.
    // PeriodFromIso: inklusiv, PeriodToExclIso: exklusiv.
    PeriodEnabled: boolean;
    FromProvided: boolean;
    ToProvided: boolean;
    PeriodFromIso: string;
    PeriodToExclIso: string;

    // Seed-/Demo-Parameter.
    SeedStations: integer;
    SeedFuelups: integer;
    SeedValue: integer;
    SeedForce: boolean;
    UseDemoDb: boolean;

    // Meta-Flags.
    Help: boolean;
    Version: boolean;
    About: boolean;
    ShowConfig: boolean;
    ResetConfig: boolean;

    // Laufzeitdiagnose.
    Debug: boolean;
    Trace: boolean;
    Quiet: boolean;

    // Datenbankoptionen.
    DbOverride: string;
    DbSet: string;
    CarId: integer;
    ReceiptLink: string;
    ReceiptLinkProvided: boolean;
    MaintenanceSource: TMaintenanceSource;
    MaintenanceSourceProvided: boolean;

    // Fehlertransport aus dem Parser.
    ErrorMsg: string;
    ErrorFocus: TErrorFocus;
  end;

// Enum -> Token Mapping fuer Targets.
// Rueckgabe ist leer fuer unbekannte/undefinierte Werte.
function TableKindToString(K: TTableKind): String;
// Enum -> Token Mapping fuer Hauptkommandos.
// Rueckgabe ist leer fuer ckNone.
function CommandKindToString(K: TCommandKind): String;
// Fehlerfokus -> bevorzugtes Focus-Flag fuer Usage-Ausgabe.
// Mehrere Enum-Werte duerfen auf dasselbe Flag mappen.
function ErrorFocusToFlag(F: TErrorFocus): String;
// Enum -> Token Mapping fuer Maintenance-Source.
function MaintenanceSourceToString(const S: TMaintenanceSource): String;

implementation

function TableKindToString(K: TTableKind): String;
begin
  // Kleines, stabiles Mapping fuer CLI-Token.
  case K of
    tkStations: Result := 'stations';
    tkFuelups : Result := 'fuelups';
    tkCars    : Result := 'cars';
    tkFleet   : Result := 'fleet';
    tkCost    : Result := 'cost';
  else
    Result := '';
  end;
end;

function CommandKindToString(K: TCommandKind): String;
begin
  // Nur echte Hauptkommandos liefern ein Token.
  case K of
    ckAdd:        Result := 'add';
    ckList:       Result := 'list';
    ckEdit:       Result := 'edit';
    ckDelete:     Result := 'delete';
    ckStats:      Result := 'stats';
    ckSeed:       Result := 'seed';
    ckNone:       Result := '';
  else
    Result := '';
  end;
end;

function ErrorFocusToFlag(F: TErrorFocus): String;
begin
  // Liefert das Flag, das fuer Hilfe/Usage am sinnvollsten ist.
  // Das Mapping ist bewusst pragmatisch und nicht 1:1.
  case F of
    efCarId:       Result := '--car-id';
    efDb:          Result := '--db';
    efDbSet:       Result := '--db-set';
    efMaintenanceSource: Result := '--maintenance-source';
    efReceiptLink: Result := '--receipt-link';
    efDemo:        Result := '--demo';
    efSeed:        Result := '--seed';
    efStats:       Result := '--stats';
    efStatsFormat: Result := '--stats';
    efStatsPeriod: Result := '--from';
    efStatsRange:  Result := '--from';
    efCommand:     Result := '--add';
    efTarget:      Result := '--list';
    efMeta:        Result := '--about';
  else
    Result := '';
  end;
end;

function MaintenanceSourceToString(const S: TMaintenanceSource): String;
begin
  case S of
    msNone: Result := 'none';
    msModule: Result := 'module';
  else
    Result := '';
  end;
end;

end.
