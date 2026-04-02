---
id: TSK-0026
title: Fuelup-Kilometerstands-Wording und Guidance auf Gesamt-Odometer ausrichten
status: todo
priority: P2
type: task
tags: [fuelups, odometer, ux, docs]
created: 2026-04-02
updated: 2026-04-02
parent: BL-0031
related:
  - ISS-0008
  - ADR-0014
---
**Stand:** 2026-04-02

# Task
Den Fuelup-Add-Flow, die Help-Texte und die Benutzerdoku so nachziehen, dass
der abgefragte Kilometerstand explizit als aktueller Gesamt-Odometer des
Fahrzeugs verstanden wird.

# Notes
- Kein Trip-/Delta-Input in diesem Task.
- Keine Aenderung an Persistenz oder Odometer-Policies.
- Betroffene Stellen liegen voraussichtlich in `units/u_fuelups.pas`,
  `units/u_cli_help.pas` und `docs/BENUTZERHANDBUCH.md`.

# Done When
- [ ] Prompting/Guidance benennen den Gesamt-Odometer explizit.
- [ ] Help und Doku verwenden dieselbe Terminologie.
- [ ] Regressionen oder gezielte Dialog-Checks sind nachgezogen.
