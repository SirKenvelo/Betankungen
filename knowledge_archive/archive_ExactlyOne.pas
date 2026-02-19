{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : Betankungen.lpr
  REMOVED  : 2026-01-31
  REASON   : Umstellung auf internes Command-Modell
  CONTEXT  : Validierung, dass genau eine Kommando-Option gesetzt ist
  CONTEXT  : Kommando-Validierung (zuvor in der zentralen Ermittlung/Dispatch)
  BEISPIEL : if not ExactlyOne([IsAdd, IsList, IsDelete, IsEdit],
  BEISPIEL :   ['--add', '--list', '--delete', '--edit'], CmdError) then
  BEISPIEL :   FailUsage(CmdError);
}


// Stellt sicher, dass genau eine Kommando-Option gesetzt ist und liefert eine sprechende Fehlermeldung
  function ExactlyOne(const Flags: array of boolean; const Names: array of string;
    out ErrorMsg: string): boolean;
  var
    i, Count: integer;
  begin
    ErrorMsg := '';
    Count := 0;

    for i := Low(Flags) to High(Flags) do
      if Flags[i] then
      begin
        Inc(Count);
        if ErrorMsg <> '' then ErrorMsg := ErrorMsg + ' ';
        ErrorMsg := ErrorMsg + Names[i];
      end;

    if Count > 1 then
    begin
      ErrorMsg := 'Fehler: Diese Kommandos dürfen nicht zusammen verwendet werden: ' + ErrorMsg;
      Exit(False);
    end;

    if Count = 0 then
    begin
      ErrorMsg := 'Fehler: Kein Kommando angegeben.';
      Exit(False);
    end;

    Result := (Count = 1);
  end;
