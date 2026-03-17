---
id: BL-0015
title: Release- und Verify-Hardening fuer die 1.1.0-Linie
status: done
priority: P1
type: improvement
tags: [release, verify, governance, qa]
created: 2026-03-16
updated: 2026-03-17
related:
  - POL-002
  - POL-003
  - BL-0014
---
**Stand:** 2026-03-17

# Goal
Den 1.1.0-Releasepfad fruehzeitig haerten, damit Scope-Freeze, Verify-Gates
und Preflight-Nachweise konsistent und reproduzierbar bleiben.

# Motivation
Nach 1.0.0 soll die naechste Linie nicht nur feature-seitig, sondern auch im
Release-Handwerk planbar und regressionssicher laufen.

# Scope
In Scope:
- Preflight-Grundgeruest fuer 1.1.0 mit klaren Gate-Pruefpunkten.
- Doku-Gates fuer Scope-/Tracker-/Contract-Konsistenz.
- Nachvollziehbare Verify-/Preflight-Referenzierung in Release-Doku.

Out of Scope:
- Vorziehen des finalen 1.1.0-Release-Schritts.
- Aufweichen der PR-only-Governance auf `main`.
- Neue Laufzeitprofile oder versteckte Betriebsmodi.

# Risks
- Ueberfrachteter Preflight mit zu vielen optionalen Nebenchecks.
- Doppelpflege zwischen Skriptlogik und Doku-Checklisten.

# Output
Ein stabiler Hardening-Block fuer die 1.1.0-Linie, der Release-Reife
fruehzeitig absichert, ohne den Feature-Umfang auszuweiten.

# Derived Tasks
- `TSK-0007` - 1.1.0-Preflight-Blueprint und Doku-Gates definieren. (done)
