---
id: BL-0016
title: Community-Standards-Baseline fuer das Public Repository
status: proposed
priority: P3
type: improvement
tags: [community, governance, docs, templates]
created: 2026-03-17
updated: 2026-03-17
related:
  - BL-012
  - POL-001
---
**Stand:** 2026-03-17

# Goal
Die oeffentlichen Community-Standards im Repository auf eine saubere
Mindestbaseline bringen, ohne den laufenden 1.1.0-Feature-/Hardening-Scope zu
blockieren.

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
Ein priorisierter, aber non-blocking Follow-up-Block fuer Community-Hygiene im
Public-Repository, der bei freier Kapazitaet umgesetzt werden kann.

# Derived Tasks
- Werden bei Aktivierung des Backlog-Items als `TSK-xxxx` angelegt.
