{
  u_module_info.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-03-10
  UPDATED: 2026-03-15
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
  TModuleCapabilities = record
    SupportsMigrate: Boolean;
    SupportsAddMaintenance: Boolean;
    SupportsListMaintenance: Boolean;
    SupportsStatsMaintenance: Boolean;
    SupportsStatsJson: Boolean;
    SupportsStatsPretty: Boolean;
    SupportsCarScope: Boolean;
    SupportsPeriodScope: Boolean;
  end;

  TModuleInfo = record
    ModuleName: string;
    ModuleVersion: string;
    MinCoreVersion: string;
    DbSchemaVersion: Integer;
    Capabilities: TModuleCapabilities;
  end;

function BuildModuleInfoJson(const Info: TModuleInfo; const Pretty: Boolean = False): string;
procedure PrintModuleInfoJson(const Info: TModuleInfo; const Pretty: Boolean = False);

implementation

uses
  SysUtils;

function BoolToJson(const B: Boolean): string;
begin
  if B then
    Result := 'true'
  else
    Result := 'false';
end;

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
      '  "db_schema_version": ' + IntToStr(Info.DbSchemaVersion) + ',' + LineEnding +
      '  "capabilities": {' + LineEnding +
      '    "supports_migrate": ' + BoolToJson(Info.Capabilities.SupportsMigrate) + ',' + LineEnding +
      '    "supports_add_maintenance": ' + BoolToJson(Info.Capabilities.SupportsAddMaintenance) + ',' + LineEnding +
      '    "supports_list_maintenance": ' + BoolToJson(Info.Capabilities.SupportsListMaintenance) + ',' + LineEnding +
      '    "supports_stats_maintenance": ' + BoolToJson(Info.Capabilities.SupportsStatsMaintenance) + ',' + LineEnding +
      '    "supports_stats_json": ' + BoolToJson(Info.Capabilities.SupportsStatsJson) + ',' + LineEnding +
      '    "supports_stats_pretty": ' + BoolToJson(Info.Capabilities.SupportsStatsPretty) + ',' + LineEnding +
      '    "supports_car_scope": ' + BoolToJson(Info.Capabilities.SupportsCarScope) + ',' + LineEnding +
      '    "supports_period_scope": ' + BoolToJson(Info.Capabilities.SupportsPeriodScope) + LineEnding +
      '  }' + LineEnding +
      '}';
    Exit;
  end;

  Result :=
    '{"module_name":"' + JsonEscape(Info.ModuleName) +
    '","module_version":"' + JsonEscape(Info.ModuleVersion) +
    '","min_core_version":"' + JsonEscape(Info.MinCoreVersion) +
    '","db_schema_version":' + IntToStr(Info.DbSchemaVersion) +
    ',"capabilities":{' +
    '"supports_migrate":' + BoolToJson(Info.Capabilities.SupportsMigrate) +
    ',"supports_add_maintenance":' + BoolToJson(Info.Capabilities.SupportsAddMaintenance) +
    ',"supports_list_maintenance":' + BoolToJson(Info.Capabilities.SupportsListMaintenance) +
    ',"supports_stats_maintenance":' + BoolToJson(Info.Capabilities.SupportsStatsMaintenance) +
    ',"supports_stats_json":' + BoolToJson(Info.Capabilities.SupportsStatsJson) +
    ',"supports_stats_pretty":' + BoolToJson(Info.Capabilities.SupportsStatsPretty) +
    ',"supports_car_scope":' + BoolToJson(Info.Capabilities.SupportsCarScope) +
    ',"supports_period_scope":' + BoolToJson(Info.Capabilities.SupportsPeriodScope) +
    '}}';
end;

procedure PrintModuleInfoJson(const Info: TModuleInfo; const Pretty: Boolean = False);
begin
  WriteLn(BuildModuleInfoJson(Info, Pretty));
end;

end.
