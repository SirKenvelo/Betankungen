---
id: TSK-0029
title: Referenzscreen fuer `--list fuelups --detail` mit kleiner View-/Painter-Basis liefern
status: done
priority: P2
type: task
tags: [tui, ui, terminal, views, fuelups, 'lane:planned']
created: 2026-04-08
updated: 2026-04-08
parent: BL-0033
related:
  - ADR-0015
---
**Stand:** 2026-04-08

# Task
Den ersten read-only TUI-Referenzscreen fuer `Betankungen --list fuelups
--detail` liefern, ohne CLI-Semantik, Persistenzregeln oder andere Screens in
einem Big-Bang mitzuziehen.

# Notes
- Genau ein Referenzscreen: `Betankungen --list fuelups --detail`.
- Keine Form-Systeme, keine Add-/Edit-Flows und keine neue Fachlogik.
- Bestehender Car-Scope, Receipt-Link-Detailausgabe und append-only-Contract
  bleiben fachlich unveraendert.
- Eine kleine wiederverwendbare Terminal-/Painter-/View-Basis ist erlaubt,
  aber nur soweit sie fuer diesen einzelnen Screen wirklich gebraucht wird.
- Wahrscheinliche Anker liegen in `units/u_fuelups.pas`, `units/u_fmt.pas`
  und neuen kleinen View-/Renderer-Units.

# Done When
- [x] `Betankungen --list fuelups --detail` nutzt den neuen
  Referenzscreen-Pfad und bleibt read-only.
- [x] Die bestehende Detailinformation bleibt sichtbar und semantisch
  unveraendert.
- [x] Eine kleine wiederverwendbare Terminal-/Painter-/View-Basis ist fuer
  diesen Screen vorhanden, ohne schon ein Form-System einzufuehren.
- [x] Help oder Doku sind nachgezogen, falls sich der sichtbare
  Darstellungs-Contract merklich veraendert.
- [x] Gezielte Checks und Repo-Standardvalidierung laufen gruen.
