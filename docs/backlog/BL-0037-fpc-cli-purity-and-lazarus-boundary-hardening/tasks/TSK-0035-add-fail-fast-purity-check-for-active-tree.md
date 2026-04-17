---
id: TSK-0035
title: Fail-Fast-Purity-Check fuer aktiven Baum und CI einfuehren
status: todo
priority: P1
type: task
tags: [architecture, audit, build, ci, purity]
created: 2026-04-17
updated: 2026-04-17
parent: BL-0037
related:
  - ADR-0016
---
**Stand:** 2026-04-17

# Task
Einen expliziten Guardrail einfuehren, der den aktiven Baum auf verbotene
Lazarus-/LCL-Artefakte und aktive GUI-Tokens prueft und im Fehlerfall lokal
sowie in der CI fail-fast abbricht.

# Notes
- Die Suchflaeche soll bewusst auf aktive Pfade begrenzt bleiben:
  `src/`, `units/`, `tests/`, `scripts/`, `Makefile`,
  `.github/workflows/`, `.vscode/tasks.json`.
- Historische Bereiche wie `docs/CHANGELOG.md`, `knowledge_archive/` und
  aeltere Tracker-Texte duerfen nicht als aktive Verstoesse fehlklassifiziert
  werden.
- Harmlosen Teilstring-Treffern wie `TFormatSettings` ist vorzubeugen.
- Erwartete Einbindung: separates Skript plus Verdrahtung in `make verify`
  und CI.

# Done When
- [ ] Ein dedizierter Purity-Check ist als Skript im Repo vorhanden.
- [ ] Der Check erkennt verbotene Artefakte/Tokens im aktiven Baum fail-fast.
- [ ] `make verify` und die CI fuehren den Check verbindlich aus.
- [ ] Doku benennt den Check als Teil der aktiven Architekturgrenze.
