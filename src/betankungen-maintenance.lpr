{
  betankungen-maintenance.lpr
  ---------------------------------------------------------------------------
  CREATED: 2026-03-10
  UPDATED: 2026-03-14
  AUTHOR : Christof Kempinski
  Companion-Binary-Skeleton fuer das optionale Maintenance-Modul.

  Verantwortlichkeiten:
  - Stellt den minimalen Modul-Handshake bereit (`--module-info`).
  - Initialisiert/Migriert das Modul-Schema via `--migrate`.
  - Liefert Basis-Meta-Flags (`--help`, `--version`, optional `--pretty`).
  - Enthaelt noch keine fachliche CRUD-/Stats-Logik fuer Maintenance-Events.
  ---------------------------------------------------------------------------
}
program betankungen_maintenance;

{$mode objfpc}{$H+}

uses
  SysUtils,
  u_module_info,
  u_maintenance_db;

const
  EXIT_OK = 0;
  EXIT_CLI = 1;

  MODULE_BIN_NAME = 'betankungen-maintenance';
  MODULE_NAME = 'maintenance';
  MODULE_VERSION = '0.1.0-dev';
  MIN_CORE_VERSION = '0.9.0-dev';
  DB_SCHEMA_VERSION = 1;

type
  TActionKind = (
    akNone,
    akHelp,
    akVersion,
    akModuleInfo,
    akMigrate,
    akAddMaintenance,
    akListMaintenance
  );

  TParsedArgs = record
    Action: TActionKind;
    Pretty: Boolean;
    DbArg: string;
    CarIdRaw: string;
    DateRaw: string;
    EventTypeRaw: string;
    CostCentsRaw: string;
    NotesRaw: string;
  end;

procedure PrintUsage;
begin
  WriteLn('Usage: ', MODULE_BIN_NAME, ' --module-info [--pretty]');
  WriteLn('       ', MODULE_BIN_NAME, ' --migrate [--db <path>]');
  WriteLn('       ', MODULE_BIN_NAME, ' --add maintenance --car-id <id> --date <YYYY-MM-DD> --type <name> --cost-cents <value> [--notes <text>] [--db <path>]');
  WriteLn('       ', MODULE_BIN_NAME, ' --list maintenance [--car-id <id>] [--db <path>]');
  WriteLn('       ', MODULE_BIN_NAME, ' --help | --version');
  WriteLn('');
  WriteLn('Maintenance companion module (schema + CRUD baseline).');
end;

procedure PrintVersion;
begin
  WriteLn(MODULE_BIN_NAME, ' ', MODULE_VERSION);
end;

procedure PrintModuleInfo(const Pretty: Boolean);
var
  Info: TModuleInfo;
begin
  Info.ModuleName := MODULE_NAME;
  Info.ModuleVersion := MODULE_VERSION;
  Info.MinCoreVersion := MIN_CORE_VERSION;
  Info.DbSchemaVersion := DB_SCHEMA_VERSION;
  PrintModuleInfoJson(Info, Pretty);
end;

procedure RunMigration(const DbArg: string);
var
  DbPath: string;
  Changed: Boolean;
begin
  DbPath := ResolveMaintenanceDbPath(DbArg);
  EnsureMaintenanceSchema(DbPath, Changed);
  if Changed then
    WriteLn('[OK] Module schema initialized: ', DbPath)
  else
    WriteLn('[OK] Module schema up to date: ', DbPath);
  WriteLn('[OK] module_schema_version=', CurrentModuleSchemaVersion);
end;

function IsIsoDateYMD(const S: string): Boolean;
var
  Yi, Mi, Di: Integer;
  Y, M, D: Word;
  Dt: TDateTime;
begin
  Result := False;
  if Length(S) <> 10 then
    Exit;
  if (S[5] <> '-') or (S[8] <> '-') then
    Exit;
  if (not TryStrToInt(Copy(S, 1, 4), Yi)) or
     (not TryStrToInt(Copy(S, 6, 2), Mi)) or
     (not TryStrToInt(Copy(S, 9, 2), Di)) then
    Exit;
  if (Yi < 1) or (Yi > 9999) or (Mi < 1) or (Mi > 12) or (Di < 1) or (Di > 31) then
    Exit;
  Y := Yi;
  M := Mi;
  D := Di;
  Result := TryEncodeDate(Y, M, D, Dt);
end;

function ParsePositiveInt(const Raw: string; const Name: string): Integer;
begin
  if (Trim(Raw) = '') or (not TryStrToInt(Trim(Raw), Result)) or (Result <= 0) then
    raise Exception.Create('Fehler: ' + Name + ' muss eine positive Ganzzahl sein.');
end;

function ParseNonNegativeInt64(const Raw: string; const Name: string): Int64;
begin
  if (Trim(Raw) = '') or (not TryStrToInt64(Trim(Raw), Result)) or (Result < 0) then
    raise Exception.Create('Fehler: ' + Name + ' muss >= 0 sein.');
end;

function SingleLine(const S: string): string;
begin
  Result := StringReplace(S, LineEnding, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #13, ' ', [rfReplaceAll]);
end;

procedure RunAddMaintenance(const Args: TParsedArgs);
var
  DbPath: string;
  EventId: Int64;
  CarId: Integer;
  CostCents: Int64;
  EventDate: string;
  EventType: string;
begin
  CarId := ParsePositiveInt(Args.CarIdRaw, '--car-id');
  CostCents := ParseNonNegativeInt64(Args.CostCentsRaw, '--cost-cents');
  EventDate := Trim(Args.DateRaw);
  EventType := Trim(Args.EventTypeRaw);

  if not IsIsoDateYMD(EventDate) then
    raise Exception.Create('Fehler: --date muss im Format YYYY-MM-DD angegeben werden.');
  if EventType = '' then
    raise Exception.Create('Fehler: --type darf nicht leer sein.');

  DbPath := ResolveMaintenanceDbPath(Args.DbArg);
  EventId := AddMaintenanceEvent(
    DbPath,
    CarId,
    EventDate,
    EventType,
    CostCents,
    Trim(Args.NotesRaw)
  );
  WriteLn('[OK] maintenance_event_id=', EventId);
  WriteLn('[OK] db=', DbPath);
end;

procedure RunListMaintenance(const Args: TParsedArgs);
var
  DbPath: string;
  Rows: TMaintenanceEventRows;
  i: Integer;
  CarIdFilter: Integer;
begin
  if Trim(Args.CarIdRaw) <> '' then
    CarIdFilter := ParsePositiveInt(Args.CarIdRaw, '--car-id')
  else
    CarIdFilter := 0;

  DbPath := ResolveMaintenanceDbPath(Args.DbArg);
  ListMaintenanceEvents(DbPath, CarIdFilter, Rows);

  WriteLn('Maintenance Events');
  if CarIdFilter > 0 then
    WriteLn('Scope: car_id=', CarIdFilter)
  else
    WriteLn('Scope: all cars');

  if Length(Rows) = 0 then
  begin
    WriteLn('No maintenance events found.');
    Exit;
  end;

  WriteLn('id | car_id | event_date | event_type | cost_cents | notes');
  for i := 0 to High(Rows) do
    WriteLn(
      Rows[i].Id, ' | ',
      Rows[i].CarId, ' | ',
      Rows[i].EventDate, ' | ',
      Rows[i].EventType, ' | ',
      Rows[i].CostCents, ' | ',
      SingleLine(Rows[i].Notes)
    );
end;

function ParseArgs(out Args: TParsedArgs; out ErrMsg: string): Boolean;
var
  i: Integer;
  A: string;
  PendingAction: TActionKind;
  procedure SetAction(const NextAction: TActionKind);
  begin
    if (PendingAction <> akNone) and (PendingAction <> NextAction) then
      raise Exception.Create('Fehler: mehrere Hauptkommandos kombiniert. Bitte genau eines verwenden.');
    PendingAction := NextAction;
  end;
begin
  Result := False;
  ErrMsg := '';
  FillChar(Args, SizeOf(Args), 0);
  Args.Action := akNone;
  PendingAction := akNone;

  i := 1;
  while i <= ParamCount do
  begin
    A := ParamStr(i);

    if A = '--help' then
      SetAction(akHelp)
    else if A = '--version' then
      SetAction(akVersion)
    else if A = '--module-info' then
      SetAction(akModuleInfo)
    else if A = '--migrate' then
      SetAction(akMigrate)
    else if A = '--pretty' then
      Args.Pretty := True
    else if (A = '--db') or (A = '--car-id') or (A = '--date') or
            (A = '--type') or (A = '--cost-cents') or (A = '--notes') then
    begin
      Inc(i);
      if i > ParamCount then
      begin
        ErrMsg := 'Fehler: ' + A + ' erwartet einen Wert.';
        Exit;
      end;

      if A = '--db' then
        Args.DbArg := ParamStr(i)
      else if A = '--car-id' then
        Args.CarIdRaw := ParamStr(i)
      else if A = '--date' then
        Args.DateRaw := ParamStr(i)
      else if A = '--type' then
        Args.EventTypeRaw := ParamStr(i)
      else if A = '--cost-cents' then
        Args.CostCentsRaw := ParamStr(i)
      else
        Args.NotesRaw := ParamStr(i);
    end
    else if (A = '--add') or (A = '--list') then
    begin
      Inc(i);
      if i > ParamCount then
      begin
        ErrMsg := 'Fehler: ' + A + ' erwartet ein Target (maintenance).';
        Exit;
      end;
      if ParamStr(i) <> 'maintenance' then
      begin
        ErrMsg := 'Fehler: nur das Target "maintenance" wird unterstuetzt.';
        Exit;
      end;
      if A = '--add' then
        SetAction(akAddMaintenance)
      else
        SetAction(akListMaintenance);
    end
    else
    begin
      ErrMsg := 'Fehler: unbekannte Option "' + A + '".';
      Exit;
    end;

    Inc(i);
  end;

  try
    if PendingAction = akNone then
      PendingAction := akHelp;
    Args.Action := PendingAction;

    if (Args.Action in [akAddMaintenance, akListMaintenance, akMigrate]) and Args.Pretty then
      raise Exception.Create('Fehler: --pretty ist nur zusammen mit --module-info erlaubt.');

    if Args.Action = akAddMaintenance then
    begin
      if Trim(Args.CarIdRaw) = '' then
        raise Exception.Create('Fehler: --car-id ist fuer --add maintenance erforderlich.');
      if Trim(Args.DateRaw) = '' then
        raise Exception.Create('Fehler: --date ist fuer --add maintenance erforderlich.');
      if Trim(Args.EventTypeRaw) = '' then
        raise Exception.Create('Fehler: --type ist fuer --add maintenance erforderlich.');
      if Trim(Args.CostCentsRaw) = '' then
        raise Exception.Create('Fehler: --cost-cents ist fuer --add maintenance erforderlich.');
    end;

    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
      Exit(False);
    end;
  end;
end;

var
  Args: TParsedArgs;
  ErrMsg: string;
begin
  if not ParseArgs(Args, ErrMsg) then
  begin
    WriteLn(StdErr, ErrMsg);
    PrintUsage;
    Halt(EXIT_CLI);
  end;

  if Args.Action = akHelp then
  begin
    PrintUsage;
    Halt(EXIT_OK);
  end;

  if Args.Action = akModuleInfo then
  begin
    PrintModuleInfo(Args.Pretty);
    Halt(EXIT_OK);
  end;

  if Args.Action = akMigrate then
  begin
    RunMigration(Args.DbArg);
    Halt(EXIT_OK);
  end;

  if Args.Action = akAddMaintenance then
  begin
    try
      RunAddMaintenance(Args);
      Halt(EXIT_OK);
    except
      on E: Exception do
      begin
        WriteLn(StdErr, E.Message);
        Halt(EXIT_CLI);
      end;
    end;
  end;

  if Args.Action = akListMaintenance then
  begin
    try
      RunListMaintenance(Args);
      Halt(EXIT_OK);
    except
      on E: Exception do
      begin
        WriteLn(StdErr, E.Message);
        Halt(EXIT_CLI);
      end;
    end;
  end;

  if Args.Action = akVersion then
  begin
    PrintVersion;
    Halt(EXIT_OK);
  end;

  WriteLn(StdErr, 'Fehler: kein Kommando angegeben.');
  PrintUsage;
  Halt(EXIT_CLI);
end.
