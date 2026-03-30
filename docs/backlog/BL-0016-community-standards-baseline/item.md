---
id: BL-0016
title: Community-Standards-Baseline fuer das Public Repository
status: done
priority: P3
type: improvement
tags: [community, governance, docs, templates, 'lane:planned']
created: 2026-03-17
updated: 2026-03-30
related:
  - BL-012
  - POL-001
---
**Stand:** 2026-03-30

# Goal
Die oeffentlichen Community-Standards im Repository auf eine saubere
Mindestbaseline bringen und als ersten In-Repo-Block der `1.4.0-dev`-Linie
liefern.

# Motivation
GitHub Community Standards zeigt derzeit offene Punkte (Code of Conduct,
Security Policy, Issue Templates, Pull Request Template). Diese Elemente
verbessern Transparenz und Zusammenarbeit im Public-Betrieb.

# Scope
In Scope:
- `CODE_OF_CONDUCT.md` als klarer Verhaltensrahmen.
- `SECURITY.md` mit Responsible-Disclosure-Prozess.
- standardisierte Issue-Templates (Bug/Feature).
- PR-Template mit `Summary`/`Validation`-Mindeststruktur.

Out of Scope:
- Aufweichung des 1.1.0 Scope-Freeze fuer `BL-0014`/`BL-0015`.
- Pflicht als Release-Blocker fuer Gate 3 oder Gate 4.
- Umbau der fachlichen Produkt-Roadmap.

# Risks
- Zu fruehe Ueberformalisierung fuer Solo-Maintenance.
- Pflegeaufwand bei Templates ohne klaren Mehrwert.

# Output
Eine gelieferte Public-Repository-Baseline mit `CODE_OF_CONDUCT.md`,
`SECURITY.md`, standardisierten Bug-/Feature-Issue-Templates und
PR-Mindeststruktur.

# Derived Tasks
- Direkte Umsetzung in Sprint 30; keine separaten `TSK-xxxx` angelegt.
