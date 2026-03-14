# Betankungen Module Architecture
**Stand:** 2026-03-14
**Status:** baseline v1 (operational)

Dieses Dokument definiert den technischen Contract fuer optionale Module in
Betankungen.

Ziel:
- klare Grenze zwischen Core und Modulen
- reproduzierbarer Modul-Build
- konsistente CLI-/DB-/Stats-Integration

Aktueller Baseline-Stand (S6/S10C1):
- Technischer Handshake ist implementiert (`--module-info` JSON-Contract).
- Erstes Companion-Skeleton ist vorhanden (`src/betankungen-maintenance.lpr`).
- Smoke-Absicherung fuer den Modul-Contract ist vorhanden (`tests/smoke/smoke_modules.sh`, integrierbar via `tests/smoke/smoke_cli.sh --modules`).
- Modul-Schema-Basis ist vorhanden: `maintenance_events` + `module_meta(schema_version)` via idempotentem `--migrate`.

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

Bedeutung der Felder (verbindlich):
- `module_name`: stabiler Modul-Identifier (z. B. `maintenance`)
- `module_version`: Version des Modul-Binaries
- `min_core_version`: minimale Core-App-Version, mit der das Modul kompatibel ist
- `db_schema_version`: Version des Modul-Schemas (nicht identisch zur Core-`schema_version`)

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

## 7) Referenz-Handshake (v1-Baseline)

Das Companion-Skeleton `betankungen-maintenance` liefert aktuell:

- `--help`
- `--version`
- `--module-info`
- `--module-info --pretty`
- `--migrate [--db <path>]`
- `--add maintenance --car-id <id> --date <YYYY-MM-DD> --type <name> --cost-cents <value> [--notes <text>] [--db <path>]`
- `--list maintenance [--car-id <id>] [--db <path>]`

Beispiel (`--module-info`, compact):

```json
{"module_name":"maintenance","module_version":"0.1.0-dev","min_core_version":"0.9.0-dev","db_schema_version":1}
```

Schema-Baseline aus `S10C1/4` (Migration `--migrate`):
- `module_meta(key PRIMARY KEY, value)` mit mindestens `schema_version=1`
- `maintenance_events`:
  - `id` (PK, autoincrement)
  - `car_id` (INTEGER, required)
  - `event_date` (TEXT, required)
  - `event_type` (TEXT, required)
  - `cost_cents` (INTEGER, required, `>= 0`)
  - `notes` (TEXT, optional)
  - `created_at`, `updated_at` (TEXT, default `datetime('now')`)

## 8) Startpunkt fuer erste Module

Priorisierte Kandidaten gemaess Backlog:

- `betankungen-maintenance` (`BL-007`)
- `betankungen-ev` (ADR-0008, EV-Strategie)
- `betankungen-agriculture` (`BL-009`)

Dieses Dokument ist bewusst ein technischer Start-Contract und wird mit den
ersten realen Modul-Implementierungen weiter praezisiert.
