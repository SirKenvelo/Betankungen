# Tests
**Stand:** 2026-02-27

## Ordnerstruktur
- `tests/domain_policy/`: Policy-Matrix und zugehoerige Hilfsmittel.
- `tests/domain_policy/cases/`: kleine, fokussierte Policy-Cases.
- `tests/domain_policy/fixtures/`: SQL-Seeds und generierte Test-DBs.
- `tests/domain_policy/helpers/`: Mini-Utilities (z. B. DB-Build).
- `tests/regression/`: Bugs, die nicht zurueckkommen duerfen.
- `tests/smoke/`: End-to-End-CLI-Sanity-Checks.

Kompatibilitaets-Wrapper bleiben im Root erhalten:
- `tests/smoke_cli.sh` -> `tests/smoke/smoke_cli.sh`
- `tests/smoke_clean_home.sh` -> `tests/smoke/smoke_clean_home.sh`
- `tests/smoke_cars_crud.sh` -> `tests/smoke/smoke_cars_crud.sh`
- `tests/run_unit_tests.sh` -> `tests/domain_policy/run_domain_policy_tests.sh`

## Namenskonvention (Policy-Cases)
- Case-Dateien: `t_<policy>__<nn>__<kurzname>.*`
- Beispiel:
  - `t_p012__01__gap_confirm_yes.*`
  - `t_p012__02__gap_confirm_no.*`
  - `t_p022__01__consumption_warn_yes.*`
- Golden-Template P-012:
  - `tests/domain_policy/fixtures/p012_base.sql`
  - `tests/domain_policy/cases/t_p012__01__gap_confirm_yes.sh`
  - `tests/domain_policy/cases/t_p012__02__gap_confirm_no.sh`
- Golden-Template P-022:
  - `tests/domain_policy/fixtures/p022_base.sql`
  - `tests/domain_policy/cases/t_p022__01__consumption_warn_yes.sh`
  - `tests/domain_policy/cases/t_p022__02__consumption_warn_no.sh`

## Test-DB-Strategie
Die Testlandschaft ist bewusst zweigleisig:
- `Betankungen_Big.db`: grosser Datensatz fuer Output-/Performance-/Dashboard-Checks.
- `Betankungen_Policy.db`: kleiner, deterministischer Datensatz fuer Policy-Cases.

SQL-Seeds:
- `tests/domain_policy/fixtures/seed_big.sql` (~500 Fuelups)
- `tests/domain_policy/fixtures/seed_policy.sql` (1-3 relevante Fuelups, Default-Car + optional zweites Car)

DB-Erzeugung (aus Projektroot):
- `tests/domain_policy/helpers/build_test_dbs.sh`

Erzeugte Dateien:
- `tests/domain_policy/fixtures/Betankungen_Big.db`
- `tests/domain_policy/fixtures/Betankungen_Policy.db`

## Domain-Policy-Runner
- Script: `tests/domain_policy/run_domain_policy_tests.sh`
- Verhalten:
  - erzeugt zuerst beide Test-DBs,
  - kompiliert alle `t_*.pas` in `tests/domain_policy/cases/`,
  - fuehrt die Cases nacheinander aus.
- Runner-Konvention: ein Case entspricht genau einem Aufruf, Assertions laufen ueber Exit-Code sowie Stdout/Stderr.
- Interaktive Bestaetigungen werden in Cases ueber STDIN simuliert.

Direktlauf:
- `tests/domain_policy/run_domain_policy_tests.sh`
- kompatibel: `tests/run_unit_tests.sh`

## Smoke-Test
- Script: `tests/smoke/smoke_cli.sh`
- Zweck: schneller Plausibilitaetscheck fuer Ordnerstruktur, Release-/Backup-Skripte und CLI-Binary.
- Der Smoke-Lauf baut Test-DBs mit auf und startet den Domain-Policy-Runner.
- Dedizierter Cars-CRUD-Smoke: `tests/smoke/smoke_cars_crud.sh`.
- Cars-CRUD-Smoke deckt zusaetzlich Car-Resolver-Scope fuer Fuelups ab:
  - `--add fuelups` ohne `--car-id` bei 1 Car = OK
  - `--add fuelups` ohne `--car-id` bei >1 Cars = Hard Error
  - `--list fuelups` ohne `--car-id` bei 1 Car = OK
  - `--list fuelups` ohne `--car-id` bei >1 Cars = Hard Error
  - `--list fuelups --car-id <id>` ist strikt auf dieses Fahrzeug gescoped
- Zusatzsuiten:
  - `-m`: Monthly-Suite
  - `-y`: Yearly-Suite
  - `-c`: Cars-Suite
  - `-a`: beide Suiten
- Steuerung:
  - Default: fail-fast
  - `--keep-going`: Fehler sammeln
  - `-l`/`--list`: nur Testplan

Ausfuehrung:
- `tests/smoke/smoke_cli.sh`
- `tests/smoke/smoke_cli.sh -m|-y|-c|-a`
- `tests/smoke/smoke_cars_crud.sh`
- kompatibel: `tests/smoke_cli.sh`

## Finaler Smoke in sauberer HOME-Sandbox
- Script: `tests/smoke/smoke_clean_home.sh`
- Zweck: reproduzierbarer End-to-End-Lauf in isolierter HOME/XDG-Umgebung.

Ausfuehrung:
- `tests/smoke/smoke_clean_home.sh`
- `tests/smoke/smoke_clean_home.sh -m|-y|-c|-a`
- `tests/smoke/smoke_clean_home.sh -a --keep-going`
- `tests/smoke/smoke_clean_home.sh -a -l`
- optional: `tests/smoke/smoke_clean_home.sh --keep-home`
- kompatibel: `tests/smoke_clean_home.sh`
