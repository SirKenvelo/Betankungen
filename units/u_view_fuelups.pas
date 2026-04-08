{
  u_view_fuelups.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-04-08
  UPDATED: 2026-04-08
  AUTHOR : Christof Kempinski
  Read-only Referenzscreen fuer `Betankungen --list fuelups --detail`.

  Verantwortlichkeiten:
  - Rendert den ersten CLI-first-TUI-Referenzscreen fuer Fuelup-Details.
  - Nutzt die kleine Painter-Basis aus `u_painter` fuer Layout und Hierarchie.
  - Haelt den sichtbaren Fuelup-Contract ohne neue Fachlogik zusammen.

  Design-Entscheidungen:
  - Kein generisches Widget-/Form-System; nur der benoetigte View-Slice.
  - Bestehende fachliche Detailfelder bleiben sichtbar.
  - Kompakte Liste ohne `--detail` bleibt ausdruecklich ausserhalb dieser Unit.
  ---------------------------------------------------------------------------
}

unit u_view_fuelups;

{$mode objfpc}{$H+}

interface

type
  TFuelupDetailViewItem = record
    Id: Integer;
    FueledAt: string;
    OdometerKm: Int64;
    LitersMl: Int64;
    TotalCents: Int64;
    PricePerLiterMilliEur: Int64;
    IsFullTank: Boolean;
    MissedPrevious: Boolean;
    CarName: string;
    FuelType: string;
    PaymentType: string;
    PumpNo: string;
    Note: string;
    ReceiptLink: string;
    StationName: string;
    Address: string;
  end;

  TFuelupDetailViewItems = array of TFuelupDetailViewItem;

procedure RenderFuelupDetailReferenceScreen(const CarId: Integer;
  const Items: TFuelupDetailViewItems);

implementation

uses
  SysUtils,
  u_fmt,
  u_painter;

const
  REFERENCE_SCREEN_WIDTH = 92;

function SafeText(const S: string): string;
begin
  if Trim(S) = '' then
    Result := '-'
  else
    Result := Trim(S);
end;

function FuelFlagsText(const Item: TFuelupDetailViewItem): string;
begin
  Result := 'Full=' + FmtBoolYN(Ord(Item.IsFullTank)) +
            ' · MissPrev=' + FmtBoolYN(Ord(Item.MissedPrevious));
end;

function PaymentAndPumpText(const Item: TFuelupDetailViewItem): string;
begin
  Result := SafeText(Item.PaymentType);
  if Trim(Item.PumpNo) <> '' then
  begin
    if Result = '-' then
      Result := 'Pump ' + Item.PumpNo
    else
      Result := Result + ' · Pump ' + Item.PumpNo;
  end;
end;

procedure RenderFuelupDetailReferenceScreen(const CarId: Integer;
  const Items: TFuelupDetailViewItems);
var
  I: Integer;
  MetaLine: string;
  Item: TFuelupDetailViewItem;
begin
  if Length(Items) = 0 then
    Exit;

  MetaLine := Format(
    'Mode: --list fuelups --detail   Car: %s (ID %d)   Entries: %d',
    [SafeText(Items[0].CarName), CarId, Length(Items)]
  );

  PaintHeading(
    REFERENCE_SCREEN_WIDTH,
    'Betankungen',
    'Fuelups detail reference screen',
    MetaLine
  );
  PaintRule(REFERENCE_SCREEN_WIDTH, '━');
  WriteLn;

  for I := 0 to High(Items) do
  begin
    Item := Items[I];

    PaintHeading(
      REFERENCE_SCREEN_WIDTH,
      '',
      Format('Fuelup #%d · %s', [Item.Id, Item.FueledAt]),
      'Station: ' + SafeText(Item.StationName)
    );
    PaintRule(REFERENCE_SCREEN_WIDTH);
    PaintInlineFacts(
      REFERENCE_SCREEN_WIDTH,
      'Odometer: ' + IntToStr(Item.OdometerKm) + ' km',
      'Volume: ' + FmtLiterFromMl(Item.LitersMl)
    );
    PaintInlineFacts(
      REFERENCE_SCREEN_WIDTH,
      'Price/L: ' + FmtEurPerLiterFromMilli(Item.PricePerLiterMilliEur),
      'Total: ' + FmtEuroFromCents(Item.TotalCents)
    );
    PaintInlineFacts(
      REFERENCE_SCREEN_WIDTH,
      'Flags: ' + FuelFlagsText(Item),
      'Fuel: ' + SafeText(Item.FuelType)
    );
    PaintInlineFacts(
      REFERENCE_SCREEN_WIDTH,
      'Payment: ' + PaymentAndPumpText(Item),
      ''
    );
    PaintWrappedFact(REFERENCE_SCREEN_WIDTH, 'Car', SafeText(Item.CarName));
    PaintWrappedFact(REFERENCE_SCREEN_WIDTH, 'Address', SafeText(Item.Address));
    if Trim(Item.Note) <> '' then
      PaintWrappedFact(REFERENCE_SCREEN_WIDTH, 'Note', Item.Note);
    if Trim(Item.ReceiptLink) <> '' then
      PaintWrappedFact(REFERENCE_SCREEN_WIDTH, 'Receipt link', Item.ReceiptLink);

    if I < High(Items) then
    begin
      WriteLn;
      PaintRule(REFERENCE_SCREEN_WIDTH, '·');
      WriteLn;
    end;
  end;
end;

end.
