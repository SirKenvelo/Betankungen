---
id: TSK-0039
title: DEV_DIARY-Sichtbarkeit und Rollenrahmung im Doku-Handoff nachschaerfen
status: done
priority: P2
type: task
tags: [docs, navigation, dev-diary, public-readiness]
created: 2026-04-18
updated: 2026-04-19
parent: BL-0038
related:
  - BL-0023
---
**Stand:** 2026-04-19

# Task
Die Rolle von `docs/DEV_DIARY.md` im Zusammenspiel mit `README.md`,
`docs/README.md`, `docs/README_EN.md`, Wiki und `docs/SPRINTS.md` so
nachschaerfen, dass Sichtbarkeit und Zweck klar sind, ohne das Dev-Diary zu
einem oeffentlichen Hauptpfad aufzublasen.

# Notes
- Der Audit zeigt kein Inhaltsproblem des Dev-Diarys, sondern vor allem ein
  Sichtbarkeits- und Einordnungsproblem.
- Wichtig ist die klare Trennung: Changelog = Aenderungen, Sprints = Ablauf /
  Traceability, Dev-Diary = kuratierter menschlicher Projektfaden.
- Der Slice darf ruhig mit kleiner Navigation oder kurzen Kontextsaetzen
  arbeiten; eine grosse inhaltliche Erweiterung des Diaries ist nicht Ziel.

# Result
- `README.md`, `docs/README.md`, `docs/README_EN.md`, `docs/wiki/Home.md`
  und `docs/wiki/README.md` rahmen das Dev Diary jetzt sichtbarer als
  kuratierte Chronik.
- `docs/DEV_DIARY.md` grenzt sich klarer von `docs/CHANGELOG.md` und
  `docs/SPRINTS.md` ab, ohne neue Pfade zu eroefnen.
- `docs/CHANGELOG.md`, `docs/STATUS.md`, `docs/SPRINTS.md` und
  `docs/BACKLOG.md` fuehren denselben Abschlussstand nach.

# Done When
- [x] Mindestens die relevanten Entry-/Navigationspunkte benennen das
  Dev-Diary konsistent oder begruenden bewusst, warum nicht.
- [x] Die Abgrenzung zu `docs/CHANGELOG.md` und `docs/SPRINTS.md` ist fuer
  Leser klarer.
- [x] Public Entry, tiefe Repo-Doku und persoenlichere Chronik senden keine
  widerspruechlichen Rollensignale.
- [x] Die Loesung bleibt klein und fuehrt keinen neuen Doku-Hauptpfad ein.
