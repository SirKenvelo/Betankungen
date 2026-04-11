---
id: TSK-0031
title: Audit-Funde in Tracker-Kandidaten und Quick Wins uebersetzen
status: done
priority: P2
type: task
tags: [github, audit, public-readiness, tracker, docs]
created: 2026-04-11
updated: 2026-04-11
parent: BL-0035
related:
  - ADR-0012
  - BL-0036
  - ISS-0011
  - ISS-0012
---
**Stand:** 2026-04-11

# Task
Die spaeteren Audit-Funde so verdichten, dass konkrete Friktionspunkte sauber
von groesseren Verbesserungsbloecken und echten Entscheidungsfragen getrennt
werden.

# Notes
- Kleine textliche oder strukturelle Nachschaerfungen sollen als Quick Wins
  gebuendelt werden, statt unnoetige Tracker-Artefakte zu erzeugen.
- `ISS` ist fuer reproduzierbare Reibung im oeffentlichen Einstieg gedacht.
- `BL` ist fuer gebuendelte Hardening-/Verbesserungsbloecke gedacht.
- Ein neuer `ADR`-Kandidat ist nur dann sinnvoll, wenn Rollen, Grenzen oder
  dauerhafte Entry-Layer-Regeln neu entschieden werden muessen.

# Result
- Der externe Audit vom 2026-04-11 wurde in konkrete Repo-Folgen
  uebersetzt.
- `ISS-0011` schneidet den README-/Quick-Start-/Entry-Flow als direkte
  Erstbesucher-Reibung.
- `ISS-0012` schneidet die Inkonsistenz zwischen oeffentlichem Release-Signal
  und sichtbarer GitHub-Release-Oberflaeche.
- `BL-0036` buendelt das spaetere Contributor-Onboarding- und
  English-Entry-Layer-Hardening.
- Kleine Copy-/Signal-Funde bleiben bewusst Quick Wins; ein neuer `ADR` ist
  aktuell nicht erforderlich.

# Done When
- [x] Audit-Funde sind in Quick Wins, `ISS`, `BL` und eventuelle
  `ADR`-Kandidaten gruppiert.
- [x] Tracker-Kandidaten sind mit klaren Titeln und Prioritaet vorgeschnitten.
- [x] Es ist explizit entschieden, ob ueberhaupt ein neuer `ADR` noetig ist.
