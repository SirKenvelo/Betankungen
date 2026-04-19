---
id: TSK-0038
title: Externe Evidence-Indexschicht und Nutzertest-Bruecke definieren
status: done
priority: P2
type: task
tags: [docs, audit, evidence, navigation]
created: 2026-04-18
updated: 2026-04-19
parent: BL-0038
related:
  - BL-0022
---
**Stand:** 2026-04-19

# Task
Eine kleine, aber klare Index- und Referenzschicht fuer die externe
Audit-Ablage schaffen, die den separaten Ordner
`/home/christof/Dokumente/Betankungen_Nutzertests` sichtbar einordnet, statt
ihn nur implizit vorauszusetzen.

# Notes
- Der Audit-Root hat bereits eine grobe README-/Status-Schicht, aber die
  Nutzertest-Dokumente sind dort noch nicht als eigene Evidence-Quelle
  auffindbar oder verlinkt.
- Ziel ist keine Verschiebung aller Dateien, sondern eine lesbare
  Informationsarchitektur mit klaren Rollen fuer `runs/`, `plans/`, `issues/`
  und externe Nutzertests.
- Der Slice darf bewusst ausserhalb des Produkt-Repos wirken; repo-seitig ist
  nur die Ableitung und Referenzierung relevant.
- Umsetzung 2026-04-19: Der externe Audit-Root fuehrt jetzt
  `EVIDENCE_INDEX.md` als explizite Einstiegsdatei; `README.md` sowie
  neue Rollen-READMEs in `runs/`, `plans/` und `issues/` trennen konkrete
  Evidence, Planungsnotizen und ausgelagerte Befunde klarer.
- Die separate Nutzertest-Ablage unter
  `/home/christof/Dokumente/Betankungen_Nutzertests` ist als eigene externe
  Evidence-Quelle dokumentiert angebunden; es wurden keine Dateien
  verschoben oder dupliziert.

# Done When
- [x] Die externe Audit-Ablage hat einen klaren Einstieg fuer Evidence-Quellen
  und Ordnerrollen.
- [x] Die Nutzertest-Dokumente sind explizit referenziert oder ueber eine
  dokumentierte Bruecke eingebunden.
- [x] Historische Audit-Laeufe, aktuelle Evidence und lose Planungsnotizen
  sind besser voneinander unterscheidbar.
- [x] Die Zielstruktur benoetigt keinen Big-Bang-Umzug bestehender Historie.
