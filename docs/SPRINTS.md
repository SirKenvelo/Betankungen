# SPRINTS
**Stand:** 2026-03-17

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
