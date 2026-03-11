# CHANGELOG
**Stand:** 2026-03-11

Alle wichtigen Änderungen an diesem Projekt werden hier dokumentiert.

## [Unreleased]
### Zielversion
0.9.x
Ziel: naechste priorisierte Entwicklungsphase nach Abschluss 0.8.0 (Scope-Freeze + klarer Folgefokus).

### Sprint / Commit References
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

### Changed
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
