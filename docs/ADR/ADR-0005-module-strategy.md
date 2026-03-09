# ADR-0005: Modulstrategie fuer Betankungen
**Stand:** 2026-03-09
**Status:** proposed
**Datum:** 2026-03-09

## Kontext

Der Funktionsumfang des Projekts waechst ueber das urspruengliche
Tanktracking hinaus.

Moegliche Erweiterungen:

- EV Charging
- Maintenance
- Tire Management
- Household Drivers
- Agriculture / Machinery

Nicht alle Nutzer benoetigen alle Features.

Ein monolithisches CLI mit immer mehr Flags wuerde:

- die Codebasis vergroessern
- die CLI-Komplexitaet erhoehen
- die Wartbarkeit reduzieren

## Entscheidung (Vorschlag)

Betankungen folgt einem **Core + Module** Modell.

Der Core enthaelt:

- cars
- stations
- fuelups
- stats
- grundlegende Infrastruktur

Erweiterungen werden als **separate Module** umgesetzt.

## Technische Strategie

Keine dynamischen Runtime-Plugins.

Stattdessen:

**Companion-Binaries**

Beispiele:

betankungen
betankungen-maintenance
betankungen-ev
betankungen-fleet

Der Core kann optional vorhandene Module erkennen
und delegieren.

## Vorteile

- Core bleibt klein und stabil
- Module koennen unabhaengig entwickelt werden
- geringere technische Komplexitaet als Runtime-Plugins
- bessere CLI-Stabilitaet

## Konsequenzen

- klare Trennung zwischen Core-Domain und Erweiterungen
- Modul-CLI muss kompatibel zum Core bleiben
- Versionierungsstrategie fuer Module erforderlich

## Referenzen

- `docs/BACKLOG/BL-005-modulstrategie-fuer-betankungen.md`
- `docs/ARCHITECTURE.md`
