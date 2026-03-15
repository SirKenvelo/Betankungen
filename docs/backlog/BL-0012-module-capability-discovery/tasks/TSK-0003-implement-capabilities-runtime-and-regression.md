---
id: TSK-0003
title: Implement capabilities in module-info plus regression coverage
status: todo
priority: P1
type: task
tags: [module, runtime, tests, smoke]
created: 2026-03-15
updated: 2026-03-15
parent: BL-0012
related:
  - BL-0012
  - TSK-0002
  - POL-002
---
**Stand:** 2026-03-15

# Task
Implementiere die `capabilities`-Ausgabe in den betroffenen Modul-Binaries und
haerte die Guardrails ueber Smoke-/Regressionstests.

# Notes
- Umsetzung additiv halten: bestehende `--module-info`-Felder bleiben stabil.
- Tests sollen Presence/Schema und Fehlerszenarien abdecken.
- Ergebnisse in `make verify` reproduzierbar pruefbar machen.

# Done When
- [ ] Runtime gibt `capabilities` stabil und maschinenlesbar aus.
- [ ] Smoke-/Regressionstests fuer den neuen Contract sind gruen.
- [ ] Changelog + Modul-/Export-Doku sind synchronisiert.
