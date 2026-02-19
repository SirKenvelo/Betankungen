{
  u_cli_validate.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-02-19
  UPDATED: 2026-02-19
  AUTHOR : Christof Kempinski
  CLI-Validierungsschicht (Stub) fuer den Parser.

  Verantwortlichkeiten:
  - Bietet den Einstiegspunkt fuer die zentrale Kommando-Validierung.
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

function ValidateCommand(var Cmd: TCommand): boolean;
begin
  Result := True;
end;

end.
