{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : u_db_common.pas
  REMOVED  : 2026-01-21
  REASON   : Ersetzt durch stringbasiertes Parsing (bon-exakt)
  CONTEXT  : Prototyp-Funktion zur Umrechnung [EUR/L] > [ml]
}

function ParseEurPerLiterToMilli(const S: string): int64;
var
  LValue: Double;
  LSettings: TFormatSettings;
  LNormalizedS: string;
begin
  Result := 0;
  if Trim(S) = '' then Exit;

  // 1. Normalisierung: Komma zu Punkt wandeln
  LNormalizedS := StringReplace(S, ',', '.', [rfReplaceAll]);

  // 2. FormatSettings für punkt-basierte Konvertierung vorbereiten
  LSettings := DefaultFormatSettings; 
  LSettings.DecimalSeparator := '.';

  try
    // 3. String zu Fließkommazahl wandeln
    LValue := StrToFloat(LNormalizedS, LSettings);

    // 4. Negativ Eingaben abfangen
    if LValue < 0 then
      raise Exception.Create('ParseEurPerLiterToMilli: Wert darf nicht negativ sein');
    
    // 5. In Cents umrechnen und sicher runden
    Result := Round(LValue * 1000);
  except
    on E: EConvertError do
      raise Exception.Create('ParseLitersToMl: Ungültiger Wert ("' + S + '")');
  end;
end;