---
id: BL-0036
title: Contributor Onboarding and English Entry-Layer Hardening
status: proposed
priority: P2
type: improvement
tags: [contributors, onboarding, english, public-readiness, docs, 'lane:planned']
created: 2026-04-11
updated: 2026-04-11
related:
  - BL-0016
  - BL-0027
  - BL-0035
---
**Stand:** 2026-04-11

# Goal
Den oeffentlichen Einstieg fuer potenzielle Mitwirkende und englischsprachige
Erstbesucher gezielt haerten, ohne die bestehende deutsche Tiefendoku
vollstaendig neu aufzubauen.

# Motivation
Der Public-Repo-Entry-Audit vom 2026-04-11 zeigt keine grundsaetzliche
Governance- oder Architekturkrise, aber eine wiederkehrende Friktion:

- Contributor-Onboarding ist fachlich vorhanden, aber noch zu dicht
- die englische Einstiegsschicht ist vorhanden, aber als Wegweiser noch nicht
  stark genug
- README, Wiki und `CONTRIBUTING.md` arbeiten noch nicht ruhig genug als
  gemeinsamer Entry-Layer fuer externe Leser

Ein gebuendelter Hardening-Block ist dafuer sinnvoller als viele kleine
unverbundene Doku-Mini-Tasks.

# Scope
In Scope:
- kompaktere Contributor-Einstiegsfuehrung in `CONTRIBUTING.md`
- klarere englische Entry-Layer-Signale in den oeffentlichen Einstiegsdokumenten
- geringere Friktion zwischen README, Wiki und Contributor-Guide fuer
  Erstbesucher und gelegentliche Mitwirkende

Out of Scope:
- vollstaendige Uebersetzung der gesamten Projektdokumentation
- neue Produkt- oder Runtime-Features
- ein Big-Bang-Umbau der kompletten Doku-Hierarchie
- neue ADR-Erzeugung ohne echten Entscheidungsbedarf

# Risks
- Eine zu breite Uebersetzungsbaustelle kann die eigentliche Entry-Layer-
  Verbesserung verlangsamen.
- Zu viele kleinteilige Doku-Massnahmen koennen den Fokus auf die wichtigsten
  Reibungspunkte verlieren.

# Output
Ein klarerer oeffentlicher Einstieg fuer externe Mitwirkende: kompaktere
Onboarding-Hinweise, sichtbarere englische Orientierung und ein ruhigerer
Uebergang zwischen README, Wiki und `CONTRIBUTING.md`.

# Derived Tasks
- Konkrete `TSK`-Slices werden nach Priorisierung der Audit-Follow-ups aus
  `ISS-0011`, `ISS-0012` und dem verbleibenden Entry-Layer-Bedarf geschnitten.
