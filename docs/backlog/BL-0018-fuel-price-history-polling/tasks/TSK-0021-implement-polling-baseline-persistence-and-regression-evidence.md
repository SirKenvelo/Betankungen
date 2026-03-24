---
id: TSK-0021
title: Implement polling baseline persistence and regression evidence for 1.3.0
status: done
priority: P1
type: task
tags: [polling, history, implementation, qa]
created: 2026-03-24
updated: 2026-03-24
parent: BL-0018
related:
  - BL-0018
  - TSK-0020
  - POL-002
  - POL-003
---
**Stand:** 2026-03-24

# Task
Liefere die technische Polling-Basis fuer externe Preisdaten inklusive
Persistenzpfad, minimalem Runner und Regression-/Audit-Nachweisen.

# Notes
- Erfolgs- und Fehlerpfade muessen reproduzierbar pruefbar sein.
- Die Umsetzung darf keine produktive Core-Datenbank still veraendern.
- Delta-/Risiko-Audit ist fuer Integrations- und Datenpfade mitzudenken.

# Done When
- [x] Polling-Basis ist in einem klar getrennten Pfad umgesetzt.
- [x] Regressionen decken Kern- und Fehlerpfade ab.
- [x] Doku und Audit-/Nachweisbezug sind auf dem Runtime-Stand.
