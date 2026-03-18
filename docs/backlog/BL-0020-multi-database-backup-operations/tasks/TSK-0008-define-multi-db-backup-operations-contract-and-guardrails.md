---
id: TSK-0008
title: Define multi-db backup operations contract and guardrails
status: done
priority: P1
type: task
tags: [backup, operations, contract, safety]
created: 2026-03-18
updated: 2026-03-18
parent: BL-0020
related:
  - BL-0020
  - POL-002
  - POL-003
---
**Stand:** 2026-03-18

# Task
Definiere den operativen Contract fuer Mehr-DB-Backups (single/all) inklusive
Dry-Run-Verhalten, Integritaetsnachweisen und klaren Fehler-/Exit-Regeln.

# Notes
- Fokus auf reproduzierbare und sichere Backup-Laeufe ohne Scope-Drift.
- Contract muss die Trennung zu Release-/Snapshot-Mechaniken explizit halten.
- Privacy-/Retention-Regeln aus `POL-003` sind verbindlich.

# Done When
- [x] Contract fuer single/all-Backup inkl. Dry-Run ist dokumentiert.
- [x] Integritaets-/Index-Metadaten pro Lauf sind eindeutig spezifiziert.
- [x] Fehlerpfade und Exit-Codes sind als testbare Guardrails beschrieben.
