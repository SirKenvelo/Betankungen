{
  Betankungen.lpr
  ---------------------------------------------------------------------------
  CREATED: 2026-01-19
  UPDATED: 2026-02-20
  AUTHOR : Christof Kempinski
  Haupteinstiegspunkt und Kommandozeilen-Schnittstelle (CLI) der
  Betankungs-Verwaltung.

  Verantwortlichkeiten:
  - CLI-Steuerung: ParseCommand (Parsing + Regelpruefung) und
    Steuerung des Programmflusses (Hinzufuegen, Auflisten, Bearbeiten, Loeschen).
  - Demo-Datenbank: Erstellen/aktualisieren der Demo-DB (--seed) und Nutzung
    der Demo-DB fuer einen Lauf (--demo).
  - Konfigurations-Management: XDG-konforme Persistenz von DB-Pfaden per INI
    sowie direkte Speicherung via --db-set.
  - Zustandspruefung: Exklusivitaet von Kommandos, Konfliktpruefung bei DB-Optionen
    sowie Validierung erforderlicher Argumente (ParseCommand).
  - Abhaengigkeitsinjektion: Initialisierung der Datenbankverbindung und
    Weitergabe des Pfad-Kontexts an die zustaendigen Fachmodule.
  - Help-Delegation: Weitergabe von Usage/Help/About/FailUsage an `u_cli_help`
    (inkl. Fokus-Mapping ueber `TErrorFocus` aus `u_cli_types`).
  - Typkonsistenz: Nutzung zentraler CLI-Typen aus `u_cli_types`
    (TCommand, TCommandKind, TTableKind, TErrorFocus).
  - Statistik-Dispatch: Weiterleitung von Zeitraum-, Monats- und Jahresoptionen
    fuer `--stats fuelups` (Text/Dashboard/JSON/CSV, JSON optional pretty).

  Betriebsmodi:
  - Bootstrap-Modus: Aufruf ohne Argumente initialisiert fehlende Config/DB still.
  - Interaktiver Fallback-Modus: Pfadabfrage nur bei nicht nutzbarem DB-Pfad.
  - Automatisierter Modus: Direkte Ausfuehrung ueber Schalter fuer Skripte/Fortgeschrittene.
  - Diagnose-Modus: Integrierte Hilfe- und Konfigurationsanzeige (--show-config).
  - Meta-Modus: Ausgabe von Hilfe (--help), Version (--version) und About (--about).
  - Trace-Modus: Einfache Laufzeitmeldungen ueber --trace.
  - Demo-Modus: Nutzung einer separaten Demo-DB (--demo) oder Aufbau per --seed.

  Tabellen / Operationen:
  - Stations: hinzufuegen/auflisten/bearbeiten/loeschen
  - Fuelups: hinzufuegen/auflisten (nur anhaengen)

  Design-Entscheidungen:
  - Minimalismus: Das Hauptprogramm enthaelt keine SQL-Statements oder
    Berechnungslogik; es fungiert rein als Weiterleiter.
  - Zustandszentriert: Parserzustand liegt in `TCommand` und steuert
    Validierung, Meta-Pfade und Fach-Dispatch deterministisch.
  - Fehlersicherheit: Verwendung von EXIT_* bei Parametrierungsfehlern zur
    Unterstuetzung von Shell-Verarbeitungsketten.
  - Ausgabe-Trennung: Help/Usage/About-Textbausteine liegen ausserhalb des
    Orchestrators in `u_cli_help`; Parsing/Regelwerk in `u_cli_parse`.

  Exit-Codes:
  - 0 OK
  - 1 CLI / Argumentfehler
  - 2 Config / Datei / Pfad
  - 3 DB / SQL
  - 4 Unerwarteter Laufzeitfehler

  Exit-Code-Konstanten:
  - EXIT_OK = 0
  - EXIT_CLI = 1
  - EXIT_CONFIG = 2
  - EXIT_DB = 3
  - EXIT_UNEXPECTED = 4

  Konfigurationspfade (XDG):
  - Config-Datei: ~/.config/Betankungen/config.ini
  - Standard-DB:  ~/.local/share/Betankungen/betankungen.db
  - Demo-DB:      ~/.local/share/Betankungen/betankungen_demo.db
  ---------------------------------------------------------------------------
}
program Betankungen;

{$mode objfpc}{$H+}

uses
  SysUtils,
  IniFiles,
  u_db_init,
  u_db_seed,
  u_log,
  u_stations,
  u_fuelups,
  u_stats,
  u_cli_help,
  u_cli_types,
  u_cli_parse;

const
  EXIT_OK = 0;
  EXIT_CLI = 1;
  EXIT_CONFIG = 2;
  EXIT_DB = 3;
  EXIT_UNEXPECTED = 4;
  
  // Anwendungsmetadaten fuer --version/--about
  APP_NAME    = 'Betankungen';
  APP_VERSION = '0.5.6-0';
  APP_AUTHOR  = 'Christof Kempinski';

var
  // Pfad zur SQLite-Datenbank
  DbPath: string;
  WasCreated: boolean;
  NoCommandInitNeeded: boolean;
  CfgDbPath: string;

  // First-Run / Config-Status (0.5.4)
  CfgExisted: boolean;
  FirstRun: boolean;

  // Zentrales Parser-Ergebnis (Definition in u_cli_types).
  Cmd: TCommand;

  // ----------------
  // XDG-konformer Standard-DB-Pfad
  function GetDefaultDbPath: string;
  var
    BaseDir: string;
  begin
    BaseDir := ExpandFileName(GetUserDir + '.local/share/Betankungen');
    Result := BaseDir + PathDelim + 'betankungen.db';
  end;

  // XDG-konformer Konfigurationspfad
  function GetConfigPath: string;
  var
    CfgDir: string;
  begin
    CfgDir := ExpandFileName(GetUserDir + '.config/Betankungen');
    Result := CfgDir + PathDelim + 'config.ini';
  end;

  function LoadDbPathFromConfig(out APath: string): boolean;
  var
    Ini: TIniFile;
    Cfg: string;
  begin
    APath := '';
    Cfg := GetConfigPath;
    Result := FileExists(Cfg);
    if not Result then Exit;

    Ini := TIniFile.Create(Cfg);
    try
      APath := Ini.ReadString('database', 'path', '');
      Result := APath <> '';
    finally
      Ini.Free;
    end;
  end;

  procedure SaveDbPathToConfig(const APath: string);
  var
    Ini: TIniFile;
    CfgPath: string;
  begin
    CfgPath := GetConfigPath;
    ForceDirectories(ExtractFileDir(CfgPath));
    Ini := TIniFile.Create(CfgPath);
    try
      Ini.WriteString('database', 'path', APath);
    finally
      Ini.Free;
    end;
  end;

  procedure ShowConfigAndExit;
  var
    CfgPath, CfgDbPath, DefaultDb: string;
  begin
    CfgPath := GetConfigPath;
    DefaultDb := GetDefaultDbPath;

    WriteLn('--- Betankungen: Config-Status ---');
    WriteLn('Config-Datei:      ', CfgPath);
    WriteLn('Config existiert:   ', BoolToStr(FileExists(CfgPath), True));

    if LoadDbPathFromConfig(CfgDbPath) then
    begin
      CfgDbPath := ExpandFileName(CfgDbPath);
      WriteLn('Config DB-Pfad:     ', CfgDbPath);
      WriteLn('DB existiert:       ', BoolToStr(FileExists(CfgDbPath), True));
    end
    else
    begin
      WriteLn('Config DB-Pfad:     (nicht gesetzt)');
    end;

    WriteLn('Default DB-Pfad:    ', DefaultDb);
    WriteLn('Default existiert:  ', BoolToStr(FileExists(DefaultDb), True));
    WriteLn('---------------------------------');
    Halt(EXIT_OK);
  end;

  procedure ResetConfigAndExit;
  var
    CfgPath: string;
  begin
    CfgPath := GetConfigPath;

    if FileExists(CfgPath) then
    begin
      if DeleteFile(CfgPath) then
        WriteLn('Config geloescht: ', CfgPath)
      else
        FailUsage('Konnte Config nicht loeschen: ' + CfgPath, efMeta, EXIT_CONFIG);
    end
    else
      Msg('Keine Config vorhanden (nichts zu loeschen).');

    Msg('Hinweis: Die DB-Datei wurde NICHT geloescht.');
    Halt(EXIT_OK);
  end;

  // Interaktive Abfrage des DB-Pfads (Eingabetaste = Standard)
  // Hinweis: Validierung/Retry erfolgt in der Provisionierungs-Phase (EnsureDatabase-Loop).
  function AskDbPathInteractive: string;
  var
    DefaultPath: string;
    Input: string;
  begin
    DefaultPath := GetDefaultDbPath;

    WriteLn('DB-Pfad konnte nicht verwendet werden.');
    WriteLn('Bitte DB-Pfad angeben oder Enter fuer Default:');
    WriteLn('  Default: ', DefaultPath);
    Write('DB-Pfad> ');
    ReadLn(Input);

    Input := Trim(Input);
    if Input = '' then
      Result := DefaultPath
    else
      Result := ExpandFileName(Input);
  end;

  // Interaktiver Fallback mit persistenter Speicherung (inkl. Retry bei ungueltigem/unbeschreibbarem Pfad)
  procedure PromptAndPersistDbPath(out APath: string);
  var
    Candidate: string;
  begin
    while True do
    begin
      Candidate := AskDbPathInteractive;
      try
        ForceDirectories(ExtractFileDir(Candidate));
        SaveDbPathToConfig(Candidate);
        APath := Candidate;
        Exit;
      except
        on E: Exception do
        begin
          Msg('Warnung: DB-Pfad konnte nicht gespeichert werden: ' + Candidate);
          Msg('Grund: ' + E.Message);
        end;
      end;
    end;
  end;

  // Ermittelt den endgueltigen DB-Pfad in fester Prioritaet (db-set, db, demo/seed, config, default)
  // 0.5.4: Kein Prompt mehr im Normalfall. Prompt nur als Fallback wenn Provisionierung fehlschlaegt.
  function ResolveDbPath: string;
  var
    FromCfg: string;
    DefaultPath: string;
  begin
    // --db: nur fuer diesen Lauf
    if Cmd.DbOverride <> '' then
    begin
      Result := ExpandFileName(Cmd.DbOverride);
      ForceDirectories(ExtractFileDir(Result));
      Exit;
    end;

    // Demo-DB: explizit via --demo oder implizit via --seed
    if Cmd.UseDemoDb or (Cmd.HasCommand and (Cmd.Kind = ckSeed)) then
    begin
      Result := GetDefaultDemoDbPath;
      ForceDirectories(ExtractFileDir(Result));
      Exit;
    end;

    // Konfiguration
    if LoadDbPathFromConfig(FromCfg) then
    begin
      FromCfg := ExpandFileName(FromCfg);
      // 0.5.4: Config-Pfad immer akzeptieren, auch wenn DB (noch) nicht existiert.
      // Die DB wird spaeter automatisch angelegt.
      if (not FileExists(FromCfg)) then
        Msg('Hinweis: Konfiguration gefunden, aber DB-Datei existiert nicht (wird neu angelegt): ' + FromCfg);
      Result := FromCfg;
      ForceDirectories(ExtractFileDir(Result));
      Exit;
    end;

    // 0.5.4: Standardpfad immer verwenden (auch wenn DB noch nicht existiert)
    DefaultPath := GetDefaultDbPath;
    Result := DefaultPath;
    ForceDirectories(ExtractFileDir(Result));
    SaveDbPathToConfig(Result);
    FirstRun := True;
  end;

begin
  // 0.5.4: Kein Kommando + fehlender Bootstrap -> stille Initialisierung.
  // Deckt Erststart und "Config vorhanden, DB fehlt" ohne Prompt/Fehler ab.
  NoCommandInitNeeded := False;
  if ParamCount = 0 then
  begin
    if not LoadDbPathFromConfig(CfgDbPath) then
      NoCommandInitNeeded := True
    else
    begin
      CfgDbPath := ExpandFileName(CfgDbPath);
      NoCommandInitNeeded := not FileExists(CfgDbPath);
    end;
  end;

  if NoCommandInitNeeded then
  begin
    SetQuiet(True);
    try
      // identischer Flow wie im regulären Pfad, aber ohne Kommandopflicht
      try
        DbPath := ResolveDbPath;
      except
        on E: Exception do
        begin
          PromptAndPersistDbPath(DbPath);
          FirstRun := True;
        end;
      end;

      while True do
      begin
        try
          EnsureDatabase(DbPath);
          Break;
        except
          on E: Exception do
          begin
            PromptAndPersistDbPath(DbPath);
          end;
        end;
      end;

      Halt(EXIT_OK);
    except
      on E: Exception do
      begin
        FailUsage(E.Message, efNone, EXIT_UNEXPECTED);
      end;
    end;
  end;

  Cmd := ParseCommand;
  if Cmd.ErrorMsg <> '' then
    FailUsage(Cmd.ErrorMsg, Cmd.ErrorFocus);

  // Quiet zuerst, damit alles danach darauf reagiert
  SetQuiet(Cmd.Quiet);
  // Debug-Tabelle
  SetDebug(Cmd.Debug);
  // Trace explizit nur bei --trace
  SetTrace(Cmd.Trace);
  Dbg(
    'Cmd: Kind=' + IntToStr(Ord(Cmd.Kind)) +
    ' Target=' + IntToStr(Ord(Cmd.Target)) +
    ' Detail=' + BoolToStr(Cmd.Detail, True) +
    ' Json=' + BoolToStr(Cmd.Json, True) +
    ' Monthly=' + BoolToStr(Cmd.Monthly, True) +
    ' Yearly=' + BoolToStr(Cmd.Yearly, True) +
    ' Csv=' + BoolToStr(Cmd.Csv, True) +
    ' Dashboard=' + BoolToStr(Cmd.Dashboard, True) +
    ' Pretty=' + BoolToStr(Cmd.Pretty, True) +
    ' DbOverride=' + BoolToStr(Cmd.DbOverride <> '', True) +
    ' UseDemoDb=' + BoolToStr(Cmd.UseDemoDb, True)
  );

  if Cmd.Help then
  begin
    PrintUsage;
    Halt(EXIT_OK);
  end;

  if Cmd.Version then
  begin
    WriteLn('Betankungen ', APP_VERSION);
    Halt(EXIT_OK);
  end;

  if Cmd.About then
  begin
    PrintAbout(APP_NAME, APP_VERSION, APP_AUTHOR);
    Halt(EXIT_OK);
  end;

  if Cmd.DbSet <> '' then
  begin
    SaveDbPathToConfig(Cmd.DbSet);
    Msg('OK: DB-Pfad in der Konfiguration gespeichert.');
    Halt(EXIT_OK);
  end;

  if Cmd.ResetConfig then
    ResetConfigAndExit;

  if Cmd.ShowConfig then
    ShowConfigAndExit;

  // 0.5.4: First-Run Erkennung (vor ResolveDbPath)
  CfgExisted := FileExists(GetConfigPath);
  FirstRun := False;

  if Cmd.HasCommand and (Cmd.Kind = ckSeed) then
  begin
    DbPath := GetDefaultDemoDbPath;
    Dbg('Seed: Pfad=' + DbPath);
    Dbg(
      'Seed: stations=' + IntToStr(Cmd.SeedStations) +
      ' fuelups=' + IntToStr(Cmd.SeedFuelups) +
      ' seed_value=' + IntToStr(Cmd.SeedValue) +
      ' force=' + BoolToStr(Cmd.SeedForce, True)
    );
    try
      SeedDemoDatabase(DbPath, Cmd.SeedStations, Cmd.SeedFuelups, Cmd.SeedValue, Cmd.SeedForce);
      if Cmd.Quiet then
      begin
        // Maschinenfreundlich
        WriteLn(DbPath);
      end
      else
      begin
        Msg('OK: Demo-DB erstellt/aktualisiert');
        Msg('Pfad: ' + DbPath);
        Msg('Beispiel:');
        Msg('  Betankungen --db "' + DbPath + '" --list stations');
        Msg('Oder:');
        Msg('  Betankungen --demo --list stations');
      end;
      Halt(EXIT_OK);
    except
      on E: Exception do
        FailUsage('Fehler: ' + E.Message, efSeed);
    end;
  end;

  // DB-Pfad vorbereiten (Ueberschreibung hat Prio)
  // 0.5.4: ResolveDbPath kann IO ausloesen (ForceDirectories/Config schreiben).
  // Deshalb hier abfangen und auf Fallback-UX umleiten statt Hard-Crash.
  try
    DbPath := ResolveDbPath;
  except
    on E: Exception do
    begin
      // Bei explizitem --db niemals interaktiv werden
      if Cmd.DbOverride <> '' then
        FailUsage('Fehler: DB-Pfad nicht nutzbar: ' + ExpandFileName(Cmd.DbOverride) + ' (' + E.Message + ')', efDb);

      // Bei Demo-DB ebenfalls nicht interaktiv (reproduzierbar bleiben)
      if Cmd.UseDemoDb then
        FailUsage('Fehler: Demo-DB Pfad nicht nutzbar: ' + GetDefaultDemoDbPath + ' (' + E.Message + ')', efDemo);

      // Fallback: neuen Pfad abfragen + speichern
      Msg('Warnung: DB-Pfad konnte nicht vorbereitet werden.');
      Msg('Grund: ' + E.Message);
      PromptAndPersistDbPath(DbPath);
      FirstRun := True; // wir haben jetzt aktiv eine neue Config geschrieben
    end;
  end;

  if Cmd.UseDemoDb and (not FileExists(DbPath)) then
    FailUsage('Fehler: Demo-DB nicht gefunden. Bitte zuerst "Betankungen --seed" ausführen.', efDemo);

  try
    // Datenbank sicherstellen und initialisieren
    // 0.5.4: Prompt nur als Fallback (wenn Provisionierung fehlschlaegt) + Retry-Loop
    while True do
    begin
      try
        WasCreated := EnsureDatabase(DbPath);
        Break;
      except
        on E: Exception do
        begin
          // Bei explizitem --db niemals interaktiv werden
          if Cmd.DbOverride <> '' then
            FailUsage('Fehler: DB-Pfad nicht nutzbar: ' + DbPath + ' (' + E.Message + ')', efDb);

          // Bei Demo-DB ebenfalls nicht interaktiv (soll reproduzierbar bleiben)
          if Cmd.UseDemoDb then
            FailUsage('Fehler: Demo-DB Pfad nicht nutzbar: ' + DbPath + ' (' + E.Message + ')', efDemo);

          // Fallback: neuen Pfad abfragen + speichern + erneut versuchen
          Msg('Warnung: DB konnte nicht angelegt/geoeffnet werden: ' + DbPath);
          Msg('Grund: ' + E.Message);
          PromptAndPersistDbPath(DbPath);
          // danach retry
        end;
      end;
    end;

    // 0.5.4: Einmalige Erststart-Meldung (nur wenn Config neu angelegt wurde)
    // (CfgExisted ist vor ResolveDbPath gesetzt; FirstRun wird in ResolveDbPath gesetzt)
    if (not Cmd.Quiet) and (not CfgExisted) and FirstRun then
    begin
      Msg('Erststart: Config angelegt: ' + GetConfigPath);
      Msg('Erststart: DB: ' + ExpandFileName(DbPath));
      Msg('Tipp: Betankungen --help');
    end;

    // ----------------
    // Weiterleitung
    case Cmd.Target of
      tkStations:
        case Cmd.Kind of
          ckAdd: AddStationInteractive(DbPath);
          ckList: ListStations(DbPath, Cmd.Detail);
          ckEdit: EditStationInteractive(DbPath);
          ckDelete: DeleteStationInteractive(DbPath);
        else
          FailUsage('Interner Fehler: Ungültiges stations-Kommando.');
        end;

      tkFuelups:
        case Cmd.Kind of
          ckAdd: AddFuelupInteractive(DbPath);
          ckList: ListFuelups(DbPath, Cmd.Detail);
          ckStats:
            begin
              if Cmd.Csv then
                ShowFuelupStatsCsv(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.Monthly)
              else if Cmd.Json then
                ShowFuelupStatsJson(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.Monthly,
                  Cmd.Yearly,
                  Cmd.Pretty)
              else
              begin
                if Cmd.Dashboard then
                  ShowFuelupDashboard(DbPath,
                    Cmd.PeriodEnabled,
                    Cmd.PeriodFromIso,
                    Cmd.PeriodToExclIso,
                    Cmd.FromProvided,
                    Cmd.ToProvided,
                    Cmd.Monthly)
                else
                  ShowFuelupStats(DbPath,
                    Cmd.PeriodEnabled,
                    Cmd.PeriodFromIso,
                    Cmd.PeriodToExclIso,
                    Cmd.FromProvided,
                    Cmd.ToProvided,
                    Cmd.Monthly,
                    Cmd.Yearly);
              end;
            end;
        else
          FailUsage('Interner Fehler: Ungültiges fuelups-Kommando.');
        end;
    else
      FailUsage('Interner Fehler: Unbekannter Target.');
    end;

    // ----------------
    // Statusausgabe
    // Nur melden, wenn die DB wirklich neu angelegt wurde.
    
    if (not Cmd.Debug) and WasCreated then
      Msg('Datenbank angelegt');

    // ----------------
    // Debug-Tabelle (nur bei Debug)
    if Cmd.Debug and (not Cmd.Quiet) then
    begin
      WriteLn('');
      DbgSep;
      DbgRow('Key', 'Value');
      DbgSep;
      DbgRow('DB-Pfad', ExpandFileName(DbPath));
      DbgRow('schema_version', ReadMetaValue(DbPath, 'schema_version'));
      DbgRow('app_name', ReadMetaValue(DbPath, 'app_name'));
      DbgRow('db_created_at', ReadMetaValue(DbPath, 'db_created_at'));
      DbgRow('db_last_run', ReadMetaValue(DbPath, 'db_last_run'));
      DbgRow('odometer_start_km', ReadMetaValue(DbPath, 'odometer_start_km'));
      DbgRow('odometer_start_date', ReadMetaValue(DbPath, 'odometer_start_date'));
      DbgSep;
    end;

  except
    on E: Exception do
    begin
      FailUsage(E.Message, efNone, EXIT_UNEXPECTED);
    end;
  end;
end.
