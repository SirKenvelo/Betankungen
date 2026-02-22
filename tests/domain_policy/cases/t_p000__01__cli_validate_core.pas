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
  Ok('Policy: --stats only fuelups');
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
  Test_Format_DashboardJson_Fails;
  Test_Format_JsonPretty_Ok;
  Test_Period_Range_Fails;
  Test_Period_Context_Fails;

  WriteLn('[OK]   all validate tests passed');
  Halt(0);
end.
