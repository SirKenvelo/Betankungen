# BL-001 - Policy Structure Coverage Check
**Stand:** 2026-03-09
**Status:** icebox
**Typ:** Meta-Guardrail fuer `tests/domain_policy/`

## Ziel

Zusaetzlicher Vollstaendigkeits-/Referenz-/Traceability-Check fuer die Policy-Struktur.

## Scope

- jede `p*.md` hat mindestens einen passenden Case `cases/t_pXXX_*`
- keine verwaisten Cases ohne passende Policy-Datei
- keine verwaisten Fixtures ohne Referenz
- IDs zwischen Policy-Datei, Case-Datei und Matrix/README bleiben konsistent

## Nicht Teil von

- `0.8.0-dev`

## Geplanter Dateipfad

- `tests/domain_policy/check_policy_coverage.sh`

## Wichtiger Hinweis

- kein Ersatz fuer bestehende Policy-Ausfuehrung
- bestehende Ausfuehrung bleibt ueber `tests/domain_policy/run_domain_policy_tests.sh` + Matrix-Doku in `tests/domain_policy/README.md` bestehen
