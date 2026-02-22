# Domain-Policy-Tests
**Stand:** 2026-02-22

## Inhalt
- `cases/`: fokussierte Case-Dateien nach Policy-ID (`t_<policy>__<nn>__<kurzname>.*`, `.pas` oder `.sh`)
- `fixtures/`: SQL-Seeds und generierte DBs (`Betankungen_Big.db`, `Betankungen_Policy.db`)
- `helpers/`: Runner-Helfer (DB-Build)

## Golden Template
- P-012 Referenz fuer Warning+Confirm-Flows:
  - `cases/t_p012__01__gap_confirm_yes.sh`
  - `cases/t_p012__02__gap_confirm_no.sh`
  - `fixtures/p012_base.sql`
- P-022 Referenz fuer Warning+Confirm-Flows:
  - `cases/t_p022__01__consumption_warn_yes.sh`
  - `cases/t_p022__02__consumption_warn_no.sh`
  - `fixtures/p022_base.sql`

## Einstieg
- Cases starten: `tests/domain_policy/run_domain_policy_tests.sh`
- Nur DBs erzeugen: `tests/domain_policy/helpers/build_test_dbs.sh`
