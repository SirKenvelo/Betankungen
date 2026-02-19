{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : Betankungen.lpr
  REMOVED  : 2026-01-31
  REASON   : Umstellung auf internes Command-Modell (BuildCommand)
  CONTEXT  : CLI-Parsing: Einfaches Flag ohne Argument (z. B. --debug)
  BEISPIEL : if TryParseFlag('--debug', IsDebug) then
  BEISPIEL :   Continue;
}

  // Prueft einfache Optionen ohne Argument (z. B. --debug)
  function TryParseFlag(const Target: string; var FlagVar: boolean): boolean;
  begin
    Result := ParamStr(i) = Target;
    if Result then
      FlagVar := True;
  end;
