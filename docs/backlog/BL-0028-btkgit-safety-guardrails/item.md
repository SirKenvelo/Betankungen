---
id: BL-0028
title: `btkgit`-Safety-Guardrails fuer Solo-Maintenance
status: done
priority: P2
type: improvement
tags: [tooling, git, safety, workflow, 'lane:planned']
created: 2026-03-30
updated: 2026-03-30
related:
  - ADR-0010
  - ADR-0013
---
**Stand:** 2026-03-30

# Goal
Das repo-lokale Wrapper-CLI `btkgit` fuer Solo-Maintenance operativ nutzbar
machen, ohne versteckte oder destruktive Defaults zu tolerieren.

# Motivation
Sprint 28 hat `btkgit` bereits auf klarere Failure-UX, konservativeres
Cleanup und nicht-destruktive Smoke-Abdeckung gehoben. Der fehlende kanonische
`BL-0028`-Eintrag wird hier ruhig nachgezogen.

# Scope
In Scope:
- gezielte Hinweise fuer Auth-/Remote-/Upstream-Probleme bei `sync`
- konservative Cleanup-Semantik ohne implizites lokales Branch-Loeschen
- nicht-destruktive Smoke-Abdeckung fuer dokumentierte Safe Paths
- Doku-/ADR-Sync auf den tatsaechlichen MVP-Grenzbereich

Out of Scope:
- neue `btkgit`-Kommandos ueber den Sprint-28-Iststand hinaus
- automatische Reparatur von Credentials, Remotes oder Tracking-Konfiguration
- Autopilot fuer Commit, Push, PR oder Merge

# Risks
- Wrapper-Fehler bleiben fuer Maintainer zu roh oder irrefuehrend
- lokale Branches werden ueber zu aggressive Cleanup-Defaults unerwartet geloescht
- dokumentierte Safe Paths und testseitig abgesicherte Pfade driften auseinander

# Output
`btkgit`, `scripts/btkgit.sh`, die Smoke-Abdeckung und die zugehoerige Doku
bilden einen engeren, expliziten Safety-Rahmen fuer den bereits
abgeschlossenen Sprint-28-Block.

# Derived Tasks
- Keine separaten `TSK-xxxx` nachgetragen; die historische Umsetzung ist
  direkt ueber Sprint 28 tracebar.
