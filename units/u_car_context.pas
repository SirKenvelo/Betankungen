{
  u_car_context.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-02-27
  UPDATED: 2026-02-27
  AUTHOR : Christof Kempinski
  Car-Context-Resolver fuer eine kanonische Car-ID im Laufkontext.

  Verantwortlichkeiten:
  - Liefert genau eine gueltige Car-ID fuer car-sensitive Commands.
  - Erzwingt konsistente Hard-Errors fuer Missing/Ambiguous/Unknown Car-ID.
  - Gibt niemals 0 zurueck.
  ---------------------------------------------------------------------------
}
unit u_car_context;

{$mode objfpc}{$H+}

interface

uses
  u_db_types;

function ResolveCarIdOrFail(const DB: TDB; const ProvidedCarId: Integer): Integer;

implementation

uses
  SysUtils,
  u_cars;

function ResolveCarIdOrFail(const DB: TDB; const ProvidedCarId: Integer): Integer;
var
  CarCount: Integer;
begin
  if ProvidedCarId > 0 then
  begin
    if not CarsExists(DB, ProvidedCarId) then
      raise Exception.CreateFmt('ERROR: unknown car_id=%d. Use --list cars.', [ProvidedCarId]);
    Exit(ProvidedCarId);
  end;

  if ProvidedCarId < 0 then
    raise Exception.CreateFmt('ERROR: unknown car_id=%d. Use --list cars.', [ProvidedCarId]);

  CarCount := CarsCount(DB);

  if CarCount = 0 then
    raise Exception.Create(
      'ERROR: no cars found. Create one first: --add cars ...' + LineEnding +
      'Hint: use --list cars'
    );

  if CarCount > 1 then
    raise Exception.Create(
      'ERROR: multiple cars found. Please specify --car-id.' + LineEnding +
      'Hint: --list cars'
    );

  Result := CarsGetSingleId(DB);
  if Result <= 0 then
    raise Exception.Create('ResolveCarIdOrFail: internal error (resolved car_id <= 0).');
end;

end.
