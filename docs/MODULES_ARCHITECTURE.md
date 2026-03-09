# Betankungen Module Architecture
**Stand:** 2026-03-09
**Status:** draft (v0.1)

Dieses Dokument definiert den technischen Contract fuer optionale Module in
Betankungen.

Ziel:
- klare Grenze zwischen Core und Modulen
- reproduzierbarer Modul-Build
- konsistente CLI-/DB-/Stats-Integration

## Scope und Begriffe

- **Core:** universelle Mobilitaetslogik (`cars`, `fuelups`, `stations`, Basis-Stats).
- **Modul:** domaenenspezifische Erweiterung als eigenes Binary.
- **Companion-Binary:** ausfuehrbare Moduldatei im Muster
  `betankungen-<module>`.

Dieses Dokument basiert auf:
- `docs/ADR/ADR-0005-module-strategy.md`
- `docs/ADR/ADR-0007-core-boundary.md`
- `docs/ADR/ADR-0008-ev-charging.md`

## 1) Build- und Packaging-Contract

1. Module werden als eigene Binaries gebaut, nicht als Runtime-Plugins.
2. Naming-Muster: `betankungen-<module>` (z. B. `betankungen-maintenance`).
3. Jedes Modul hat einen eigenen Einstiegspunkt (`src/<module>.lpr`).
4. Modul-Builds bleiben framework-arm und FPC-kompatibel wie der Core.
5. Jedes Modul liefert eine maschinenlesbare Info-Ausgabe:
   - `--module-info` (JSON)
   - Felder mindestens:
     - `module_name`
     - `module_version`
     - `min_core_version`
     - `db_schema_version`

## 2) CLI-Integrations-Contract

1. Primaerer Aufruf erfolgt direkt ueber das Modul-Binary.
2. Help/Usage-Format orientiert sich an Core-Konventionen:
   - klare One-Line-Usage
   - konsistente Exitcodes
   - keine impliziten Side-Effects
3. Modulspezifische Targets/Flags muessen kollisionsarm benannt werden.
4. Wenn Core-Delegation spaeter eingefuehrt wird, bleibt sie optional:
   - Core darf Modul erkennen und weiterleiten
   - ohne installiertes Modul bleibt Core-Verhalten stabil

## 3) DB-Integrations-Contract

1. Module besitzen eigene Tabellen und eigene Schema-Versionierung.
2. Core-Tabellen werden durch Module nicht stillschweigend geaendert.
3. Beziehungen zum Core erfolgen explizit ueber FK (z. B. `car_id`) oder
   dokumentierte Join-Keys.
4. Migrationen sind idempotent und transaktionssicher.
5. Modul-Schema-Metadaten werden getrennt vom Core gepflegt
   (z. B. eigener Modul-Meta-Keyspace).

## 4) Stats-Integrations-Contract

1. Module duerfen eigene Stats bereitstellen (Text/JSON/CSV nach Bedarf).
2. JSON-Stats muessen klar versioniert sein:
   - `contract_version`
   - `kind`
   - `generated_at`
   - `app_version` (modulseitig)
3. Falls Module in Gesamt-Kostenkennzahlen einfliessen, muss der Datenursprung
   je Anteil transparent bleiben (z. B. fuel vs maintenance).
4. Stats duerfen Core-Contracts nicht brechen; Erweiterungen sind additive
   Contracts.

## 5) Kompatibilitaet und Versionierung

1. Module definieren eine minimale Core-Version (`min_core_version`).
2. Bei Inkompatibilitaet erfolgt ein klarer Hard Error mit Handlungs-Hinweis.
3. Breaking Changes an Modul-Contracts erfordern:
   - Contract-Version-Bump
   - Changelog-Eintrag
   - Migrationshinweis

## 6) Mindest-Qualitaetsstandard pro Modul

Ein Modul gilt erst als integrierbar, wenn mindestens vorhanden:

1. Build-Anleitung (kurz, reproduzierbar)
2. CLI-Help inkl. Beispiele
3. DB-Migrationspfad (neu + upgrade)
4. Basis-Smoke-Tests
5. Kurz-Doku zu Stats-/Export-Contract (falls Stats vorhanden)

## 7) Startpunkt fuer erste Module

Priorisierte Kandidaten gemaess Backlog:

- `betankungen-maintenance` (`BL-007`)
- `betankungen-ev` (ADR-0008, EV-Strategie)
- `betankungen-agriculture` (`BL-009`)

Dieses Dokument ist bewusst ein technischer Start-Contract und wird mit den
ersten realen Modul-Implementierungen praezisiert.
