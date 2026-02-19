{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : u_db_common.pas
  REMOVED  : 2026-01-21
  REASON   : Ersetzt durch stringbasiertes Parsing (bon-exakt)
  CONTEXT  : Prototyp-Funktion zur Vereinheitlichung von
             ParseEuroToCents / ParseEurPerLiterToMilli / ParseLitersToMl
}

function ParseToMinorUnit(const S: string; const AMultiplier: Integer): int64;
var
  LValue: Double;
  LSettings: TFormatSettings;
  LNormalizedS: string;
begin
  Result := 0;
  if Trim(S) = '' then Exit;

  LNormalizedS := StringReplace(S, ',', '.', [rfReplaceAll]);
  LSettings := DefaultFormatSettings; 
  LSettings.DecimalSeparator := '.';

  try
    LValue := StrToFloat(LNormalizedS, LSettings);

    // Negativ Eingaben abfangen
    if LValue < 0 then
      raise Exception.Create('ParseToMinorUnit: Wert darf nicht negativ sein');

    // Der Multiplikator bestimmt die Ziel-Einheit (100 für Cent, 1000 für Milli-Einheiten)
    Result := Round(LValue * AMultiplier);
  except
    on E: EConvertError do
      raise Exception.Create('Konvertierungsfehler bei Wert: ' + S);
  end;
end;