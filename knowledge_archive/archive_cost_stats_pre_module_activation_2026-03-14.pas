{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : units/u_stats.pas
  CHANGED  : 2026-03-14
  REASON   : behavior change (S11C2/4 aktiviert maintenance-source module im Cost-Flow)
  CONTEXT  : Vor S11C2 war --maintenance-source module als Not-Active Hard Error verdrahtet.
  CONTEXT  : maintenance_source_active war im JSON immer false und Text zeigte fix "active: no".
  BEISPIEL : CollectCostStats wirft Exception fuer msModule.
  BEISPIEL : ShowCostStats schreibt immer "Maintenance source active: no".
}

// Vor-S11C2 Stand (Auszug): Modulmodus noch nicht aktiv.

procedure CollectCostStats(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const ScopeCarId: integer;
  const MaintenanceSource: TMaintenanceSource;
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

  case MaintenanceSource of
    msNone:
      begin
        // Core-only Fallback bleibt explizit sichtbar.
        R.MaintenanceCentsTotal := 0;
        R.MaintenanceSourceActive := False;
        R.MaintenanceSourceNote := 'core-only mode (none)';
      end;
    msModule:
      raise Exception.Create('Fehler: --maintenance-source module ist vorbereitet, aber noch nicht aktiv (S11C2/4).');
  else
    begin
      R.MaintenanceCentsTotal := 0;
      R.MaintenanceSourceActive := False;
      R.MaintenanceSourceNote := 'unknown maintenance source; fallback to 0';
    end;
  end;
  R.TotalCents := R.FuelCentsTotal + R.MaintenanceCentsTotal;
end;

procedure ShowCostStats(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const CarId: integer;
  const MaintenanceSource: TMaintenanceSource);
var
  R: TCostStats;
begin
  CollectCostStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, CarId, MaintenanceSource, R);

  WriteLn('Cost-Stats (MVP)');
  WriteLn('Scope: ', CostScopeLabel(CarId));
  WriteLn('Maintenance source mode: ', MaintenanceSourceToString(MaintenanceSource));
  WriteLn('Maintenance source active: no');
  WriteLn('Period filter: ', CostPeriodLabel(PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided));
  WriteLn('Cars total: ', R.CarsTotal);
  WriteLn('Cars with valid full-tank cycles: ', R.CarsWithCycles);
  WriteLn('Distance (km): ', R.DistKmTotal);
  WriteLn('Fuel cost (cents): ', R.FuelCentsTotal);
  WriteLn('Maintenance cost (cents): ', R.MaintenanceCentsTotal, ' (MVP placeholder)');
  WriteLn('Total cost (cents): ', R.TotalCents);
  WriteLn('Total cost per km (EUR): ', FormatEuroPerKm(R.TotalCents, R.DistKmTotal));
end;
