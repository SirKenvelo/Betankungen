---
id: TSK-0013
title: Fix seed-demo and interactive abort contracts
status: todo
priority: P0
type: task
tags: [cli, demo, ux, eof, robustness]
created: 2026-03-20
updated: 2026-03-20
parent: BL-0022
related:
  - BL-0022
  - ISS-0002
  - ISS-0003
---
**Stand:** 2026-03-20

# Task
Behebe die reproduzierbaren Anschluss- und Abbruchprobleme in den interaktiven
Flows: konsistenter `--seed`/`--demo`-Pfad und kontrolliertes Verhalten bei EOF
oder leerer Ausgangslage.

# Notes
- `--seed` darf keine Anschlusswege empfehlen, die direkt danach nicht
  funktionieren.
- Interaktive Prompt-Schleifen muessen EOF und "keine Datenbasis vorhanden"
  explizit behandeln.
- Benutzerabbruch, EOF und echter Hard Error sollen sprachlich und technisch
  sauber getrennt werden.

# Done When
- [ ] `--seed` und `--demo` haben einen konsistenten, dokumentierten Anschlussfluss.
- [ ] EOF-/Nicht-Interaktiv-Faelle beenden sich kontrolliert statt zu loopen.
- [ ] Regression oder Smoke decken die Fehlerpfade reproduzierbar ab.
