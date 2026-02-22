# Domain-Policy Fixtures
**Stand:** 2026-02-22

## SQL-Seeds
- `seed_big.sql`: erzeugt den großen Last-/Output-Datensatz (500 Fuelups).
- `seed_policy.sql`: erzeugt den kleinen, deterministischen Policy-Datensatz (3 Fuelups).
- `p001_base.sql`: minimaler P-001-Zustand fuer car_id-Invalid-Hard-Error-Cases.
- `p002_base.sql`: minimaler P-002-Zustand fuer car_id-FK-Hard-Error-Cases.
- `p010_base.sql`: minimaler P-010-Zustand fuer Odometer-Start-KM-Hard-Error.
- `p011_base.sql`: minimaler P-011-Zustand fuer Odometer-Last-KM-Hard-Error.
- `p012_base.sql`: minimaler P-012-Zustand fuer Gap-Confirm YES/NO-Template.
- `p013_base.sql`: minimaler P-013-Zustand fuer Odometer-Duplikat-KM-Hard-Error.
- `p020_base.sql`: minimaler P-020-Zustand fuer Fuel-Hard-Error (`liters <= 0`/NaN).
- `p021_base.sql`: minimaler P-021-Zustand fuer Fuel-Warning+Confirm (`liters > 150`).
- `p022_base.sql`: minimaler P-022-Zustand fuer Consumption-Warn-Confirm YES/NO-Template.
- `p030_base.sql`: minimaler P-030-Zustand fuer Cost-Hard-Error (`cost_cents < 0`).
- `p031_base.sql`: minimaler P-031-Zustand fuer Cost-Warning+Confirm (`cost_cents == 0`).
- `p032_base.sql`: minimaler P-032-Zustand fuer Price-Warning+Confirm (`price_cents_per_liter <= 0`).

## Generierte DB-Dateien
Diese Dateien werden bewusst nicht versioniert und vom Helper erzeugt:
- `Betankungen_Big.db`
- `Betankungen_Policy.db`

Erzeugung aus dem Projektroot:
- `tests/domain_policy/helpers/build_test_dbs.sh`
