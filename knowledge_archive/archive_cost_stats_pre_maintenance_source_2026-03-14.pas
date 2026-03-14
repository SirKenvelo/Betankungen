{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : units/u_stats.pas
  CHANGED  : 2026-03-14
  REASON   : behavior change (S11C1/4 expliziter maintenance-source Integrationspfad)
  CONTEXT  : Vor S11C1 war Cost immer implizit core-only (maintenance placeholder = 0)
  CONTEXT  : Kein expliziter maintenance_source_* Contract in Text/JSON vorhanden
  BEISPIEL : ShowCostStats(DbPath, ..., CarId) ohne MaintenanceSource-Parameter
  BEISPIEL : RenderCostStatsJson ohne maintenance_source_mode/active
}

// Vor-S11C1 Stand (Auszug): Cost-Collector + Renderer + ShowCostStats/-Json

procedure CollectCostStats(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const ScopeCarId: integer;
  out R: TCostStats);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  CarIds: array of integer;
  CarN: integer;
  i: integer;
  CarId: integer;
  CarStats: TStatsCollected;
begin
  FillChar(R, SizeOf(R), 0);
  SetLength(CarIds, 0);
  CarN := 0;

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    try
      Conn.DatabaseName := DbPath;
      Conn.Transaction := Tran;
      Q.Database := Conn;
      Q.Transaction := Tran;
      Conn.Open;

      if ScopeCarId > 0 then
      begin
        Q.SQL.Text := 'SELECT id FROM cars WHERE id = :car_id ORDER BY id;';
        Q.Params.ParamByName('car_id').AsInteger := ScopeCarId;
      end
      else
        Q.SQL.Text := 'SELECT id FROM cars ORDER BY id;';
      Q.Open;
      while not Q.EOF do
      begin
        SetLength(CarIds, CarN + 1);
        CarIds[CarN] := Q.FieldByName('id').AsInteger;
        Inc(CarN);
        Q.Next;
      end;
      Q.Close;
    except
      on E: Exception do
        raise Exception.Create('Cost-Stats fehlgeschlagen: ' + E.Message);
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;

  R.CarsTotal := CarN;

  for i := 0 to CarN - 1 do
  begin
    CarId := CarIds[i];
    CollectFuelupStats(
      DbPath,
      PeriodEnabled,
      PeriodFromIso,
      PeriodToExclIso,
      FromProvided,
      ToProvided,
      False,
      False,
      CarId,
      CarStats);

    if CarStats.CyclesCount > 0 then
      Inc(R.CarsWithCycles);

    R.DistKmTotal += CarStats.SumDistKm;
    R.FuelCentsTotal += CarStats.SumTotalCents;
  end;

  // MVP-Basis: maintenance liegt noch nicht im Core vor.
  R.MaintenanceCentsTotal := 0;
  R.TotalCents := R.FuelCentsTotal + R.MaintenanceCentsTotal;
end;

procedure RenderCostStatsJson(const R: TCostStats;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const CarId: integer;
  const Pretty: boolean;
  const AppVersion: string);
var
  J: TJsonWriter;
  CostPerKmAvailable: boolean;
  FuelPerKmX1000: Int64;
  MaintenancePerKmX1000: Int64;
  TotalPerKmX1000: Int64;
  ScopeMode: string;
begin
  CostPerKmAvailable := R.DistKmTotal > 0;
  if CarId > 0 then
    ScopeMode := 'single_car'
  else
    ScopeMode := 'all_cars';

  if CostPerKmAvailable then
  begin
    FuelPerKmX1000 := CostPerKmEurX1000(R.FuelCentsTotal, R.DistKmTotal);
    MaintenancePerKmX1000 := CostPerKmEurX1000(R.MaintenanceCentsTotal, R.DistKmTotal);
    TotalPerKmX1000 := CostPerKmEurX1000(R.TotalCents, R.DistKmTotal);
  end
  else
  begin
    FuelPerKmX1000 := 0;
    MaintenancePerKmX1000 := 0;
    TotalPerKmX1000 := 0;
  end;

  J.Pretty := Pretty;
  J.Ind := 0;

  J.W('{'); J.NL;
  J.IndentInc;

  WriteJsonMetaHeader(J, 'cost_mvp', AppVersion);

  J.IndentWrite; J.W('"cost":'); J.SP; J.W('{'); J.NL;
  J.IndentInc;
  J.IndentWrite; J.W('"scope_mode":'); J.SP; J.W('"'); J.W(ScopeMode); J.W('"'); J.W(','); J.NL;
  J.IndentWrite; J.W('"scope_car_id":'); J.SP; J.W(IntToStr(CarId)); J.W(','); J.NL;
  J.IndentWrite; J.W('"period_enabled":'); J.SP;
  if PeriodEnabled then J.W('true') else J.W('false');
  J.W(','); J.NL;
  J.IndentWrite; J.W('"period_from":'); J.SP; J.W('"'); J.W(JsonEscape(PeriodFromIso)); J.W('"'); J.W(','); J.NL;
  J.IndentWrite; J.W('"period_to_exclusive":'); J.SP; J.W('"'); J.W(JsonEscape(PeriodToExclIso)); J.W('"'); J.W(','); J.NL;
  J.IndentWrite; J.W('"period_from_provided":'); J.SP;
  if FromProvided then J.W('true') else J.W('false');
  J.W(','); J.NL;
  J.IndentWrite; J.W('"period_to_provided":'); J.SP;
  if ToProvided then J.W('true') else J.W('false');
  J.W(','); J.NL;
  J.IndentWrite; J.W('"cars_total":'); J.SP; J.W(IntToStr(R.CarsTotal)); J.W(','); J.NL;
  J.IndentWrite; J.W('"cars_with_cycles":'); J.SP; J.W(IntToStr(R.CarsWithCycles)); J.W(','); J.NL;
  J.IndentWrite; J.W('"distance_km_total":'); J.SP; J.W(IntToStr(R.DistKmTotal)); J.W(','); J.NL;
  J.IndentWrite; J.W('"fuel_cents_total":'); J.SP; J.W(IntToStr(R.FuelCentsTotal)); J.W(','); J.NL;
  J.IndentWrite; J.W('"maintenance_cents_total":'); J.SP; J.W(IntToStr(R.MaintenanceCentsTotal)); J.W(','); J.NL;
  J.IndentWrite; J.W('"total_cents":'); J.SP; J.W(IntToStr(R.TotalCents)); J.W(','); J.NL;
  J.IndentWrite; J.W('"cost_per_km_available":'); J.SP;
  if CostPerKmAvailable then J.W('true') else J.W('false');
  J.W(','); J.NL;
  J.IndentWrite; J.W('"fuel_cost_per_km_eur_x1000":'); J.SP; J.W(IntToStr(FuelPerKmX1000)); J.W(','); J.NL;
  J.IndentWrite; J.W('"maintenance_cost_per_km_eur_x1000":'); J.SP; J.W(IntToStr(MaintenancePerKmX1000)); J.W(','); J.NL;
  J.IndentWrite; J.W('"total_cost_per_km_eur_x1000":'); J.SP; J.W(IntToStr(TotalPerKmX1000)); J.NL;
  J.IndentDec;
  J.IndentWrite; J.W('}'); J.NL;

  J.IndentDec;
  J.W('}'); J.NL;
end;

procedure ShowCostStats(const DbPath: string);
begin
  ShowCostStats(DbPath, False, '', '', False, False, 0);
end;

procedure ShowCostStats(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const CarId: integer);
var
  R: TCostStats;
begin
  CollectCostStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, CarId, R);

  WriteLn('Cost-Stats (MVP)');
  WriteLn('Scope: ', CostScopeLabel(CarId));
  WriteLn('Period filter: ', CostPeriodLabel(PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided));
  WriteLn('Cars total: ', R.CarsTotal);
  WriteLn('Cars with valid full-tank cycles: ', R.CarsWithCycles);
  WriteLn('Distance (km): ', R.DistKmTotal);
  WriteLn('Fuel cost (cents): ', R.FuelCentsTotal);
  WriteLn('Maintenance cost (cents): ', R.MaintenanceCentsTotal, ' (MVP placeholder)');
  WriteLn('Total cost (cents): ', R.TotalCents);
  WriteLn('Total cost per km (EUR): ', FormatEuroPerKm(R.TotalCents, R.DistKmTotal));
end;

procedure ShowCostStatsJson(const DbPath: string;
  const Pretty: boolean;
  const AppVersion: string);
begin
  ShowCostStatsJson(DbPath, False, '', '', False, False, 0, Pretty, AppVersion);
end;

procedure ShowCostStatsJson(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const CarId: integer;
  const Pretty: boolean;
  const AppVersion: string);
var
  R: TCostStats;
begin
  CollectCostStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, CarId, R);
  RenderCostStatsJson(
    R,
    PeriodEnabled,
    PeriodFromIso,
    PeriodToExclIso,
    FromProvided,
    ToProvided,
    CarId,
    Pretty,
    AppVersion);
end;
