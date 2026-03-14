{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : units/u_cli_validate.pas
  CHANGED  : 2026-03-14
  REASON   : behavior change (S11C1/4 maintenance-source Kontext-Policy)
  CONTEXT  : Vor S11C1 gab es keine explizite Validate-Policy fuer --maintenance-source
  CONTEXT  : ValidateCommand endete nach Period-Policy ohne maintenance-source Guardrail
  BEISPIEL : --maintenance-source ausserhalb --stats cost wurde nicht zentral geblockt
  BEISPIEL : ErrorFocus efMaintenanceSource war nicht an eine eigene Policy gebunden
}

// Vor-S11C1 Stand (Auszug): ValidateCommand ohne maintenance-source Policy.

function ValidatePeriodPolicy(var Cmd: TCommand): boolean;
begin
  Result := True;

  if not Cmd.PeriodEnabled then
    Exit(True);

  // 1) Nur bei stats fuelups/cost erlaubt
  if (not IsStatsFuelups(Cmd)) and (not IsStatsCost(Cmd)) then
  begin
    Cmd.ErrorMsg := 'Fehler: --from/--to ist nur zusammen mit "--stats fuelups" oder "--stats cost" erlaubt.';
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

  if not ValidateCarIdPolicy(Cmd) then
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
