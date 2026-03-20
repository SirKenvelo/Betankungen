---
id: TSK-0014
title: Tighten fuelup and station validation
status: todo
priority: P1
type: task
tags: [validation, fuelups, stations, data-quality]
created: 2026-03-20
updated: 2026-03-20
parent: BL-0022
related:
  - BL-0022
  - ISS-0004
  - ISS-0005
---
**Stand:** 2026-03-20

# Task
Haerte die fachliche Cross-Field-Validierung bei Fuelups und die
Plausibilitaetspruefung fuer Stations-Stammdaten.

# Notes
- Fuelups brauchen eine Abweichungsregel fuer Gesamtpreis vs. Liter x
  Preis/Liter inklusive definierter Rundungstoleranz.
- Stationsdaten sollen offensichtliche Feldverschiebungen und unplausible Werte
  frueh blockieren oder zumindest gezielt rueckfragen.
- Ziel ist bessere Datenqualitaet, nicht bloss strengere Fehlermeldungen.

# Done When
- [ ] Widerspruechliche Fuelup-Werte werden klar abgefangen.
- [ ] Offensichtlich unplausible Stationswerte werden nicht mehr still gespeichert.
- [ ] Tests decken positive und negative Faelle reproduzierbar ab.
