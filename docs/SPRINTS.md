# SPRINTS
**Stand:** 2026-03-04

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

- Status: in progress
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
