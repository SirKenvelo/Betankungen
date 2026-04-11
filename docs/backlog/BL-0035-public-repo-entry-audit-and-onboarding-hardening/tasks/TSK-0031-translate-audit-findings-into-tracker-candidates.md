---
id: TSK-0031
title: Audit-Funde in Tracker-Kandidaten und Quick Wins uebersetzen
status: todo
priority: P2
type: task
tags: [github, audit, public-readiness, tracker, docs]
created: 2026-04-11
updated: 2026-04-11
parent: BL-0035
related:
  - ADR-0012
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

# Done When
- [ ] Audit-Funde sind in Quick Wins, `ISS`, `BL` und eventuelle
  `ADR`-Kandidaten gruppiert.
- [ ] Tracker-Kandidaten sind mit klaren Titeln und Prioritaet vorgeschnitten.
- [ ] Es ist explizit entschieden, ob ueberhaupt ein neuer `ADR` noetig ist.
