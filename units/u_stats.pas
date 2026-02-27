{
  u_stats.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-27
  AUTHOR : Christof Kempinski
  Statistik-Funktionen fuer Betankungen.

  Verantwortlichkeiten:
  - Auswertung von Tankvorgaengen (fuelups) fuer Volltank-Zyklen.
  - Aggregation von Zeitraum, Zyklen, Strecke, Kraftstoff und Kosten.
  - Tabellenbasierte Ausgabe der Zyklusdaten plus Summenzeile.
  - Dashboard-Ausgabe (Unicode-Boxen) als alternative Textausgabe.
  - JSON-Ausgabe fuer Zyklen/Monate/Jahre (`--json`, optional Pretty).
  - CSV-Ausgabe der Zyklus-/Monatsdaten (maschinenlesbar, strict).
  - Monatsaggregation fuer `--stats fuelups --monthly` (Text + JSON kind "fuelups_monthly").
  - Jahresaggregation fuer `--stats fuelups --yearly` (Text + JSON kind "fuelups_yearly").

  Hinweise:
  - Erwartet die Tabelle fuelups inkl. car_id, is_full_tank, odometer_km, liters_ml, total_cents.
  - Zeitraumgrenzen werden intern als [from inklusiv, to_excl exklusiv] verarbeitet.
  ---------------------------------------------------------------------------
}
unit u_stats;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}

interface

// Liefert die Standard-Zyklusstatistik (Text, ohne Period-Filter).
procedure ShowFuelupStats(const DbPath: string); overload;
// Liefert Zyklus-/Monats-/Jahresstatistik im Textformat mit optionalem Period-Filter.
procedure ShowFuelupStats(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean; const Yearly: boolean = False;
  const CarId: integer = 0); overload;

// Liefert CSV-Statistik mit Standardparametern.
procedure ShowFuelupStatsCsv(const DbPath: string); overload;
// Liefert CSV-Statistik (Zyklen oder Monate) mit optionalem Period-Filter.
procedure ShowFuelupStatsCsv(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const CarId: integer = 0); overload;

// Liefert JSON-Statistik (compact) mit Standardparametern.
procedure ShowFuelupStatsJson(const DbPath: string); overload;
// Liefert JSON-Statistik (compact/pretty, monthly/yearly optional).
procedure ShowFuelupStatsJson(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const Yearly: boolean = False;
  const Pretty: boolean = False;
  const CarId: integer = 0); overload;

// Liefert Dashboard-Statistik mit Standardparametern.
procedure ShowFuelupDashboard(const DbPath: string); overload;
// Liefert Dashboard-Statistik (Textbox-Renderer) mit optionalem Period-Filter.
procedure ShowFuelupDashboard(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const CarId: integer = 0); overload;

implementation

uses
  SysUtils,
  SQLite3Conn, SQLDB, u_log, u_table, u_fmt, u_car_context;

// ------------------------------------------------------------
// Zeitraum-Helper inkl. Debug des effektiven Zeitraums
procedure ResolvePeriodBounds(
  Q: TSQLQuery;
  const PeriodEnabled: boolean;
  const ResolvedCarId: integer;
  var FromIso, ToExclIso: string;
  const FromProvided, ToProvided: boolean);
begin
  if not PeriodEnabled then Exit;

  // Nur --from: to = MAX(fueled_at) der Daten nach from, dann +1 Sekunde exklusiv
  if FromProvided and (not ToProvided) and (ToExclIso = '') and (FromIso <> '') then
  begin
    Q.Close;
    Q.SQL.Text :=
      'SELECT datetime(MAX(fueled_at), ''+1 second'') AS to_excl ' +
      'FROM fuelups ' +
      'WHERE car_id = :car_id ' +
      '  AND fueled_at >= :from;';
    Q.Params.ParamByName('car_id').AsInteger := ResolvedCarId;
    Q.Params.ParamByName('from').AsString := FromIso;
    Q.Open;
    ToExclIso := Q.FieldByName('to_excl').AsString; // kann '' sein bei 0 Rows
    Q.Close;
  end;

  // Nur --to: from = MIN(fueled_at) der Daten vor to_excl
  if ToProvided and (not FromProvided) and (FromIso = '') and (ToExclIso <> '') then
  begin
    Q.Close;
    Q.SQL.Text :=
      'SELECT MIN(fueled_at) AS min_dt ' +
      'FROM fuelups ' +
      'WHERE car_id = :car_id ' +
      '  AND fueled_at < :to_excl;';
    Q.Params.ParamByName('car_id').AsInteger := ResolvedCarId;
    Q.Params.ParamByName('to_excl').AsString := ToExclIso;
    Q.Open;
    FromIso := Q.FieldByName('min_dt').AsString; // kann '' sein bei 0 Rows
    Q.Close;
  end;
end;

procedure ApplyPeriodWhere(
  Q: TSQLQuery;
  const PeriodEnabled: boolean;
  const FromIso, ToExclIso: string);
begin
  if not PeriodEnabled then Exit;

  if FromIso <> '' then
    Q.Params.ParamByName('from').AsString := FromIso;

  if ToExclIso <> '' then
    Q.Params.ParamByName('to_excl').AsString := ToExclIso;
end;

// ------------------------------------------------------------
// Debug: Effektiver Zeitraum nach Kopf-Query
procedure DbgEffectivePeriod(
  const PeriodEnabled: boolean;
  const FromProvided, ToProvided: boolean;
  const EffFromIso, EffToExclIso: string;
  const RowCount: Int64);
var
  Notes: string;
begin
  if not PeriodEnabled then Exit;

  Notes := '';
  if FromProvided and (not ToProvided) then Notes := Notes + ' open-ended-to';
  if ToProvided and (not FromProvided) then Notes := Notes + ' open-ended-from';

  if Notes <> '' then
    Notes := ' (open-ended resolved:' + Notes + ')'
  else
    Notes := ' (closed period)';

  if RowCount = 0 then
    Notes := Notes + ' (no rows after filter)';

  Dbg('Stats period: from=' + EffFromIso + ' to_excl=' + EffToExclIso + Notes);
end;

function FieldInt64OrZero(Q: TSQLQuery; const FieldName: string): Int64;
begin
  if Q.FieldByName(FieldName).IsNull then
    Exit(0);
  Result := Q.FieldByName(FieldName).AsLargeInt;
end;

// ------------------------------------------------------------
// Monats-Aggregator
type
  TMonthAgg = record
    Month: string;        // 'YYYY-MM'
    DistKm: Int64;
    LitersMl: Int64;
    TotalCents: Int64;
  end;
  TMonthAggArray = array of TMonthAgg;

function MonthKeyFromIso(const DtIso: string): string;
begin
  if Length(DtIso) >= 7 then Result := Copy(DtIso, 1, 7) else Result := '????-??';
end;

procedure MonthAggAdd(var A: TMonthAggArray; var N: integer;
  const Key: string; const DistKmA, LitersMlA, CentsA: Int64);
var
  i: integer;
begin
  for i := 0 to N - 1 do
    if A[i].Month = Key then
    begin
      A[i].DistKm += DistKmA;
      A[i].LitersMl += LitersMlA;
      A[i].TotalCents += CentsA;
      Exit;
    end;

  // append
  SetLength(A, N + 1);
  A[N].Month := Key;
  A[N].DistKm := DistKmA;
  A[N].LitersMl := LitersMlA;
  A[N].TotalCents := CentsA;
  Inc(N);
end;

procedure MonthAggSort(var A: TMonthAggArray; const N: integer);
var
  i, j: integer;
  tmp: TMonthAgg;
begin
  for i := 0 to N - 2 do
    for j := i + 1 to N - 1 do
      if A[j].Month < A[i].Month then
      begin
        tmp := A[i]; A[i] := A[j]; A[j] := tmp;
      end;
end;

type
  TYearAgg = record
    Year: string;        // 'YYYY'
    DistKm: Int64;
    LitersMl: Int64;
    TotalCents: Int64;
  end;
  TYearAggArray = array of TYearAgg;

function YearKeyFromMonthKey(const MonthKey: string): string;
begin
  if Length(MonthKey) >= 4 then Result := Copy(MonthKey, 1, 4) else Result := '????';
end;

procedure YearAggAdd(var A: TYearAggArray; var N: integer;
  const Key: string; const DistKmA, LitersMlA, CentsA: Int64);
var
  i: integer;
begin
  for i := 0 to N - 1 do
    if A[i].Year = Key then
    begin
      A[i].DistKm += DistKmA;
      A[i].LitersMl += LitersMlA;
      A[i].TotalCents += CentsA;
      Exit;
    end;

  SetLength(A, N + 1);
  A[N].Year := Key;
  A[N].DistKm := DistKmA;
  A[N].LitersMl := LitersMlA;
  A[N].TotalCents := CentsA;
  Inc(N);
end;

procedure YearAggSort(var A: TYearAggArray; const N: integer);
var
  i, j: integer;
  tmp: TYearAgg;
begin
  for i := 0 to N - 2 do
    for j := i + 1 to N - 1 do
      if A[j].Year < A[i].Year then
      begin
        tmp := A[i]; A[i] := A[j]; A[j] := tmp;
      end;
end;

type
  TStatsHeader = record
    TotalFuelups: Int64;
    FullFuelups: Int64;
    MinDt: string;
    MaxDt: string;
    TotalCentsAll: Int64;
    EffFromIso: string;
    EffToExclIso: string;
  end;

  TCycleRow = record
    Idx: integer;
    DistKm: Int64;
    LitersMl: Int64;
    TotalCents: Int64;
  end;
  TCycleRowArray = array of TCycleRow;

  TStatsCollected = record
    H: TStatsHeader;

    CyclesCount: integer;
    SumDistKm: Int64;
    SumLitersMl: Int64;
    SumTotalCents: Int64;

    Cycles: TCycleRowArray;   // nur befuellt wenn keine Monats/Jahresaggregation aktiv ist
    Months: TMonthAggArray;   // befuellt bei Monthly=True oder Yearly=True
    MonthN: integer;
  end;

function AvgLPer100_x100(const LitersMlA: Int64; const DistKmA: Int64): Int64;
begin
  if DistKmA <= 0 then Exit(0);
  // avg_x100 = (liters_ml * 10) / dist_km  (mit Rundung)
  Result := (LitersMlA * 10 + (DistKmA div 2)) div DistKmA;
end;

procedure CollectFuelupStats(
  const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const Yearly: boolean;
  const CarId: integer;
  out R: TStatsCollected);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  CollectMonths: boolean;

  HaveStartFull: boolean;
  StartOdo: integer;
  AccLitersMl: Int64;
  AccTotalCents: Int64;

  Odo, IsFull: integer;
  RowCarId, CurrentCarId: integer;
  MissedPrev: integer;
  LitersMl: Int64;
  TotalCents: Int64;
  DistKm: integer;
  CycleLitersMl: Int64;
  CycleTotalCents: Int64;

  EndDtIso: string;
  MKey: string;
  ResolvedCarId: integer;
begin
  CollectMonths := Monthly or Yearly;

  FillChar(R, SizeOf(R), 0);
  SetLength(R.Cycles, 0);
  SetLength(R.Months, 0);
  R.MonthN := 0;

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;

    Q.DataBase := Conn;
    Q.Transaction := Tran;

    Conn.Open;
    Tran.StartTransaction;

    ResolvedCarId := ResolveCarIdOrFail(DbPath, CarId);
    Dbg('StatsFuelups: monthly=' + IntToStr(ord(Monthly)) +
        ' yearly=' + IntToStr(ord(Yearly)) +
        ' car_id=' + IntToStr(ResolvedCarId));

    R.H.EffFromIso := PeriodFromIso;
    R.H.EffToExclIso := PeriodToExclIso;

    ResolvePeriodBounds(Q, PeriodEnabled, ResolvedCarId, R.H.EffFromIso, R.H.EffToExclIso, FromProvided, ToProvided);
    Dbg('Stats: period_enabled=' + IntToStr(ord(PeriodEnabled)) +
        ' from=' + R.H.EffFromIso + ' to_excl=' + R.H.EffToExclIso +
        ' monthly=' + IntToStr(ord(Monthly)) +
        ' yearly=' + IntToStr(ord(Yearly)));

    // ------------------------------------------------------------
    // 1) Kopfzeilen-Infos (Anzahl/Zeitraum)
    Q.SQL.Text :=
      'SELECT ' +
      '  COUNT(*) AS cnt, ' +
      '  SUM(CASE WHEN is_full_tank = 1 THEN 1 ELSE 0 END) AS full_cnt, ' +
      '  MIN(fueled_at) AS min_dt, ' +
      '  MAX(fueled_at) AS max_dt, ' +
      '  SUM(total_cents) AS total_cents ' +
      'FROM fuelups ' +
      'WHERE car_id = :car_id ';

    if PeriodEnabled and ((R.H.EffFromIso <> '') or (R.H.EffToExclIso <> '')) then
    begin
      if R.H.EffFromIso <> '' then Q.SQL.Text := Q.SQL.Text + 'AND fueled_at >= :from ';
      if R.H.EffToExclIso <> '' then Q.SQL.Text := Q.SQL.Text + 'AND fueled_at < :to_excl ';
    end;

    Q.SQL.Text := Q.SQL.Text + ';';

    Q.Params.ParamByName('car_id').AsInteger := ResolvedCarId;
    ApplyPeriodWhere(Q, PeriodEnabled, R.H.EffFromIso, R.H.EffToExclIso);
    Q.Open;

    R.H.TotalFuelups := FieldInt64OrZero(Q, 'cnt');
    DbgEffectivePeriod(PeriodEnabled, FromProvided, ToProvided, R.H.EffFromIso, R.H.EffToExclIso, R.H.TotalFuelups);
    R.H.FullFuelups := FieldInt64OrZero(Q, 'full_cnt');
    R.H.MinDt := Q.FieldByName('min_dt').AsString;
    R.H.MaxDt := Q.FieldByName('max_dt').AsString;
    R.H.TotalCentsAll := FieldInt64OrZero(Q, 'total_cents');

    Q.Close;

    // ------------------------------------------------------------
    // 2) Zyklus-Iteration
    Q.SQL.Text :=
      'SELECT id, car_id, fueled_at, odometer_km, liters_ml, is_full_tank, total_cents, missed_previous ' +
      'FROM fuelups ' +
      'WHERE car_id = :car_id ';

    if PeriodEnabled and ((R.H.EffFromIso <> '') or (R.H.EffToExclIso <> '')) then
    begin
      if R.H.EffFromIso <> '' then Q.SQL.Text := Q.SQL.Text + 'AND fueled_at >= :from ';
      if R.H.EffToExclIso <> '' then Q.SQL.Text := Q.SQL.Text + 'AND fueled_at < :to_excl ';
    end;

    Q.SQL.Text := Q.SQL.Text + 'ORDER BY odometer_km ASC, fueled_at ASC, id ASC;';
    Q.Params.ParamByName('car_id').AsInteger := ResolvedCarId;
    ApplyPeriodWhere(Q, PeriodEnabled, R.H.EffFromIso, R.H.EffToExclIso);
    Q.Open;

    HaveStartFull := False;
    StartOdo := 0;
    AccLitersMl := 0;
    AccTotalCents := 0;
    CurrentCarId := 0;

    R.CyclesCount := 0;
    R.SumDistKm := 0;
    R.SumLitersMl := 0;
    R.SumTotalCents := 0;

    while not Q.EOF do
    begin
      // v4: pro Car getrennte Zeitachse (Safety, auch wenn aktuell Default-Car=1)
      RowCarId := Q.FieldByName('car_id').AsInteger;
      MissedPrev := Q.FieldByName('missed_previous').AsInteger;

      // Car-Wechsel: Collector resetten, damit keine Auto-uebergreifenden Zyklen entstehen
      if (CurrentCarId = 0) then
        CurrentCarId := RowCarId
      else if RowCarId <> CurrentCarId then
      begin
        CurrentCarId := RowCarId;
        HaveStartFull := False;
        StartOdo := 0;
        AccLitersMl := 0;
        AccTotalCents := 0;
      end;

      // User-bestaetigte Luecke: reset, bevor der Datensatz verarbeitet wird
      if MissedPrev = 1 then
      begin
        HaveStartFull := False;
        StartOdo := 0;
        AccLitersMl := 0;
        AccTotalCents := 0;
      end;

      Odo := Q.FieldByName('odometer_km').AsInteger;
      LitersMl := Q.FieldByName('liters_ml').AsLargeInt;
      IsFull := Q.FieldByName('is_full_tank').AsInteger;
      TotalCents := Q.FieldByName('total_cents').AsLargeInt;

      if IsFull = 1 then
      begin
        if not HaveStartFull then
        begin
          StartOdo := Odo;
          HaveStartFull := True;
          AccLitersMl := 0;
          AccTotalCents := 0;
        end
        else
        begin
          DistKm := Odo - StartOdo;

          CycleLitersMl := AccLitersMl + LitersMl;
          CycleTotalCents := AccTotalCents + TotalCents;

          if DistKm > 0 then
          begin
            Inc(R.CyclesCount);

            if CollectMonths then
            begin
              EndDtIso := Q.FieldByName('fueled_at').AsString;
              MKey := MonthKeyFromIso(EndDtIso);
              MonthAggAdd(R.Months, R.MonthN, MKey, DistKm, CycleLitersMl, CycleTotalCents);
            end
            else
            begin
              SetLength(R.Cycles, Length(R.Cycles) + 1);
              R.Cycles[High(R.Cycles)].Idx := R.CyclesCount;
              R.Cycles[High(R.Cycles)].DistKm := DistKm;
              R.Cycles[High(R.Cycles)].LitersMl := CycleLitersMl;
              R.Cycles[High(R.Cycles)].TotalCents := CycleTotalCents;
            end;

            R.SumDistKm += DistKm;
            R.SumLitersMl += CycleLitersMl;
            R.SumTotalCents += CycleTotalCents;
          end;

          StartOdo := Odo;
          AccLitersMl := 0;
          AccTotalCents := 0;
        end;
      end
      else
      begin
        if HaveStartFull then
        begin
          AccLitersMl += LitersMl;
          AccTotalCents += TotalCents;
        end;
      end;

      Q.Next;
    end;

    Q.Close;
    Tran.Commit;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

procedure RenderFuelupStatsText(const C: TStatsCollected; const Monthly: boolean; const Yearly: boolean);
var
  i: integer;
  YearN: integer;
  YKey: string;

  LitersTotal: double;
  AvgLPer100: double;
  Fs: TFormatSettings;

  T: TTable;
  TM: TTable;
  TY: TTable;
  MonthsSorted: TMonthAggArray;
  Years: TYearAggArray;

  function SafeStr(const S: string): string;
  begin
    if S = '' then Result := '-' else Result := S;
  end;

  function FormatMlAsLiter(const V: Int64): string;
  begin
    Result := FmtLiterFromMl(V);
  end;

  function FormatCentsAsEuro(const Cents: Int64): string;
  begin
    Result := Format('%d,%.2d', [Cents div 100, Abs(Cents mod 100)]);
  end;

  function FormatConsumption(const LitersMl: Int64; const DistKm: Int64): string;
  var
    L: double;
    V: double;
  begin
    if DistKm <= 0 then
      Exit('0.00');
    L := LitersMl / 1000.0;
    V := (L / DistKm) * 100.0;
    Result := FormatFloat('0.00', V, Fs);
  end;

begin
  if Yearly then
  begin
    WriteLn('Statistik (fuelups) - Jahresuebersicht');
    WriteLn('Zeitraum: ', SafeStr(C.H.MinDt), ' ... ', SafeStr(C.H.MaxDt));
    WriteLn('Tankvorgaenge: ', C.H.TotalFuelups, '  |  Volltank: ', C.H.FullFuelups);

    if C.H.TotalFuelups = 0 then
    begin
      WriteLn('Keine Tankvorgaenge vorhanden.');
      Exit;
    end;

    YearN := 0;
    SetLength(Years, 0);

    for i := 0 to C.MonthN - 1 do
    begin
      YKey := YearKeyFromMonthKey(C.Months[i].Month);
      YearAggAdd(Years, YearN, YKey, C.Months[i].DistKm, C.Months[i].LitersMl, C.Months[i].TotalCents);
    end;

    YearAggSort(Years, YearN);

    if YearN = 0 then
    begin
      WriteLn('Jahre: 0');
      WriteLn('Hinweis: Es wurden keine gueltigen Volltank-Zyklen gefunden.');
      Exit;
    end;

    TY := TTable.Create;
    try
      TY.AddCol('Jahr', taLeft);
      TY.AddCol('km', taRight);
      TY.AddCol('Liter', taRight);
      TY.AddCol('Ø L/100km', taRight);
      TY.AddCol('Kosten (EUR)', taRight);

      for i := 0 to YearN - 1 do
        TY.AddRow([
          Years[i].Year,
          IntToStr(Years[i].DistKm),
          FormatMlAsLiter(Years[i].LitersMl),
          FmtScaledInt(AvgLPer100_x100(Years[i].LitersMl, Years[i].DistKm), 2, ''),
          FormatCentsAsEuro(Years[i].TotalCents)
        ]);

      TY.AddSep;
      TY.AddRow([
        'Σ',
        IntToStr(C.SumDistKm),
        FormatMlAsLiter(C.SumLitersMl),
        FmtScaledInt(AvgLPer100_x100(C.SumLitersMl, C.SumDistKm), 2, ''),
        FormatCentsAsEuro(C.SumTotalCents)
      ]);

      WriteLn('');
      TY.Write;
    finally
      TY.Free;
    end;

    WriteLn('');
    WriteLn('Jahre: ', YearN);
    WriteLn('Strecke: ', C.SumDistKm, ' km');
    WriteLn('Kraftstoff: ', FormatMlAsLiter(C.SumLitersMl));
    WriteLn('Ø Verbrauch: ', FmtScaledInt(AvgLPer100_x100(C.SumLitersMl, C.SumDistKm), 2, ''), ' L/100 km');
    WriteLn('Kosten gesamt (nur gueltige Zyklen): ', FormatCentsAsEuro(C.SumTotalCents), ' EUR');
    Exit;
  end;

  Fs := DefaultFormatSettings;
  Fs.ThousandSeparator := '.';
  Fs.DecimalSeparator := ',';

  WriteLn('Statistik (fuelups) - Volltank-Zyklen');
  WriteLn('Zeitraum: ', SafeStr(C.H.MinDt), ' ... ', SafeStr(C.H.MaxDt));
  WriteLn('Tankvorgänge: ', C.H.TotalFuelups, '  |  Volltank: ', C.H.FullFuelups);

  if C.H.TotalFuelups = 0 then
  begin
    WriteLn('Keine Tankvorgänge vorhanden.');
    Exit;
  end;

  if C.CyclesCount = 0 then
  begin
    WriteLn('Zyklen: 0');
    WriteLn('Hinweis: Es wurden keine gültigen Volltank-Zyklen gefunden.');
    Exit;
  end;

  if (not Monthly) and (Length(C.Cycles) > 0) then
  begin
    T := TTable.Create;
    try
      T.AddCol('Zyklus', taRight);
      T.AddCol('km', taRight);
      T.AddCol('Liter', taRight);
      T.AddCol('Ø L/100km', taRight);
      T.AddCol('Kosten (EUR)', taRight);

      for i := 0 to High(C.Cycles) do
        T.AddRow([
          IntToStr(C.Cycles[i].Idx),
          IntToStr(C.Cycles[i].DistKm),
          FormatMlAsLiter(C.Cycles[i].LitersMl),
          FormatConsumption(C.Cycles[i].LitersMl, C.Cycles[i].DistKm),
          FormatCentsAsEuro(C.Cycles[i].TotalCents)
        ]);

      T.AddSep;
      T.AddRow([
        'Σ',
        IntToStr(C.SumDistKm),
        FormatMlAsLiter(C.SumLitersMl),
        FormatConsumption(C.SumLitersMl, C.SumDistKm),
        FormatCentsAsEuro(C.SumTotalCents)
      ]);

      WriteLn('');
      T.Write;
    finally
      T.Free;
    end;
  end;

  if Monthly and (C.MonthN > 0) then
  begin
    SetLength(MonthsSorted, C.MonthN);
    for i := 0 to C.MonthN - 1 do
      MonthsSorted[i] := C.Months[i];
    MonthAggSort(MonthsSorted, C.MonthN);

    WriteLn('');
    WriteLn('Monatsstatistik (aus gültigen Volltank-Zyklen)');

    TM := TTable.Create;
    try
      TM.AddCol('Monat', taLeft);
      TM.AddCol('km', taRight);
      TM.AddCol('Liter', taRight);
      TM.AddCol('Ø L/100km', taRight);
      TM.AddCol('Kosten (EUR)', taRight);

      for i := 0 to C.MonthN - 1 do
        TM.AddRow([
          MonthsSorted[i].Month,
          IntToStr(MonthsSorted[i].DistKm),
          FormatMlAsLiter(MonthsSorted[i].LitersMl),
          FormatConsumption(MonthsSorted[i].LitersMl, MonthsSorted[i].DistKm),
          FormatCentsAsEuro(MonthsSorted[i].TotalCents)
        ]);

      TM.Write;
    finally
      TM.Free;
    end;
  end;

  LitersTotal := C.SumLitersMl / 1000.0;

  if C.SumDistKm > 0 then
    AvgLPer100 := (LitersTotal / C.SumDistKm) * 100.0
  else
    AvgLPer100 := 0.0;

  WriteLn('Zyklen: ', C.CyclesCount);
  WriteLn('Strecke: ', C.SumDistKm, ' km');
  WriteLn('Kraftstoff: ', FormatMlAsLiter(C.SumLitersMl));
  WriteLn('Ø Verbrauch: ', FormatFloat('0.00', AvgLPer100, Fs), ' L/100 km');

  // Kosten-Klarheit: SQL-Summe (alle Tankungen) vs. Zyklus-Summe (nur gültige Zyklen)
  if C.H.TotalCentsAll = C.SumTotalCents then
    WriteLn('Kosten gesamt: ', FormatCentsAsEuro(C.SumTotalCents), ' EUR')
  else
  begin
    WriteLn('Kosten gesamt (alle Tankungen): ', FormatCentsAsEuro(C.H.TotalCentsAll), ' EUR');
    WriteLn('Kosten gesamt (nur gültige Zyklen): ', FormatCentsAsEuro(C.SumTotalCents), ' EUR');
  end;
end;

procedure RenderFuelupStatsCsv(const R: TStatsCollected; const Monthly: boolean);
var
  i: integer;
  MonthsSorted: TMonthAggArray;
begin
  if Monthly then
  begin
    // Kopfzeile immer
    WriteLn('month,dist_km,liters_ml,avg_l_per_100km_x100,total_cents');

    if R.MonthN <= 0 then Exit;

    // stabile Reihenfolge
    SetLength(MonthsSorted, R.MonthN);
    for i := 0 to R.MonthN - 1 do
      MonthsSorted[i] := R.Months[i];
    MonthAggSort(MonthsSorted, R.MonthN);

    for i := 0 to R.MonthN - 1 do
      WriteLn(CsvJoin([
        CsvTokenStrict(MonthsSorted[i].Month),
        IntToStr(MonthsSorted[i].DistKm),
        IntToStr(MonthsSorted[i].LitersMl),
        IntToStr(AvgLPer100_x100(MonthsSorted[i].LitersMl, MonthsSorted[i].DistKm)),
        IntToStr(MonthsSorted[i].TotalCents)
      ]));
  end
  else
  begin
    WriteLn('idx,dist_km,liters_ml,avg_l_per_100km_x100,total_cents');

    if Length(R.Cycles) = 0 then Exit;

    for i := 0 to High(R.Cycles) do
      WriteLn(CsvJoin([
        IntToStr(R.Cycles[i].Idx),
        IntToStr(R.Cycles[i].DistKm),
        IntToStr(R.Cycles[i].LitersMl),
        IntToStr(AvgLPer100_x100(R.Cycles[i].LitersMl, R.Cycles[i].DistKm)),
        IntToStr(R.Cycles[i].TotalCents)
      ]));
  end;
end;

type
  TJsonWriter = record
    Pretty: boolean;
    Ind: integer;
    procedure W(const S: string);
    procedure NL;
    procedure SP;
    procedure IndentInc;
    procedure IndentDec;
    procedure IndentWrite;
  end;

procedure TJsonWriter.W(const S: string);
begin
  Write(S);
end;

procedure TJsonWriter.NL;
begin
  if Pretty then WriteLn;
end;

procedure TJsonWriter.SP;
begin
  if Pretty then Write(' ');
end;

procedure TJsonWriter.IndentInc;
begin
  Inc(Ind);
end;

procedure TJsonWriter.IndentDec;
begin
  if Ind > 0 then Dec(Ind);
end;

procedure TJsonWriter.IndentWrite;
var
  i: integer;
begin
  if not Pretty then Exit;
  for i := 1 to Ind * 2 do Write(' ');
end;

function JsonEscape(const S: string): string;
var
  k: integer;
  ch: char;
begin
  Result := '';
  for k := 1 to Length(S) do
  begin
    ch := S[k];
    case ch of
      '\': Result += '\\';
      '"': Result += '\"';
      #8: Result += '\b';
      #9: Result += '\t';
      #10: Result += '\n';
      #12: Result += '\f';
      #13: Result += '\r';
    else
      Result += ch;
    end;
  end;
end;

procedure RenderFuelupStatsJson(const R: TStatsCollected; const Monthly: boolean; const Yearly: boolean; const Pretty: boolean);
var
  J: TJsonWriter;
  i: integer;
  YearN: integer;
  YKey: string;
  MonthsSorted: TMonthAggArray;
  Years: TYearAggArray;
begin
  J.Pretty := Pretty;
  J.Ind := 0;

  if Yearly then
  begin
    YearN := 0;
    SetLength(Years, 0);
    for i := 0 to R.MonthN - 1 do
    begin
      YKey := YearKeyFromMonthKey(R.Months[i].Month);
      YearAggAdd(Years, YearN, YKey, R.Months[i].DistKm, R.Months[i].LitersMl, R.Months[i].TotalCents);
    end;
    YearAggSort(Years, YearN);

    J.W('{'); J.NL;
    J.IndentInc;

    J.IndentWrite; J.W('"kind":'); J.SP; J.W('"fuelups_yearly",'); J.NL;

    J.IndentWrite; J.W('"period":'); J.SP; J.W('{"from":'); J.SP;
    J.W('"'); J.W(JsonEscape(R.H.MinDt)); J.W('"'); J.W(',');
    J.SP; J.W('"to":'); J.SP; J.W('"'); J.W(JsonEscape(R.H.MaxDt)); J.W('"');
    J.W('},'); J.NL;

    J.IndentWrite; J.W('"fuelups_total":'); J.SP; J.W(IntToStr(R.H.TotalFuelups)); J.W(','); J.NL;
    J.IndentWrite; J.W('"fuelups_full":'); J.SP; J.W(IntToStr(R.H.FullFuelups)); J.W(','); J.NL;

    J.IndentWrite; J.W('"rows":'); J.SP; J.W('['); J.NL;
    J.IndentInc;
    for i := 0 to YearN - 1 do
    begin
      J.IndentWrite;
      J.W('{"year":"'); J.W(JsonEscape(Years[i].Year));
      J.W('","dist_km":'); J.W(IntToStr(Years[i].DistKm));
      J.W(',"liters_ml":'); J.W(IntToStr(Years[i].LitersMl));
      J.W(',"avg_l_per_100km_x100":'); J.W(IntToStr(AvgLPer100_x100(Years[i].LitersMl, Years[i].DistKm)));
      J.W(',"total_cents":'); J.W(IntToStr(Years[i].TotalCents));
      J.W('}');
      if i < YearN - 1 then J.W(',');
      J.NL;
    end;
    J.IndentDec;
    J.IndentWrite; J.W(']'); J.NL;

    J.IndentDec;
    J.W('}'); J.NL;
    Exit;
  end;

  if Monthly then
  begin
    SetLength(MonthsSorted, R.MonthN);
    for i := 0 to R.MonthN - 1 do
      MonthsSorted[i] := R.Months[i];
    MonthAggSort(MonthsSorted, R.MonthN);

    J.W('{'); J.NL;
    J.IndentInc;

    J.IndentWrite; J.W('"kind":'); J.SP; J.W('"fuelups_monthly",'); J.NL;

    J.IndentWrite; J.W('"period":'); J.SP; J.W('{"from":'); J.SP;
    J.W('"'); J.W(JsonEscape(R.H.MinDt)); J.W('"'); J.W(',');
    J.SP; J.W('"to":'); J.SP; J.W('"'); J.W(JsonEscape(R.H.MaxDt)); J.W('"');
    J.W('},'); J.NL;

    J.IndentWrite; J.W('"fuelups_total":'); J.SP; J.W(IntToStr(R.H.TotalFuelups)); J.W(','); J.NL;
    J.IndentWrite; J.W('"fuelups_full":'); J.SP; J.W(IntToStr(R.H.FullFuelups)); J.W(','); J.NL;

    J.IndentWrite; J.W('"rows":'); J.SP; J.W('['); J.NL;
    J.IndentInc;

    for i := 0 to R.MonthN - 1 do
    begin
      J.IndentWrite;
      J.W('{"month":"'); J.W(JsonEscape(MonthsSorted[i].Month));
      J.W('","dist_km":'); J.W(IntToStr(MonthsSorted[i].DistKm));
      J.W(',"liters_ml":'); J.W(IntToStr(MonthsSorted[i].LitersMl));
      J.W(',"avg_l_per_100km_x100":'); J.W(IntToStr(AvgLPer100_x100(MonthsSorted[i].LitersMl, MonthsSorted[i].DistKm)));
      J.W(',"total_cents":'); J.W(IntToStr(MonthsSorted[i].TotalCents));
      J.W('}');
      if i < R.MonthN - 1 then J.W(',');
      J.NL;
    end;

    J.IndentDec;
    J.IndentWrite; J.W(']'); J.NL;

    J.IndentDec;
    J.W('}'); J.NL;
  end
  else
  begin
    J.W('{'); J.NL;
    J.IndentInc;

    J.IndentWrite; J.W('"kind":'); J.SP; J.W('"fuelups_full_tank_cycles",'); J.NL;

    J.IndentWrite; J.W('"period":'); J.SP; J.W('{"from":'); J.SP;
    J.W('"'); J.W(JsonEscape(R.H.MinDt)); J.W('"'); J.W(',');
    J.SP; J.W('"to":'); J.SP; J.W('"'); J.W(JsonEscape(R.H.MaxDt)); J.W('"');
    J.W('},'); J.NL;

    J.IndentWrite; J.W('"fuelups_total":'); J.SP; J.W(IntToStr(R.H.TotalFuelups)); J.W(','); J.NL;
    J.IndentWrite; J.W('"fuelups_full":'); J.SP; J.W(IntToStr(R.H.FullFuelups)); J.W(','); J.NL;

    J.IndentWrite; J.W('"cycles":'); J.SP; J.W('['); J.NL;
    J.IndentInc;

    for i := 0 to High(R.Cycles) do
    begin
      J.IndentWrite;
      J.W('{"idx":'); J.SP; J.W(IntToStr(R.Cycles[i].Idx));
      J.W(',"dist_km":'); J.SP; J.W(IntToStr(R.Cycles[i].DistKm));
      J.W(',"liters_ml":'); J.SP; J.W(IntToStr(R.Cycles[i].LitersMl));
      J.W(',"avg_l_per_100km_x100":'); J.SP; J.W(IntToStr(AvgLPer100_x100(R.Cycles[i].LitersMl, R.Cycles[i].DistKm)));
      J.W(',"total_cents":'); J.SP; J.W(IntToStr(R.Cycles[i].TotalCents));
      J.W('}');
      if i < High(R.Cycles) then J.W(',');
      J.NL;
    end;

    J.IndentDec;
    J.IndentWrite; J.W('],'); J.NL;

    J.IndentWrite; J.W('"sum":'); J.SP; J.W('{'); J.NL;
    J.IndentInc;

    J.IndentWrite; J.W('"cycles":'); J.SP; J.W(IntToStr(R.CyclesCount)); J.W(','); J.NL;
    J.IndentWrite; J.W('"dist_km":'); J.SP; J.W(IntToStr(R.SumDistKm)); J.W(','); J.NL;
    J.IndentWrite; J.W('"liters_ml":'); J.SP; J.W(IntToStr(R.SumLitersMl)); J.W(','); J.NL;
    J.IndentWrite; J.W('"avg_l_per_100km_x100":'); J.SP; J.W(IntToStr(AvgLPer100_x100(R.SumLitersMl, R.SumDistKm))); J.W(','); J.NL;
    J.IndentWrite; J.W('"total_cents_all":'); J.SP; J.W(IntToStr(R.H.TotalCentsAll)); J.W(','); J.NL;
    J.IndentWrite; J.W('"total_cents_cycles":'); J.SP; J.W(IntToStr(R.SumTotalCents)); J.NL;

    J.IndentDec;
    J.IndentWrite; J.W('}'); J.NL;

    J.IndentDec;
    J.W('}'); J.NL;
  end;
end;

procedure ShowFuelupStats(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const Yearly: boolean;
  const CarId: integer); overload;
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, Monthly, Yearly, CarId, R);
  RenderFuelupStatsText(R, Monthly, Yearly);
end;

procedure ShowFuelupStats(const DbPath: string); overload;
begin
  ShowFuelupStats(DbPath, False, '', '', False, False, False, False, 0);
end;

procedure ShowFuelupStatsCsv(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const CarId: integer); overload;
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, Monthly, False, CarId, R);
  RenderFuelupStatsCsv(R, Monthly);
end;

procedure ShowFuelupStatsCsv(const DbPath: string); overload;
begin
  ShowFuelupStatsCsv(DbPath, False, '', '', False, False, False, 0);
end;

procedure ShowFuelupStatsJson(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const Yearly: boolean;
  const Pretty: boolean;
  const CarId: integer); overload;
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, Monthly, Yearly, CarId, R);
  RenderFuelupStatsJson(R, Monthly, Yearly, Pretty);
end;

procedure ShowFuelupStatsJson(const DbPath: string); overload;
begin
  ShowFuelupStatsJson(DbPath, False, '', '', False, False, False, False, False, 0);
end;

procedure RenderFuelupDashboardText(const C: TStatsCollected; const Monthly: boolean);
const
  W = 56;
  MAX_ROWS = 8;
var
  AvgX100: Int64;
  i: Integer;

  MonthsSorted: TMonthAggArray;
  MaxCents: Int64;

  function SafeStr(const S: string): string;
  begin
    if S = '' then Result := '-' else Result := S;
  end;

  function PeriodLine: string;
  begin
    Result := SafeStr(C.H.MinDt) + ' ... ' + SafeStr(C.H.MaxDt);
  end;

begin
  BoxTop(W);
  BoxLine(W, 'BETANKUNGEN – STATUS');
  BoxSep(W);

  BoxKV(W, 'Zeitraum', PeriodLine);
  BoxKV(W, 'Tankvorgaenge', IntToStr(C.H.TotalFuelups) + ' | Volltank: ' + IntToStr(C.H.FullFuelups));

  if C.H.TotalFuelups = 0 then
  begin
    BoxSep(W);
    BoxLine(W, 'Keine Tankvorgaenge vorhanden.');
    BoxBottom(W);
    Exit;
  end;

  BoxKV(W, 'Zyklen', IntToStr(C.CyclesCount));

  if C.CyclesCount = 0 then
  begin
    BoxSep(W);
    BoxLine(W, 'Hinweis: Keine gueltigen Volltank-Zyklen gefunden.');
    BoxBottom(W);
    Exit;
  end;

  AvgX100 := AvgLPer100_x100(C.SumLitersMl, C.SumDistKm);

  BoxKV(W, 'Gesamt-km', IntToStr(C.SumDistKm));
  BoxKV(W, 'Gesamt-Liter', FmtLiterFromMl(C.SumLitersMl));
  BoxKV(W, 'Ø Verbrauch', FmtScaledInt(AvgX100, 2, 'L/100km'));
  BoxKV(W, 'Kosten (Zyklen)', FmtEuroFromCents(C.SumTotalCents));
  BoxKV(W, 'Kosten (alle)', FmtEuroFromCents(C.H.TotalCentsAll));

  // ---------------- Monatsblock (mit farbigen Kosten-Balken)
  if Monthly and (C.MonthN > 0) then
  begin
    BoxSep(W);
    BoxLine(W, 'Monatskosten');

    MonthsSorted := Copy(C.Months, 0, C.MonthN);
    MonthAggSort(MonthsSorted, Length(MonthsSorted));

    MaxCents := 0;
    for i := 0 to High(MonthsSorted) do
      if MonthsSorted[i].TotalCents > MaxCents then
        MaxCents := MonthsSorted[i].TotalCents;

    for i := 0 to High(MonthsSorted) do
    begin
      if i >= MAX_ROWS then
      begin
        BoxLine(W, '... (' + IntToStr(Length(MonthsSorted) - MAX_ROWS) + ' weitere)');
        Break;
      end;

      BoxLineAnsi(W,
        MonthsSorted[i].Month + '  ' +
        RenderCostBar(MonthsSorted[i].TotalCents, MaxCents) + '  ' +
        FmtEuroFromCents(MonthsSorted[i].TotalCents)
      );
    end;
  end;

  BoxBottom(W);
end;

procedure ShowFuelupDashboard(const DbPath: string);
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, False, '', '', False, False, False, False, 0, R);
  RenderFuelupDashboardText(R, False);
end;

procedure ShowFuelupDashboard(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const CarId: integer);
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, Monthly, False, CarId, R);
  RenderFuelupDashboardText(R, Monthly);
end;

end.
