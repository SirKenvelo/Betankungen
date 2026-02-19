{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : Betankungen.lpr
  REMOVED  : 2026-01-31
  REASON   : Umstellung auf internes Command-Modell (BuildCommand)
  CONTEXT  : CLI-Parsing: Option mit Pflicht-Argument (konsumiert Flag + Wert)
  BEISPIEL : if ParseRequiredValueFlag('--db', DbOverride) then
  BEISPIEL :   Continue;
}

  // Liest eine Option mit Pflicht-Argument und konsumiert Flag + Wert (Inc(i, 2))
  function ParseRequiredValueFlag(const Flag: string; var Value: string): boolean;
  begin
    Result := False;
    if ParamStr(i) = Flag then
    begin
      if i + 1 > ParamCount then
      begin
        FailUsage('Fehler: ' + Flag + ' benötigt einen Pfad.', Flag);
      end;
      Value := ParamStr(i + 1);
      Inc(i, 2);
      Result := True;
    end;
  end;
