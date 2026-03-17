---
id: TSK-0007
title: Define 1.1.0 preflight blueprint and doc-gates
status: done
priority: P1
type: task
tags: [release, preflight, docs, qa]
created: 2026-03-16
updated: 2026-03-17
parent: BL-0015
related:
  - BL-0015
  - POL-002
  - POL-003
---
**Stand:** 2026-03-17

# Task
Lege einen klaren 1.1.0-Preflight-Blueprint fest (Skript + Checkliste +
Doku-Gates), der Scope-Freeze, Contract-Stabilitaet und Governance-Konsistenz
validiert.

# Notes
- Muss mit bestehendem `make verify`-Flow kompatibel bleiben.
- Fokus auf reproduzierbare Freigabenachweise statt Add-on-Komplexitaet.
- Guardrails muessen explizit falsche Release-Staende erkennen.

# Done When
- [x] 1.1.0-Preflight-Checkpunkte sind in Skript und Doku deckungsgleich.
- [x] Doku-Gates pruefen Scope-/Tracker-/Contract-Konsistenz explizit.
- [x] Dry-Run-Pfad fuer Release-/Backup-Werkzeuge ist dokumentiert.
