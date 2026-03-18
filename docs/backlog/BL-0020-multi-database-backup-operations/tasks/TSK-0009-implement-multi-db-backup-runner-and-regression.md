---
id: TSK-0009
title: Implement multi-db backup runner and regression checks
status: done
priority: P1
type: task
tags: [backup, operations, tests, qa]
created: 2026-03-18
updated: 2026-03-18
parent: BL-0020
related:
  - BL-0020
  - TSK-0008
  - POL-003
---
**Stand:** 2026-03-18

# Task
Liefere den operativen Mehr-DB-Backup-Runner auf Basis des festgelegten
Contracts und sichere den Pfad per Regression/Smoke ab.

# Notes
- Erfolgs- und Fehlerpfade muessen gleichwertig abgedeckt sein.
- Teilfehler in Sammellaeufen duerfen nicht still uebergangen werden.
- Doku-Sync fuer Bedienung und Restore-Grenzen ist Teil der Aufgabe.

# Done When
- [x] Single-/All-Backup-Lauf ist technisch umgesetzt.
- [x] Regression deckt Fehlerszenarien (fehlende DB/Rechte/Teilfehler) ab.
- [x] Verify-relevante Tests laufen lokal gruen und Doku ist aktualisiert.
