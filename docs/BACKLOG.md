# Backlog
**Stand:** 2026-03-31

Dieses Dokument ist der uebergreifende Navigationsindex fuer Backlog-Themen.
Neue Backlog-Arbeit wird im kanonischen Tracker unter `docs/backlog/`
gepflegt; historische BL-0xx unter `docs/BACKLOG/` bleiben lesbar und
referenzierbar. Offene Architektur-/Produktentscheidungen liegen aktuell in
`docs/ADR/`; eine separate ADR-Pfadmigration ist derzeit nicht aktiviert.

## Status-Legende

### Kanonischer Tracker (`BL-xxxx`)

- `idea`: fruehe Idee ohne verbindliche Priorisierung.
- `proposed`: konkret beschrieben, aber noch nicht freigegeben.
- `approved`: fachlich freigegeben und fuer einen der naechsten Schritte
  einplanbar.
- `in_progress`: aktiv in Bearbeitung.
- `blocked`: fachlich klar, aber durch Abhaengigkeiten blockiert.
- `done`: abgeschlossen.
- `dropped`: bewusst verworfen oder aus dem Scope genommen.

### Legacy-Backlog (`BL-0xx`)

- `icebox`: bewusst nach hinten gestellt, kein aktiver Sprint-Commitment.
- `geplant`: fachlich vorgesehen und priorisierbar, aber noch kein aktiver Sprint-Commitment.
- `next`: fuer einen der naechsten Sprints priorisiert.
- `blocked`: fachlich klar, aber durch Abhaengigkeiten blockiert.
- `done`: historisch abgeschlossen.

## Priorisierungs-Lanes (empfohlen)

- `release-blocking`: gehoert in den aktiven Release-Scope.
- `planned`: wichtig, aber nicht release-blockierend.
- `exploratory`: Forschungs-/Ideenblock mit unsicherem ROI.

Hinweis: Die Lane kann in BL-Frontmatter als Tag (`lane:*`) gefuehrt werden.

## Kanonische BL-xxxx (aktuelle Arbeitsbasis)

Neue `BL-xxxx` und neue `TSK-xxxx` werden nur in dieser Struktur angelegt.

- [BL-0011 - Projekt-Scaffolder (Repo Bootstrap)](backlog/BL-0011-projekt-scaffolder-repo-bootstrap/item.md) - Status: `done`, Typ: Research (repo-seitiger Externalisierungs-/Handover-Closeout abgeschlossen; weitere Umsetzung nur extern), Lane: `exploratory`
- [BL-0012 - Module Capability Discovery erweitern](backlog/BL-0012-module-capability-discovery/item.md) - Status: `done`, Typ: Feature (Module-Contract), Lane: `release-blocking` (historisch)
- [BL-0013 - Performance-Benchmark-Harness fuer Stats-Collector](backlog/BL-0013-stats-performance-benchmark-harness/item.md) - Status: `done`, Typ: Research (trigger-basiert), Lane: `planned` (historisch)
- [BL-0014 - Import-Export-Paketformat mit Manifest und Checksum](backlog/BL-0014-import-export-package-format/item.md) - Status: `done`, Typ: Research (priorisierter Feature-Block fuer 1.1.0), Lane: `release-blocking` (historisch)
- [BL-0015 - Release- und Verify-Hardening fuer die 1.1.0-Linie](backlog/BL-0015-release-verify-hardening-1-1-0/item.md) - Status: `done`, Typ: Improvement (priorisierter Hardening-Block fuer 1.1.0), Lane: `release-blocking` (historisch)
- [BL-0016 - Community-Standards-Baseline fuer das Public Repository](backlog/BL-0016-community-standards-baseline/item.md) - Status: `done`, Typ: Improvement (Code of Conduct, Security Policy, Issue-/PR-Templates geliefert), Lane: `planned`
- [BL-0017 - Evaluation kostenloser Tankstellenpreis-APIs](backlog/BL-0017-fuel-price-api-evaluation/item.md) - Status: `done`, Typ: Research (API-Quellenentscheid fuer Preis-Polling), Lane: `release-blocking` (1.3.0)
- [BL-0018 - Historische Tankstellenpreis-Erfassung via API-Polling](backlog/BL-0018-fuel-price-history-polling/item.md) - Status: `done`, Typ: Feature (15-Minuten-Polling + Historienbasis), Lane: `release-blocking` (1.3.0)
- [BL-0019 - Tankstellen-Geodaten und Plus-Codes erweitern](backlog/BL-0019-station-geodata-plus-codes/item.md) - Status: `done`, Typ: Feature (Koordinaten/Plus-Codes fuer Stationen inkl. Validierung/Migration), Lane: `planned`
- [BL-0020 - Backup-Operationen fuer einzelne oder alle Tankdatenbanken](backlog/BL-0020-multi-database-backup-operations/item.md) - Status: `done`, Typ: Improvement (Mehr-DB-Backup im Betrieb), Lane: `release-blocking` (1.2.0)
- [BL-0021 - Tankbeleg-Foto-Links als Referenz speichern](backlog/BL-0021-receipt-photo-link-references/item.md) - Status: `done`, Typ: Feature (externe Belegbilder nur per Link referenzieren), Lane: `release-blocking` (1.2.0)
- [BL-0022 - User-Flow- und QA-Hardening aus Nutzertests](backlog/BL-0022-user-flow-and-qa-hardening/item.md) - Status: `done`, Typ: Improvement (reproduzierbare Nutzertest-Funde in Matrix, Tracker und Folgetasks ueberfuehren), Lane: `planned`
- [BL-0023 - Dev-Diary als kuratierte Projektchronik](backlog/BL-0023-dev-diary-project-chronicle/item.md) - Status: `done`, Typ: Improvement (kuratierte Entwicklungschronik in `docs/DEV_DIARY.md` + Initialeintrag), Lane: `planned`
- [BL-0024 - Cookie als persoenliche Wiki-Notiz mit optionalem Bild](backlog/BL-0024-cookie-personal-wiki-note/item.md) - Status: `done`, Typ: Improvement (kleine persoenliche Wiki-Notiz mit behutsamem Public-Readiness-Rahmen), Lane: `planned`, Tasks: `TSK-0022` (`done`), `TSK-0023` (`done`)
- [BL-0025 - Tracker-Endzustand und Legacy-Grenzen fuer neue Arbeit](backlog/BL-0025-tracker-end-state-legacy-boundaries/item.md) - Status: `done`, Typ: Improvement (kanonische vs. historische Tracker-Pfade fuer neue Arbeit verbindlich getrennt), Lane: `planned` (historisch)
- [BL-0026 - Transition-Hold und Entry-Doku-Sync nach 1.3.0](backlog/BL-0026-transition-hold-entry-doc-sync/item.md) - Status: `done`, Typ: Improvement (Einstiegsdoku konsistent auf finaler `1.3.0`-Linie und bewusstem Hold gehalten), Lane: `planned` (historisch)
- [BL-0027 - Wiki-Entry-Layer und Public-Readiness-Ausrichtung](backlog/BL-0027-wiki-entry-layer-public-alignment/item.md) - Status: `done`, Typ: Improvement (Wiki-Entry und Repo-Einstiege ruhig gegenueber `docs/` als Source of Truth ausgerichtet), Lane: `planned` (historisch)
- [BL-0028 - `btkgit`-Safety-Guardrails fuer Solo-Maintenance](backlog/BL-0028-btkgit-safety-guardrails/item.md) - Status: `done`, Typ: Improvement (`btkgit`-Failure-UX, konservatives Cleanup und Smoke-Guardrails explizit nachgeschaerft), Lane: `planned` (historisch)
- [BL-0029 - Odometer Validation Contract Hardening](backlog/BL-0029-odometer-validation-contract-hardening/item.md) - Status: `done`, Typ: Improvement (kanonischer Hard-Error-Contract fuer negative `odometer_km`-Eingaben umgesetzt und regressionsgesichert), Lane: `planned`, Tasks: `TSK-0001` (`done`)
- [BL-0030 - EV Companion Feasibility Spike](backlog/BL-0030-ev-companion-feasibility-spike/item.md) - Status: `approved`, Typ: Research (priorisierter Paket-C-Discovery-Block fuer EV als naechste modulare Domaenenerweiterung), Lane: `exploratory`, Tasks: `TSK-0024` (`todo`), `TSK-0025` (`todo`)

## Legacy Backlog-Index (BL-0xx)

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
