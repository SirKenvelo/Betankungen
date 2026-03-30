---
id: BL-0026
title: Transition-Hold und Entry-Doku-Sync nach 1.3.0
status: done
priority: P2
type: improvement
tags: [docs, entry, status, release, 'lane:planned']
created: 2026-03-30
updated: 2026-03-30
related:
  - BL-0025
  - ADR-0012
---
**Stand:** 2026-03-30

# Goal
Alle zentralen Einstiegsdokumente auf denselben Zustand ziehen:
`1.3.0` ist final, `APP_VERSION=1.3.0` bleibt unveraendert und
`1.4.0-dev` ist bewusst noch nicht gestartet.

# Motivation
Sprint 26 hat diesen Abgleich bereits geliefert, aber die kanonische
Backlog-Referenz fehlte. Der Backfill dokumentiert den abgeschlossenen
Transition-Hold-Block, ohne den Hold erneut fachlich zu verhandeln.

# Scope
In Scope:
- Root-`README.md`, `docs/README.md`, `docs/README_EN.md`,
  `CONTRIBUTING.md` und `docs/STATUS.md` auf denselben Hold-Narrativ ziehen
- klarer Hinweis auf den separaten Dev-Start nach Sprint 29
- saubere Abgrenzung zwischen finaler `1.3.0`-Linie und vorbereitetem
  Folge-Scope

Out of Scope:
- Aktivierung von `1.4.0-dev`
- Umsetzung von `BL-0016` oder Rueckkehr von `BL-0011` in den Repo-Scope
- neue inhaltliche Umgestaltung der Einstiegsdoku ueber den Hold-Abgleich

# Risks
- oeffentliche Einstiegsseiten kommunizieren einen veralteten Projektzustand
- der separate Dev-Start wirkt implizit bereits vorgezogen
- deutscher und englischer Einstieg driften erneut auseinander

# Output
Der Hold-Narrativ ist in den zentralen Einstiegsdokumenten konsistent
dokumentiert. Historische Basis: Sprint 26 mit den Commits `5e10687` und
`bab3e9e`.

# Derived Tasks
- Keine separaten `TSK-xxxx` nachgetragen; die historische Umsetzung ist
  direkt ueber Sprint 26 tracebar.
