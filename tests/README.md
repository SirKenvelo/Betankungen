# Tests
**Stand:** 2026-03-10

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
- `tests/smoke_multi_car_context.sh` -> `tests/smoke/smoke_multi_car_context.sh`
- `tests/smoke_migrations.sh` -> `tests/smoke/smoke_migrations.sh`
- `tests/smoke_modules.sh` -> `tests/smoke/smoke_modules.sh`
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
- Baseline deckt jetzt zusaetzlich `--stats fleet` (MVP-Textausgabe) ab.
- Der Smoke-Lauf baut Test-DBs mit auf und startet den Domain-Policy-Runner.
- Dedizierter Cars-CRUD-Smoke: `tests/smoke/smoke_cars_crud.sh`.
- Dedizierter Resolver-Matrix-Smoke: `tests/smoke/smoke_multi_car_context.sh`.
- Dedizierter Migrations-Smoke: `tests/smoke/smoke_migrations.sh` (aktuell: `--v4-to-v5`).
- Dedizierter Module-Contract-Smoke: `tests/smoke/smoke_modules.sh` (`--module-info` compact/pretty, unknown-flag-Fehlerpfad).
- Die `-c`-Cars-Suite in `tests/smoke/smoke_cli.sh` prueft den kompatiblen Wrapper `tests/smoke_cars_crud.sh` (inkl. Transit auf `tests/smoke/smoke_cars_crud.sh`).
- Die `-c`-Cars-Suite prueft zusaetzlich den Wrapper `tests/smoke_multi_car_context.sh` (inkl. Transit auf `tests/smoke/smoke_multi_car_context.sh`).
- Cars-CRUD-Smoke deckt zusaetzlich Car-Resolver-Scope fuer Fuelups ab:
  - `--add fuelups` ohne `--car-id` bei 1 Car = OK
  - `--add fuelups` ohne `--car-id` bei >1 Cars = Hard Error
  - `--list fuelups` ohne `--car-id` bei 1 Car = OK
  - `--list fuelups` ohne `--car-id` bei >1 Cars = Hard Error
  - `--list fuelups --car-id <id>` ist strikt auf dieses Fahrzeug gescoped
  - `--stats fuelups` ohne `--car-id` bei 1 Car = OK
  - `--stats fuelups` ohne `--car-id` bei >1 Cars = Hard Error
  - `--stats fuelups --car-id <id>` ist strikt auf dieses Fahrzeug gescoped
- Resolver-Matrix-Smoke deckt zusaetzlich die finale 0/1/>1-Car-Matrix und Guardrails ab:
  - 0 Cars: `--add/--list/--stats fuelups` => Hard Error (`no cars found`)
  - 1 Car: ohne `--car-id` OK, mit gueltiger `--car-id` OK, mit ungueltiger `--car-id` Hard Error
  - >1 Cars: ohne `--car-id` Hard Error (`multiple cars found`), mit gueltiger `--car-id` strikt scoped
  - Cross-Car-Isolation: `--stats fuelups --car-id <id>` aggregiert niemals fremde Fahrzeuge
  - Cars-Guards: `--edit/--delete cars` ohne `--car-id` required, unknown `--car-id` wird geblockt, `--car-id 0` wird als invalid input geblockt
- 0-Cars-Test-Guard:
  - Der Resolver-Pfad fuer 0 Cars wird im Smoke explizit ueber einen Test-Trigger erzwungen (`trg_block_default_car_insert`) und danach per `DELETE FROM cars` validiert.
  - Bei Schema-/Migrationsaenderungen muss dieser Guard explizit mitgeprueft und bei Bedarf angepasst werden, damit Resolver-Hard-Errors fuer 0/1/>1 Cars stabil bleiben.
  - Optionaler Migrations-Check: in einer reinen Test-DB temporaer alle Cars loeschen (nicht Produktions-Flow), um den 0-Cars-Pfad gezielt zu validieren.
- Hinweis zu CSV-Scope-Assertions:
  - Feldbasierte Vergleiche (Token-Parsing via `tests/helpers/csv.sh`) sind fuer Stats-CSV in Smoke und Domain-Policy der Standard.
  - Contract-Checks fuer Stats-CSV laufen ueber Header-/Spalten-/Rowcount-/Feldassertions statt Vollzeilen-Regex-Matches.
- Zusatzsuiten:
  - `-m`: Monthly-Suite
  - `-y`: Yearly-Suite
  - `-c`: Cars-Suite
  - `--migrations`: Migrations-Suite
  - `--modules`: Modules-Suite
  - `-a`: beide Suiten
- Steuerung:
  - Default: fail-fast
  - `--keep-going`: Fehler sammeln
  - `-l`/`--list`: nur Testplan

Ausfuehrung:
- `tests/smoke/smoke_cli.sh`
- `tests/smoke/smoke_cli.sh -m|-y|-c|--migrations|--modules|-a`
- `tests/smoke/smoke_cars_crud.sh`
- `tests/smoke/smoke_multi_car_context.sh`
- `tests/smoke/smoke_migrations.sh --v4-to-v5`
- `tests/smoke/smoke_modules.sh`
- kompatibel: `tests/smoke_cli.sh`

## Finaler Smoke in sauberer HOME-Sandbox
- Script: `tests/smoke/smoke_clean_home.sh`
- Zweck: reproduzierbarer End-to-End-Lauf in isolierter HOME/XDG-Umgebung.

Ausfuehrung:
- `tests/smoke/smoke_clean_home.sh`
- `tests/smoke/smoke_clean_home.sh -m|-y|-c|--migrations|--modules|-a`
- `tests/smoke/smoke_clean_home.sh -a --keep-going`
- `tests/smoke/smoke_clean_home.sh -a -l`
- optional: `tests/smoke/smoke_clean_home.sh --keep-home`
- kompatibel: `tests/smoke_clean_home.sh`
