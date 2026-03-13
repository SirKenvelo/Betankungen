# Regression-Tests
**Stand:** 2026-03-13

Hier liegen reproduzierbare Regression-Cases fuer bereits behobene Bugs.

Namenskonvention:
- `r_<id>__<kurzname>.*`

Aktueller automatischer Check:
- `tests/regression/run_export_contract_json_check.sh`
  - vergleicht JSON-Contract-Keys aus `docs/EXPORT_CONTRACT.md` mit realen CLI-JSON-Ausgaben (inkl. Cost-Scope-/Period-Feldern).
