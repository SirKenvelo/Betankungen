# Domain-Policy-Tests
**Stand:** 2026-02-22

## Inhalt
- `cases/`: fokussierte Case-Dateien nach Policy-ID (`t_<policy>__<nn>__<kurzname>.*`, `.pas` oder `.sh`)
- `fixtures/`: SQL-Seeds und generierte DBs (`Betankungen_Big.db`, `Betankungen_Policy.db`)
- `helpers/`: Runner-Helfer (DB-Build)

## Golden Template
- P-001 Referenz fuer Hard-Error ohne Write:
  - `cases/t_p001__01__car_id_zero.sh`
  - `cases/t_p001__02__car_id_negative.sh`
  - `fixtures/p001_base.sql`
- P-002 Referenz fuer Hard-Error ohne Write (FK):
  - `cases/t_p002__01__car_id_missing_fk.sh`
  - `fixtures/p002_base.sql`
- Odometer-Policy-Block P-010..P-013:
  - `P-010` Hard Error (unter Start-KM):
    - `cases/t_p010__01__odometer_below_start_km.sh`
    - `fixtures/p010_base.sql`
  - `P-011` Hard Error (unter Last-KM pro car):
    - `cases/t_p011__01__odometer_below_last_km.sh`
    - `fixtures/p011_base.sql`
  - `P-012` Warning+Confirm (grosse Distanzluecke):
    - `cases/t_p012__01__gap_confirm_yes.sh`
    - `cases/t_p012__02__gap_confirm_no.sh`
    - `fixtures/p012_base.sql`
  - `P-013` Hard Error (Duplikat-KM / delta=0):
    - `cases/t_p013__01__odometer_duplicate_km.sh`
    - `fixtures/p013_base.sql`
- Fuel-/Plausibility-Block P-020..P-022:
  - `P-020` Hard Error (`liters <= 0` oder NaN):
    - `cases/t_p020__01__liters_zero.sh`
    - `cases/t_p020__02__liters_nan.sh`
    - `fixtures/p020_base.sql`
  - `P-021` Warning+Confirm (`liters > 150`):
    - `cases/t_p021__01__fuel_warning_yes.sh`
    - `cases/t_p021__02__fuel_warning_no.sh`
    - `fixtures/p021_base.sql`
  - `P-022` Warning+Confirm (bereits vorhanden):
    - `cases/t_p022__01__consumption_warn_yes.sh`
    - `cases/t_p022__02__consumption_warn_no.sh`
    - `fixtures/p022_base.sql`
- Cost-/Price-Block P-030..P-032:
  - `P-030` Hard Error (`cost_cents < 0`):
    - `cases/t_p030__01__cost_negative.sh`
    - `fixtures/p030_base.sql`
  - `P-031` Warning+Confirm (`cost_cents == 0`):
    - `cases/t_p031__01__cost_zero_warn_yes.sh`
    - `cases/t_p031__02__cost_zero_warn_no.sh`
    - `fixtures/p031_base.sql`
  - `P-032` Warning+Confirm (`price_cents_per_liter <= 0`):
    - `cases/t_p032__01__price_zero_warn_yes.sh`
    - `cases/t_p032__02__price_zero_warn_no.sh`
    - `fixtures/p032_base.sql`
- Date-Block P-040..P-041:
  - `P-040` Hard Error (Datum/Zeit fehlt oder ungueltig):
    - `cases/t_p040__01__datetime_invalid.sh`
    - `fixtures/p040_base.sql`
  - `P-041` Warning+Confirm (Datum in der Zukunft `> now + 10 min`):
    - `cases/t_p041__01__future_date_warn_yes.sh`
    - `cases/t_p041__02__future_date_warn_no.sh`
    - `fixtures/p041_base.sql`

## Einstieg
- Cases starten: `tests/domain_policy/run_domain_policy_tests.sh`
- Nur DBs erzeugen: `tests/domain_policy/helpers/build_test_dbs.sh`
