---
id: TSK-0015
title: Improve first-run and multi-car guidance
status: done
priority: P2
type: task
tags: [cli, onboarding, cars, ux]
created: 2026-03-20
updated: 2026-03-22
parent: BL-0022
related:
  - BL-0022
  - ISS-0006
---
**Stand:** 2026-03-22

# Task
Schaerfe die sichtbare CLI-Fuehrung fuer Erststart, Default-Fahrzeug und den
Uebergang von 1 auf mehrere Fahrzeuge, damit Nutzer den naechsten Schritt nicht
erst aus Fehlern ableiten muessen.

# Notes
- Der First-Run-Pfad soll klar benennen, was angelegt wurde und welcher
  Folgekommando-Pfad sinnvoll ist.
- Das Verhalten rund um `Hauptauto` muss bewusst erklaert oder ueberarbeitet
  werden.
- Mehrfahrzeug-Fehlertexte und Hilfetexte sollen `--car-id` konsistent und
  frueh genug nennen.

# Done When
- [x] Erststart kommuniziert den angelegten Zustand sichtbar und knapp.
- [x] Default-Car- und Multi-Car-Regeln sind in CLI-Hints/Help konsistent.
- [x] Tests oder reproduzierbare User-Flow-Faelle decken die Guidance-Pfade ab.
