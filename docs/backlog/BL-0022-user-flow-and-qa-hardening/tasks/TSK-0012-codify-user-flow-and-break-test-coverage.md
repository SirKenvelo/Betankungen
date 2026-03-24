---
id: TSK-0012
title: Codify user-flow and break-test coverage from the test matrix
status: done
priority: P1
type: task
tags: [qa, tests, user-flow, regression]
created: 2026-03-20
updated: 2026-03-24
parent: BL-0022
related:
  - BL-0022
  - ISS-0002
  - ISS-0003
---
**Stand:** 2026-03-24

# Task
Leite aus `docs/TEST_MATRIX.md` die ersten reproduzierbaren User-Flow-,
Leerzustands- und Break-Tests ab und verankere sie in den vorhandenen
Smoke-/Regression-Pfaden.

# Notes
- Keine zweite Runner-Dokumentation aufbauen; `tests/README.md` bleibt die
  operative Suite-Uebersicht.
- Bevorzugt mit isolierten HOME/XDG-Umgebungen und deterministischen Fixtures
  arbeiten.
- Erwartete Exit-Codes, Fehlermeldungen und Leerzustandsausgaben muessen
  explizit dokumentiert werden.

# Done When
- [x] Mindestens die priorisierten User-Flow-/Break-Pfade aus der Matrix sind
      als automatisierbare Faelle eingeordnet.
- [x] Neue oder erweiterte Tests laufen reproduzierbar in isolierter Umgebung.
- [x] Testdoku und Matrix verweisen konsistent aufeinander.

# Umsetzung
- Neuer Regression-Runner:
  `tests/regression/run_user_flow_break_matrix_check.sh`
- Verify-Verdrahtung:
  - Make-Target `user-flow-break-check`
  - Aufnahme in `make verify`
- Abgedeckte Matrix-Schwerpunkte (automatisiert):
  - `INIT-001` bis `INIT-006`
  - `DEMO-001` bis `DEMO-005`
  - `CLI-001`
  - EOF-/Leerzustandsabbruch fuer `--add fuelups`
  - Multi-Car-Guidance-Hints (ISS-0006)
