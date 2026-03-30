---
id: BL-0027
title: Wiki-Entry-Layer und Public-Readiness-Ausrichtung
status: done
priority: P2
type: improvement
tags: [wiki, docs, public-readiness, navigation, 'lane:planned']
created: 2026-03-30
updated: 2026-03-30
related:
  - BL-0024
  - ADR-0012
---
**Stand:** 2026-03-30

# Goal
Die Wiki-Schicht als ruhigen oeffentlichen Einstieg schaerfen, waehrend
`docs/` die technische Source of Truth bleibt.

# Motivation
Sprint 27 hat die Wiki- und Entry-Layer bereits auf diesen Zustand gezogen,
aber ohne eigenen kanonischen `BL-0027`-Eintrag. Der Backfill dient nur der
sauberen Referenzierbarkeit des abgeschlossenen Arbeitsblocks.

# Scope
In Scope:
- Wiki-Home, Wiki-README und redaktionelle Nebeninhalte ruhig und klar ordnen
- publizierten Wiki-Einstieg und versionierte Wiki-Quelle sauber verlinken
- Source-of-Truth-Grenze zwischen Wiki und Repo-Doku explizit machen

Out of Scope:
- neue Wiki-Inhalte oder breite Public-Readiness-Ueberarbeitung
- Rueckbau persoenlicher Kontexte wie `Cookie-Note`
- Verlagerung technischer Detaildoku aus `docs/` in das Wiki

# Risks
- das Wiki wirkt wie eine zweite konkurrierende technische Doku
- persoenliche Nebeninhalte werden im Einstieg zu dominant
- externe Leser finden den kuratierten Einstieg oder die Repo-Quelle nicht klar

# Output
Wiki-Entry, verlinkte Repo-Einstiege und die Source-of-Truth-Abgrenzung sind
ruhig synchronisiert. Historische Basis: Sprint 27 mit den Commits `fc283cc`
und `cc7d107`.

# Derived Tasks
- Keine separaten `TSK-xxxx` nachgetragen; die historische Umsetzung ist
  direkt ueber Sprint 27 tracebar.
