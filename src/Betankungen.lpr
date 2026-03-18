{
  Betankungen.lpr
  ---------------------------------------------------------------------------
  CREATED: 2026-01-19
  UPDATED: 2026-03-18
  AUTHOR : Christof Kempinski
  Haupteinstiegspunkt und Kommandozeilen-Schnittstelle (CLI) der
  Betankungs-Verwaltung.

  Verantwortlichkeiten:
  - CLI-Steuerung: ParseCommand (Parsing + Regelpruefung) und
    Steuerung des Programmflusses (Hinzufuegen, Auflisten, Bearbeiten, Loeschen).
  - Demo-Datenbank: Erstellen/aktualisieren der Demo-DB (--seed) und Nutzung
    der Demo-DB fuer einen Lauf (--demo).
  - Konfigurations-Management: XDG-konforme Persistenz von DB-Pfaden per INI
    sowie direkte Speicherung via --db-set; Sprach-Setting `language=de|en|pl`
    wird zentral in der Config mitgefuehrt.
  - Zustandspruefung: Exklusivitaet von Kommandos, Konfliktpruefung bei DB-Optionen
    sowie Validierung erforderlicher Argumente (ParseCommand).
  - Abhaengigkeitsinjektion: Initialisierung der Datenbankverbindung und
    Weitergabe des Pfad-Kontexts an die zustaendigen Fachmodule.
  - Help-Delegation: Weitergabe von Usage/Help/About/FailUsage an `u_cli_help`
    (inkl. Fokus-Mapping ueber `TErrorFocus` aus `u_cli_types`).
  - Typkonsistenz: Nutzung zentraler CLI-Typen aus `u_cli_types`
    (TCommand, TCommandKind, TTableKind, TErrorFocus).
  - Statistik-Dispatch: Weiterleitung von Zeitraum-, Monats- und Jahresoptionen
    fuer `--stats fuelups`, Fleet-MVP via `--stats fleet` und Cost-MVP
    (Text/JSON) via `--stats cost`.

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
  - Cars: hinzufuegen/auflisten/bearbeiten/loeschen

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
  u_fmt,
  u_stations,
  u_cars,
  u_fuelups,
  u_stats,
  u_i18n,
  u_cli_help,
  u_cli_types,
  u_cli_parse,
  u_cli_validate;

const
  EXIT_OK = 0;
  EXIT_CLI = 1;
  EXIT_CONFIG = 2;
  EXIT_DB = 3;
  EXIT_UNEXPECTED = 4;
  
  // Anwendungsmetadaten fuer --version/--about
  APP_NAME    = 'Betankungen';
  APP_VERSION = '1.1.0';
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

  function LoadLanguageFromConfig(out ALangCode: string): boolean;
  var
    Ini: TIniFile;
    Cfg: string;
    RawCode: string;
  begin
    ALangCode := '';
    Cfg := GetConfigPath;
    Result := FileExists(Cfg);
    if not Result then Exit;

    Ini := TIniFile.Create(Cfg);
    try
      RawCode := Ini.ReadString('ui', 'language', '');
      ALangCode := NormalizeLanguageCode(RawCode);
      Result := ALangCode <> '';
    finally
      Ini.Free;
    end;
  end;

  // Liest den Sprachkontext aus der Config und normalisiert auf `de|en|pl`.
  // Bei fehlendem/ungueltigem Eintrag wird `de` als Default gesetzt.
  procedure ApplyLanguageFromConfig;
  var
    CfgPath: string;
    Ini: TIniFile;
    RawCode: string;
    LangCode: string;
    PersistNeeded: Boolean;
  begin
    SetLanguage(DEFAULT_LANGUAGE);
    CfgPath := GetConfigPath;
    if not FileExists(CfgPath) then Exit;

    Ini := TIniFile.Create(CfgPath);
    try
      RawCode := Ini.ReadString('ui', 'language', '');
      LangCode := NormalizeLanguageCode(RawCode);
      PersistNeeded := False;

      if LangCode = '' then
      begin
        LangCode := DEFAULT_LANGUAGE_CODE;
        PersistNeeded := True;
      end
      else if RawCode <> LangCode then
        PersistNeeded := True;

      SetLanguageByCodeOrDefault(LangCode, DEFAULT_LANGUAGE);

      if PersistNeeded then
      begin
        try
          Ini.WriteString('ui', 'language', LangCode);
        except
          // Read-only Config ist kein Hard-Error fuer den Runtime-Flow.
        end;
      end;
    finally
      Ini.Free;
    end;
  end;

  procedure SaveDbPathToConfig(const APath: string);
  var
    Ini: TIniFile;
    CfgPath: string;
    LangCode: string;
  begin
    CfgPath := GetConfigPath;
    ForceDirectories(ExtractFileDir(CfgPath));
    Ini := TIniFile.Create(CfgPath);
    try
      Ini.WriteString('database', 'path', APath);
      // Sprachkontext bleibt zentral in derselben Config verankert.
      LangCode := NormalizeLanguageCode(Ini.ReadString('ui', 'language', ''));
      if LangCode = '' then
        LangCode := GetLanguageCode;
      Ini.WriteString('ui', 'language', NormalizeLanguageCodeOrDefault(LangCode));
    finally
      Ini.Free;
    end;
  end;

  procedure ShowConfigAndExit;
  var
    CfgPath, CfgDbPath, DefaultDb, CfgLangCode: string;
  begin
    CfgPath := GetConfigPath;
    DefaultDb := GetDefaultDbPath;

    WriteLn(Tr(midMetaConfigStatusHeader));
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

    if LoadLanguageFromConfig(CfgLangCode) then
      WriteLn('Config Sprache:     ', CfgLangCode)
    else
      WriteLn(Tr(midMetaConfigLanguageUnset));

    WriteLn('Default DB-Pfad:    ', DefaultDb);
    WriteLn('Default existiert:  ', BoolToStr(FileExists(DefaultDb), True));
    WriteLn('Aktive Sprache:     ', GetLanguageCode);
    WriteLn(Tr(midMetaConfigStatusFooter));
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
      Msg(Tr(midMetaNoConfigToDelete));

    Msg(Tr(midMetaDbNotDeletedHint));
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

  function AskKeepLocal(const Prompt, Current: string): string;
  var
    Input: string;
  begin
    Write(Prompt, ' [', Current, ']: ');
    ReadLn(Input);
    Input := Trim(Input);
    if Input = '' then
      Result := Current
    else
      Result := Input;
  end;

  procedure HandleCarsAdd(const ADbPath: string);
  var
    Name, Plate, Note, StartDate, S: string;
    StartKm: Integer;
    NewId: Integer;
  begin
    WriteLn('Car hinzufuegen');
    WriteLn('---------------');

    Write('Name*: ');
    ReadLn(Name);
    Name := Trim(Name);
    if Name = '' then
      raise Exception.Create('Name darf nicht leer sein.');

    Write('Plate: ');
    ReadLn(Plate);
    Plate := Trim(Plate);

    Write('Note: ');
    ReadLn(Note);
    Note := Trim(Note);

    Write('Start-KM* (>0): ');
    ReadLn(S);
    if (not TryStrToInt(Trim(S), StartKm)) or (StartKm <= 0) then
      raise Exception.Create('Start-KM muss > 0 sein.');

    Write('Start-Datum* (YYYY-MM-DD): ');
    ReadLn(StartDate);
    StartDate := Trim(StartDate);
    if StartDate = '' then
      raise Exception.Create('Start-Datum darf nicht leer sein.');

    NewId := CarsAdd(ADbPath, Name, Plate, Note, StartKm, StartDate);
    Msg('OK: Car gespeichert (id=' + IntToStr(NewId) + ').');
  end;

  procedure HandleCarsList(const ADbPath: string; const Detailed: Boolean);
  var
    Cars: TCarsArray;
  begin
    Cars := CarsList(ADbPath);
    RenderCarsTable(Cars, Detailed);
  end;

  procedure HandleCarsEdit(const ADbPath: string; const CarId: Integer);
  var
    Car: TCar;
    NewName, NewPlate, NewNote: string;
  begin
    if not CarsGetById(ADbPath, CarId, Car) then
      raise Exception.Create('P-002: Fahrzeug nicht gefunden (car_id nicht mehr vorhanden).');

    WriteLn('Car bearbeiten (id=', CarId, ')');
    WriteLn('--------------------------');

    NewName := AskKeepLocal('Name*', Car.Name);
    if Trim(NewName) = '' then
      raise Exception.Create('Name darf nicht leer sein.');

    NewPlate := AskKeepLocal('Plate', Car.Plate);
    NewNote := AskKeepLocal('Note', Car.Note);

    if not CarsEdit(ADbPath, CarId, NewName, NewPlate, NewNote) then
      raise Exception.Create('Car konnte nicht aktualisiert werden (keine Zeile betroffen).');

    Msg('OK: Car aktualisiert (id=' + IntToStr(CarId) + ').');
  end;

  procedure HandleCarsDelete(const ADbPath: string; const CarId: Integer);
  var
    Confirm: string;
  begin
    Write('Car id ' + IntToStr(CarId) + ' loeschen (y/N): ');
    ReadLn(Confirm);
    Confirm := LowerCase(Trim(Confirm));
    if (Confirm <> 'y') and (Confirm <> 'yes') then
    begin
      Msg('Abgebrochen.');
      Exit;
    end;

    if not CarsDelete(ADbPath, CarId) then
      raise Exception.Create('Car konnte nicht geloescht werden (nicht gefunden).');

    Msg('OK: Car geloescht (id=' + IntToStr(CarId) + ').');
  end;

begin
  ApplyLanguageFromConfig;

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
    ' CarId=' + IntToStr(Cmd.CarId) +
    ' MaintenanceSource=' + MaintenanceSourceToString(Cmd.MaintenanceSource) +
    ' MaintenanceSourceProvided=' + BoolToStr(Cmd.MaintenanceSourceProvided, True) +
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
      Msg(Format(Tr(midMetaFirstRunConfigCreatedFmt), [GetConfigPath]));
      Msg(Format(Tr(midMetaFirstRunDbFmt), [ExpandFileName(DbPath)]));
      Msg(Tr(midMetaHelpHint));
    end;

    // DB-abhaengige Command-Policies (z. B. cars edit/delete Exists/HasFuelups).
    if not ValidateCommandDb(Cmd, DbPath) then
      FailUsage(Cmd.ErrorMsg, Cmd.ErrorFocus);

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
          ckAdd: AddFuelupInteractive(DbPath, Cmd.CarId);
          ckList: ListFuelups(DbPath, Cmd.Detail, Cmd.CarId);
          ckStats:
            begin
              if Cmd.Csv then
                ShowFuelupStatsCsv(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.Monthly,
                  Cmd.CarId)
              else if Cmd.Json then
                ShowFuelupStatsJson(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.Monthly,
                  Cmd.Yearly,
                  Cmd.Pretty,
                  Cmd.CarId,
                  APP_VERSION)
              else
              begin
                if Cmd.Dashboard then
                  ShowFuelupDashboard(DbPath,
                    Cmd.PeriodEnabled,
                    Cmd.PeriodFromIso,
                    Cmd.PeriodToExclIso,
                    Cmd.FromProvided,
                    Cmd.ToProvided,
                    Cmd.Monthly,
                    Cmd.CarId)
                else
                  ShowFuelupStats(DbPath,
                    Cmd.PeriodEnabled,
                    Cmd.PeriodFromIso,
                    Cmd.PeriodToExclIso,
                    Cmd.FromProvided,
                    Cmd.ToProvided,
                    Cmd.Monthly,
                    Cmd.Yearly,
                    Cmd.CarId);
              end;
            end;
        else
          FailUsage('Interner Fehler: Ungültiges fuelups-Kommando.');
        end;

      tkCars:
        case Cmd.Kind of
          ckAdd: HandleCarsAdd(DbPath);
          ckList: HandleCarsList(DbPath, Cmd.Detail);
          ckEdit: HandleCarsEdit(DbPath, Cmd.CarId);
          ckDelete: HandleCarsDelete(DbPath, Cmd.CarId);
        else
          FailUsage('Interner Fehler: Ungültiges cars-Kommando.');
        end;

      tkFleet:
        case Cmd.Kind of
          ckStats:
            begin
              if Cmd.Json then
                ShowFleetStatsJson(DbPath, Cmd.Pretty, APP_VERSION)
              else
                ShowFleetStats(DbPath);
            end;
        else
          FailUsage('Interner Fehler: Ungültiges fleet-Kommando.');
        end;

      tkCost:
        case Cmd.Kind of
          ckStats:
            begin
              if Cmd.Json then
                ShowCostStatsJson(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.CarId,
                  Cmd.MaintenanceSource,
                  Cmd.Pretty,
                  APP_VERSION)
              else
                ShowCostStats(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.CarId,
                  Cmd.MaintenanceSource);
            end;
        else
          FailUsage('Interner Fehler: Ungültiges cost-Kommando.');
        end;
    else
      FailUsage('Interner Fehler: Unbekannter Target.');
    end;

    // ----------------
    // Statusausgabe
    // Nur melden, wenn die DB wirklich neu angelegt wurde.
    
    if (not Cmd.Debug) and WasCreated then
      Msg(Tr(midMetaDatabaseCreated));

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
      DbgRow('language', GetLanguageCode);
      DbgSep;
    end;

  except
    on E: Exception do
    begin
      FailUsage(E.Message, efNone, EXIT_UNEXPECTED);
    end;
  end;
end.
