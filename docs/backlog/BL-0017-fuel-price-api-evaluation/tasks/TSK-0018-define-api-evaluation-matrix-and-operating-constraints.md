---
id: TSK-0018
title: Define API evaluation matrix and operating constraints for 1.3.0
status: done
priority: P1
type: task
tags: [api, research, contract, operations]
created: 2026-03-24
updated: 2026-03-24
parent: BL-0017
related:
  - BL-0017
  - BL-0018
  - POL-003
  - TSK-0019
---
**Stand:** 2026-03-24

# Task
Definiere eine belastbare Evaluationsmatrix fuer kostenlose
Tankstellenpreis-APIs inklusive Betriebsgrenzen fuer ein Raspberry-Pi-/
Home-Setup.

# Notes
- Lizenz, Rate Limits, Stabilitaet, Regionabdeckung und Betriebsmodus muessen
  vergleichbar dokumentiert sein.
- Die Bewertung muss explizit festhalten, welche API fuer `1.3.0` tragfaehig
  ist und welche Ausschlussgruende fuer Alternativen bestehen.
- Audit-relevant sind vor allem Risiken bei externer Abhaengigkeit und
  Betriebsgrenzen; ein Delta-/Risiko-Audit ist bei belastbarer Entscheidung zu
  pruefen.
- Ergebnis ist in `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md` verankert.

# Done When
- [x] Vergleichsmatrix fuer Kandidaten ist dokumentiert.
- [x] Betriebsgrenzen und Ausschlusskriterien sind nachvollziehbar beschrieben.
- [x] Entscheidungsvorlage fuer die v1-Quelle ist vorbereitet.
