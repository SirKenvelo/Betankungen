---
id: BL-0025
title: Tracker-Endzustand und Legacy-Grenzen fuer neue Arbeit
status: done
priority: P2
type: improvement
tags: [tracker, docs, governance, legacy, 'lane:planned']
created: 2026-03-30
updated: 2026-03-30
related:
  - ADR-0011
  - POL-001
---
**Stand:** 2026-03-30

# Goal
Kanonische und Legacy-Pfade fuer neue Tracker-Arbeit eindeutig festziehen,
ohne den historischen Bestand umzubenennen oder neu zu interpretieren.

# Motivation
Sprint 25 hat diesen Endzustand bereits geliefert, aber der zugehoerige
kanonische `BL-0025`-Eintrag fehlte bisher. Dieser Backfill macht den
abgeschlossenen Arbeitsblock referenzierbar, ohne ihn erneut zu oeffnen.

# Scope
In Scope:
- klare Regel fuer neue `BL`/`TSK`, `ISS`, `POL` und aktuelle `ADR`
- konsistente Abgrenzung zwischen kanonischen Pfaden und lesbarem Legacy-Bestand
- explizite Einordnung von `docs/tasks/` als historischer Ausnahmefall

Out of Scope:
- Big-Bang-Renames oder Pfadmigrationen
- nachtraegliche Umdeutung abgeschlossener Alt-Eintraege
- separate ADR-Pfadmigration nach `docs/adr/`

# Risks
- neue Maintainer legen Folgearbeit in veralteten Pfaden an
- Policy, Indizes und Statusdoku laufen wieder auseinander
- eine spaetere ADR-Pfadmigration wird versehentlich implizit vorweggenommen

# Output
Der dokumentierte Endzustand liegt in `POL-001`, `docs/BACKLOG.md`,
`docs/ADR/README.md`, `docs/backlog/README.md`, `docs/issues/README.md` und
der Legacy-Notiz unter `docs/tasks/`. Historische Basis: Sprint 25 mit den
Commits `0968b70` und `25df1d6`.

# Derived Tasks
- Keine separaten `TSK-xxxx` nachgetragen; die historische Umsetzung ist
  direkt ueber Sprint 25 tracebar.
