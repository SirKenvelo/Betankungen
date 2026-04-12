# CHANGELOG
**Stand:** 2026-04-12

Alle wichtigen Änderungen an diesem Projekt werden hier dokumentiert.

## [Unreleased]
### Zielversion
Aktive Entwicklungsbasis `1.4.0-dev` (`APP_VERSION=1.4.0-dev`)
Ziel: die aktive `1.4.0-dev`-Linie ueber gezielte Hardening- und
Datenanreicherungs-Bloecke stabilisieren und offene Contracts sauber
schliessen.

### Sprint / Commit References
- S40C1/2 - Ersten read-only Referenzscreen fuer `Betankungen --list fuelups --detail` geliefert (`units/u_painter.pas`, `units/u_view_fuelups.pas`, `units/u_fuelups.pas`, `tests/regression/run_receipt_link_contract_check.sh`, `tests/smoke/smoke_cli.sh`, `tests/smoke/smoke_multi_car_context.sh`, `docs/backlog/BL-0033-tui-presentation-and-view-layer-refresh/item.md`, `docs/backlog/BL-0033-tui-presentation-and-view-layer-refresh/tasks/TSK-0029-implement-fuelups-detail-reference-screen.md`, `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/README.md`, `docs/BENUTZERHANDBUCH.md`); Artefakte: `.artifacts/sprint_40_commit_1_von_2.md`, `.artifacts/sprint_40_commit_1_von_2.diff`; Basis-Commit: `e9dc1c0`. (2026-04-08)
- S39C1/2 - `P-050`-Reset-Guidance vom normalen Kurzdistanz-Fuelup entkoppelt und einen manuellen Reset nur noch ueber den expliziten Ausnahme-Opt-in `--missed-previous` erreichbar gemacht (`src/Betankungen.lpr`, `units/u_cli_types.pas`, `units/u_cli_parse.pas`, `units/u_cli_validate.pas`, `units/u_cli_help.pas`, `units/u_fuelups.pas`, `tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`, `tests/domain_policy/cases/t_p050__01__manual_gap_flag_yes.sh`, `tests/domain_policy/cases/t_p050__02__manual_gap_flag_no.sh`, `tests/domain_policy/cases/t_p051__01__no_auto_gap_flag_without_confirm.sh`, `tests/domain_policy/p050.md`, `tests/domain_policy/p051.md`, `tests/domain_policy/README.md`, `tests/smoke/smoke_multi_car_context.sh`, `docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/item.md`, `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/tasks/TSK-0028-decouple-p050-reset-guidance-from-normal-fuelup-flow.md`, `docs/issues/ISS-0010-p050-reset-prompt-misleading-for-normal-distances/issue.md`); Artefakte: `.artifacts/sprint_39_commit_1_von_2.md`, `.artifacts/sprint_39_commit_1_von_2.diff`; Basis-Commit: `8be52b1`. (2026-04-07)
- S38C1/2 - Sichtbaren Fahrzeugkontext, fruehe Receipt-Link-Guidance und lokale Receipt-Pfadnormalisierung im Fuelup-Add-Flow geliefert (`units/u_car_context.pas`, `units/u_fuelups.pas`, `units/u_cli_help.pas`, `docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/item.md`, `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/tasks/TSK-0027-surface-car-context-and-receipt-link-guidance.md`, `docs/issues/ISS-0009-fuelup-add-flow-guidance-gap/issue.md`, `tests/regression/run_receipt_link_contract_check.sh`, `tests/smoke/smoke_cli.sh`, `tests/smoke/smoke_multi_car_context.sh`, `tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`, `docs/CHANGELOG.md`); Artefakte: `.artifacts/sprint_38_commit_1_von_2.md`, `.artifacts/sprint_38_commit_1_von_2.diff`; Basis-Commit: `1e6ef9e`. (2026-04-03)
- S37C1/2 - Fuelup-Prompt, Help und Doku auf expliziten Gesamt-Odometer-Contract gezogen (`units/u_fuelups.pas`, `units/u_cli_help.pas`, `docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/item.md`, `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/tasks/TSK-0026-clarify-fuelup-odometer-guidance-and-contract.md`, `docs/issues/ISS-0008-fuelup-odometer-trip-semantics-gap/issue.md`, `tests/smoke/smoke_cli.sh`, `tests/smoke/smoke_multi_car_context.sh`); Artefakte: `.artifacts/sprint_37_commit_1_von_2.md`, `.artifacts/sprint_37_commit_1_von_2.diff`; Basis-Commit: `cdd0aeb`. (2026-04-03)
- S36C1/2 - Fuelup-Guidance- und Kilometerstands-Semantik fuer die naechste Core-UX-Stufe gerahmt (`docs/issues/ISS-0008-fuelup-odometer-trip-semantics-gap/issue.md`, `docs/issues/ISS-0009-fuelup-add-flow-guidance-gap/issue.md`, `docs/ADR/ADR-0014-fuelup-mileage-input-semantics.md`, `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/item.md`, `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/tasks/TSK-0026-clarify-fuelup-odometer-guidance-and-contract.md`, `docs/backlog/BL-0031-fuelup-input-semantics-and-guidance-hardening/tasks/TSK-0027-surface-car-context-and-receipt-link-guidance.md`, `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `docs/ADR/README.md`); Artefakte: `.artifacts/sprint_36_commit_1_von_2.md`, `.artifacts/sprint_36_commit_1_von_2.diff`; Basis-Commit: `d243df3`. (2026-04-02)
- S35C1/2 - Minimales Charging-Event- und Storage-Modell fuer `betankungen-ev` definiert (`docs/backlog/BL-0030-ev-companion-feasibility-spike/item.md`, `docs/backlog/BL-0030-ev-companion-feasibility-spike/tasks/TSK-0025-evaluate-charging-event-minimum-and-storage-boundary.md`, `docs/MODULES_ARCHITECTURE.md`, `docs/BACKLOG.md`, `docs/STATUS.md`); Artefakte: `.artifacts/sprint_35_commit_1_von_2.md`, `.artifacts/sprint_35_commit_1_von_2.diff`; Basis-Commit: `b613acd`. (2026-04-01)
- General-2026-04-01-ev-scope-baseline - EV-Discovery-Rahmen fuer `betankungen-ev` mit Scope-, Boundary- und CLI-Contract-Baseline definiert (`docs/backlog/BL-0030-ev-companion-feasibility-spike/item.md`, `docs/backlog/BL-0030-ev-companion-feasibility-spike/tasks/TSK-0024-define-ev-module-scope-and-contract.md`, `docs/MODULES_ARCHITECTURE.md`, `docs/BACKLOG.md`, `docs/STATUS.md`); Basis-Commit: `0d5cac6`. (2026-04-01)
- S34C1/2 - Paket C als strategischen EV-Discovery-Pfad verankert (`docs/ADR/ADR-0008-ev-charging.md`, `docs/ADR/README.md`, `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/backlog/BL-0030-ev-companion-feasibility-spike/item.md`, `docs/backlog/BL-0030-ev-companion-feasibility-spike/tasks/TSK-0024-define-ev-module-scope-and-contract.md`, `docs/backlog/BL-0030-ev-companion-feasibility-spike/tasks/TSK-0025-evaluate-charging-event-minimum-and-storage-boundary.md`); Artefakte: `.artifacts/sprint_34_commit_1_von_2.md`, `.artifacts/sprint_34_commit_1_von_2.diff`; Basis-Commit: `23cdef6`. (2026-03-31)
- S33C1/2 - Stations-Stammdaten um Geodaten/Plus-Code-Write-Path, Schema v6, Migrations-Smokes und Contract-Regression erweitert (`units/u_stations.pas`, `units/u_db_init.pas`, `units/u_db_seed.pas`, `tests/smoke/smoke_migrations.sh`, `tests/regression/run_station_geodata_contract_check.sh`, `tests/domain_policy/p080.md`, `tests/domain_policy/README.md`, `docs/backlog/BL-0019-station-geodata-plus-codes/item.md`, `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `Makefile`); Artefakte: `.artifacts/sprint_33_commit_1_von_2.md`, `.artifacts/sprint_33_commit_1_von_2.diff`; Basis-Commit: `2064fbd`. (2026-03-31)
- S32C1/2 - Odometer-Validierungscontract fuer negative Eingaben gehaertet (`units/u_fuelups.pas`, `tests/domain_policy/cases/t_p010__02__negative_odometer_input_contract.sh`, `tests/domain_policy/p010.md`, `tests/domain_policy/README.md`, `tests/smoke/smoke_multi_car_context.sh`, `docs/backlog/BL-0029-odometer-validation-contract-hardening/item.md`, `docs/backlog/BL-0029-odometer-validation-contract-hardening/tasks/TSK-0001-unify-odometer-hard-error-validation.md`, `docs/issues/ISS-0001-negative-odometer-validation/issue.md`, `docs/BACKLOG.md`, `docs/BENUTZERHANDBUCH.md`); Artefakte: `.artifacts/sprint_32_commit_1_von_2.md`, `.artifacts/sprint_32_commit_1_von_2.diff`; Basis-Commit: `193a7e0`. (2026-03-31)
- S31C1/2 - `BL-0011` repo-seitig auf finalen Externalisierungs-/Handover-Closeout gezogen (`docs/backlog/BL-0011-projekt-scaffolder-repo-bootstrap/item.md`, `docs/BL-0011_SCOPE_DECISION_1_4_0.md`, `docs/BACKLOG.md`, `docs/STATUS.md`); Artefakte: `.artifacts/sprint_31_commit_1_von_2.md`, `.artifacts/sprint_31_commit_1_von_2.diff`; Basis-Commit: `7a5c038`. (2026-03-30)
- S30C1/4 - `1.4.0-dev` in separatem Aktivierungs-Commit gestartet (`src/Betankungen.lpr`, `README.md`, `docs/README.md`, `docs/README_EN.md`, `CONTRIBUTING.md`, `docs/STATUS.md`, `docs/CHANGELOG.md`); Artefakte: `.artifacts/sprint_30_commit_1_von_4.md`, `.artifacts/sprint_30_commit_1_von_4.diff`; Basis-Commit: `5a2d69b`. (2026-03-30)
- S30C2/4 - `BL-0016` als Community-Standards-Baseline geliefert (`CODE_OF_CONDUCT.md`, `SECURITY.md`, `.github/ISSUE_TEMPLATE/bug_report.md`, `.github/ISSUE_TEMPLATE/feature_request.md`, `.github/pull_request_template.md`, `docs/backlog/BL-0016-community-standards-baseline/item.md`, `docs/BACKLOG.md`); Artefakte: `.artifacts/sprint_30_commit_2_von_4.md`, `.artifacts/sprint_30_commit_2_von_4.diff`; Basis-Commit: `72e0d06`. (2026-03-30)
- S30C3/4 - Legacy-Task-Index auf Markdown migriert und `projtrack_lint` fuer `docs/tasks/` auf echte `TSK-*.md` begrenzt (`docs/tasks/README.md`, `scripts/projtrack_lint.sh`, `docs/CHANGELOG.md`); Artefakte: `.artifacts/sprint_30_commit_3_von_4.md`, `.artifacts/sprint_30_commit_3_von_4.diff`; Basis-Commit: `cc3d8f6`. (2026-03-30)
- S29C1/2 - Formales Startgate vor `1.4.0-dev` definiert (`docs/DEV_START_GATE_1_4_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md`, `README.md`); Artefakte: `.artifacts/sprint_29_commit_1_von_2.md`, `.artifacts/sprint_29_commit_1_von_2.diff`; Basis-Commit: `f97a591`. (2026-03-29)
- S28C1/2 - `btkgit`-Wrapper auf klarere Failure-UX und konservativeres Cleanup gehaertet (`btkgit`, `scripts/btkgit.sh`, `tests/smoke/smoke_cli.sh`); Artefakte: `.artifacts/sprint_28_commit_1_von_2.md`, `.artifacts/sprint_28_commit_1_von_2.diff`; Basis-Commit: `ebf8626`. (2026-03-29)
- S27C1/2 - Wiki-Entry-Layer beruhigt und klarer auf Source-of-Truth-Grenzen ausgerichtet (`docs/wiki/Home.md`, `docs/wiki/README.md`, `docs/wiki/Cookie-Note.md`); Artefakte: `.artifacts/sprint_27_commit_1_von_2.md`, `.artifacts/sprint_27_commit_1_von_2.diff`; Basis-Commit: `fc283cc`. (2026-03-29)
- S27C2/2 - Oeffentliche Repo-Einstiege auf publizierten Wiki-Entry und versionierte Wiki-Quelle ausgerichtet (`README.md`, `CONTRIBUTING.md`, `docs/README_EN.md`); Artefakte: `.artifacts/sprint_27_commit_2_von_2.md`, `.artifacts/sprint_27_commit_2_von_2.diff`; Basis-Commit: `cc7d107`. (2026-03-29)
- S26C1/2 - Oeffentliche Einstiegsdoku auf den bewussten Transition-Hold nach `1.3.0` synchronisiert (`README.md`, `CONTRIBUTING.md`, `docs/README_EN.md`); Artefakte: `.artifacts/sprint_26_commit_1_von_2.md`, `.artifacts/sprint_26_commit_1_von_2.diff`; Basis-Commit: `5e10687`. (2026-03-29)
- S26C2/2 - Deutsche Einstiegs-/Statusdoku auf denselben Hold-Narrativ und den bereinigten `1.4.0`-Planungsstand gezogen (`docs/README.md`, `docs/STATUS.md`); Artefakte: `.artifacts/sprint_26_commit_2_von_2.md`, `.artifacts/sprint_26_commit_2_von_2.diff`; Basis-Commit: `bab3e9e`. (2026-03-29)
- S1C1/4 - Multi-Car CSV-Stats feldbasiert (Quick-Win auf aktuellem Aggregat-CSV-Contract); Artefakte: `sprint_1_commit_1_von_4.md`, `sprint_1_commit_1_von_4.diff`; Basis-Commit: `11127c6`. (2026-03-01)
- S1C2/4 - cars_crud: CSV-Stats Scope feldbasiert (Header + Token-Checks statt Zeilenregex); Artefakte: `sprint_1_commit_2_von_4.md`, `sprint_1_commit_2_von_4.diff`; Basis-Commit: `da4e74c`. (2026-03-02)
- S1C3/4 - Audit/Polish: smoke_clean_home-Check, CSV-Helper `csv_row_count`, knowledge_archive-Regeln; Artefakte: `sprint_1_commit_3_von_4.md`, `sprint_1_commit_3_von_4.diff`; Basis-Commit: `b4273c4`. (2026-03-04)
- S2C1/4 - Export-Contract v1-Baseline in `docs/EXPORT_CONTRACT.md`; Artefakte: `sprint_2_commit_1_von_4.md`, `sprint_2_commit_1_von_4.diff`; Basis-Commit: `4feba89`. (2026-03-04)
- S2C2/4 - JSON-Export-Meta (contract_version/generated_at/app_version) in Stats-JSON und Smoke-Guardrails fuer Presence-Checks; Artefakte: `sprint_2_commit_2_von_4.md`, `sprint_2_commit_2_von_4.diff`; Basis-Commit: `701b34f`. (2026-03-04)
- S2C3/4 - CSV-Contract-Versionierung in Stats-CSV (erste Spalte `contract_version`) inkl. Smoke-/Policy-Testsynchronisierung; Artefakte: `sprint_2_commit_3_von_4.md`, `sprint_2_commit_3_von_4.diff`; Basis-Commit: `b08a4a6`. (2026-03-04)
- S2C4/4 - Doku-Schaerfung und Sprint-2-Finalisierung (CSV-yearly-Grenze, Status/Hashes, Volltest-Verifikation); Artefakte: `sprint_2_commit_4_von_4.md`, `sprint_2_commit_4_von_4.diff`; Basis-Commit: `94f502c`. (2026-03-04)
- S3C1/3 - Cars-Schema v5-Vorbereitung (vin/reg-doc Felder) und ALTER-basierte Migration fuer Bestands-DBs; Artefakte: `sprint_3_commit_1_von_3.md`, `sprint_3_commit_1_von_3.diff`; Basis-Commit: `f25c3ca`. (2026-03-06)
- S3C2/3 - Migration-Smoke-Framework mit Flag-Strategie (`--v4-to-v5`) und CLI-Integration (`--migrations`); Artefakte: `sprint_3_commit_2_von_3.md`, `sprint_3_commit_2_von_3.diff`; Basis-Commit: `ff5fb27`. (2026-03-06)
- S3C3/3 - VIN-Policy-/UX-Prep dokumentiert (optionaler VIN-Ansatz, Normalisierung, Policy-light, Dokument-Referenzen) und Sprint-3-Doku finalisiert; Artefakte: `sprint_3_commit_3_von_3.md`, `sprint_3_commit_3_von_3.diff`; Basis-Commit: `c518fda`. (2026-03-06)
- S4C1/3 - i18n-Policy-/Architektur-Basis vor Runtime-Wiring dokumentiert (inkl. Sprint-4-Roadmap und Leitplanken in Einstieg/Prinzipien); Artefakte: `sprint_4_commit_1_von_3.md`, `sprint_4_commit_1_von_3.diff`; Basis-Commit: `dd25860`. (2026-03-07)
- S4C2/3 - technisches i18n-Skeleton mit `u_i18n` (`TMsgId`, `Tr()`) und Config-Flow-Verankerung fuer `language=de|en|pl`; Artefakte: `sprint_4_commit_2_von_3.md`, `sprint_4_commit_2_von_3.diff`; Basis-Commit: `c1a6348`. (2026-03-07)
- S4C3/3 - erster kontrollierter Runtime-Mini-Rollout mit wenigen Meta-Texten ueber `Tr()` (ohne breite Help-/Fehlertext-Migration); Artefakte: `.artifacts/sprint_4_commit_3_von_3.md`, `.artifacts/sprint_4_commit_3_von_3.diff`; Basis-Commit: `87e5f6e`. (2026-03-07)
- S5C1/1 - Domain-Policy-CSV-Assertions final auf feldbasiertes Token-Parsing umgestellt (`P-060/01`, `P-060/02`); Artefakte: `.artifacts/sprint_5_commit_1_von_1.md`, `.artifacts/sprint_5_commit_1_von_1.diff`; Basis-Commit: `47fbc0a`. (2026-03-07)
- S6C1/4 - ADR-0005 von `proposed` auf `accepted` finalisiert und Scope-Grenzen fuer Core-vs-Module verbindlich geschaerft; Artefakte: `.artifacts/sprint_6_commit_1_von_4.md`, `.artifacts/sprint_6_commit_1_von_4.diff`; Basis-Commit: `2886ec5`. (2026-03-10)
- S6C2/4 - Minimaler Modul-Handshake eingefuehrt: neue Contract-Unit `u_module_info`, Companion-Skeleton `betankungen-maintenance` mit `--module-info` (JSON) und Core-Version auf `0.9.0-dev` synchronisiert; Artefakte: `.artifacts/sprint_6_commit_2_von_4.md`, `.artifacts/sprint_6_commit_2_von_4.diff`; Basis-Commit: `f81757f`. (2026-03-10)
- S6C3/4 - Smoke-Absicherung fuer den Modul-Handshake erweitert: dedizierte Modules-Suite (`smoke_modules`) samt Wrapper und Integration in `smoke_cli`/`smoke_clean_home` via `--modules`; Artefakte: `.artifacts/sprint_6_commit_3_von_4.md`, `.artifacts/sprint_6_commit_3_von_4.diff`; Basis-Commit: `f91a650`. (2026-03-10)
- S6C4/4 - Modul-Contract auf operative v1-Baseline finalisiert (`docs/MODULES_ARCHITECTURE.md`) und Entry-/Status-Doku auf den abgeschlossenen Sprint-6-Stand synchronisiert; Artefakte: `.artifacts/sprint_6_commit_4_von_4.md`, `.artifacts/sprint_6_commit_4_von_4.diff`; Basis-Commit: `c15482b`. (2026-03-10)
- S7C1/4 - CLI-Wiring fuer `--stats fleet` eingefuehrt (Parse/Validate/Dispatch + MVP-Textausgabe), inkl. Smoke- und Doku-Sync; Artefakte: `.artifacts/sprint_7_commit_1_von_4.md`, `.artifacts/sprint_7_commit_1_von_4.diff`; Basis-Commit: `3ee7355`. (2026-03-10)
- S7C2/4 - Fleet-JSON-MVP fuer `--stats fleet --json [--pretty]` eingefuehrt (Core-Renderer + Validate/Dispatch), inkl. Smoke-/Policy-Checks und Doku-Sync; Artefakte: `.artifacts/sprint_7_commit_2_von_4.md`, `.artifacts/sprint_7_commit_2_von_4.diff`; Basis-Commit: `bcaa02e`. (2026-03-10)
- S7C3/4 - Fleet-Guardrails gehaertet und regressionsgesichert (Domain-Policy + Smoke) fuer ungueltige Fleet-Optionen (`--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`); Artefakte: `.artifacts/sprint_7_commit_3_von_4.md`, `.artifacts/sprint_7_commit_3_von_4.diff`; Basis-Commit: `4a1c4e7`. (2026-03-10)
- S7C4/4 - Sprint-7-Finalisierung mit DoD-Check, finalem Verifikationslauf und Abschluss-Sync der Sprint-/Status-/Entry-Doku; Artefakte: `.artifacts/sprint_7_commit_4_von_4.md`, `.artifacts/sprint_7_commit_4_von_4.diff`; Basis-Commit: `aa9281e`. (2026-03-10)
- S8C1/4 - Cost-MVP-Basis gestartet: `--stats cost` als neuer Stats-Target-Pfad mit Core-Textausgabe (fuel-basiert, maintenance placeholder), inkl. Validate-/Smoke-/Doku-Sync; Artefakte: `.artifacts/sprint_8_commit_1_von_4.md`, `.artifacts/sprint_8_commit_1_von_4.diff`; Basis-Commit: `f9e0cdb`. (2026-03-11)
- S8C2/4 - Cost-JSON-MVP fuer `--stats cost --json [--pretty]` eingefuehrt (Validate/Help/Dispatch + Core-Renderer), inkl. Export-Contract-Update und Domain-Policy-/Smoke-Sync; Artefakte: `.artifacts/sprint_8_commit_2_von_4.md`, `.artifacts/sprint_8_commit_2_von_4.diff`; Basis-Commit: `379343b`. (2026-03-11)
- S8C3/4 - Cost-Guardrails regressionsgesichert: Domain-Policy-/Smoke-Abdeckung fuer ungueltige Cost-Optionen (`--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`, `--car-id`) erweitert; Artefakte: `.artifacts/sprint_8_commit_3_von_4.md`, `.artifacts/sprint_8_commit_3_von_4.diff`; Basis-Commit: `e7c1f6f`. (2026-03-11)
- S8C4/4 - Sprint-8-Finalisierung mit DoD-Check, finalem Verifikationslauf und Abschluss-Sync der Sprint-/Status-/Entry-Doku; Artefakte: `.artifacts/sprint_8_commit_4_von_4.md`, `.artifacts/sprint_8_commit_4_von_4.diff`; Basis-Commit: `680e962`. (2026-03-11)
- S9C1/4 - CLI-Scope-Enablement fuer Cost (`--from/--to`, `--car-id`) in Validate/Help/Dispatch aktiviert, Tests und Doku synchronisiert; Artefakte: `.artifacts/sprint_9_commit_1_von_4.md`, `.artifacts/sprint_9_commit_1_von_4.diff`; Basis-Commit: `628cd71`. (2026-03-13)
- S9C2/4 - Cost-Collector und Textausgabe auf aktiven Period-/Car-Scope erweitert (inkl. Smoke-Regression auf Filterwirkung); Artefakte: `.artifacts/sprint_9_commit_2_von_4.md`, `.artifacts/sprint_9_commit_2_von_4.diff`; Basis-Commit: `b757d3d`. (2026-03-13)
- S9C3/4 - Cost-JSON-Contract um Scope-/Period-Felder erweitert und Contract-/Smoke-Checks synchronisiert; Artefakte: `.artifacts/sprint_9_commit_3_von_4.md`, `.artifacts/sprint_9_commit_3_von_4.diff`; Basis-Commit: `fcb4ab5`. (2026-03-13)
- S9C4/4 - Cost-Scope-Guardrails via Domain-Policy `P-061` erweitert (Car-/Period-Isolation fuer `--stats cost`) und Sprint-9-Doku finalisiert; Artefakte: `.artifacts/sprint_9_commit_4_von_4.md`, `.artifacts/sprint_9_commit_4_von_4.diff`; Basis-Commit: `297d588`. (2026-03-13)
- S10C1/4 - Modul-Schema + idempotente Migration fuer `betankungen-maintenance` eingefuehrt (`--migrate [--db <path>]`, `module_meta`, `maintenance_events`) inkl. Module-Smoke-Erweiterung; Artefakte: `.artifacts/sprint_10_commit_1_von_4.md`, `.artifacts/sprint_10_commit_1_von_4.diff`; Basis-Commit: `278408a`. (2026-03-14)
- S10C2/4 - Companion-CRUD-Basis fuer Maintenance eingefuehrt (`--add maintenance`, `--list maintenance` inkl. `--car-id`-Scope), Module-Smoke auf Add/List-Contract erweitert; Artefakte: `.artifacts/sprint_10_commit_2_von_4.md`, `.artifacts/sprint_10_commit_2_von_4.diff`; Basis-Commit: `aad05f8`. (2026-03-14)
- S10C3/4 - Companion-Stats-Basis fuer Maintenance eingefuehrt (`--stats maintenance` Text + JSON/Pretty inkl. Scope via `--car-id`), inklusive Aggregation in `u_maintenance_db`, Module-Smoke-Absicherung und Archive-Snapshot des vorherigen CLI-Flows; Artefakte: `.artifacts/sprint_10_commit_3_von_4.md`, `.artifacts/sprint_10_commit_3_von_4.diff`; Basis-Commit: `25b6080`. (2026-03-14)
- S10C4/4 - Modul-Qualitaetsgate finalisiert: Module-Smoke um negative Guardrail-Pfade erweitert und Contract-Doku fuer `maintenance_stats_v1` abgeschlossen; Artefakte: `.artifacts/sprint_10_commit_4_von_4.md`, `.artifacts/sprint_10_commit_4_von_4.diff`; Basis-Commit: `f15fcf3`. (2026-03-14)
- S11C1/4 - Expliziter Integrationsmodus im Cost-Pfad (`--maintenance-source none|module`) inkl. Validate-Policy, Cost-Text/JSON-Contract-Feldern und regressionssicherer Smoke-/Domain-Policy-Abdeckung; Artefakte: `.artifacts/sprint_11_commit_1_von_4.md`, `.artifacts/sprint_11_commit_1_von_4.diff`; Basis-Commit: `47dcee8`. (2026-03-14)
- S11C2/4 - Cost-Integration fuel+maintenance aktiviert: `--maintenance-source module` liest Companion-Stats (`maintenance_stats_v1`) ein, aggregiert Maintenance-Kosten in Cost-Text/JSON und nutzt bei Quellproblemen einen expliziten Fallback mit `maintenance_source_note`; Artefakte: `.artifacts/sprint_11_commit_2_von_4.md`, `.artifacts/sprint_11_commit_2_von_4.diff`; Basis-Commit: `274111c`. (2026-03-14)
- S11C3/4 - Verify-/CI-Haertung fuer Cost-Integration: neuer Regression-Gate `run_cost_integration_modes_check.sh` prueft `--maintenance-source none|module` inkl. aktivem Modulpfad und Fallback-Szenarien; eingebunden in `make verify` und CI-Job `verify`; Artefakte: `.artifacts/sprint_11_commit_3_von_4.md`, `.artifacts/sprint_11_commit_3_von_4.diff`; Basis-Commit: `015ba1b`. (2026-03-14)
- S11C4/4 - 0.9.0-Readiness-Paket finalisiert: Scope-Freeze dokumentiert, lokaler Preflight `scripts/release_preflight.sh` + `make release-preflight` eingefuehrt und Release-Checkliste unter `docs/RELEASE_0_9_0_PREFLIGHT.md` verankert; Artefakte: `.artifacts/sprint_11_commit_4_von_4.md`, `.artifacts/sprint_11_commit_4_von_4.diff`; Basis-Commit: `cbfa3e8`. (2026-03-14)
- S13C1/4 - Contract-Hardening-Checklist aus `POL-002` fuer 1.0.0 abgeleitet und gegen bestehende JSON/CSV/CLI-Nachweise gemappt; Artefakte: `.artifacts/sprint_13_commit_1_von_4.md`, `.artifacts/sprint_13_commit_1_von_4.diff`; Basis-Commit: `cf802fb`. (2026-03-15)
- S13C2/4 - Zentrales CSV-Contract-Regression-Gate eingefuehrt (Header-/Versionierungs-/Guardrail-Checks) und in lokale/CI-Verify-Kette verdrahtet; Artefakte: `.artifacts/sprint_13_commit_2_von_4.md`, `.artifacts/sprint_13_commit_2_von_4.diff`; Basis-Commit: `1608656`. (2026-03-15)
- S13C3/4 - Contract-Evolution-/Deprecation-Sichtbarkeit gemaess `POL-002` finalisiert (expliziter Deprecation-Status in Export-Contract, Module-/Entry-Doku-Sync, Gate-2-Restscope auf Abschlusslauf reduziert); Artefakte: `.artifacts/sprint_13_commit_3_von_4.md`, `.artifacts/sprint_13_commit_3_von_4.diff`; Basis-Commit: `2f48bf6`. (2026-03-15)
- S13C4/4 - Gate-2-Abschlusslauf dokumentiert und Contract-Hardening auf `done` gesetzt (Verify-Nachweis, Roadmap-/Status-/Sprint-Abschlusssync); Artefakte: `.artifacts/sprint_13_commit_4_von_4.md`, `.artifacts/sprint_13_commit_4_von_4.diff`; Basis-Commit: `43d5e32`. (2026-03-15)
- S15C1/4 - 1.0.0-Preflight um Gate-Status-/Doku-Guardrails erweitert (`--skip-doc-gates`, Checks fuer `CONTRACT_HARDENING=done` sowie Gate-2-Abschluss in `ROADMAP_1_0_0.md`/`STATUS.md`); Artefakte: `.artifacts/sprint_15_commit_1_von_4.md`, `.artifacts/sprint_15_commit_1_von_4.diff`; Basis-Commit: `d8b618e`. (2026-03-15)
- S15C2/4 - RC-Checkliste/Scope-Freeze auf aktuellen Gate-Stand synchronisiert (Gate 1/2/3 abgeschlossen, Gate 4 aktiv; Governance-Text fuer Solo-Maintainer ohne verpflichtende Approvals aktualisiert); Artefakte: `.artifacts/sprint_15_commit_2_von_4.md`, `.artifacts/sprint_15_commit_2_von_4.diff`; Basis-Commit: `e52ba86`. (2026-03-16)
- S15C3/4 - RC-Abschlusslauf dokumentiert: lokaler Voll-Preflight (`make release-preflight-1-0-0`) inklusive `make verify` gruen sowie CI-Referenz auf `main` (`CI`-Run `23153384396`, `success`, Commit `a59cb6e`); Artefakte: `.artifacts/sprint_15_commit_3_von_4.md`, `.artifacts/sprint_15_commit_3_von_4.diff`; Basis-Commit: `8c993b5`. (2026-03-16)
- S15C4/4 - Gate-4-Abschlussnarrativ finalisiert: Gate 4 auf `abgeschlossen` gesetzt und Handover auf Gate 5 (finaler Release-Umschalt-Commit + finaler Doku-Sync + Release-/Backup-Ausfuehrung nach Freigabe) dokumentiert; Artefakte: `.artifacts/sprint_15_commit_4_von_4.md`, `.artifacts/sprint_15_commit_4_von_4.diff`; Basis-Commit: `52b5823`. (2026-03-16)
- S16C2/4 - Gate-2-Scope-Freeze fuer die 1.1.0-Linie im Tracker festgezogen (`BL-0014` + `TSK-0006`, `BL-0015` + `TSK-0007`) und Roadmap-/Status-/Sprint-/Entry-Doku synchronisiert; Artefakte: `.artifacts/sprint_16_commit_2_von_4.md`, `.artifacts/sprint_16_commit_2_von_4.diff`; Basis-Commit: `feab063`. (2026-03-16)
- S16C3/4 - Verify-/Contract-DoD fuer Gate 3 der 1.1.0-Linie konkretisiert (`docs/CONTRACT_HARDENING_1_1_0.md`, `docs/RELEASE_1_1_0_PREFLIGHT.md`) und Entry-/Status-/Roadmap-/Sprint-Doku synchronisiert; Artefakte: `.artifacts/sprint_16_commit_3_von_4.md`, `.artifacts/sprint_16_commit_3_von_4.diff`; Basis-Commit: `f796179`. (2026-03-17)
- S16C4/4 - Sprint-16-Kickoff als Gate-3-Handover abgeschlossen und den optionalen Community-Standards-Follow-up als `BL-0016` im kanonischen Tracker erfasst; Artefakte: `.artifacts/sprint_16_commit_4_von_4.md`, `.artifacts/sprint_16_commit_4_von_4.diff`; Basis-Commit: `f3aa61b`. (2026-03-17)
- S17C1/4 - Manifest-v1-Contract und Dry-Run-Fixtures fuer Export-Pakete geliefert (optionaler Fixture-Runner inkl. Make-Target), `TSK-0006`/`BL-0014` auf done gesetzt und Gate-3-Matrix synchronisiert; Artefakte: `.artifacts/sprint_17_commit_1_von_4.md`, `.artifacts/sprint_17_commit_1_von_4.diff`; Basis-Commit: `2d3ba79`. (2026-03-17)
- S17C2/4 - Operatives 1.1.0-Preflight-Skript mit Scope-/Tracker-/Contract-Doku-Gates eingefuehrt und via Make-Target verdrahtet; zusaetzlich neue Vorschlags-Backlogs `BL-0017` bis `BL-0020` aufgenommen; Artefakte: `.artifacts/sprint_17_commit_2_von_4.md`, `.artifacts/sprint_17_commit_2_von_4.diff`; Basis-Commit: `fb7b351`. (2026-03-17)
- S17C3/4 - Gate-3-Closeout-Nachweise verdichtet (`Policy-Fit=done`, lokaler Preflight-Nachweis + CI-Referenz) und RC-Handover fuer Gate 4 im Preflight-Dokument konkretisiert; Artefakte: `.artifacts/sprint_17_commit_3_von_4.md`, `.artifacts/sprint_17_commit_3_von_4.diff`; Basis-Commit: `5425ccf`. (2026-03-17)
- S17C4/4 - Finalen Gate-3-Abschlusslauf ausgefuehrt (`make release-preflight-1-1-0`) und Gate-Status auf Gate 3 `abgeschlossen` / Gate 4 `aktiv` umgestellt; Artefakte: `.artifacts/sprint_17_commit_4_von_4.md`, `.artifacts/sprint_17_commit_4_von_4.diff`; Basis-Commit: `980fc41`. (2026-03-17)
- S18C1/4 - Gate-4-Kickoff auf Doku-Ebene verankert und neuen nicht-blockierenden Tracker-Eintrag `BL-0021` fuer externe Belegfoto-Links erfasst; Artefakte: `.artifacts/sprint_18_commit_1_von_4.md`, `.artifacts/sprint_18_commit_1_von_4.diff`; Basis-Commit: `2d202a4`. (2026-03-18)
- S18C2/4 - RC-Checkliste/Feature-Freeze-Snapshot fuer Gate 4 synchronisiert und den Fokus auf den RC-Abschlusslauf `S18C3/4` nachgezogen; Artefakte: `.artifacts/sprint_18_commit_2_von_4.md`, `.artifacts/sprint_18_commit_2_von_4.diff`; Basis-Commit: `ff9dcf6`. (2026-03-18)
- S18C3/4 - RC-Abschlusslauf fuer Gate 4 dokumentiert (lokaler Voll-Preflight `make release-preflight-1-1-0` + aktualisierte CI-Referenz auf `main`), inkl. Doku-Sync auf den verbleibenden Gate-4-Closeout `S18C4/4`; Artefakte: `.artifacts/sprint_18_commit_3_von_4.md`, `.artifacts/sprint_18_commit_3_von_4.diff`; Basis-Commit: `e14ee87`. (2026-03-18)
- S18C4/4 - Gate 4 fuer die 1.1.0-Linie formal abgeschlossen und den Handover auf Gate 5 finalisiert (Roadmap-/Status-/Preflight-/Entry-/Sprint-Sync); Artefakte: `.artifacts/sprint_18_commit_4_von_4.md`, `.artifacts/sprint_18_commit_4_von_4.diff`; Basis-Commit: `6d08aa3`. (2026-03-18)
- S19C1/4 - Gate-5-Kickoff dokumentiert und BL-Triage-Lanes (`release-blocking`/`planned`/`exploratory`) in Policy, Backlog-Index und offenen BL-Items verankert; Artefakte: `.artifacts/sprint_19_commit_1_von_4.md`, `.artifacts/sprint_19_commit_1_von_4.diff`; Basis-Commit: `12d1cd7`. (2026-03-18)
- S19C2/4 - Gate-5-Checklisten-/Scope-Snapshot synchronisiert (inkl. aktueller CI-Referenz auf `main`) und Doku-Fokus auf den finalen Release-Umschalt-Commit `S19C3/4` gesetzt; Artefakte: `.artifacts/sprint_19_commit_2_von_4.md`, `.artifacts/sprint_19_commit_2_von_4.diff`; Basis-Commit: `87b18fb`. (2026-03-18)
- S19C3/4 - Gate-5-Release-Umschaltpaket vorbereitet (ohne vorgezogenen Versionswechsel) und Doku-Fokus auf den finalen Abschlussblock `S19C4/4` gesetzt; Artefakte: `.artifacts/sprint_19_commit_3_von_4.md`, `.artifacts/sprint_19_commit_3_von_4.diff`; Basis-Commit: `99fc714`. (2026-03-18)
- S19C4/4 - Finalen 1.1.0-Release ausgefuehrt (`APP_VERSION=1.1.0`), Gate-5-Closeout in Roadmap-/Status-/Entry-/Preflight-/Sprint-Doku finalisiert und Release-/Backup-Ausfuehrung dokumentiert; Artefakte: `.artifacts/sprint_19_commit_4_von_4.md`, `.artifacts/sprint_19_commit_4_von_4.diff`; Basis-Commit: `cf74b1c`. (2026-03-18)
- S23C1/1 - Semantische Entflechtung von `BL-0011` umgesetzt: Odometer-Validierung aus der Scaffolder-Kette geloest und als eigener Hardening-Block `BL-0029` mit `TSK-0001`/`ISS-0001` neu verankert; Artefakte: `.artifacts/sprint_23_commit_1_von_1.md`, `.artifacts/sprint_23_commit_1_von_1.diff`; Basis-Commit: `60e30f6`. (2026-03-28)
- S24C1/1 - `1.4.0`-Repo-Scope formal festgezogen: `BL-0011` aus dem Betankungen-Implementierungsscope herausgeloest, als externes Research-/Handover-Thema dokumentiert und die betroffenen Planungsquellen auf `BL-0016` als verbleibenden In-Repo-Scope synchronisiert; Artefakte: `.artifacts/sprint_24_commit_1_von_1.md`, `.artifacts/sprint_24_commit_1_von_1.diff`; Basis-Commit: `a8af75d`. (2026-03-28)
- S25C1/2 - Tracker-Endzustand fuer neue Arbeit definiert: Policy, Backlog-Index, ADR-Index und Status auf kanonische vs. Legacy-Pfade synchronisiert; Artefakte: `.artifacts/sprint_25_commit_1_von_2.md`, `.artifacts/sprint_25_commit_1_von_2.diff`; Basis-Commit: `0968b70`. (2026-03-29)
- S25C2/2 - Legacy-Task-Navigation explizit dokumentiert: Issue-Hinweise fuer neue Folge-Tasks im kanonischen Backlog-Pfad plus Legacy-Notiz im `docs/tasks/`-Ordner; Artefakte: `.artifacts/sprint_25_commit_2_von_2.md`, `.artifacts/sprint_25_commit_2_von_2.diff`; Basis-Commit: `25df1d6`. (2026-03-29)

### Changed
- [General] Docs/Planning: `BL-0036` ist jetzt von `proposed` auf
  `approved` gezogen und in drei nicht ueberlappende Folge-Tasks
  geschnitten. `TSK-0032` rahmt den kompakten Contributor-Quickstart mit
  erster PR-Checkliste, `TSK-0033` staerkt die englischen Entry-Signale fuer
  internationale Erstbesucher, und `TSK-0034` beruhigt den Handoff zwischen
  README, Wiki und `CONTRIBUTING.md`. `docs/BACKLOG.md`, `docs/STATUS.md`
  und `docs/SPRINTS.md` fuehren denselben Planungsstand; als naechster
  kleinster Umsetzungsblock ist `TSK-0032` empfohlen. Es wurde bewusst keine
  Runtime-, CLI- oder direkte Entry-Layer-Implementierung eingefuehrt.
  (2026-04-12)
- [General] Docs/Release: Der sichtbare GitHub-Release-Handoff fuer die
  stabile Linie `1.3.0` ist jetzt veroeffentlicht und im Entry-Layer
  verlinkt. `README.md` und `docs/README_EN.md` fuehren Erstbesucher direkt
  zur Release-Seite, die `1.3.0`-Release-Notes benennen die aktuelle
  Source-Build-Erwartung ruhig und explizit, und `ISS-0012` ist damit auf
  `resolved` gezogen. `docs/STATUS.md` und `docs/SPRINTS.md` fuehren
  denselben Closeout; es wurde weder eine neue Version noch ein neuer
  Runtime- oder Build-Slice eingefuehrt. (2026-04-12)
- [General] Docs/Prompts: Die Prompt-Ablage fuer Leitstand-, Audit- und
  Folge-Prompts wird jetzt konsequent ausserhalb des Repos unter
  `/home/christof/Projekte/Audit/Betankungen/prompts/` gefuehrt. Der
  repo-lokale Restordner `prompts/` wurde entfernt, `TSK-0030` verweist fuer
  den Public-Repo-Entry-Audit jetzt auf die Vorlage
  `templates/TEMPLATE_public-repo-entry-audit_prompt.md`, und unter
  `general/offen/` liegt der neue Folge-Prompt
  `2026-04-12_general_public-release-handoff_prompt.md`. Die externe
  Prompt-README fuehrt den bereinigten Bestand; eine Produkt- oder
  Runtime-Aenderung wurde nicht eingefuehrt. (2026-04-12)
- [General] Docs/Entry: `README.md` fuehrt den oeffentlichen Repo-Einstieg
  jetzt mit knapper Produktbeschreibung, Hauptanwendungsfaellen, sichtbarem
  Quick Start und fruehem Verweis auf den publizierten GitHub-Wiki-Pfad
  (`Getting Started`, `CLI Quick Reference`). `docs/README_EN.md` fuehrt
  denselben Entry-Layer-Stand fuer englischsprachige Erstbesucher weiter,
  waehrend `ISS-0011` damit auf `resolved` gezogen ist. Status-, Roadmap-
  und Traceability-Details bleiben ueber `docs/STATUS.md`,
  `docs/CHANGELOG.md` und `docs/SPRINTS.md` verfuegbar, dominieren aber
  nicht mehr die erste Leseebene. (2026-04-11)
- [General] Fix/TUI: `u_painter` verbraucht bei umbrochenen Fact-Values
  jetzt die korrekte UTF-8-Teilmenge ohne Zeichenverlust. Lange
  ununterbrochene `Receipt link`- oder `Note`-Werte im Referenzscreen
  `Betankungen --list fuelups --detail` ueberspringen dadurch beim Umbruch
  keine Zeichen mehr. `tests/regression/run_receipt_link_contract_check.sh`
  prueft den sichtbaren Contract jetzt explizit gegen lange ununterbrochene
  Werte ohne Leerzeichen. (2026-04-11)
- [General] Docs/Audit: Der externe Public-Repo-Entry-Audit vom 2026-04-11
  ist jetzt in konkrete Repo-Folgen uebersetzt. `TSK-0031` ist `done`,
  `BL-0035` ist `done`, `ISS-0011` schneidet den README-/Quick-Start-
  Einstieg als Erstbesucher-Reibung, `ISS-0012` schneidet die Inkonsistenz
  zwischen oeffentlichem Release-Signal und sichtbarer GitHub-Release-
  Oberflaeche, und `BL-0036` buendelt den spaeteren Contributor-Onboarding-
  und English-Entry-Layer-Folgeblock. `docs/BACKLOG.md`, `docs/STATUS.md`,
  `docs/README.md` und `docs/SPRINTS.md` fuehren denselben audit-gestuetzten
  Stand; ein neuer `ADR` war nicht erforderlich und es wurde keine
  Produkt-Runtime geaendert. (2026-04-11)
- [General] Docs/Audit: `BL-0035` rahmt jetzt einen zweistufigen
  Public-Repo-Entry-Audit fuer den GitHub-Einstieg. `TSK-0030` liefert den
  wiederverwendbaren Prompt jetzt bewusst als Vorlage in der externen
  Audit-Ablage unter
  `/home/christof/Projekte/Audit/Betankungen/prompts/templates/TEMPLATE_public-repo-entry-audit_prompt.md`,
  waehrend `TSK-0031` spaetere Findings erst nach einem Cold-Start-Pass in
  Quick Wins, konkrete `ISS`, groessere `BL` und nur bei echtem
  Strukturbedarf in `ADR`-Kandidaten uebersetzt. `docs/BACKLOG.md`,
  `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md` und die externe
  Audit-Ablage fuehren denselben Planungsstand; eine Produkt- oder
  Runtime-Aenderung wurde bewusst nicht vorgenommen. (2026-04-11)
- [S40C2/2] Docs/Traceability: Sprint 40, der Abschluss von `TSK-0029`
  und der erreichte `BL-0033`-Stand sind jetzt in `docs/CHANGELOG.md`
  und `docs/SPRINTS.md` verankert. Der Abschlusslauf dokumentiert den
  gruennen Nachweis ueber den Repo-Standard-Build
  (`fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`),
  `tests/regression/run_receipt_link_contract_check.sh`,
  `tests/smoke/smoke_multi_car_context.sh`, `tests/smoke/smoke_cli.sh`,
  `scripts/projtrack_lint.sh` und `make verify`. Der Sprint haelt
  ausdruecklich fest, dass weder ein Form-System noch Add-/Edit-Flows oder
  neue Fachlogik vorgezogen wurden. (2026-04-08)
- [S40C1/2] Feat/TUI: `--list fuelups --detail` nutzt jetzt den ersten
  read-only Referenzscreen der CLI-first-TUI-Linie. `units/u_painter.pas`
  und `units/u_view_fuelups.pas` liefern dafuer eine kleine
  wiederverwendbare Painter-/View-Basis; `units/u_fuelups.pas` routet nur
  den Detailpfad auf diesen neuen Screen, waehrend der kompakte
  `--list fuelups`-Pfad stationsfokussiert und fachlich unveraendert
  bleibt. Die bestehende Detailinformation bleibt sichtbar, gezielte
  Receipt-/Mehrfahrzeug-Smokes fuehren denselben Contract, `BL-0033` und
  `TSK-0029` sind damit `done`, und `BL-0034` bleibt bewusst spaeter.
  (2026-04-08)
- [General] Docs/Process: Die Sync-Regel fuer Arbeitskopien trennt jetzt
  klar zwischen beobachtender Zustandspruefung und bewusst ausgeloesten
  Git-Aenderungen. `docs/GIT_WORKFLOW.md` fuehrt am Session-Start
  `git remote -v`, `git fetch --prune origin`,
  `git status --short --branch` und `git log -1 --oneline` als
  Standardfolge; `git pull --ff-only` bleibt zulaessig, aber nur noch als
  explizite Folgeaktion. `AGENTS.md`, `docs/README.md`,
  `docs/ADR/ADR-0010-repo-local-workflow-wrapper-cli.md` sowie die
  Audit-Prompt-Artefakte werden auf denselben Regelstand gezogen.
  Es wurde keine Produkt-Runtime geaendert. (2026-04-08)
- [General] Docs/Planning: Der Steuerungs-Sync vor Sprint 40 zieht Audit-,
  Tracker- und Prompt-Artefakte auf den aktuellen `1.4.0-dev`-Stand.
  `/home/christof/Projekte/Audit/Betankungen/AUDIT_STATUS_BOARD.md` markiert
  die fruehe `1.2.0`-Bewertung jetzt explizit als historisch und spiegelt
  die triggerbasierte Audit-Realitaet der aktiven Linie; `BL-0033` ist auf
  `approved` gezogen, der erste Referenzscreen ist fest auf
  `Betankungen --list fuelups --detail` zugeschnitten und `TSK-0029`
  bereitet den naechsten kleinen Runtime-Slice ohne Form-System vor.
  `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/SPRINTS.md`,
  `/home/christof/Projekte/Audit/Betankungen/prompts/README.md` und der
  neue offene Sprint-Prompt
  `/home/christof/Projekte/Audit/Betankungen/prompts/sprints/offen/2026-04-08_S40_TSK-0029_prompt.md`
  fuehren denselben Steuerungsstand. (2026-04-08)
- [S39C2/2] Docs/Traceability: Sprint 39 und der Abschluss von `TSK-0028`
  sind jetzt in `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankert.
  Der Sprint dokumentiert den gruennen Abschlussnachweis ueber den
  Repo-Standard-Build (`fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`),
  gezielte `P-012`-/`P-050`-/`P-051`-Checks, einen manuellen Kurzlauf fuer
  normale kleine Distanz ohne `--missed-previous`, einen manuellen
  Distanzluecken-Abbruch fuer `P-012`, `scripts/projtrack_lint.sh` und
  `make verify`. (2026-04-07)
- [S39C1/2] Fix/Fuelups: `--add fuelups` stellt `P-050` fuer kleine
  Distanzen nicht mehr als irrefuehrenden Standarddialog in den normalen
  Add-Flow. Ein bewusster Kurzdistanz-Reset bleibt nur noch ueber den
  expliziten Ausnahme-Opt-in `--missed-previous` erreichbar; dann fragt
  `P-050` klar nach einem manuellen Zyklus-Reset mit `missed_previous=1`.
  `P-012` fuer grosse Distanzluecken bleibt fachlich und dialogseitig
  unveraendert. `BL-0031` ist damit `done`, `TSK-0028` ist `done`,
  `ISS-0010` ist `resolved`, und Help-/Test-/Entry-Doku fuehren denselben
  Contract. (2026-04-07)
- [General] Docs/TUI: `ADR-0015` verankert jetzt die CLI-first-TUI-Strategie
  fuer Betankungen. Klassische CLI- und non-interactive-Pfade bleiben
  verbindlich erhalten; eine TUI wird nur als optionale Komfortschicht
  iterativ eingefuehrt. `BL-0033` schneidet dafuer einen spaeteren
  read-only-View-Refresh mit einem einzelnen Referenzscreen, waehrend
  `BL-0034` ein moegliches spaeteres Formular-/Widget-System erst nach
  bewaehrter View-/Painter-Basis vorbereitet. `docs/BACKLOG.md`,
  `docs/STATUS.md`, `docs/README.md`, `docs/ADR/README.md` und
  `docs/SPRINTS.md` fuehren denselben Planungsstand. (2026-04-07)
- [S38C2/2] Docs/Traceability: Sprint 38 und der Abschluss von `TSK-0027`
  sind jetzt in `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankert.
  Der Sprint dokumentiert den gruennen Abschlussnachweis ueber
  `tests/regression/run_receipt_link_contract_check.sh`,
  `tests/smoke/smoke_cli.sh`, `tests/smoke/smoke_multi_car_context.sh`,
  `scripts/projtrack_lint.sh`, `make verify` sowie einen manuellen
  Realtest fuer gueltigen lokalen Pfad, fehlende lokale Datei und den Lauf
  ohne `--receipt-link`. (2026-04-03)
- [S38C1/2] Feat/Fuelups: `--add fuelups` zeigt den aktiven
  Fahrzeugkontext jetzt frueh und explizit an, kommuniziert den
  Vorab-Charakter von `--receipt-link` im Add-Flow und haertet lokale
  Receipt-Links ohne neuen Edit-Path. `units/u_car_context.pas` liefert
  dafuer ein sichtbares Car-Kontext-Label; `units/u_fuelups.pas`
  normalisiert lokale absolute Receipt-Pfade vor der Persistenz auf einen
  kanonischen `file://`-Wert und fragt bei fehlenden lokalen Dateien per
  Warning+Confirm nach, statt die Referenz still zu uebernehmen.
  `units/u_cli_help.pas`, `docs/BENUTZERHANDBUCH.md`,
  `docs/README.md`, `ISS-0009`, `BL-0031` und `TSK-0027` fuehren
  denselben Guidance-Contract; `tests/regression/run_receipt_link_contract_check.sh`,
  `tests/smoke/smoke_cli.sh`, `tests/smoke/smoke_multi_car_context.sh`
  und `tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`
  decken die neue Add-Flow-Guidance regressionsseitig ab. (2026-04-03)
- [General] Docs/Tracker: `ISS-0010` dokumentiert jetzt den realen
  Nutzungsbefund, dass `P-050` bei normalen kurzen Fuelup-Distanzen im
  aktuellen Add-Flow irrefuehrend wirkt. Unter `BL-0031` ist dafuer
  `TSK-0028` neu angelegt, um die spaetere Entkopplung der
  `P-050`-Reset-Guidance vom normalen Fuelup-Flow sauber von `TSK-0027`
  zu trennen; `P-012` fuer grosse Distanzluecken bleibt ausdruecklich
  unberuehrt. `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/README.md` und
  `docs/SPRINTS.md` fuehren denselben Planungsstand. (2026-04-03)
- [S37C2/2] Docs/Traceability: Sprint 37 und der Abschluss von `TSK-0026`
  sind jetzt in `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankert.
  Der Sprint dokumentiert den gruennen Abschlussnachweis ueber
  `tests/smoke/smoke_multi_car_context.sh`, `tests/smoke/smoke_cli.sh`,
  `scripts/projtrack_lint.sh` und `make verify`. (2026-04-03)
- [S37C1/2] Docs/Fuelups: `--add fuelups` fragt den Kilometerstand jetzt
  explizit als aktuellen Gesamt-Kilometerstand des Fahrzeugs ab.
  `units/u_fuelups.pas`, `units/u_cli_help.pas`,
  `docs/BENUTZERHANDBUCH.md` und `docs/README.md` fuehren damit denselben
  kanonischen `odometer_km`-Contract ohne Trip-/Delta-Semantik.
  `ISS-0008` ist auf `resolved`, `BL-0031` auf `in_progress` und
  `TSK-0026` auf `done` synchronisiert; die Smoke-Abdeckung prueft Help-
  und Prompt-Guidance fuer den geklaerten Odometer-Contract. (2026-04-03)
- [General] Docs/Fuelups: `BL-0031` und `TSK-0027` schneiden den
  Receipt-Link-Teil jetzt konkreter: lokale Receipt-Pfade aus
  Drag-and-Drop/Shell-Nutzung sollen spaeter auf einen kanonischen
  `file://`-Speicherwert normalisiert werden, und fehlende lokale Dateien
  sollen eine explizite Guidance statt stiller Annahme bekommen. Als bewusst
  spaeterer Hybrid-Folgeblock ist `BL-0032` neu angelegt: benutzerverwaltete
  Receipt-Ordner bleiben erlaubt, ein app-verwalteter XDG-Belegordner ist nur
  als optionaler Komfortmodus vorgemerkt. `docs/BACKLOG.md`, `docs/STATUS.md`
  und `docs/README.md` fuehren denselben Planungsstand. (2026-04-02)
- [General] Fix/Fuelups: `--list fuelups` haengt den Fahrzeugnamen nicht mehr
  an die Stationsspalte an. Die Hauptzeile bleibt damit stationsfokussiert
  und schneidet bei ueblichen Stationsnamen nicht mehr mit einem
  uneindeutigen ` / ...`-Suffix ab; der Fahrzeugkontext bleibt in
  `--list fuelups --detail` separat ueber `Car: ...` sichtbar. Die
  Receipt-Link-Regression sichert jetzt explizit ab, dass die kompakte Liste
  den Stationsnamen ohne abgeschnittenen Car-Suffix zeigt. (2026-04-02)
- [S36C2/2] Docs/Traceability: Sprint 36 ist jetzt mit Hash-,
  Tracker- und Verifikationsbezug in `docs/CHANGELOG.md` und
  `docs/SPRINTS.md` verankert. Der Sprint dokumentiert den gruennen
  Abschlussnachweis ueber `scripts/projtrack_lint.sh` und `make verify`.
  (2026-04-02)
- [S36C1/2] Docs/Fuelups: Neue Tracker-/Entscheidungsbasis fuer die
  beobachteten Fuelup-Funde aus realer Nutzung angelegt. `ISS-0008`
  dokumentiert die offene Odometer-vs-Trip-Semantik des Prompts,
  `ISS-0009` die versteckte Car-/Receipt-Link-Guidance im Add-Flow,
  `ADR-0014` akzeptiert `odometer_km` als kanonischen Gesamt-KM-Stand,
  und `BL-0031` samt `TSK-0026`/`TSK-0027` schneidet daraus einen
  spaeteren UX-Hardening-Block. `docs/BACKLOG.md`, `docs/STATUS.md`,
  `docs/BENUTZERHANDBUCH.md`, `docs/README.md` und `docs/ADR/README.md`
  fuehren denselben Planungsstand; eine Runtime-Aenderung an
  `--add fuelups` wurde bewusst nicht vorgezogen. (2026-04-02)

- [S35C2/2] Docs/Traceability: Sprint 35 und der Abschluss von `BL-0030`
  sind jetzt in `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankert.
  Der Sprint dokumentiert den gruennen Abschlussnachweis ueber
  `scripts/projtrack_lint.sh` und `make verify`. (2026-04-01)
- [S35C1/2] Docs/EV: `TSK-0025` schliesst `BL-0030` als
  Discovery-/Boundary-Block ab. `docs/MODULES_ARCHITECTURE.md` definiert
  fuer `betankungen-ev` jetzt das minimale Event-Modell mit `car_id`,
  `event_date`, `energy_wh` und `cost_cents` als Pflichtfeldern sowie
  `odometer_km`, `location_id` und `notes` als optionale Zusatzfelder.
  Der erste Storage-Schnitt bleibt modul-lokal (`charging_events`,
  `charging_locations`, `module_meta`); ein generisches Core-
  `energy_events`-Modell und die Wiederverwendung von Core-`stations` als
  kanonischer Ladeort-Speicher bleiben fuer `1.4.x` explizit
  ausgeschlossen. `BL-0030`, `TSK-0025`, `docs/BACKLOG.md` und
  `docs/STATUS.md` fuehren denselben Abschlussstand. (2026-04-01)
- [General] Docs/Traceability: Der EV-Modul-Scope-Block ist jetzt
  ohne neuen Sprint-Rahmen als General-Stream in
  `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankert.
  `TSK-0024` bleibt damit als abgeschlossener Discovery-/
  Contract-Block referenzierbar; `TSK-0025` steht als
  naechster isolierter Folgeauftrag bereit. (2026-04-01)
- [General] Docs/Architecture: `TSK-0024` definiert jetzt den
  minimalen Scope fuer `betankungen-ev`: `BL-0030` steht auf
  `in_progress`, `TSK-0024` auf `done`, und
  `docs/MODULES_ARCHITECTURE.md` beschreibt den `charging`-Fokus,
  die Core-vs-Modul-Grenzen sowie die erwartete CLI-/Contract-
  Baseline. `docs/BACKLOG.md`, `docs/STATUS.md` und der
  BL-/TSK-Tracker sind auf denselben Discovery-Schnitt
  synchronisiert; `TSK-0025` bleibt bewusst auf Event-/Storage-
  Fragen begrenzt. (2026-04-01)
- [General] Fix/Stations: `stations` akzeptieren bei Geodaten jetzt neben
  vollen/globalen Open Location Codes auch lokale/short Plus Codes aus
  gaengigen Karten-UIs, sofern `latitude` und `longitude` gesetzt sind.
  `u_stations` normalisiert Eingaben mit Ortszusatz (z. B.
  `GC2M+H4 Dortmund`) auf den eigentlichen Plus-Code-Token, blockiert Short
  Codes ohne Koordinaten mit klarer Guidance (`P-088`) und speichert
  weiterhin einen kanonischen Vollcode in `plus_code`. Die Detailausgabe
  `--list stations --detail` bleibt die Source fuer vorhandene Geodaten und
  zeigt den normalisierten Vollcode wie vorgesehen an; der beobachtete
  Anzeigeeffekt trat nur auf, wenn der Short-Code zuvor gar nicht
  gespeichert wurde. `ISS-0007`, Domain-Policy- und Regressionstests sowie
  Benutzerdoku/BL-0019 sind auf den neuen Contract synchronisiert.
  (2026-04-01)
- [S34C2/2] Docs/Traceability: Sprint 34 ist jetzt mit Hash-,
  Tracker- und Verifikationsbezug in `docs/CHANGELOG.md` und
  `docs/SPRINTS.md` verankert. Paket C bleibt damit als bewusster
  Richtungs-/Discovery-Sprint referenzierbar; der gruene Abschlussnachweis
  laeuft ueber `scripts/projtrack_lint.sh` und `make verify`. (2026-03-31)
- [S34C1/2] Docs/Strategy: Paket C priorisiert EV als naechste grosse
  Domaenenerweiterung der aktiven `1.4.x`-Linie. `ADR-0008` ist jetzt
  `accepted`, `BL-0030` aktiviert einen einzelnen kanonischen
  Discovery-/Feasibility-Block fuer `betankungen-ev`, und `TSK-0024`/
  `TSK-0025` machen Scope sowie Storage-/Boundary-Fragen explizit.
  `docs/BACKLOG.md`, `docs/ADR/README.md` und `docs/STATUS.md` sind auf
  diesen EV-first-Pfad synchronisiert; Household Drivers bleiben bewusst
  nachgeordnet. (2026-03-31)
- [General] Fix/Cars: `--edit cars` kann Fahrzeug-Startwerte jetzt vor dem
  ersten Fuelup korrigieren. Sobald fuer ein Fahrzeug `fuelups` existieren,
  bleiben `odometer_start_km` und `odometer_start_date` ueber CLI und DB-Guard
  gesperrt; die Cars-Smokes und die Benutzerdoku sind auf diesen Vertrag
  synchronisiert. (2026-03-31)
- [S33C2/2] Docs/Traceability: Sprint 33 und der Abschluss von `BL-0019`
  sind jetzt in `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankert.
  Der Sprint dokumentiert den gruenen Abschluss ueber
  `scripts/projtrack_lint.sh` und `make verify`. (2026-03-31)
- [S33C1/2] Feat/Stations: `stations` wurden um optionale Geodaten und
  Plus Codes erweitert. Das Core-Schema ist auf `v6` angehoben, additiv
  fuer `v4 -> v6` und `v5 -> v6` migrierbar, und die Dialogpfade
  `--add stations`/`--edit stations` validieren jetzt Koordinatenpaare,
  Wertebereiche und volle Open Location Codes (`P-085` bis `P-088`).
  Die kompakte Stationsliste bleibt adressfokussiert; `--list stations
  --detail` zeigt vorhandene Geodaten als `geodata:`-Zeile. `BL-0019`,
  Status-/Benutzerdoku und der Verify-Gate sind darauf synchronisiert.
  (2026-03-31)
- [S32C2/2] Docs/Traceability: Sprint 32 und der Abschluss von `BL-0029`
  sind jetzt in `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankert.
  Der Sprint dokumentiert die gruene Verifikation ueber
  `scripts/projtrack_lint.sh` und `make verify`. (2026-03-31)
- [S32C1/2] Fix/Validation: Negative `odometer_km`-Eingaben werden im
  Fuelup-Dialog jetzt ueber einen kanonischen Untergrenzen-Guard
  abgefangen, bevor DB-bezogene Odometer-Policies greifen.
  `units/u_fuelups.pas` liefert damit denselben handlungsorientierten
  Hard-Error-Contract fuer relevante `--add fuelups`-Pfade; neue
  Regressionen sichern den expliziten `--car-id`-Pfad und den
  1-Car-Autoresolve-Pfad ab. `BL-0029`, `TSK-0001` und `ISS-0001`
  wurden auf den abgeschlossenen Stand synchronisiert. (2026-03-31)
- [General] Docs/Process: `knowledge_archive/` repo-seitig auf
  deprecated/read-only gestellt. `AGENTS.md` hebt die fruehere Pflicht fuer
  neue Archiv-Snippets auf, `knowledge_archive/README.md` dokumentiert den
  Legacy-/Freeze-Status und `docs/STATUS.md`, `docs/README.md` sowie
  `docs/ARCHITECTURE.md` ordnen den Ordner nur noch als historischen
  Bestand ein. Git-Historie ist jetzt explizit der primaere Rueckgriff fuer
  fruehere Implementationsstaende; historische Referenzen in
  `docs/CHANGELOG.md` und `docs/SPRINTS.md` bleiben bewusst unveraendert.
  (2026-03-31)
- [S31C2/2] Docs/Traceability: Sprint 31 ist jetzt als repo-seitiger
  Externalisierungs-Closeout fuer `BL-0011` in `docs/CHANGELOG.md` und
  `docs/SPRINTS.md` verankert. Der Sprint dokumentiert den gruennen
  Vollnachweis `make verify` und trennt klar zwischen abgeschlossenem
  Betankungen-Closeout und moeglicher externer Weiterarbeit. (2026-03-30)
- [S31C1/2] Docs/Closeout: `BL-0011` wurde im kanonischen Tracker, in der
  Scope-Entscheidung, im Backlog-Index und im Projektstatus auf den finalen
  Externalisierungs-/Handover-Abschluss fuer `Betankungen` gezogen. Das Thema
  ist fuer dieses Repository jetzt `done`; eventuelle Umsetzung liegt nur
  noch ausserhalb dieses Repositories. (2026-03-30)
- [S30C4/4] Docs/Traceability: Sprint 30 als vierteiligen Dev-Start-Sprint
  dokumentiert. `docs/CHANGELOG.md` und `docs/SPRINTS.md` referenzieren jetzt
  den isolierten Aktivierungs-Commit, die `BL-0016`-Baseline, die
  Markdown-Migration des Legacy-Task-Index und den gruennen Vollnachweis
  `make verify`. (2026-03-30)
- [S30C3/4] Docs/Tracker: `docs/tasks/README.txt` auf Markdown umgestellt und
  `scripts/projtrack_lint.sh` gezielt auf echte Legacy-Task-Dateien
  (`TSK-*.md`) unter `docs/tasks/` begrenzt, damit ein Markdown-Index im
  Ordner moeglich bleibt, ohne den Tracker-Lint zu verfaelschen.
  (2026-03-30)
- [S30C2/4] Docs/Community: `BL-0016` als erste `1.4.0-dev`-Inhaltsarbeit
  umgesetzt. Neue Public-Repository-Baseline aus `CODE_OF_CONDUCT.md`,
  `SECURITY.md`, Bug-/Feature-Issue-Templates und PR-Template geliefert;
  `CONTRIBUTING.md`, Root-README, deutsche/englische Einstiegsdoku,
  `docs/STATUS.md`, `docs/BACKLOG.md` und der BL-Tracker sind darauf
  synchronisiert. (2026-03-30)
- [S30C1/4] Release/Docs: Die aktive Entwicklungsbasis wurde in einem
  separaten Aktivierungs-Commit auf `APP_VERSION=1.4.0-dev` gesetzt
  (`src/Betankungen.lpr`). Root-README, deutsche/englische Einstiegsdoku,
  `CONTRIBUTING.md` und `docs/STATUS.md` fuehren den Sprint-29-Gate jetzt als
  eingeloesten Vorstart-Nachweis und kommunizieren `BL-0016` weiterhin als
  ersten In-Repo-Folgeblock der 1.4.0-Linie. (2026-03-30)
- [General] Docs/Traceability: Fehlende kanonische Tracker-/ADR-Referenzen
  fuer den bereits abgeschlossenen Vorbereitungsblock Sprint 25 bis 28
  nachgezogen. Neue Backfill-Eintraege `BL-0025` bis `BL-0028` und
  `ADR-0011` bis `ADR-0013` machen Tracker-Endzustand, Entry-/Wiki-Layer und
  `btkgit`-Safety referenzierbar; `docs/BACKLOG.md`, `docs/ADR/README.md`,
  `docs/STATUS.md` und `docs/SPRINTS.md` sind minimal darauf synchronisiert.
  `APP_VERSION=1.3.0`, der Sprint-29-Startgate und der Scope vor
  `1.4.0-dev` bleiben unveraendert. (2026-03-30)
- [S29C2/2] Docs/Traceability: Sprint 29 ist jetzt als eigener Go-/No-Go-
  Gate-Sprint vor `1.4.0-dev` in `docs/CHANGELOG.md` und `docs/SPRINTS.md`
  verankert. Die Doku haelt fest, dass der naechste zulaessige Schritt ein
  separater Aktivierungs-Commit bleibt und `BL-0016` erst danach beginnen
  darf. (2026-03-29)
- [S29C1/2] Docs/Gate: Neuer Startgate
  `docs/DEV_START_GATE_1_4_0.md` definiert die Preconditions vor
  `1.4.0-dev`, den aktuellen Stand `GO` fuer einen separaten
  Aktivierungs-Commit und die klare Abgrenzung zwischen abgeschlossenem
  Vorbereitungsblock, Startfreigabe und eigentlichem Dev-Start.
  `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md` und `README.md`
  sind darauf synchronisiert. (2026-03-29)
- [S28C2/2] Docs/ADR: `ADR-0010` und `docs/README.md` dokumentieren den
  gehaerteten `btkgit`-Ist-Zustand jetzt explizit: `sync` liefert nur klare
  Operator-Hinweise fuer Auth-/Remote-/Upstream-Probleme, `cleanup` bleibt
  ohne `--delete-local` bewusst nicht-destruktiv, und der Wrapper wird klar
  als kleines Repo-Werkzeug mit Grenzen gegenueber `git`/`gh` beschrieben.
  (2026-03-29)
- [S28C1/2] Tooling/Workflow: `btkgit` wurde fuer Solo-Maintenance
  gehaertet. Der Root-Entrypoint scheitert jetzt klar, wenn das eigentliche
  Script fehlt; `sync` erklaert fehlendes `origin`, fehlenden Branch-Upstream
  sowie Auth-/Remote-Probleme gezielter; `cleanup` fuehrt nur noch ein
  explizites lokales Branch-Delete via `--delete-local` aus und loescht nie
  stillschweigend `main`. Die Smoke-Abdeckung prueft diese Pfade jetzt
  nicht-destruktiv in isolierten Temp-Repositories. (2026-03-29)
- [S27C2/2] Docs/Public Entry: Root-README, `CONTRIBUTING.md` und
  `docs/README_EN.md` verlinken den publizierten GitHub-Wiki-Einstieg jetzt
  explizit neben den versionierten Wiki-Quellseiten. Die oeffentlichen
  Repo-Einstiege kommunizieren damit ruhiger, dass das Wiki die kuratierte
  Orientierungsschicht ist, waehrend `docs/` die technische Source of Truth
  bleibt. (2026-03-29)
- [S27C1/2] Docs/Wiki: Wiki-Home, Wiki-README und `Cookie-Note` auf eine
  klarere Entry-Layer-Rolle ausgerichtet. Die Kernnavigation ist jetzt von
  Zusatzkontext getrennt, die Source-of-Truth-Grenze zu `docs/` wird explizit
  benannt und persoenlicher Kontext bleibt sichtbar, aber bewusst
  nachgeordnet. (2026-03-29)
- [General] Docs/CI: Sprint-26-Referenzen im Abschnitt `Sprint / Commit
  References` auf das vom Doku-Lint erwartete Ein-Zeilen-Format normalisiert,
  damit `scripts/sprint_docs_lint.sh` die `Basis-Commit`-Hashes in GitHub
  Actions auf dem PR-Merge-Ref korrekt erkennt. (2026-03-29)
- [S26C2/2] Docs/Entry: Deutschen Einstieg und Status-Narrativ auf den
  bewussten Transition-Hold nach `1.3.0` synchronisiert. `docs/README.md`
  fuehrt jetzt einen kompakten Kurzstand mit finaler `1.3.0`-Linie,
  aktivem Hold, unveraendertem `APP_VERSION=1.3.0`, `BL-0016` als
  vorbereitetem In-Repo-Scope und `BL-0011` als externem Handover-Thema.
  `docs/STATUS.md` markiert den 1.3.0-Gate-Plan zusaetzlich explizit als
  abgeschlossene Linie mit bewusst aktivem `post-1-3-0-transition`.
  (2026-03-29)
- [S26C1/2] Docs/Public Entry: Root-README, `CONTRIBUTING.md` und
  `docs/README_EN.md` auf den post-`1.3.0`-Hold umgestellt. Die
  Einstiegsdoku kommuniziert jetzt konsistent: `1.3.0` ist final,
  `APP_VERSION=1.3.0` bleibt technisch stehen, `1.4.0-dev` ist bewusst noch
  nicht gestartet, `main` bleibt PR-/Verify-gesteuert und `BL-0011` ist fuer
  dieses Repository kein aktiver In-Repo-Implementierungsscope. (2026-03-29)
- [S25C2/2] Docs/Tracker: Task-Navigation als Legacy-Ausnahmefall
  nachgeschaerft. `docs/issues/README.md` verweist neue Folge-Tasks
  verbindlich auf `docs/backlog/.../tasks/`, und eine neue Legacy-Notiz im
  `docs/tasks/`-Ordner ordnet `TSK-0005` als historischen Ausnahmefall klar
  ein. Der Hinweis liegt bewusst nicht als Markdown-Tracker-Datei vor, damit
  `projtrack_lint` unter `docs/tasks/` weiterhin nur echte Task-Artefakte
  bewertet. (2026-03-29)
- [S25C1/2] Docs/Tracker: Verbindlichen Tracker-Endzustand fuer neue Arbeit
  festgezogen. `POL-001`, `docs/BACKLOG.md`, `docs/backlog/README.md`,
  `docs/ADR/README.md` und `docs/STATUS.md` trennen jetzt explizit zwischen
  kanonischen Pfaden (`docs/backlog/`, `docs/issues/`, `docs/policies/`) und
  lesbarem Legacy-Bestand. `docs/ADR/` bleibt bis zu einem separaten
  Migrationsentscheid der aktive ADR-Pfad; `docs/adr/` wird nicht implizit
  parallel eingefuehrt. (2026-03-29)
- [General] Process/PR-Workflow: Sprint-PR-Titel als eigene Konvention
  verankert. Fuer Sprint-Arbeit gilt auf GitHub jetzt `[Sxx] type: short
  description`; Commit-Labels wie `[S24C1/1]` und generische Titel wie
  `[Sprint 24]` sind als PR-Titel nicht zulaessig. Kurzregel in `AGENTS.md`,
  Detailregel in `docs/GIT_WORKFLOW.md`. (2026-03-28)
- [S24C1/1] Planning/Tracker: `BL-0011` fuer die geplante `1.4.0`-Linie
  formal aus dem Betankungen-Implementierungsscope externalisiert.
  `BL-0011` steht jetzt im kanonischen Tracker als blocked/research mit
  explizitem Externalisierungs-Handover; neues Entscheidungsdokument
  `docs/BL-0011_SCOPE_DECISION_1_4_0.md` haelt Begruendung, MVP-Snapshot und
  Re-Entry-Kriterien fest. `docs/BACKLOG.md`, `docs/STATUS.md` und
  `docs/ROADMAP_1_3_0.md` fuehren fuer das Betankungen-Repo jetzt nur noch
  `BL-0016` als verbleibenden In-Repo-Scope fuer `1.4.0`. (2026-03-28)
- [S23C1/1] Tracker/Backlog: Semantischen Kettenbruch rund um `BL-0011`
  bereinigt. `BL-0011` ist jetzt wieder ein reiner Scaffolder-Backlog ohne
  Odometer-Referenzen; neuer fachlicher Block `BL-0029` wurde angelegt,
  `TSK-0001` in den neuen BL-Pfad verschoben und auf `parent: BL-0029`
  umgestellt, `ISS-0001` auf `BL-0029` referenziert und der Backlog-Index
  (`docs/BACKLOG.md`) entsprechend synchronisiert. (2026-03-28)
- [General] Tooling/Workflow: `ADR-0010` als MVP umgesetzt. Neues
  repo-lokales Wrapper-CLI `btkgit` eingefuehrt (`./btkgit`,
  `scripts/btkgit.sh`) mit den Kommandos `sync`, `preflight <version>`,
  `ready` und `cleanup`; Smoke-Abdeckung wurde um einen Basischeck fuer
  `btkgit --help` erweitert (`tests/smoke/smoke_cli.sh`).
  Doku-Sync in `docs/ADR/ADR-0010-repo-local-workflow-wrapper-cli.md`,
  `docs/README.md`, `docs/STATUS.md` und `docs/SPRINTS.md`. (2026-03-27)
- [General] Wiki/Tracker: `BL-0024` abgeschlossen und auf `done` gesetzt.
  Cookie-Notiz als kuratierte Wiki-Seite veroeffentlicht
  (`docs/wiki/Cookie-Note.md`), Navigation in `docs/wiki/Home.md` und
  `docs/wiki/README.md` nachgezogen, zugehoerige Tasks `TSK-0022` und
  `TSK-0023` auf `done` gesetzt sowie Backlog-Index synchronisiert
  (`docs/backlog/BL-0024-cookie-personal-wiki-note/**`, `docs/BACKLOG.md`).
  Wiki-Link-Guardrails wurden fuer die neue Seite erweitert
  (`scripts/wiki_link_check.sh`). (2026-03-27)
- [General] Process/Git-Policy: Merge- und Commit-Regeln verbindlich
  nachgeschaerft. `Create a merge commit` ist jetzt als fester
  Standard-Merge mit Prioritaetsregel dokumentiert; heuristische
  Squash-Entscheidungen gelten nur ohne expliziten Standard.
  `Squash and merge` ist nur noch mit expliziter Ueberschreibung oder
  eindeutiger Task-Forderung zulaessig. Zusaetzlich ist die
  Commit-Message-Konvention repo-weit auf
  `[Scope] type: kurze beschreibung` vereinheitlicht
  (`AGENTS.md`, `docs/GIT_WORKFLOW.md`). (2026-03-27)
- [General] Versioning/Transition: Verbindlichen Uebergangszustand
  `post-1-3-0-transition` definiert. `APP_VERSION` bleibt explizit auf
  `1.3.0`; die 1.4.0-Linie bleibt nur planerisch vorgemerkt und startet erst
  mit einem separaten Dev-Start-Commit (`1.4.0-dev`). Status-/Changelog-
  Metadaten wurden entsprechend synchronisiert (`docs/STATUS.md`,
  `docs/CHANGELOG.md`). (2026-03-27)
- [General] Process/Git-Workflow: Verbindliche Branch-Naming-Disziplin in den
  kanonischen Git-/PR-Regeln verankert (`docs/GIT_WORKFLOW.md`): generische
  Platzhalter-Branch-Namen sind explizit unzulaessig; Branches muessen den
  fachlichen Scope klar abbilden; bei unklarer Ableitung ist vor
  Commit/Push ein konkreter Namensvorschlag zur Freigabe einzuholen.
  Zusaetzlich wurde der laufende Arbeitsbranch auf einen regelkonformen Namen
  korrigiert (`chore/1-4-0-adr0010-bl0024-tracker-sync`) und der generische
  Remote-Branch aufgeraeumt. (2026-03-26)
- [General] ADR/Tracker: `ADR-0010` ist von `proposed` auf `accepted`
  finalisiert und der Startumfang fuer das repo-lokale Workflow-Wrapper-CLI
  (`btkgit`) verbindlich festgezogen (`docs/ADR/ADR-0010-repo-local-workflow-wrapper-cli.md`,
  `docs/ADR/README.md`). Parallel wurde `BL-0024` von `proposed` auf
  `approved` gehoben und um konkrete Folgeaufgaben erweitert:
  `TSK-0022` (Platzierung/Ton/Guardrails) und `TSK-0023`
  (Veroeffentlichung/Navigation/Link-Check). Backlog-Index und Tracker-Dateien
  sind synchronisiert (`docs/backlog/BL-0024-cookie-personal-wiki-note/item.md`,
  `docs/backlog/BL-0024-cookie-personal-wiki-note/tasks/TSK-0022-define-cookie-note-placement-tone-and-guardrails.md`,
  `docs/backlog/BL-0024-cookie-personal-wiki-note/tasks/TSK-0023-publish-cookie-wiki-note-and-sync-links.md`,
  `docs/BACKLOG.md`). (2026-03-26)
- [General] Release/Docs: Version `1.3.0` final freigegeben.
  `src/Betankungen.lpr` wurde auf `APP_VERSION=1.3.0` umgestellt; Gate 5 der
  1.3.0-Linie ist in Roadmap-/Status-/Entry-/Preflight-/Sprint-Doku als
  abgeschlossen synchronisiert (`docs/ROADMAP_1_3_0.md`, `docs/STATUS.md`,
  `docs/README.md`, `docs/README_EN.md`, `README.md`,
  `docs/RELEASE_1_3_0_PREFLIGHT.md`, `docs/SPRINTS.md`). Finale
  Release-/Backup-Ausfuehrung wurde erfolgreich durchgefuehrt
  (`./kpr.sh --note "Release 1.3.0 final"`,
  `scripts/backup_snapshot.sh --note "Backup after release 1.3.0"`), inkl.
  Artefakt `.releases/Betankungen_1_3_0.tar` (SHA-256
  `d9e61f0c6516c67c5191882c163bb28f664db2a1d1f41397766830a1280653de`) und
  Snapshot `.backup/2026-03-26_1918`; lokaler
  Vollnachweis `make verify` ist gruen. (2026-03-26)
- [General] Versioning: Nach der Finalisierung von `1.2.0` wurde die aktive
  Entwicklungsbasis auf `APP_VERSION=1.3.0-dev` angehoben
  (`src/Betankungen.lpr`). (2026-03-24)
- [General] Planning/Roadmap: Verbindlichen Fahrplan fuer die `1.3.0`-Linie
  eingefuehrt (`docs/ROADMAP_1_3_0.md`) und den aktiven Gate-Stand
  synchronisiert: Gate 1 abgeschlossen (Zyklusstart), Gate 2 abgeschlossen,
  Gate 3 aktiv.
  Leitplanken aus dem Entscheidungsentwurf vom 2026-03-18 sind verankert:
  `1.3.0` = Option B (`BL-0017` + `BL-0018`), `1.4.0` = Option C
  (`BL-0016` + `BL-0011`). Zusaetzlich ist die triggerbasierte Audit-
  Leitplanke fuer Gate 4/5 verankert (kein pauschales Vollaudit pro Change).
  (2026-03-24)
- [General] Docs/Entry: Root-README, deutsche/englische Einstiegsdoku,
  Projektstatus und Sprint-Narrativ auf die aktive `1.3.0-dev`-Linie
  synchronisiert (`README.md`, `docs/README.md`, `docs/README_EN.md`,
  `docs/STATUS.md`, `docs/SPRINTS.md`). (2026-03-24)
- [General] Tracker/Planning: Scope-Freeze fuer `1.3.0` im kanonischen Tracker
  festgezogen. `BL-0017` und `BL-0018` stehen jetzt auf `approved` mit Lane
  `release-blocking`; Downstream-Tasks `TSK-0018` bis `TSK-0021` sind angelegt
  und der Gate-2-Stand ist in Backlog-/Roadmap-/Status-/Entry-Doku
  synchronisiert (`docs/backlog/BL-0017-fuel-price-api-evaluation/item.md`,
  `docs/backlog/BL-0018-fuel-price-history-polling/item.md`,
  `docs/BACKLOG.md`, `docs/ROADMAP_1_3_0.md`, `docs/STATUS.md`,
  `docs/README.md`, `docs/README_EN.md`, `docs/SPRINTS.md`). (2026-03-24)
- [General] Research/Decision: API-Evaluation fuer `BL-0017` in kanonische
  Repo-Doku ueberfuehrt (`docs/FUEL_PRICE_API_EVALUATION_1_3_0.md`).
  Bewertungsmatrix, Ausschlussgruende, Betriebsgrenzen und Auditbedarf sind
  jetzt nachvollziehbar verankert; fuer `1.3.0` ist `Tankerkoenig` als
  Primaerquelle und `Benzinpreis-Aktuell.de` als degradierter Fallback
  festgelegt. Tracker-Sync: `TSK-0018` und `TSK-0019` auf `done`, `BL-0017`
  auf `done`; Gate-3-Stand in Roadmap-/Status-/Entry-/Sprint-Doku
  aktualisiert. (2026-03-24)
- [General] Contract/Planning: `TSK-0020` fuer `BL-0018` abgeschlossen und den
  Polling-/Historien-Contract fuer `1.3.0` als kanonische Repo-Doku
  eingefuehrt (`docs/FUEL_PRICE_POLLING_HISTORY_CONTRACT_1_3_0.md`).
  Dokumentiert sind jetzt Datenpfad-Trennung zur Core-Datenbank,
  Raw-Snapshot-Konventionen, minimale Historienpersistenz, Integrationsgrenzen
  sowie Retention-/Audit-Leitplanken. Tracker-Sync: `TSK-0020` auf `done`,
  `BL-0018` auf `in_progress`; Gate-3-Stand in Backlog-/Roadmap-/Status-/
  Entry-/Sprint-Doku aktualisiert. (2026-03-24)
- [General] Polling/History: `TSK-0021` fuer `BL-0018` abgeschlossen. Neuer
  separater Runner `scripts/fuel_price_polling_run.sh` persistiert
  `tankerkoenig`-Snapshots in den getrennten Historienpfad
  `fuel_price_history/` (raw/db/state), inklusive SQLite-Minimalpersistenz und
  lesbarer State-Datei. Neue Regression
  `tests/regression/run_fuel_price_history_check.sh` mit Fixtures deckt
  Pflichtargumente, Dry-Run, Erfolgsfall, Duplikat-Guardrail und Fehlerpfad
  ohne Partial-Write ab; Verify wurde ueber `make fuel-price-history-check`
  erweitert. Doku-/Runtime-Sync in
  `docs/FUEL_PRICE_POLLING_RUNTIME_1_3_0.md`,
  `docs/FUEL_PRICE_POLLING_HISTORY_CONTRACT_1_3_0.md`,
  `docs/TEST_MATRIX.md`, `tests/README.md` und
  `tests/regression/README.md`. Tracker-Sync: `TSK-0021` auf `done`,
  `BL-0018` auf `done`; Gate 3 der 1.3.0-Linie ist formal abgeschlossen,
  Gate 4 aktiv. (2026-03-24)
- [General] Release/Preflight: Gate 4 der `1.3.0`-Linie operationalisiert.
  Neuer Blueprint `docs/RELEASE_1_3_0_PREFLIGHT.md` definiert Scope-,
  Doku-, Dry-Run- und Audit-Gates fuer Gate 4/5; neues Skript
  `scripts/release_preflight_1_3_0.sh` prueft `APP_VERSION=1.3.0-dev`,
  dokumentierte Scope-/Tracker-Gates fuer `BL-0017`/`BL-0018`, optional
  `make verify` sowie Release-/Backup-Dry-Runs. Make-/Entry-Sync:
  `make release-preflight-1-3-0` in `Makefile`, Doku-Navigation und
  Gate-Status in `README.md`, `docs/README.md`, `docs/README_EN.md`,
  `docs/ROADMAP_1_3_0.md`, `docs/STATUS.md` und `docs/SPRINTS.md`
  aktualisiert. Lokaler RC-Kickoff-Lauf `make release-preflight-1-3-0` ist
  erfolgreich dokumentiert. (2026-03-24)
- [General] ADR/Workflow: Die Idee eines kleinen repo-lokalen Workflow-
  Wrapper-CLI fuer Git-/PR-/Preflight-Schritte ist als `ADR-0010` auf
  Vorschlagsstand verankert (`docs/ADR/ADR-0010-repo-local-workflow-wrapper-cli.md`).
  Leitplanke: kein neuer Scope in `1.3.0`; ein einfacher Script-MVP wird erst
  nach der Finalisierung der `1.3.0`-Linie als Folgearbeit betrachtet.
  ADR-Index synchronisiert (`docs/ADR/README.md`). (2026-03-24)
- [General] Release/Docs: Gate-4-RC-Snapshot fuer `1.3.0` nachgezogen.
  `docs/RELEASE_1_3_0_PREFLIGHT.md` enthaelt jetzt den RC-Checklisten-/
  Freeze-Snapshot, die aktuelle CI-Referenz auf `main`
  (`CI` Run `23514165068`, Commit `ce5a574`, `success`) sowie den
  verbleibenden Gate-4-Rest. Roadmap-/Status-/Entry-/Sprint-Doku auf den
  aktualisierten Gate-4-Stand synchronisiert
  (`docs/ROADMAP_1_3_0.md`, `docs/STATUS.md`, `docs/README.md`,
  `docs/README_EN.md`, `docs/SPRINTS.md`). (2026-03-24)
- [General] Release/Docs: Gate 4 der `1.3.0`-Linie formal abgeschlossen und
  Handover auf Gate 5 synchronisiert. `docs/RELEASE_1_3_0_PREFLIGHT.md`
  dokumentiert jetzt den finalen RC-Abschlusslauf (`make release-preflight-1-3-0`
  inkl. `make verify`) sowie die aktuelle CI-Referenz auf `main`
  (`CI` Run `23515516312`, Commit `027e963`, `success`). Roadmap-/Status-/
  Entry-/Sprint-Doku sind auf den Gate-Stand `Gate 4 abgeschlossen, Gate 5 aktiv`
  nachgezogen (`docs/ROADMAP_1_3_0.md`, `docs/STATUS.md`, `docs/README.md`,
  `docs/README_EN.md`, `README.md`, `docs/SPRINTS.md`). Preflight-Guardrail
  in `scripts/release_preflight_1_3_0.sh` auf den Gate-4-Closeout-Zustand
  erweitert (`Gate 4 aktiv/abgeschlossen`). (2026-03-26)
- [General] Release/Docs: Gate-5-Kickoff-Snapshot fuer `1.3.0` dokumentiert.
  `docs/RELEASE_1_3_0_PREFLIGHT.md` fuehrt jetzt einen expliziten
  Gate-5-Snapshot (Scope, Versions-Guardrail `APP_VERSION=1.3.0-dev`,
  Audit-Snapshot und finale Exit-Checks). Roadmap-/Status-/Entry-/Sprint-Doku
  auf den neuen Zwischenstand synchronisiert (`docs/ROADMAP_1_3_0.md`,
  `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md`,
  `docs/SPRINTS.md`). (2026-03-26)
- [General] Release/Docs: Finales Gate-5-Release-Umschaltpaket fuer `1.3.0`
  vorbereitet. `docs/RELEASE_1_3_0_PREFLIGHT.md` dokumentiert jetzt die
  Ziel-Dateien und die geplante Reihenfolge fuer den finalen
  `APP_VERSION`-Switch auf `1.3.0` (ohne vorgezogene Ausfuehrung in diesem
  Schritt). Roadmap-/Status-/Entry-/Sprint-Doku auf den
  Vorbereitungsstand synchronisiert (`docs/ROADMAP_1_3_0.md`,
  `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md`,
  `docs/SPRINTS.md`). (2026-03-26)
- [General] Release/Docs: Version `1.2.0` final freigegeben. `src/Betankungen.lpr` wurde auf `APP_VERSION=1.2.0` umgestellt; Gate 5 der 1.2.0-Linie ist in Roadmap-/Status-/Entry-/Preflight-/Sprint-Doku als abgeschlossen synchronisiert (`docs/ROADMAP_1_2_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md`, `README.md`, `docs/RELEASE_1_2_0_PREFLIGHT.md`, `docs/SPRINTS.md`). Finale Release-/Backup-Ausfuehrung wurde erfolgreich durchgefuehrt (`./kpr.sh --note "Release 1.2.0 final"`, `scripts/backup_snapshot.sh --note "Backup after release 1.2.0"`), inkl. Artefakt `.releases/Betankungen_1_2_0.tar` (SHA-256 `b8798ab376bdc0b4cd17c7e8f47f6904d5337b26e96472a2b2ab99dcfddbca1d`) und Snapshot `.backup/2026-03-24_1809`; lokaler Vollnachweis `make verify` ist gruen. (2026-03-24)
- [General] Docs/Tracker: `BL-0023` abgeschlossen und als kuratierte Entwicklungschronik verankert. Neues Basisdokument `docs/DEV_DIARY.md` definiert Ort, Leitplanken und Abgrenzung zu Changelog/Sprints; erster Referenzeintrag unter `docs/dev_diary/2026-03-24-bl0023-kickoff-and-framing.md` angelegt. Tracker-Sync: `BL-0023` auf `done`, neue Tasks `TSK-0016`/`TSK-0017` auf `done` (`docs/backlog/BL-0023...`), Backlog-/Status-/Entry-Navigation nachgezogen (`docs/BACKLOG.md`, `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md`, `README.md`). (2026-03-24)
- [General] QA/Tests/Tracker: `TSK-0012` umgesetzt und `BL-0022` auf Abschlussstand gebracht. Neuer Regression-Runner `tests/regression/run_user_flow_break_matrix_check.sh` codifiziert priorisierte User-Flow-/Break-Pfade aus `docs/TEST_MATRIX.md` (INIT-001..006, DEMO-001..005, CLI-001, EOF-Abbruch `--add fuelups`, Multi-Car-Guidance-Hints). Verify-Verdrahtung erweitert (`Makefile`: Target `user-flow-break-check`, Aufnahme in `make verify`), Testdoku synchronisiert (`tests/README.md`, `tests/regression/README.md`), Matrix-Status fuer die erstabgedeckten IDs auf `Automatisiert` gesetzt und Tracker-Status nachgezogen (`docs/backlog/BL-0022...`, `docs/BACKLOG.md`, `docs/STATUS.md`). (2026-03-24)
- [General] Docs/Status-Sync: Projektstatus nach aktuellem Remote-Abgleich (`origin/main`) konsolidiert. Stand-Daten in den Entry-/Statusdokumenten aktualisiert (`README.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`, `docs/ROADMAP_1_2_0.md`, `docs/SPRINTS.md`), Gate-5-Fortschritt der 1.2.0-Linie mit dem laufenden non-blocking Hardening-Stream (`BL-0022`) explizit nachgezogen und die englische Einstiegssicht auf den aktuellen Release-/Roadmap-Stand (`1.1.0` final, `1.2.0-dev`, Gate 1-4 abgeschlossen, Gate 5 aktiv) korrigiert. (2026-03-24)
- [General] CLI/UX: First-Run- und Multi-Car-Guidance gemaess `TSK-0015` geschaerft. Bootstrap ohne Argumente meldet jetzt den angelegten Zustand sichtbar (Config/DB), erklaert das aktive Default-Fahrzeug `Hauptauto` und zeigt den naechsten Schritt (`Betankungen --list cars`). Resolver-Fehler bei `>1` Fahrzeugen enthalten neben `--car-id` zusaetzlich den Hint auf `--list cars`; Help-Text in `u_cli_help` um klare Resolver-Regeln erweitert. Smoke-Abdeckung auf den neuen Guidance-Contract synchronisiert (`tests/smoke/helpers/smoke_bootstrap_helpers.sh`, `tests/smoke/smoke_multi_car_context.sh`, `tests/smoke/smoke_cars_crud.sh`, `tests/smoke/smoke_cli.sh`). (2026-03-22)
- [General] Stations/Validation: Plausibilitaets-Guardrails in `--add stations` und `--edit stations` geschaerft. Neue Pruefungen blockieren offensichtliche Fehlbelegungen (u. a. nicht-numerische `zip`, numerische `city`, `house_no` ohne Ziffer, `phone` ohne Ziffer) und erkennen den typischen Shift-Fall `zip`/`city` mit klarem Hinweis (`P-080` bis `P-084`). Domain-Policy-Abdeckung um `t_p080__01__station_zip_city_shift_rejected.sh`, `t_p080__02__station_valid_master_data_accepts.sh`, `t_p081__01__station_zip_non_numeric_rejected.sh` und `t_p084__01__station_phone_without_digits_rejected.sh` (Fixture `p080_base.sql`) erweitert; Policy-Doku in `tests/domain_policy/p080.md` und `tests/domain_policy/README.md` synchronisiert. (2026-03-21)
- [General] Tests/Smoke: Resolver-Matrix in `tests/smoke/smoke_multi_car_context.sh` auf den zusaetzlichen `P-050`-Prompt synchronisiert. Die interaktiven Input-Sequenzen fuer zweite Fuelups im 1-Car- sowie >1-Cars-Pfad beantworten den Confirm jetzt explizit, sodass der Lauf nicht mehr mit EOF abbricht. Re-Check: `tests/smoke/smoke_multi_car_context.sh` und `tests/smoke/smoke_clean_home.sh -c` laufen wieder gruen. (2026-03-22)
- [General] Fuelups/Validation: Neue Cross-Field-Policy `P-033` fuer starke Abweichungen zwischen `Gesamtpreis`, `Liter` und `Preis/Liter` eingefuehrt (Warning+Confirm mit dokumentierter Rundungs-/Toleranzregel: erwarteter Gesamtpreis aus `liters_ml * price_per_liter_milli_eur`, Toleranz `<= 10` Cent). Bei Abbruch wird der Write-Pfad sauber blockiert. Domain-Policy-Abdeckung um `t_p033__01__price_total_mismatch_warn_yes.sh` und `t_p033__02__price_total_mismatch_warn_no.sh` inkl. Fixture `p033_base.sql` erweitert; Policy-Doku in `tests/domain_policy/p033.md` und `tests/domain_policy/README.md` synchronisiert. (2026-03-21)
- [General] Fuelups/Bootstrap-Hardening: Interaktive Fuelup-Eingaben lesen stdin jetzt EOF-sicher. `--add fuelups` bricht bei leerer DB ohne Prompt-Schleife sauber mit Hinweis auf fehlende Tankstellen ab, und die Car-/Stationsauswahl nutzt einen gemeinsamen EOF-geschuetzten Dialogpfad. Smoke-Abdeckung um `--seed -> --demo --list stations` sowie den nicht-interaktiven EOF-Fall fuer `--add fuelups` erweitert. (2026-03-21)
- [General] Docs/Backlog: Zwei neue kanonische Vorschlags-Backlogs aufgenommen: `BL-0023` fuer ein kuratiertes Dev-Diary als Projektchronik und `BL-0024` fuer eine kleine persoenliche Wiki-Notiz zu Cookie inklusive optionaler Bild-Einbindung. Backlog-Index in `docs/BACKLOG.md` synchronisiert. (2026-03-21)
- [General] Repo/Cleanup: Lokale Codex-Konfigurationen werden jetzt ueber `.gitignore` aus dem Repo herausgehalten (`.codex/`). Projektweite Editor-Konventionen bleiben weiterhin ueber `.editorconfig` versioniert. (2026-03-20)
- [General] QA/Docs/Tracker: Neue kanonische Teststrategie `docs/TEST_MATRIX.md` eingefuehrt. Das Dokument trennt jetzt bewusst zwischen Teststrategie/Coverage (`docs/TEST_MATRIX.md`), ausfuehrbaren Reposuiten (`tests/README.md`) und konkreten reproduzierbaren Nutzertest-Funden (`docs/issues/ISS-0002` bis `ISS-0006`, `docs/backlog/BL-0022`). Entry-Doku (`README.md`, `docs/README.md`), Testdoku (`tests/README.md`) und Backlog-Index (`docs/BACKLOG.md`) wurden auf diese Leitplanke synchronisiert; zusaetzlich ist die UX-Spur fuer Erststart- und Mehrfahrzeug-Fuehrung jetzt explizit als Tracker-Artefakt verankert. (2026-03-20)
- [S22C3/3] Release/Docs: Gate 4 der 1.2.0-Linie formal abgeschlossen. RC-Abschlussnachweis dokumentiert mit lokalem Volllauf `make verify` (gruen) sowie CI-Referenz auf `main` (`CI` Run `23307738745`, Commit `3e9be17`, `success`). Gate-Status auf Gate 4 `abgeschlossen` / Gate 5 `aktiv` synchronisiert (`docs/ROADMAP_1_2_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/RELEASE_1_2_0_PREFLIGHT.md`, `docs/SPRINTS.md`). (2026-03-19)
- [S22C2/3] Release/Docs: Gate-4-RC-Checklisten-/Feature-Freeze-Snapshot fuer die 1.2.0-Linie auf den aktuellen Scope-Stand fortgeschrieben. `docs/RELEASE_1_2_0_PREFLIGHT.md` enthaelt jetzt einen expliziten RC-Snapshot (Scope-Freeze intakt, Doku-Gates konsistent, offene Exit-Schritte fuer `S22C3/3`), und Roadmap-/Status-/Entry-/Sprint-Doku wurden auf den aktiven Gate-4-Fortschritt synchronisiert (`docs/ROADMAP_1_2_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). (2026-03-19)
- [General] Meta/Process: Neues Referenzdokument `docs/GIT_WORKFLOW.md` eingefuehrt und als kanonische Leitplanke fuer Branch-/Commit-/PR-/Merge-Entscheidungen verankert (1 Sprint = 1 Branch/1 PR, Merge-Commit als Standard, Squash als Ausnahme, Rebase-Merge aus). `AGENTS.md` auf denselben Standard harmonisiert (Sync-Flow auf `fetch` + `pull --ff-only`, Verweis auf `docs/GIT_WORKFLOW.md`) und Entry-Doku-Navigation in `docs/README.md` erweitert. (2026-03-19)
- [General] Roadmap/Release-Flow: Gate-Stand der 1.2.0-Linie auf den naechsten operativen Abschnitt fortgeschrieben. Gate 3 ist formal abgeschlossen (`BL-0020` + `BL-0021` auf `done`, Hardening-Checklist auf Abschlussstand), Gate 4 ist aktiv (RC-Haertung/Preflight-Snapshot). Doku-Sync in `docs/ROADMAP_1_2_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/CONTRACT_HARDENING_1_2_0.md`, `docs/RELEASE_1_2_0_PREFLIGHT.md` und `docs/SPRINTS.md`. (2026-03-19)
- [General] Meta/Process: Merge-Strategie in `AGENTS.md` als Decision-Matrix praezisiert. `Create a merge commit` ist fuer sprintgebundene Multi-Commit-PRs mit Hash-Traceability der Standard; `Squash and merge` ist fuer WIP-/Fixup-lastige PRs mit kuratiertem Einzelcommit vorgesehen; bei Ein-Commit-PRs sind beide Varianten zulaessig mit Praeferenz fuer `merge commit` bei hash-pflichtigen Sprint-Commits. (2026-03-19)
- [General] Meta/Process: `AGENTS.md` auf den Git-Workflowwunsch synchronisiert (`Stand` aktualisiert). Commit+Push-Uebernahme durch Codex ist explizit als Standard auf Wunsch festgehalten; Sprint-Tagging bleibt auf abgeschlossene/freigegebene Sprints begrenzt, und Release-/Version-Tags (z. B. `1.2.0`) duerfen nur nach expliziter User-Freigabe erstellt/gepusht werden. (2026-03-19)
- [General] Docs/Root-README: Project-State-Block auf den aktuellen Release-/Dev-Stand korrigiert (`Latest release: 1.1.0` vom 2026-03-18, `Current development line: 1.2.0-dev`) und Datumsstand der Seite synchronisiert. (2026-03-18)
- [General] Fuelups/Receipt-Link: Optionalen Beleg-Link fuer neue Fuelups eingefuehrt (`--receipt-link` nur mit `--add fuelups`) inklusive Guardrails fuer Scope, leere Werte, Steuerzeichen und Laengenlimit. Additives Datenfeld `fuelups.receipt_link` in Core-/Seed-Schema inkl. idempotenter Migration nachgezogen; Detailausgabe zeigt gesetzte Links (`Receipt link: ...`). Fuelups-JSON (full/monthly/yearly) erweitert um `receipt_links_set` und `receipt_links_missing`, Export-Contract und Nutzerdoku synchronisiert. Neue Regression `tests/regression/run_receipt_link_contract_check.sh` sowie Verify-Verdrahtung via `make receipt-link-check` und `make verify`. Tracker-/Roadmap-/Status-/Hardening-/Sprint-Doku fuer `BL-0021` und `TSK-0010`/`TSK-0011` auf `done` gesetzt. (2026-03-18)
- [S20C4/4] Ops/Backup: Ersten regressionssicheren Gate-3-Lieferstand fuer die 1.2.0-Linie geliefert. Neuer Runner `scripts/db_backup_ops.sh` implementiert Multi-DB-Backups fuer `--db` (single) und `--all --source-dir` inkl. Dry-Run, Integritaetsmetadaten (`metadata.json`), Laufindex (`.backup/db_ops/index.json`) und Retention (`--keep`). Dedizierte Regression `tests/regression/run_db_backup_ops_check.sh` eingefuehrt und in `make verify` verdrahtet (`Makefile`: neues Target `db-backup-ops-check`). Tracker-/Doku-Sync: `BL-0020` sowie `TSK-0008`/`TSK-0009` auf `done`; Roadmap-/Status-/Entry-/Sprint-/Testdoku aktualisiert. (2026-03-18)
- [S20C3/4] Planning/Quality: Verify-/Contract-DoD fuer Gate 3 der 1.2.0-Linie konkretisiert. Neue Leitdokumente `docs/CONTRACT_HARDENING_1_2_0.md` (Hardening-Matrix/Exit-Kriterien) und `docs/RELEASE_1_2_0_PREFLIGHT.md` (Preflight-Blueprint + Doku-Gates) eingefuehrt; Roadmap-/Status-/Sprint-/Entry-Doku auf den DoD-Stand synchronisiert (`docs/ROADMAP_1_2_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`). (2026-03-18)
- [General] Planning/Roadmap: Verbindlichen Fahrplan fuer die 1.2.0-Linie eingefuehrt (`docs/ROADMAP_1_2_0.md`) und Gate-Stand auf aktiven Zyklus synchronisiert: Gate 1 und Gate 2 abgeschlossen (Zyklusstart + Scope-Freeze), Gate 3 aktiv. Verbindliche Folge-Reihenfolge fuer die naechsten Versionsspruenge festgelegt (`1.3.0`: Option B mit `BL-0017`/`BL-0018`; `1.4.0`: Option C mit `BL-0016`/`BL-0011`). (2026-03-18)
- [General] Tracker/Versioning: Scope-Freeze fuer 1.2.0 im kanonischen Tracker festgezogen (`BL-0020` und `BL-0021` auf `approved`, Lane `release-blocking`) und Downstream-Tasks `TSK-0008` bis `TSK-0011` angelegt. Entwicklungsbasis auf `APP_VERSION=1.2.0-dev` umgestellt (`src/Betankungen.lpr`), Doku-Sync in `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md` und `docs/BACKLOG.md`. (2026-03-18)
- [S19C4/4] Release/Docs: Finalen 1.1.0-Release abgeschlossen. `src/Betankungen.lpr` wurde auf `APP_VERSION=1.1.0` gesetzt; Gate 5 ist in `docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md` und `docs/RELEASE_1_1_0_PREFLIGHT.md` als abgeschlossen dokumentiert. Finale Release-/Backup-Ausfuehrung wurde erfolgreich ausgefuehrt (`./kpr.sh --note "Release 1.1.0 final"`, `scripts/backup_snapshot.sh --note "Backup after release 1.1.0"`), inkl. Artefakt `.releases/Betankungen_1_1_0.tar` (SHA-256 `f3c1f5ef4a8daa3a5a1cf9d4cb74c871c2799c1338e1eafe2422a6bfbeb026f3`) und Snapshot `.backup/2026-03-18_1331`. (2026-03-18)
- [General] Release: Version `1.1.0` final freigegeben. Gate 5 der 1.1.0-Linie ist abgeschlossen; Release-Artefakt und Direkt-Backup wurden ausgefuehrt (`./kpr.sh --note "Release 1.1.0 final"`, `scripts/backup_snapshot.sh --note "Backup after release 1.1.0"`). (2026-03-18)
- [S19C3/4] Release/Docs: Gate-5-Release-Umschaltpaket fuer `1.1.0` vorbereitet, ohne vorgezogenen Versionswechsel. `docs/RELEASE_1_1_0_PREFLIGHT.md` dokumentiert jetzt explizit die finalen Umschaltdateien (`src/Betankungen.lpr`, `docs/STATUS.md`, `docs/ROADMAP_1_1_0.md`, `docs/SPRINTS.md`, `docs/CHANGELOG.md`) und den operativen Ablauf nach Freigabe (Release-Umschalt-Commit, Doku-Finalsync, Release-/Backup-Ausfuehrung). Roadmap-/Status-/Entry-/Sprint-Doku auf den Abschlussblock `S19C4/4` synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). (2026-03-18)
- [S19C2/4] Release/Docs: Gate-5-Checklisten-/Scope-Snapshot fuer die 1.1.0-Linie dokumentiert. `docs/RELEASE_1_1_0_PREFLIGHT.md` enthaelt jetzt einen expliziten Gate-5-Snapshot (Gate-Konsistenz, `APP_VERSION=1.1.0-dev` bis Finalisierung, release-blockierender Scope ohne Drift, aktive BL-Lanes) inkl. aktueller CI-Referenz auf `main` (`CI`-Run `23243226276`, Commit `6088568`). Roadmap-/Status-/Entry-/Sprint-Doku auf den naechsten operativen Fokus `S19C3/4` synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). (2026-03-18)
- [S19C1/4] Planning/Tracker: Gate-5-Kickoff fuer die 1.1.0-Linie dokumentiert und eine leichte BL-Lane-Sortierung eingefuehrt (`release-blocking`/`planned`/`exploratory`). Die Lane-Regeln sind in `docs/policies/POL-001-tracker-standard.md` und `docs/backlog/README.md` verankert; der Backlog-Index wurde um Lane-Hinweise erweitert (`docs/BACKLOG.md`) und offene BL-Eintraege `BL-0016` bis `BL-0021` tragen die Lane als Tag (`lane:*`). Roadmap-/Status-/Entry-/Sprint-Doku auf den Gate-5-Kickoff synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). (2026-03-18)
- [S18C4/4] Release/Docs: Gate 4 fuer die 1.1.0-Linie formal abgeschlossen und den Handover auf Gate 5 finalisiert. `docs/ROADMAP_1_1_0.md` fuehrt Gate 4 jetzt als `abgeschlossen am 2026-03-18`; `docs/STATUS.md` und `docs/README.md` zeigen den operativen Fokus auf Gate 5. `docs/RELEASE_1_1_0_PREFLIGHT.md` dokumentiert den Gate-4-Closeout-Nachweis und den naechsten Finalisierungsblock fuer Gate 5. `docs/SPRINTS.md` setzt Sprint 18 inkl. `S18C4/4` auf `done`. (2026-03-18)
- [S18C3/4] Release/Verification: RC-Abschlusslauf fuer Gate 4 dokumentiert. Lokaler Voll-Preflight lief gruen (`make release-preflight-1-1-0`, inkl. `make verify`, Doku-Gates sowie Release-/Backup-Dry-Runs) und die CI-Referenz auf `main` wurde auf den aktuellen Stand `23241536267` (`success`, Commit `6b1a0c1`) aktualisiert. Roadmap-/Status-/Entry-/Sprint-Doku auf den verbleibenden Gate-4-Closeout `S18C4/4` synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`, `docs/RELEASE_1_1_0_PREFLIGHT.md`). (2026-03-18)
- [S18C2/4] Release/Docs: RC-Checkliste und Feature-Freeze-Snapshot fuer Gate 4 auf den aktuellen 1.1.0-Stand synchronisiert. `docs/RELEASE_1_1_0_PREFLIGHT.md` enthaelt jetzt explizite Snapshot-Abschnitte (Gate-Konsistenz, Versionierungs-/Governance-Guardrails, in-scope vs. non-blocking/out-of-scope). Roadmap-/Status-/Entry-/Sprint-Doku auf den naechsten operativen Fokus `S18C3/4` nachgezogen (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). (2026-03-18)
- [S18C1/4] Planning/Tracker: Gate-4-Kickoff fuer die 1.1.0-Linie dokumentiert und den RC-Hardening-Block gestartet. Roadmap-/Status-/Entry-/Preflight-/Sprint-Doku auf den aktiven Gate-4-Fokus synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/RELEASE_1_1_0_PREFLIGHT.md`, `docs/SPRINTS.md`). Zusaetzlich neuen nicht-blockierenden Backlog-Vorschlag `BL-0021` fuer externe Tankbeleg-Foto-Links im kanonischen Tracker erfasst (`docs/backlog/BL-0021-receipt-photo-link-references/item.md`, `docs/BACKLOG.md`). (2026-03-18)
- [S17C4/4] Release/Docs: Gate 3 fuer die 1.1.0-Linie formal abgeschlossen. Der finale Abschlusslauf (`make release-preflight-1-1-0`, inkl. Vollsuite `make verify`) ist dokumentiert; `docs/CONTRACT_HARDENING_1_1_0.md` wurde auf `abgeschlossen` gesetzt. Roadmap-/Status-Flip vollzogen (`Gate 3 abgeschlossen am 2026-03-17`, `Gate 4 aktiv`) und RC-Preflight-Stand auf Gate 4 fortgeschrieben (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/RELEASE_1_1_0_PREFLIGHT.md`, `docs/SPRINTS.md`, `docs/README.md`). (2026-03-17)
- [S17C3/4] Release/Docs: Gate-3-Closeout-Nachweise fuer die 1.1.0-Linie verdichtet. `docs/CONTRACT_HARDENING_1_1_0.md` setzt `Policy-Fit` auf `done` und dokumentiert lokalen/CI-Nachweis (`make release-preflight-1-1-0`, CI-Run `23207955306` auf `main`). `docs/RELEASE_1_1_0_PREFLIGHT.md` enthaelt jetzt Gate-3-Snapshot, RC-Handover-Stand und den verbleibenden Abschlussschritt `S17C4/4`; Roadmap-/Status-/Entry-/Sprint-Doku wurden auf den Closeout-Stand synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). (2026-03-17)
- [S17C2/4] Release/Preflight: Operativen 1.1.0-Readiness-Preflight eingefuehrt (`scripts/release_preflight_1_1_0.sh`) und via `make release-preflight-1-1-0` verdrahtet. Das Skript prueft Versionierungs-Guardrails (`APP_VERSION=1.1.0-dev`), Scope-/Tracker-/Contract-Doku-Gates (`BL-0014`, `BL-0015`, `TSK-0006`, Hardening-/Roadmap-/Preflight-Doku), optional `make verify` sowie Release-/Backup-Dry-Runs. Tracker-/Gate-Sync: `TSK-0007` und `BL-0015` auf `done`, Gate-3-Matrix und Entry-/Status-/Roadmap-/Sprint-Doku aktualisiert. (2026-03-17)
- [S17C1/4] Contract/QA/Tracker: Manifest-v1-Contract fuer Export-Pakete eingefuehrt (`docs/EXPORT_PACKAGE_CONTRACT.md`), reproduzierbare Dry-Run-Fixtures fuer valid/invalid Bundles angelegt (`tests/regression/fixtures/package_manifest_v1/`) und optionalen lokalen Fixture-Runner umgesetzt (`tests/regression/run_package_manifest_fixture_check.sh`, `make package-manifest-check`). Tracker-/Gate-Sync: `TSK-0006` und `BL-0014` auf `done`, Hardening-Matrix auf aktualisierten Gate-3-Stand synchronisiert (`docs/CONTRACT_HARDENING_1_1_0.md`, `docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`, `docs/BACKLOG.md`, `tests/README.md`, `tests/regression/README.md`). (2026-03-17)
- [General] Tracker/Backlog: Vier neue Vorschlags-Backlogs fuer den Raspberry-Pi-/Docker-Betrieb aufgenommen: `BL-0017` (kostenlose Tankstellenpreis-API-Evaluation), `BL-0018` (15-Minuten-Preis-Polling mit Historienablage), `BL-0019` (Tankstellen-Geodaten/Plus-Codes) und `BL-0020` (Backup-Operationen fuer einzelne/alle Datenbanken). Kanonischer Backlog-Index synchronisiert (`docs/BACKLOG.md`). (2026-03-17)
- [S16C4/4] Planning/Tracker: Sprint-16-Kickoff als Gate-3-Handover abgeschlossen. Roadmap-/Status-/Entry-/Sprint-Doku auf den aktiven Umsetzungsblock synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`) und den optionalen Community-Standards-Follow-up als explizit nicht-blockierenden Tracker-Eintrag aufgenommen (`docs/backlog/BL-0016-community-standards-baseline/item.md`, `docs/BACKLOG.md`). (2026-03-17)
- [S16C3/4] Planning/Quality: Verify-/Contract-DoD fuer Gate 3 der 1.1.0-Linie konkretisiert. Neue Leitdokumente `docs/CONTRACT_HARDENING_1_1_0.md` (Hardening-Matrix/Exit-Kriterien) und `docs/RELEASE_1_1_0_PREFLIGHT.md` (Preflight-Blueprint + Doku-Gates) eingefuehrt; Roadmap-/Status-/Sprint-/Entry-Doku auf den DoD-Stand synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`). (2026-03-17)
- [S16C2/4] Planning/Tracker: Gate-2-Scope-Freeze fuer die 1.1.0-Linie festgezogen. `BL-0014` wurde auf `approved` angehoben und mit `TSK-0006` konkretisiert (Manifest-v1 + Dry-Run-Fixtures); zusaetzlich wurde `BL-0015` als dedizierter Hardening-Block mit `TSK-0007` neu angelegt (Release-/Verify-Haertung 1.1.0). Roadmap-/Status-/Sprint-/Entry-Doku auf Gate-2-Abschluss synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`, `docs/BACKLOG.md`). (2026-03-16)
- [General] Roadmap/Planning: Aktiven 1.1.0-Gate-Plan eingefuehrt (`docs/ROADMAP_1_1_0.md`) und als verbindlichen Zyklusrahmen in Entry-/Status-/Sprint-Doku verankert (`docs/README.md`, `docs/STATUS.md`, `docs/SPRINTS.md`). Gate 1 ist damit als abgeschlossen dokumentiert, Gate 2 (Scope-Freeze) als naechster operativer Fokus gesetzt. (2026-03-16)
- [General] Versioning: Nach finaler Freigabe von `1.0.0` wurde die aktive Entwicklungsbasis auf die naechste Linie angehoben (`src/Betankungen.lpr`: `APP_VERSION=1.1.0-dev`). Entry-/Status-Doku auf den neuen Dev-Start synchronisiert (`docs/README.md`, `docs/STATUS.md`). (2026-03-16)
- [General] Release: Version `1.0.0` final freigegeben. `src/Betankungen.lpr` wurde von `APP_VERSION 1.0.0-dev` auf `1.0.0` umgestellt. Gate 5 ist als abgeschlossen dokumentiert (`docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/RELEASE_1_0_0_PREFLIGHT.md`, `docs/SPRINTS.md`, `docs/README.md`). Release-Artefakt und Direkt-Backup wurden ausgefuehrt (`./kpr.sh --note "Release 1.0.0 final"`, `scripts/backup_snapshot.sh --note "Backup after release 1.0.0"`); Artefakt `.releases/Betankungen_1_0_0.tar` (SHA-256 `9ebde5b6ffec7197688dd5ae71f035b66f8f874fe18b38d01aff4939f295f5c1`) und Snapshot `.backup/2026-03-16_1736`. (2026-03-16)
- [S15C4/4] Release/Docs: Gate 4 (RC-Haertung) als abgeschlossen dokumentiert und der Handover auf Gate 5 finalisiert. `docs/ROADMAP_1_0_0.md` fuehrt Gate 4 jetzt als `abgeschlossen am 2026-03-16`; `docs/RELEASE_1_0_0_PREFLIGHT.md` enthaelt das Gate-4-Abschlussnarrativ mit den verbleibenden finalen Schritten (`APP_VERSION -> 1.0.0`, finaler Doku-Sync, Release-/Backup-Ausfuehrung nach Freigabe). Status-/Sprint-/Entry-Doku entsprechend synchronisiert (`docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`). (2026-03-16)
- [S15C3/4] Release/Verification: RC-Abschlusslauf fuer Gate 4 dokumentiert. Lokaler Voll-Preflight lief gruen (`make release-preflight-1-0-0`, inklusive `make verify`, Doku-Gates sowie Release-/Backup-Dry-Runs) und ist in `docs/RELEASE_1_0_0_PREFLIGHT.md` als Nachweis verankert. Roadmap-/Status-/Sprint-/Entry-Doku auf den Abschlussstand `S15C3/4 done` synchronisiert (`docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`) und CI-Referenz auf `main` dokumentiert (`https://github.com/SirKenvelo/Betankungen/actions/runs/23153384396`). (2026-03-16)
- [S15C2/4] Release/Docs: RC-Checkliste und Scope-Freeze auf den aktuellen Gate-Stand nachgezogen. `docs/RELEASE_1_0_0_PREFLIGHT.md` enthaelt jetzt einen expliziten RC-Status-Snapshot (Gate 1/2/3 abgeschlossen, Gate 4 aktiv), die 1.0.0-Checkliste fordert dokumentierte Gate-Konsistenz, und Roadmap-/Status-/Entry-/Sprint-Doku wurden auf S15C2 synchronisiert (`docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). Governance-Text auf Solo-Maintainer-Betrieb ohne verpflichtende Approvals vereinheitlicht. (2026-03-16)
- [S15C1/4] Release/Preflight: 1.0.0-Preflight um Gate-Status-/Doku-Guardrails erweitert. `scripts/release_preflight_1_0_0.sh` validiert jetzt zusaetzlich `CONTRACT_HARDENING=done` sowie den dokumentierten Gate-2-Abschluss in `docs/ROADMAP_1_0_0.md` und `docs/STATUS.md` (optional deaktivierbar via `--skip-doc-gates`). Preflight-Doku und Gate-4-Status synchronisiert (`docs/RELEASE_1_0_0_PREFLIGHT.md`, `docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). (2026-03-15)
- [S13C4/4] QA/Docs: Gate-2-Abschlusslauf abgeschlossen und dokumentiert. `make verify` lief gruen; die Contract-Hardening-Checklist zeigt keine offenen 1.0.0-Blocker mehr (`docs/CONTRACT_HARDENING_1_0_0.md`). Gate-Status wurde auf `abgeschlossen` synchronisiert (`docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`), Sprint 13 auf `done` fortgeschrieben (`docs/SPRINTS.md`) und der Roadmap-Kurzstand in `docs/README.md` angeglichen. (2026-03-15)
- [S13C3/4] Contract/Docs: Deprecation-Sichtbarkeit gemaess `POL-002` finalisiert. `docs/EXPORT_CONTRACT.md` enthaelt jetzt den expliziten Abschnitt `Deprecation Status` (Stand: keine aktiven Deprecations) sowie klarere Integrationszustandsregeln fuer `--stats cost --maintenance-source none|module` inkl. Fallback-Semantik. Modul-/Entry-Doku auf Contract-Evolution synchronisiert (`docs/MODULES_ARCHITECTURE.md`, `docs/README.md`, `docs/README_EN.md`) und Gate-2-Tracking auf den verbleibenden Abschlusslauf `S13C4/4` nachgezogen (`docs/CONTRACT_HARDENING_1_0_0.md`, `docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`). (2026-03-15)
- [S13C2/4] QA/CI/Contract: Neuer zentraler CSV-Export-Regression-Check `tests/regression/run_export_contract_csv_check.sh` validiert den Contract aus `docs/EXPORT_CONTRACT.md` gegen reale CLI-Ausgaben (`--stats fuelups --csv`) inklusive Guardrail fuer die ungueltige Kombination `--yearly --csv`. Verify-/CI-Verdrahtung erweitert (`Makefile`: `contract-check-json` + `contract-check-csv`; `.github/workflows/ci.yml`: Schritt `Export-Contract CSV check`). Testdoku synchronisiert (`tests/regression/README.md`, `tests/README.md`) und Gate-2-Fortschritt in Contract-/Roadmap-/Status-Doku nachgezogen (`docs/CONTRACT_HARDENING_1_0_0.md`, `docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`). (2026-03-15)
- [S13C1/4] Contract/Docs: Gate-2-Restscope konkretisiert durch neue Policy-abgeleitete Checkliste `docs/CONTRACT_HARDENING_1_0_0.md` (Matrix fuer JSON/CSV/CLI inkl. Nachweisstand, Exit-Kriterien und verbleibende S13-Risiken). Roadmap-/Status-/Sprint-/Preflight-/Entry-Doku auf den neuen Arbeitsstand synchronisiert (`docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/RELEASE_1_0_0_PREFLIGHT.md`, `docs/README.md`). (2026-03-15)
- [General] Roadmap/Gate-Sync: Public-Readiness auf finalen Ist-Stand synchronisiert. `BL-012` auf `done` gesetzt (`docs/BACKLOG/BL-012-github-wiki-enablement.md`, Index `docs/BACKLOG.md`), Gate 3 (S14) als abgeschlossen dokumentiert (`docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`) und Sprint 12 finalisiert (`docs/SPRINTS.md`: `S12C4/4` + Sprintstatus `done`). Governance-Text auf aktuellen Solo-Maintainer-Betrieb praezisiert (`required_approving_review_count=0` bei aktivem Review-Block). Sprint 13 fuer verbleibenden Gate-2-Restscope initialisiert. (2026-03-15)
- [General] Wiki/Navigation: Interne Wiki-Startlinks auf gerenderte Seitenpfade umgestellt (ohne `.md`-Suffix), damit `Start Here` nicht mehr auf `raw.githubusercontent.com/wiki/...` sondern auf GitHub-Wiki-Seiten rendert. Betroffen: `docs/wiki/Home.md` und `docs/wiki/FAQ-Troubleshooting.md`. `scripts/wiki_link_check.sh` um Guardrails fuer interne Wiki-Links ohne `.md` erweitert. (2026-03-15)
- [General] Wiki/Docs: Broken Source-of-Truth-Links im GitHub-Wiki behoben (Issue `#3`). Die betroffenen Wiki-Seiten (`Home`, `Getting-Started`, `CLI-Quick-Reference`, `Architecture-Short-Guide`, `FAQ-Troubleshooting`, `Troubleshooting-Playbooks`) verwenden fuer Repo-Dokumente jetzt stabile absolute `blob/main`-URLs statt Wiki-relativer `../`-Pfade. `scripts/wiki_link_check.sh` wurde gehaertet: Pflichtmuster auf absolute Repo-Links umgestellt und Guardrail fuer verbotene `../`-Repo-Links in Wiki-Seiten ergaenzt. (2026-03-15)
- [General] Meta/Process: `AGENTS.md` fuer den oeffentlichen Repo-Betrieb nachgeschaerft. Verbindlicher PR-Standard fuer geschuetztes `main` ergaenzt (Branch->PR->Merge, `Summary`+`Validation` in PRs, Branch-Cleanup nach Merge, dokumentierte Ausnahmefaelle) sowie Public-Security-Hygiene festgezogen (keine Secrets, nur synthetische Testdaten, reduzierte Systemdetails in oeffentlichen Logs). (2026-03-15)
- [General] Governance/Workflow: PR-Flow auf `main` verbindlich gemacht. Branch-Protection ist jetzt aktiv mit Required-Check `verify` (strict up-to-date), PR-Pflicht, Conversation-Resolution, Admin-Enforcement sowie deaktivierten Force-Pushes/Deletes. Damit erfolgt Merge nach `main` nur noch ueber Branch + Pull Request. (2026-03-15)
- [General] Release/Readiness: Standardisierten 1.0.0-Preflight eingefuehrt (`scripts/release_preflight_1_0_0.sh`, `make release-preflight-1-0-0`) inkl. neuer Checkliste `docs/RELEASE_1_0_0_PREFLIGHT.md` und Gate-Sync in `docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`. Der 1.0.0-Preflight prueft strikt `APP_VERSION=1.0.0-dev`, fuehrt optional den Voll-Gate-Lauf (`make verify`) aus und sichert Release-/Backup-Werkzeuge per Dry-Run ab. (2026-03-15)
- [General] Public-Readiness/Wiki: GitHub-Wiki ist jetzt live und initial befuellt. Nach der Initialisierung wurde das Wiki-Repo `SirKenvelo/Betankungen.wiki.git` erfolgreich synchronisiert; `Home` sowie die v1-Seiten (`Getting-Started`, `CLI-Quick-Reference`, `Architecture-Short-Guide`, `FAQ-Troubleshooting`, `Troubleshooting-Playbooks`) sind veroeffentlicht. Der zuvor dokumentierte Remote-Blocker ist damit aufgeloest. (2026-03-15)
- [General] Repo/Visibility: Repository auf `public` umgestellt (2026-03-15) und Wiki-Feature per REST auf `has_wiki=true` gesetzt. Aktueller technischer Folgestatus: Das Wiki-Webziel (`/wiki`) redirectet weiterhin auf die Repo-Startseite und das Git-Remote `SirKenvelo/Betankungen.wiki.git` antwortet noch mit `Repository not found`; die automatische Wiki-Synchronisierung aus `docs/wiki/` bleibt bis zur erfolgreichen Remote-Initialisierung pending. (2026-03-15)
- [General] Process/Wiki: `AGENTS.md` um verbindliche Wiki-Pflegeregeln erweitert (`docs/wiki/` als redaktionelle Quelle, Pflichtlauf `make wiki-link-check`, klarer Publish-Flow inkl. Blocker-Transparenz). Technischer Stand beim Publish-Versuch am 2026-03-15: GitHub-Feature-Flags zeigen Wiki aktiviert, das zugehoerige Wiki-Remote (`SirKenvelo/Betankungen.wiki.git`) ist aktuell dennoch nicht erreichbar (`Repository not found`). (2026-03-15)
- [General] Public-Readiness/Wiki: `TSK-0005` abgeschlossen und Wiki-v1-Basispaket als versionierte Quellseiten eingefuehrt (`docs/wiki/Home.md`, `docs/wiki/Getting-Started.md`, `docs/wiki/CLI-Quick-Reference.md`, `docs/wiki/Architecture-Short-Guide.md`, `docs/wiki/FAQ-Troubleshooting.md`, `docs/wiki/Troubleshooting-Playbooks.md`, `docs/wiki/README.md`). Link-Governance operationalisiert ueber neues Skript `scripts/wiki_link_check.sh` und Make-Target `make wiki-link-check`; Entry-Verweise in `README.md`/`CONTRIBUTING.md` und Gate-/Status-Sync in `docs/BACKLOG/BL-012-github-wiki-enablement.md`, `docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/BACKLOG.md`. (2026-03-15)
- [General] Performance/Benchmark: Optionalen Stats-Benchmark-Harness umgesetzt (`tests/benchmark/run_stats_benchmark.sh`) inklusive reproduzierbarer Fixture-Nutzung (`Betankungen_Big.db`), definierter Messfaelle (`fuelups_text`, `fuelups_json`, `fleet_json`, `cost_json_none`, `cost_json_scoped`) und optionalem JSON-Protokoll-Output. `Makefile` um `make stats-benchmark` erweitert; Doku-Sync in `tests/README.md` und `docs/README.md`. Tracker-Sync: `BL-0013` sowie `TSK-0004` auf done inkl. initialem Baseline-Protokoll im Backlog-Item. (2026-03-15)
- [General] Module-Contract: `--module-info` fuer das Companion-Modul um den additiven `capabilities`-Block erweitert (stabile boolesche Keys: `supports_migrate`, `supports_add_maintenance`, `supports_list_maintenance`, `supports_stats_maintenance`, `supports_stats_json`, `supports_stats_pretty`, `supports_car_scope`, `supports_period_scope`). Runtime in `u_module_info`/`betankungen-maintenance` umgesetzt und Module-Smoke auf compact/pretty-Contract inkl. Capabilities gehaertet. Doku-Sync in `docs/MODULES_ARCHITECTURE.md`, `docs/EXPORT_CONTRACT.md`, `tests/README.md`; Tracker-Sync: `BL-0012` sowie `TSK-0002`/`TSK-0003` auf done. (2026-03-15)
- [General] Roadmap/Gates: Gate-Plan 1.0.0 operativ gestartet. Gate 1 (S12) ist als abgeschlossen dokumentiert und Gate 2 als aktiv markiert (`docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`). Tracker-Downstream fuer den 1.0.0-Zyklus umgesetzt: neue Tasks `TSK-0002`/`TSK-0003` zu `BL-0012`, `TSK-0004` zu `BL-0013` und `TSK-0005` zu `BL-012` angelegt; Backlog-Referenzen entsprechend synchronisiert (`docs/backlog/BL-0012-module-capability-discovery/item.md`, `docs/backlog/BL-0013-stats-performance-benchmark-harness/item.md`, `docs/BACKLOG/BL-012-github-wiki-enablement.md`). (2026-03-15)
- [General] Roadmap/Versioning: Verbindlichen Gate-Plan bis `1.0.0` eingefuehrt (`docs/ROADMAP_1_0_0.md`) und in die Entry-Doku verankert (`docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). Entwicklungsbasis auf die neue Linie angehoben (`src/Betankungen.lpr`: `APP_VERSION 1.0.0-dev`). (2026-03-15)
- [General] Release: 0.9.0 final freigegeben. `src/Betankungen.lpr` auf `APP_VERSION 0.9.0` gesetzt und Release-Doku auf den finalen Stand synchronisiert (`docs/STATUS.md`, `docs/RELEASE_0_9_0_PREFLIGHT.md`). `[Unreleased]` wurde auf Zielversion `1.0.x` fuer den naechsten Entwicklungszyklus vorbereitet. (2026-03-15)
- [General] Tracker/Policy: Vorschlagsabgleich fuer 9 ADR/BL-Themen formalisiert. Duplikate in `BL-010` (Integrationscontract + Cost-Scope-UX bereits umgesetzt) markiert, Public-Readiness-Paket in `BL-012` konsolidiert (inkl. FAQ/Troubleshooting/Link-Check-Richtung), neue kanonische Folgeeintraege `BL-0012` (Module Capability Discovery), `BL-0013` (trigger-basierter Performance-Benchmark-Harness) und `BL-0014` (Import/Export-Paketformat als spaetere Forschungsarbeit) angelegt, neue Policies `POL-002` (Contract Evolution/Deprecation) und `POL-003` (Backup Retention/Restore/Privacy) eingefuehrt, sowie `ADR-0009` fuer Runtime-Config-Profile im Core auf `rejected` gesetzt. Doku-Sync in `docs/STATUS.md`, `docs/BACKLOG.md`, `docs/CONSTRAINTS.md`, `docs/ADR/README.md`. (2026-03-15)
- [S11C4/4] Release/Readiness: 0.9.0-Readiness-Paket finalisiert. Neuer lokaler Preflight `scripts/release_preflight.sh` fuehrt den standardisierten Freigabe-Vorcheck aus (Versionierungs-Guardrail auf `-dev`, optionaler Voll-Gate-Lauf via `make verify`, Dry-Runs fuer `kpr.sh` und `backup_snapshot.sh`); `Makefile` um Target `make release-preflight` erweitert. Scope-Freeze und Release-Checkliste in `docs/RELEASE_0_9_0_PREFLIGHT.md` verankert, Sprint-/Status-/Entry-Doku synchronisiert (`docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md`, `docs/BACKLOG/BL-010-cost-analytics.md`). (2026-03-14)
- [S11C3/4] QA/CI: Verify-Kette fuer Cost-Integration gehaertet. Neuer Regression-Check `tests/regression/run_cost_integration_modes_check.sh` validiert den Integrationscontract fuer beide Modi (`--maintenance-source none|module`) inklusive aktivem Companion-Pfad (`BETANKUNGEN_MAINTENANCE_BIN` + `BETANKUNGEN_MAINTENANCE_DB`) und expliziten Fallback-Szenarien (fehlendes Binary, period-gefilterter Modulmodus). Lokales Gate erweitert (`Makefile`: neues Target `cost-integration-check`, Aufnahme in `make verify`) und CI-Workflow um Pflichtschritt `Cost integration modes check` ergaenzt (`.github/workflows/ci.yml`). Doku-Sync in `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`, `docs/BACKLOG/BL-010-cost-analytics.md`, `tests/README.md`, `tests/regression/README.md`. (2026-03-14)
- [S11C2/4] Core/Stats: Cost-Integration `fuel + maintenance` aktiviert. Bei `--stats cost --maintenance-source module` liest der Core Maintenance-Kosten ueber den Companion-Contract `maintenance_stats_v1` (Process-Bridge in `units/u_stats.pas` mit JSON-Validierung von `maintenance.total_cost_cents`) und aggregiert sie in `maintenance_cents_total`/`total_cents`; bei nicht verfuegbarem Companion, Fehlern oder ungueltigem Modul-Output greift ein expliziter, robuster Fallback (`maintenance_source_active=false`, `maintenance_source_note` mit Ursache) statt Hard-Fail. Cost-Text/JSON wurden um transparente Integrationshinweise erweitert (`maintenance_source_note`, differenzierte Textmarkierung core/module/fallback), der fruehe Orchestrator-Blocker wurde entfernt (`src/Betankungen.lpr`), und die Smoke-Suites decken jetzt sowohl den Fallback-Pfad als auch den positiven Core↔Module-Integrationspfad ab (`tests/smoke/helpers/smoke_cost_helpers.sh`, `tests/smoke/smoke_cli.sh`, `tests/smoke/smoke_modules.sh`). Doku-/Contract-Sync in `docs/EXPORT_CONTRACT.md`, `docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`, `docs/BACKLOG/BL-010-cost-analytics.md`, `tests/README.md`. (2026-03-14)
- [S11C1/4] Core/Stats: Expliziten Integrationsmodus fuer Cost eingefuehrt. Neues Flag `--maintenance-source none|module` ist in CLI-Types/Parse/Validate/Help/Dispatch verdrahtet (`units/u_cli_types.pas`, `units/u_cli_parse.pas`, `units/u_cli_validate.pas`, `units/u_cli_help.pas`, `src/Betankungen.lpr`). Cost-Text/JSON-Contract zeigen den Modus transparent (`maintenance_source_mode`, `maintenance_source_active`) und Smokes/Validate-Policy decken den neuen Pfad regressionssicher ab (`tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`, `tests/smoke/helpers/smoke_cost_helpers.sh`, `tests/smoke/smoke_cli.sh`). Bis S11C2/4 bleibt `--maintenance-source module` bewusst ein klarer Not-Active-Fehler statt stiller Fallback. Doku-/Contract-Sync in `docs/EXPORT_CONTRACT.md`, `docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/BACKLOG/BL-010-cost-analytics.md`, `tests/README.md`. (2026-03-14)
- [S10C4/4] Tests/Contract: Modul-Qualitaetsgate fuer `betankungen-maintenance` gehaertet. `tests/smoke/smoke_modules.sh` prueft jetzt zusaetzlich negative Guardrail-Pfade (`--stats maintenance --pretty` ohne `--json`, Add-Parameter im Stats-Kontext, `--module-info --json`) mit stabilen Fehlermeldungen; der Module-Testplan in `tests/smoke/smoke_cli.sh` wurde entsprechend erweitert. Contract-Doku fuer `maintenance_stats_v1` in `docs/EXPORT_CONTRACT.md` finalisiert und Modul-/Entry-/Status-Doku synchronisiert (`docs/MODULES_ARCHITECTURE.md`, `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md`, `docs/BACKLOG/BL-007-maintenance.md`, `tests/README.md`). (2026-03-14)
- [S10C3/4] Module/Stats: `betankungen-maintenance` um Stats-Basis erweitert. Neues Kommando `--stats maintenance` (optional `--car-id`) liefert Textausgabe mit Scope-/Period-Hinweis sowie JSON (`--json` / `--json --pretty`) mit Contract `maintenance_stats_v1` (`contract_version`, `kind`, `generated_at`, `app_version`, Payload `maintenance` inkl. Scope-/Period-/Kostenfeldern). Datenerhebung in `units/u_maintenance_db.pas` ueber neue Aggregation `CollectMaintenanceStats`. Module-Smoke auf Stats-Contract gehaertet (`tests/smoke/smoke_modules.sh`, `tests/smoke/smoke_cli.sh`) und Modul-/Entry-Doku synchronisiert (`docs/MODULES_ARCHITECTURE.md`, `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md`, `docs/BACKLOG/BL-007-maintenance.md`, `tests/README.md`). (2026-03-14)
- [General] Knowledge-Archive: Nachtraegliches Archiv-Snippet fuer entfernte Maintenance-CLI-Helper aus S10C2/4 hinzugefuegt (`knowledge_archive/archive_maintenance_cli_parse_helpers_2026-03-14.pas` mit `HasFlag`, `HasUnknownFlags`, `TryReadDbArg` aus `src/betankungen-maintenance.lpr`) und Inventar in `knowledge_archive/README.md` aktualisiert. (2026-03-14)
- [S10C2/4] Module/CLI: Companion-CRUD-Basis fuer Maintenance eingefuehrt. `betankungen-maintenance` unterstuetzt jetzt `--add maintenance` (mit validierten Pflichtfeldern `--car-id`, `--date`, `--type`, `--cost-cents`, optional `--notes`) sowie `--list maintenance` (optional scoped via `--car-id`) in `src/betankungen-maintenance.lpr`; Persistenz/Lesepfade in `units/u_maintenance_db.pas` erweitert. Module-Smoke auf Add/List-Contract gehaertet (`tests/smoke/smoke_modules.sh`) und Listen-/Testdoku synchronisiert (`tests/smoke/smoke_cli.sh`, `tests/README.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`, `docs/README_EN.md`, `docs/MODULES_ARCHITECTURE.md`, `docs/BACKLOG/BL-007-maintenance.md`). (2026-03-14)
- [S10C1/4] Module/Migration: `betankungen-maintenance` um idempotente Schema-Migration erweitert (`--migrate [--db <path>]`). Neue Unit `units/u_maintenance_db.pas` initialisiert das Modul-Schema mit `module_meta(schema_version)` und `maintenance_events` inkl. Indizes; das Companion-CLI verdrahtet den Migrationspfad in `src/betankungen-maintenance.lpr`. Module-Smoke auf Migrations-Contract erweitert (`tests/smoke/smoke_modules.sh`, `tests/smoke/smoke_cli.sh`) und Test-/Modul-Doku synchronisiert (`tests/README.md`, `docs/MODULES_ARCHITECTURE.md`, `docs/BACKLOG/BL-007-maintenance.md`). (2026-03-14)
- [General] Meta/Process: `AGENTS.md` auf den aktuellen Tracker-/Quality-Gate-Stand aktualisiert (`Stand` auf `2026-03-13`, explizite Verankerung von `POL-001`, kanonischen Pfaden `docs/backlog`/`docs/issues`/`docs/policies`, Legacy-Hinweis fuer `docs/BACKLOG`/`docs/ADR`, Verifikationshinweis zu `make verify` inkl. `projtrack_lint`). Hash-Disziplin fuer Sprint-Traceability praezisiert (verbindlich fuer `[SxCy/z]`, ohne harte Ueberdehnung auf alle `[General]`-Tasks). (2026-03-13)
- [General] Tools/Quality-Gate: `projtrack_lint` in die Standard-Gates integriert. `Makefile` erweitert um Target `tracker-lint`; `make verify` fuehrt jetzt `sprint_docs_lint` + `projtrack_lint` vor Build/Tests aus. CI-Workflow `.github/workflows/ci.yml` um den Schritt `Tracker lint` ergaenzt. Doku-Sync in `docs/README.md`. (2026-03-13)
- [General] Docs/Tracker: Bereichs-READMEs fuer das neue Tracker-Schema ergaenzt (`docs/issues/README.md`, `docs/backlog/README.md`) und die BL-Kette auf dem neuen Pfad finalisiert (`docs/backlog/BL-0011-projekt-scaffolder-repo-bootstrap/item.md` + `tasks/TSK-0001...`), inklusive Referenz-Sync in `ISS-0001`/`TSK-0001`. (2026-03-13)
- [General] Tools/Tracker: Neuer Linter `scripts/projtrack_lint.sh` eingefuehrt (Frontmatter-/ID-/Status-/Type-Checks, `related`/`parent`-Referenzpruefung, Duplicate-ID-Check, Code-Referenz-Scan fuer `TODO/FIXME/NOTE/REF`). Doku-Sync in `docs/README.md` und `docs/policies/POL-001-tracker-standard.md`. (2026-03-13)
- [General] Docs/Tracker: Backlog-Kette im neuen Schema vervollstaendigt. Neues `item.md` fuer `BL-0011` angelegt (`docs/backlog/BL-0011-projekt-scaffolder-repo-bootstrap/item.md`) und Beispiel-Referenzen auf die 4-stellige Linie synchronisiert (`ISS-0001` -> `BL-0011`, `TSK-0001` `parent: BL-0011`, Task-Pfad unter `docs/backlog/BL-0011-.../tasks/`). (2026-03-13)
- [General] Docs/Tracker: Erste konkrete Tracker-Beispiele angelegt: `ISS-0001` unter `docs/issues/ISS-0001-negative-odometer-validation/issue.md` und `TSK-0001` unter `docs/backlog/BL-0011-projekt-scaffolder-repo-bootstrap/tasks/TSK-0001-unify-odometer-hard-error-validation.md` (Frontmatter gemaess `POL-001`, inkl. Referenzierung `ISS-0001` <-> `TSK-0001`). (2026-03-13)
- [General] Docs/Policy: Tracker-Templates gemaess `POL-001` eingefuehrt (`docs/policies/templates/issue.template.md`, `docs/policies/templates/backlog-item.template.md`, `docs/policies/templates/task.template.md`, `docs/policies/templates/README.md`). `POL-001` um den Template-Abschnitt erweitert und die Doku-Navigation in `docs/README.md` um den Template-Pfad ergaenzt. (2026-03-13)
- [General] Docs/Policy: Neues Regelwerk `docs/policies/POL-001-tracker-standard.md` eingefuehrt. Der Standard fixiert Maintainer-Schema (ADR/BL/ISS/TSK/POL), ID-Kompatibilitaet (Legacy 3-stellig lesen, neue IDs 4-stellig fuer ADR/BL/ISS/TSK), Status-Mapping (`icebox/geplant/next` -> `idea/proposed/approved`), Pflicht-Frontmatter, kanonische Code-Kommentar-Referenzen (`TODO/FIXME/NOTE/REF`) sowie einen schrittweisen Migrationsplan ohne Big-Bang-Rename. Doku-Navigation in `docs/README.md` um den neuen Policy-Bereich erweitert. (2026-03-13)
- [S9C4/4] Tests/Domain-Policy: Neue Cost-Scope-Guardrail `P-061` ergaenzt (`tests/domain_policy/cases/t_p061__01__cost_scope_isolation.sh`, `tests/domain_policy/fixtures/p061_cost_scope_base.sql`). Der Case sichert die strikte Car-/Period-Isolation fuer `--stats cost` (inkl. Scope-Labels) regressionsfest ab. Domain-Policy-Doku und Fixture-Inventar aktualisiert (`tests/domain_policy/p061.md`, `tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`). Backlog-Stand fuer Cost-Analytics auf S9C4-Nachweis erweitert (`docs/BACKLOG/BL-010-cost-analytics.md`). (2026-03-13)
- [S9C3/4] Core/Stats: Cost-JSON-Contract um Scope-/Period-Felder erweitert (`units/u_stats.pas`): `cost` enthaelt jetzt `scope_mode`, `scope_car_id` sowie `period_enabled`, `period_from`, `period_to_exclusive`, `period_from_provided`, `period_to_provided`. Export-Contract auf neuen Key-Stand synchronisiert (`docs/EXPORT_CONTRACT.md`) und Smoke-/Regression-Checks nachgezogen (`tests/smoke/helpers/smoke_cost_helpers.sh`, `tests/smoke/smoke_cli.sh`, `tests/README.md`). Doku-Sync in `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`, `docs/README_EN.md`, `docs/BENUTZERHANDBUCH.md`, `docs/BACKLOG/BL-010-cost-analytics.md`. (2026-03-13)
- [S9C2/4] Core/Stats: Cost-Collector auf aktiven Scope erweitert (`units/u_stats.pas`): `--stats cost` aggregiert jetzt car-/period-gefiltert und Textausgabe zeigt den aktiven Scope explizit (`Scope`, `Period filter`). Smoke-Abdeckung auf Filterwirkung ausgebaut (`tests/smoke/helpers/smoke_cost_helpers.sh`, `tests/smoke/smoke_cli.sh`) inkl. fixture-basierter Car-Scope-Validierung in Demo-DB und Period-Scope-Regression. Doku-Sync in `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`, `docs/README_EN.md`, `docs/BENUTZERHANDBUCH.md`, `docs/BACKLOG/BL-010-cost-analytics.md`, `tests/README.md`. (2026-03-13)
- [S9C1/4] CLI/Stats: Cost-CLI-Scope freigeschaltet. `--stats cost` akzeptiert jetzt `--from/--to` und `--car-id` in Validate/Help/Dispatch (`units/u_cli_validate.pas`, `units/u_cli_help.pas`, `src/Betankungen.lpr`). Stats-Schicht fuer Scope-Parameter vorbereitet (`units/u_stats.pas`) und Testabdeckung auf den neuen CLI-Pfad synchronisiert (`tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`, `tests/smoke/helpers/smoke_cost_helpers.sh`, `tests/smoke/smoke_cli.sh`, `tests/smoke/helpers/smoke_fleet_helpers.sh`). Doku-Sync in `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`, `docs/README_EN.md`, `docs/BENUTZERHANDBUCH.md`, `docs/BACKLOG/BL-010-cost-analytics.md`, `tests/README.md`. (2026-03-13)
- [General] Docs/Planung: Backlog um `BL-012` (GitHub Wiki Enablement) erweitert und Sprintlinie 9-11 in `docs/STATUS.md` sowie `docs/SPRINTS.md` verbindlich vorstrukturiert (S9 gestartet, S10/S11 geplant). `docs/BACKLOG.md` auf den neuen Indexstand synchronisiert. (2026-03-12)
- [General] Tests/Smoke: Prefix-Farbkonvention in allen dedizierten Smoke-Skripten vereinheitlicht (`tests/smoke/smoke_cars_crud.sh`, `tests/smoke/smoke_multi_car_context.sh`, `tests/smoke/smoke_migrations.sh`, `tests/smoke/smoke_modules.sh`): `[OK]` gruen, `[INFO]` gelb, `[FAIL]` rot (TTY-basiert, `NO_COLOR` respektiert). Testdoku in `tests/README.md` synchronisiert. (2026-03-12)
- [General] Tools/Repo-Pflege: Neues Retention-Skript `scripts/artifacts_retention.sh` fuer `.artifacts/` eingefuehrt. Das Skript bereinigt alte Nicht-Sprint-Artefakte (`*.md`, `*.diff`) gruppiert nach Dateistamm und schuetzt Sprint-Historie strikt (Muster `sprint_<nr>_commit_<nr>_von_<nr>.md|.diff` wird nie geloescht). Unterstuetzt `--dry-run`, `--keep` und optionalen Zielordner via `--dir`. Doku in `docs/README.md` ergänzt. (2026-03-12)
- [General] Docs/Polish: Kleine Sprach- und Konsistenzkorrekturen in den oeffentlichen Entry-Dokumenten vorgenommen (Root-`README.md`, `CONTRIBUTING.md`, `docs/README_EN.md`), inkl. aktualisierter Stand-Datumsfelder und vereinheitlichter Formulierungen (`road to 0.9.x`, `export-meta`). Keine Funktionsaenderung. (2026-03-12)
- [General] Tools/Repo-Pflege: Einheitliche Task-Entrypoints via neuem `Makefile` eingefuehrt (`make verify`, `make smoke`, `make release-dry`, plus `build`/`smoke-clean`). `make verify` spiegelt den lokalen CI-Gate-Ablauf (Lint, FPC-Build, Export-Contract-Check, Domain-Policy, Smoke, Clean-Home-Smoke) und bereitet fehlende Smoke-Fixtures robust vor. Doku in `docs/README.md` um den Abschnitt "Task-Entrypoints (make)" erweitert. (2026-03-12)
- [General] Tests/Smoke: `tests/smoke/smoke_cli.sh` in modulare Helper-Struktur zerlegt; Fleet-/Cost-/Bootstrap-Checks wurden nach `tests/smoke/helpers/smoke_fleet_helpers.sh`, `tests/smoke/helpers/smoke_cost_helpers.sh` und `tests/smoke/helpers/smoke_bootstrap_helpers.sh` ausgelagert und zentral per `source` eingebunden. Testdoku in `tests/README.md` um die neue Struktur ergaenzt. (2026-03-12)
- [General] Docs/Tooling: Neuer Sprint-/Doku-Lint `scripts/sprint_docs_lint.sh` eingefuehrt (Checks fuer `Stand`-Datum, `TBD`-Marker, Sprint-Tag-Format `[General]`/`[SxCy/z]` unter `[Unreleased] -> Changed` sowie 7-stellige Hash-Referenzen in `docs/CHANGELOG.md` und `docs/SPRINTS.md`). CI-Verify um den Schritt `Sprint/Docs lint` erweitert und Doku in `docs/README.md` synchronisiert. (2026-03-12)
- [General] Tests/Contract: Neuer automatischer Export-Contract-Check `tests/regression/run_export_contract_json_check.sh` eingefuehrt. Der Check liest die JSON-Contract-Keys aus `docs/EXPORT_CONTRACT.md` (Meta-Felder, `kind`, Payload-Top-Level und nested Keys fuer `fleet_mvp`/`cost_mvp`) und validiert diese gegen reale CLI-Ausgaben (`--demo --stats fuelups --json` inkl. monthly/yearly sowie `--stats fleet --json` und `--stats cost --json`). CI-Verify um den Schritt `Export-Contract JSON check` erweitert; Doku in `docs/README.md`, `tests/README.md` und `tests/regression/README.md` synchronisiert. (2026-03-12)
- [General] CI/Workflow-Fix: GitHub-Action `actions/checkout` im Verify-Workflow von `@v4` auf `@v6` angehoben, um die Node-20-Deprecation-Warnung zu vermeiden und den Runner-Pfad auf aktuelle Node-24-basierte Action-Runtimes vorzubereiten. (2026-03-12)
- [General] CI/Workflow-Fix: Verify-Workflow fuer frische GitHub-Runner gehaertet; vor den Module-Smokes werden jetzt `.releases/.backup` angelegt und ein minimales CI-Smoke-Archiv `Betankungen_0_0_0_ci_smoke.tar` erzeugt, damit `backup_snapshot --dry-run` in `tests/smoke/smoke_cli.sh --modules` nicht an fehlenden Release-Artefakten scheitert. (2026-03-12)
- [General] CI/Workflow-Fix: Dependency-Setup in `.github/workflows/ci.yml` von `fp-compiler` auf `fpc` umgestellt, damit im GitHub-Runner neben dem Compiler auch benoetigte Standard-Units (u. a. `IniFiles` aus FCL) verfuegbar sind und `verify` nicht mehr mit `Can't find unit IniFiles` fehlschlaegt. (2026-03-11)
- [General] CI/Workflow-Fix: Build-Step in `.github/workflows/ci.yml` gehaertet; FPC-Ausgabeordner (`bin`, `build`, `units`) werden vor dem Compile explizit angelegt, damit der Gate-Job `verify` im frischen GitHub-Checkout nicht mehr mit `Path "bin/" does not exist` fehlschlaegt. (2026-03-11)
- [General] CI/Quality-Gate: Neuer GitHub-Actions-Workflow `.github/workflows/ci.yml` eingefuehrt (Trigger: `push` auf `main`, `pull_request` gegen `main`, Tag-Push) mit Pflicht-Verifikationskette aus FPC-Build, Domain-Policy-Suite, `smoke_cli --modules` und `smoke_clean_home --modules`. Doku-Hinweis inkl. Required-Check-Name (`CI / verify`) in `docs/README.md` ergaenzt. (2026-03-11)
- [General] Tests/Domain-Policy: `tests/domain_policy/helpers/build_test_dbs.sh` fuer Parallelaufrufe gehaertet (Build-Lock via `flock` mit Fallback, Temp-DBs + atomarer Swap auf `Betankungen_Big.db`/`Betankungen_Policy.db`), damit parallele Smoke-/Policy-Laeufe keine sporadischen `no such table`-Fehler mehr erzeugen. Testdoku in `tests/README.md`, `tests/domain_policy/README.md` und `tests/domain_policy/fixtures/README.md` synchronisiert. (2026-03-11)
- [General] Tools/Repo-Pflege: Neues Hilfsskript `scripts/repo_sync.sh` eingefuehrt, das den Session-Sync robust und sequentiell ausfuehrt (`fetch` + `rebase` auf eindeutigem `remote/branch`) und damit sporadische Pull-/FETCH_HEAD-Konflikte durch parallele Sync-Aufrufe vermeidet. Werkzeugdoku in `docs/README.md` ergaenzt. (2026-03-11)
- [S8C4/4] Docs/Verification: Sprint 8 als abgeschlossen markiert (Cost-MVP Text + JSON + Guardrails) und Abschlussnarrative in `docs/SPRINTS.md`, `docs/STATUS.md`, `docs/README_EN.md` sowie Sprint-Referenzen im Changelog finalisiert. Abschluss-Verifikation erneut durchgefuehrt (`fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`, `tests/domain_policy/run_domain_policy_tests.sh`, `tests/smoke/smoke_cli.sh --modules`, `tests/smoke/smoke_clean_home.sh --modules`). (2026-03-11)
- [S8C3/4] Tests/CLI-Policy: Cost-Guardrails fuer ungueltige Optionen gehaertet. `tests/domain_policy/cases/t_p000__01__cli_validate_core.pas` deckt jetzt zusaetzlich Cost-Fehlerpfade fuer `--csv`, `--monthly`, `--yearly`, `--dashboard` und `--car-id` ab; `tests/smoke/smoke_cli.sh` prueft dieselben Cost-Error-Pfade end-to-end inkl. `--from/--to`. Doku-Sync in `tests/README.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/BACKLOG/BL-010-cost-analytics.md`. (2026-03-11)
- [S8C2/4] Core/Stats: Cost-JSON-MVP umgesetzt (`--stats cost --json [--pretty]`) mit Export-Meta (`contract_version`, `generated_at`, `app_version`) und `kind: "cost_mvp"` im neuen `cost`-Payload (`cars_total`, `cars_with_cycles`, `distance_km_total`, `fuel_cents_total`, `maintenance_cents_total`, `total_cents`, `cost_per_km_available`, `fuel_cost_per_km_eur_x1000`, `maintenance_cost_per_km_eur_x1000`, `total_cost_per_km_eur_x1000`). Validierung/Help/Dispatch auf cost-json erweitert (`u_cli_validate`, `u_cli_help`, `src/Betankungen.lpr`), Domain-Policy + Smoke fuer cost-json nachgezogen (`tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`, `tests/smoke/smoke_cli.sh`) und Doku synchronisiert (`docs/EXPORT_CONTRACT.md`, `docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `tests/README.md`). (2026-03-11)
- [S8C1/4] Core/Stats: Neuer Stats-Target `cost` eingefuehrt (`u_cli_types`, `u_cli_parse`, `u_cli_validate`, `u_cli_help`, Dispatch in `src/Betankungen.lpr`) und Cost-MVP-Textausgabe in `u_stats` umgesetzt (`--stats cost`, fuel-basiert ueber gueltige Volltank-Zyklen, maintenance placeholder `0`). Domain-Policy-/Smoke-Abdeckung fuer Cost-Pfad nachgezogen (`tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`, `tests/smoke/smoke_cli.sh`) und Doku/Backlog auf Sprint-8-Start synchronisiert (`docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/BACKLOG.md`, `docs/BACKLOG/BL-010-cost-analytics.md`, `tests/README.md`). (2026-03-11)
- [General] Docs/Backlog: Neues Backlog-Paket `BL-011` fuer einen separaten Projekt-Scaffolder aufgenommen (`docs/BACKLOG/BL-011-projekt-scaffolder-repo-bootstrap.md`) und im Index `docs/BACKLOG.md` verankert. Scope fuer v0.1 festgezogen (Projektname als Pflichtinput, Grundstruktur + Basisdateien + `AGENTS.md` per Template, optionales `--git-init`). (2026-03-11)
- [S7C4/4] Docs/Verification: Sprint 7 als abgeschlossen markiert (Fleet-MVP Text + JSON + Guardrails) und Abschlussnarrative in `docs/SPRINTS.md`, `docs/STATUS.md`, `docs/README_EN.md` sowie Sprint-Referenzen im Changelog finalisiert. Abschluss-Verifikation erneut durchgefuehrt (`tests/domain_policy/run_domain_policy_tests.sh`, `tests/smoke/smoke_cli.sh --modules`, `tests/smoke/smoke_clean_home.sh --modules`). (2026-03-10)
- [S7C3/4] Tests/CLI-Policy: Fleet-Guardrails fuer ungueltige Optionen gehaertet. `tests/domain_policy/cases/t_p000__01__cli_validate_core.pas` deckt jetzt zusaetzlich Fleet-Fehlerpfade fuer `--monthly`, `--yearly`, `--dashboard` sowie `--from/--to` ab; `tests/smoke/smoke_cli.sh` prueft dieselben Fleet-Error-Pfade end-to-end. Doku-Sync in `tests/README.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`, `docs/SPRINTS.md`. (2026-03-10)
- [S7C2/4] Core/Stats: Fleet-JSON-MVP umgesetzt (`--stats fleet --json [--pretty]`) mit Export-Meta (`contract_version`, `generated_at`, `app_version`) und `kind: "fleet_mvp"` im neuen `fleet`-Payload (`cars_total`, `fuelups_total`, `liters_ml_total`, `total_cents_all`). Validierung/Help/Dispatch auf fleet-json erweitert (`u_cli_validate`, `u_cli_help`, `src/Betankungen.lpr`), Domain-Policy + Smoke fuer fleet-json nachgezogen (`tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`, `tests/smoke/smoke_cli.sh`) und Doku synchronisiert (`docs/EXPORT_CONTRACT.md`, `docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `tests/README.md`). (2026-03-10)
- [General] Tests/Domain-Policy: `tests/domain_policy/run_domain_policy_tests.sh` auf isolierte Testumgebung umgestellt (`HOME`/`XDG_CONFIG_HOME`/`XDG_DATA_HOME` via temporaerem Verzeichnis), damit `tests/smoke/smoke_cli.sh --modules` nicht mehr sporadisch durch hostseitige Config-Zugriffe kippt. Testdoku in `tests/README.md` synchronisiert. (2026-03-10)
- [S7C1/4] Core/Stats: Neues Stats-Target `fleet` in der CLI aktiviert (`u_cli_types`, `u_cli_parse`, `u_cli_validate`, `u_cli_help`, Orchestrator-Dispatch in `src/Betankungen.lpr`) und MVP-Textausgabe in `u_stats` eingefuehrt (`Fleet-Stats (MVP)` mit aggregierten Basiswerten). Smoke/Tests fuer `--stats fleet` nachgezogen (`tests/smoke/smoke_cli.sh`, `tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`) und Nutzerdoku synchronisiert (`docs/BENUTZERHANDBUCH.md`, `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md`, `tests/README.md`, `docs/SPRINTS.md`). (2026-03-10)
- [General] Tests/Smoke: `tests/smoke/smoke_modules.sh` um einen klaren Preflight fuer `fpc` erweitert (`command -v fpc`), damit bei fehlendem Compiler eine direkte, nachvollziehbare Fehlermeldung statt spaeterem Build-Fehler ausgegeben wird. (2026-03-10)
- [General] Tests/Smoke: `tests/smoke/smoke_modules.sh` Build-Aufruf robust gemacht (absolute FPC-Ausgabepfade `-FE`/`-FU` und Unit-Pfad `-Fu` relativ zum Projektroot, plus `mkdir -p` fuer Build-Ordner), damit `tests/smoke_modules.sh` und `tests/smoke_cli.sh --modules` auch bei Aufruf aus `tests/` stabil gruen laufen. (2026-03-10)
- [S6C4/4] Docs/Modules: `docs/MODULES_ARCHITECTURE.md` von `draft (v0.1)` auf `baseline v1 (operational)` gehoben, Baseline-Umsetzungsstand aus Sprint 6 dokumentiert und die Feldsemantik von `--module-info` verbindlich praezisiert (insb. `db_schema_version` als Modul-Schema-Version, getrennt vom Core-Schema). Entry-Doku in `docs/README.md` und `docs/README_EN.md` sowie Status-/Sprint-Narrative in `docs/STATUS.md` und `docs/SPRINTS.md` synchronisiert. (2026-03-10)
- [S6C3/4] Tests/Smoke: Neue dedizierte Modules-Suite `tests/smoke/smoke_modules.sh` eingefuehrt (Companion-Build + `--help`/`--version` + `--module-info` compact/pretty + unknown-flag-Fehlerpfad), kompatiblen Wrapper `tests/smoke_modules.sh` ergänzt sowie `tests/smoke/smoke_cli.sh` und `tests/smoke/smoke_clean_home.sh` um die optionale Zusatzsuite `--modules` erweitert. Testdoku in `tests/README.md` synchronisiert. (2026-03-10)
- [S6C2/4] Core/Module: Neue Unit `units/u_module_info.pas` eingefuehrt (standardisierter `--module-info` JSON-Output inkl. optional Pretty-Format), Companion-Binary-Skeleton `src/betankungen-maintenance.lpr` mit Meta-Flags (`--help`, `--version`, `--module-info`) aufgebaut und `src/Betankungen.lpr` auf `APP_VERSION 0.9.0-dev` fuer die aktive 0.9.x-Linie angehoben. (2026-03-10)
- [S6C1/4] Docs/ADR: `docs/ADR/ADR-0005-module-strategy.md` auf finalen Entscheidungsstand (`accepted`) gehoben und verbindliche Scope-Grenzen fuer Core-vs-Module festgezogen (inkl. Kriterien, Modulkandidaten und Verweis auf `docs/MODULES_ARCHITECTURE.md` als Gate). ADR-Index in `docs/ADR/README.md` synchronisiert. (2026-03-10)
- [General] Docs/Architecture: Neues Dokument `docs/MODULES_ARCHITECTURE.md` als technischer Modul-Contract eingefuehrt (Build/Packaging, CLI-Integration, DB-Erweiterung, Stats-Integration, Kompatibilitaet und Mindest-Qualitaetsstandard) und in `docs/README.md` sowie `docs/ARCHITECTURE.md` verankert. (2026-03-09)
- [General] Docs/Backlog: Neues Backlog-Item `BL-010` fuer Cost-Analytics aufgenommen (`--stats cost`, Kennzahlen fuer Fuel-/Maintenance-/Total-cost per km, Formel `total_cost = fuel_cost + maintenance_cost` und `cost_per_km = total_cost / gefahrene_km`). (2026-03-09)
- [General] Docs/Backlog: Neues Backlog-Item `BL-009` fuer ein Agriculture-Modul aufgenommen (`betankungen-agriculture` mit Asset-Typen, Energietypen und Perspektive fuer `usage_unit` bei Betriebsstunden). (2026-03-09)
- [General] Docs/Backlog: Neues Backlog-Item `BL-008` fuer Tire-Management aufgenommen (Datenmodell-Skizze `tiresets` und `tire_installations`, Kosten-/Laufleistungskennzahlen `km_per_tireset` und `cost_per_km`). (2026-03-09)
- [General] Docs/Backlog: Neues Backlog-Item `BL-007` fuer ein optionales Maintenance-System aufgenommen (Ereignisarten, Beispielschema `maintenance_events`, Kostenintegration `cost_per_km = fuel + maintenance`, Scope als Companion-Modul `betankungen-maintenance`). (2026-03-09)
- [General] Docs/ADR: Neues ADR `ADR-0008` zur EV-Strategie aufgenommen (Elektrofahrzeuge zunaechst modular ueber `betankungen-ev` statt Core-Refactoring) und ADR-Index aktualisiert. (2026-03-09)
- [General] Docs/ADR: Neues ADR `ADR-0007` zur Core-Grenze aufgenommen (Regel "Core = universelle Mobilitaetsdaten, Module = domaenenspezifische Erweiterungen") und ADR-Index aktualisiert. (2026-03-09)
- [General] Docs/ADR: `ADR-0004` auf finalen Entscheidungsstand gesetzt (`accepted`) und Terminologie fuer aggregierte Fahrzeugstatistiken auf `--stats fleet` festgezogen; ADR-Index (`docs/ADR/README.md`) und Backlog-Verweis (`docs/BACKLOG.md`) entsprechend synchronisiert. (2026-03-09)
- [General] Docs/Language: Kompakte englische Architektur-Zusammenfassung `docs/ARCHITECTURE_EN.md` eingefuehrt und in den Entry-Dokumenten (`README.md`, `docs/README.md`, `docs/README_EN.md`) verankert. (2026-03-09)
- [General] Meta/Process: `AGENTS.md` um verbindliche Doku-Sprachstrategie fuer Public-Readiness erweitert (Deutsch-first fuer Detaildoku, inkrementelle englische Entry-Doku, kein Big-Bang-Umbau vor `1.0.0`). (2026-03-09)
- [General] Docs/Language: Englischen Doku-Einstieg `docs/README_EN.md` eingefuehrt und in Root-`README.md` sowie `docs/README.md` verlinkt. (2026-03-09)
- [General] Meta/Open-Source: Apache-2.0-Lizenzdatei (`LICENSE`) im Projektroot eingefuehrt, um die spaetere Oeffentlichstellung in Richtung V1 vorzubereiten. (2026-03-09)
- [General] Docs/Open-Source: Root-`README.md` (GitHub-Einstieg mit Sprach-/Lizenzhinweis) und `CONTRIBUTING.md` (Contribution-Policy, Kommunikations- und Scope-Leitplanken) neu aufgenommen. (2026-03-09)
- [General] Docs/README: Open-Source-Hinweis um Lizenzziel, Contribution-Verweis und Sprach-/Kommunikationsrahmen erweitert. (2026-03-09)
- [General] Docs/ADR: Neues ADR `ADR-0006` zu Household Drivers aufgenommen (optionales `driver`-Objekt, `fuelups.driver_id` nullable) und ADR-Index aktualisiert. (2026-03-09)
- [General] Docs/Backlog: UI-Polishing-/ASCII-Draw-Notizen als Backlog-Item `BL-006` eingeordnet (CLI-Renderer-Fokus mit ASCII/Unicode-Fallback; Detailskizze in `docs/UI_ASCII_DRAW.md`). (2026-03-09)
- [General] Docs/ADR: `docs/VIN_POLICY_UX_PREP.md` im ADR-Index als ADR-nahe Policy-/UX-Begleitnotiz verankert. (2026-03-09)
- [General] Docs/ADR: Neues ADR `ADR-0005` zur Modulstrategie aufgenommen (Core+Module, Companion-Binaries wie `betankungen-maintenance` statt dynamischer Runtime-Plugins) und ADR-Index aktualisiert. (2026-03-09)
- [General] Docs/Backlog: Backlog auf Index+Einzeldatei-Struktur umgestellt (`docs/BACKLOG.md` als zentrale Uebersicht, Detaildokumente unter `docs/BACKLOG/BL-001..BL-005`), inkl. neuem Eintrag `BL-005` zur Modulstrategie fuer optionale Erweiterungen. (2026-03-09)
- [General] Docs/Backlog: Neues Icebox-Backlog `BL-004` fuer "Cross-Border Fuel Context" aufgenommen (optionale Zusatzfelder `currency_code` [ISO-4217] und `country_code` [ISO-3166-1 alpha-2] an `fuelups`, ohne automatische FX-Umrechnung). (2026-03-09)
- [General] Docs/Backlog: Neues Icebox-Backlog `BL-003` fuer "Household Drivers / Shared Cars" aufgenommen (optionale `driver_id`-Beziehung in `fuelups`, moegliche Tabelle `drivers`, klare Nicht-Ziele ohne Login/Auth/Rollen). (2026-03-09)
- [General] Data/Easter-Egg: Zusaetzliche Multi-Line-Message fuer die geplante Maintainer-Variante `--cookie` in `data/dev_messages.b64` aufgenommen (feste drei Zeilen: SEARCHING/DOGGO FOUND/TAIL.PROPELLER). (2026-03-07)
- [General] Docs/Backlog: `docs/BACKLOG.md` um die optionale, versteckte CLI-Variante `--cookie` erweitert (feste Ausgabe, isoliert von normalen Flows). (2026-03-07)
- [General] Data/Easter-Egg: Entkoppelte Message-Sammlung `data/dev_messages.b64` eingefuehrt (eine base64-kodierte Message pro Zeile, inkl. initialem Bestand fuer das optionale `--ndt`-Backlog-Feature). (2026-03-07)
- [General] Tools/Data: Neues Hilfsskript `scripts/dev_messages_encode.sh` eingefuehrt (Input mit Delimiter `---`, Multi-Line-Support, Ausgabe als base64-Zeilenformat fuer `data/dev_messages.b64`). (2026-03-07)
- [General] Docs/Backlog: Rohtexte der Developer-Messages aus `docs/BACKLOG.md` entfernt und auf entkoppelte Datenablage umgestellt; Referenzen auf `data/dev_messages.b64` und Pflegeworkflow ergaenzt. (2026-03-07)
- [General] Docs/Navigation: `docs/README.md` um `data/`-Struktur, `scripts/dev_messages_encode.sh` und den neuen Asset-Hinweis erweitert; `data/README.md` als Format-/Pflegehilfe hinzugefuegt. (2026-03-07)
- [General] Docs/Backlog: Neues Backlog-Dokument `docs/BACKLOG.md` eingefuehrt (klare Trennung von spaeteren Themen inkl. `BL-001` Policy-Structure-Coverage-Check und `BL-002` optionales Developer-Flag `--ndt`). (2026-03-07)
- [General] Docs/ADR: ADR-Unterordner `docs/ADR/` eingefuehrt (`README` + `ADR-0001..ADR-0004`) fuer entschiedene und offene Produkt-/Architekturentscheidungen (u. a. CSV-Contract-Versionierung, VIN-Validierungs-Haertegrad, Schema-Bump-Strategie, Fleet-Stats-Naming). (2026-03-07)
- [General] Docs/Navigation: `docs/README.md`, `docs/ARCHITECTURE.md` und `docs/STATUS.md` um strukturierte Verweise/Artefaktlisten fuer Backlog-/ADR-Dokumente erweitert; gezielte Unterordner-Struktur ueber `docs/ADR/` eingefuehrt, ohne riskante Massenverschiebung bestehender Doku-Dateien. (2026-03-07)
- [General] Tools/Backup: `scripts/backup_snapshot.sh` um automatische Retention erweitert (`--keep N`, Default `10`); alte Snapshot-Ordner werden nach dem Lauf bereinigt und `.backup/index.json` auf bestehende Snapshots gepruned. `docs/README.md` um Usage-/Beispiele aktualisiert. (2026-03-07)
- [General] Release/Artifacts: `kpr.sh --note "Release 0.8.0 final"` ausgefuehrt; lokales Release-Archiv `Betankungen_0_8_0.tar` erstellt (`sha256=72c26a025bfeaf166af7212e05e2baf688ba6f39ea41a8317c35c0f54435414d`) und `release_log.json` aktualisiert. (2026-03-07)
- [General] Backup/Snapshot: `scripts/backup_snapshot.sh --note "Backup after release 0.8.0"` ausgefuehrt; Snapshot `.backup/2026-03-07_2010` und aktualisierter Backup-Index erstellt. (2026-03-07)
- [General] Release/Tagging: Release-Tag `0.8.0` und Sprint-Tag `sprint-5-done` fuer den finalen Stand gesetzt. (2026-03-07)
- [General] Release/Versioning: `src/Betankungen.lpr` auf `APP_VERSION 0.8.0` (final) gesetzt; `0.8.0-dev` wurde damit auf finalen Release-Stand ohne Suffix abgeschlossen. (2026-03-07)
- [General] Docs/Release: `docs/STATUS.md`, `docs/README.md`, `docs/ARCHITECTURE.md` und `docs/SPRINTS.md` auf 0.8.0-Abschluss und naechsten Fokus `0.9.x` nachgezogen (inkl. Sprint-5-Narrative). (2026-03-07)
- [General] Meta/Process: `AGENTS.md` um eine verbindliche Versionierungs-Policy erweitert (klare Trennung `road to` vs. `-dev` vs. final, Patch-Zyklen, Release-Umschaltregeln) und die selbststaendige Synchronisierung von `APP_VERSION` in `src/Betankungen.lpr` als Standard festgelegt. (2026-03-07)
- [S5C1/1] Tests/Domain-Policy: Verbleibende Stats-CSV-Checks in `tests/domain_policy/cases/t_p060__01__stats_skip_interval_missed_previous.sh` und `tests/domain_policy/cases/t_p060__02__car_isolation.sh` konsequent auf feldbasiertes Token-Parsing umgestellt (Header/Rowcount/Spaltenwerte via `tests/helpers/csv.sh`), ohne Vollzeilen-Regex-Matches. (2026-03-07)
- [S4C3/3] Core/i18n: `units/u_i18n.pas` um eine kleine, klar abgegrenzte Menge an Meta-Message-IDs erweitert (Config-Status, First-Run-Hinweise, generische Systemmeldung) fuer den ersten Runtime-Rollout ueber `Tr()`. (2026-03-07)
- [S4C3/3] Runtime/Orchestrator: In `src/Betankungen.lpr` wurden nur ausgewaehlte risikoarme Texte auf i18n-Lookup umgestellt (`--show-config`-Rahmentexte, Reset-Config-Hinweise, First-Run-Hinweise, generische Meldung "Datenbank angelegt"), ohne breite Help-/Fehlertext-Migration. (2026-03-07)
- [S4C3/3] Docs: Sprint-4-Abschlussstand und Mini-Rollout dokumentiert (`docs/ARCHITECTURE.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). (2026-03-07)
- [General] Docs/Migrations: `migrations/` als historisches SQL-Archiv festgezogen (`migrations/README.md` neu); aktive Schema-Migrationen als Runtime-Source-of-Truth (`units/u_db_init.pas`) und zugehoerige Validierung (`tests/smoke/smoke_migrations.sh`) in der Doku klar verankert (`docs/README.md`, `docs/ARCHITECTURE.md`). (2026-03-07)
- [General] Tools/Artifacts: Neues Skript `scripts/sprint_artifact.sh` eingefuehrt (lokale Sprint-Artefakte `.md/.diff` mit Default-Ziel `.artifacts`, optional `--commit`, `--outdir`, `--force`, robusteres Arg-Parsing und Schutz vor stillem Ueberschreiben). (2026-03-07)
- [General] Docs/Tools: Neue Nutzungsdoku `scripts/README_sprint_artifact.md` erstellt und Werkzeugabschnitt in `docs/README.md` um `scripts/sprint_artifact.sh` inkl. Beispiele ergaenzt. (2026-03-07)
- [General] Meta/Process: Lokale Sprint-Artefakte auf den zentralen Ordner `.artifacts/` umgestellt; bestehende lokale `sprint_*_commit_*`-Dateien wurden dorthin verschoben, `.gitignore` ignoriert nun `.artifacts/`, und `AGENTS.md` nutzt `.artifacts/...` als verbindlichen Pfad. (2026-03-07)
- [S4C2/3] Core/i18n: Neue Unit `units/u_i18n.pas` als zentraler i18n-Einstiegspunkt eingefuehrt (`TMsgId`, `Tr()`, Sprachraum `de|en|pl`, Normalisierungs-/Parsing-Helfer), ohne breite Migration bestehender Runtime-Texte. (2026-03-07)
- [S4C2/3] Core/Config-Flow: Sprachkontext `language=de|en|pl` im Konfigurationsfluss verankert (`src/Betankungen.lpr`): Laden/Normalisieren aus `config.ini`, Default `de`, Persistenz bei Config-Schreibpfaden (`--db-set`, Erststart/Fallback). (2026-03-07)
- [S4C2/3] Docs: Sprint-4-Status auf Skeleton-Stand aktualisiert (`docs/ARCHITECTURE.md`, `docs/STATUS.md`, `docs/README.md`, `docs/SPRINTS.md`). (2026-03-07)
- [General] Meta/Process: `AGENTS.md` um verbindliche Regel fuer Sprint-Artefakte nach Push erweitert (lokale Erstellung von `sprint_<nr>_commit_<nr>_von_<nr>.md/.diff`, definierte Reihenfolge, kein Commit/Push ohne explizite Freigabe). (2026-03-07)
- [General] Meta: Sprint-Artefakte `sprint_4_commit_1_von_3.md/.diff` aus dem Repository entfernt (nur lokal), und `.gitignore` um Pattern `sprint_[0-9]*_commit_[0-9]*_von_[0-9]*.diff` erweitert, damit diese Artefakte kuenftig nicht mehr versehentlich versioniert werden. (2026-03-07)
- [S4C1/3] Docs/Architecture: i18n-Policy als verbindliche Architekturregelbasis vor Runtime-Wiring dokumentiert (`language=de|en|pl`, Rolle von `u_i18n.pas`/`TMsgId`/`Tr()`, Testentkopplung von lokalisierten Volltexten, Sprint-4-Migrationsgrenzen in/out of scope). (2026-03-07)
- [S4C1/3] Docs/Status: Sprint-4-Roadmap "i18n First" ergaenzt (`S4C1/3` Policy-Doku, `S4C2/3` Skeleton, `S4C3/3` kontrollierte Textmigration + Testhaertung) inkl. expliziter Nicht-Ziele. (2026-03-07)
- [S4C1/3] Docs/Readme+Principles: Kurzverweis in `docs/README.md` und i18n-Leitplanke in `docs/DESIGN_PRINCIPLES.md` aufgenommen, damit die neue Regelbasis an den zentralen Einstiegspunkten sichtbar ist. (2026-03-07)
- [S3C3/3] Docs: Neues Dokument `docs/VIN_POLICY_UX_PREP.md` eingefuehrt (VIN optional statt Pflicht, spaetere Normalisierung/Validierung, Registrierungsdokumente nur als Referenzen, CLI-UX-Richtung und Test-Ideen). (2026-03-06)
- [S3C3/3] Docs/Architecture: `docs/ARCHITECTURE.md` um expliziten VIN-Policy-/UX-Prep-Verweis erweitert; `docs/SPRINTS.md` Sprint-3-Folge um S3C3/3 inkl. Abschluss-Tag-Plan ergänzt. (2026-03-06)
- [S3C2/3] Tests/Smoke: Neue dedizierte Migrations-Suite `tests/smoke/smoke_migrations.sh` inkl. Wrapper `tests/smoke_migrations.sh` eingefuehrt; erster Check validiert Upgrade `v4 -> v5` (ALTER-Spalten `vin`, `reg_doc_path`, `reg_doc_sha256`, `schema_version=5`, idempotenter Re-Run). (2026-03-06)
- [S3C2/3] Tests/Runner+Docs: `tests/smoke/smoke_cli.sh` und `tests/smoke/smoke_clean_home.sh` um Flag `--migrations` erweitert; `tests/README.md` um Wrapper/Suite/Run-Beispiele fuer Migration-Smokes aktualisiert. (2026-03-06)
- [S3C1/3] DB/Cars: Schema auf VIN-Vorbereitung erweitert (`vin`, `reg_doc_path`, `reg_doc_sha256`), ohne CLI-Wiring oder aktive Runtime-Nutzung. (2026-03-06)
- [S3C1/3] DB/Migration: `schema_version` von `4` auf `5` angehoben; Migration fuer Bestands-DBs erfolgt per `ALTER TABLE`-Nachzug in `u_db_init` und `u_db_seed` (Rebuild-Pfad unveraendert nur fuer historische v4-Faelle). (2026-03-06)
- [S2C4/4] Docs: `docs/EXPORT_CONTRACT.md` praezisiert, dass `--yearly` keinen CSV-Export besitzt und `--yearly --csv` ungueltig ist. (2026-03-04)
- [S2C4/4] QA/Verification: Volltestlauf erfolgreich verifiziert (`tests/smoke/smoke_cli.sh -a -c` und `tests/domain_policy/run_domain_policy_tests.sh`). (2026-03-04)
- [S2C4/4] Docs/Process: Sprint-2-Narrative finalisiert (`docs/SPRINTS.md`: Status `done`, S2C4/4-Commit ergänzt, Abschluss-Tag `sprint-2-done` als pending bis Freigabe markiert). (2026-03-04)
- [S2C3/4] Core/Stats: Stats-CSV auf Contract-v1-Spalte `contract_version` umgestellt (erste Spalte fuer monthly und full-tank-cycles; Datenzeilen prefixed mit `1`). (2026-03-04)
- [S2C3/4] Tests/Smoke+Policy: Feldbasierte Smoke-Checks (`smoke_cars_crud`, `smoke_multi_car_context`) sowie Domain-Policy-Cases `P-060/01` und `P-060/02` auf neuen CSV-Header/Rows mit `contract_version=1` synchronisiert. (2026-03-04)
- [S2C2/4] Meta/Process: `AGENTS.md` um verbindliche Hash-Disziplin erweitert (unmittelbare Ermittlung nach Commit, Short-Hash-Format `7` Zeichen, lokale Hash-Quelle via `git rev-parse --short=7 HEAD`, kein nachgelagerter Doku-Sync fuer Hash-Nachtrag). (2026-03-04)
- [S2C2/4] Core/Stats: JSON-Stats-Export um v1-Metafelder erweitert (`contract_version=1`, `generated_at` als UTC-ISO-Timestamp, `app_version` aus `APP_VERSION`) fuer monthly/yearly/full-tank-cycles. (2026-03-04)
- [S2C2/4] Tests/Smoke: `tests/smoke/smoke_cli.sh` um JSON-Meta-Presence-Guards erweitert und bestehende Monthly/Yearly-JSON-Checks auf Contract-v1-Metafelder gehaertet. (2026-03-04)
- [S2C2/4] Docs: `docs/EXPORT_CONTRACT.md` auf den aktuell implementierten JSON-v1-Payload-Zuschnitt praezisiert (`kind` + bestehende Datenfelder). (2026-03-04)
- [S2C1/4] Docs: Neues Export-Contract-Dokument `docs/EXPORT_CONTRACT.md` eingefuehrt (v1-Minimalvertrag fuer Versionierung, JSON/CSV-Pflichtfelder, Scope-/Period-Regeln und Stabilitaetsregeln). (2026-03-04)
- [S1C4/4] Docs/Process: Konsistenz-Pass fuer `AGENTS.md`, `docs/CHANGELOG.md`, `docs/SPRINTS.md` und `docs/README.md` abgeschlossen; keine Placeholder-Eintraege im Sprint-1-Aktivbereich. (2026-03-04)
- [S1C4/4] Tests/Smoke: Wrapper-Konsistenz geprueft (`tests/smoke/*.sh`, `tests/smoke_*.sh`); Wrapper bleiben unveraendert, da nur delegierende `exec`-Durchreicher. (2026-03-04)
- [S1C4/4] Tests/Lint: Schnell-Lint `bash -n tests/**/*.sh` erfolgreich. (2026-03-04)
- [General] Meta: `src/Betankungen.lpr` auf `APP_VERSION 0.8.0-dev` angehoben (aktuelle Entwicklungsbasis fuer 0.8.x). (2026-03-04)
- [S1C3/4] Docs: `docs/SPRINTS.md` auf finalen S1C3/4-Status synchronisiert (`done`, Commit `b4273c4`, Artefakte ohne Placeholder-Suffix). (2026-03-04)
- [S1C3/4] Tests/Smoke: `tests/smoke/smoke_clean_home.sh` auf CSV-/Stats-Contract-Matches geprueft; keine CSV-Textmatches oder helper-relevanten CSV-Header/Rowcount-Checks gefunden, daher keine Migration in diesem Skript erforderlich. (2026-03-04)
- [S1C3/4] Tests/Helpers: `tests/helpers/csv.sh` um `csv_row_count <file>` erweitert (Datenzeilen ohne Header), und Smoke-Skripte auf die zentrale Helper-Semantik umgestellt (`tests/smoke/smoke_multi_car_context.sh`, `tests/smoke/smoke_cars_crud.sh`). (2026-03-04)
- [S1C3/4] Meta/Process: `AGENTS.md` um verbindliche `knowledge_archive`-Regeln erweitert (Loeschungen verpflichtend archivieren, funktionale Verhaltensaenderungen ebenfalls archivieren und in `knowledge_archive/README.md` dokumentieren). (2026-03-04)
- [S1C3/4] Docs: `knowledge_archive/README.md` auf verpflichtende Archiv-Metadaten, Dateinamenskonvention und Header-Template vereinheitlicht; bestehende Archiv-Snippets mit Quelle/Symbol/Anlass/Datum/Commit-Status inventarisiert. (2026-03-04)
- [General] Meta/Process: `AGENTS.md` um verbindliche Sprint-Disziplin erweitert (Commit-Message-Prefix `[SxCy/z]` fuer Sprint-Arbeit, annotierter Abschluss-Tag `sprint-<nr>-done` nur nach Sprint-Freigabe). (2026-03-03)
- [General] Docs: Neues Sprint-Narrative-Dokument `docs/SPRINTS.md` angelegt (Status, Commit-Folge, Artefakte und geplanter Abschluss-Tag je Sprint). (2026-03-03)
- [S1C1/4] Tests/Smoke: `tests/smoke/smoke_multi_car_context.sh` auf feldbasierte CSV-Assertions fuer Multi-Car-Stats umgestellt (Helper-Sourcing, Header-/Spalten-Checks auf `car_id` und `fueled_at`, row-basierte Scope-Validierung pro Car-ID, Foreign-Row-Guards). (2026-03-01)
- [S1C1/4] Tests/Helpers: `tests/helpers/csv.sh` Header-Parser fuer `set -e` stabilisiert (`((i += 1))` statt `((i++))`). (2026-03-01)
- [S1C1/4] Tests/Helpers: `csv_assert_has_cols` erweitert, damit fehlende Pflichtspalten die vorhandene Header-Liste im Fehlertext ausgeben (`have: ...`) fuer schnellere Contract-Diagnose. (2026-03-01)
- [S1C1/4] Tests/Smoke: Cross-Car-Isolation-Guardrail in `tests/smoke/smoke_multi_car_context.sh` geschaerft (`ROWS_* == DB_COUNT_*` statt Mindestanzahl), damit CSV-Output strikt gegen DB-Realitaet validiert wird. (2026-03-01)
- [S1C1/4] Tests/Smoke: Multi-Car-Stats-Assertions auf den aktuellen Aggregat-CSV-Contract ausgerichtet (`idx,dist_km,liters_ml,avg_l_per_100km_x100,total_cents` inkl. feldbasierter Wertpruefung je Car) und Isolation auf `stats_rows = fuelups_count - 1` validiert. (2026-03-01)
- [S1C1/4] Tests/Helpers: `tests/helpers/assert.sh` mit finalem Newline am Dateiende vereinheitlicht. (2026-03-01)
- [S1C2/4] Tests/Smoke: `tests/smoke/smoke_cars_crud.sh` Stats-CSV-Scope auf feldbasierte Contract-Checks umgestellt (Header `idx,dist_km,liters_ml,avg_l_per_100km_x100,total_cents`, numerische Typguards, Rowcount `fuelups_count(car)-1`, DB-abgeleitete Token-Validation und Foreign-Guards ohne grep-Regexe). (2026-03-02)

### Tooling / Assistance
- Referenzscreen-Umsetzung, Tracker-Sync und Sprint-40-Traceability
  erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner.
  (2026-04-08)
- Tracker-/Planungs-Sync fuer `ISS-0010`, `TSK-0028` und den zugehoerigen
  BL-/Status-/Traceability-Stand erfolgte mit Unterstuetzung durch AI-Tools
  als Sparringspartner. (2026-04-03)
- Odometer-Contract-Hardening, Tracker-Sync und Sprint-32-Traceability
  erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner.
  (2026-03-31)
- Governance-/Docs-Cleanup zur stillen Stilllegung des repo-getrackten
  Knowledge-Archive-Mechanismus erfolgte mit Unterstuetzung durch AI-Tools
  als Sparringspartner. (2026-03-31)
- Tracker-/ADR-Backfill, Index-Sync und Traceability-Pflege fuer Sprint 25
  bis 28 erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner.
  (2026-03-30)
- Workflow-Korrektur und Governance-Schaerfung zur Branch-Naming-Disziplin
  erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner.
  (2026-03-26)
- Ausarbeitung und Finalisierung von `ADR-0010` sowie Tracker-Operationalisierung
  von `BL-0024` (`TSK-0022`/`TSK-0023`) erfolgte mit Unterstuetzung durch
  AI-Tools als Sparringspartner. (2026-03-26)
- Versionierungs-/Roadmap-Sync fuer den Start der `1.3.0-dev`-Linie erfolgte
  mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-24)
- Pflege der neuen Backlog-Vorschlaege `BL-0023` und `BL-0024` inkl. Index-/Changelog-Sync erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-21)
- Tracker-/Policy-Pflege (Vorschlagsabgleich, neue BL/POL/ADR-Eintraege und Doku-Sync) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-15)
- Konsistenz-Update von `AGENTS.md` auf den aktuellen Tracker-/Gate-Stand erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-13)
- Integration von `projtrack_lint` in lokale/CI-Quality-Gates (`make verify`, GitHub Actions) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-13)
- Aufbau des initialen Tracker-Lints (`scripts/projtrack_lint.sh`) sowie Struktur-/Referenz-Sync fuer den neuen Tracker-Bereich erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-13)
- Vervollstaendigung der Beispielkette `BL-0011 -> TSK-0001 -> ISS-0001` inklusive Referenz-Sync erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-13)
- Erstellung der ersten konkreten Tracker-Beispiele (`ISS-0001`, `TSK-0001`) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-13)
- Erstellung der Tracker-Templates und Synchronisierung des Policy-Standards erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-13)
- Ausarbeitung und Strukturierung des Tracker-Standards (`POL-001`) inkl. Migrationsleitplanke erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-13)
- Ausbau der englischen Entry-Doku um `docs/ARCHITECTURE_EN.md` und Entry-Linking erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-09)
- Verankerung der Doku-Sprachstrategie (`AGENTS.md`) und Start der englischen Entry-Doku (`docs/README_EN.md`) erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-09)
- Open-Source-Readiness (Apache-2.0-Lizenz, Root-README, CONTRIBUTING und Doku-Hinweise) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-09)
- ADR-Erweiterung `ADR-0006`, Backlog-Einordnung `BL-006` und ADR-nahe Verankerung von `VIN_POLICY_UX_PREP.md` erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-09)
- ADR-Erweiterung `ADR-0005` (Modulstrategie) und Index-Update erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-09)
- Backlog-Refactoring (Index + Einzeldateien `BL-001..BL-005`) und Doku-Navigation-Update erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-09)
- Backlog-Erweiterung `BL-004` (Cross-Border Fuel Context) wurde mit Unterstuetzung durch AI-Tools als Sparringspartner eingepflegt. (2026-03-09)
- Backlog-Erweiterung `BL-003` (Household Drivers / Shared Cars) wurde mit Unterstuetzung durch AI-Tools als Sparringspartner eingepflegt. (2026-03-09)
- Erweiterung der Easter-Egg-Message-Liste und Backlog-Praezisierung fuer `--cookie` erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Auslagerung/Obfuskation der Developer-Messages (`data/dev_messages.b64`) und Einrichtung des Encode-Helfers erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Backlog-/ADR-Strukturierung und Doku-Navigation erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Retention-Erweiterung fuer `scripts/backup_snapshot.sh` (inkl. Doku-Update) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Release-/Backup-Durchlauf (`kpr.sh`, `backup_snapshot.sh`) und zugehoerige Traceability-Pflege erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Prozessschaerfung zur Versionierungsautomatik (`AGENTS.md`, inkl. `APP_VERSION`-Sync-Regel) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Umsetzung S5C1/1 (Domain-Policy-CSV-Assertions auf feldbasiertes Token-Parsing) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Dokumentationsschaerfung zum historischen Migrationsordner (`migrations/`) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Umsetzung S4C3/3 (kontrollierte Runtime-Mini-Migration auf `Tr()` + Doku-Sync) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Umsetzung S4C2/3 (i18n-Skeleton + Config-Flow-Verankerung + Doku-Sync) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Umsetzung S4C1/3 (i18n-Policy-/Architektur-Doku, Status-Roadmap und Leitplanken) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-07)
- Umsetzung S3C3/3 (VIN-Policy-/UX-Doku und Sprint-3-Finalisierung) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-06)
- Umsetzung S3C2/3 (Migrations-Smoke-Framework und Runner-Integration) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-06)
- Umsetzung S3C1/3 (DB-Schema v5 + Migrations-/Doku-Pflege) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-06)
- Sprint-1-Abschluss (Konsistenzpass, Wrapper-Check, Lint und Tagging) erfolgte mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-04)
- Implementation und Review erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-01)
- Sprint-Umsetzung und Test-Review in S1C2/4 erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-02)
- Dokumentationspflege und Prozess-Schaerfung erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-03)
- S1C3/4-Audit, Helper-Polish und Prozess-Regelerweiterung erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (2026-03-04)

## 0.7.0 – 2026-03-01

### Changed
- Meta: `src/Betankungen.lpr` auf `APP_VERSION 0.7.0` angehoben (Release-Stand ohne Sprint-Suffix). (2026-03-01)
- Docs: Releaseabschluss 0.7.0 im Changelog durchgefuehrt; `[Unreleased]` auf Zielversion `0.8.x` vorbereitet. (2026-03-01)
- Docs: `docs/STATUS.md` und `docs/README.md` auf 0.7.0-Abschluss und naechsten Fokus `0.8.x` aktualisiert. (2026-03-01)
- Meta: Finales Release-Archiv `Betankungen_0_7_0.tar` per `scripts/kpr.sh --note "Release 0.7.0 final"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=bb4769ec0b63c6299c3bfd6cac2f93c57df9efc50503ad87d2a02179ce1466ef`). (2026-03-01)
- Tests/Domain-Policy: Commit-4-Konsistenzschritt umgesetzt (Runtime unveraendert): Smoke-/Policy-Checks fuer Car-Guards von fragilen Policy-String-Matches entkoppelt (stabile Kernsignale via Exitcode/Kernhinweis/No-Write/DB-State), Domain-Policy-Doku um klare Trennung `Policy-ID = Engineering-Contract` vs. `Runtime-Text = User-Contract` ergaenzt. (2026-03-01)
- Tests/Docs: Smoke-Feinschliff fuer Commit 3 umgesetzt: CSV-Scope-Assertions in `tests/smoke/smoke_cars_crud.sh` und `tests/smoke/smoke_multi_car_context.sh` mit TODOs fuer spaeteres feldbasiertes Token-Parsing vorbereitet (ohne Verhaltensaenderung), plus 0-Cars-Trigger-/Migrations-Guard explizit in `tests/README.md` und `docs/ARCHITECTURE.md` dokumentiert. (2026-03-01)
- Docs: `docs/README.md` und `docs/BENUTZERHANDBUCH.md` auf 0.7.x-Ist-Zustand synchronisiert (Roadmap-Kurzstand korrigiert, Multi-Car-Strategie/Resolver-Regelwerk zentral dokumentiert, kein implizites `car_id=1`). (2026-02-28)
- Docs: `docs/ARCHITECTURE.md`, `docs/STATUS.md` und `docs/VISION.md` auf den Ist-Zustand synchronisiert: Multi-Car-CLI als umgesetzt markiert (Resolver, strict car scope, kein implizites `car_id=1`), 0.7.x auf Release-Reife-Fokus geschwenkt und Vision um einen Reality-Check erweitert. (2026-02-28)
- Tests/Smoke: Finale Resolver-/CLI-Matrix als dedizierte Suite ergaenzt (`tests/smoke/smoke_multi_car_context.sh` + Wrapper `tests/smoke_multi_car_context.sh`) mit 0/1/>1-Car-Faellen fuer `--add/--list/--stats fuelups`, scoped Output-Checks, Cross-Car-Isolation sowie Guards fuer `--edit/--delete cars` inkl. `--car-id 0` (`P-001`). (2026-02-28)
- Tests/Smoke: Cars-Suite (`tests/smoke/smoke_cli.sh -c`) um die neue Resolver-Matrix-Suite erweitert (Dry-List + Runner-Integration). (2026-02-28)
- Docs/Tests: `tests/README.md` um die finale Resolver-Matrix-Suite, Wrapper und Abdeckungsumfang erweitert. (2026-02-28)
- CLI/Core: Presence-Flag `CarIdProvided` entfernt; `--car-id`-Presence wird jetzt ueber `Cmd.CarId` (0 = nicht gesetzt) abgebildet (`units/u_cli_types.pas`, `units/u_cli_parse.pas`, `units/u_cli_validate.pas`, `src/Betankungen.lpr`, `units/u_fuelups.pas`). (2026-02-28)
- CLI/Parser: `--car-id` validiert bereits beim Parsing auf `> 0`, sodass ungueltige Werte (`<= 0`) weiterhin als `P-001` abgewiesen werden. (2026-02-28)
- Core/Stats: `--stats fuelups` auf strikten Car-Scope umgestellt (`src/Betankungen.lpr`, `units/u_stats.pas`): Resolver-Aufloesung via `ResolveCarIdOrFail`, SQL-Filterung `WHERE car_id = :car_id` (inkl. Period-Bounds), keine Cross-Car-Vermischung mehr ohne explizite Fahrzeugauswahl. (2026-02-27)
- CLI/Validate+Help: `--car-id` fuer `--stats fuelups` freigeschaltet (`units/u_cli_validate.pas`) und Usage/Help entsprechend erweitert (`units/u_cli_help.pas`). (2026-02-27)
- Tests/Domain-Policy: `P-060/02` auf strict car-scope angepasst (`tests/domain_policy/cases/t_p060__02__car_isolation.sh`, `tests/domain_policy/p060.md`), damit Car-Isolation gezielt pro `--car-id` validiert wird. (2026-02-27)
- Tests/Smoke: Cars-CRUD-Smoke um Stats-Resolver-Faelle erweitert (`tests/smoke/smoke_cars_crud.sh`: 1 Car OK, >1 Cars Hard Error, car-scoped CSV-Checks), Dry-List in `tests/smoke/smoke_cli.sh` und Testdoku in `tests/README.md` nachgezogen. (2026-02-27)
- Docs: `docs/BENUTZERHANDBUCH.md` fuer strict car-scoped `--stats fuelups` aktualisiert. (2026-02-27)
- Tests/Domain-Policy: P-002-Case auf aktuellen Resolver-Fehlertext angepasst (`ERROR: unknown car_id=...` statt hartem `P-002`-String), damit Runner und Smoke-Suite wieder konsistent gruene Laeufe liefern. (2026-02-27)
- Tests/Smoke: Cars-Suite (`tests/smoke/smoke_cli.sh -c`) auf den kompatiblen Wrapper `tests/smoke_cars_crud.sh` umgestellt, sodass der Wrapper-Pfad selbst regressionsgesichert ist. (2026-02-27)
- Tests/Smoke: `tests/smoke/smoke_cars_crud.sh` um die heute eingefuehrten Car-Resolver-Checks erweitert (`--add/--list fuelups` bei 1 Car vs. >1 Cars inkl. Hard-Error-Pfad und car-scoped `--car-id`-Listing); `tests/smoke/smoke_cli.sh` Dry-List und `tests/README.md` entsprechend nachgezogen. (2026-02-27)
- Core/Fuelups: `--list fuelups` auf strikten Car-Scope umgestellt (`units/u_fuelups.pas`): Car-Kontext wird ueber `ResolveCarIdOrFail` aufgeloest und SQL listet nur noch `WHERE f.car_id = :car_id`; dadurch gelten 0/1/>1-Car-Regeln identisch zu `--add fuelups`. (2026-02-27)
- CLI/Validate+Help: `--car-id` fuer `--list fuelups` freigeschaltet (`units/u_cli_validate.pas`) und Help-/Usage-Texte entsprechend erweitert (`units/u_cli_help.pas`). (2026-02-27)
- Docs: `docs/BENUTZERHANDBUCH.md` um Car-Scope-Regeln fuer `--list fuelups` ergaenzt. (2026-02-27)
- CLI/Help: `units/u_cli_help.pas` um klaren Hinweis erweitert, dass `--car-id` bei `--add fuelups` in Multi-Car-Szenarien erforderlich ist (Kurz-Usage und Common-Options-Text nachgeschaerft). (2026-02-27)
- Core/Fuelups: `units/u_fuelups.pas` im Add-Flow auf Car-Resolver umgestellt (`ResolveCarIdOrFail`); harter Fallback `car_id=1` entfernt. Ohne `--car-id` wird jetzt genau 1 Fahrzeug automatisch aufgeloest, bei 0 oder >1 Fahrzeugen folgt ein Hard Error. (2026-02-27)
- Docs: Car-Resolver-Verhalten fuer `--add fuelups` in `docs/BENUTZERHANDBUCH.md` dokumentiert (inkl. 0/1/>1 Fahrzeuge ohne `--car-id`). (2026-02-27)
- UX/Core: `ResolveCarIdOrFail` (`units/u_car_context.pas`) fuer den Fall ohne Fahrzeuge praezisiert: `ERROR: no cars found.` mit zielgerichtetem Hinweis `Hint: create one first using --add cars` (statt Listen-Hinweis). (2026-02-27)
- Core: `units/u_car_context.pas` Fehlermeldungen geschaerft und vereinheitlicht: negative `car_id` jetzt als `invalid` (statt `unknown`), Hint-Zeilen konsistent in exaktem Format (`Hint: --list cars` / `Hint: specify --car-id <id>`), interne Resolver-Fehler ebenfalls englisch vereinheitlicht. (2026-02-27)
- Core: Neue Units `units/u_db_types.pas` (`TDB` als DB-Kontext-Alias) und `units/u_car_context.pas` eingefuehrt; `ResolveCarIdOrFail` implementiert als Single-Source-of-Truth fuer Car-ID-Aufloesung inkl. konsistenter Hard-Errors (0 Cars, unknown `car_id`, multiple cars ohne `--car-id`). (2026-02-27)
- Core: `units/u_cars.pas` um `CarsCount` (`SELECT COUNT(*) FROM cars`) und `CarsGetSingleId` (`SELECT id FROM cars ORDER BY id LIMIT 1`) erweitert als Resolver-Bausteine. (2026-02-27)
- Meta: `src/Betankungen.lpr` auf `APP_VERSION v0.7.0-sprint1` angehoben (interner Sprint-Stand, ohne Release-Tag). (2026-02-24)
- Docs: Neues Vision-Dokument `docs/VISION.md` als strategisches Brainstorming hinzugefuegt (Version 0.2 inkl. Vision-, Non-Goals- und Contribution-Leitlinien). (2026-02-24)
- Docs: Neues Dokument `docs/UI_ASCII_DRAW.md` fuer CLI-UI-Polishing und ASCII-Draw-Notizen angelegt (formatiert, emoji-frei, ohne Roadmap-Commitment). (2026-02-24)
- Core: Neue Domain-Unit `units/u_cars.pas` mit DB-basiertem CRUD eingefuehrt (`CarsAdd`, `CarsList`, `CarsEdit`, `CarsDelete`) sowie Pruef-APIs `CarsExists` und `CarsHasFuelups` ohne CLI-Abhaengigkeit. (2026-02-24)
- Core: `u_cars` nachgezogen: einheitlich `Q.Params.ParamByName`, Read-Pfade ohne erzwungene Write-Transaktion (read-only Rollback-Cleanup) und neutralere UNIQUE-Fehlermeldungen. (2026-02-24)
- CLI/Core: `cars` als CLI-Target verdrahtet (`--add/--list/--edit/--delete cars`) inkl. DB-Validierung fuer `--car-id` via `CarsExists`/`CarsHasFuelups`; Dispatch ruft Core-Funktionen aus `u_cars` direkt auf. (2026-02-24)
- Core/CLI: Doppelpruefung bei Cars-Edit reduziert: `u_cars` um `CarsGetById` erweitert und `HandleCarsEdit` auf direkten Record-Load umgestellt (kein `CarsList`+lokale ID-Suche mehr). (2026-02-24)
- CLI: Cars-Edit-Race/Missing-Row-Fehlertext praezisiert (`Fahrzeug nicht gefunden`) statt internem Sammelfehler. (2026-02-24)
- Core/CLI: Mini-Polish fuer Cars-Edit/GetById: Race-Fehlertext auf `P-002`-Kontext vereinheitlicht und `CarsGetById` ohne `FillChar` auf explizite Feldinitialisierung umgestellt. (2026-02-24)
- UI/CLI: Cars-Listenansicht auf Renderer umgestellt (`RenderCarsTable` in `u_fmt`) und Help/Usage um `cars`-Kommandos inkl. `--car-id`-Kontext erweitert. (2026-02-24)
- Tests: Neuer dedizierter Cars-CRUD-Smoke `tests/smoke/smoke_cars_crud.sh` (add/list/edit/delete ohne Referenzen + delete mit Referenzen als Fehler) inkl. Root-Wrapper und Integration in die `-c`-Smoke-Suite. (2026-02-24)
- Domain/Policy: Neue Guard-Policy `P-070` fuer Cars-Delete bei vorhandenen fuelup-Referenzen inkl. Domain-Policy-Fixture/Case (`tests/domain_policy/fixtures/p070_base.sql`, `tests/domain_policy/cases/t_p070__01__cars_delete_blocked_by_fuelups.sh`) und Doku-Updates in `docs/README.md`, `docs/STATUS.md`, `docs/ARCHITECTURE.md`, `tests/README.md`. (2026-02-24)
- Meta: `.gitignore` fuer lokale Arbeitsdateien generalisiert (`aktuelle_aenderungen_<datum>.md` via Pattern sowie `sprint_<nr>_commit_<nr>_von_<nr>.md`, plus Legacy-Muster `sprint_<d>.md` und `sprint_<dd>.md`), Header-Stand aktualisiert. (2026-02-24)
- Tests: Smoke-Suite um optionale Cars-Zusatzsuite erweitert (`-c`/`--cars`) inkl. Add/List-Flow und Edit/Delete-Validierungschecks; Clean-Home-Runner und `tests/README.md` entsprechend aktualisiert. (2026-02-24)

### Tooling / Assistance
- Implementation und Review erfolgten mit Unterstuetzung durch AI-Tools (u. a. Codex/ChatGPT) als Sparringspartner. Autorenschaft und fachliche Entscheidungen liegen beim Projekt. (2026-02-27)

## 0.6.0 – 2026-02-22

### Changed (User-Edits)
- Keine Eintraege.

### Changed (Codex)
- Meta: `src/Betankungen.lpr` auf `APP_VERSION 0.6.0` angehoben. (2026-02-22)
- Docs: Releaseabschluss 0.6.0 im Changelog durchgefuehrt; `[Unreleased]` auf Zielversion `0.7.x` vorbereitet. (2026-02-22)
- Docs: `docs/STATUS.md`, `docs/ARCHITECTURE.md` und `docs/README.md` auf 0.6.0-Abschluss und naechsten Fokus 0.7.x aktualisiert. (2026-02-22)
- Meta: Finales Release-Archiv `Betankungen_0_6_0.tar` per `scripts/kpr.sh --note "Release 0.6.0 final"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=32fc7d6f8361e857fa42e0389c7bd0b62c4ab0f6553eba671ad68a080f1d87ed`). (2026-02-22)
- Docs: Doku-Konsistenz auf Matrix-v1-Stand nachgezogen (`docs/ARCHITECTURE.md`, `docs/STATUS.md`, `docs/README.md`, `docs/BENUTZERHANDBUCH.md`) und Commit-Abgleich der Matrix-v1-Serie gegen `[Unreleased]` verifiziert (abgedeckt von `a8eaf83` bis `7a6474d`). (2026-02-22)
- Tests/Domain-Policy: P-060 um Car-Isolation-Case ergaenzt (`tests/domain_policy/cases/t_p060__02__car_isolation.sh`, `tests/domain_policy/fixtures/p060_car_isolation_base.sql`) fuer Guardrail gegen Cross-Car-Zyklen. (2026-02-22)
- Tests/Domain-Policy: P-050 um NO-Case ergaenzt (`tests/domain_policy/cases/t_p050__02__manual_gap_flag_no.sh`) inkl. Assert auf normales Speichern mit `missed_previous=0`. (2026-02-22)
- Fuelups/Domain: Gap-Flag-Policies ergaenzt (`P-050` Warning+Confirm fuer bewusstes `missed_previous=1` bei kleiner Distanz, `P-051` Guardrail gegen automatisches Setzen ohne Confirm). (2026-02-22)
- Tests/Domain-Policy: Golden-Templates fuer P-050/P-051/P-060 ergaenzt (`tests/domain_policy/fixtures/p050_base.sql`, `tests/domain_policy/fixtures/p051_base.sql`, `tests/domain_policy/fixtures/p060_base.sql`, `tests/domain_policy/cases/t_p050__01__manual_gap_flag_yes.sh`, `tests/domain_policy/cases/t_p051__01__no_auto_gap_flag_without_confirm.sh`, `tests/domain_policy/cases/t_p060__01__stats_skip_interval_missed_previous.sh`) inkl. Assertions auf Flag-Integritaet und deterministische Stats-Intervalle. (2026-02-22)
- Stats/Policy: P-060 explizit abgesichert (Intervalle ueber `missed_previous=1` werden fuer Verbrauch uebersprungen). (2026-02-22)
- Docs/Tests: Gap-Flag-/Stats-Blocke `P-050..P-051` und `P-060` als Doku-Referenzen aufgebaut (`tests/domain_policy/p050.md`, `tests/domain_policy/p051.md`, `tests/domain_policy/p060.md`, `tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`). (2026-02-22)
- Fuelups/Domain: Date-Policies ergaenzt (`P-040` Hard Error bei fehlendem/ungueltigem Datum, `P-041` Warning+Confirm bei Zukunftsdatum `> now + 10 min`). (2026-02-22)
- Tests/Domain-Policy: Golden-Templates fuer P-040/P-041 ergaenzt (`tests/domain_policy/fixtures/p040_base.sql`, `tests/domain_policy/fixtures/p041_base.sql`, `tests/domain_policy/cases/t_p040__01__datetime_invalid.sh`, `tests/domain_policy/cases/t_p041__01__future_date_warn_yes.sh`, `tests/domain_policy/cases/t_p041__02__future_date_warn_no.sh`) inkl. Exitcode-/Policy-Tag-/No-Write-Assertions. (2026-02-22)
- Docs/Tests: Date-Block `P-040..P-041` als Doku-Block aufgebaut (`tests/domain_policy/p040.md`, `tests/domain_policy/p041.md`, `tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`). (2026-02-22)
- Fuelups/Domain: Cost-/Price-Policies ergaenzt (`P-030` Hard Error bei negativem Gesamtpreis, `P-031` Warning+Confirm bei `cost_cents=0`, `P-032` Warning+Confirm bei `price_cents_per_liter<=0`). (2026-02-22)
- Tests/Domain-Policy: Golden-Templates fuer P-030/P-031/P-032 ergaenzt (`tests/domain_policy/fixtures/p030_base.sql`, `tests/domain_policy/fixtures/p031_base.sql`, `tests/domain_policy/fixtures/p032_base.sql`, `tests/domain_policy/cases/t_p030__01__cost_negative.sh`, `tests/domain_policy/cases/t_p031__01__cost_zero_warn_yes.sh`, `tests/domain_policy/cases/t_p031__02__cost_zero_warn_no.sh`, `tests/domain_policy/cases/t_p032__01__price_zero_warn_yes.sh`, `tests/domain_policy/cases/t_p032__02__price_zero_warn_no.sh`) inkl. Exitcode-/Policy-Tag-/No-Write-Assertions. (2026-02-22)
- Docs/Tests: Cost-/Price-Block `P-030..P-032` als Doku-Block aufgebaut (`tests/domain_policy/p030.md`, `tests/domain_policy/p031.md`, `tests/domain_policy/p032.md`, `tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`). (2026-02-22)
- Fuelups/Domain: Fuel-Policy-Tags fuer Literwerte eingefuehrt (`P-020` als Hard Error fuer `liters <= 0`/NaN, `P-021` als Warning+Confirm bei `liters > 150`). (2026-02-22)
- Tests/Domain-Policy: Golden-Templates fuer P-020/P-021 ergaenzt (`tests/domain_policy/fixtures/p020_base.sql`, `tests/domain_policy/fixtures/p021_base.sql`, `tests/domain_policy/cases/t_p020__01__liters_zero.sh`, `tests/domain_policy/cases/t_p020__02__liters_nan.sh`, `tests/domain_policy/cases/t_p021__01__fuel_warning_yes.sh`, `tests/domain_policy/cases/t_p021__02__fuel_warning_no.sh`) inkl. Exitcode-/Policy-Tag-/No-Write-Assertions. (2026-02-22)
- Docs/Tests: Fuel-/Plausibility-Block `P-020..P-022` als gemeinsamer Doku-Block aufgebaut (`tests/domain_policy/p020.md`, `tests/domain_policy/p021.md`, `tests/domain_policy/p022.md`, `tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`). (2026-02-22)
- Docs/Tests: Domain-Policy-README um expliziten Odometer-Policy-Block `P-010..P-013` erweitert (inkl. P-012 als Warning+Confirm innerhalb desselben Blocks). (2026-02-22)
- Fuelups/Domain: Odometer-Hard-Error-Klassifikation explizit nach Policy getrennt (`P-010` unter Start-KM, `P-011` unter Last-KM pro Fahrzeug, `P-013` bei Duplikat-KM delta=0). (2026-02-22)
- Tests/Domain-Policy: Golden-Templates fuer P-010/P-011/P-013 ergaenzt (`tests/domain_policy/fixtures/p010_base.sql`, `tests/domain_policy/fixtures/p011_base.sql`, `tests/domain_policy/fixtures/p013_base.sql`, `tests/domain_policy/cases/t_p010__01__odometer_below_start_km.sh`, `tests/domain_policy/cases/t_p011__01__odometer_below_last_km.sh`, `tests/domain_policy/cases/t_p013__01__odometer_duplicate_km.sh`) inkl. Exitcode-/Policy-Tag-/No-Write-Assertions. (2026-02-22)
- Docs/Tests: Policy-Doku fuer P-010/P-011/P-013 und Domain-Policy-Fixtures aktualisiert (`tests/domain_policy/p010.md`, `tests/domain_policy/p011.md`, `tests/domain_policy/p013.md`, `tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`). (2026-02-22)
- CLI/Fuelups: `--car-id <id>` fuer `--add fuelups` eingefuehrt; P-001/P-002 sauber getrennt (`P-001` bei fehlend/ungueltig <= 0, `P-002` bei nicht existenter car_id/FK), jeweils als Hard Error ohne Write. (2026-02-22)
- Tests/Domain-Policy: Golden-Templates fuer P-001/P-002 ergaenzt (`tests/domain_policy/fixtures/p001_base.sql`, `tests/domain_policy/fixtures/p002_base.sql`, `tests/domain_policy/cases/t_p001__01__car_id_zero.sh`, `tests/domain_policy/cases/t_p001__02__car_id_negative.sh`, `tests/domain_policy/cases/t_p002__01__car_id_missing_fk.sh`) inkl. Exitcode-/Policy-Tag-/No-Write-Assertions. (2026-02-22)
- Docs/Tests: Policy-Doku fuer P-001/P-002 und Domain-Policy-Fixtures aktualisiert (`tests/domain_policy/p001.md`, `tests/domain_policy/p002.md`, `tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`). (2026-02-22)
- Tests/Domain-Policy: Golden-Template P-022 eingefuehrt (`tests/domain_policy/fixtures/p022_base.sql`, `tests/domain_policy/cases/t_p022__01__consumption_warn_yes.sh`, `tests/domain_policy/cases/t_p022__02__consumption_warn_no.sh`) inkl. STDIN-Mapping und YES/NO-Assertions auf Exitcode, Meldung und DB-State. (2026-02-22)
- Docs/Tests: P-022-Template-Doku und Fixture-/Domain-Policy-README nachgezogen (`tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`, `tests/domain_policy/p022.md`). (2026-02-22)
- Meta: `AGENTS.md` Repo-Pflege-Rhythmus auf "Commit+Push pro logischer Einheit" geschwenkt und Release-Disziplin ergaenzt (Tags/Release erst bei `Done`). (2026-02-22)
- Tests/DB-Fixtures: `tests/domain_policy/fixtures/seed_big.sql` auf voll deterministische Fuelup-IDs umgestellt (`id = n` aus CTE, stabiles `ORDER BY n` fuer Seed-Reihenfolge). (2026-02-22)
- Tests/Domain-Policy: P-012-Shell-Cases robuster gemacht (Input-Mapping dokumentiert, NO-Case prueft explizite Distanzluecken-Abbruchmeldung, YES-Case prueft genau einen Insert bei Ziel-Odometer). (2026-02-22)
- Tests/Runner: `tests/domain_policy/run_domain_policy_tests.sh` um Fail-Fast-Pruefung fuer `sqlite3`/`fpc` erweitert und Prefix-Farbformatierung auf `stderr` ausgedehnt. (2026-02-22)
- Fuelups/Domain: Gap-Confirm-Policy geschaerft (`GAP_THRESHOLD_KM=1500`): bei Distanzwarnung fuehrt Antwort `n` jetzt zu einem harten Abbruch ohne Insert; nur `y` speichert und setzt `missed_previous=1`. (2026-02-20)
- Tests/Domain-Policy: Golden-Template P-012 eingefuehrt (`tests/domain_policy/fixtures/p012_base.sql`, `tests/domain_policy/cases/t_p012__01__gap_confirm_yes.sh`, `tests/domain_policy/cases/t_p012__02__gap_confirm_no.sh`) inkl. STDIN-Simulation und DB-Assertions. (2026-02-20)
- Tests/Runner: `tests/domain_policy/run_domain_policy_tests.sh` erweitert und startet jetzt Case-Dateien als `.pas` und `.sh`. (2026-02-20)
- Docs: Gap-Confirm-Abbruchregel und P-012-Template-Doku nachgezogen (`docs/BENUTZERHANDBUCH.md`, `docs/README.md`, `tests/README.md`, `tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`, `tests/domain_policy/p012.md`). (2026-02-20)
- Tests: Teststruktur auf `domain_policy`/`regression`/`smoke` konsolidiert, Domain-Policy-Runner eingefuehrt (`tests/domain_policy/run_domain_policy_tests.sh`) und kompatible Wrapper (`tests/smoke_cli.sh`, `tests/smoke_clean_home.sh`, `tests/run_unit_tests.sh`) auf die neuen Pfade umgestellt. (2026-02-20)
- Tests/DB: Zweigleisige Test-DB-Strategie umgesetzt mit SQL-Fixtures und Builder (`tests/domain_policy/helpers/build_test_dbs.sh`), der reproduzierbar `tests/domain_policy/fixtures/Betankungen_Big.db` (500 Fuelups) und `tests/domain_policy/fixtures/Betankungen_Policy.db` (deterministische Minimalfaelle) erzeugt. (2026-02-20)
- Docs: Testdoku auf neue Struktur/Namenskonvention/Runner-Konvention aktualisiert (`tests/README.md`, `tests/domain_policy/README.md`, `tests/domain_policy/fixtures/README.md`, `docs/ARCHITECTURE.md`, `docs/STATUS.md`, `docs/RESTORE.md`). (2026-02-20)
- Meta: `aktuelle_aenderungen.md` in `.gitignore` aufgenommen (lokale Session-Datei bleibt bewusst untracked); `.gitignore`-Stand auf 2026-02-20 aktualisiert. (2026-02-20)

## 0.5.6-0 – 2026-02-20

### Changed (User-Edits)
- Keine Eintraege.

### Changed (Codex)
- Refactor: CLI validation extracted into dedicated layer (`u_cli_validate`) mit klarer CLI-Pipeline Parse -> Validate -> Dispatch (`u_cli_parse` / `u_cli_validate` / Orchestrator). (2026-02-20)
- Meta: `src/Betankungen.lpr` auf `APP_VERSION 0.5.6-0` angehoben. (2026-02-20)
- Docs: Releaseabschluss 0.5.6-0 im Changelog durchgefuehrt; `[Unreleased]` auf Zielversion `0.6.0` vorbereitet. (2026-02-20)
- Meta: Finales Release-Archiv `Betankungen_0_5_6-0.tar` per `scripts/kpr.sh --note "Release 0.5.6-0 final"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=f0f0028392ef7c794068120ed964ce0c10b96ecac08f73ef6602ebc1b66b2028`). (2026-02-20)
- Tests/CLI-Validate: Neuer Framework-freier Unit-Test `tests/test_cli_validate.pas` plus Runner `tests/run_unit_tests.sh` eingefuehrt und in den Basis-Smoke integriert (`tests/smoke_cli.sh`); Runner auf Smoke-konforme Prefix-Farbcodierung (`[INFO]`, `[OK]`, `[FAIL]`) erweitert, Testdoku (`tests/README.md`) und Architekturhinweis Parse/Validate/Dispatch (`docs/ARCHITECTURE.md`) aktualisiert. (2026-02-20)
- CLI-Validate: Zeitraum-Policy in `ValidatePeriodPolicy` nach `u_cli_validate` verschoben (Kontext `--stats fuelups`, Range `--from < --to`, Open-Ended-Normalisierung); verbleibende Period-Checks aus `u_cli_parse` entfernt. (2026-02-20)
- CLI-Validate: Output-/Format-Policies fuer `--stats fuelups` granular nach `u_cli_validate` verschoben (`IsStatsFuelups`, `ValidateDashboardFormatPolicy`, `ValidateJsonCsvPrettyPolicy`, `ValidateMonthlyYearlyPolicy`); entsprechende Checks aus `u_cli_parse` entfernt. (2026-02-20)
- CLI-Validate: Domain-Policies fuer `fuelups` (append-only bei edit/delete) und `--stats`-Target (nur `fuelups`) in eigene Helper (`ValidateFuelupsPolicy`, `ValidateStatsTargetPolicy`) ausgelagert; entsprechende Checks aus `u_cli_parse` entfernt. (2026-02-20)
- CLI-Validate: Meta-/Action-Flow aus `u_cli_parse` in `u_cli_validate` verschoben (`IsStandaloneMeta`, `IsStandaloneAction`, `HasMainCommand`); Fehlerfall ohne Hauptkommando zentral als `Kein Kommando angegeben.` mit Fokus `efTarget`. (2026-02-20)
- CLI-Parser: Neue Stub-Unit `u_cli_validate` eingefuehrt und in `u_cli_parse` verdrahtet (`ValidateCommand(Cmd)` am Ende des Build-Flows, aktuell ohne Verhaltensaenderung mit `Result := True`). (2026-02-19)
- Meta: `AGENTS.md` um Regel erweitert: GitHub-Kommentare (Issues/PRs/Reviews) werden immer auf Englisch verfasst. (2026-02-19)
- Meta: `.vscode/` und `projekt_kontext.md` aus der Versionsverwaltung genommen (per `.gitignore` ausgeschlossen und aus dem Git-Index entfernt). (2026-02-19)
- Meta: `scripts/projekt_kontext.sh` Git-Status auf `git status --short --branch` erweitert (Branch + Ahead/Behind im Export) und zwei neue Kurzblaecke fuer `git diff --stat` sowie `git diff --cached --stat` hinzugefuegt; `docs/README.md` aktualisiert. (2026-02-19)
- Meta: `AGENTS.md` um verbindlichen `Repo-Pflege-Rhythmus` erweitert (Session-Start-Sync, Pflege je logischer Einheit waehrend der Session, Abschluss-Sync + Commit/Push am Session-Ende). (2026-02-19)
- Meta: `AGENTS.md` um Abschnitt `Repo-Pflege` erweitert (Codex uebernimmt auf Wunsch laufende Git-Repository-Pflege inkl. sicheren Leitplanken fuer Auth-Fallbacks und destruktive Aktionen); Stand-Datum aktualisiert. (2026-02-19)
- Meta: `scripts/projekt_kontext.sh` um Snapshot des Arbeitsstands erweitert (`git status --short` als eigener Abschnitt im Export); Doku in `docs/README.md` nachgezogen. (2026-02-19)
- Meta: Neues Skript `scripts/projekt_kontext.sh` fuer Session-Kontext ergaenzt (Git-tracked Struktur wie auf GitHub + Volltext-Export fuer `.pas`, `.lpr`, `.md`, `.sh` in `projekt_kontext.md`); `docs/README.md` um Nutzung/Beispiele erweitert. (2026-02-19)
- Meta: Projektweite `.gitignore` im Root erstellt (FPC-Buildartefakte, Laufzeitdaten wie `.backup/.releases` und DB-Dateien sowie Editor-/OS-Tempdateien). (2026-02-19)
- Docs: Zielversion im Unreleased-Block von `0.6.0` auf `0.5.6-0` umgestellt und Roadmap-Referenzen auf Zwischenversion/Folgeversion nachgezogen (`docs/STATUS.md`, `docs/ARCHITECTURE.md`, `docs/README.md`). (2026-02-19)

## 0.5.6 – 2026-02-19

### Changed (User-Edits)
- Keine Eintraege.

### Changed (Codex)
- Meta: Finales Release-Archiv `Betankungen_0_5_6.tar` per `scripts/kpr.sh --note "Release 0.5.6 final"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=28be5b44c5478c2ff6358caa08dcb8152055d3f2794d254947c445b859845839`). (2026-02-19)
- Docs: Releaseabschluss 0.5.6 im CHANGELOG durchgefuehrt; `[Unreleased]` auf Zielversion `0.6.0` vorbereitet. (2026-02-19)
- Docs: `docs/STATUS.md`, `docs/ARCHITECTURE.md` und `docs/README.md` auf 0.5.6-Abschluss und naechsten Fokus 0.6.0 aktualisiert. (2026-02-19)
- CLI-Parser: Parsing/Validierung aus `src/Betankungen.lpr` in neue Unit `units/u_cli_parse.pas` ausgelagert (`ParseCommand` + `BuildCommand` intern 1:1); Orchestrator nutzt nun `Cmd := ParseCommand` bei unveraenderter Logik. (2026-02-19)
- CLI-Help: `PrintUsage` auf Kompatibilitaets-Alias umgestellt und `PrintHelp` als strukturierte Vollhilfe neu aufgebaut (Usage/Commands/Common/Advanced/Stats/Examples, inkl. konsolidierter Optionen und Beispiele). (2026-02-19)
- CLI/Tests: Help-Struktur um Abschnitt `Stats options` erweitert und Smoke-Basislauf um drei feste Guardrails ergaenzt (`--help`-Keyword-Check, `--stats stations` Fehlerformat, `--stats fuelups --json --csv` als 3-Zeilen-Kurzfehler ohne Voll-Help). Doku in `tests/README.md` aktualisiert. (2026-02-18)
- CLI-Help: Tipp-Dopplung im Fehlerpfad behoben (`PrintUsageShort` Default ohne eingebettetes `"(Tipp: --help)"`, Tipp bleibt als eigene dritte Zeile aus `FailUsage`). (2026-02-18)
- Tests: `tests/smoke_cli.sh` Monthly/Yearly-Validierungschecks auf den neuen Fehlerkanal umgestellt (`stderr` statt `stdout` bei erwarteten Fehlerfaellen wie `--monthly` ohne Stats, Flag-Konflikte, `--pretty` ohne JSON). (2026-02-18)
- Tests: `tests/smoke_cli.sh` Checks fuer Fehlerpfade `--demo` ohne Seed und fehlerhaften `--db` auf den neuen Fehlerkanal angepasst (Fehlermeldungen jetzt in `stderr` statt `stdout`). (2026-02-18)
- Tests: `tests/smoke_cli.sh` um optionalen Guardrail fuer `--reset-config`-Fehlerpfad erweitert (Config nicht loeschbar via Schreibschutz-Simulation, mit Skip falls im Laufzeitumfeld nicht reproduzierbar); Doku in `tests/README.md` aktualisiert. (2026-02-18)
- CLI: `src/Betankungen.lpr` nutzt in Reset-/Exception-Pfaden jetzt konsistent `FailUsage` statt direkter `WriteLn/Halt`-Kombinationen (Config-Loeschfehler + unerwartete Exceptions), inklusive passendem Exit-Code/Fokus. (2026-02-18)
- CLI-Help: `units/u_cli_help.pas` um `PrintUsageShort` erweitert; `FailUsage` auf kompakten 3-Zeilen-Fehlerpfad (Fehlerzeile, kontextsensitive Kurz-Usage, `--help`-Tipp) umgestellt. (2026-02-18)
- Meta: Header in `src/Betankungen.lpr` an die aktuelle Help-Architektur angepasst (Usage/About/FailUsage delegiert an `u_cli_help`, Parserzustand/Output-Trennung klarer dokumentiert). (2026-02-17)
- CLI-Help: `units/u_cli_help.pas` auf zentrale Help-Ausgabe umgestellt und an `u_cli_types` angebunden (`TErrorFocus` + `ErrorFocusToFlag`); `PrintUsage`, `PrintAbout` und `FailUsage` aus `src/Betankungen.lpr` in die Unit uebernommen (inkl. `--about`). (2026-02-17)
- CLI: Lokale Help-Helfer in `src/Betankungen.lpr` entfernt und Aufrufe auf `u_cli_help` umverdrahtet. (2026-02-17)
- Meta/Docs: Header- und Kommentarkonsistenz fuer `src/Betankungen.lpr` sowie alle Kern-Units (ausser `u_cli_help.pas`/`u_cli_types.pas`) professionell vereinheitlicht: erweiterte Datei-Header, konsistente `CREATED/UPDATED`-Metadaten und praezisere API-/Abschnittskommentare in `u_db_common`, `u_db_init`, `u_db_seed`, `u_fmt`, `u_fuelups`, `u_log`, `u_stations`, `u_stats`, `u_table`. (2026-02-17)
- CLI-Types: `units/u_cli_types.pas` fachlich/professionell voll kommentiert (erweiterter Unit-Header, klare Enum-/Record-Felddoku und Mapping-Helper-Kommentare) bei unveraenderter Logik. (2026-02-17)
- CLI-Types: `units/u_cli_types.pas` bereinigt und als zentrale Typquelle konsolidiert (einheitliche Definitionen fuer `TTableKind`, `TCommandKind`, `TErrorFocus`, `TCommand` + Helper `ErrorFocusToFlag`). (2026-02-17)
- CLI: Lokale Typduplikate in `src/Betankungen.lpr` entfernt; Parser/FailUsage auf `u_cli_types` inkl. `TErrorFocus`-Enum umgestellt. (2026-02-17)
- CLI-Types: Template-Hinweis bei `TErrorFocus` in `units/u_cli_types.pas` durch konkrete Produktiv-Doku fuer Parser-/Short-Usage-Mapping ersetzt. (2026-02-17)
- CLI: Neues Meta-Flag `--about` in `src/Betankungen.lpr` ergaenzt (Parsing, Usage, Meta-Dispatch) inkl. Ausgabe einer About-Seite mit Danksagung. (2026-02-17)
- Docs: `docs/README.md` um Meta-Kommandos + Danksagung erweitert und `docs/BENUTZERHANDBUCH.md` um `--about` aktualisiert. (2026-02-17)
- Changed: `scripts/net_recover.sh` um `--only-if-offline` erweitert; Interface-Neustart erfolgt damit nur bei fehlgeschlagenen Connectivity-Checks. (2026-02-17)
- Added: Neues Hilfsskript `scripts/net_recover.sh` fuer Linux-Netzwerkdiagnose und Interface-Neustart (inkl. `--info-only`, Auto-Interface-Erkennung, Connectivity-Checks). (2026-02-17)
- Docs: `docs/README.md` um `scripts/net_recover.sh` ergaenzt und Skript-Uebersicht aktualisiert. (2026-02-17)
- Meta: Release-Archiv `Betankungen_0_5_5.tar` nach STATUS/CHANGELOG-Feinschliff erneut via `scripts/kpr.sh --note "Post-release docs sync: STATUS + CHANGELOG final note"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=3fad313df723976f2aff3c083d0acfc628780ed456d14bfd240f48a7a4e2aba4`). (2026-02-16)
- Docs: `docs/STATUS.md` um kurzen Hinweis auf finalisiertes 0.5.5-Release-Artefakt inkl. Post-Release-Doku-Sync ergänzt. (2026-02-16)
- Meta: Release-Archiv `Betankungen_0_5_5.tar` nach Doku-Konsistenzbereinigung erneut via `scripts/kpr.sh --note "Post-release docs consistency sync: 0.5.5 changelog cleanup"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=845ac6833039675a51a4f7aca4e3ffae683192c61b76219ec7096970a3eb2c2c`). (2026-02-16)
- Docs: Konsistenz-Bereinigung im CHANGELOG: 0.5.5-Abschnitt auf finalen Release-Stand reduziert (entfernte 0.5.4-Resteintraege und veraltete Zwischenstaende wie "TODO/ohne Wirkung" bei Yearly). (2026-02-16)

## 0.5.5 – 2026-02-16

### Changed (User-Edits)
- Keine Eintraege.

### Changed (Codex)
- Meta: Finales Release-Archiv `Betankungen_0_5_5.tar` per `scripts/kpr.sh --note "Release 0.5.5 final"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=1ede5cdb00f9e28c1e3d056d96756eaf430deda78c1449e1cdec3e16a776b512`). (2026-02-16)
- Meta: Header-Metadaten in `src/Betankungen.lpr` an den aktuellen Stats-Umfang angepasst (Statistik-Dispatch jetzt explizit inkl. Monats- und Jahresoptionen). (2026-02-16)
- Added: `--yearly` fuer `--stats fuelups` finalisiert (Text + JSON mit `kind: "fuelups_yearly"`; Jahresaggregation aus Monatsdaten). (2026-02-16)
- Fixed: CLI-Validierung fuer Yearly-Kombinationen konsolidiert (`--yearly` nur mit `--stats fuelups`, exklusiv zu `--monthly`, kein Mix mit `--csv`/`--dashboard`). (2026-02-16)
- Changed: Smoke-Suite fuer Monthly/Yearly ausgebaut und steuerbar gemacht (`-m`, `-y`, `-a`, `-l/--list`, `--keep-going`) inkl. farblicher Ausgabe und Wrapper-Forwarding. (2026-02-16)
- Changed: Doku fuer 0.5.5-Abschluss nachgezogen (`docs/README.md`, `docs/BENUTZERHANDBUCH.md`, `docs/STATUS.md`, `docs/ARCHITECTURE.md`; Yearly-Feature + Restriktionen + Fokus 0.5.6). (2026-02-16)
- Tests: `tests/smoke_cli.sh` um `-l/--list` erweitert (Dry-List aller geplanten Checks ohne Ausfuehrung) und um Fail-Mode-Schalter `--keep-going`; Standard ist jetzt fail-fast. (2026-02-16)
- Tests: Smoke-Ausgaben in `tests/smoke_cli.sh` und `tests/smoke_clean_home.sh` farblich markiert (`[INFO]` gelb, `[OK]` gruen, `[FAIL]` rot; `[LIST]` cyan in `smoke_cli.sh`). (2026-02-16)
- Tests: `tests/smoke_clean_home.sh` reicht zusaetzlich `-l/--list` und `--keep-going` an `smoke_cli.sh` durch. (2026-02-16)
- Tests: Smoke-Suites fuer Monthly/Yearly per Flags steuerbar gemacht (`tests/smoke_cli.sh`: `-m`, `-y`, `-a`); Defaultlauf bleibt kurz ohne Zusatzsuiten. (2026-02-16)
- Tests: `tests/smoke_clean_home.sh` reicht `-m/-y/-a` an `smoke_cli.sh` durch und dokumentiert die Optionen. (2026-02-16)
- Tests: `tests/smoke_cli.sh` um eine vollstaendige Yearly-Smoke-Suite erweitert (Erfolgsfaelle, Validierungskonflikte, JSON-Strukturchecks, Period-/Pretty-Kombinationen inkl. leerer DB-Fall). (2026-02-16)
- Docs: `tests/README.md` um die neue Yearly-Regression-Suite erweitert und Stand-Datum aktualisiert. (2026-02-16)
- Seed: Demo-Befuellung in `u_db_seed` auf groesseren Datensatz erweitert: effektive Fuelup-Zielmenge 300-500 (bei abweichender Anfrage Normalisierung in den Zielbereich) und Zeitverteilung ueber 3-5 Jahre. (2026-02-16)
- Stats: Abschnitt 5 umgesetzt: echte Jahresaggregation (`--yearly`) in Text und JSON aus Monatsdaten gefaltet (`TYearAgg`, `YearAggAdd/Sort`, JSON `kind: "fuelups_yearly"`). (2026-02-16)
- Stats: `ShowFuelupStatsJson` auf eine zentrale Signatur konsolidiert (`Monthly, Yearly, Pretty`) und Forward-/Implementierungsreihenfolge vereinheitlicht; behebt FPC-Fehler "var name changes Pretty => Yearly". (2026-02-16)

## 0.5.4 – 2026-02-15

### Changed (User-Edits)
- Keine Eintraege.

### Changed (Codex)
- CLI: `src/Betankungen.lpr` auf `APP_VERSION 0.5.4` angehoben und First-Run-/DB-Path-Flow angepasst (Default/Config ohne Prompt, interaktive Pfadabfrage nur als Fallback bei fehlgeschlagener DB-Provisionierung inkl. Retry + Erststart-Hinweis). (2026-02-15)
- Docs: `docs/BENUTZERHANDBUCH.md` auf den neuen First-Run-Flow aktualisiert (Default ohne Prompt, interaktive Pfadabfrage nur als Fallback). (2026-02-15)
- CLI: `ResolveDbPath`-Aufruf in `src/Betankungen.lpr` gegen IO-Fehler abgesichert (`try/except`) und auf denselben Fallback-UX umgeleitet (nur interaktiv ohne `--db`/`--demo`, inkl. Config-Speicherung). (2026-02-15)
- CLI: Frischstart ohne Argumente initialisiert jetzt still `config.ini` + Default-DB vor dem Command-Parsing; dadurch kein Fehler "Kein Kommando" beim ersten Aufruf. (2026-02-15)
- Docs: `docs/README.md` und `docs/BENUTZERHANDBUCH.md` um das Verhalten "frischer Start ohne Argumente" ergänzt. (2026-02-15)
- CLI: No-Command-Bootstrap erweitert: Bei vorhandener Config aber fehlender DB wird die DB jetzt ebenfalls still automatisch angelegt. (2026-02-15)
- CLI: Pfad-Getter (`GetDefaultDbPath`/`GetConfigPath`) ohne IO-Seiteneffekte; Verzeichnisanlage erfolgt nun gezielt in Schreibpfaden. (2026-02-15)
- CLI: Interaktiver Fallback auf zentralen Retry-Helper (`PromptAndPersistDbPath`) umgestellt, sodass bei nicht speicherbaren Eingabepfaden erneut abgefragt wird. (2026-02-15)
- Docs: `docs/README.md` und `docs/BENUTZERHANDBUCH.md` um den Fall "Config vorhanden, DB fehlt" ergänzt. (2026-02-15)
- Tests: `tests/smoke_cli.sh` um 0.5.4-First-Run-Szenarien erweitert (frischer Start, Config ohne DB, nicht schreibbarer Default mit Prompt-Retry). (2026-02-15)
- Docs: `tests/README.md` um die neuen Smoke-Fälle ergänzt und Stand-Datum aktualisiert. (2026-02-15)
- Tests: `tests/smoke_cli.sh` um weitere CLI-Guardrail-Checks erweitert (`--show-config` fresh HOME, `--reset-config` behaelt DB, `--demo` ohne Seed ohne Prompt, fehlerhafter `--db` ohne Prompt). (2026-02-15)
- Docs: `tests/README.md` um die zusaetzlichen Guardrail-Checks ergaenzt. (2026-02-15)
- Tests: Neues Wrapper-Script `tests/smoke_clean_home.sh` fuer den finalen Smoke-Run in sauberer HOME/XDG-Sandbox eingefuehrt (`--keep-home` optional). (2026-02-15)
- Docs: `tests/README.md` um Nutzung von `tests/smoke_clean_home.sh` ergaenzt. (2026-02-15)

## 0.5.3 – 2026-02-14

### Changed (User-Edits)
- CLI: `APP_VERSION` auf `0.5.3` gesetzt und Datumsstand in `src/Betankungen.lpr` aktualisiert. (2026-02-14)

### Changed (Codex)
- Meta: Finales Release-Archiv `Betankungen_0_5_3.tar` per `scripts/kpr.sh` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=5a6ecf54d24a72bc96110622d47a5140680b532f9dc485a1274db66b8f243338`). (2026-02-14)
- Docs: Releaseabschluss 0.5.3 im CHANGELOG durchgefuehrt; `[Unreleased]` auf Zielversion `0.5.4` vorbereitet. (2026-02-14)
- Docs: `STATUS` auf Zielversion `0.5.4` umgestellt und 0.5.3 als abgeschlossen markiert. (2026-02-14)
- Docs: `README` um konsistenten Roadmap-Kurzstand erweitert (0.5.3/0.5.4/0.5.5/0.6.0) und Jahres-Summary explizit auf 0.5.5 verankert; Stand-Datum aktualisiert. (2026-02-14)
- Docs: Roadmap-Dokumentation auf neue Evolutionslinie ausgerichtet (0.5.3 Reifegrad, 0.5.4 First-Run-UX, 0.5.5 Jahres-Summary, 0.6.0 Fahrzeug-Domain-Konsolidierung) in `ARCHITECTURE`, `STATUS` und `BENUTZERHANDBUCH`. (2026-02-14)
- Meta: `AGENTS.md` um verbindlichen FPC-Build-Standard erweitert (`fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`) und Stand-Datum aktualisiert. (2026-02-14)
- Stats: `u_stats` Zyklus-Collector auf v4-Reihenfolge gebracht (`car_id`/`missed_previous` zuerst), inkl. Reset bei Car-Wechsel und bestaetigter Luecke vor Datensatzverarbeitung. (2026-02-14)
- DB: `u_db_init` um Cars-Immutability-Trigger (`odometer_start_km`/`odometer_start_date`) erweitert; Header auf aktuellen Stand gesetzt. (2026-02-14)
- Fuelups: `u_fuelups` auf Default-Car-Flow (`car_id=1`) angepasst; Odometer-/Gap-Checks und Tankmengen-Warnung gem. Diff-Reihenfolge ausgerichtet. (2026-02-14)
- DB: `u_db_init` setzt v4-Meta-Defaults (`odometer_start_km/date`) nur bei neuen DBs und nutzt `meta` als Migrationsquelle fuer `cars`-Startwerte. (2026-02-13)
- DB: `u_db_init` migriert `cars` auf erweitertes v4-Schema (`plate`, `note`, `odometer_start_km`, `odometer_start_date`) und legt Default-Fahrzeug `Hauptauto` an. (2026-02-13)
- Seed: `u_db_seed` erweitert `cars` auf v4-full inkl. kompatibler ALTER-Faelle und schreibt Default `Hauptauto` mit Startwerten. (2026-02-13)
- Fuelups: Odometer-Domainvalidierung pro Fahrzeug ergaenzt (Start-KM-Grenze, monotone Reihenfolge, Gap-Threshold fuer `missed_previous`, Tankmengen-Warnung >150L). (2026-02-13)
- Stats: Zyklus-Collector wertet `missed_previous` aus und resettet laufende Sammler bei gesetzter Luecke. (2026-02-13)
- Docs: README/BENUTZERHANDBUCH/ARCHITECTURE/STATUS um neue v4-Details und Validierungslogik aktualisiert. (2026-02-13)
- DB: `migrations/v3_to_v4.sql` FK-PRAGMA-Reihenfolge auf robuste SQLite-Variante korrigiert (`foreign_keys=OFF` vor `BEGIN`, `ON` nach `COMMIT`). (2026-02-13)
- DB: Manuelle SQL-Migration `migrations/v3_to_v4.sql` fuer Fuelups-Rebuild (car_id + missed_previous), v4-Indizes und Trigger-Recreate ergaenzt. (2026-02-13)
- Docs: README-Projektstruktur um Ordner `migrations/` ergaenzt. (2026-02-13)
- DB: Schema auf v4 erweitert (`cars`, `fuelups.car_id`, `fuelups.missed_previous`) inkl. v3->v4 Migration in `u_db_init` ueber `fuelups_new` + Datenuebernahme. (2026-02-13)
- Fuelups: `--add fuelups` schreibt nun `car_id` und `missed_previous`; Fahrzeugauswahl ist bei mehreren Fahrzeugen interaktiv, bei einem Fahrzeug automatisch. (2026-02-13)
- Fuelups: Listenansicht zeigt Fahrzeugbezug (`car_name`) und Detailblock zeigt `MissPrev`-Status. (2026-02-13)
- Seed: Demo-Schema auf v4 angehoben (cars + neue fuelups-Felder), inkl. kompatibler ALTER-Faelle fuer bestehende Demo-DBs. (2026-02-13)
- Stats: Zyklusbildung trennt Daten strikt pro `car_id` (keine Vermischung zwischen Fahrzeugen). (2026-02-13)
- Docs: README/BENUTZERHANDBUCH/STATUS/ARCHITECTURE fuer Schema v4 und neues Fuelup-Verhalten aktualisiert. (2026-02-13)
- Meta: Erster Snapshot per `scripts/backup_snapshot.sh` angelegt (`.backup/2026-02-13_1757`, Note: "Initial 0.5.3 workflow"). (2026-02-13)
- Meta: `.archive/` nach `knowledge_archive/` umbenannt und als Wissens-Archiv dokumentiert (`knowledge_archive/README.md`). (2026-02-13)
- Meta: `kpr.sh` nach `scripts/kpr.sh` verlagert; Projektroot behaelt kompatiblen Wrapper `kpr.sh`. (2026-02-13)
- Meta: Backup-Snapshot-Skript `scripts/backup_snapshot.sh` mit `.backup/index.json`-Pflege ergaenzt. (2026-02-13)
- Docs: Restore-Dokumentation `docs/RESTORE.md` ergaenzt (Auswahl, Hash-Pruefung, Entpacken, Plausibilitaetscheck). (2026-02-13)
- QA: `tests/` mit `tests/smoke_cli.sh` und `tests/README.md` fuer lokale Smoke-Checks ergaenzt. (2026-02-13)
- Docs: README/ARCHITECTURE/STATUS/DESIGN_PRINCIPLES auf neue Ordnerstruktur (`scripts`, `.backup`, `knowledge_archive`) aktualisiert. (2026-02-13)
- Docs: README-Releaseabschnitt um expliziten Ordner `.releases/` fuer finalisierte `.tar`-Archive + `release_log.json` erweitert. (2026-02-13)
- Meta: `kpr.sh` schreibt Release-Archive standardmaessig nach `.releases/` und pflegt Log in `.releases/release_log.json`. (2026-02-12)
- Docs: README/STATUS/ARCHITECTURE/DESIGN_PRINCIPLES auf `.releases`-Pfade fuer Release-Artefakte aktualisiert. (2026-02-12)
- Docs: STATUS auf konsistenten 0.5.2-Abschluss gebracht und Kurzfazit auf "0.5.2 freigegeben" aktualisiert. (2026-02-12)
- Docs: ARCHITECTURE auf Stand 0.5.2 aktualisiert (Stand-Datum, Funktionsumfang, abgeschlossener 0.5.2-Abschnitt). (2026-02-12)
- Docs: README/BENUTZERHANDBUCH um konkrete Dashboard-Schnellbeispiele ergaenzt. (2026-02-12)
- Docs: DESIGN_PRINCIPLES-Nummerierung konsolidiert (doppelte "9" entfernt) und Stand-Datum aktualisiert. (2026-02-12)

## 0.5.2 – 2026-02-12

### Added
Ziel von 0.5.2:
- Ein kompaktes, scanbares Konsolen-Dashboard fuer `--stats fuelups`, das sich visuell klar von der Tabellen-Ausgabe unterscheidet und langfristig als Grundlage fuer ein einheitliches Unicode-Box-Design dient.
- Kein CLI-Umbau.
- Kein neues Subcommand.
- Keine GUI.
- Dashboard ist ein alternativer Renderer innerhalb des bestehenden Stats-Systems.

### Changed (User-Edits)
- u_fmt: Dashboard-Bar (Kosten-Balken) inkl. Farblogik, ANSI-sichere Box-Zeilen und Konfig-Variablen ergaenzt; `FmtScaledInt` ins Interface gehoben. (2026-02-11)
- u_stats: Dashboard-Renderer (`RenderFuelupDashboardText`) und `ShowFuelupDashboard`-Overloads ergaenzt (API). (2026-02-11)

### Changed (Codex)
- u_fmt: Dashboard-Farblogik um `TDashColorMode` erweitert (static/relative); `ResolveDashColor` nutzt nun `Cents` + `MaxCents`. (2026-02-12)
- Docs: README um Hinweis auf umschaltbare Dashboard-Farblogik (Cent vs. Promille) ergaenzt. (2026-02-12)
- u_fmt: `AnsiVisibleLen` auf UTF-8-sichtbare Laenge (nach `StripAnsi`) umgestellt; Padding bei Mehrbyte-Zeichen stabilisiert. (2026-02-12)
- CLI: Stats-Dispatch strukturell refaktoriert (`--dashboard`-Pfad im finalen Else-Block), Verhalten unveraendert. (2026-02-12)
- CLI: `--dashboard` fuer `--stats fuelups` ergaenzt (Parsing, Usage, Validierung, Dispatch zu `ShowFuelupDashboard`). (2026-02-12)
- Docs: README/BENUTZERHANDBUCH/STATUS auf `--dashboard`-Flag und CLI-Status aktualisiert. (2026-02-12)
- u_table: UTF-8-sichtbare Breite/Cut fuer stabiles Tabellenlayout mit Mehrbyte-Zeichen ergaenzt. (2026-02-12)
- Docs: README um UTF-8-Hinweis bei `u_table.pas` ergaenzt. (2026-02-12)
- Meta: `kpr.sh` nutzt versionierten Archivnamen `Betankungen_<version>.tar`. (2026-02-11)
- Docs: README/DESIGN_PRINCIPLES auf versionierten `kpr.sh`-Archivnamen aktualisiert. (2026-02-11)
- CLI: Temporaere Dashboard-Testverdrahtung in `--stats fuelups` wieder entfernt. (2026-02-11)
- Docs: STATUS-Hinweis zur temporaeren CLI-Verdrahtung entfernt. (2026-02-11)
- Docs: README/STATUS auf Dashboard-API und Box-Engine-Erweiterungen aktualisiert. (2026-02-11)
- u_stats: Header-Doku um Dashboard-Ausgabe ergaenzt. (2026-02-11)
- u_fmt: Unicode-Box-Engine (BoxTop/BoxSep/BoxBottom/BoxLine/BoxKV) ergaenzt. (2026-02-11)
- Docs: README um Unicode-Box-Engine in `u_fmt` ergaenzt. (2026-02-11)
- Docs: Zielbeschreibung 0.5.2 in STATUS/CHANGELOG ergaenzt. (2026-02-11)
- Docs: Roadmap 0.5.2 um Status-Dashboard ergaenzt. (2026-02-11)
- Docs: Release-Prep 0.5.1 (CHANGELOG/STATUS/ARCHITECTURE) konsolidiert. (2026-02-11)
- Docs: DESIGN_PRINCIPLES Stand + Output-Formate-Policy ergaenzt. (2026-02-11)
- Meta: `kpr.sh` als Release-Archiv + Log-Skript im Projektroot ergaenzt. (2026-02-11)
- Meta: `kpr.sh` APP_VERSION-Auslese im Log korrigiert. (2026-02-11)
- Meta: `kpr.sh` schreibt Release-Summary ins Log und gibt sie auf STDOUT aus. (2026-02-11)
- Meta: `kpr.sh` normalisiert `release_log.json` auf kompakte JSON-Form. (2026-02-11)
- Meta: `kpr.sh` Log-Append robust gegen ungueltige JSONs (Neuschreiben via Python). (2026-02-11)

## 0.5.1 – 2026-02-11
### Decisions
- Offene Grenzen bei Filtern datengetrieben festgelegt: nur `--from` => `to = MAX(fueled_at)`, nur `--to` => `from = MIN(fueled_at)` (kein "heute"). (2026-02-09)
- Zyklusregel am Rand festgelegt: Zyklus zählt nur, wenn Start- und End-Volltank im Zeitraum liegen (vollständig im Zeitraum). (2026-02-09)
- JSON-avg festgelegt: `avg_l_per_100km` als scaled Integer (z. B. `avg_l_per_100km_x100`), keine Strings. (2026-02-09)

### Changed (User-Edits)
- CLI: `--csv`/`--pretty` Flags inkl. Validierung/Usage/Dispatch fuer `--stats fuelups` ergaenzt. (2026-02-11)
- CLI: `--from`/`--to` Parsing (YYYY-MM oder YYYY-MM-DD) mit Normalisierung auf `PeriodFromIso`/`PeriodToExclIso`. (2026-02-09)
- CLI: Zentrale Validierung von `--from/--to` (nur mit `--stats fuelups`, from < to, Open-Ended-Reset). (2026-02-09)
- CLI: `--monthly` Flag fuer `--stats fuelups` ergaenzt (Parsing, Validierung, Usage, Dispatch). (2026-02-10)
- u_fmt: CSV-Helper `CsvTokenStrict`/`CsvJoin`/`CsvJoinInt64` ergänzt. (2026-02-10)
- Meta: Projektweite Codex-Regeln in `AGENTS.md` definiert. (2026-02-10)
- Meta: Definition „größere Änderungen“ und Prioritäten in `AGENTS.md` ergänzt. (2026-02-10)
- Meta: Präzisierungen zu Header-Datum, vorhandenen Headern und Doku-Priorität in `AGENTS.md`. (2026-02-10)
- Meta: CHANGELOG-Pflege folgt dem bestehenden Datei-Stil/Abschnitt. (2026-02-10)
- Meta: CHANGELOG-Kennzeichnung User vs. Codex in `AGENTS.md` festgelegt. (2026-02-10)
- Meta: CHANGELOG-Einträge immer unter `[Unreleased]` in bestehenden Unterabschnitten. (2026-02-10)
- Meta: CHANGELOG-Beispielformat in `AGENTS.md` ergänzt. (2026-02-10)
- Meta: CHANGELOG-Beispiel explizit unter „Changed (Codex)“ verankert. (2026-02-10)
- Meta: CHANGELOG-Beispiel auch fuer „Changed (User-Edits)“ ergänzt. (2026-02-10)
- Meta: CHANGELOG-Beispiele in `AGENTS.md` konkretisiert. (2026-02-10)
- Stats: Helper `ResolvePeriodBounds` und `ApplyPeriodWhere` in `u_stats.pas` eingefuegt. (2026-02-09)
- Stats: `ShowFuelupStats` nutzt Period-Resolve + optionales WHERE in Kopf- und Zyklus-Query. (2026-02-09)
- Stats: `ShowFuelupStatsJson` nutzt Period-Resolve + optionales WHERE und gibt `avg_l_per_100km_x100` aus. (2026-02-09)
- Docs: README-Abschnitt zu `u_stats.pas` auf `avg_l_per_100km_x100` aktualisiert. (2026-02-09)
- Orchestrator: `--stats fuelups` Dispatch reicht Period-Parameter an `u_stats` durch (Text/JSON). (2026-02-09)
- Docs: JSON-Beispielausgabe fuer `--stats fuelups --json` in README ergaenzt. (2026-02-09)

### Changed (Codex)
- Docs: BENUTZERHANDBUCH/README/STATUS/ARCHITECTURE auf `--csv`/`--pretty` aktualisiert. (2026-02-11)
- Docs: 0.5.1 CLI-Flag-Skizze (csv/pretty + Validierung/Dispatch) in STATUS ergänzt. (2026-02-11)
- Docs: ARCHITECTURE CSV-Helper Hinweis an Stats-CSV-Realitaet angepasst. (2026-02-11)
- Stats: `ShowFuelupStatsJson` nutzt Collector-Resultat konsistent via `R`. (2026-02-11)
- Stats: `ShowFuelupStatsCsv` nutzt Collector-Resultat konsistent via `R`. (2026-02-11)
- Stats: `ShowFuelupStats` nutzt Collector-Resultat konsistent via `R`. (2026-02-11)
- Stats: JSON-Renderer auf R-Parameter-Namenskonvention angepasst. (2026-02-11)
- Stats: CSV-Renderer an Vorgabe angepasst (feste Kopfzeilen, Rows via CsvJoin, striktes Token nur fuer Month). (2026-02-11)
- Stats: Collector-Init auf FillChar/Nullstart umgestellt (vereinheitlicht). (2026-02-11)
- Stats: JSON-Writer (compact/pretty) fuer `RenderFuelupStatsJson` eingefuehrt. (2026-02-11)
- Stats: Sammelstruktur + Collector/Renderer fuer Fuelup-Stats eingefuehrt. (2026-02-11)
- Stats: CSV-Ausgabe fuer Zyklen/Monate in `u_stats.pas` ergaenzt. (2026-02-11)
- Stats: JSON-Pretty-Overload eingefuehrt; Standardausgabe nun kompakt. (2026-02-11)
- Stats: Monats-Textausgabe zeigt nur die Monats-Tabelle (keine Zyklusliste). (2026-02-11)
- Docs: README/BENUTZERHANDBUCH/STATUS/ARCHITECTURE auf CSV/JSON-Stand aktualisiert. (2026-02-11)
- CLI: Kalender-validiertes Datums-Parsing fuer `YYYY-MM-DD` implementiert. (2026-02-09)
- Build: DateUtils fuer Datumsarithmetik (`IncDay`, `IncMonth`) eingebunden. (2026-02-09)
- Stats: Public API von `u_stats.pas` um Overloads mit Zeitraum-Parametern erweitert. (2026-02-09)
- Stats: `ShowFuelupStats`/`ShowFuelupStatsJson` Signaturen um `Monthly` erweitert. (2026-02-10)
- Stats: Monatsaggregation (Text) fuer `--stats fuelups --monthly` ergaenzt. (2026-02-10)
- Stats: JSON-Ausgabe fuer `--stats fuelups --json --monthly` mit `kind: "fuelups_monthly"`. (2026-02-10)
- Stats: Debug-Helper `DbgEffectivePeriod` eingefuegt (open-ended/closed, no-rows Hinweis). (2026-02-09)
- Stats: Effektiver Zeitraum nach Kopf-Query einmalig geloggt (Text + JSON). (2026-02-09)
- Stats: Zyklus-Algorithmus kanonisiert (Sammler nur zwischen Volltanks; End-Volltank schliesst Zyklus). (2026-02-09)
- Stats: Accumulator-Namen vereinheitlicht (`Acc*` statt `Bucket*`). (2026-02-09)
- Docs: README/STATUS um Stats-Debug-Hinweis (Kopf-Query, open-ended/closed, no-rows) ergaenzt. (2026-02-09)
- Stats: `ShowFuelupStats(DbPath)`/`ShowFuelupStatsJson(DbPath)` als Wrapper auf die Overloads umgestellt. (2026-02-09)

### Fixed (Codex)
- CLI: `--csv`/`--pretty` werden nach Parsing zentral validiert; Kombinationen mit `--json` werden sauber abgelehnt. (2026-02-11)
- Stats: Advanced records aktiviert und Monats-Sortierung auf lokale Kopie umgestellt (const-sicher). (2026-02-11)
- Stats: Zyklusabschluss zaehlt End-Volltank in Liter- und Kosten-Summe (kein 0,0 bei Endtank ohne Teilbetankung). (`units/u_stats.pas`) (2026-02-10)
- Build: `--to` Parsing ohne inline `var` (objfpc-kompatibel). (2026-02-09)
- Build: `TryParseYYYYMMDD` gibt nun korrekt `Result` und Werte zurueck. (2026-02-09)
- Stats: `u_stats.pas` Compile-Fixes (doppelte Var-Deklaration, `Q.SQL.Text` ohne `+=`). (2026-02-09)
- Stats: `ShowFuelupStatsJson` fehlende Eff-Variablen ergänzt; doppelte Eff-Deklaration bereinigt. (2026-02-09)
- Stats: NULL-sichere Summen/Counts (`FieldInt64OrZero`) zur Vermeidung leerer Integer-Konvertierung. (2026-02-09)

## 0.4.2 – 2026-02-07
### Added
- Vorbereitung auf Subcommands (internes Modell), CLI bleibt unverändert.
- Neues Backup-Skript `kpr.sh`: tar von docs/src/units, SHA-256 + JSON-Log. (2026-02-04)
- Stats: JSON-Ausgabe fuer `--stats fuelups` (`--json`). (2026-02-07)

### Changed
- u_db_init: Header auf einheitliches UPDATED/AUTHOR-Format gebracht. (2026-02-07)
- u_fmt: Header-Hinweis zum Dezimaltrennzeichen korrigiert. (2026-02-07)
- u_stats: Header um JSON-Stats ergaenzt. (2026-02-07)
- CLI: `--json` für `--stats fuelups` ergänzt (Parsing, Validierung, Usage, Dispatch). (2026-02-07)
- Stats: Leerzeile zwischen Header und Tabelle ergänzt. (2026-02-07)
- Docs: Stand-Datum in `INITIAL_CONTEXT.md` und `CONSTRAINTS.md` auf 2026-02-07 aktualisiert. (2026-02-07)
- Docs: Release-Logging in `DESIGN_PRINCIPLES.md` und `STATUS.md` ergänzt. (2026-02-07)
- Docs: Hinweis auf `kpr.sh` (Release-Log) in README/ARCHITECTURE ergänzt. (2026-02-07)
- Backup: `kpr.sh` loggt Release-Infos in `release_log.json` und erfasst Quellen im JSON. (2026-02-07)
- Stats: Header-UPDATED in `u_stats.pas` auf 2026-02-07 gesetzt. (2026-02-07)
- Stats: Zyklus-Tabelle erst nach Header/Checks ausgeben; Kosten klarer zwischen SQL-Summe und Zyklus-Summe getrennt. (2026-02-07)
- Docs: README/ARCHITECTURE/STATUS auf aktuellen Funktionsumfang gebracht (Fuelups, Stats-Kosten, Tabellen-Renderer, Input-Parsing, JSON). (2026-02-07)
- Logging-Doku: Quiet unterdrueckt explizit alle Ausgaben; `Dbg(...)` nutzt `[TRC]`. (2026-02-04)
- Design-Prinzipien: neue Ausgabe- & Logging-Regel plus Quiet Output Policy (`--quiet`). (2026-02-04)
- Stats: `total_cents` in den SELECTs erfasst und im Debug geloggt. (2026-02-04)
- Stats: Aggregation von `total_cents` und Gesamtkosten-Ausgabe ergänzt. (2026-02-04)
- Stats: Gesamtkosten mit Tausenderpunkt formatiert. (2026-02-04)
- Stats: Tabellen-Setup mit TTable-Spalten initialisiert (Vorbereitung Renderer). (2026-02-04)
- Stats: Zyklusabschluss fügt Tabellenzeile inkl. Kosten hinzu. (2026-02-04)
- Stats: Gesamtzeile (Summe) via TTable-Footer ergänzt. (2026-02-04)
- Stats: TTable-Ausgabe via `T.Write` ergänzt. (2026-02-04)
- Stats: Kostenformatierung in `FormatCentsAsEuro` auf Integer-Format umgestellt. (2026-02-04)
- Tabellen-Renderer: `TTable` in `u_table` ergänzt (Spalten, Zeilen, Separator, Write). (2026-02-04)
- Tabellen-Renderer: Separatoren unterstützen jetzt Doppellinie fuer Footer (`=`). (2026-02-04)
- Tabellen-Renderer: Header-Trennlinie als Doppellinie formatiert. (2026-02-04)
- u_stats: Header-Doku an aktuellen Funktionsumfang angepasst. (2026-02-04)
- u_table: Header-Doku um TTable-Renderer erweitert. (2026-02-04)
- Stats: Kosten gesamt wieder strikt als Fixed-Point formatiert. (2026-02-04)
- Stats: Kraftstoff-Ausgabe nutzt Fixed-Point-Formatter statt Float. (2026-02-04)
- Stats: Summenzeile wird nur bei vorhandenen Zyklen in die Tabelle gesetzt. (2026-02-04)
- Stats: Ausgabe-Block nach DB-Block gezogen (Lesbarkeit). (2026-02-04)
- Stats: Tabellen-Write direkt nach Summenzeile platziert. (2026-02-04)

### Fixed
- `--quiet` unterdrueckt jetzt auch die leere Zeile vor der Debug-Tabelle. (2026-02-04)

---

## 0.4.1 – 2026-02-03
### Added
- `--stats fuelups` mit Volltank-Zyklus-Auswertung (Strecke, Verbrauch, Zeitraum).
- `u_stats.pas` als neue Unit fuer Auswertungen.
- `--trace` fuer gezielte Trace-Ausgaben.
### Changed
- Logging-Policy: informative Ausgaben ueber `Msg(...)` (respektiert Quiet).
- Debug/Trace getrennt: `Dbg` nutzt Trace, Debug-Tabelle bleibt bei `--debug`.
### Fixed
- Ausgaben bei `--seed` in Quiet sauber und maschinenfreundlich.

---

## 0.4.0 – 2026-02-01
### Added
- Demo-DB-Workflow: `--seed` zum Erzeugen/Aktualisieren, `--demo` zur Nutzung.
- Seed-Parameter: `--stations`, `--fuelups`, `--seed-value`, `--force`.
- Erweiterte Usage-/Hilfeausgabe inkl. Beispiele und Hinweise.
### Changed
- CLI-Policy erweitert: `--seed` ist exklusiv und nutzt immer die Demo-DB.
- Demo-Seed-Daten auf ASCII angepasst (Umlaute als ae/oe/ue).
### Fixed
- Stabilere Fehlerausgabe beim Seeding (saubere Fehlermeldung statt Stacktrace).
- `sqlite_sequence`-Reset defensiv, falls Tabelle fehlt.

---

## 0.3.0 – 2026-01-28
### Added
- Vollständige Fachlogik für Betankungen (`fuelups`): add / list / `--detail`, JOIN auf `stations`
- Bon-exaktes Parsing für `fuelups` (skalierte Integer, keine Float-Rundungsfehler)
- Striktes Transaktionshandling pro Business-Aktion (fuelups)
- Neues, standardisiertes Header-System für alle Units zur besseren Wartbarkeit
### Changed
- Schema-Version auf v3 aktualisiert (inkl. `fuelups`)

---

## 0.2.2 – 2026-01-21 (Projektstruktur & DB-Pfad-Handling)
### Added
- **Persistenz:** DB-Pfad wird nun in `~/.config/Betankungen/config.ini` gespeichert.
- **XDG-Support:** Automatische Nutzung von Standardverzeichnissen für Daten und Konfiguration.
- **CLI-Tools:** Befehle `--show-config` und `--reset-config` für einfachere Wartung hinzugefügt.
- **Flexibilität:** Mit `--db` kann der Pfad nun für einzelne Aufrufe überschrieben werden.

### Fixed
- Build-Umgebung: Inkonsistenzen zwischen Lazarus-IDE und VS Code (fpc) behoben.
- Bereinigung verwaister Lazarus-Projekt-Metadaten.

---

## 0.2.1 – Stabilisierung & Dokumentation
### Changed
- **Robustheit:** Umfassende Einführung von `try...finally` zur sicheren Ressourcen-Freigabe (Memory Leaks verhindert).
- **UX:** Fehlermeldungen verständlicher gestaltet und interaktive Texte verfeinert.
- **Logging:** Debug-Ausgaben vereinheitlicht und lesbarer formatiert.


---

## 0.2.0 – Stations-CRUD
- Vollständige CRUD-Funktionalität für `stations`
- Interaktive Eingabe und Bearbeitung
- Alt-/Neu-Vergleich bei Änderungen
- Detail- und Standardlisten
- UNIQUE-Constraint auf Adresse
- Debug-Logging mit Tabellenlayout
- Zentrale Logging-Unit (`u_log`)

---

## 0.1.0 – Initiale Basis
- SQLite-Initialisierung (`EnsureDatabase`)
- Technische Meta-Tabelle (`meta`)
- Schema-Versionierung
- CLI-Grundgerüst mit Flag-Parsing
- Debug- und Quiet-Modus
