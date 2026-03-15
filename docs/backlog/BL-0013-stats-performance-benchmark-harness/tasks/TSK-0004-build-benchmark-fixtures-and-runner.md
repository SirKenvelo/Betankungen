---
id: TSK-0004
title: Build benchmark fixtures and optional runner for stats paths
status: done
priority: P3
type: task
tags: [performance, benchmark, stats, qa]
created: 2026-03-15
updated: 2026-03-15
parent: BL-0013
related:
  - BL-0013
  - BL-010
  - POL-002
---
**Stand:** 2026-03-15

# Task
Erzeuge einen reproduzierbaren Benchmark-Workflow (Fixtures + Runner +
Messprotokoll) fuer zentrale Stats-Pfade, optional ausfuehrbar ausserhalb der
Pflicht-Gates.

# Notes
- Kein dauerhaftes Pflicht-Gate in `make verify`.
- Fokus auf Trigger-Faelle mit messbarem Performance-Schmerz.
- Messpunkte und Laufparameter dokumentieren.

# Done When
- [x] Benchmark-Fixtures sind versioniert und reproduzierbar.
- [x] Runner liefert stabile Messausgaben fuer definierte Stats-Modi.
- [x] Baseline und Ausfuehrungshinweise sind dokumentiert.
