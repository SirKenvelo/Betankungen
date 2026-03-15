# Contract Hardening Checklist for 1.0.0
**Stand:** 2026-03-15
**Status:** active

## Ziel

Diese Checkliste operationalisiert `POL-002` fuer den laufenden 1.0.0-Zyklus
(Gate 2 / Sprint 13) und mappt die aktuellen Contract-Flaechen auf konkrete
Nachweise.

## Scope

- JSON-Contracts (Core + Companion)
- CSV-Contract (fuelups stats)
- CLI-Contract (Flag-/Semantik-Grenzen)
- Deprecation-/Breaking-Regeln aus `POL-002`

## Compliance-Matrix (abgeleitet aus POL-002)

| Regel aus POL-002 | Contract-Flaeche | Aktueller Nachweis | Stand | Restscope S13 |
| --- | --- | --- | --- | --- |
| Additiv ist Standard | JSON (Core) | `docs/EXPORT_CONTRACT.md`, `tests/regression/run_export_contract_json_check.sh` | abgedeckt | weiter bei neuen Feldern nur additive Keys |
| Additiv ist Standard | JSON (Companion `--module-info` + maintenance stats) | `docs/MODULES_ARCHITECTURE.md`, `docs/EXPORT_CONTRACT.md`, `tests/smoke/smoke_modules.sh` | abgedeckt | bei neuen `capabilities` nur additive Keys |
| Breaking Change => expliziter Bump + Doku + Testupdate | JSON/CSV | Regel in `POL-002`, Contract-Basis in `docs/EXPORT_CONTRACT.md`, zentrale Regressionen `run_export_contract_json_check.sh` + `run_export_contract_csv_check.sh` | abgedeckt | bei echten Breaking Changes weiterhin verpflichtend: Bump + Doku + Testupdate im selben Change |
| Keine stillen Semantikwechsel | CLI | `tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`, `tests/smoke/smoke_cli.sh` | abgedeckt | neue CLI-Optionen nur mit Validate/Help/Smoke im selben Change |
| Maschinenfreundliche Ausgabe stabil | JSON/CSV | JSON-Check (`run_export_contract_json_check.sh`), zentraler CSV-Check (`run_export_contract_csv_check.sh`), feldbasierte CSV-Regressionen in Smoke/Domain-Policy (`tests/helpers/csv.sh`, `t_p060__01`, `t_p060__02`) | abgedeckt | bei Contract-Erweiterungen nur additive Felder und stabile Header-Reihenfolge |
| CLI-Deprecation Lifecycle (A/B/C) | CLI | Policy-Definition vorhanden (`POL-002`) | offen | S13C3: "Aktive Deprecations"-Abschnitt in Doku etablieren (aktuell: keine aktiven Deprecations) |

## Gate-2 Exit-Kriterien (Operationalisierung)

Gate 2 gilt als abgeschlossen, wenn:

1. diese Matrix keinen offenen Blocker mehr fuer 1.0.0 enthaelt,
2. CSV-Contract-Regression zentral und reproduzierbar verankert ist,
3. Deprecation-Status sichtbar dokumentiert ist (auch wenn "none"),
4. `make verify` inklusive neuer Contract-Gates gruen ist.

## Referenzen

- `docs/policies/POL-002-contract-evolution-and-deprecation.md`
- `docs/EXPORT_CONTRACT.md`
- `docs/MODULES_ARCHITECTURE.md`
- `tests/regression/run_export_contract_json_check.sh`
- `tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`
- `tests/domain_policy/cases/t_p060__01__stats_skip_interval_missed_previous.sh`
- `tests/domain_policy/cases/t_p060__02__car_isolation.sh`
