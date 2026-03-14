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

function HasFlag(const Flag: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to ParamCount do
    if ParamStr(i) = Flag then
      Exit(True);
end;

function HasUnknownFlags: Boolean;
var
  i: Integer;
  A: string;
begin
  Result := False;
  i := 1;
  while i <= ParamCount do
  begin
    A := ParamStr(i);
    if (A = '--help') or
       (A = '--version') or
       (A = '--module-info') or
       (A = '--pretty') or
       (A = '--migrate') then
    begin
      Inc(i);
      Continue;
    end;

    if A = '--db' then
    begin
      Inc(i);
      if i > ParamCount then
        Exit(True);
      Inc(i);
      Continue;
    end;

    Exit(True);
  end;
end;

function TryReadDbArg(out DbArg: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  DbArg := '';
  i := 1;
  while i <= ParamCount do
  begin
    if ParamStr(i) = '--db' then
    begin
      if i = ParamCount then
        Exit(False);
      DbArg := ParamStr(i + 1);
      if Trim(DbArg) = '' then
        Exit(False);
      Inc(i);
    end;
    Inc(i);
  end;
end;

procedure PrintUsage;
begin
  WriteLn('Usage: ', MODULE_BIN_NAME, ' --module-info [--pretty]');
  WriteLn('       ', MODULE_BIN_NAME, ' --migrate [--db <path>]');
  WriteLn('       ', MODULE_BIN_NAME, ' --help | --version');
  WriteLn('');
  WriteLn('Maintenance companion module (schema + migration baseline).');
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

var
  DbArg: string;
begin
  if not TryReadDbArg(DbArg) then
  begin
    WriteLn(StdErr, 'Fehler: --db erwartet einen Pfad als Wert.');
    PrintUsage;
    Halt(EXIT_CLI);
  end;

  if HasUnknownFlags then
  begin
    WriteLn(StdErr, 'Fehler: unbekannte Option.');
    PrintUsage;
    Halt(EXIT_CLI);
  end;

  if (ParamCount = 0) or HasFlag('--help') then
  begin
    PrintUsage;
    Halt(EXIT_OK);
  end;

  if HasFlag('--module-info') then
  begin
    PrintModuleInfo(HasFlag('--pretty'));
    Halt(EXIT_OK);
  end;

  if HasFlag('--migrate') then
  begin
    RunMigration(DbArg);
    Halt(EXIT_OK);
  end;

  if HasFlag('--version') then
  begin
    PrintVersion;
    Halt(EXIT_OK);
  end;

  WriteLn(StdErr, 'Fehler: kein Kommando angegeben.');
  PrintUsage;
  Halt(EXIT_CLI);
end.
