---
id: TSK-0024
title: EV-Modul-Scope und Contract-Rahmen definieren
status: todo
priority: P2
type: task
tags: [module, ev, discovery]
created: 2026-03-31
updated: 2026-03-31
parent: BL-0030
related:
  - ADR-0005
  - ADR-0007
  - ADR-0008
---
**Stand:** 2026-03-31

# Task
Den minimalen Scope fuer ein moegliches Companion-Modul `betankungen-ev`
festziehen und den notwendigen Contract-Rahmen gegenueber dem Core
dokumentieren.

# Notes
- Fokus auf einen kleinen, implementierbaren Discovery-Rahmen statt auf einen
  kompletten EV-Funktionskatalog.
- Zu klaeren sind insbesondere:
  - minimaler CLI-Zuschnitt
  - erwartete Modul-Metadaten
  - Abgrenzung zwischen Core-Daten und Modul-Daten
  - Nicht-Ziele fuer den ersten EV-Block
- `docs/MODULES_ARCHITECTURE.md` bleibt die technische Leitplanke.

# Done When
- [ ] Minimaler EV-Modul-Scope ist beschrieben
- [ ] Contract- und Boundary-Leitplanken sind dokumentiert
- [ ] Doku aktualisiert
