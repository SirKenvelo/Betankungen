# ADR-0008: Elektrofahrzeuge - Strategie
**Stand:** 2026-03-31
**Status:** accepted
**Datum:** 2026-03-31

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

Seit `1.4.0-dev` sind die Stabilisierung der aktiven Linie (`BL-0029`) und die
Datenanreicherung der Stationsbasis (`BL-0019`) abgeschlossen. Fuer die
naechste groessere Domaenenerweiterung musste daher bewusst entschieden werden,
welcher strategische Pfad zuerst aktiviert wird.

Zusammen mit `ADR-0005` (Modulstrategie) und `ADR-0007` (Core Boundary) ist
der EV-Pfad die risikoaermere erste Erweiterung gegenueber einem Core-Ausbau
wie Household Drivers.

## Entscheidung

EV-Unterstuetzung wird fuer Betankungen zunaechst **als Companion-Modul**
priorisiert.

Modul:

`betankungen-ev`

Dieses Modul verwaltet:

- Ladevorgaenge
- kWh
- Ladepreise
- Ladeorte

Der Core bleibt weiterhin auf klassische Fuelups fokussiert.

Der naechste Schritt ist **kein** breiter Implementierungs-Rollout, sondern ein
begrenzter Discovery-/Feasibility-Block im kanonischen Tracker
`BL-0030`.

## Leitplanken

- Kein generisches `energy_events`-Refactoring im Core in diesem Block.
- Keine Vermischung des EV-Pfads mit Household-Drivers-/Shared-Cars-Arbeit.
- Modulgrenzen, CLI-Oberflaeche und Datenhaltung muessen sich an
  `docs/MODULES_ARCHITECTURE.md` orientieren.
- Core-Schema und Core-UX bleiben in `1.4.x` moeglichst stabil; neue
  EV-spezifische Tabellen und Flows gehoeren nicht in den Core.

## Zukunft

Langfristig kann ein generisches Energy-Event-System entstehen.

Dies wuerde jedoch ein grosses Domain-Refactoring erfordern und ist explizit
nicht Teil dieser Entscheidung.

## Konsequenzen

- EV-Unterstuetzung wird modular entwickelt und beeinflusst den Core
  zunaechst nicht.
- Der naechste strategische Discovery-Block fuer die `1.4.x`-Linie ist
  `BL-0030`.
- Household Drivers bleiben fachlich moeglich, werden aber fuer die aktuelle
  Linie nicht als erste grosse Domaenenerweiterung priorisiert.

## Referenzen

- `docs/ADR/ADR-0005-module-strategy.md`
- `docs/ADR/ADR-0007-core-boundary.md`
- `docs/backlog/BL-0030-ev-companion-feasibility-spike/item.md`
