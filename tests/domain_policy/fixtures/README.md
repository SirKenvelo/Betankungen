# Domain-Policy Fixtures
**Stand:** 2026-02-22

## SQL-Seeds
- `seed_big.sql`: erzeugt den großen Last-/Output-Datensatz (500 Fuelups).
- `seed_policy.sql`: erzeugt den kleinen, deterministischen Policy-Datensatz (3 Fuelups).
- `p001_base.sql`: minimaler P-001-Zustand fuer car_id-Invalid-Hard-Error-Cases.
- `p002_base.sql`: minimaler P-002-Zustand fuer car_id-FK-Hard-Error-Cases.
- `p012_base.sql`: minimaler P-012-Zustand fuer Gap-Confirm YES/NO-Template.
- `p022_base.sql`: minimaler P-022-Zustand fuer Consumption-Warn-Confirm YES/NO-Template.

## Generierte DB-Dateien
Diese Dateien werden bewusst nicht versioniert und vom Helper erzeugt:
- `Betankungen_Big.db`
- `Betankungen_Policy.db`

Erzeugung aus dem Projektroot:
- `tests/domain_policy/helpers/build_test_dbs.sh`
