# Backlog
**Stand:** 2026-03-11

Dieses Dokument sammelt bewusst verschobene oder spaeter geplante Themen.
Nur umsetzbare Arbeitspakete gehoeren hier hinein; offene Architektur-/Produktentscheidungen liegen in `docs/ADR/`.
Die zentrale Uebersicht bleibt in `docs/BACKLOG.md`; die Details je Thema liegen in `docs/BACKLOG/BL-*.md`.

## Status-Legende

- `icebox`: bewusst nach hinten gestellt, kein aktiver Sprint-Commitment.
- `geplant`: fachlich vorgesehen und priorisierbar, aber noch kein aktiver Sprint-Commitment.
- `next`: fuer einen der naechsten Sprints priorisiert.
- `blocked`: fachlich klar, aber durch Abhaengigkeiten blockiert.

## Backlog-Index

- [BL-001 - Policy Structure Coverage Check](BACKLOG/BL-001-policy-structure-coverage-check.md) - Status: `icebox`, Typ: Meta-Guardrail
- [BL-002 - Developer-Easter-Egg `--ndt`](BACKLOG/BL-002-developer-easter-egg-ndt.md) - Status: `icebox`, Typ: optionales Developer-Feature
- [BL-003 - Household Drivers / Shared Cars](BACKLOG/BL-003-household-drivers-shared-cars.md) - Status: `icebox`, Typ: Domain-Erweiterung
- [BL-004 - Cross-Border Fuel Context (Currency / Country)](BACKLOG/BL-004-cross-border-fuel-context-currency-country.md) - Status: `icebox`, Typ: Domain-Erweiterung
- [BL-005 - Modulstrategie fuer Betankungen](BACKLOG/BL-005-modulstrategie-fuer-betankungen.md) - Status: `next`, Typ: Architekturentscheidung
- [BL-006 - UI Polishing & ASCII-Draw](BACKLOG/BL-006-ui-polishing-ascii-draw.md) - Status: `icebox`, Typ: UX-/Renderer-Erweiterung
- [BL-007 - Maintenance System](BACKLOG/BL-007-maintenance.md) - Status: `icebox`, Typ: Domain-Erweiterung (Companion-Modul)
- [BL-008 - Tire Management](BACKLOG/BL-008-tire-management.md) - Status: `icebox`, Typ: Domain-Erweiterung (Companion-Modul)
- [BL-009 - Agriculture Module](BACKLOG/BL-009-agriculture-module.md) - Status: `icebox`, Typ: Domain-Erweiterung (Companion-Modul)
- [BL-010 - Cost Analytics](BACKLOG/BL-010-cost-analytics.md) - Status: `next`, Typ: Stats-/Domain-Erweiterung (cross-module)
- [BL-011 - Projekt-Scaffolder (Repo Bootstrap)](BACKLOG/BL-011-projekt-scaffolder-repo-bootstrap.md) - Status: `geplant`, Typ: Tooling-/Meta-Projekt (separates Repository)

## Verknuepfte Entscheidungen

- Siehe `docs/ADR/ADR-0004-fleet-stats-naming.md` fuer die festgelegte Terminologie `--stats fleet` bei fahrzeuguebergreifenden Stats.
