# ADR-0005: Modulstrategie fuer Betankungen
**Stand:** 2026-03-10
**Status:** accepted
**Datum:** 2026-03-10

## Kontext

Der Funktionsumfang des Projekts waechst ueber das urspruengliche Tanktracking
hinaus.

Moegliche Erweiterungen:

- EV Charging
- Maintenance
- Tire Management
- Household Drivers
- Agriculture / Machinery

Nicht alle Nutzer benoetigen alle Features. Ein monolithisches CLI mit immer
mehr Flags wuerde:

- die Codebasis vergroessern
- die CLI-Komplexitaet erhoehen
- die Wartbarkeit reduzieren

Zusammen mit `ADR-0007` (Core Boundary) musste geklaert werden, wie diese
Grenze praktisch und dauerhaft durchgesetzt wird.

## Entscheidung

Betankungen folgt einem **Core + Module** Modell.

Der Core enthaelt:

- cars
- stations
- fuelups
- stats
- grundlegende Infrastruktur

Erweiterungen werden als **separate Module (Companion-Binaries)** umgesetzt.

## Scope-Grenzen (verbindlich)

Ein Feature bleibt im Core, wenn es:

- universell fuer die Kernnutzung relevant ist
- keine domanenspezifische Sonderlogik erzwingt
- ohne optionales Zusatzwissen verstehbar bleibt

Ein Feature wird als Modul umgesetzt, wenn mindestens einer der Punkte gilt:

- es ist nur fuer einen Teil der Nutzer relevant
- es fuehrt neue domanenspezifische Tabellen/Flows ein
- es erhoeht die Core-CLI spuerbar durch Spezial-Flags oder Sonderpfade

Typische Modulkandidaten:

- maintenance
- ev charging
- tires
- agriculture
- household drivers

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

## Konsequenzen

- klare Trennung zwischen Core-Domain und Erweiterungen
- Modul-CLI muss kompatibel zu Core-Konventionen bleiben
- Versionierung/Kompatibilitaet zwischen Core und Modulen ist verpflichtend
- Modul-Contracts werden in `docs/MODULES_ARCHITECTURE.md` praezisiert und als
  Gate vor Modul-Rollouts genutzt

## Referenzen

- `docs/BACKLOG/BL-005-modulstrategie-fuer-betankungen.md`
- `docs/ARCHITECTURE.md`
- `docs/ADR/ADR-0007-core-boundary.md`
- `docs/MODULES_ARCHITECTURE.md`
