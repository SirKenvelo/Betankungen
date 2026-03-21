---
id: BL-0022
title: User-Flow- und QA-Hardening aus Nutzertests
status: in_progress
priority: P1
type: improvement
tags: [qa, tests, ux, validation, 'lane:planned']
created: 2026-03-20
updated: 2026-03-21
related:
  - ISS-0002
  - ISS-0003
  - ISS-0004
  - ISS-0005
  - ISS-0006
---
**Stand:** 2026-03-21

# Goal
Reproduzierbare Nutzertest-Funde in eine belastbare QA- und Hardening-Spur
ueberfuehren: mit zentraler Testmatrix, klaren Tracker-Artefakten und
umsetzbaren Folgetasks.

# Motivation
Die vorhandenen Domain-/Smoke-/Regression-Suiten sichern bereits viele
Contracts gut ab. Die Nutzertests vom 2026-03-20 zeigen aber mehrere Luecken,
die vor allem in realen Erstnutzer-, Break- und Dialogpfaden sichtbar werden:

- inkonsistenter `--seed`/`--demo`-Flow
- EOF-/Leerzustandsprobleme in interaktiven Dialogen
- fehlende Cross-Field-Validierung bei Fuelups
- zu schwache Plausibilitaetspruefung bei Stations-Stammdaten
- schwache Erststart- und Mehrfahrzeug-Fuehrung fuer neue CLI-Nutzer

# Scope
In Scope:
- kanonische Teststrategie und Coverage-Matrix fuer Betankungen
- Ueberfuehrung reproduzierbarer Nutzertest-Funde in `ISS`-Artefakte
- gezielte Hardening-Arbeit fuer User-Flow-, Robustheits- und Validierungsluecken
- klare Onboarding- und Mehrfahrzeug-Hinweise fuer Erstnutzer und Folge-CLI-Pfade
- Ausbau von User-Flow-/Break-Test-Abdeckung mit deterministischen Fixtures

Out of Scope:
- groesserer CLI-Umbau ohne direkte Ableitung aus den konkreten Findings
- generische Komplett-Neuschreibung der Interaktionsschicht
- Performance-Arbeit ohne funktionalen Qualitaetsbezug

# Risks
- Scope-Drift in Richtung "volle Testplattform", ohne die akuten Luecken zuerst
  zu schliessen
- doppelte Pflege zwischen Strategie-Doku und `tests/README.md`
- UX-Hardening ohne klare Exit-Code-/Contract-Definitionen

# Output
Ein priorisierter Hardening-Block, der die aktuellen Nutzer- und
Robustheitsbefunde sichtbar macht, in konkrete Arbeitsschritte zerlegt und als
Grundlage fuer die naechste Qualitaetsphase dient, inklusive sichtbarer
Onboarding- und Mehrfahrzeug-Fuehrung.

# Derived Tasks
- `TSK-0012` - User-Flow- und Break-Test-Abdeckung aus der Matrix ableiten. (todo)
- `TSK-0013` - Seed-/Demo-Flow sowie EOF-/Abbruchverhalten haerten. (done)
- `TSK-0014` - Fuelup- und Stations-Validierung auf Cross-Field-/Plausibilitaetsniveau anheben. (done)
- `TSK-0015` - Erststart- und Mehrfahrzeug-Fuehrung in Help, Hints und Leerzustaenden schaerfen. (todo)
