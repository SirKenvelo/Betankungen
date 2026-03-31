---
id: TSK-0025
title: Minimales Charging-Event-Modell und Storage-Grenzen evaluieren
status: todo
priority: P2
type: task
tags: [module, ev, discovery, schema]
created: 2026-03-31
updated: 2026-03-31
parent: BL-0030
related:
  - ADR-0007
  - ADR-0008
---
**Stand:** 2026-03-31

# Task
Das minimale fachliche Modell fuer EV-Ladevorgaenge evaluieren und die
Storage-Grenzen zwischen Core und moeglichem EV-Modul klar beschreiben.

# Notes
- Discovery soll eine kleine, realistische erste Event-Struktur fuer
  Ladevorgaenge skizzieren (z. B. kWh, Kosten, Datum, Standortbezug).
- Es soll explizit geklaert werden, warum dieser Block nicht als generisches
  Core-`energy_events`-Modell startet.
- Die Entscheidung muss den Core gegen vorschnelle Schema-Aufweichung schuetzen
  und gleichzeitig einen spaeteren Modulpfad praktisch nutzbar machen.

# Done When
- [ ] Minimales Charging-Event-Modell ist beschrieben
- [ ] Storage-/Boundary-Entscheidung ist nachvollziehbar dokumentiert
- [ ] Doku aktualisiert
