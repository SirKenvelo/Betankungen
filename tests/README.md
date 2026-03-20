# Tests
**Stand:** 2026-03-20

## Abgrenzung / Source of Truth

- `docs/TEST_MATRIX.md` definiert die kanonische Teststrategie, Testebenen,
  Coverage-Bereiche und Release-Gates.
- `tests/README.md` beschreibt bewusst nur die heute im Repository vorhandenen
  und ausfuehrbaren Suiten, Runner und Fixtures.
- Konkrete reproduzierbare Produktprobleme und Hardening-Follow-ups werden im
  Tracker unter `docs/issues/` und `docs/backlog/` gefuehrt.

## Ordnerstruktur
- `tests/benchmark/`: optionaler Benchmark-Runner fuer trigger-basierte Performance-Messungen.
- `tests/domain_policy/`: Policy-Matrix und zugehoerige Hilfsmittel.
- `tests/domain_policy/cases/`: kleine, fokussierte Policy-Cases.
- `tests/domain_policy/fixtures/`: SQL-Seeds und generierte Test-DBs.
- `tests/domain_policy/helpers/`: Mini-Utilities (z. B. DB-Build).
- `tests/regression/`: Bugs, die nicht zurueckkommen duerfen.
- `tests/smoke/`: End-to-End-CLI-Sanity-Checks.
- `tests/smoke/helpers/`: modulare Funktionsbloecke fuer `smoke_cli.sh` (Fleet/Cost/Bootstrap).

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
- DB-Build ist jetzt race-safe: der Helper serialisiert parallele Aufrufe per Lock und ersetzt fertige DBs atomar.

## Domain-Policy-Runner
- Script: `tests/domain_policy/run_domain_policy_tests.sh`
- Verhalten:
  - erzeugt zuerst beide Test-DBs,
  - kompiliert alle `t_*.pas` in `tests/domain_policy/cases/`,
  - fuehrt die Cases nacheinander aus.
  - nutzt eine isolierte `HOME`/`XDG`-Testumgebung, damit lokale User-Config den Lauf nicht beeinflusst.
- Runner-Konvention: ein Case entspricht genau einem Aufruf, Assertions laufen ueber Exit-Code sowie Stdout/Stderr.
- Interaktive Bestaetigungen werden in Cases ueber STDIN simuliert.

Direktlauf:
- `tests/domain_policy/run_domain_policy_tests.sh`
- kompatibel: `tests/run_unit_tests.sh`

## Regression-Checks
- Script: `tests/regression/run_export_contract_json_check.sh`
- Zweck: Liest die JSON-Contract-Keys aus `docs/EXPORT_CONTRACT.md` und validiert sie gegen echte CLI-JSON-Ausgaben (`fuelups` full/monthly/yearly, `fleet`, `cost`).
- Script: `tests/regression/run_export_contract_csv_check.sh`
- Zweck: Validiert den CSV-Contract aus `docs/EXPORT_CONTRACT.md` gegen echte CLI-CSV-Ausgaben (`--stats fuelups --csv`) inkl. Guardrail fuer die ungueltige Kombination `--yearly --csv`.
- Script: `tests/regression/run_cost_integration_modes_check.sh`
- Zweck: validiert den Cost-Integrationscontract fuer `--maintenance-source none|module` inkl. aktivem Companion-Pfad und expliziten Fallbacks (fehlendes Binary, period-gefilterter Modulmodus).
- Script: `tests/regression/run_package_manifest_fixture_check.sh`
- Zweck: validiert den Export-Package-Manifest-Contract v1 gegen reproduzierbare Dry-Run-Fixtures (1x valid, mehrere invalid).
- Script: `tests/regression/run_db_backup_ops_check.sh`
- Zweck: validiert den Multi-DB-Backup-Operationspfad (`scripts/db_backup_ops.sh`) inkl. Scope-Guardrails, Dry-Run, Single/All-Run, Integritaetsmetadaten, Index-Konsistenz und Retention.
- Script: `tests/regression/run_receipt_link_contract_check.sh`
- Zweck: validiert den Receipt-Link-Contract fuer `--receipt-link` (Scope-Guardrails, Write-Path in `fuelups.receipt_link`, Detailausgabe und JSON-Sichtbarkeit `receipt_links_set`/`receipt_links_missing`).

Direktlauf:
- `tests/regression/run_export_contract_json_check.sh`
- `tests/regression/run_export_contract_csv_check.sh`
- `tests/regression/run_cost_integration_modes_check.sh`
- `tests/regression/run_package_manifest_fixture_check.sh`
- `tests/regression/run_db_backup_ops_check.sh`
- `tests/regression/run_receipt_link_contract_check.sh`

## Benchmark (optional)

- Script: `tests/benchmark/run_stats_benchmark.sh`
- Zweck: reproduzierbare Laufzeitmessung fuer definierte Stats-Pfade
  (fuelups/fleet/cost), ausserhalb der Pflicht-Gates.
- Standard-Fixture: `tests/domain_policy/fixtures/Betankungen_Big.db`

Direktlauf:
- `tests/benchmark/run_stats_benchmark.sh --iterations 5 --warmup 1`
- optional JSON-Protokoll:
  `tests/benchmark/run_stats_benchmark.sh --json-out .artifacts/benchmarks/stats_bench.json`

## Smoke-Test
- Script: `tests/smoke/smoke_cli.sh`
- Zweck: schneller Plausibilitaetscheck fuer Ordnerstruktur, Release-/Backup-Skripte und CLI-Binary.
- Interne Struktur: Fleet-/Cost-/Bootstrap-Checks sind in dedizierte Helper unter `tests/smoke/helpers/` ausgelagert; `smoke_cli.sh` sourced diese zentral.
- Prefix-Ausgabe ist in allen dedizierten Smoke-Skripten vereinheitlicht (TTY): `[OK]` gruen, `[INFO]` gelb, `[FAIL]` rot.
- Baseline deckt jetzt zusaetzlich `--stats fleet` (MVP-Text + JSON compact/pretty) inkl. Guardrails fuer ungueltige Fleet-Optionen (`--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`) ab.
- Baseline deckt jetzt zusaetzlich `--stats cost` (MVP-Text + JSON compact/pretty) ab; Cost-Guardrails bleiben fuer `--csv`, `--monthly`, `--yearly`, `--dashboard` regressionsgesichert.
- Cost-Scope ist in den Smokes funktionsbezogen abgesichert: `--stats cost --from ...` und `--stats cost --car-id ...` werden mit wirksamer Aggregationsfilterung geprueft.
- Cost-JSON-Scope ist regressionsgesichert: `--stats cost --json --car-id ... --from ...` prueft Contract-Felder und Scope-/Period-Werte.
- Cost-Integrationsmodus ist regressionsgesichert: `--stats cost --maintenance-source none` (OK), `--maintenance-source` ausserhalb `--stats cost` (Validierungsfehler) und `--stats cost --maintenance-source module` mit robustem Fallback ohne Companion-Binary.
- Modules-Suite prueft zusaetzlich den positiven Integrationspfad: Core-`--stats cost --maintenance-source module --json` liest `total_cost_cents` aus dem Companion-Contract (`maintenance_stats_v1`) ein.
- Der Smoke-Lauf baut Test-DBs mit auf und startet den Domain-Policy-Runner.
- Dedizierter Cars-CRUD-Smoke: `tests/smoke/smoke_cars_crud.sh`.
- Dedizierter Resolver-Matrix-Smoke: `tests/smoke/smoke_multi_car_context.sh`.
- Dedizierter Migrations-Smoke: `tests/smoke/smoke_migrations.sh` (aktuell: `--v4-to-v5`).
- Dedizierter Module-Contract-Smoke: `tests/smoke/smoke_modules.sh` (`--module-info` compact/pretty inkl. `capabilities`, `--migrate` inkl. idempotentem Re-Run, `--add maintenance`, `--list maintenance`, `--stats maintenance` Text/JSON/Pretty/Scope, Guardrails fuer ungueltige Stats-/JSON-Kombinationen, unknown-flag-Fehlerpfad).
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
