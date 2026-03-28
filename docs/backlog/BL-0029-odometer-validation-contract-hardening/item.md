---
id: BL-0029
title: Odometer Validation Contract Hardening
status: proposed
priority: P1
type: improvement
tags: [validation, cli, quality, 'lane:planned']
created: 2026-03-28
updated: 2026-03-28
related:
  - ISS-0001
  - TSK-0001
  - POL-001
---
**Stand:** 2026-03-28

# Goal
Die Validierung negativer Kilometerstaende (`odometer_km`) soll in allen
relevanten CLI-Pfaden denselben klaren Hard-Error-Contract liefern.

# Motivation
Der aktuelle Tracker-Stand hatte die Odometer-Validierung fachfremd an den
Scaffolder-Backlog `BL-0011` gekoppelt. Diese Arbeit braucht einen eigenen,
fachlich passenden Block.

# Scope
In Scope:
- Harmonisierung der Validierungslogik fuer negative Odometer-Eingaben.
- Einheitliche, handlungsorientierte Fehlermeldung im CLI-Output.
- Regression-Absicherung fuer interaktive und nicht-interaktive Pfade.

Out of Scope:
- Repo-Scaffolder-/Bootstrap-Themen (`BL-0011`).
- Allgemeine UX- oder Stats-Erweiterungen ohne Bezug zu Odometer-Validierung.

# Risks
- Unterschiedliche Codepfade bleiben unbemerkt inkonsistent.
- Fehlermeldungen driften ohne zentrale Contract-Regel erneut auseinander.
- Regressionen werden bei kuenftigen Parser-/Dialogaenderungen zu spaet erkannt.

# Output
Ein klar abgegrenzter Hardening-Backlog fuer Odometer-Validierung mit
nachvollziehbarer Task-/Issue-Verkettung und testbarer Done-Definition.

# Derived Tasks
- `TSK-0001` - Hard-Error-Contract fuer negative Odometer-Werte vereinheitlichen. (todo)
