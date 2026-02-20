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
end;

end.
