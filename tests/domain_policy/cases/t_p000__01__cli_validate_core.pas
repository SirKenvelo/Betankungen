program t_p000__01__cli_validate_core;

{$mode objfpc}{$H+}

uses
  SysUtils,
  u_cli_types,
  u_cli_validate;

procedure Fail(const Msg: string);
begin
  WriteLn('[FAIL] ', Msg);
  Halt(1);
end;

procedure Ok(const Msg: string);
begin
  WriteLn('[OK]   ', Msg);
end;

procedure AssertTrue(Cond: boolean; const Msg: string);
begin
  if not Cond then
    Fail(Msg);
end;

procedure AssertFalse(Cond: boolean; const Msg: string);
begin
  if Cond then
    Fail(Msg);
end;

procedure AssertEqInt(Expected, Actual: integer; const Msg: string);
begin
  if Expected <> Actual then
    Fail(Format('%s (expected=%d actual=%d)', [Msg, Expected, Actual]));
end;

procedure AssertEqStr(const Expected, Actual, Msg: string);
begin
  if Expected <> Actual then
    Fail(Format('%s (expected="%s" actual="%s")', [Msg, Expected, Actual]));
end;

function NewCmd: TCommand;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.Kind := ckNone;
  Result.Target := tkStations;
end;

procedure SetMainCommand(var Cmd: TCommand; Kind: TCommandKind; Target: TTableKind);
begin
  Cmd.Kind := Kind;
  Cmd.Target := Target;
  Cmd.HasCommand := True;
end;

procedure Test_MetaHelp_Standalone;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  Cmd.Help := True;

  AssertTrue(ValidateCommand(Cmd), 'Meta help should validate');
  Ok('Meta: --help standalone');
end;

procedure Test_ActionDbSet_Standalone;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  Cmd.DbSet := '/tmp/x.db';

  AssertTrue(ValidateCommand(Cmd), 'DbSet without main command should validate');
  Ok('Action: --db-set standalone');
end;

procedure Test_NoCommand_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;

  AssertFalse(ValidateCommand(Cmd), 'Empty command must fail');
  AssertEqInt(Ord(efTarget), Ord(Cmd.ErrorFocus), 'No-command focus');
  AssertEqStr('Kein Kommando angegeben.', Cmd.ErrorMsg, 'No-command message');
  Ok('Flow: no command fails with efTarget');
end;

procedure Test_Fuelups_Edit_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckEdit, tkFuelups);

  AssertFalse(ValidateCommand(Cmd), 'fuelups edit must fail');
  AssertEqInt(Ord(efTarget), Ord(Cmd.ErrorFocus), 'fuelups edit focus');
  Ok('Policy: fuelups edit rejected');
end;

procedure Test_StatsStations_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkStations);

  AssertFalse(ValidateCommand(Cmd), 'stats stations must fail');
  AssertEqInt(Ord(efTarget), Ord(Cmd.ErrorFocus), 'stats target focus');
  Ok('Policy: --stats rejects stations');
end;

procedure Test_StatsFleet_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFleet);

  AssertTrue(ValidateCommand(Cmd), 'stats fleet should validate');
  Ok('Policy: --stats fleet allowed');
end;

procedure Test_StatsCost_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);

  AssertTrue(ValidateCommand(Cmd), 'stats cost should validate');
  Ok('Policy: --stats cost allowed');
end;

procedure Test_Cost_NonStats_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckList, tkCost);

  AssertFalse(ValidateCommand(Cmd), 'cost without stats must fail');
  AssertEqInt(Ord(efTarget), Ord(Cmd.ErrorFocus), 'cost non-stats focus');
  Ok('Policy: cost is stats-only');
end;

procedure Test_Format_DashboardJson_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFuelups);
  Cmd.Dashboard := True;
  Cmd.Json := True;

  AssertFalse(ValidateCommand(Cmd), 'dashboard+json must fail');
  AssertEqInt(Ord(efStatsFormat), Ord(Cmd.ErrorFocus), 'format focus');
  Ok('Format: dashboard+json rejected');
end;

procedure Test_Format_FleetJson_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFleet);
  Cmd.Json := True;

  AssertTrue(ValidateCommand(Cmd), 'fleet+json must be ok');
  Ok('Format: fleet+json ok');
end;

procedure Test_Format_FleetJsonPretty_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFleet);
  Cmd.Json := True;
  Cmd.Pretty := True;

  AssertTrue(ValidateCommand(Cmd), 'fleet+json+pretty must be ok');
  Ok('Format: fleet+json+pretty ok');
end;

procedure Test_Format_FleetCsv_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFleet);
  Cmd.Csv := True;

  AssertFalse(ValidateCommand(Cmd), 'fleet+csv must fail');
  AssertEqInt(Ord(efStatsFormat), Ord(Cmd.ErrorFocus), 'fleet csv focus');
  Ok('Format: fleet+csv rejected');
end;

procedure Test_Format_CostJson_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);
  Cmd.Json := True;

  AssertTrue(ValidateCommand(Cmd), 'cost+json must be ok');
  Ok('Format: cost+json ok');
end;

procedure Test_Format_CostJsonPretty_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);
  Cmd.Json := True;
  Cmd.Pretty := True;

  AssertTrue(ValidateCommand(Cmd), 'cost+json+pretty must be ok');
  Ok('Format: cost+json+pretty ok');
end;

procedure Test_Format_CostCsv_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);
  Cmd.Csv := True;

  AssertFalse(ValidateCommand(Cmd), 'cost+csv must fail');
  AssertEqInt(Ord(efStatsFormat), Ord(Cmd.ErrorFocus), 'cost csv focus');
  Ok('Format: cost+csv rejected');
end;

procedure Test_Format_CostMonthly_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);
  Cmd.Monthly := True;

  AssertFalse(ValidateCommand(Cmd), 'cost+monthly must fail');
  AssertEqInt(Ord(efStatsFormat), Ord(Cmd.ErrorFocus), 'cost monthly focus');
  Ok('Format: cost+monthly rejected');
end;

procedure Test_Format_CostYearly_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);
  Cmd.Yearly := True;

  AssertFalse(ValidateCommand(Cmd), 'cost+yearly must fail');
  AssertEqInt(Ord(efStatsFormat), Ord(Cmd.ErrorFocus), 'cost yearly focus');
  Ok('Format: cost+yearly rejected');
end;

procedure Test_Format_CostDashboard_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);
  Cmd.Dashboard := True;

  AssertFalse(ValidateCommand(Cmd), 'cost+dashboard must fail');
  AssertEqInt(Ord(efStatsFormat), Ord(Cmd.ErrorFocus), 'cost dashboard focus');
  Ok('Format: cost+dashboard rejected');
end;

procedure Test_CostCarId_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);
  Cmd.CarId := 1;

  AssertTrue(ValidateCommand(Cmd), 'cost+car-id must be ok');
  Ok('Policy: cost allows --car-id');
end;

procedure Test_MaintenanceSource_Cost_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);
  Cmd.MaintenanceSource := msNone;
  Cmd.MaintenanceSourceProvided := True;

  AssertTrue(ValidateCommand(Cmd), 'cost+maintenance-source must be ok');
  Ok('Policy: --maintenance-source allowed for --stats cost');
end;

procedure Test_MaintenanceSource_NonCost_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFuelups);
  Cmd.MaintenanceSource := msNone;
  Cmd.MaintenanceSourceProvided := True;

  AssertFalse(ValidateCommand(Cmd), 'maintenance-source outside cost must fail');
  AssertEqInt(Ord(efMaintenanceSource), Ord(Cmd.ErrorFocus), 'maintenance-source focus');
  Ok('Policy: --maintenance-source restricted to --stats cost');
end;

procedure Test_Format_FleetMonthly_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFleet);
  Cmd.Monthly := True;

  AssertFalse(ValidateCommand(Cmd), 'fleet+monthly must fail');
  AssertEqInt(Ord(efStatsFormat), Ord(Cmd.ErrorFocus), 'fleet monthly focus');
  Ok('Format: fleet+monthly rejected');
end;

procedure Test_Format_FleetYearly_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFleet);
  Cmd.Yearly := True;

  AssertFalse(ValidateCommand(Cmd), 'fleet+yearly must fail');
  AssertEqInt(Ord(efStatsFormat), Ord(Cmd.ErrorFocus), 'fleet yearly focus');
  Ok('Format: fleet+yearly rejected');
end;

procedure Test_Format_FleetDashboard_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFleet);
  Cmd.Dashboard := True;

  AssertFalse(ValidateCommand(Cmd), 'fleet+dashboard must fail');
  AssertEqInt(Ord(efStatsFormat), Ord(Cmd.ErrorFocus), 'fleet dashboard focus');
  Ok('Format: fleet+dashboard rejected');
end;

procedure Test_Period_FleetFrom_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFleet);
  Cmd.PeriodEnabled := True;
  Cmd.FromProvided := True;
  Cmd.PeriodFromIso := '2025-01-01';

  AssertFalse(ValidateCommand(Cmd), 'fleet+period must fail');
  AssertEqInt(Ord(efStatsPeriod), Ord(Cmd.ErrorFocus), 'fleet period focus');
  Ok('Period: fleet rejects --from/--to');
end;

procedure Test_Period_CostFrom_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkCost);
  Cmd.PeriodEnabled := True;
  Cmd.FromProvided := True;
  Cmd.PeriodFromIso := '2025-01-01';

  AssertTrue(ValidateCommand(Cmd), 'cost+period must be ok');
  Ok('Period: cost allows --from/--to');
end;

procedure Test_Format_JsonPretty_Ok;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFuelups);
  Cmd.Json := True;
  Cmd.Pretty := True;

  AssertTrue(ValidateCommand(Cmd), 'json+pretty must be ok');
  Ok('Format: json+pretty ok');
end;

procedure Test_Period_Range_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckStats, tkFuelups);

  Cmd.PeriodEnabled := True;
  Cmd.FromProvided := True;
  Cmd.ToProvided := True;
  Cmd.PeriodFromIso := '2025-02-01';
  Cmd.PeriodToExclIso := '2025-01-01';

  AssertFalse(ValidateCommand(Cmd), 'from>=to must fail');
  AssertEqInt(Ord(efStatsRange), Ord(Cmd.ErrorFocus), 'range focus');
  Ok('Period: invalid range rejected');
end;

procedure Test_Period_Context_Fails;
var
  Cmd: TCommand;
begin
  Cmd := NewCmd;
  SetMainCommand(Cmd, ckList, tkStations);

  Cmd.PeriodEnabled := True;
  Cmd.FromProvided := True;
  Cmd.PeriodFromIso := '2025-01-01';

  AssertFalse(ValidateCommand(Cmd), 'period outside stats fuelups must fail');
  AssertEqInt(Ord(efStatsPeriod), Ord(Cmd.ErrorFocus), 'period focus');
  Ok('Period: context restricted');
end;

begin
  Test_MetaHelp_Standalone;
  Test_ActionDbSet_Standalone;
  Test_NoCommand_Fails;
  Test_Fuelups_Edit_Fails;
  Test_StatsStations_Fails;
  Test_StatsFleet_Ok;
  Test_StatsCost_Ok;
  Test_Cost_NonStats_Fails;
  Test_Format_DashboardJson_Fails;
  Test_Format_FleetJson_Ok;
  Test_Format_FleetJsonPretty_Ok;
  Test_Format_FleetCsv_Fails;
  Test_Format_CostJson_Ok;
  Test_Format_CostJsonPretty_Ok;
  Test_Format_CostCsv_Fails;
  Test_Format_CostMonthly_Fails;
  Test_Format_CostYearly_Fails;
  Test_Format_CostDashboard_Fails;
  Test_CostCarId_Ok;
  Test_MaintenanceSource_Cost_Ok;
  Test_MaintenanceSource_NonCost_Fails;
  Test_Format_FleetMonthly_Fails;
  Test_Format_FleetYearly_Fails;
  Test_Format_FleetDashboard_Fails;
  Test_Period_FleetFrom_Fails;
  Test_Period_CostFrom_Ok;
  Test_Format_JsonPretty_Ok;
  Test_Period_Range_Fails;
  Test_Period_Context_Fails;

  WriteLn('[OK]   all validate tests passed');
  Halt(0);
end.
