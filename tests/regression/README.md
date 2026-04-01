# Regression-Tests
**Stand:** 2026-04-01

Hier liegen reproduzierbare Regression-Cases fuer bereits behobene Bugs.

Namenskonvention:
- `r_<id>__<kurzname>.*`

Aktueller automatischer Check:
- `tests/regression/run_export_contract_json_check.sh`
  - vergleicht JSON-Contract-Keys aus `docs/EXPORT_CONTRACT.md` mit realen CLI-JSON-Ausgaben (inkl. Cost-Scope-/Period-Feldern).
- `tests/regression/run_export_contract_csv_check.sh`
  - validiert CSV-Header-/Versionierungsregeln aus `docs/EXPORT_CONTRACT.md` gegen reale CLI-CSV-Ausgaben (inkl. Guardrail `--yearly --csv`).
- `tests/regression/run_cost_integration_modes_check.sh`
  - validiert den Cost-Integrationscontract fuer `--maintenance-source none|module` inkl. aktivem Modulpfad und expliziten Fallback-Szenarien.
- `tests/regression/run_package_manifest_fixture_check.sh`
  - validiert den Manifest-v1-Contract fuer Export-Pakete gegen Dry-Run-Fixtures (valid/invalid).
- `tests/regression/run_db_backup_ops_check.sh`
  - validiert den Multi-DB-Backup-Operationspfad (`scripts/db_backup_ops.sh`) fuer Scope-Guardrails, Dry-Run, Single/All-Run, Integritaetsmetadaten, Index-Konsistenz und Retention.
- `tests/regression/run_fuel_price_history_check.sh`
  - validiert die getrennte Preis-Historienbasis (`scripts/fuel_price_polling_run.sh`) fuer Pflichtargumente, Dry-Run, Raw-Snapshot-Ablage, SQLite-Persistenz, State-Datei, Duplikat-Schutz und sauberen Fehlerpfad ohne Partial-Write.
- `tests/regression/run_receipt_link_contract_check.sh`
  - validiert den Receipt-Link-Contract fuer `--receipt-link` (Scope-Guardrails, Write-Path in `fuelups.receipt_link`, Detailausgabe sowie JSON-Sichtbarkeit `receipt_links_set`/`receipt_links_missing`).
- `tests/regression/run_station_geodata_contract_check.sh`
  - validiert den Stations-Geodaten-Contract fuer `latitude/longitude` und `plus_code` (Normalisierung, Short-Code-Recovery auf Vollcode, Persistenz und kompakte vs. Detail-Ausgabe bei `--list stations`).
- `tests/regression/run_user_flow_break_matrix_check.sh`
  - validiert priorisierte User-Flow-/Break-Pfade aus `docs/TEST_MATRIX.md` (u. a. INIT-/DEMO-Basispfade, unknown-flag-Fehler, EOF-Abbruch bei `--add fuelups`, Multi-Car-Guidance-Hints).
