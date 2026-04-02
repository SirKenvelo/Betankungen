# ADR-0014: Fuelup-Kilometerstands-Semantik
**Stand:** 2026-04-02
**Status:** accepted
**Datum:** 2026-04-02

## Kontext

Reale Nutzung von `Betankungen --add fuelups` hat gezeigt, dass die aktuelle
Prompt-Formulierung `Kilometerstand (km)` fuer neue Nutzer semantisch zu offen
ist. Aus dem Dialog allein ist nicht klar genug erkennbar, ob der gesamte
Fahrzeug-Odometer oder nur die seit der letzten Tankung gefahrene Strecke
gemeint ist.

Die bestehende Runtime und Policy-Lage ist bereits fachlich konsistent:

- persistiert wird `fuelups.odometer_km`
- verglichen wird gegen `cars.odometer_start_km`
- pro Fahrzeug gilt eine strikt monotone Odometer-Historie
- Duplikate bzw. rueckwaerts laufende Kilometerstaende werden geblockt

Offen war damit nicht die Datenbasis, sondern die explizite Produktsemantik
fuer kuenftige Guidance und moegliche Komforterweiterungen.

## Entscheidung

Betankungen fuehrt fuer Fuelups weiterhin genau **einen kanonischen
Kilometerstandsbegriff**:

- `odometer_km` bedeutet den **gesamten aktuellen Fahrzeug-Kilometerstand**
  zum Zeitpunkt des Tankvorgangs
- diese Gesamt-Odometer-Semantik bleibt die einzige kanonische Persistenz- und
  Policy-Basis im Core
- Prompting, Hilfe und Doku muessen diese Semantik explizit so benennen

Ein moeglicher Trip-/Delta-Input ist, wenn ueberhaupt, nur ein spaeterer
Komfortmodus. Er darf die kanonische Bedeutung von `odometer_km` nicht
veraendern.

## Leitplanken

- Kein stiller Bedeutungswechsel fuer bestehende Fuelup-Daten.
- Kein paralleler Dual-Contract, bei dem `odometer_km` je nach Eingabepfad
  mal Gesamtstand und mal Delta bedeutet.
- Ein spaeterer Komfortmodus darf hoechstens eine alternative Eingabeform
  bereitstellen, muss aber intern wieder auf einen kanonischen Gesamtstand
  zurueckgefuehrt werden.
- Die bestehenden Odometer-Policies (`P-010`, `P-011`, `P-013`) bleiben
  fachlich unaufgeweicht.

## Nicht-Ziele

- keine Runtime-Umsetzung eines Trip-/Delta-Modus in diesem ADR-Schritt
- keine neue Persistenz fuer separate Trip-Werte
- kein Umbau der vorhandenen Fuelup-Validierungslogik

## Konsequenzen

- `ISS-0008` wird als Guidance-/Terminologieproblem behandelt, nicht als
  Datenmodellzweifel.
- `BL-0031` kann die spaetere Umsetzung auf Prompting, Help, Dialogfuehrung
  und Regression fokussieren, ohne die Core-Persistenz neu zu verhandeln.
- Car-Zuordnung und Receipt-Link-Hinweise bleiben eigenstaendige UX-Themen
  (`ISS-0009`) und sind kein Anlass fuer einen zweiten Kilometerstandsbegriff.

## Referenzen

- `docs/issues/ISS-0008-fuelup-odometer-trip-semantics-gap/issue.md`
- `docs/issues/ISS-0009-fuelup-add-flow-guidance-gap/issue.md`
- `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/item.md`
- `docs/backlog/BL-0029-odometer-validation-contract-hardening/item.md`
- `units/u_fuelups.pas`
- `units/u_cli_help.pas`
