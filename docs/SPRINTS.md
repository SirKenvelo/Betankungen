# SPRINTS
**Stand:** 2026-04-01

Dieses Dokument fuehrt die Sprint-Narrative (Ziel, Fortschritt, Commit-Folge, Artefakte, Abschluss-Tag).

## Sprint 1 - Road to 0.8.x

- Status: done
- Ziel: CSV/JSON-Output-Contracts haerten und Smoke-Tests auf feldbasierte Contract-Checks umstellen.

### Commit-Folge

1. S1C1/4
- Thema: Multi-Car Stats-CSV in `tests/smoke/smoke_multi_car_context.sh` auf feldbasierte Assertions migriert.
- Git-Commit: `da4e74c` (Finalisierung)
- Artefakte: `sprint_1_commit_1_von_4.md`, `sprint_1_commit_1_von_4.diff`

2. S1C2/4
- Thema: cars_crud Stats-CSV Scope in `tests/smoke/smoke_cars_crud.sh` auf feldbasierte Contract-Checks migriert.
- Git-Commit: `aefca0d`
- Artefakte: `sprint_1_commit_2_von_4.md`, `sprint_1_commit_2_von_4.diff`

3. S1C3/4
- Thema: smoke_clean_home Audit + CSV-Helper-Polish (`csv_row_count`) + knowledge_archive-Regeln.
- Status: done
- Git-Commit: `b4273c4`
- Artefakte: `sprint_1_commit_3_von_4.md`, `sprint_1_commit_3_von_4.diff`

### Abschluss-Tag

- Sprint-Abschluss: S1C4/4 (Konsistenz-Pass, Wrapper-Check, Lint, Tagging)
- Abschluss-Tag: `sprint-1-done` (gesetzt)

## Sprint 2 - Export Contract Rollout

- Status: done
- Ziel: JSON-/CSV-Export-Contract v1 schrittweise in Runtime und Smoke-Tests verankern.

### Commit-Folge

1. S2C1/4
- Thema: Export-Contract-Basis in `docs/EXPORT_CONTRACT.md` eingefuehrt.
- Git-Commit: `4feba89`
- Artefakte: `sprint_2_commit_1_von_4.md`, `sprint_2_commit_1_von_4.diff`

2. S2C2/4
- Thema: JSON-Stats-Export um Meta-Felder (`contract_version`, `generated_at`, `app_version`) erweitert; Smoke-Guardrails fuer Presence-Checks nachgezogen.
- Git-Commit: `701b34f`
- Artefakte: `sprint_2_commit_2_von_4.md`, `sprint_2_commit_2_von_4.diff`

3. S2C3/4
- Thema: Stats-CSV um Contract-Versionierung erweitert (Spalte `contract_version` als erste Spalte) und betroffene Smoke-/Policy-Tests auf den neuen Header/Rows synchronisiert.
- Git-Commit: `b08a4a6`
- Artefakte: `sprint_2_commit_3_von_4.md`, `sprint_2_commit_3_von_4.diff`

4. S2C4/4
- Thema: Abschluss Sprint 2 mit Doku-Schaerfung (`yearly` ohne CSV), Hash-/Status-Finalisierung und Volltest-Verifikation.
- Git-Commit: `94f502c`
- Artefakte: `sprint_2_commit_4_von_4.md`, `sprint_2_commit_4_von_4.diff`

### Abschluss-Tag

- Sprint-Abschluss: S2C4/4 (Doku-Finalisierung + Volltest-Verifikation)
- Abschluss-Tag: `sprint-2-done` (pending, wird erst nach expliziter Freigabe gesetzt und gepusht)

## Sprint 3 - DB-Migrationsdisziplin ab Schema v4

- Status: done
- Ziel: Ab `schema_version >= 4` keine Neuinitialisierung mehr, sondern konsequente Schema-Migration pro Version.

### Commit-Folge

1. S3C1/3
- Thema: Cars-Schema fuer VIN + Registrierungs-Metadaten vorbereitet (`vin`, `reg_doc_path`, `reg_doc_sha256`) ohne CLI-Wiring und ohne aktive Runtime-Nutzung.
- Status: done
- Git-Commit: `f25c3ca`
- Artefakte: `sprint_3_commit_1_von_3.md`, `sprint_3_commit_1_von_3.diff` (pending)

2. S3C2/3
- Thema: Migration-Smoke-Framework aufgebaut (`tests/smoke/smoke_migrations.sh`) mit Flag-Strategie (`--v4-to-v5`) und Runner-Integration ueber `--migrations` in `smoke_cli`/`smoke_clean_home`.
- Status: done
- Git-Commit: `ff5fb27`
- Artefakte: `sprint_3_commit_2_von_3.md`, `sprint_3_commit_2_von_3.diff` (pending)

3. S3C3/3
- Thema: VIN-Policy-/UX-Prep dokumentiert (`docs/VIN_POLICY_UX_PREP.md`) und Architektur-/Sprint-Doku fuer den optionalen VIN-Ansatz finalisiert.
- Status: done
- Git-Commit: `c518fda`
- Artefakte: `sprint_3_commit_3_von_3.md`, `sprint_3_commit_3_von_3.diff` (pending)

### Abschluss-Tag

- Sprint-Abschluss: S3C3/3 (Doku-Finalisierung VIN-Policy/UX + Traceability)
- Abschluss-Tag: `sprint-3-done` (pending, wird erst nach expliziter Freigabe gesetzt und gepusht)

## Sprint 4 - i18n Policy First

- Status: done
- Ziel: verbindliche i18n-Regelbasis vor jeglichem Runtime-Wiring schaffen.

### Commit-Folge

1. S4C1/3
- Thema: i18n-Policy und Architektur-Doku vor technischer Verdrahtung eingefuehrt (`docs/ARCHITECTURE.md`, `docs/STATUS.md`, optionaler Einstieg in `docs/README.md`, Leitplanke in `docs/DESIGN_PRINCIPLES.md`).
- Status: done
- Git-Commit: `dd25860`
- Artefakte: `sprint_4_commit_1_von_3.md`, `sprint_4_commit_1_von_3.diff`

2. S4C2/3
- Thema: technisches i18n-Skeleton verdrahtet (`units/u_i18n.pas` mit `TMsgId`/`Tr()`, Config-Flow auf `language=de|en|pl` normalisiert/persistiert, keine breite Textmigration).
- Status: done
- Git-Commit: `c1a6348`
- Artefakte: `sprint_4_commit_2_von_3.md`, `sprint_4_commit_2_von_3.diff`

3. S4C3/3
- Thema: erste risikoarme Runtime-Meta-Texte kontrolliert auf `Tr()` migriert (Config-Status, First-Run-Hinweise, generische Systemmeldung), ohne breite Help-/Fehlertextmigration und ohne testgetriebene Textanpassungen.
- Status: done
- Git-Commit: `87e5f6e`
- Artefakte: `.artifacts/sprint_4_commit_3_von_3.md`, `.artifacts/sprint_4_commit_3_von_3.diff`

### Abschluss-Tag

- Sprint-Abschluss: S4C3/3 (Policy umgesetzt, Skeleton verdrahtet, Textmigration + Testhaertung abgeschlossen)
- Abschluss-Tag: `sprint-4-done` (pending, wird erst nach expliziter Freigabe gesetzt und gepusht)

## Sprint 5 - Performance Sweep (trigger-basiert)

- Status: done
- Ziel: verbleibende CSV-Volltext-/Regex-Pruefungen in Domain-Policy auf feldbasierte Token-Assertions finalisieren.

### Commit-Folge

1. S5C1/1
- Thema: `tests/domain_policy/cases/t_p060__01__stats_skip_interval_missed_previous.sh` und `tests/domain_policy/cases/t_p060__02__car_isolation.sh` auf `tests/helpers/csv.sh` umgestellt (Header/Spalten/Rowcount/Felder), ohne Vollzeilen-Regex-Matches.
- Status: done
- Git-Commit: `47fbc0a`
- Artefakte: `.artifacts/sprint_5_commit_1_von_1.md`, `.artifacts/sprint_5_commit_1_von_1.diff`

### Abschluss-Tag

- Sprint-Abschluss: S5C1/1 (Domain-Policy-CSV-Assertions final feldbasiert)
- Abschluss-Tag: `sprint-5-done` (gesetzt)

## Sprint 6 - Modulstrategie operationalisieren

- Status: done
- Ziel: Modulstrategie auf finalen ADR-Status heben und Scope-Grenzen fuer Core-vs-Module verbindlich schaerfen.

### Commit-Folge

1. S6C1/4
- Thema: `ADR-0005` auf `accepted` finalisiert und Scope-Kriterien fuer Core/Module verbindlich dokumentiert; ADR-Index synchronisiert.
- Status: done
- Git-Commit: `2886ec5`
- Artefakte: `.artifacts/sprint_6_commit_1_von_4.md`, `.artifacts/sprint_6_commit_1_von_4.diff`

2. S6C2/4
- Thema: Minimalen Modul-Handshake umgesetzt (neue Contract-Unit `u_module_info`, Companion-Skeleton `src/betankungen-maintenance.lpr` mit `--module-info`-JSON und `--help`/`--version`), plus Core-Version auf `0.9.0-dev` synchronisiert.
- Status: done
- Git-Commit: `f81757f`
- Artefakte: `.artifacts/sprint_6_commit_2_von_4.md`, `.artifacts/sprint_6_commit_2_von_4.diff`

3. S6C3/4
- Thema: Smoke-Absicherung fuer Companion-Module erweitert (`tests/smoke/smoke_modules.sh` + Wrapper `tests/smoke_modules.sh`) und als optionale Zusatzsuite `--modules` in `smoke_cli`/`smoke_clean_home` integriert.
- Status: done
- Git-Commit: `f91a650`
- Artefakte: `.artifacts/sprint_6_commit_3_von_4.md`, `.artifacts/sprint_6_commit_3_von_4.diff`

4. S6C4/4
- Thema: Modul-Contract auf operative v1-Baseline finalisiert (`docs/MODULES_ARCHITECTURE.md`), Feldsemantik fuer `--module-info` geschaerft (inkl. `db_schema_version`-Abgrenzung zum Core-Schema) und Entry-/Status-Doku synchronisiert.
- Status: done
- Git-Commit: `c15482b`
- Artefakte: `.artifacts/sprint_6_commit_4_von_4.md`, `.artifacts/sprint_6_commit_4_von_4.diff`

### Abschluss-Tag

- Sprint-Abschluss: S6C4/4 (Contract-Finalisierung, Smoke-Verifikation, Abschluss-Sync)
- Abschluss-Tag: `sprint-6-done` (gesetzt)

## Sprint 7 - Fleet Stats MVP

- Status: done
- Ziel: `--stats fleet` als klaren, fahrzeuguebergreifenden Stats-Modus schrittweise einziehen.

### Commit-Folge

1. S7C1/4
- Thema: CLI-Validate/Dispatch fuer `--stats fleet` eingefuehrt (Target parsing/validation, Orchestrator-Dispatch, MVP-Textausgabe in `u_stats`) und Basis-Smoke/Docs nachgezogen.
- Status: done
- Git-Commit: `3ee7355`
- Artefakte: `.artifacts/sprint_7_commit_1_von_4.md`, `.artifacts/sprint_7_commit_1_von_4.diff`

2. S7C2/4
- Thema: Fleet-JSON-MVP umgesetzt (`--stats fleet --json [--pretty]`) inkl. Export-Meta/`kind` im Core, Validierungsfreigaben fuer fleet-json/pretty sowie Smoke-/Domain-Policy-Checks und Doku-Sync.
- Status: done
- Git-Commit: `bcaa02e`
- Artefakte: `.artifacts/sprint_7_commit_2_von_4.md`, `.artifacts/sprint_7_commit_2_von_4.diff`

3. S7C3/4
- Thema: Fleet-Guardrails gehaertet und regressionsgesichert (Validate + Smoke) fuer ungueltige Fleet-Optionen (`--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`) inkl. Doku-Sync.
- Status: done
- Git-Commit: `4a1c4e7`
- Artefakte: `.artifacts/sprint_7_commit_3_von_4.md`, `.artifacts/sprint_7_commit_3_von_4.diff`

4. S7C4/4
- Thema: Sprint-7-Finalisierung (DoD-Check + Verifikationslauf + finaler Doku-Sync fuer Fleet-MVP Text/JSON/Guardrails).
- Status: done
- Git-Commit: `aa9281e`
- Artefakte: `.artifacts/sprint_7_commit_4_von_4.md`, `.artifacts/sprint_7_commit_4_von_4.diff`

### Abschluss-Tag

- Sprint-Abschluss: S7C4/4 (Fleet-MVP Text+JSON, Tests, Doku-Finalisierung)
- Abschluss-Tag: `sprint-7-done` (gesetzt)

## Sprint 8 - Cost Analytics MVP

- Status: done
- Ziel: `--stats cost` als erste Kostenperspektive einziehen (fuel-basiert) und den Pfad fuer spaetere Maintenance-Integration vorbereiten.

### Commit-Folge

1. S8C1/4
- Thema: Neuer CLI-Target-Pfad `--stats cost` inkl. Core-Dispatch und Cost-MVP-Textausgabe eingefuehrt; Validierung/Smoke/Domain-Policy sowie Entry-/Status-Doku auf Sprint-8-Start synchronisiert.
- Status: done
- Git-Commit: `f9e0cdb`
- Artefakte: `.artifacts/sprint_8_commit_1_von_4.md`, `.artifacts/sprint_8_commit_1_von_4.diff`

2. S8C2/4
- Thema: Cost-JSON-MVP (`--stats cost --json [--pretty]`) im Core aktiviert (Validate/Help/Dispatch/Renderer), Export-Contract um `kind: "cost_mvp"` erweitert und Domain-Policy-/Smoke-Abdeckung auf JSON compact/pretty nachgezogen.
- Status: done
- Git-Commit: `379343b`
- Artefakte: `.artifacts/sprint_8_commit_2_von_4.md`, `.artifacts/sprint_8_commit_2_von_4.diff`

3. S8C3/4
- Thema: Cost-Guardrails gehaertet und regressionsgesichert; Domain-Policy und Smoke decken jetzt ungueltige Cost-Kombinationen (`--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`, `--car-id`) explizit ab.
- Status: done
- Git-Commit: `e7c1f6f`
- Artefakte: `.artifacts/sprint_8_commit_3_von_4.md`, `.artifacts/sprint_8_commit_3_von_4.diff`

4. S8C4/4
- Thema: Sprint-8-Finalisierung mit DoD-Check, finalem Verifikationslauf und Abschluss-Sync der Sprint-/Status-/Entry-Doku.
- Status: done
- Git-Commit: `680e962`
- Artefakte: `.artifacts/sprint_8_commit_4_von_4.md`, `.artifacts/sprint_8_commit_4_von_4.diff`

### Abschluss-Tag

- Sprint-Abschluss: S8C4/4 (Cost-MVP Text+JSON/Contract, Tests, Doku-Finalisierung)
- Abschluss-Tag: `sprint-8-done` (gesetzt)

## Sprint 9 - Cost Scoped Analytics v1.1

- Status: done (`S9C1/4` + `S9C2/4` + `S9C3/4` + `S9C4/4` done)
- Ziel: `--stats cost` um Zeitraum-/Fahrzeug-Scope erweitern und Contract-seitig absichern.

### Commit-Folge

1. S9C1/4
- Thema: CLI-Scope fuer Cost freigeschaltet (`--from/--to`, `--car-id`) in Validate/Help/Dispatch; Smoke/Domain-Policy und Doku synchronisiert.
- Status: done
- Git-Commit: `628cd71`
- Artefakte: `.artifacts/sprint_9_commit_1_von_4.md`, `.artifacts/sprint_9_commit_1_von_4.diff`

2. S9C2/4
- Thema: Cost-Collector und Textausgabe auf aktiven Period-/Car-Scope erweitert; Smoke deckt jetzt die echte Filterwirkung fuer `--from` und `--car-id` regressionssicher ab.
- Status: done
- Git-Commit: `b757d3d`
- Artefakte: `.artifacts/sprint_9_commit_2_von_4.md`, `.artifacts/sprint_9_commit_2_von_4.diff`

3. S9C3/4
- Thema: Cost-JSON-Contract um Scope-/Period-Felder erweitert (`scope_*`, `period_*`) und Contract-/Smoke-Checks auf den neuen Key-Stand synchronisiert.
- Status: done
- Git-Commit: `fcb4ab5`
- Artefakte: `.artifacts/sprint_9_commit_3_von_4.md`, `.artifacts/sprint_9_commit_3_von_4.diff`

4. S9C4/4
- Thema: Guardrails/Regression fuer Cost-Scope finalisiert: neue Domain-Policy `P-061` sichert Car-/Period-Isolation fuer `--stats cost`; Sprint-9-Doku auf Abschlussstand synchronisiert.
- Status: done
- Git-Commit: `297d588`
- Artefakte: `.artifacts/sprint_9_commit_4_von_4.md`, `.artifacts/sprint_9_commit_4_von_4.diff`

### Geplante Bloecke

- S9C1/4: done - CLI-Scope-Enablement fuer Cost (`--from/--to`, `--car-id`) inkl. Validate-/Help-/Dispatch-Anpassungen.
- S9C2/4: done - Cost-Collector + Textausgabe auf Zeitraum-/Fahrzeug-Scope erweitert.
- S9C3/4: done - Cost-JSON-Contract um Scope-/Period-Felder erweitert und Export-Contract-Checks nachgezogen.
- S9C4/4: done - Guardrails/Regression + Sprint-Finalisierung (Smoke/Domain-Policy/Doku-Sync).

### Abschluss-Tag

- Sprint-Abschluss: S9C4/4 (done)
- Abschluss-Tag: `sprint-9-done` (gesetzt)

## Sprint 10 - Maintenance Companion v0.2

- Status: done (`S10C1/4` + `S10C2/4` + `S10C3/4` + `S10C4/4` done)
- Ziel: `betankungen-maintenance` von Handshake-Skeleton auf fachliche Basisfunktionalitaet heben.

### Commit-Folge

1. S10C1/4
- Thema: Modul-Schema + idempotente Migration umgesetzt (`--migrate [--db <path>]`, `module_meta`, `maintenance_events`) inkl. Smoke-Absicherung.
- Status: done
- Git-Commit: `278408a`
- Artefakte: `.artifacts/sprint_10_commit_1_von_4.md`, `.artifacts/sprint_10_commit_1_von_4.diff`

2. S10C2/4
- Thema: Companion-CLI fuer Maintenance-CRUD-Basis umgesetzt (`--add maintenance`, `--list maintenance` inkl. `--car-id`-Scope) und Module-Smoke erweitert.
- Status: done
- Git-Commit: `aad05f8`
- Artefakte: `.artifacts/sprint_10_commit_2_von_4.md`, `.artifacts/sprint_10_commit_2_von_4.diff`

3. S10C3/4
- Thema: Companion-Stats-Basis umgesetzt (`--stats maintenance` Text + JSON/Pretty inkl. optionalem `--car-id`-Scope), Aggregation in `u_maintenance_db` ergaenzt und Module-Smoke auf Stats-Contract gehaertet.
- Status: done
- Git-Commit: `25b6080`
- Artefakte: `.artifacts/sprint_10_commit_3_von_4.md`, `.artifacts/sprint_10_commit_3_von_4.diff`

4. S10C4/4
- Thema: Modul-Qualitaetsgate finalisiert (negative Guardrail-Checks in `smoke_modules`, Contract-Doku `maintenance_stats_v1` in `docs/EXPORT_CONTRACT.md`, Abschluss-Sync fuer Modul-/Entry-/Statusdoku).
- Status: done
- Git-Commit: `f15fcf3`
- Artefakte: `.artifacts/sprint_10_commit_4_von_4.md`, `.artifacts/sprint_10_commit_4_von_4.diff`

### Geplante Bloecke

- (keine offenen Bloecke)

### Abschluss-Tag

- Sprint-Abschluss: S10C4/4 (pending)
- Abschluss-Tag: `sprint-10-done` (pending)

## Sprint 11 - Integration + 0.9.0 Readiness

- Status: done (`S11C1/4` + `S11C2/4` + `S11C3/4` + `S11C4/4` done)
- Ziel: Kostenintegration fuel + maintenance stabilisieren und 0.9.0-Readiness absichern.

### Commit-Folge

1. S11C1/4
- Thema: Expliziter Integrationsmodus im Cost-Pfad (`--maintenance-source none|module`) inkl. Validate-Policy, Text-/JSON-Contract-Feldern und Guardrail (`module` aktuell klarer Not-Active-Fehler bis S11C2/4).
- Status: done
- Git-Commit: `47dcee8`
- Artefakte: `.artifacts/sprint_11_commit_1_von_4.md`, `.artifacts/sprint_11_commit_1_von_4.diff`

2. S11C2/4
- Thema: Cost-Aggregation fuel + maintenance aktiviert. `--maintenance-source module` liest Companion-Stats (`maintenance_stats_v1`) ein und integriert Maintenance-Kosten im Core; bei fehlender/ungueltiger Quelle greift ein robuster Fallback mit explizitem Hinweis (`maintenance_source_note`) statt Hard-Fail.
- Status: done
- Git-Commit: `274111c`
- Artefakte: `.artifacts/sprint_11_commit_2_von_4.md`, `.artifacts/sprint_11_commit_2_von_4.diff`

3. S11C3/4
- Thema: Regression/CI fuer beide Integrationsmodi gehaertet. Neuer Gate-Check `tests/regression/run_cost_integration_modes_check.sh` deckt `--maintenance-source none|module` inkl. aktivem Companion-Pfad und expliziten Fallback-Szenarien ab und ist in `make verify` sowie CI verankert.
- Status: done
- Git-Commit: `015ba1b`
- Artefakte: `.artifacts/sprint_11_commit_3_von_4.md`, `.artifacts/sprint_11_commit_3_von_4.diff`

4. S11C4/4
- Thema: 0.9.0-Readiness-Paket finalisiert. Scope-Freeze wurde dokumentiert, der standardisierte lokale Preflight (`scripts/release_preflight.sh`, `make release-preflight`) eingefuehrt und die Release-Checkliste unter `docs/RELEASE_0_9_0_PREFLIGHT.md` verankert.
- Status: done
- Git-Commit: `cbfa3e8`
- Artefakte: `.artifacts/sprint_11_commit_4_von_4.md`, `.artifacts/sprint_11_commit_4_von_4.diff`

### Geplante Bloecke

- (keine offenen Bloecke)

### Abschluss-Tag

- Sprint-Abschluss: S11C4/4 (done)
- Abschluss-Tag: `sprint-11-done` (pending, wird erst nach expliziter Freigabe gesetzt und gepusht)

## Sprint 12 - Road to 1.0.0 Kickoff

- Status: done
- Ziel: verbindlichen 1.0.0-Gate-Plan operativ starten und den Zyklus
  releasefaehig strukturieren.

### Geplante Bloecke

- S12C1/4: done - Zyklusstart technisch fixieren (`APP_VERSION 1.0.0-dev`) und
  Entry-Doku (`README`/`STATUS`/`CHANGELOG`) konsistent auf 1.0.0-Kurs setzen.
- S12C2/4: done - Backlog-Downstream fuer 1.0.0 aufsetzen (konkrete Tasks aus
  `BL-0012`, `BL-012`, optional `BL-0013`).
- S12C3/4: done - DoD-/Gate-Kriterien fuer 1.0.0 in Verify-/Preflight-Flow
  operationalisieren (inkl. abgeschlossenem Capability-Contract-Block aus `BL-0012` und optionalem Benchmark-Harness aus `BL-0013`).
- S12C4/4: done - Sprint-12-Finalisierung mit Doku-Sync, Wiki-Linkhaertung und Abschluss-Verifikation.

### Fortschritt (2026-03-15)

- `TSK-0005` (BL-012) abgeschlossen: Wiki-v1-Quellseiten unter `docs/wiki/`
  angelegt und Link-Governance via `make wiki-link-check` verankert.
- 1.0.0-Readiness-Preflight operationalisiert:
  `scripts/release_preflight_1_0_0.sh`, `make release-preflight-1-0-0`,
  `docs/RELEASE_1_0_0_PREFLIGHT.md`.
- Public-Readiness-Gate (S14) fachlich abgeschlossen:
  `BL-012` ist auf `done`, Source-of-Truth-Links sind auf stabile Repo-URLs
  gehaertet und interne Wiki-Navigation rendert Seitenpfade ohne `.md`.
- Branch-Protection fuer `main` ist aktiv:
  PR-only-Flow mit Required-Check `verify`, strict up-to-date, Conversation-
  Resolution, Admin-Enforcement und Review-Block im Solo-Modus
  (`required_approving_review_count=0`).

### Abschluss-Tag

- Sprint-Abschluss: S12C4/4 (done)
- Abschluss-Tag: `sprint-12-done` (pending, wird erst nach expliziter
  Freigabe gesetzt und gepusht)

## Sprint 13 - Contract Hardening for 1.0.0

- Status: done
- Ziel: Gate 2 (Contract + Modulfaehigkeiten) operativ abschliessen und die
  1.0.0-Contract-Haertung sichtbar in Verify-/Doku-Flow verankern.

### Geplante Bloecke

- S13C1/4: done - Restscope Gate 2 konkretisiert
  (Contract-Haertungs-Checklist aus `POL-002` fuer JSON/CSV/CLI ableiten und
  gegen bestehende Contracts mappen).
- S13C2/4: done - Fehlende Contract-Checks als Regressionen ergaenzen
  (fokussiert auf klare Deprecation-/Breaking-Sichtbarkeit statt stiller
  Semantikwechsel).
- S13C3/4: done - Doku-Sync fuer Contract-Evolution und Integrationsnutzung
  finalisieren (`EXPORT_CONTRACT`, Module-/Entry-Doku, Status-Roadmap-Sync).
- S13C4/4: done - Gate-2-Abschlusslauf dokumentieren
  (`make verify` + Abschlussnarrativ + Sprint-/Changelog-Referenzen).

### Fortschritt (2026-03-15)

- Sprint 13 wurde nach Abschluss von Sprint 12 initialisiert; Arbeitsfokus ist
  jetzt der verbleibende Gate-2-Restscope.
- `S13C1/4` abgeschlossen: Policy-abgeleitete Contract-Hardening-Checklist
  erstellt (`docs/CONTRACT_HARDENING_1_0_0.md`) und gegen aktuelle JSON/CSV/CLI-
  Nachweise gemappt; verbleibender Restscope fuer `S13C2/4` ist konkretisiert.
- `S13C2/4` abgeschlossen: zentraler CSV-Contract-Regression-Runner eingefuehrt
  (`tests/regression/run_export_contract_csv_check.sh`) und in lokale/CI-Gates
  verdrahtet (`Makefile`, `.github/workflows/ci.yml`); Testdoku sowie
  Gate-2-Fortschritt in Contract-/Roadmap-/Status-Doku synchronisiert.
- `S13C3/4` abgeschlossen: Contract-Evolution-/Deprecation-Sichtbarkeit gemaess
  `POL-002` in der Contract-Doku finalisiert (`docs/EXPORT_CONTRACT.md`:
  Abschnitt "Deprecation Status"), Modul-/Entry-Doku darauf ausgerichtet
  (`docs/MODULES_ARCHITECTURE.md`, `docs/README.md`, `docs/README_EN.md`) und
  Gate-2-Restscope in Hardening-/Roadmap-/Status-Doku auf den Abschlusslauf
  (`S13C4/4`) reduziert.
- `S13C4/4` abgeschlossen: Gate-2-Abschlusslauf ausgefuehrt und dokumentiert
  (`make verify` gruen, keine offenen Gate-2-Blocker), Gate-2-Status auf
  `abgeschlossen` synchronisiert (`docs/CONTRACT_HARDENING_1_0_0.md`,
  `docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`).
- S13C1/4 Traceability:
  - Git-Commit: `cf802fb`
  - Artefakte: `.artifacts/sprint_13_commit_1_von_4.md`,
    `.artifacts/sprint_13_commit_1_von_4.diff`
- S13C2/4 Traceability:
  - Git-Commit: `1608656`
  - Artefakte: `.artifacts/sprint_13_commit_2_von_4.md`,
    `.artifacts/sprint_13_commit_2_von_4.diff`
- S13C3/4 Traceability:
  - Git-Commit: `2f48bf6`
  - Artefakte: `.artifacts/sprint_13_commit_3_von_4.md`,
    `.artifacts/sprint_13_commit_3_von_4.diff`
- S13C4/4 Traceability:
  - Git-Commit: `43d5e32`
  - Artefakte: `.artifacts/sprint_13_commit_4_von_4.md`,
    `.artifacts/sprint_13_commit_4_von_4.diff`

### Abschluss-Tag

- Sprint-Abschluss: S13C4/4 (done)
- Abschluss-Tag: `sprint-13-done` (pending, wird erst nach expliziter
  Freigabe gesetzt und gepusht)

## Sprint 15 - Release Candidate Hardening for 1.0.0

- Status: done
- Ziel: Gate 4 (RC-Haertung) operativ abschliessen und den 1.0.0-Releasepfad mit klaren Preflight-Guardrails absichern.

### Geplante Bloecke

- S15C1/4: done - 1.0.0-Preflight um Gate-Status-/Doku-Guardrails erweitern.
- S15C2/4: done - RC-Checkliste/Scope-Freeze auf aktuellen Gate-Stand nachziehen.
- S15C3/4: done - RC-Abschlusslauf (lokal + CI-Referenz) dokumentieren.
- S15C4/4: done - Gate-4-Abschlussnarrativ und Release-Vorbereitung finalisieren.

### Fortschritt (2026-03-16)

- `S15C1/4` abgeschlossen: `scripts/release_preflight_1_0_0.sh` prueft jetzt
  zusaetzlich den dokumentierten Gate-Status (`CONTRACT_HARDENING=done`, Gate 2
  in `ROADMAP_1_0_0.md` und `STATUS.md` als abgeschlossen). Doku-Sync in
  `docs/RELEASE_1_0_0_PREFLIGHT.md`, `docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`,
  `docs/README.md`.
- `S15C2/4` abgeschlossen: RC-Checkliste/Scope-Freeze auf den aktuellen
  Gate-Stand synchronisiert (Gate 1/2/3 abgeschlossen, Gate 4 aktiv) und
  Governance-Text auf den laufenden Solo-Maintainer-Modus ohne verpflichtende
  Approvals nachgezogen (`docs/RELEASE_1_0_0_PREFLIGHT.md`,
  `docs/ROADMAP_1_0_0.md`, `docs/STATUS.md`, `docs/README.md`).
- `S15C3/4` abgeschlossen: RC-Abschlusslauf mit lokalem Voll-Preflight und
  CI-Referenz auf `main` dokumentiert. Lokaler Nachweis erfolgte ueber
  `make release-preflight-1-0-0` (inkl. `make verify`, Doku-Gates und Dry-Runs);
  referenzierter CI-Run: `https://github.com/SirKenvelo/Betankungen/actions/runs/23153384396`
  (`CI`, `success`, Commit `a59cb6e`).
- `S15C4/4` abgeschlossen: Gate-4-Abschlussnarrativ finalisiert und Handover
  auf Gate 5 dokumentiert. Gate 4 ist damit als abgeschlossen markiert;
  verbleibend ist nur der finale Release-Block (`APP_VERSION -> 1.0.0`,
  finaler Doku-Sync, `kpr.sh`/`backup_snapshot.sh` nach Freigabe).
- S15C1/4 Traceability:
  - Git-Commit: `d8b618e`
  - Artefakte: `.artifacts/sprint_15_commit_1_von_4.md`,
    `.artifacts/sprint_15_commit_1_von_4.diff`
- S15C2/4 Traceability:
  - Git-Commit: `e52ba86`
  - Artefakte: `.artifacts/sprint_15_commit_2_von_4.md`,
    `.artifacts/sprint_15_commit_2_von_4.diff`
- S15C3/4 Traceability:
  - Git-Commit: `8c993b5`
  - Artefakte: `.artifacts/sprint_15_commit_3_von_4.md`,
    `.artifacts/sprint_15_commit_3_von_4.diff`
- S15C4/4 Traceability:
  - Git-Commit: `52b5823`
  - Artefakte: `.artifacts/sprint_15_commit_4_von_4.md`,
    `.artifacts/sprint_15_commit_4_von_4.diff`

### Abschluss-Tag

- Sprint-Abschluss: S15C4/4 (done)
- Abschluss-Tag: `sprint-15-done` (pending, wird erst nach expliziter
  Freigabe gesetzt und gepusht)

## Gate 5 - Finalisierung 1.0.0

- Status: done
- Ziel: finalen Release-Schritt fuer `1.0.0` ausfuehren und den Abschluss
  nachvollziehbar dokumentieren.

### Abschluss (2026-03-16)

- Finaler Release-Umschalt-Commit ausgefuehrt (`APP_VERSION=1.0.0`).
- Finaler Doku-Sync fuer Gate 5 abgeschlossen (`ROADMAP_1_0_0`, `STATUS`,
  `README`, `RELEASE_1_0_0_PREFLIGHT`, `CHANGELOG`).
- Release-Artefakt ausgefuehrt: `./kpr.sh --note "Release 1.0.0 final"`.
- Release-Artefakt: `.releases/Betankungen_1_0_0.tar`
  (SHA-256: `9ebde5b6ffec7197688dd5ae71f035b66f8f874fe18b38d01aff4939f295f5c1`).
- Direktes Backup nach Release ausgefuehrt:
  `scripts/backup_snapshot.sh --note "Backup after release 1.0.0"`.
- Backup-Snapshot: `.backup/2026-03-16_1736`.

### Abschluss-Tag

- Kein zusaetzlicher Sprint-Tag (Gate-basierter Release-Block ausserhalb der
  Sprint-Nummerierung).

## Sprint 16 - Road to 1.1.0 Kickoff

- Status: done
- Ziel: den 1.1.0-Zyklus mit verbindlichem Gate-Plan und klarer Scope-Freeze-Vorbereitung starten.

### Geplante Bloecke

- S16C1/4: done - 1.1.0-Fahrplan initialisieren (`docs/ROADMAP_1_1_0.md`) und Entry-Doku (`README`/`STATUS`/`SPRINTS`) auf den aktiven Zyklus synchronisieren.
- S16C2/4: done - Scope-Freeze fuer Gate 2 im Tracker festziehen (priorisierter Feature-Block + Hardening-Block + explizites Out-of-Scope).
- S16C3/4: done - Verify-/Contract-DoD fuer den gewaehlten 1.1.0-Scope konkretisieren.
- S16C4/4: done - Gate-3-Kickoff-Handover dokumentieren und Sprint-16-Abschluss auf den Umsetzungsblock uebergeben.

### Fortschritt (2026-03-17)

- Sprint 16 wurde initialisiert: verbindlichen 1.1.0-Gate-Plan als neues Arbeitsdokument angelegt (`docs/ROADMAP_1_1_0.md`) und den aktiven Zyklus in Entry-Doku/Status verankert (`docs/README.md`, `docs/STATUS.md`, `docs/CHANGELOG.md`).
- `S16C2/4` abgeschlossen: Gate-2-Scope-Freeze im Tracker festgezogen. `BL-0014` wurde auf `approved` angehoben und mit `TSK-0006` konkretisiert; zusaetzlich wurde der dedizierte Hardening-Block `BL-0015` mit `TSK-0007` angelegt. Roadmap-/Status-/Entry-Doku wurden auf den Gate-2-Abschluss synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/BACKLOG.md`).
- `S16C3/4` abgeschlossen: Verify-/Contract-DoD fuer Gate 3 konkretisiert. Neue Arbeitsdokumente `docs/CONTRACT_HARDENING_1_1_0.md` und `docs/RELEASE_1_1_0_PREFLIGHT.md` eingefuehrt und Roadmap-/Status-/Entry-Doku auf den DoD-Stand synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/CHANGELOG.md`).
- `S16C4/4` abgeschlossen: Sprint-16-Kickoff als Gate-3-Handover finalisiert. Gate-Status in Roadmap-/Status-/Entry-Doku auf den aktiven Umsetzungsblock synchronisiert und ein expliziter non-blocking Follow-up fuer Public-Readiness als `BL-0016` im kanonischen Tracker aufgenommen (`docs/backlog/BL-0016-community-standards-baseline/item.md`, `docs/BACKLOG.md`, `docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/CHANGELOG.md`).
- S16C1/4 Traceability:
  - Git-Commit: `6256d87`
  - Artefakte: `.artifacts/sprint_16_commit_1_von_4.md`,
    `.artifacts/sprint_16_commit_1_von_4.diff`
- S16C2/4 Traceability:
  - Git-Commit: `feab063`
  - Artefakte: `.artifacts/sprint_16_commit_2_von_4.md`,
    `.artifacts/sprint_16_commit_2_von_4.diff`
- S16C3/4 Traceability:
  - Git-Commit: `f796179`
  - Artefakte: `.artifacts/sprint_16_commit_3_von_4.md`,
    `.artifacts/sprint_16_commit_3_von_4.diff`
- S16C4/4 Traceability:
  - Git-Commit: `f3aa61b`
  - Artefakte: `.artifacts/sprint_16_commit_4_von_4.md`,
    `.artifacts/sprint_16_commit_4_von_4.diff`

## Sprint 17 - Gate 3 Umsetzung (Manifest v1)

- Status: done
- Ziel: Gate 3 der 1.1.0-Linie inkl. Closeout-Nachweisen abschliessen und den Uebergang auf Gate 4 vorbereiten.

### Geplante Bloecke

- S17C1/4: done - Manifest-v1-Contract, Dry-Run-Fixtures und optionalen lokalen Runner fuer Paketvalidierung liefern (`TSK-0006`).
- S17C2/4: done - 1.1.0-Preflight-Skriptbasis aus dem Blueprint operationalisieren (`TSK-0007`).
- S17C3/4: done - Gate-3-Closeout-Nachweise und RC-Handover auf Gate 4 verdichten.
- S17C4/4: done - finalen Gate-3-Abschlusslauf (Verify + Matrix-Sync + Gate-Status-Flip) abschliessen.

### Fortschritt (2026-03-17)

- `S17C1/4` abgeschlossen: Manifest-v1-Contract als neues Arbeitsdokument eingefuehrt (`docs/EXPORT_PACKAGE_CONTRACT.md`), reproduzierbare valid/invalid-Fixtures angelegt (`tests/regression/fixtures/package_manifest_v1/`) und optionalen lokalen Fixture-Runner umgesetzt (`tests/regression/run_package_manifest_fixture_check.sh`, `make package-manifest-check`). Tracker-/Gate-Sync auf done/in-progress aktualisiert (`docs/backlog/BL-0014-import-export-package-format/item.md`, `docs/backlog/BL-0014-import-export-package-format/tasks/TSK-0006-define-package-manifest-v1-and-dry-run-fixtures.md`, `docs/CONTRACT_HARDENING_1_1_0.md`, `docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/CHANGELOG.md`).
- `S17C2/4` abgeschlossen: operatives 1.1.0-Preflight-Skript eingefuehrt (`scripts/release_preflight_1_1_0.sh`) und ueber `make release-preflight-1-1-0` verdrahtet. Doku-Gates fuer Scope-/Tracker-/Contract-Konsistenz sind im Skript explizit abgebildet; `TSK-0007` und `BL-0015` wurden auf `done` synchronisiert (`docs/backlog/BL-0015-release-verify-hardening-1-1-0/item.md`, `docs/backlog/BL-0015-release-verify-hardening-1-1-0/tasks/TSK-0007-define-1-1-0-preflight-blueprint-and-doc-gates.md`, `docs/RELEASE_1_1_0_PREFLIGHT.md`, `docs/CONTRACT_HARDENING_1_1_0.md`, `docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/CHANGELOG.md`).
- `S17C3/4` abgeschlossen: Gate-3-Closeout auf Nachweisebene verdichtet. `docs/CONTRACT_HARDENING_1_1_0.md` fuehrt `Policy-Fit` jetzt auf `done`; `docs/RELEASE_1_1_0_PREFLIGHT.md` enthaelt Gate-3-Snapshot und RC-Handover-Nachweise (lokaler Lauf `make release-preflight-1-1-0`, CI-Referenz `23207955306` auf `main`). Roadmap-/Status-/Entry-Doku auf den neuen Fokus `S17C4/4` synchronisiert (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/CHANGELOG.md`).
- `S17C4/4` abgeschlossen: finaler Gate-3-Abschlusslauf ausgefuehrt (`make release-preflight-1-1-0` inkl. Vollsuite) und Gate-Status formal geflippt (Gate 3 `abgeschlossen`, Gate 4 `aktiv`). Matrix-/Roadmap-/Status-/Entry-/Preflight-Doku auf den Abschlussstand synchronisiert (`docs/CONTRACT_HARDENING_1_1_0.md`, `docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`, `docs/RELEASE_1_1_0_PREFLIGHT.md`, `docs/CHANGELOG.md`).
- S17C1/4 Traceability:
  - Git-Commit: `2d3ba79`
  - Artefakte: `.artifacts/sprint_17_commit_1_von_4.md`,
    `.artifacts/sprint_17_commit_1_von_4.diff`
- S17C2/4 Traceability:
  - Git-Commit: `fb7b351`
  - Artefakte: `.artifacts/sprint_17_commit_2_von_4.md`,
    `.artifacts/sprint_17_commit_2_von_4.diff`
- S17C3/4 Traceability:
  - Git-Commit: `5425ccf`
  - Artefakte: `.artifacts/sprint_17_commit_3_von_4.md`,
    `.artifacts/sprint_17_commit_3_von_4.diff`
- S17C4/4 Traceability:
  - Git-Commit: `980fc41`
  - Artefakte: `.artifacts/sprint_17_commit_4_von_4.md`,
    `.artifacts/sprint_17_commit_4_von_4.diff`

### Abschluss-Tag

- Sprint-Abschluss: S17C4/4 (done)
- Abschluss-Tag: `sprint-17-done` (pending, wird erst nach expliziter
  Freigabe gesetzt und gepusht)

## Sprint 18 - Gate 4 RC Hardening (1.1.0)

- Status: done
- Ziel: Gate 4 fuer die 1.1.0-Linie operativ absichern und den Handover auf
  Gate 5 vorbereiten.

### Geplante Bloecke

- S18C1/4: done - Gate-4-Kickoff dokumentieren und nicht-blockierenden
  Follow-up `BL-0021` erfassen.
- S18C2/4: done - RC-Checkliste/Feature-Freeze-Snapshot auf aktuellen
  Gate-Stand synchronisieren.
- S18C3/4: done - RC-Abschlusslauf (lokal + CI-Referenz) dokumentieren.
- S18C4/4: done - Gate-4-Abschlussnarrativ und Handover auf Gate 5
  finalisieren.

### Fortschritt (2026-03-18)

- `S18C1/4` abgeschlossen: Gate-4-Kickoff auf Doku-Ebene verankert
  (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`,
  `docs/RELEASE_1_1_0_PREFLIGHT.md`) und den neuen nicht-blockierenden
  Backlog-Vorschlag fuer externe Belegfoto-Links als `BL-0021` im kanonischen
  Tracker aufgenommen (`docs/backlog/BL-0021-receipt-photo-link-references/item.md`,
  `docs/BACKLOG.md`, `docs/CHANGELOG.md`).
- `S18C2/4` abgeschlossen: RC-Checkliste und Feature-Freeze-Snapshot auf den
  aktuellen Gate-4-Stand synchronisiert. `docs/RELEASE_1_1_0_PREFLIGHT.md`
  fuehrt jetzt einen expliziten RC-/Freeze-Snapshot (in-scope vs.
  non-blocking/out-of-scope), waehrend Roadmap-/Status-/Entry-Doku den Fokus
  auf den RC-Abschlusslauf `S18C3/4` umstellen
  (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`,
  `docs/CHANGELOG.md`).
- `S18C3/4` abgeschlossen: RC-Abschlusslauf fuer Gate 4 dokumentiert.
  Lokaler Voll-Preflight lief gruen (`make release-preflight-1-1-0`) und die
  CI-Referenz auf `main` wurde auf den aktuellen Stand aktualisiert
  (Run `23241536267`, Commit `6b1a0c1`).
  Preflight-/Roadmap-/Status-/Entry-Doku auf den verbleibenden Gate-4-Closeout
  (`S18C4/4`) synchronisiert (`docs/RELEASE_1_1_0_PREFLIGHT.md`,
  `docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`,
  `docs/CHANGELOG.md`).
- `S18C4/4` abgeschlossen: Gate 4 formal auf `abgeschlossen` gesetzt und der
  Handover auf Gate 5 finalisiert (`docs/ROADMAP_1_1_0.md`,
  `docs/STATUS.md`, `docs/RELEASE_1_1_0_PREFLIGHT.md`, `docs/README.md`,
  `docs/CHANGELOG.md`).
- S18C1/4 Traceability:
  - Git-Commit: `2d202a4`
  - Artefakte: `.artifacts/sprint_18_commit_1_von_4.md`,
    `.artifacts/sprint_18_commit_1_von_4.diff`
- S18C2/4 Traceability:
  - Git-Commit: `ff9dcf6`
  - Artefakte: `.artifacts/sprint_18_commit_2_von_4.md`,
    `.artifacts/sprint_18_commit_2_von_4.diff`
- S18C3/4 Traceability:
  - Git-Commit: `e14ee87`
  - Artefakte: `.artifacts/sprint_18_commit_3_von_4.md`,
    `.artifacts/sprint_18_commit_3_von_4.diff`
- S18C4/4 Traceability:
  - Git-Commit: `6d08aa3`
  - Artefakte: `.artifacts/sprint_18_commit_4_von_4.md`,
    `.artifacts/sprint_18_commit_4_von_4.diff`

### Abschluss-Tag

- Sprint-Abschluss: S18C4/4 (done)
- Abschluss-Tag: `sprint-18-done` (pending, wird erst nach expliziter
  Freigabe gesetzt und gepusht)

## Sprint 19 - Gate 5 Finalisierung (1.1.0)

- Status: abgeschlossen
- Ziel: Finale 1.1.0-Freigabe vorbereiten und dabei Priorisierung im Backlog
  klar trennen (release-blocking vs. planned vs. exploratory).

### Geplante Bloecke

- S19C1/4: done - Gate-5-Kickoff dokumentieren und BL-Triage-Lanes im
  kanonischen Tracker verankern.
- S19C2/4: done - finalen Release-Checklisten-/Scope-Snapshot fuer Gate 5
  synchronisieren.
- S19C3/4: done - finalen Release-Umschalt-Commit (`APP_VERSION=1.1.0`) +
  Doku-Finalsync nach Freigabe vorbereiten.
- S19C4/4: done - finalen Release-Umschalt-Commit ausfuehren, Release-/Backup
  final laufen lassen und Gate-5-Closeout dokumentieren.

### Fortschritt (2026-03-18)

- `S19C1/4` abgeschlossen: Gate-5-Kickoff dokumentiert und die empfohlene
  BL-Lane-Sortierung (`release-blocking`/`planned`/`exploratory`) in Policy,
  Backlog-Index und den offenen BL-Items verankert
  (`docs/policies/POL-001-tracker-standard.md`, `docs/backlog/README.md`,
  `docs/BACKLOG.md`, `BL-0016`, `BL-0017`, `BL-0018`, `BL-0019`, `BL-0020`,
  `BL-0021`).
- `S19C2/4` abgeschlossen: Gate-5-Checklisten-/Scope-Snapshot auf den
  aktuellen Stand synchronisiert. `docs/RELEASE_1_1_0_PREFLIGHT.md` fuehrt
  jetzt einen expliziten Snapshot fuer Gate 5 (Gate-Konsistenz,
  Versionierungs-Guardrail, release-blockierender Scope, Lane-Stand) inkl.
  aktueller CI-Referenz auf `main` (Run `23243226276`, Commit `6088568`).
  Roadmap-/Status-/Entry-/Changelog-Doku auf den naechsten Fokus `S19C3/4`
  nachgezogen (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`,
  `docs/CHANGELOG.md`).
- `S19C3/4` abgeschlossen: Release-Umschaltpaket fuer Gate 5 ist dokumentiert,
  ohne vorgezogenen Versionswechsel. `docs/RELEASE_1_1_0_PREFLIGHT.md` fuehrt
  jetzt die finalen Umschaltdateien und den operativen Ablauf nach Freigabe.
  Roadmap-/Status-/Entry-/Changelog-Doku auf den Abschlussblock `S19C4/4`
  ausgerichtet (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`,
  `docs/CHANGELOG.md`).
- `S19C4/4` abgeschlossen: finaler 1.1.0-Release ausgefuehrt
  (`APP_VERSION=1.1.0`), Gate 5 in Roadmap-/Status-/Entry-Doku auf
  abgeschlossen gesetzt und finale Release-/Backup-Ausfuehrung dokumentiert
  (`./kpr.sh --note "Release 1.1.0 final"`,
  `scripts/backup_snapshot.sh --note "Backup after release 1.1.0"`).
  Ergebnis: Artefakt `.releases/Betankungen_1_1_0.tar`
  (SHA-256 `f3c1f5ef4a8daa3a5a1cf9d4cb74c871c2799c1338e1eafe2422a6bfbeb026f3`)
  und Snapshot `.backup/2026-03-18_1331`.
- S19C1/4 Traceability:
  - Git-Commit: `12d1cd7`
  - Artefakte: `.artifacts/sprint_19_commit_1_von_4.md`,
    `.artifacts/sprint_19_commit_1_von_4.diff`
- S19C2/4 Traceability:
  - Git-Commit: `87b18fb`
  - Artefakte: `.artifacts/sprint_19_commit_2_von_4.md`,
    `.artifacts/sprint_19_commit_2_von_4.diff`
- S19C3/4 Traceability:
  - Git-Commit: `99fc714`
  - Artefakte: `.artifacts/sprint_19_commit_3_von_4.md`,
    `.artifacts/sprint_19_commit_3_von_4.diff`
- S19C4/4 Traceability:
  - Git-Commit: `cf74b1c`
  - Artefakte: `.artifacts/sprint_19_commit_4_von_4.md`,
    `.artifacts/sprint_19_commit_4_von_4.diff`

## Sprint 20 - Road to 1.2.0 Kickoff

- Status: done
- Ziel: Scope-Freeze fuer die 1.2.0-Linie operativ verankern und die
  release-blocking Arbeitsbloecke fuer Umsetzung/Haertung vorbereiten.

### Geplante Bloecke

- S20C1/4: done - 1.2.0-Fahrplan aufsetzen (`docs/ROADMAP_1_2_0.md`),
  Entwicklungsbasis auf `1.2.0-dev` anheben und Entry-/Status-Doku
  synchronisieren.
- S20C2/4: done - Scope-Freeze fuer `BL-0020` und `BL-0021` im Tracker
  festziehen (Status `approved`, Lane `release-blocking`, Tasks `TSK-0008`
  bis `TSK-0011`).
- S20C3/4: done - Verify-/Contract-DoD fuer Gate 3 der 1.2.0-Linie
  konkretisieren.
- S20C4/4: done - Gate-3-Umsetzungsblock starten und den ersten
  regressionssicheren Lieferstand dokumentieren.

### Fortschritt (2026-03-18)

- `S20C1/4` abgeschlossen: neue 1.2.0-Roadmap angelegt und als aktiver
  Fahrplan verankert (`docs/ROADMAP_1_2_0.md`), Versionierungsbasis auf
  `APP_VERSION=1.2.0-dev` gesetzt (`src/Betankungen.lpr`) und Entry-/Status-
  Doku synchronisiert (`docs/README.md`, `docs/STATUS.md`, `docs/CHANGELOG.md`).
- `S20C2/4` abgeschlossen: release-blocking Scope im kanonischen Tracker
  festgezogen. `BL-0020` und `BL-0021` stehen auf `approved` mit Lane
  `release-blocking`; Downstream-Tasks `TSK-0008` bis `TSK-0011` sind angelegt
  (`docs/backlog/BL-0020-multi-database-backup-operations/`,
  `docs/backlog/BL-0021-receipt-photo-link-references/`, `docs/BACKLOG.md`).
- `S20C3/4` abgeschlossen: Verify-/Contract-DoD fuer Gate 3 konkretisiert.
  Neue Leitdokumente `docs/CONTRACT_HARDENING_1_2_0.md` (Hardening-Matrix) und
  `docs/RELEASE_1_2_0_PREFLIGHT.md` (Preflight-Blueprint + Doku-Gates)
  eingefuehrt; Roadmap-/Status-/Entry-/Changelog-Doku auf den Gate-3-DoD-Stand
  synchronisiert (`docs/ROADMAP_1_2_0.md`, `docs/STATUS.md`, `docs/README.md`,
  `docs/CHANGELOG.md`).
- `S20C4/4` abgeschlossen: erster regressionssicherer Gate-3-Lieferstand fuer
  den 1.2.0-Release-Kern umgesetzt. `BL-0020` ist auf `done` gesetzt
  (Runner `scripts/db_backup_ops.sh`, Regression
  `tests/regression/run_db_backup_ops_check.sh`, Verify-Verdrahtung via
  `make db-backup-ops-check` + `make verify`); Tracker-/Roadmap-/Status-/Entry-
  Doku synchronisiert.

## Sprint 21 - Receipt-Link Delivery (1.2.0)

- Status: done
- Ziel: `BL-0021` als zweiten release-blocking Gate-3-Lieferstand umsetzen
  (Contract + Write-Path + Guardrails + Nachweise).

### Geplante Bloecke

- S21C1/1: done - Receipt-Link-Contract und optionalen Write-Path fuer Fuelups
  liefern, inklusive Output-/JSON-Sichtbarkeit und Verify-Verdrahtung.

### Fortschritt (2026-03-18)

- `S21C1/1` abgeschlossen:
  - CLI/Policy: neues Flag `--receipt-link` eingefuehrt (nur mit
    `--add fuelups`, Guardrails fuer leer/Steuerzeichen/Laenge).
  - DB/Write-Path: neues additives Feld `fuelups.receipt_link` in Core- und
    Seed-Schema inkl. idempotenter Migration.
  - Output/Contract: Detailausgabe zeigt gesetzte Receipt-Links; Fuelups-JSON
    fuehrt `receipt_links_set` und `receipt_links_missing` fuer full/monthly/
    yearly.
  - Regression/Verify: neuer Check
    `tests/regression/run_receipt_link_contract_check.sh`, verdrahtet via
    `make receipt-link-check` und `make verify`.

## Sprint 22 - Gate 4 RC Hardening (1.2.0)

- Status: done
- Ziel: Gate 3 fuer die 1.2.0-Linie formal schliessen und Gate 4
  (RC-Haertung) mit konsistentem Doku-/Preflight-Stand aktiv fuehren.

### Geplante Bloecke

- S22C1/3: done - Gate-3-Closeout und Gate-4-Kickoff in Roadmap-/Status-/
  Entry-/Hardening-/Preflight-Doku synchronisiert.
- S22C2/3: done - RC-Checklisten-/Feature-Freeze-Snapshot fuer Gate 4 auf
  den laufenden Stand gehaertet.
- S22C3/3: done - RC-Abschlusslauf und Gate-4-Exit-Nachweis dokumentieren.

### Sprint-Notiz zu S22C1/3 (Uebergang)

- Der originale Sprint-Auftakt von Sprint 22 ist Commit `e08b716`
  (`[General] docs: close 1.2.0 gate-3 and activate gate-4`) auf Branch
  `chore/1-2-0-gate3-closeout-gate4-kickoff`.
- Dieser Commit entspricht fachlich `S22C1/3`.
- Die explizite C1/C2/C3-Kennzeichnung war im laufenden Uebergang zur
  kanonischen Sprint-Governance noch nicht vollstaendig im Branch-/PR-Flow
  umgesetzt.
- Traceability:
  - `S22C1/3` = `e08b716`
  - `S22C2/3` = `74c2b63`
  - `S22C3/3` = aktueller Sprint-Abschlussschritt

### Fortschritt (2026-03-19)

- `S22C2/3` abgeschlossen:
  - `docs/RELEASE_1_2_0_PREFLIGHT.md` um einen expliziten
    RC-Checklisten-Snapshot erweitert (Scope-Freeze intakt, Doku-Gates
    konsistent, offene RC-Exit-Schritte transparent).
  - Roadmap-/Status-/Entry-/Changelog-Doku auf den Gate-4-Fortschritt
    synchronisiert (`docs/ROADMAP_1_2_0.md`, `docs/STATUS.md`,
    `docs/README.md`, `docs/CHANGELOG.md`).
- `S22C3/3` abgeschlossen:
  - lokaler Vollnachweis `make verify` ist gruen.
  - CI-Referenz auf `main` aktualisiert (`CI` Run `23307738745`,
    Commit `3e9be17`, `success`).
  - Gate-4-Exit dokumentiert und Handover auf Gate 5 in Roadmap-/Status-/
    Entry-/Preflight-/Changelog-Doku synchronisiert.

## General-Stream nach Sprint 22 (Gate 5, non-blocking)

- Status: abgeschlossen
- Ziel: Gate-5-Finalisierung der 1.2.0-Linie begleiten, ohne den
  release-blocking Scope zu aendern; gezielte QA-/User-Flow-/Doku-
  Nachschaerfungen aus `BL-0022`/`BL-0023` auf `main` integrieren und den
  finalen 1.2.0-Release-Closeout durchfuehren.

### Bisheriger Fortschritt (2026-03-20 bis 2026-03-24)

- `189e159`: Teststrategie und Nutzerfund-Tracker als kanonischer Rahmen
  eingefuehrt (`docs/TEST_MATRIX.md`, `BL-0022`, `ISS-0002..ISS-0006`).
- `7d43034`: Repo-Hygiene fuer lokale Codex-Konfigurationen nachgezogen
  (`.codex/` in `.gitignore`).
- `eebac9a`: EOF-sicheren Fuelup-Dialog und Seed-/Demo-Smoke-Hardening
  umgesetzt.
- `10d6361`: Cross-Field-Guardrail `P-033` fuer Fuelups geliefert.
- `26e1499`: Stations-Masterdata-Plausibilitaet (`P-080..P-084`) gehaertet.
- `50b7600`: Resolver-Matrix-Smoke fuer den zusaetzlichen `P-050`-Prompt
  stabilisiert.
- `f590bcb`: First-Run- und Multi-Car-Guidance in CLI/Help sichtbar
  geschaerft (`TSK-0015`).
- Gate-5-Closeout 1.2.0 finalisiert:
  - `APP_VERSION=1.2.0` gesetzt.
  - finaler Doku-Sync fuer Roadmap/Status/Entry/Preflight/Changelog
    abgeschlossen.
  - lokaler Vollnachweis `make verify` ist gruen.
  - finale Release-/Backup-Ausfuehrung dokumentiert
    (`.releases/Betankungen_1_2_0.tar`, Snapshot `.backup/2026-03-24_1809`).

## General-Stream nach 1.2.0 - Kickoff 1.3.0

- Status: done
- Ziel: die neue Entwicklungsbasis `1.3.0-dev` technisch und dokumentarisch
  sauber verankern, basierend auf der verbindlichen Reihenfolge aus dem
  Entscheidungsentwurf vom 2026-03-18.

### Fortschritt (2026-03-26)

- `APP_VERSION=1.3.0-dev` gesetzt und damit die neue Entwicklungsbasis aktiv
  gemacht.
- Neue Roadmap `docs/ROADMAP_1_3_0.md` als aktiven Gate-Rahmen angelegt.
- Entry-/Status-Doku fuer den aktiven 1.3.0-Zyklus synchronisiert
  (`README.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`,
  `docs/CHANGELOG.md`).
- Verbindliche Reihenfolge fuer die naechsten Versionen explizit verankert:
  `1.3.0` = Option B (`BL-0017` + `BL-0018`), `1.4.0` = Option C
  (`BL-0016` + `BL-0011`).
- Triggerbasierte Audit-Leitplanke fuer die 1.3.0-Linie in der Roadmap
  verankert (kein pauschales Vollaudit; Release-Audit erst an Gate 4/5
  verbindlich entscheiden).
- Gate 2 fuer die 1.3.0-Linie als Scope-Freeze nachgezogen:
  `BL-0017`/`BL-0018` auf `approved` + `lane:release-blocking`,
  Downstream-Tasks `TSK-0018` bis `TSK-0021` angelegt.
- `BL-0017` fachlich abgeschlossen: Research-Ausarbeitung in die kanonische
  Repo-Doku `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md` ueberfuehrt,
  Primaerquelle `Tankerkoenig` festgelegt, Fallback `Benzinpreis-Aktuell.de`
  dokumentiert und Audit-/Betriebsgrenzen fuer `BL-0018` benannt.
- `TSK-0020` fuer `BL-0018` abgeschlossen: Kanon-Doku
  `docs/FUEL_PRICE_POLLING_HISTORY_CONTRACT_1_3_0.md` definiert jetzt
  Datenpfad-Trennung, Raw-Snapshot-Format, minimale Historienpersistenz und
  Integrationsgrenzen zur Core-Datenbank.
- `TSK-0021` fuer `BL-0018` abgeschlossen: neuer separater Runner
  `scripts/fuel_price_polling_run.sh` persistiert `tankerkoenig`-Snapshots in
  den getrennten Historienpfad (`raw/`, `db/`, `state/`); Runtime-Doku in
  `docs/FUEL_PRICE_POLLING_RUNTIME_1_3_0.md`, Regression in
  `tests/regression/run_fuel_price_history_check.sh`, Verify-Einbindung ueber
  `make fuel-price-history-check`.
- Gate 3 der 1.3.0-Linie ist damit formal abgeschlossen; lokaler
  Abschlusslauf `make verify` ist auf diesem Stand gruen, Gate 4 ist aktiv.
- Gate 4 fuer die 1.3.0-Linie ist operationalisiert: neuer Preflight-Blueprint
  `docs/RELEASE_1_3_0_PREFLIGHT.md` und operativer Entrypoint
  `scripts/release_preflight_1_3_0.sh` / `make release-preflight-1-3-0`
  verdichten RC-Haertung, Doku-Gates und Dry-Run-Nachweise.
- Der erste lokale Gate-4-Kickoff-Lauf ist gruen:
  `make release-preflight-1-3-0` lief erfolgreich inklusive `make verify`,
  `kpr.sh --dry-run` und `scripts/backup_snapshot.sh --dry-run`.
- Der RC-Checklisten-/Freeze-Snapshot fuer Gate 4 ist jetzt dokumentiert,
  inklusive aktueller CI-Referenz auf `main`
  (`CI` Run `23514165068`, Commit `ce5a574`).
- Der finale RC-Abschlusslauf fuer Gate 4 ist dokumentiert:
  `make release-preflight-1-3-0` lief gruen (inkl. `make verify`,
  Doku-Gates sowie Release-/Backup-Dry-Runs).
- Gate 4 der 1.3.0-Linie ist formal abgeschlossen; Gate 5 ist aktiv.
- Aktuelle CI-Referenz auf `main` fuer den Gate-4-Closeout ist dokumentiert
  (`CI` Run `23515516312`, Commit `027e963`, Status `success`).
- Gate-5-Kickoff-Snapshot ist dokumentiert (Scope/Version/Audit/Exit-Checks)
  in `docs/RELEASE_1_3_0_PREFLIGHT.md`.
- Finales Gate-5-Release-Umschaltpaket ist vorbereitet
  (Ziel-Dateien + Ausfuehrungsreihenfolge, ohne vorgezogenen
  `APP_VERSION`-Wechsel).
- Gate-5-Closeout fuer 1.3.0 ist abgeschlossen:
  - `APP_VERSION=1.3.0` gesetzt.
  - finaler Doku-Sync fuer Roadmap/Status/Entry/Preflight/Sprints/Changelog
    abgeschlossen.
  - lokaler Vollnachweis `make verify` ist gruen.
  - finale Release-/Backup-Ausfuehrung dokumentiert
    (`.releases/Betankungen_1_3_0.tar`, Snapshot `.backup/2026-03-26_1918`).

## General-Stream nach 1.3.0 - ADR/Backlog-Refinement

- Status: done
- Ziel: Entscheidungs- und Tracker-Basis fuer den naechsten Arbeitsabschnitt
  nach der abgeschlossenen `1.3.0`-Linie konsistent finalisieren.

### Fortschritt (2026-03-26)

- `ADR-0010` auf `accepted` finalisiert und den verbindlichen MVP-Rahmen fuer
  das repo-lokale Workflow-Wrapper-CLI `btkgit` festgezogen.
- `BL-0024` von `proposed` auf `approved` gehoben und von einem reinen
  Vorschlag auf einen umsetzbaren Arbeitsblock ausgebaut.
- Downstream-Tasks fuer `BL-0024` angelegt:
  - `TSK-0022` (Platzierung/Ton/Guardrails der Cookie-Wiki-Notiz)
  - `TSK-0023` (Veroeffentlichung, Navigation und Wiki-Link-Check)
- ADR-/Backlog-Index sowie Changelog auf den neuen Entscheidungs- und
  Tracker-Stand synchronisiert.

## General-Stream nach 1.3.0 - ADR-0010 + BL-0024 Umsetzung

- Status: done
- Ziel: den akzeptierten `ADR-0010` als operatives MVP liefern und den
  freigegebenen Backlog-Block `BL-0024` inklusive Wiki-Navigation und
  Tracker-Status vollstaendig abschliessen.

### Fortschritt (2026-03-27)

- `ADR-0010` ist jetzt technisch umgesetzt:
  - neues Wrapper-CLI `scripts/btkgit.sh` plus Root-Entrypoint `./btkgit`.
  - MVP-Kommandos aktiv: `sync`, `preflight <version>`, `ready`, `cleanup`.
  - bestehende Projektbefehle bleiben sichtbar und kanonisch (`git`, `make`,
    `scripts/release_preflight_*`).
- `BL-0024` ist umgesetzt und auf `done` gesetzt:
  - `TSK-0022` (Platzierung/Ton/Guardrails) auf `done`.
  - `TSK-0023` (Veroeffentlichung/Navigation/Link-Check) auf `done`.
  - finale Wiki-Seite `docs/wiki/Cookie-Note.md` angelegt und in
    `docs/wiki/Home.md` / `docs/wiki/README.md` verlinkt.
- Wiki-Guardrails fuer die neue Seite erweitert
  (`scripts/wiki_link_check.sh`) und per `make wiki-link-check` abgesichert.

## Sprint 23 - BL-0011 fachlich entflechten

- Status: done
- Ziel: den semantischen Kettenbruch zwischen Scaffolder-Backlog `BL-0011` und
  Odometer-Validierungsarbeit (`ISS-0001`/`TSK-0001`) sauber aufloesen.

### Geplante Bloecke

- S23C1/1: done - `BL-0011` auf reinen Scaffolder-Scope zurueckfuehren und
  die Odometer-Hardening-Kette in einen eigenen fachlichen Backlog-Block
  ueberfuehren.

### Fortschritt (2026-03-28)

- `S23C1/1` abgeschlossen:
  - neues Backlog `BL-0029` (`Odometer Validation Contract Hardening`) als
    fachlich passende Klammer fuer die Odometer-Validierungsarbeit angelegt
    (`docs/backlog/BL-0029-odometer-validation-contract-hardening/item.md`).
  - `TSK-0001` aus `BL-0011` herausgeloest, in den neuen BL-Pfad verschoben
    und auf `parent: BL-0029` umgestellt.
  - `ISS-0001` auf `BL-0029` referenziert; `BL-0011` wieder auf reinen
    Scaffolder-Zuschnitt ohne Odometer-Taskbezug gebracht.
  - Backlog-Index auf den neuen kanonischen Eintrag synchronisiert
    (`docs/BACKLOG.md`).
  - Git-Commit: `60e30f6`
  - Artefakte: `.artifacts/sprint_23_commit_1_von_1.md`,
    `.artifacts/sprint_23_commit_1_von_1.diff` (nach Push lokal erzeugen)

## Sprint 24 - 1.4.0 Scope formal festziehen

- Status: done
- Ziel: fuer die geplante `1.4.0`-Linie verbindlich klaeren, ob `BL-0011`
  zum Betankungen-Repo-Scope gehoert, und den Folge-Scope ohne vorgezogenen
  Dev-Start sauber dokumentieren.

### Geplante Bloecke

- S24C1/1: done - `BL-0011` als externes Thema fuer `Betankungen`
  festziehen und die direkt betroffenen `1.4.0`-Planungsquellen auf den
  bereinigten Repo-Scope synchronisieren.

### Fortschritt (2026-03-28)

- `S24C1/1` abgeschlossen:
  - `BL-0011` im kanonischen Tracker auf externalisierten
    Research-/Handover-Stand gesetzt (`blocked`, `research`,
    `lane:exploratory`).
  - neues Entscheidungsdokument
    `docs/BL-0011_SCOPE_DECISION_1_4_0.md` angelegt.
  - `docs/BACKLOG.md`, `docs/STATUS.md` und `docs/ROADMAP_1_3_0.md` auf den
    bereinigten `1.4.0`-Repo-Scope synchronisiert.
  - `BL-0016` bleibt der verbleibende In-Repo-Scope fuer die spaetere
    `1.4.0`-Linie; `APP_VERSION=1.3.0` bleibt unveraendert.
  - Git-Commit: `a8af75d`
  - Artefakte: `.artifacts/sprint_24_commit_1_von_1.md`,
    `.artifacts/sprint_24_commit_1_von_1.diff` (nach Push lokal erzeugen)

## General-Stream nach Sprint 24 - PR-Titel-Konvention

- Status: done
- Ziel: PR-Titel fuer Sprint-Arbeit explizit von Commit-Labels und generischen
  Platzhaltern abgrenzen, damit Sprint-Branches und PRs konsistent benannt
  bleiben.

### Fortschritt (2026-03-28)

- Kurzregel in `AGENTS.md` verankert: Sprint-PR-Titel folgen auf GitHub dem
  Format `[Sxx] type: short description`.
- Commit-Labels wie `[S24C1/1]` und generische Platzhalter wie `[Sprint 24]`
  sind fuer PR-Titel jetzt explizit ausgeschlossen.
- Detailregel in `docs/GIT_WORKFLOW.md` unter `Pull Requests` ergaenzt,
  inklusive fachlicher Scope-Anforderung und Englisch-Leitplanke fuer
  GitHub-PR-Titel.

## Sprint 25 - Tracker-Endzustand definieren

- Status: done
- Ziel: kanonische vs. Legacy-Pfade fuer neue Tracker-Arbeit eindeutig
  dokumentieren und die verbleibende Task-/ADR-Mehrdeutigkeit vor
  `1.4.0-dev` aufloesen.

### Geplante Bloecke

- S25C1/2: done - Policy, Backlog-Index, ADR-Index und Status auf einen
  verbindlichen Tracker-Endzustand bringen.
- S25C2/2: done - Task-Navigation fuer Legacy-Ausnahmefaelle explizit
  dokumentieren.

### Fortschritt (2026-03-29)

- `S25C1/2` abgeschlossen:
  - `POL-001` definiert den verbindlichen Arbeitszustand fuer neue
    Tracker-Arbeit.
  - `docs/BACKLOG.md` trennt kanonische `BL-xxxx` von Legacy `BL-0xx`
    inklusive der jeweiligen Statuswelt.
  - `docs/backlog/README.md`, `docs/ADR/README.md` und `docs/STATUS.md`
    fuehren den aktiven ADR-Pfad und die Legacy-Grenzen konsistent.
  - Git-Commit: `0968b70`
  - Artefakte: `.artifacts/sprint_25_commit_1_von_2.md`,
    `.artifacts/sprint_25_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S25C2/2` abgeschlossen:
  - `docs/issues/README.md` verweist neue Folge-Tasks verbindlich auf
    `docs/backlog/.../tasks/`.
  - Eine neue Legacy-Notiz im `docs/tasks/`-Ordner ordnet `docs/tasks/` als
    historischen Ausnahmeordner ein, ohne den Tracker-Linter auf eine
    zusaetzliche Markdown-Taskdatei zu lenken.
  - Git-Commit: `25df1d6`
  - Artefakte: `.artifacts/sprint_25_commit_2_von_2.md`,
    `.artifacts/sprint_25_commit_2_von_2.diff` (nach Push lokal erzeugen)
- Validierung:
  - `scripts/projtrack_lint.sh`
  - `make verify`

## Sprint 26 - Transition-Hold und Entry-Doku synchronisieren

- Status: done
- Ziel: alle zentralen Einstiegsdokumente auf denselben Zustand ziehen:
  `1.3.0` ist final, `APP_VERSION=1.3.0` bleibt unveraendert, `1.4.0-dev`
  ist bewusst noch nicht gestartet.

### Geplante Bloecke

- S26C1/2: done - Root-README, `CONTRIBUTING.md` und `docs/README_EN.md`
  auf den bewussten Hold nach `1.3.0` synchronisieren.
- S26C2/2: done - `docs/README.md` und `docs/STATUS.md` auf denselben
  Hold-Narrativ und den bereinigten `1.4.0`-Planungsstand ziehen.

### Fortschritt (2026-03-29)

- `S26C1/2` abgeschlossen:
  - `README.md`, `CONTRIBUTING.md` und `docs/README_EN.md` kommunizieren jetzt
    konsistent: `1.3.0` ist die letzte finale Linie, `APP_VERSION=1.3.0`
    bleibt stehen, `1.4.0-dev` ist noch nicht gestartet.
  - Der vorbereitete In-Repo-Folgescope wird als `BL-0016` benannt; `BL-0011`
    bleibt explizit ein externes Research-/Handover-Thema.
  - Git-Commit: `5e10687`
  - Artefakte: `.artifacts/sprint_26_commit_1_von_2.md`,
    `.artifacts/sprint_26_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S26C2/2` abgeschlossen:
  - `docs/README.md` fuehrt den aktuellen Kurzstand jetzt kompakt ueber
    Transition-Hold statt ueber eine implizit aktive `1.3.0`-Roadmap.
  - `docs/STATUS.md` markiert die 1.3.0-Linie explizit als abgeschlossen und
    den `post-1-3-0-transition` als bewusst aktiven Uebergangszustand.
  - Git-Commit: `bab3e9e`
  - Artefakte: `.artifacts/sprint_26_commit_2_von_2.md`,
    `.artifacts/sprint_26_commit_2_von_2.diff` (nach Push lokal erzeugen)
- Validierung:
  - `make verify`

## Sprint 27 - Wiki- und Public-Readiness-Layer nachschaerfen

- Status: done
- Ziel: die Wiki-Schicht als ruhigen oeffentlichen Einstieg schaerfen, ohne
  die Source-of-Truth-Rolle von `docs/` zu verwischen.

### Geplante Bloecke

- S27C1/2: done - Wiki-Home, Wiki-README und `Cookie-Note` so nachschaerfen,
  dass Kernnavigation, Source-of-Truth-Hinweise und persoenlicher Kontext
  bewusst getrennt sind.
- S27C2/2: done - Root-`README.md`, `CONTRIBUTING.md` und
  `docs/README_EN.md` auf publizierten Wiki-Einstieg plus versionierte
  Wiki-Quelle ausrichten.

### Fortschritt (2026-03-29)

- `S27C1/2` abgeschlossen:
  - `docs/wiki/Home.md` trennt jetzt Kernnavigation, Zusatzkontext,
    Repository-Source-of-Truth und redaktionelle Side Note.
  - `docs/wiki/README.md` dokumentiert die Wiki-Rolle explizit als ruhige
    Entry-Layer und ordnet `Cookie-Note.md` bewusst ausserhalb des
    technischen Startpfads ein.
  - `docs/wiki/Cookie-Note.md` benennt ihre redaktionelle Rolle jetzt offen
    als bewusst nachgeordneten Kontext.
  - Git-Commit: `fc283cc`
  - Artefakte: `.artifacts/sprint_27_commit_1_von_2.md`,
    `.artifacts/sprint_27_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S27C2/2` abgeschlossen:
  - `README.md`, `CONTRIBUTING.md` und `docs/README_EN.md` verweisen jetzt
    auf den publizierten GitHub-Wiki-Einstieg und weiterhin auf `docs/wiki/`
    als versionierte Quelle.
  - Die Repo-Einstiege trennen klarer zwischen kuratierter Orientierung im
    Wiki und technischer Source of Truth unter `docs/`.
  - Git-Commit: `cc7d107`
  - Artefakte: `.artifacts/sprint_27_commit_2_von_2.md`,
    `.artifacts/sprint_27_commit_2_von_2.diff` (nach Push lokal erzeugen)
- Validierung:
  - `make wiki-link-check`
  - `make verify`

## Sprint 28 - `btkgit` absichern und operationalisieren

- Status: done
- Ziel: das repo-lokale Workflow-Wrapper-CLI fuer Auth-/Remote-/Cleanup-Faelle
  klarer, sicherer und im Solo-Maintenance-Alltag belastbarer machen.

### Geplante Bloecke

- S28C1/2: done - Wrapper-Logik und Smoke-Absicherung fuer Failure-UX,
  konservatives Cleanup und klare Operator-Hinweise haerten.
- S28C2/2: done - ADR, Einstiegsdoku und Sprint-Traceability auf den
  gehaerteten `btkgit`-Ist-Zustand synchronisieren.

### Fortschritt (2026-03-29)

- `S28C1/2` abgeschlossen:
  - `btkgit` und `scripts/btkgit.sh` liefern jetzt gezielte Hinweise fuer
    fehlendes `origin`, fehlenden Branch-Upstream sowie Auth-/Remote-Probleme,
    ohne Credentials oder Remotes automatisch zu veraendern.
  - `cleanup` loescht lokale Branches nur noch explizit via
    `--delete-local`; der Default-Fall bleibt konservativ und `main`
    unloeschbar.
  - `tests/smoke/smoke_cli.sh` deckt `ready --skip-verify`,
    `preflight default -- --help`, `sync`-Fehlerpfade und die neue
    `cleanup`-Semantik jetzt nicht-destruktiv in isolierten Temp-Repos ab.
  - Git-Commit: `ebf8626`
  - Artefakte: `.artifacts/sprint_28_commit_1_von_2.md`,
    `.artifacts/sprint_28_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S28C2/2` abgeschlossen:
  - `docs/ADR/ADR-0010-repo-local-workflow-wrapper-cli.md` haelt jetzt den
    gehaerteten MVP-Vertrag, die Failure-UX-Leitplanke und die
    Nicht-Ziele fuer Auth-/Remote-/Delete-Automation explizit fest.
  - `docs/README.md` beschreibt `btkgit` jetzt als bewusst kleines
    Repo-Werkzeug mit konservativem Cleanup und klaren Grenzen gegenueber
    `git`/`gh`.
  - `docs/CHANGELOG.md` und `docs/SPRINTS.md` fuehren Sprint 28 und die
    verifizierten Checks nach.
- Validierung:
  - `tests/smoke/smoke_cli.sh`
  - `make verify`

## Sprint 29 - Go-/No-Go-Gate vor `1.4.0-dev`

- Status: done
- Ziel: die Startfreigabe fuer `1.4.0-dev` als eigenen Gate-Sprint
  dokumentieren, ohne den eigentlichen Dev-Start oder `BL-0016` vorwegzunehmen.

### Geplante Bloecke

- S29C1/2: done - formales Startgate und Status-/Entry-Sync fuer den
  separaten Aktivierungs-Commit liefern.
- S29C2/2: done - Sprint-Traceability und Go-/No-Go-Narrativ in
  `docs/CHANGELOG.md` und `docs/SPRINTS.md` finalisieren.

### Fortschritt (2026-03-29)

- `S29C1/2` abgeschlossen:
  - Neues Gate-Dokument `docs/DEV_START_GATE_1_4_0.md` definiert
    Preconditions, Go-/No-Go-Kriterien und den aktuellen Stand `GO` fuer
    einen spaeteren separaten Aktivierungs-Commit.
  - `docs/STATUS.md`, `docs/README.md`, `docs/README_EN.md` und `README.md`
    trennen jetzt explizit zwischen abgeschlossenem Vorbereitungsblock,
    Startfreigabe und eigentlichem Dev-Start.
  - `APP_VERSION=1.3.0` bleibt unveraendert; der Dev-Start wurde bewusst
    nicht vorgezogen.
  - Git-Commit: `f97a591`
  - Artefakte: `.artifacts/sprint_29_commit_1_von_2.md`,
    `.artifacts/sprint_29_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S29C2/2` abgeschlossen:
  - `docs/CHANGELOG.md` und `docs/SPRINTS.md` fuehren Sprint 29 jetzt als
    eigenen Go-/No-Go-Gate-Sprint.
  - Der naechste zulaessige Schritt bleibt explizit ein separater
    Aktivierungs-Commit fuer `1.4.0-dev`; inhaltliche Folgearbeit ist erst
    danach zulaessig.

### Validierung

- `make verify`

## Sprint 30 - `1.4.0-dev` starten und `BL-0016` als Baseline liefern

- Status: done
- Ziel: `1.4.0-dev` per isoliertem Aktivierungs-Commit starten, danach
  `BL-0016` als ersten In-Repo-Block umsetzen und den Legacy-Task-Index
  sauber auf Markdown heben.

### Geplante Bloecke

- S30C1/4: done - `1.4.0-dev` separat aktivieren und nur die aktive
  Roadmap-/Status-/Entry-Doku synchronisieren.
- S30C2/4: done - `BL-0016` als Community-Standards-Baseline liefern.
- S30C3/4: done - `docs/tasks/README.txt` nach Markdown migrieren und den
  Tracker-Lint dafuer gezielt nachziehen.
- S30C4/4: done - Sprint-Traceability und Verifikationsnachweis finalisieren.

### Fortschritt (2026-03-30)

- `S30C1/4` abgeschlossen:
  - `src/Betankungen.lpr` setzt `APP_VERSION` in einem klar isolierten
    Aktivierungs-Commit auf `1.4.0-dev`.
  - Root-README, deutsche/englische Einstiegsdoku, `CONTRIBUTING.md` und
    `docs/STATUS.md` fuehren den Sprint-29-Gate ab jetzt als eingeloesten
    Vorstart-Nachweis.
  - Git-Commit: `5a2d69b`
  - Artefakte: `.artifacts/sprint_30_commit_1_von_4.md`,
    `.artifacts/sprint_30_commit_1_von_4.diff` (nach Push lokal erzeugen)
- `S30C2/4` abgeschlossen:
  - `BL-0016` ist als Community-Standards-Baseline umgesetzt.
  - Geliefert wurden `CODE_OF_CONDUCT.md`, `SECURITY.md`,
    Bug-/Feature-Issue-Templates und ein PR-Template mit `Summary` und
    `Validation`.
  - `docs/BACKLOG.md` und
    `docs/backlog/BL-0016-community-standards-baseline/item.md` stehen auf
    `done`; Root-README, `CONTRIBUTING.md`, `docs/README.md`,
    `docs/README_EN.md` und `docs/STATUS.md` sind synchronisiert.
  - Git-Commit: `72e0d06`
  - Artefakte: `.artifacts/sprint_30_commit_2_von_4.md`,
    `.artifacts/sprint_30_commit_2_von_4.diff` (nach Push lokal erzeugen)
- `S30C3/4` abgeschlossen:
  - `docs/tasks/README.txt` wurde zu `docs/tasks/README.md` migriert.
  - `scripts/projtrack_lint.sh` lintet unter `docs/tasks/` jetzt gezielt nur
    echte Legacy-Task-Dateien `TSK-*.md`, damit der Markdown-Index nicht als
    Tracker-Artefakt fehlinterpretiert wird.
  - Git-Commit: `cc3d8f6`
  - Artefakte: `.artifacts/sprint_30_commit_3_von_4.md`,
    `.artifacts/sprint_30_commit_3_von_4.diff` (nach Push lokal erzeugen)
- `S30C4/4` abgeschlossen:
  - `docs/CHANGELOG.md` und `docs/SPRINTS.md` dokumentieren Sprint 30 jetzt
    als vierteiligen Dev-Start-Sprint mit getrenntem Aktivierungs-Commit,
    Inhaltsblock `BL-0016`, Legacy-Markdown-Migration und Vollnachweis.

### Validierung

- `make verify`

## Sprint 31 - `BL-0011` repo-seitig externalisiert abschliessen

- Status: done
- Ziel: den repo-seitigen Externalisierungs-/Handover-Stand von `BL-0011`
  final abschliessen und klar dokumentieren, dass weitere fachliche Arbeit
  ausserhalb von `Betankungen` stattfindet.

### Geplante Bloecke

- S31C1/2: done - Tracker-, Scope-Decision-, Backlog- und Status-Texte auf
  finalen Closeout fuer `Betankungen` ziehen.
- S31C2/2: done - Sprint-Traceability und Verifikationsnachweis fuer den
  Externalisierungs-Closeout finalisieren.

### Fortschritt (2026-03-30)

- `S31C1/2` abgeschlossen:
  - `docs/backlog/BL-0011-projekt-scaffolder-repo-bootstrap/item.md` steht
    fuer `Betankungen` jetzt auf `done`.
  - `docs/BL-0011_SCOPE_DECISION_1_4_0.md`, `docs/BACKLOG.md` und
    `docs/STATUS.md` behandeln `BL-0011` nicht mehr als offenen In-Repo-Block
    der `1.4.0`-Linie.
  - Weitere Umsetzung ist explizit nur noch in einem separaten Zielprojekt
    vorgesehen.
  - Git-Commit: `7a5c038`
  - Artefakte: `.artifacts/sprint_31_commit_1_von_2.md`,
    `.artifacts/sprint_31_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S31C2/2` abgeschlossen:
  - `docs/CHANGELOG.md` und `docs/SPRINTS.md` fuehren Sprint 31 jetzt als
    repo-seitigen Externalisierungs-Closeout fuer `BL-0011`.
  - Der gruene Vollnachweis `make verify` ist fuer den Sprint dokumentiert.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`

## Sprint 32 - `BL-0029` Odometer-Contract haerten

- Status: done
- Ziel: negative `odometer_km`-Eingaben ueber die relevanten
  `--add fuelups`-Pfade auf einen klaren Hard-Error-Contract ziehen und
  regressionssicher absichern.

### Geplante Bloecke

- S32C1/2: done - kanonischen Odometer-Untergrenzen-Guard im Fuelup-Flow
  einfuehren, Regressionen ergaenzen und die direkt betroffenen
  Tracker-/Benutzerdokumente synchronisieren.
- S32C2/2: done - Sprint-Traceability, Abschlussstatus und Vollverifikation
  fuer `BL-0029` finalisieren.

### Fortschritt (2026-03-31)

- `S32C1/2` abgeschlossen:
  - `units/u_fuelups.pas` nutzt jetzt einen kanonischen Untergrenzen-Guard
    fuer `odometer_km`.
  - Negative Werte werden vor `P-010`/`P-011`/`P-013` mit derselben
    handlungsorientierten Fehlermeldung geblockt.
  - Neue Regressionen decken den expliziten `--car-id`-Pfad und den
    1-Car-Autoresolve-Pfad ab.
  - `BL-0029`, `TSK-0001` und `ISS-0001` wurden auf `done`/`resolved`
    gezogen; `docs/BACKLOG.md` und `docs/BENUTZERHANDBUCH.md`
    sind synchronisiert.
  - Git-Commit: `193a7e0`
  - Artefakte: `.artifacts/sprint_32_commit_1_von_2.md`,
    `.artifacts/sprint_32_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S32C2/2` abgeschlossen:
  - `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankern Sprint 32 jetzt mit
    Hash-/Verifikationsbezug.
  - `BL-0029` ist als abgeschlossener Stabilisierungssprint der aktiven
    `1.4.0-dev`-Linie dokumentiert.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`

## Sprint 33 - `BL-0019` Stations-Geodaten und Plus Codes

- Status: done
- Ziel: den Stationskontext der aktiven `1.4.0-dev`-Linie kontrolliert um
  Geokoordinaten und optionale Plus Codes erweitern, ohne die kompakte
  CLI-Nutzung in Richtung Mapping/GUI auszuweiten.

### Geplante Bloecke

- S33C1/2: done - Schema, Dialogpfade, Migrationen, Regressionen und direkt
  betroffene Produkt-/Tracker-Doku fuer `BL-0019` liefern.
- S33C2/2: done - Sprint-Traceability, Abschlussstatus und Vollverifikation
  fuer `BL-0019` finalisieren.

### Fortschritt (2026-03-31)

- `S33C1/2` abgeschlossen:
  - `stations` fuehren jetzt optionale Geodaten ueber
    `latitude_e6`/`longitude_e6` sowie `plus_code`.
  - `--add stations` und `--edit stations` validieren Koordinatenpaare,
    Dezimalgrad-Bereiche und volle Open Location Codes; Plus Codes werden vor
    Persistenz whitespace-frei und in Grossbuchstaben normalisiert.
  - Die kompakte Stationsliste bleibt adressfokussiert; `--list stations
    --detail` zeigt vorhandene Geodaten als zusaetzliche `geodata:`-Zeile.
  - `tests/smoke/smoke_migrations.sh` deckt jetzt `v4 -> v6` und `v5 -> v6`
    ab; Domain-Policy `P-085` bis `P-088` und die neue Regression
    `run_station_geodata_contract_check.sh` sichern Persistenz und
    Sichtbarkeit.
  - `BL-0019` und `docs/BACKLOG.md` wurden auf `done` synchronisiert.
  - Git-Commit: `2064fbd`
  - Artefakte: `.artifacts/sprint_33_commit_1_von_2.md`,
    `.artifacts/sprint_33_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S33C2/2` abgeschlossen:
  - `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankern Sprint 33 jetzt mit
    Hash-/Verifikationsbezug.
  - `BL-0019` ist als abgeschlossener Paket-B-Block der aktiven
    `1.4.0-dev`-Linie dokumentiert.

### Validierung

- `tests/smoke/smoke_migrations.sh --all`
- `tests/regression/run_station_geodata_contract_check.sh`
- `tests/domain_policy/run_domain_policy_tests.sh`
- `tests/smoke/smoke_cars_crud.sh`
- `tests/smoke/smoke_multi_car_context.sh`
- `scripts/projtrack_lint.sh`
- `make verify`

## Sprint 35 - Minimales EV-Charging-Modell und Storage-Grenzen

- Status: done
- Ziel: den EV-Discovery-Block `BL-0030` mit einem kleinen, belastbaren
  Charging-Event-Modell und klaren Storage-Grenzen abschliessen, damit ein
  separater EV-MVP-Block ohne Core-Generalisierung starten kann.

### Geplante Bloecke

- S35C1/2: done - `TSK-0025` fachlich abschliessen und die Event-/
  Storage-Grenze in Tracker, Architektur und Status festziehen.
- S35C2/2: done - Sprint-Traceability und Vollverifikation fuer den
  abgeschlossenen Discovery-Block finalisieren.

### Fortschritt (2026-04-01)

- `S35C1/2` abgeschlossen:
  - `BL-0030` und `TSK-0025` stehen jetzt auf `done`.
  - Das minimale EV-Event-Modell bleibt klein: `car_id`, `event_date`,
    `energy_wh` und `cost_cents` sind verpflichtend; `odometer_km`,
    `location_id` und `notes` bleiben optional.
  - Der erste Storage-Schnitt bleibt modul-lokal ueber `module_meta`,
    `charging_events` und `charging_locations`.
  - Ein generisches Core-`energy_events` und die Wiederverwendung von
    Core-`stations` als kanonischer Ladeort-Speicher sind fuer `1.4.x`
    explizit ausgeschlossen.
  - Git-Commit: `b613acd`
  - Artefakte: `.artifacts/sprint_35_commit_1_von_2.md`,
    `.artifacts/sprint_35_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S35C2/2` abgeschlossen:
  - `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankern Sprint 35 jetzt mit
    Hash- und Verifikationsbezug.
  - `BL-0030` ist damit als abgeschlossener Discovery-/Boundary-Sprint
    referenzierbar; ein separater EV-MVP-Folgeblock kann darauf aufsetzen,
    ohne in `1.4.x` den Core in Richtung `energy_events` aufzubiegen.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`

## Sprint 34 - Paket C strategisch auf EV-Discovery ziehen

- Status: done
- Ziel: nach den abgeschlossenen Paketen A und B genau eine groessere
  Domaenenerweiterung fuer die aktive `1.4.x`-Linie priorisieren und als
  kontrollierten Discovery-Block im Repo verankern.

### Geplante Bloecke

- S34C1/2: done - EV als naechsten strategischen Discovery-Pfad priorisieren,
  `ADR-0008` akzeptieren und einen einzelnen kanonischen Backlog-Block mit
  Folge-Tasks aktivieren.
- S34C2/2: done - Sprint-Traceability und Vollverifikation fuer die
  Paket-C-Entscheidung finalisieren.

### Fortschritt (2026-03-31)

- `S34C1/2` abgeschlossen:
  - `ADR-0008` ist jetzt `accepted` und fixiert EV als priorisierte erste
    modulare Domaenenerweiterung gegenueber einem unmittelbaren Core-Ausbau.
  - Neuer kanonischer Discovery-Block `BL-0030` aktiviert den
    Feasibility-Pfad fuer ein moegliches Modul `betankungen-ev`.
  - `TSK-0024` und `TSK-0025` machen Scope-/Contract- sowie
    Storage-/Boundary-Fragen explizit; `docs/BACKLOG.md`,
    `docs/ADR/README.md` und `docs/STATUS.md` fuehren Paket C jetzt mit
    derselben Priorisierung.
  - Git-Commit: `23cdef6`
  - Artefakte: `.artifacts/sprint_34_commit_1_von_2.md`,
    `.artifacts/sprint_34_commit_1_von_2.diff` (nach Push lokal erzeugen)
- `S34C2/2` abgeschlossen:
  - `docs/CHANGELOG.md` und `docs/SPRINTS.md` verankern Sprint 34 jetzt mit
    Hash-/Verifikationsbezug.
  - Paket C bleibt damit als bewusster Richtungs- und Discovery-Sprint
    referenzierbar; Household Drivers werden nicht stillschweigend parallel
    aktiviert.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`

## General-Stream nach Sprint 34 - Stations-Short-Codes und Geodata-Contract

- Status: done
- Ziel: den Stations-Geodata-Flow fuer realistische Plus-Code-Eingaben aus
  mobilen Karten-UIs oeffnen, ohne den kanonischen Speichervertrag fuer
  `plus_code` aufzugeben.

### Stand (2026-04-01)

- `u_stations` akzeptiert jetzt sowohl volle/globalen Open Location Codes als
  auch lokale/short Plus Codes, wenn `latitude` und `longitude` gesetzt sind.
- Ortszusaetze aus gaengigen Karten-UIs (z. B. `GC2M+H4 Dortmund`) werden
  bei der Normalisierung auf den eigentlichen Plus-Code-Token reduziert.
- Short Codes ohne Koordinaten liefern weiter einen Hard Error, aber jetzt mit
  expliziter Guidance auf `latitude`/`longitude` oder einen vollen Code.
- Persistiert wird weiterhin ein kanonischer Vollcode; die Detailausgabe
  `--list stations --detail` zeigt ihn wie vorgesehen in der `geodata:`-Zeile.
- `ISS-0007`, `BL-0019`, `tests/domain_policy/p080.md`, die neuen
  `P-088/02`- und `P-088/03`-Cases sowie
  `tests/regression/run_station_geodata_contract_check.sh` sichern den neuen
  Contract ab.

### Validierung

- `bash tests/domain_policy/cases/t_p088__01__station_plus_code_invalid_rejected.sh`
- `bash tests/domain_policy/cases/t_p088__02__station_short_plus_code_without_coordinates_rejected.sh`
- `bash tests/domain_policy/cases/t_p088__03__station_short_plus_code_with_coordinates_accepts.sh`
- `tests/regression/run_station_geodata_contract_check.sh`
- `scripts/projtrack_lint.sh`
- `make verify`

## General-Stream nach Sprint 34 - EV module scope baseline

- Status: done
- Ziel: `TSK-0024` als klaren Discovery-/Contract-Block abschliessen und den
  minimalen Scope fuer `betankungen-ev` so schneiden, dass `TSK-0025`
  unmittelbar mit Event-/Storage-Fragen weiterarbeiten kann, ohne schon eine
  produktive EV-Implementierung oder ein generisches Core-Refactoring
  vorzuziehen.

### Stand (2026-04-01)

- `BL-0030` wurde auf `in_progress` gezogen und `TSK-0024` auf `done`
  gestellt.
- `docs/MODULES_ARCHITECTURE.md` definiert jetzt den minimalen
  `charging`-Scope, die Core-vs-Modul-Grenzen, die erwarteten
  `capabilities` und die expliziten Nicht-Ziele fuer `betankungen-ev`.
- `docs/BACKLOG.md` und `docs/STATUS.md` fuehren denselben Discovery-
  Zuschnitt; `TSK-0025` bleibt auf das minimale Event-/Storage-Modell
  begrenzt.
- `docs/CHANGELOG.md` und `docs/SPRINTS.md` fuehren diesen Block bewusst als
  General-Stream ohne neuen Sprint-Prefix.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`

## General-Stream nach Sprint 33 - Car-Startwerte vor erstem Fuelup korrigieren

- Status: done
- Ziel: den Cars-Edit-Flow so oeffnen, dass Start-KM/-Datum eines Fahrzeugs
  vor dem ersten Fuelup korrigiert werden koennen, ohne die spaetere
  Odometer-Historie zu destabilisieren.

### Stand (2026-03-31)

- `--edit cars` fragt Start-KM und Start-Datum jetzt mit ab, solange fuer das
  Fahrzeug noch keine `fuelups` existieren.
- Sobald bereits `fuelups` vorhanden sind, zeigt der Edit-Flow die Startwerte
  nur noch als gesperrt an; Name/Plate/Note bleiben weiterhin editierbar.
- `u_db_init` ersetzt die fruehere globale Immutability durch DB-Trigger, die
  Startwert-Aenderungen erst **nach** dem ersten Fuelup blockieren.
- `tests/smoke/smoke_cars_crud.sh` deckt jetzt sowohl die erfolgreiche
  Korrektur vor dem ersten Fuelup als auch den CLI-/DB-Guard danach ab.
- `docs/README.md` und `docs/BENUTZERHANDBUCH.md` dokumentieren die neue
  Produktregel fuer Fahrzeug-Startwerte.

### Validierung

- `tests/smoke/smoke_cars_crud.sh`
- `make verify`

## General-Stream nach Sprint 31 - Knowledge-Archive stilllegen

- Status: done
- Ziel: `knowledge_archive/` repo-seitig ruhig stilllegen, den Bestand als
  Legacy-/Read-only-Ordner behalten und die Pflicht fuer neue
  Archiv-Snippets aufheben.

### Stand (2026-03-31)

- `AGENTS.md` und `knowledge_archive/README.md` markieren
  `knowledge_archive/` jetzt explizit als deprecated/read-only.
- Neue Archiv-Snippets sind nicht mehr verpflichtender Repo-Standard; fuer
  fruehere Implementationsstaende ist die Git-Historie der primaere
  Rueckgriff.
- `docs/STATUS.md`, `docs/README.md` und `docs/ARCHITECTURE.md` ordnen den
  Ordner nur noch als Legacy-Bestand ein.
- Historische Referenzen in `docs/CHANGELOG.md` und `docs/SPRINTS.md`
  bleiben bewusst unveraendert; der neue Status wird nur transparent
  dokumentiert.

### Validierung

- `make verify`

## Traceability-Backfill fuer Sprint 25 bis 28

- Status: done
- Ziel: die fehlenden kanonischen BL-/ADR-Referenzen fuer den bereits
  abgeschlossenen Vorbereitungsblock nachziehen, ohne Sprint 25 bis 28
  inhaltlich neu zu oeffnen.

### Stand (2026-03-30)

- `BL-0025` bis `BL-0028` dokumentieren Sprint 25 bis 28 jetzt auch im
  kanonischen Backlog.
- `ADR-0011` bis `ADR-0013` halten den bereits entschiedenen Tracker-,
  Entry-Layer- und `btkgit`-Vertrag explizit fest.
- `docs/BACKLOG.md`, `docs/ADR/README.md` und `docs/STATUS.md` sind auf diese
  Backfills synchronisiert; bestehende Sprint-Ziele, Commit-Folgen und
  Gate-Aussagen bleiben unveraendert.
- Kein Start von `1.4.0-dev`, keine Aktivierung von `BL-0016`, keine neue
  `btkgit`-Umsetzung.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`
