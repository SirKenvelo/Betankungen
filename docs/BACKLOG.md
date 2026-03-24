# Backlog
**Stand:** 2026-03-24

Dieses Dokument sammelt bewusst verschobene oder spaeter geplante Themen.
Nur umsetzbare Arbeitspakete gehoeren hier hinein; offene Architektur-/Produktentscheidungen liegen in `docs/ADR/`.
Die zentrale Uebersicht bleibt in `docs/BACKLOG.md`; die Details je Thema liegen in `docs/BACKLOG/BL-*.md`.

## Status-Legende

- `icebox`: bewusst nach hinten gestellt, kein aktiver Sprint-Commitment.
- `geplant`: fachlich vorgesehen und priorisierbar, aber noch kein aktiver Sprint-Commitment.
- `next`: fuer einen der naechsten Sprints priorisiert.
- `blocked`: fachlich klar, aber durch Abhaengigkeiten blockiert.

## Priorisierungs-Lanes (empfohlen)

- `release-blocking`: gehoert in den aktiven Release-Scope.
- `planned`: wichtig, aber nicht release-blockierend.
- `exploratory`: Forschungs-/Ideenblock mit unsicherem ROI.

Hinweis: Die Lane kann in BL-Frontmatter als Tag (`lane:*`) gefuehrt werden.

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
- [BL-012 - GitHub Wiki Enablement](BACKLOG/BL-012-github-wiki-enablement.md) - Status: `done`, Typ: Dokumentations-/Community-Enablement (Public-Readiness)

## Verknuepfte Entscheidungen

- Siehe `docs/ADR/ADR-0004-fleet-stats-naming.md` fuer die festgelegte Terminologie `--stats fleet` bei fahrzeuguebergreifenden Stats.

## Kanonische BL-xxxx (neues Tracker-Schema)

- [BL-0011 - Projekt-Scaffolder (Repo Bootstrap)](backlog/BL-0011-projekt-scaffolder-repo-bootstrap/item.md) - Status: `proposed`, Typ: Feature (Meta-/Tooling)
- [BL-0012 - Module Capability Discovery erweitern](backlog/BL-0012-module-capability-discovery/item.md) - Status: `done`, Typ: Feature (Module-Contract), Lane: `release-blocking` (historisch)
- [BL-0013 - Performance-Benchmark-Harness fuer Stats-Collector](backlog/BL-0013-stats-performance-benchmark-harness/item.md) - Status: `done`, Typ: Research (trigger-basiert), Lane: `planned` (historisch)
- [BL-0014 - Import-Export-Paketformat mit Manifest und Checksum](backlog/BL-0014-import-export-package-format/item.md) - Status: `done`, Typ: Research (priorisierter Feature-Block fuer 1.1.0), Lane: `release-blocking` (historisch)
- [BL-0015 - Release- und Verify-Hardening fuer die 1.1.0-Linie](backlog/BL-0015-release-verify-hardening-1-1-0/item.md) - Status: `done`, Typ: Improvement (priorisierter Hardening-Block fuer 1.1.0), Lane: `release-blocking` (historisch)
- [BL-0016 - Community-Standards-Baseline fuer das Public Repository](backlog/BL-0016-community-standards-baseline/item.md) - Status: `proposed`, Typ: Improvement (nicht-blockierender Public-Readiness-Follow-up), Lane: `planned`
- [BL-0017 - Evaluation kostenloser Tankstellenpreis-APIs](backlog/BL-0017-fuel-price-api-evaluation/item.md) - Status: `proposed`, Typ: Research (API-Quellenentscheid fuer Preis-Polling), Lane: `exploratory`
- [BL-0018 - Historische Tankstellenpreis-Erfassung via API-Polling](backlog/BL-0018-fuel-price-history-polling/item.md) - Status: `proposed`, Typ: Feature (15-Minuten-Polling + Historienbasis), Lane: `planned`
- [BL-0019 - Tankstellen-Geodaten und Plus-Codes erweitern](backlog/BL-0019-station-geodata-plus-codes/item.md) - Status: `proposed`, Typ: Feature (Koordinaten/Plus-Codes fuer Stationen), Lane: `planned`
- [BL-0020 - Backup-Operationen fuer einzelne oder alle Tankdatenbanken](backlog/BL-0020-multi-database-backup-operations/item.md) - Status: `done`, Typ: Improvement (Mehr-DB-Backup im Betrieb), Lane: `release-blocking` (1.2.0)
- [BL-0021 - Tankbeleg-Foto-Links als Referenz speichern](backlog/BL-0021-receipt-photo-link-references/item.md) - Status: `done`, Typ: Feature (externe Belegbilder nur per Link referenzieren), Lane: `release-blocking` (1.2.0)
- [BL-0022 - User-Flow- und QA-Hardening aus Nutzertests](backlog/BL-0022-user-flow-and-qa-hardening/item.md) - Status: `done`, Typ: Improvement (reproduzierbare Nutzertest-Funde in Matrix, Tracker und Folgetasks ueberfuehren), Lane: `planned`
- [BL-0023 - Dev-Diary als kuratierte Projektchronik](backlog/BL-0023-dev-diary-project-chronicle/item.md) - Status: `done`, Typ: Improvement (kuratierte Entwicklungschronik in `docs/DEV_DIARY.md` + Initialeintrag), Lane: `planned`
- [BL-0024 - Cookie als persoenliche Wiki-Notiz mit optionalem Bild](backlog/BL-0024-cookie-personal-wiki-note/item.md) - Status: `proposed`, Typ: Improvement (kleine persoenliche Wiki-Notiz mit behutsamem Public-Readiness-Rahmen), Lane: `exploratory`
