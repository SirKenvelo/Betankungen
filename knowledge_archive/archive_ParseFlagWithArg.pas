{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : Betankungen.lpr
  REMOVED  : 2026-01-31
  REASON   : Umstellung auf internes Command-Modell (BuildCommand)
  CONTEXT  : CLI-Parsing: Option mit optionalem Argument (z. B. --add stations)
  BEISPIEL : if ParamStr(i) = '--add' then
  BEISPIEL :   ParseFlagWithArg('--add', IsAdd, TableName);
}


  // Liest eine Option mit optionalem Argument (z. B. --add stations)
  procedure ParseFlagWithArg(const Flag: string; var Enabled: boolean; var Arg: string);
  begin
    if ParamStr(i) = Flag then
    begin
      Enabled := True;
      if (i + 1 <= ParamCount) and (ParamStr(i + 1)[1] <> '-') then
      begin
        Inc(i);
        Arg := ParamStr(i);
      end;
    end;
  end;
