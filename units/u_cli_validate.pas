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
  - Kapselt Output-/Format-Policies fuer Stats-Flags (dashboard/json/csv/pretty/monthly/yearly).
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

function IsStatsFuelups(const Cmd: TCommand): boolean;
begin
  Result := HasMainCommand(Cmd)
        and (Cmd.Kind = ckStats)
        and (Cmd.Target = tkFuelups);
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

function ValidateDashboardFormatPolicy(var Cmd: TCommand): boolean;
begin
  Result := True;

  if Cmd.Dashboard then
  begin
    if not IsStatsFuelups(Cmd) then
    begin
      Cmd.ErrorMsg := 'Fehler: --dashboard ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Json or Cmd.Csv then
    begin
      Cmd.ErrorMsg := 'Fehler: --dashboard kann nicht mit --json oder --csv kombiniert werden.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;
end;

function ValidateJsonCsvPrettyPolicy(var Cmd: TCommand): boolean;
begin
  Result := True;

  // --json ist nur fuer "--stats fuelups" erlaubt
  if Cmd.Json then
  begin
    if not IsStatsFuelups(Cmd) then
    begin
      Cmd.ErrorMsg := 'Fehler: --json ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;

  // --csv ist nur fuer "--stats fuelups" erlaubt und exklusiv zu --json
  if Cmd.Csv then
  begin
    if not IsStatsFuelups(Cmd) then
    begin
      Cmd.ErrorMsg := 'Fehler: --csv ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Json then
    begin
      Cmd.ErrorMsg := 'Fehler: --csv und --json koennen nicht zusammen verwendet werden.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;

  // --pretty ist nur zusammen mit --json erlaubt (und damit nur bei --stats fuelups)
  if Cmd.Pretty then
  begin
    if not Cmd.Json then
    begin
      Cmd.ErrorMsg := 'Fehler: --pretty ist nur zusammen mit --json erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if not IsStatsFuelups(Cmd) then
    begin
      Cmd.ErrorMsg := 'Fehler: --pretty ist nur zusammen mit "--stats fuelups --json" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;
end;

function ValidateMonthlyYearlyPolicy(var Cmd: TCommand): boolean;
begin
  Result := True;

  // --monthly ist nur fuer "--stats fuelups" erlaubt
  if Cmd.Monthly then
  begin
    if not IsStatsFuelups(Cmd) then
    begin
      Cmd.ErrorMsg := 'Fehler: --monthly ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;

  // --yearly ist nur fuer "--stats fuelups" erlaubt + Konfliktregeln
  if Cmd.Yearly then
  begin
    if not IsStatsFuelups(Cmd) then
    begin
      Cmd.ErrorMsg := 'Fehler: --yearly ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Monthly then
    begin
      Cmd.ErrorMsg := 'Fehler: --yearly und --monthly koennen nicht zusammen verwendet werden.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Dashboard then
    begin
      Cmd.ErrorMsg := 'Fehler: --yearly kann nicht mit --dashboard kombiniert werden.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Csv then
    begin
      Cmd.ErrorMsg := 'Fehler: --yearly ist aktuell nicht als CSV verfuegbar (nur Text/JSON).';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;
end;

function ValidatePeriodPolicy(var Cmd: TCommand): boolean;
begin
  Result := True;

  if not Cmd.PeriodEnabled then
    Exit(True);

  // 1) Nur bei stats fuelups erlaubt
  if not IsStatsFuelups(Cmd) then
  begin
    Cmd.ErrorMsg := 'Fehler: --from/--to ist nur zusammen mit "--stats fuelups" erlaubt.';
    Cmd.ErrorFocus := efStatsPeriod;
    Exit(False);
  end;

  // 2) Range-Check nur wenn beide gesetzt
  if Cmd.FromProvided and Cmd.ToProvided then
  begin
    if Cmd.PeriodFromIso >= Cmd.PeriodToExclIso then
    begin
      Cmd.ErrorMsg := 'Fehler: --from muss vor --to liegen.';
      Cmd.ErrorFocus := efStatsRange;
      Exit(False);
    end;
  end;

  // 3) Open-ended Normalisierung
  if Cmd.FromProvided and (not Cmd.ToProvided) then
    Cmd.PeriodToExclIso := '';

  if Cmd.ToProvided and (not Cmd.FromProvided) then
    Cmd.PeriodFromIso := '';
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

  if not ValidateDashboardFormatPolicy(Cmd) then
    Exit(False);

  if not ValidateJsonCsvPrettyPolicy(Cmd) then
    Exit(False);

  if not ValidateMonthlyYearlyPolicy(Cmd) then
    Exit(False);

  if not ValidatePeriodPolicy(Cmd) then
    Exit(False);
end;

end.
