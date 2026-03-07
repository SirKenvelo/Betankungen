# Backlog
**Stand:** 2026-03-07

Dieses Dokument sammelt bewusst verschobene oder spaeter geplante Themen.
Nur umsetzbare Arbeitspakete gehoeren hier hinein; offene Architektur-/Produktentscheidungen liegen in `docs/ADR/`.

## Status-Legende

- `icebox`: bewusst nach hinten gestellt, kein aktiver Sprint-Commitment.
- `next`: fuer einen der naechsten Sprints priorisiert.
- `blocked`: fachlich klar, aber durch Abhaengigkeiten blockiert.

## BL-001 - Policy Structure Coverage Check

- Status: `icebox`
- Nicht Teil von: `0.8.0-dev`
- Typ: Meta-Guardrail fuer `tests/domain_policy/`
- Ziel: zusaetzlicher Vollstaendigkeits-/Referenz-/Traceability-Check fuer die Policy-Struktur.
- Scope:
  - jede `p*.md` hat mindestens einen passenden Case `cases/t_pXXX_*`
  - keine verwaisten Cases ohne passende Policy-Datei
  - keine verwaisten Fixtures ohne Referenz
  - IDs zwischen Policy-Datei, Case-Datei und Matrix/README bleiben konsistent
- Geplanter Dateipfad:
  - `tests/domain_policy/check_policy_coverage.sh`
- Wichtiger Hinweis:
  - kein Ersatz fuer bestehende Policy-Ausfuehrung
  - bestehende Ausfuehrung bleibt ueber `tests/domain_policy/run_domain_policy_tests.sh` + Matrix-Doku in `tests/domain_policy/README.md` bestehen

## BL-002 - Developer-Easter-Egg `--ndt`

- Status: `icebox`
- Typ: optionales Developer-Feature (humorvoll, intern)
- Ziel: bei explizitem Aufruf eine zufaellige Entwickler-Nachricht ausgeben.
- Flag:
  - `--ndt` (Nachricht des Tages)
- Guardrails:
  - nur bei explizitem Aufruf aktiv
  - keine Auswirkung auf normale CLI-Outputs
  - kein Einfluss auf Skript-/Maschinen-Ausgaben
  - keine unnoetige Kopplung mit i18n oder Domain-Logik
- Moegliche Datenquelle:
  - `data/dev_messages.txt` (bevorzugt)
  - alternativ `assets/dev_messages.txt`
- Startbestand (erste Vorschlagsliste):
  - `Interrupt Cookie_Interaction { Play_Mode("ausgelassen"); Body.ingest("Winterbier"); } Catch (Frog_Detected) { Cookie.jump(); Frog.panic(); }`
  - `ss -tulpen`
  - `Wenn dir alles zu viel wird: kurz innehalten, Systemstatus pruefen - du bist nicht allein im Netz.`
  - `Fuel efficiency is temporary. Good architecture is forever.`
  - `Remember: tests are cheaper than debugging.`
  - `If this tool helped you, Cookie demands one treat.`

## Verknuepfte Entscheidungen

- Siehe `docs/ADR/ADR-0004-fleet-stats-naming.md` fuer den noch offenen Naming-Entscheid zu `--stats fleet` vs. `--stats cars`.
