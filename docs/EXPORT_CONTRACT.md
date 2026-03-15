# EXPORT CONTRACT
**Stand:** 2026-03-15

Zweck: Stabiler Export-Vertrag fuer maschinenlesbare Ausgabeformate (JSON/CSV).

## Contract Versioning

- `contract_version: 1` (Start)
- Breaking Change => `contract_version` erhoehen (`contract_version++`)

## JSON Contract

Pflichtfelder:
- `contract_version`
- `generated_at`
- `app_version`

Payload (v1, aktueller Stand):
- Report-Kennung: Feld `kind` (z. B. `fuelups_monthly`, `fuelups_yearly`, `fuelups_full_tank_cycles`, `fleet_mvp`, `cost_mvp`)
- Nutzdaten:
  - fuelups monthly/yearly: `rows`
  - fuelups full_tank_cycles: `cycles` + `sum`
  - fleet_mvp: `fleet` (`cars_total`, `fuelups_total`, `liters_ml_total`, `total_cents_all`)
- cost_mvp: `cost` (`scope_mode`, `scope_car_id`, `maintenance_source_mode`, `maintenance_source_active`, `maintenance_source_note`, `period_enabled`, `period_from`, `period_to_exclusive`, `period_from_provided`, `period_to_provided`, `cars_total`, `cars_with_cycles`, `distance_km_total`, `fuel_cents_total`, `maintenance_cents_total`, `total_cents`, `cost_per_km_available`, `fuel_cost_per_km_eur_x1000`, `maintenance_cost_per_km_eur_x1000`, `total_cost_per_km_eur_x1000`)

### Module JSON Contract (Maintenance Companion v1)

#### Module Handshake Contract (`--module-info` v1)

Companion-Modul `betankungen-maintenance`:
- Top-Level-Keys:
  - `module_name`
  - `module_version`
  - `min_core_version`
  - `db_schema_version`
  - `capabilities`
- `capabilities` ist ein Objekt mit stabilen booleschen Keys:
  - `supports_migrate`
  - `supports_add_maintenance`
  - `supports_list_maintenance`
  - `supports_stats_maintenance`
  - `supports_stats_json`
  - `supports_stats_pretty`
  - `supports_car_scope`
  - `supports_period_scope`

Contract-Regel:
- `capabilities` wird nur additiv erweitert (keine stillen Semantikwechsel).

Companion-Modul `betankungen-maintenance`:
- `kind`: `maintenance_stats_v1`
- Payload-Feld: `maintenance`
- Keys in `maintenance` (v1):
  - `scope_mode`
  - `scope_car_id`
  - `events_total`
  - `cars_total`
  - `total_cost_cents`
  - `avg_cost_per_event_cents`
  - `period_from`
  - `period_to`

Guardrails (Companion-CLI):
- `--pretty` nur zusammen mit `--module-info` oder `--stats maintenance --json`
- `--json` nur fuer `--stats maintenance`
- `--stats maintenance` akzeptiert keine Add-Parameter (`--date`, `--type`, `--cost-cents`, `--notes`)

Core-zu-Modul-Integration (Cost):
- Aktivierung ueber `--stats cost --maintenance-source module`
- Optionales Environment-Override fuer den Companion-Binary-Pfad:
  - `BETANKUNGEN_MAINTENANCE_BIN`
- Optionales Environment-Override fuer die Modul-DB:
  - `BETANKUNGEN_MAINTENANCE_DB`
- Bei nicht verfuegbarem oder fehlerhaftem Companion bleibt der Cost-Run erfolgreich
  mit explizitem Fallback (`maintenance_source_active=false`, `maintenance_source_note` gesetzt).
- Integrationszustand wird im Cost-JSON explizit markiert:
  - Core-only: `maintenance_source_mode="none"`, `maintenance_source_active=false`
  - Modul aktiv: `maintenance_source_mode="module"`, `maintenance_source_active=true`
  - Modul-Fallback: `maintenance_source_mode="module"`, `maintenance_source_active=false`, Grund in `maintenance_source_note`

## CSV Contract

- Erste Spalte: `contract_version`
- Header ist API (stabil)
- Strict CSV: keine Kommentare, keine impliziten Escaping-Annahmen
- `--yearly` hat keinen CSV-Export (Kombination `--yearly --csv` ist ungueltig).

## Scope-Regeln

- 1 Car: `--car-id` optional
- >1 Cars: `--car-id` verpflichtend

## Period-Regeln

- `from` inklusiv
- `to` exklusiv

## Stability Rules

- Keine Feldentfernung
- Nur additive Erweiterungen
- CSV-Spaltenreihenfolge bleibt stabil

## Deprecation Status (POL-002)

Aktive Deprecations (Stand 2026-03-15):
- none

Regel fuer neue Deprecations:
- Lifecycle nach `POL-002` (Phase A `announced`, Phase B `deprecated`, Phase C `removed`).
- Jede neue Deprecation wird in diesem Abschnitt und im Changelog dokumentiert,
  inkl. Nachfolger und geplanter Entfernungsphase.
