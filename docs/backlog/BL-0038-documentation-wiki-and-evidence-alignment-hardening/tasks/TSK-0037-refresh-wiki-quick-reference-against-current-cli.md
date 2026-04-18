---
id: TSK-0037
title: Wiki-Quick-Reference auf aktuellen CLI-/Build-Stand ziehen
status: done
priority: P1
type: task
tags: [docs, wiki, cli, public-readiness]
created: 2026-04-18
updated: 2026-04-18
parent: BL-0038
related:
  - BL-0035
---
**Stand:** 2026-04-18

# Task
Die oeffentliche Wiki-Quick-Reference gegen den realen `--help`-, Parser- und
Build-Stand pruefen und so bereinigen, dass Beispielkommandos und
Referenzlinks keine falschen oder veralteten Nutzersignale mehr senden.

# Notes
- Der Audit zeigt mindestens einen harten Drift-Fund: `Betankungen --init` ist
  im aktuellen Core ungueltig.
- Beispiele muessen den heutigen Interaktionscharakter der Core-CLI korrekt
  rahmen; Pseudo-Non-Interactive-Beispiele ohne Parser-Basis sind zu
  vermeiden.
- Companion-Modul-Beispiele duerfen bleiben, muessen aber sauber von
  Core-Kommandos und Build-/Pfadvoraussetzungen getrennt werden.

# Done When
- [x] `docs/wiki/CLI-Quick-Reference.md` verwendet nur aktuelle, technisch
  wahre Core-Beispiele.
- [x] Build-/Startpfad ist konsistent zu `README.md`, `docs/README_EN.md` und
  `./bin/Betankungen --help`.
- [x] Verlinkte Vertrags- und Referenzdokumente sind noch passend und bewusst
  ausgewaehlt.
- [x] `make wiki-link-check` laeuft nach dem Doku-Sync gruen.
