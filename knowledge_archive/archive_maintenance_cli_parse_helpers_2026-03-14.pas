{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : src/betankungen-maintenance.lpr
  REMOVED  : 2026-03-14
  REASON   : loeschung (ersetzt durch zentrales ParseArgs-Modell in S10C2/4)
  CONTEXT  : Vor S10C2/4 wurden Hauptaktionen/Flags getrennt ueber Helper geprueft.
  CONTEXT  : Mit Add/List-CRUD wurde auf ein einheitliches Argument-Parsing umgestellt.
  BEISPIEL : if (ParamCount = 0) or HasFlag('--help') then ...
  BEISPIEL : if HasUnknownFlags then ... ; if not TryReadDbArg(...) then ...
}

function HasFlag(const Flag: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 1 to ParamCount do
    if ParamStr(i) = Flag then
      Exit(True);
end;

function HasUnknownFlags: Boolean;
var
  i: Integer;
  A: string;
begin
  Result := False;
  i := 1;
  while i <= ParamCount do
  begin
    A := ParamStr(i);
    if (A = '--help') or
       (A = '--version') or
       (A = '--module-info') or
       (A = '--pretty') or
       (A = '--migrate') then
    begin
      Inc(i);
      Continue;
    end;

    if A = '--db' then
    begin
      Inc(i);
      if i > ParamCount then
        Exit(True);
      Inc(i);
      Continue;
    end;

    Exit(True);
  end;
end;

function TryReadDbArg(out DbArg: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  DbArg := '';
  i := 1;
  while i <= ParamCount do
  begin
    if ParamStr(i) = '--db' then
    begin
      if i = ParamCount then
        Exit(False);
      DbArg := ParamStr(i + 1);
      if Trim(DbArg) = '' then
        Exit(False);
      Inc(i);
    end;
    Inc(i);
  end;
end;
