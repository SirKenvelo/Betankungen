# SPRINTS
**Stand:** 2026-03-06

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

- Status: in progress
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
- Status: in progress
- Git-Commit: pending (wird nach Commit mit 7-stelligem Short-Hash nachgetragen)
- Artefakte: `sprint_3_commit_3_von_3.md`, `sprint_3_commit_3_von_3.diff` (pending)

### Abschluss-Tag

- Sprint-Abschluss: S3C3/3 (Doku-Finalisierung VIN-Policy/UX + Traceability)
- Abschluss-Tag: `sprint-3-done` (pending, wird erst nach expliziter Freigabe gesetzt und gepusht)
