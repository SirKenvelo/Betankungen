---
id: BL-0031
title: Fuelup Input Semantics and Guidance Hardening
status: approved
priority: P2
type: improvement
tags: [fuelups, ux, semantics, guidance, 'lane:planned']
created: 2026-04-02
updated: 2026-04-02
related:
  - ADR-0014
  - ISS-0008
  - ISS-0009
  - BL-0021
  - BL-0029
---
**Stand:** 2026-04-02

# Goal
Die Fuelup-Eingabe fuer neue und gelegentliche Nutzer semantisch klarer und
dialogseitig fuehrender machen, ohne die bestehende Core-Persistenz oder
Odometer-Policy zu verbiegen.

# Motivation
Reale Nutzung des Add-Flows hat drei zusammenhaengende Schwachstellen
sichtbar gemacht:

- `Kilometerstand (km)` ist als Prompt zu offen und verschweigt die
  kanonische Gesamt-Odometer-Semantik
- die aktuelle Car-Zuordnung ist im Add-Flow nicht sichtbar genug
- der Vorab-Contract fuer `--receipt-link` ist im interaktiven Lauf zu leicht
  zu uebersehen, obwohl Fuelups append-only sind

Die technische Basis ist bereits korrekt. Was fehlt, ist eine bewusst
geschnittene Guidance-/Semantik-Haertung fuer die naechste Core-UX-Stufe.

# Scope
In Scope:
- Guidance fuer den kanonischen Fuelup-Kilometerstandsbegriff auf
  Gesamt-Odometer-Basis
- sichtbare Car-Kontext-Fuehrung im Add-Flow und in zugehoeriger Help/Doku
- klare Vorab-Hinweise fuer `--receipt-link` im Zusammenhang mit append-only
  Fuelups
- saubere Verknuepfung zwischen Issue-, ADR-, Backlog- und Folge-Task-Ebene

Out of Scope:
- Runtime-Implementierung in diesem Rahmungsblock
- neuer Trip-/Delta-Input als alternative Erfassungslogik
- neue Fuelup-Editierbarkeit oder nachtraeglicher Receipt-Link-Write-Path
- Vermischung mit EV-Discovery, Household Drivers oder groesseren CLI-Umbauten

# Risks
- Guidance-Arbeit driftet in einen groesseren UI-Umbau statt bei klaren
  Dialog- und Hilfetext-Grenzen zu bleiben.
- Die Kilometerstandsfrage wird fachlich erneut aufgeweicht, obwohl
  `ADR-0014` den kanonischen Gesamt-Odometer festzieht.
- Receipt-Link- und Car-Resolver-Themen werden als Architekturproblem
  missverstanden, obwohl es primaer UX-/Dialogfragen sind.

# Output
Ein umsetzungsreifer Hardening-Block fuer einen spaeteren Fuelup-UX-Sprint:
mit akzeptierter Semantik-Entscheidung (`ADR-0014`), zwei konkreten offenen
Problemfaellen (`ISS-0008`, `ISS-0009`) und klar abgegrenzten Folgeaufgaben.

# Derived Tasks
- `TSK-0026` - Fuelup-Kilometerstands-Wording und Guidance auf den
  Gesamt-Odometer ausrichten. (todo)
- `TSK-0027` - Car-Kontext und Receipt-Link-Timing im Fuelup-Add-Flow
  sichtbar machen. (todo)
