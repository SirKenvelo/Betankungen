---
id: TSK-0012
title: Codify user-flow and break-test coverage from the test matrix
status: todo
priority: P1
type: task
tags: [qa, tests, user-flow, regression]
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
- [ ] Mindestens die priorisierten User-Flow-/Break-Pfade aus der Matrix sind
      als automatisierbare Faelle eingeordnet.
- [ ] Neue oder erweiterte Tests laufen reproduzierbar in isolierter Umgebung.
- [ ] Testdoku und Matrix verweisen konsistent aufeinander.
