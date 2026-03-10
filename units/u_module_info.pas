{
  u_module_info.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-03-10
  UPDATED: 2026-03-10
  AUTHOR : Christof Kempinski
  Kleiner JSON-Contract-Helper fuer Companion-Module.

  Verantwortlichkeiten:
  - Kapselt den standardisierten `--module-info` JSON-Output.
  - Stellt kompaktes und optional pretty formatiertes JSON bereit.
  - Fuehrt keine Fachlogik aus und greift nicht auf DB/CLI-State zu.
  ---------------------------------------------------------------------------
}
unit u_module_info;

{$mode objfpc}{$H+}

interface

type
  TModuleInfo = record
    ModuleName: string;
    ModuleVersion: string;
    MinCoreVersion: string;
    DbSchemaVersion: Integer;
  end;

function BuildModuleInfoJson(const Info: TModuleInfo; const Pretty: Boolean = False): string;
procedure PrintModuleInfoJson(const Info: TModuleInfo; const Pretty: Boolean = False);

implementation

uses
  SysUtils;

function JsonEscape(const S: string): string;
var
  i: Integer;
  C: Char;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    C := S[i];
    case C of
      '"':  Result := Result + '\"';
      '\':  Result := Result + '\\';
      #8:   Result := Result + '\b';
      #9:   Result := Result + '\t';
      #10:  Result := Result + '\n';
      #12:  Result := Result + '\f';
      #13:  Result := Result + '\r';
    else
      if Ord(C) < 32 then
        Result := Result + '\u00' + IntToHex(Ord(C), 2)
      else
        Result := Result + C;
    end;
  end;
end;

function BuildModuleInfoJson(const Info: TModuleInfo; const Pretty: Boolean = False): string;
begin
  if Pretty then
  begin
    Result :=
      '{' + LineEnding +
      '  "module_name": "' + JsonEscape(Info.ModuleName) + '",' + LineEnding +
      '  "module_version": "' + JsonEscape(Info.ModuleVersion) + '",' + LineEnding +
      '  "min_core_version": "' + JsonEscape(Info.MinCoreVersion) + '",' + LineEnding +
      '  "db_schema_version": ' + IntToStr(Info.DbSchemaVersion) + LineEnding +
      '}';
    Exit;
  end;

  Result :=
    '{"module_name":"' + JsonEscape(Info.ModuleName) +
    '","module_version":"' + JsonEscape(Info.ModuleVersion) +
    '","min_core_version":"' + JsonEscape(Info.MinCoreVersion) +
    '","db_schema_version":' + IntToStr(Info.DbSchemaVersion) + '}';
end;

procedure PrintModuleInfoJson(const Info: TModuleInfo; const Pretty: Boolean = False);
begin
  WriteLn(BuildModuleInfoJson(Info, Pretty));
end;

end.
