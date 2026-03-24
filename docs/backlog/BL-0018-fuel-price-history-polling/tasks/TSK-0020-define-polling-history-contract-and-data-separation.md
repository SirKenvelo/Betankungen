---
id: TSK-0020
title: Define polling history contract and data separation for 1.3.0
status: done
priority: P1
type: task
tags: [polling, history, contract, storage]
created: 2026-03-24
updated: 2026-03-24
parent: BL-0018
related:
  - BL-0018
  - BL-0017
  - POL-002
  - POL-003
---
**Stand:** 2026-03-24

# Task
Definiere den Contract fuer Polling-/Historien-Daten inklusive Datenpfad,
Trennung von Core-Datenbanken, Rohdatenformat und minimaler Persistenzstruktur.

# Notes
- Die Trennung zur produktiven Tankdatenbank ist verbindlich.
- Speicherformat, Retention-Ansatz und Integrationsgrenzen muessen vor
  Implementierung dokumentiert sein.
- Contract-/Privacy-Regeln muessen vor der technischen Umsetzung stabil sein.

# Done When
- [x] Datenpfad- und Trennregeln sind dokumentiert.
- [x] Rohdaten-/Historienformat ist ausreichend konkret beschrieben.
- [x] Integrationsgrenzen zum Core sind explizit festgehalten.
