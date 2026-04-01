# Betankungen Module Architecture
**Stand:** 2026-04-01
**Status:** baseline v1 (operational)

Dieses Dokument definiert den technischen Contract fuer optionale Module in
Betankungen.

Ziel:
- klare Grenze zwischen Core und Modulen
- reproduzierbarer Modul-Build
- konsistente CLI-/DB-/Stats-Integration

Aktueller Baseline-Stand (S6/S10C4):
- Technischer Handshake ist implementiert (`--module-info` JSON-Contract inkl. `capabilities`).
- Erstes Companion-Skeleton ist vorhanden (`src/betankungen-maintenance.lpr`).
- Smoke-Absicherung fuer den Modul-Contract ist vorhanden (`tests/smoke/smoke_modules.sh`, integrierbar via `tests/smoke/smoke_cli.sh --modules`).
- Modul-Schema-Basis ist vorhanden: `maintenance_events` + `module_meta(schema_version)` via idempotentem `--migrate`.
- Maintenance-Companion liefert CRUD + Stats-Basis (`--add/--list/--stats maintenance`) inkl. JSON-Contract (`kind: "maintenance_stats_v1"`).
- Contract-Guardrails sind regressionsgesichert (u. a. `--pretty` nur mit `--module-info` bzw. `--stats maintenance --json`, `--json` nur im Stats-Kontext).

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
     - `capabilities` (Objekt mit stabilen booleschen Keys)

Bedeutung der Felder (verbindlich):
- `module_name`: stabiler Modul-Identifier (z. B. `maintenance`)
- `module_version`: Version des Modul-Binaries
- `min_core_version`: minimale Core-App-Version, mit der das Modul kompatibel ist
- `db_schema_version`: Version des Modul-Schemas (nicht identisch zur Core-`schema_version`)
- `capabilities`: maschinenlesbare Modulfaehigkeiten, additiv erweiterbar

Capabilities v1 (verbindliche Keys, boolesch):
- `supports_migrate`
- `supports_add_maintenance`
- `supports_list_maintenance`
- `supports_stats_maintenance`
- `supports_stats_json`
- `supports_stats_pretty`
- `supports_car_scope`
- `supports_period_scope`

Contract-Regel fuer `capabilities`:
- bestehende Keys bleiben semantisch stabil,
- neue Keys duerfen nur additiv ergaenzt werden,
- kein stiller Bedeutungswechsel bestehender Keys (`POL-002`).

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

### Deprecation-Status (POL-002)

- Aktive Modul-Deprecations (Stand 2026-03-15): `none`
- Wenn ein Modulpfad deprecate't wird, sind verpflichtend:
  - Lifecycle-Phase gemaess `POL-002` (A/B/C),
  - Doku-Update in `docs/EXPORT_CONTRACT.md` und diesem Dokument,
  - Changelog-Eintrag im gleichen Change-Set.

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
- `--stats maintenance [--car-id <id>] [--json [--pretty]] [--db <path>]`

Beispiel (`--module-info`, compact):

```json
{"module_name":"maintenance","module_version":"0.1.0-dev","min_core_version":"0.9.0-dev","db_schema_version":1,"capabilities":{"supports_migrate":true,"supports_add_maintenance":true,"supports_list_maintenance":true,"supports_stats_maintenance":true,"supports_stats_json":true,"supports_stats_pretty":true,"supports_car_scope":true,"supports_period_scope":false}}
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

Stats-Baseline aus `S10C3/4` (`--stats maintenance`):
- Text: `Maintenance-Stats (MVP)` mit Scope (`all cars` oder `car_id=<id>`), Zeitraum (`period`) und Kennzahlen (`events_total`, `cars_total`, `total_cost_cents`, `avg_cost_per_event_cents`).
- JSON: `contract_version=1`, `kind="maintenance_stats_v1"`, `generated_at`, `app_version`, Payload `maintenance` mit `scope_mode`, `scope_car_id`, `events_total`, `cars_total`, `total_cost_cents`, `avg_cost_per_event_cents`, `period_from`, `period_to`.
- Contract-Referenz: siehe `docs/EXPORT_CONTRACT.md` (Abschnitt "Module JSON Contract (Maintenance Companion v1)").

## 8) EV Discovery Profile (`betankungen-ev`)

Diese Sektion definiert den Discovery-/Contract-Rahmen aus `TSK-0024` fuer
das priorisierte EV-Companion-Modul. Sie beschreibt bewusst den kleinsten
belastbaren Startpunkt und soll `TSK-0025` einen klaren Folgeauftrag geben,
ohne das Event-/Storage-Design schon vollstaendig festzuschreiben.

### Minimaler Scope

- Das erste EV-Modul fokussiert ausschliesslich `charging`-Flows.
- Mindestfaehigkeiten des ersten Blocks:
  - Ladevorgaenge erfassen
  - Ladevorgaenge listen
  - modul-lokale `charging`-Stats bereitstellen
  - Energiemenge (`kWh`/`Wh`), Kosten und Ladeort-Referenzen fuehren
- Scoping bleibt zunaechst klein:
  - per `car_id`
  - optional per Zeitraum (`--from`/`--to`) fuer Listen/Stats
- Es gibt noch keine Verpflichtung auf ein vollstaendiges EV-Fachmodell
  (z. B. Ladeleistung, SoC-Kurven, Tarife, Provider-Sync).

### Boundary zum Core

- Der Core bleibt verantwortlich fuer:
  - `cars`
  - `fuelups`
  - `stations`
  - Basis-Stats
  - Konfigurations-/DB-Grundlagen
  - Modul-Discovery / Modul-Delegation
- Die erste harte fachliche Kopplung fuer `betankungen-ev` ist nur
  `car_id` gegen den Core.
- EV-spezifische Tabellen, Ladeort-/Anbieter-Metadaten und fachliche
  Charging-Semantik bleiben modul-eigene Verantwortung.
- Der Core bekommt in `1.4.x` keine neuen EV-spezifischen
  CRUD-/Stats-Targets.
- Ein generisches Core-Modell `energy_events` ist fuer diesen Pfad explizit
  ausgeschlossen.
- Die bestehenden Core-`stations` sind **nicht** der kanonische
  Ladeort-Speicher des ersten EV-Blocks. Wenn spaeter eine Wiederverwendung
  oder Verknuepfung sinnvoll wird, braucht das einen separaten Entscheid.

### Erwartete CLI-/Contract-Baseline

- Binary-Name: `betankungen-ev`
- Stabiler Modul-Identifier in `--module-info`: `module_name="ev"`
- Verbindliche Grundkommandos:
  - `--help`
  - `--version`
  - `--module-info`
  - `--migrate`
  - `--add charging`
  - `--list charging`
  - `--stats charging`
- Erwartete Scope-/Output-Leitplanken:
  - `--car-id` fuer car-scoped Operationen
  - `--from`/`--to` nur additiv und konsistent zu Core-Konventionen
  - `--json [--pretty]` nur im Stats-Kontext
- Erwartete `capabilities` fuer einen ersten EV-MVP:
  - `supports_migrate`
  - `supports_add_charging`
  - `supports_list_charging`
  - `supports_stats_charging`
  - `supports_stats_json`
  - `supports_stats_pretty`
  - `supports_car_scope`
  - `supports_period_scope`
- Wenn JSON-Stats im ersten Block geliefert werden, bleibt der Contract klar
  versioniert und nutzt mindestens:
  - `contract_version`
  - `kind="ev_charging_stats_v1"`
  - `generated_at`
  - `app_version`

### Explizite Nicht-Ziele

- keine produktive EV-Implementierung in diesem Discovery-Task
- kein generisches `energy`-Alias oder gemischtes Fuel+EV-Target im Core
- keine Karten-, Routing-, Provider-Sync- oder Tarifmodell-Arbeit
- keine Household-Drivers-/Shared-Cars-Kopplung
- keine Vorfestlegung auf Ladeleistungs-, SoC- oder Batteriegesundheits-
  Modellierung

### Handover fuer `TSK-0025`

`TSK-0025` soll auf dieser Baseline jetzt nur noch die offenen Modellfragen
fuer einen MVP konkretisieren:

- minimales Charging-Event-Payload
- notwendige vs. optionale Event-Felder
- Tabellen-/Storage-Zuschnitt im Modul
- Ladeort- und Anbieter-Referenzmodell
- konkrete Stats-/JSON-Payload fuer den ersten `charging`-Pfad

## 9) Startpunkt fuer erste Module

Priorisierte Kandidaten gemaess Backlog:

- `betankungen-maintenance` (`BL-007`)
- `betankungen-ev` (ADR-0008, EV-Strategie)
- `betankungen-agriculture` (`BL-009`)

Dieses Dokument ist bewusst ein technischer Start-Contract und wird mit den
ersten realen Modul-Implementierungen weiter praezisiert.
