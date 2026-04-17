---
id: TSK-0036
title: VS-Code-Build-Frontend an make build binden
status: todo
priority: P2
type: task
tags: [build, tooling, vscode, cli]
created: 2026-04-17
updated: 2026-04-17
parent: BL-0037
related:
  - ADR-0016
---
**Stand:** 2026-04-17

# Task
`.vscode/tasks.json` so nachziehen, dass der Editor-Build explizit auf
`make build` oder einen gleichwertig kanonischen Wrapper zeigt statt einen
separat gepflegten FPC-Compile-String zu duplizieren.

# Notes
- Der Audit bewertet `.vscode/tasks.json` aktuell als Komfort-Frontend ohne
  aktive Build-Abweichung.
- Ziel ist nicht ein neuer Buildpfad, sondern weniger Drift-Risiko fuer
  kuenftige Compiler- oder Output-Aenderungen.
- Der Clean-Pfad kann separat bleiben, solange er keine konkurrierende
  Build-Wahrheit aufbaut.

# Done When
- [ ] Der VS-Code-Build verweist auf `make build` oder eine gleichwertig
  kanonische Huelle.
- [ ] Es gibt keinen separat zu pflegenden konkurrierenden Build-String mehr.
- [ ] Doku und Audit-Verweise benennen `.vscode/tasks.json` explizit als
  Komfort-Frontend.
