# BL-005 - Modulstrategie fuer Betankungen
**Stand:** 2026-03-09
**Status:** next
**Typ:** Architekturentscheidung

## Ziel

Definition, wie optionale Features modular erweitert werden koennen.

## Kontext

Mit wachsendem Funktionsumfang entstehen Feature-Bloecke,
die nicht fuer alle Nutzer relevant sind:

- EV Charging
- Maintenance
- Tires
- Agriculture / Machinery
- Fleet Aggregations

Ein Aufblaehen des Core-Binaries soll vermieden werden.

## Diskussionspunkte

- Core vs Erweiterungsmodule
- CLI-Erweiterbarkeit
- Versionierungsstrategie
- Abhaengigkeiten zwischen Core und Modulen

## Kandidaten fuer erste Module

- maintenance
- inspections
- tires
- ev_charging
