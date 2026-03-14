{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : src/betankungen-maintenance.lpr
  CHANGED  : 2026-03-14
  REASON   : behavior change (S10C3/4: Stats-Command + erweitertes Parse-/Flag-Model)
  CONTEXT  : Vor S10C3/4 unterstuetzte die CLI nur Help/Version/Module-Info/Migrate/Add/List.
  CONTEXT  : Mit S10C3/4 wurden --stats maintenance sowie --json/--pretty-Kontexte ergaenzt.
  BEISPIEL : ParseArgs erkannte nur --add/--list als Maintenance-Targets.
  BEISPIEL : RunListMaintenance war der einzige Ausgabe-Pfad neben Add/Migrate/Meta.
}

procedure RunListMaintenance(const Args: TParsedArgs);
var
  DbPath: string;
  Rows: TMaintenanceEventRows;
  i: Integer;
  CarIdFilter: Integer;
begin
  if Trim(Args.CarIdRaw) <> '' then
    CarIdFilter := ParsePositiveInt(Args.CarIdRaw, '--car-id')
  else
    CarIdFilter := 0;

  DbPath := ResolveMaintenanceDbPath(Args.DbArg);
  ListMaintenanceEvents(DbPath, CarIdFilter, Rows);

  WriteLn('Maintenance Events');
  if CarIdFilter > 0 then
    WriteLn('Scope: car_id=', CarIdFilter)
  else
    WriteLn('Scope: all cars');

  if Length(Rows) = 0 then
  begin
    WriteLn('No maintenance events found.');
    Exit;
  end;

  WriteLn('id | car_id | event_date | event_type | cost_cents | notes');
  for i := 0 to High(Rows) do
    WriteLn(
      Rows[i].Id, ' | ',
      Rows[i].CarId, ' | ',
      Rows[i].EventDate, ' | ',
      Rows[i].EventType, ' | ',
      Rows[i].CostCents, ' | ',
      SingleLine(Rows[i].Notes)
    );
end;

function ParseArgs(out Args: TParsedArgs; out ErrMsg: string): Boolean;
var
  i: Integer;
  A: string;
  PendingAction: TActionKind;
  procedure SetAction(const NextAction: TActionKind);
  begin
    if (PendingAction <> akNone) and (PendingAction <> NextAction) then
      raise Exception.Create('Fehler: mehrere Hauptkommandos kombiniert. Bitte genau eines verwenden.');
    PendingAction := NextAction;
  end;
begin
  Result := False;
  ErrMsg := '';
  FillChar(Args, SizeOf(Args), 0);
  Args.Action := akNone;
  PendingAction := akNone;

  i := 1;
  while i <= ParamCount do
  begin
    A := ParamStr(i);

    if A = '--help' then
      SetAction(akHelp)
    else if A = '--version' then
      SetAction(akVersion)
    else if A = '--module-info' then
      SetAction(akModuleInfo)
    else if A = '--migrate' then
      SetAction(akMigrate)
    else if A = '--pretty' then
      Args.Pretty := True
    else if (A = '--db') or (A = '--car-id') or (A = '--date') or
            (A = '--type') or (A = '--cost-cents') or (A = '--notes') then
    begin
      Inc(i);
      if i > ParamCount then
      begin
        ErrMsg := 'Fehler: ' + A + ' erwartet einen Wert.';
        Exit;
      end;

      if A = '--db' then
        Args.DbArg := ParamStr(i)
      else if A = '--car-id' then
        Args.CarIdRaw := ParamStr(i)
      else if A = '--date' then
        Args.DateRaw := ParamStr(i)
      else if A = '--type' then
        Args.EventTypeRaw := ParamStr(i)
      else if A = '--cost-cents' then
        Args.CostCentsRaw := ParamStr(i)
      else
        Args.NotesRaw := ParamStr(i);
    end
    else if (A = '--add') or (A = '--list') then
    begin
      Inc(i);
      if i > ParamCount then
      begin
        ErrMsg := 'Fehler: ' + A + ' erwartet ein Target (maintenance).';
        Exit;
      end;
      if ParamStr(i) <> 'maintenance' then
      begin
        ErrMsg := 'Fehler: nur das Target "maintenance" wird unterstuetzt.';
        Exit;
      end;
      if A = '--add' then
        SetAction(akAddMaintenance)
      else
        SetAction(akListMaintenance);
    end
    else
    begin
      ErrMsg := 'Fehler: unbekannte Option "' + A + '".';
      Exit;
    end;

    Inc(i);
  end;

  try
    if PendingAction = akNone then
      PendingAction := akHelp;
    Args.Action := PendingAction;

    if (Args.Action in [akAddMaintenance, akListMaintenance, akMigrate]) and Args.Pretty then
      raise Exception.Create('Fehler: --pretty ist nur zusammen mit --module-info erlaubt.');

    if Args.Action = akAddMaintenance then
    begin
      if Trim(Args.CarIdRaw) = '' then
        raise Exception.Create('Fehler: --car-id ist fuer --add maintenance erforderlich.');
      if Trim(Args.DateRaw) = '' then
        raise Exception.Create('Fehler: --date ist fuer --add maintenance erforderlich.');
      if Trim(Args.EventTypeRaw) = '' then
        raise Exception.Create('Fehler: --type ist fuer --add maintenance erforderlich.');
      if Trim(Args.CostCentsRaw) = '' then
        raise Exception.Create('Fehler: --cost-cents ist fuer --add maintenance erforderlich.');
    end;

    Result := True;
  except
    on E: Exception do
    begin
      ErrMsg := E.Message;
      Exit(False);
    end;
  end;
end;
