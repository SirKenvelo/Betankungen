{
  u_cli_validate.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-02-19
  UPDATED: 2026-02-20
  AUTHOR : Christof Kempinski
  CLI-Validierungsschicht fuer den Parser.

  Verantwortlichkeiten:
  - Bietet den Einstiegspunkt fuer die zentrale Kommando-Validierung.
  - Kapselt deklarative Zustandspruefungen fuer Meta-/Action-Flow.
  - Kapselt domain-nahe Command-/Target-Policies ohne Ausgabeformat-Logik.
  - Ermoeglicht die schrittweise Auslagerung von Regelpruefungen aus dem Parser.
  ---------------------------------------------------------------------------
}

unit u_cli_validate;

{$mode objfpc}{$H+}

interface

uses
  u_cli_types;

function ValidateCommand(var Cmd: TCommand): boolean;

implementation

function IsStandaloneMeta(const Cmd: TCommand): boolean;
begin
  Result := Cmd.Help
         or Cmd.Version
         or Cmd.About;
end;

function IsStandaloneAction(const Cmd: TCommand): boolean;
begin
  Result := (Cmd.DbSet <> '')
         or Cmd.ShowConfig
         or Cmd.ResetConfig;
end;

function HasMainCommand(const Cmd: TCommand): boolean;
begin
  Result := Cmd.Kind <> ckNone;
end;

function ValidateFuelupsPolicy(var Cmd: TCommand): boolean;
begin
  Result := True;

  if (Cmd.Target = tkFuelups)
     and (Cmd.Kind in [ckEdit, ckDelete]) then
  begin
    Cmd.ErrorMsg := 'fuelups unterstuetzt nur add/list (append-only).';
    Cmd.ErrorFocus := efTarget;
    Exit(False);
  end;
end;

function ValidateStatsTargetPolicy(var Cmd: TCommand): boolean;
begin
  Result := True;

  if (Cmd.Kind = ckStats)
     and (Cmd.Target <> tkFuelups) then
  begin
    Cmd.ErrorMsg := '--stats ist aktuell nur fuer fuelups verfuegbar.';
    Cmd.ErrorFocus := efTarget;
    Exit(False);
  end;
end;

function ValidateCommand(var Cmd: TCommand): boolean;
begin
  Result := True;

  // 1. Meta darf alleine stehen
  if IsStandaloneMeta(Cmd) then
    Exit(True);

  // 2. Aktionen ohne Hauptkommando erlaubt
  if (not HasMainCommand(Cmd)) and IsStandaloneAction(Cmd) then
    Exit(True);

  // 3. Kein Kommando angegeben -> Fehler
  if not HasMainCommand(Cmd) then
  begin
    Cmd.ErrorMsg := 'Kein Kommando angegeben.';
    Cmd.ErrorFocus := efTarget;
    Exit(False);
  end;

  if not ValidateFuelupsPolicy(Cmd) then
    Exit(False);

  if not ValidateStatsTargetPolicy(Cmd) then
    Exit(False);
end;

end.
