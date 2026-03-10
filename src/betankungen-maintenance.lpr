{
  betankungen-maintenance.lpr
  ---------------------------------------------------------------------------
  CREATED: 2026-03-10
  UPDATED: 2026-03-10
  AUTHOR : Christof Kempinski
  Companion-Binary-Skeleton fuer das optionale Maintenance-Modul.

  Verantwortlichkeiten:
  - Stellt den minimalen Modul-Handshake bereit (`--module-info`).
  - Liefert Basis-Meta-Flags (`--help`, `--version`, optional `--pretty`).
  - Enthaelt bewusst noch keine fachliche Maintenance-Logik.
  ---------------------------------------------------------------------------
}
program betankungen_maintenance;

{$mode objfpc}{$H+}

uses
  SysUtils,
  u_module_info;

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
  for i := 1 to ParamCount do
  begin
    A := ParamStr(i);
    if (A = '--help') or
       (A = '--version') or
       (A = '--module-info') or
       (A = '--pretty') then
      Continue;
    Exit(True);
  end;
end;

procedure PrintUsage;
begin
  WriteLn('Usage: ', MODULE_BIN_NAME, ' --module-info [--pretty]');
  WriteLn('       ', MODULE_BIN_NAME, ' --help | --version');
  WriteLn('');
  WriteLn('Minimal companion skeleton for the maintenance module.');
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

begin
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

  if HasFlag('--version') then
  begin
    PrintVersion;
    Halt(EXIT_OK);
  end;

  WriteLn(StdErr, 'Fehler: kein Kommando angegeben.');
  PrintUsage;
  Halt(EXIT_CLI);
end.
