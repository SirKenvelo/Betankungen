# Regression-Tests
**Stand:** 2026-03-15

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
