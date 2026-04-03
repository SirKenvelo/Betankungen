{
  u_car_context.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-02-27
  UPDATED: 2026-04-03
  AUTHOR : Christof Kempinski
  Car-Context-Resolver fuer eine kanonische Car-ID im Laufkontext.

  Verantwortlichkeiten:
  - Liefert genau eine gueltige Car-ID fuer car-sensitive Commands.
  - Erzwingt konsistente Hard-Errors fuer Missing/Ambiguous/Unknown Car-ID.
  - Gibt niemals 0 zurueck.
  - Liefert bei Bedarf ein sichtbares Label fuer den aktiven Fahrzeugkontext.
  ---------------------------------------------------------------------------
}
unit u_car_context;

{$mode objfpc}{$H+}

interface

uses
  u_db_types;

function ResolveCarIdOrFail(const DB: TDB; const ProvidedCarId: Integer): Integer;
function DescribeCarContextOrFail(const DB: TDB; const ResolvedCarId: Integer): string;

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
      raise Exception.CreateFmt(
        'ERROR: unknown car_id=%d.' + LineEnding +
        'Hint: --list cars',
        [ProvidedCarId]
      );
    Exit(ProvidedCarId);
  end;

  if ProvidedCarId < 0 then
    raise Exception.CreateFmt(
      'ERROR: invalid car_id=%d (must be > 0).' + LineEnding +
      'Hint: specify --car-id <id>',
      [ProvidedCarId]
    );

  CarCount := CarsCount(DB);

  if CarCount = 0 then
    raise Exception.Create(
      'ERROR: no cars found.' + LineEnding +
      'Hint: create one first using --add cars'
    );

  if CarCount > 1 then
    raise Exception.Create(
      'ERROR: multiple cars found.' + LineEnding +
      'Hint: specify --car-id <id>' + LineEnding +
      'Hint: use --list cars to inspect available IDs'
    );

  Result := CarsGetSingleId(DB);
  if Result <= 0 then
    raise Exception.Create('ERROR: internal resolver state (resolved car_id <= 0).');
end;

function DescribeCarContextOrFail(const DB: TDB; const ResolvedCarId: Integer): string;
var
  Car: TCar;
begin
  if ResolvedCarId <= 0 then
    raise Exception.CreateFmt('ERROR: invalid car context (car_id=%d).', [ResolvedCarId]);

  if not CarsGetById(DB, ResolvedCarId, Car) then
    raise Exception.CreateFmt(
      'ERROR: unknown car_id=%d.' + LineEnding +
      'Hint: --list cars',
      [ResolvedCarId]
    );

  Result := Format('%s (ID %d)', [Car.Name, Car.Id]);
end;

end.
