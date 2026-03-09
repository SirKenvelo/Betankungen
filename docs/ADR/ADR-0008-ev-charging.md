# ADR-0008: Elektrofahrzeuge - Strategie
**Stand:** 2026-03-09
**Status:** proposed
**Datum:** 2026-03-09

## Kontext

Das Projekt entstand aus der Erfassung von Kraftstofftankungen.

Mit zunehmender Verbreitung von Elektrofahrzeugen entsteht die Frage, wie
Ladevorgaenge modelliert werden.

Ein vollstaendig generisches Energiemodell waere:

`energy_events`

- `energy_type`
- `amount`
- `cost`
- `odometer`

Dies wuerde jedoch das gesamte Datenmodell veraendern.

## Entscheidung

EV-Unterstuetzung wird zunaechst als Modul implementiert.

Modul:

`betankungen-ev`

Dieses Modul verwaltet:

- Ladevorgaenge
- kWh
- Ladepreise
- Ladeorte

Der Core bleibt weiterhin auf klassische Fuelups fokussiert.

## Zukunft

Langfristig kann ein generisches Energy-Event-System entstehen.

Dies wuerde jedoch ein grosses Domain-Refactoring erfordern.

## Konsequenzen

EV-Unterstuetzung wird modular entwickelt und beeinflusst den Core zunaechst
nicht.

## Referenzen

- `docs/ADR/ADR-0005-module-strategy.md`
- `docs/ADR/ADR-0007-core-boundary.md`
