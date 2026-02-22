{
  u_cli_parse.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-02-19
  UPDATED: 2026-02-22
  AUTHOR : Christof Kempinski
  Zentrale CLI-Parsing-Unit fuer den Kommandozustand.

  Verantwortlichkeiten:
  - Parst CLI-Argumente in den zentralen Zustand `TCommand`.
  - Fuehrt die regelbasierte Validierung der CLI-Kombinationen aus.
  - Liefert im Fehlerfall konsistente Fehlertexte und Fokus-Markierungen.
  ---------------------------------------------------------------------------
}

unit u_cli_parse;

{$mode objfpc}{$H+}

interface

uses
  u_cli_types,
  u_cli_validate;

function ParseCommand: TCommand;

implementation

uses
  SysUtils,
  DateUtils;

// Mapping-Helfer
function CommandKindFromFlag(const S: string; out Kind: TCommandKind): boolean;
begin
  Result := True;
  if S = '--add' then Kind := ckAdd
  else if S = '--list' then Kind := ckList
  else if S = '--edit' then Kind := ckEdit
  else if S = '--delete' then Kind := ckDelete
  else if S = '--stats' then Kind := ckStats
  else Result := False;
end;

// Parst Tabellennamen in Aufzaehlungstyp und erlaubt Singular/Plural.
function ParseTableKind(const S: string; out Kind: TTableKind): boolean;
var
  L: string;
begin
  L := LowerCase(S);
  case L of
    'station', 'stations':
      begin
        Kind := tkStations;
        Exit(True);
      end;
    'fuelup', 'fuelups':
      begin
        Kind := tkFuelups;
        Exit(True);
      end;
  end;
  Result := False;
end;

function TryParseYYYYMM(const S: string; out Y, M: word): boolean;
var
  SY, SM: string;
  iY, iM: integer;
begin
  Result := False;
  if Length(S) <> 7 then Exit;
  if S[5] <> '-' then Exit;

  SY := Copy(S, 1, 4);
  SM := Copy(S, 6, 2);

  if (not TryStrToInt(SY, iY)) or (not TryStrToInt(SM, iM)) then Exit;
  if (iY < 1900) or (iY > 2200) then Exit;
  if (iM < 1) or (iM > 12) then Exit;

  Y := word(iY);
  M := word(iM);
  Result := True;
end;

function TryParseYYYYMMDD(const S: string; out Y, M, D: word): boolean;
var
  SY, SM, SD: string;
  iY, iM, iD: integer;
  Dt: TDateTime;
begin
  Result := False;
  if Length(S) <> 10 then Exit;
  if (S[5] <> '-') or (S[8] <> '-') then Exit;

  SY := Copy(S, 1, 4);
  SM := Copy(S, 6, 2);
  SD := Copy(S, 9, 2);

  if (not TryStrToInt(SY, iY)) or (not TryStrToInt(SM, iM)) or (not TryStrToInt(SD, iD)) then Exit;
  if (iY < 1900) or (iY > 2200) then Exit;

  // echte Kalenderpruefung
  if not TryEncodeDate(iY, iM, iD, Dt) then Exit;

  Y := word(iY);
  M := word(iM);
  D := word(iD);
  Result := True;
end;

// ------------------------------------------------------------
// Zeitraum-Parsing (--from/--to) -> ISO + exklusives Ende
function TryParseFromToValue(const S: string; out FromIso, ToExclIso: string): boolean;
var
  Y, M, D: word;
  DtStart, DtEnd: TDateTime;
begin
  Result := False;
  FromIso := '';
  ToExclIso := '';

  if TryParseYYYYMM(S, Y, M) then
  begin
    DtStart := EncodeDate(Y, M, 1);
    DtEnd := IncMonth(DtStart, 1);
    FromIso := FormatDateTime('yyyy-mm-dd hh:nn:ss', DtStart);
    ToExclIso := FormatDateTime('yyyy-mm-dd hh:nn:ss', DtEnd);
    Exit(True);
  end;

  if TryParseYYYYMMDD(S, Y, M, D) then
  begin
    DtStart := EncodeDate(Y, M, D);
    DtEnd := IncDay(DtStart, 1);
    FromIso := FormatDateTime('yyyy-mm-dd hh:nn:ss', DtStart);
    ToExclIso := FormatDateTime('yyyy-mm-dd hh:nn:ss', DtEnd);
    Exit(True);
  end;
end;

// Zentrale CLI-Parsing- und Regelpruefung; liefert Fehlertext + Fokus-Flag.
function BuildCommand(out Cmd: TCommand): boolean;
var
  i: integer;
  TmpKind: TCommandKind;
  TmpFromIso, TmpToExclIso: string;
begin
  FillChar(Cmd, SizeOf(Cmd), 0);
  Cmd.Kind := ckNone;
  Cmd.HasCommand := False;
  Cmd.Target := tkStations; // Standard egal, wird gesetzt, wenn HasCommand True

  Cmd.SeedStations := 10;
  Cmd.SeedFuelups := 100;
  Cmd.SeedValue := 0;
  Cmd.SeedForce := False;
  Cmd.UseDemoDb := False;
  Cmd.CarId := 0;
  Cmd.CarIdProvided := False;

  i := 1;
  while i <= ParamCount do
  begin
    // Meta-Optionen
    if ParamStr(i) = '--help' then begin Cmd.Help := True; Inc(i); Continue; end;
    if ParamStr(i) = '--version' then begin Cmd.Version := True; Inc(i); Continue; end;
    if ParamStr(i) = '--about' then begin Cmd.About := True; Inc(i); Continue; end;

    // Optionen
    if ParamStr(i) = '--debug' then begin Cmd.Debug := True; Inc(i); Continue; end;
    if ParamStr(i) = '--trace' then begin Cmd.Trace := True; Inc(i); Continue; end;
    if ParamStr(i) = '--quiet' then begin Cmd.Quiet := True; Inc(i); Continue; end;
    if ParamStr(i) = '--detail' then begin Cmd.Detail := True; Inc(i); Continue; end;
    if ParamStr(i) = '--json' then begin Cmd.Json := True; Inc(i); Continue; end;
    if ParamStr(i) = '--monthly' then begin Cmd.Monthly := True; Inc(i); Continue; end;
    if ParamStr(i) = '--yearly' then begin Cmd.Yearly := True; Inc(i); Continue; end;
    if ParamStr(i) = '--csv' then begin Cmd.Csv := True; Inc(i); Continue; end;
    if ParamStr(i) = '--dashboard' then begin Cmd.Dashboard := True; Inc(i); Continue; end;
    if ParamStr(i) = '--pretty' then begin Cmd.Pretty := True; Inc(i); Continue; end;

    // ------------------------------------------------------------
    // Zeitraum-Optionen: --from/--to (nur fuer --stats fuelups)
    if ParamStr(i) = '--from' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --from benoetigt einen Wert (YYYY-MM oder YYYY-MM-DD).'; Cmd.ErrorFocus := efStatsPeriod; Exit(False); end;
      Cmd.FromProvided := True;
      Cmd.PeriodEnabled := True;
      if not TryParseFromToValue(ParamStr(i + 1), Cmd.PeriodFromIso, Cmd.PeriodToExclIso) then
      begin
        Cmd.ErrorMsg := 'Fehler: --from hat ein ungueltiges Format. Erwartet: YYYY-MM oder YYYY-MM-DD.';
        Cmd.ErrorFocus := efStatsPeriod;
        Exit(False);
      end;
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--to' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --to benoetigt einen Wert (YYYY-MM oder YYYY-MM-DD).'; Cmd.ErrorFocus := efStatsPeriod; Exit(False); end;
      Cmd.ToProvided := True;
      Cmd.PeriodEnabled := True;

      // Achtung: --to wird als *exklusives Ende* gespeichert:
      // Wir parsen den Wert ebenfalls als Zeitraum und nehmen das ToExclIso.
      // Beispiel: --to 2025-02-28 -> ToExcl = 2025-03-01 00:00:00
      if not TryParseFromToValue(ParamStr(i + 1), TmpFromIso, TmpToExclIso) then
      begin
        Cmd.ErrorMsg := 'Fehler: --to hat ein ungueltiges Format. Erwartet: YYYY-MM oder YYYY-MM-DD.';
        Cmd.ErrorFocus := efStatsPeriod;
        Exit(False);
      end;

      Cmd.PeriodToExclIso := TmpToExclIso;
      Inc(i, 2);
      Continue;
    end;

    // Seed/Demo-Optionen: --seed ist ein exklusives Hauptkommando, die uebrigen sind Zusatzparameter.
    if ParamStr(i) = '--seed' then
    begin
      if Cmd.HasCommand then
      begin
        Cmd.ErrorMsg := 'Fehler: --seed darf nicht mit anderen Kommandos kombiniert werden.';
        Cmd.ErrorFocus := efSeed;
        Exit(False);
      end;
      Cmd.Kind := ckSeed;
      Cmd.HasCommand := True;
      Inc(i);
      Continue;
    end;

    // Laufzeit-Schalter fuer Seed/Demo
    if ParamStr(i) = '--demo' then
    begin
      Cmd.UseDemoDb := True;
      Inc(i);
      Continue;
    end;

    if ParamStr(i) = '--force' then
    begin
      Cmd.SeedForce := True;
      Inc(i);
      Continue;
    end;

    // Seed-Parameter mit Zahlenwert
    if ParamStr(i) = '--stations' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --stations benötigt eine Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      if not TryStrToInt(ParamStr(i + 1), Cmd.SeedStations) then begin Cmd.ErrorMsg := 'Fehler: --stations benötigt eine gültige Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--fuelups' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --fuelups benötigt eine Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      if not TryStrToInt(ParamStr(i + 1), Cmd.SeedFuelups) then begin Cmd.ErrorMsg := 'Fehler: --fuelups benötigt eine gültige Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--seed-value' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --seed-value benötigt eine Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      if not TryStrToInt(ParamStr(i + 1), Cmd.SeedValue) then begin Cmd.ErrorMsg := 'Fehler: --seed-value benötigt eine gültige Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--show-config' then begin Cmd.ShowConfig := True; Inc(i); Continue; end;
    if ParamStr(i) = '--reset-config' then begin Cmd.ResetConfig := True; Inc(i); Continue; end;

    // DB-Optionen (2 Parameter)
    if ParamStr(i) = '--db' then
    begin
      if i + 1 > ParamCount then
      begin
        Cmd.ErrorMsg := 'Fehler: --db benötigt einen Pfad.';
        Cmd.ErrorFocus := efDb;
        Exit(False);
      end;
      Cmd.DbOverride := ParamStr(i + 1);
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--db-set' then
    begin
      if i + 1 > ParamCount then
      begin
        Cmd.ErrorMsg := 'Fehler: --db-set benötigt einen Pfad.';
        Cmd.ErrorFocus := efDbSet;
        Exit(False);
      end;
      Cmd.DbSet := ParamStr(i + 1);
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--car-id' then
    begin
      if i + 1 > ParamCount then
      begin
        Cmd.ErrorMsg := 'P-001: --car-id benoetigt eine Zahl.';
        Cmd.ErrorFocus := efCarId;
        Exit(False);
      end;
      if not TryStrToInt(ParamStr(i + 1), Cmd.CarId) then
      begin
        Cmd.ErrorMsg := 'P-001: --car-id muss eine gueltige Ganzzahl sein.';
        Cmd.ErrorFocus := efCarId;
        Exit(False);
      end;
      Cmd.CarIdProvided := True;
      Inc(i, 2);
      Continue;
    end;

    // Hauptkommandos: --add/--list/--edit/--delete <stations|fuelups>
    if CommandKindFromFlag(ParamStr(i), TmpKind) then
    begin
      if Cmd.HasCommand then
      begin
        Cmd.ErrorMsg := 'Fehler: Genau EIN Kommando ist erlaubt.';
        Cmd.ErrorFocus := efCommand;
        Exit(False);
      end;

      if i + 1 > ParamCount then
      begin
        Cmd.ErrorMsg := 'Fehler: ' + ParamStr(i) + ' benötigt eine Tabelle.';
        Cmd.ErrorFocus := efCommand;
        Exit(False);
      end;

      // Tabellenart parsen (Singular/Plural)
      if not ParseTableKind(ParamStr(i + 1), Cmd.Target) then
      begin
        Cmd.ErrorMsg := 'Fehler: "' + ParamStr(i + 1) +
          '" ist keine gültige Tabelle (erlaubt: stations|fuelups).';
        Cmd.ErrorFocus := efTarget;
        Exit(False);
      end;

      Cmd.Kind := TmpKind;
      Cmd.HasCommand := True;

      Inc(i, 2);
      Continue;
    end;

    // Unbekannt
    Cmd.ErrorMsg := 'Fehler: Unbekanntes Argument: ' + ParamStr(i);
    Cmd.ErrorFocus := efNone;
    Exit(False);
  end;

  // ----------------
  // Zentrale Validierung (Regeln)

  if (Cmd.DbOverride <> '') and (Cmd.DbSet <> '') then
  begin
    Cmd.ErrorMsg := 'Fehler: --db und --db-set können nicht zusammen verwendet werden.';
    Cmd.ErrorFocus := efDbSet;
    Exit(False);
  end;

  // --seed ist eine isolierte Aktion (Demo-DB)
  // Keine Kombination mit --db / --db-set / --demo oder anderen Commands
  if Cmd.HasCommand and (Cmd.Kind = ckSeed) then
  begin
    if (Cmd.DbOverride <> '') or (Cmd.DbSet <> '') or Cmd.UseDemoDb then
    begin
      Cmd.ErrorMsg :=
        'Fehler: --seed verwendet immer die Demo-DB und darf nicht mit ' +
        '--db, --db-set oder --demo kombiniert werden.';
      Cmd.ErrorFocus := efSeed;
      Exit(False);
    end;
  end;

  if Cmd.HasCommand and (Cmd.Kind = ckSeed) and Cmd.UseDemoDb then
  begin
    Cmd.ErrorMsg := 'Fehler: --demo ist bei --seed nicht erforderlich.';
    Cmd.ErrorFocus := efSeed;
    Exit(False);
  end;

  if not ValidateCommand(Cmd) then
    Exit(False);

  Result := True;
end;

function ParseCommand: TCommand;
begin
  BuildCommand(Result);
end;

end.
