---
id: TSK-0040
title: Selektive English-Public-Readiness fuer Doku- und Evidence-Einstiege schneiden
status: done
priority: P3
type: task
tags: [docs, english, public-readiness, evidence]
created: 2026-04-18
updated: 2026-04-19
parent: BL-0038
related:
  - BL-0036
---
**Stand:** 2026-04-19

# Task
Aus dem Audit heraus explizit entscheiden, welche weiteren englischen
Kurzpfade fuer Public Entry, Orientierung oder Evidence-Nutzung echten Nutzen
bringen und welche Doku bewusst deutsch/intern bleiben sollte.

# Notes
- Der Audit empfiehlt keine Volluebersetzung von `docs/STATUS.md`,
  Roadmaps oder interner Steuerungsdoku.
- Moegliche Kandidaten sind kurze englische Brueckensaetze oder kleine
  Index-/Summary-Schichten, nicht automatisch ganze Dokumente.
- Der Slice soll klare Nicht-Ziele dokumentieren, damit spaetere Arbeit nicht
  wieder in pauschale Uebersetzungsreflexe kippt.
- Reale Drift mit hoher Aussenwirkung lag zuletzt vor allem in
  `CONTRIBUTING.md` und `SECURITY.md`, nicht in fehlender Breitenuebersetzung.

# Result
- Priorisierte englische Bruecken bleiben bewusst klein und oeffentlich
  wirkungsstark: `README.md`, `docs/README_EN.md`, `CONTRIBUTING.md`,
  `SECURITY.md` sowie der Wiki-Entry-/Quick-Reference-Pfad.
- Fuer diese Schicht sind kurze Kontextsaetze, sichtbare Links und
  Wahrheitskonsistenz wichtiger als breite Paralleluebersetzungen.
- `CONTRIBUTING.md` und `SECURITY.md` fuehren jetzt denselben stabilen
  `1.4.0`-Hold wie die bereits aktualisierten Entry-Seiten.
- `docs/README_EN.md` und `docs/wiki/Home.md` benennen jetzt explizit, welche
  englischen Einstiegspfade priorisiert werden und welche tiefen Doku-Typen
  bewusst deutsch bleiben.
- Bewusst deutsch bzw. intern bleiben: `docs/STATUS.md`, Roadmaps,
  Release-/Gate-Dokumente, Sprint-Narrative, Tracker-Details und tiefe
  Steuerungsdoku unter `docs/`.

# Non-Goals
- Keine Volluebersetzung der Repo-Dokumentation.
- Keine parallele englische Zweitfassung von Statushistorie, Roadmaps oder
  Tracker-Details.
- Keine pauschale Bereinigung aller oeffentlichen Drift-Funde in einem Zug.

# Done When
- [x] Es gibt eine kleine, begruendete Liste fuer sinnvolle englische
  Folgepfade.
- [x] Dokumente mit bewusst deutschem/internem Status sind explizit
  eingeordnet.
- [x] Public Entry und Evidence-Nutzung profitieren sichtbar, ohne den
  Pflegeaufwand unverhaeltnismaessig zu vergroessern.
- [x] Es entsteht kein impliziter Volluebersetzungsauftrag.
