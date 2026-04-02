---
id: TSK-0027
title: Car-Kontext und Receipt-Link-Timing im Fuelup-Add-Flow sichtbar machen
status: todo
priority: P2
type: task
tags: [fuelups, cars, receipts, ux]
created: 2026-04-02
updated: 2026-04-02
parent: BL-0031
related:
  - ISS-0009
  - BL-0021
---
**Stand:** 2026-04-02

# Task
Den Fuelup-Add-Flow so fuehren, dass Nutzer den aktiven Fahrzeugkontext und
den Vorab-Charakter von `--receipt-link` sehen, bevor ein neuer Fuelup
gespeichert wird.

# Notes
- Kein neuer Fuelup-Edit-Path.
- Kein zweiter Resolver-Modus; vorhandene 0/1/>1-Car-Regeln bleiben bestehen.
- Voraussichtlich betroffen: `units/u_fuelups.pas`, `units/u_car_context.pas`,
  `units/u_cli_help.pas` und die Benutzerdoku.

# Done When
- [ ] Der aktive Car-Kontext ist im Add-Flow sichtbar genug.
- [ ] `--receipt-link` wird als Vorab-Flag klar kommuniziert.
- [ ] Help/Doku und Regressionen decken den Guidance-Contract ab.
