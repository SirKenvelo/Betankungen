---
id: BL-0036
title: Contributor Onboarding and English Entry-Layer Hardening
status: in_progress
priority: P2
type: improvement
tags: [contributors, onboarding, english, public-readiness, docs, 'lane:planned']
created: 2026-04-11
updated: 2026-04-12
related:
  - BL-0016
  - BL-0027
  - BL-0035
  - TSK-0032
  - TSK-0033
  - TSK-0034
---
**Stand:** 2026-04-12

# Goal
Den oeffentlichen Einstieg fuer potenzielle Mitwirkende und englischsprachige
Erstbesucher gezielt haerten, ohne die bestehende deutsche Tiefendoku
vollstaendig neu aufzubauen.

# Motivation
Die direkten P1-Funde aus dem Public-Repo-Entry-Audit sind inzwischen
geschlossen (`ISS-0011`, `ISS-0012`), aber fuer gelegentliche Contributors
und englischsprachige Erstbesucher bleibt mittlere Reibung sichtbar:

- Contributor-Onboarding ist fachlich vorhanden, aber noch zu dicht und nicht
  schnell genug in einen ersten PR-Pfad uebersetzt.
- Die englische Einstiegsschicht ist vorhanden, signalisiert aber noch nicht
  ruhig genug, wo internationale Erstbesucher sinnvoll weiterlesen sollten.
- README, Wiki und `CONTRIBUTING.md` sind einzeln brauchbar, arbeiten aber als
  gemeinsamer Handoff fuer externe Leser noch nicht klar genug zusammen.

Der verbleibende Scope ist jetzt schmal genug, um nicht mehr als grosser
Sammelblock weiterzulaufen. Fuer die naechsten Schritte ist ein Zuschnitt in
wenige kleine, nicht ueberlappende `TSK` sinnvoller als ein weiterer
unscharfer Hardening-Container.

# Scope
In Scope:
- kompakterer Contributor-Quickstart mit klarer Build-/Verify-/PR-Orientierung
  fuer gelegentliche Mitwirkende
- klarere englische Entry-Signale fuer Erstbesucher, die tiefe deutsche Doku
  nicht zuerst lesen wollen
- ruhigerer Handoff zwischen README, Wiki und `CONTRIBUTING.md`, damit die
  jeweilige Rolle der Einstiegsartefakte schneller erkennbar ist
- operative Schneidung in kleine, priorisierbare `TSK` statt weiterer
  Sammelbeschreibung

Out of Scope:
- vollstaendige Uebersetzung der gesamten Projektdokumentation
- neue Produkt- oder Runtime-Features
- ein Big-Bang-Umbau der kompletten Doku-Hierarchie
- neue ADR-Erzeugung ohne echten Entscheidungsbedarf
- direkte Umsetzung der neuen `TSK` in diesem Planungsblock

# Risks
- Ein zu breiter "translate everything"-Reflex kann den eigentlichen
  Entry-Layer-Nutzen verdecken.
- Ueberlappende Tasks erzeugen spaeter doppelte Dokuarbeit und unklare
  Abschlusskriterien.
- Ein Handoff-Task darf nicht wieder implizit Quickstart- oder
  Uebersetzungsarbeit vereinnahmen.

# Output
`BL-0036` ist jetzt von `proposed` auf `approved` gezogen und in drei
umsetzbare Folgepfade geschnitten. Der Block ist damit operativ belastbar:
Contributor-Quickstart, englische Entry-Signale und README-/Wiki-/
`CONTRIBUTING.md`-Handoff sind getrennt priorisierbar und koennen ohne
Scope-Ueberlappung nacheinander umgesetzt werden.

Der erste Umsetzungsblock ist jetzt angelaufen:
`TSK-0032` ist abgeschlossen und liefert in `CONTRIBUTING.md` einen
kompakten Contributor-Quickstart mit minimalem Build-/Verify-/PR-Pfad.
`TSK-0033` ist abgeschlossen und schaerft die englischen Entry-Signale fuer
internationale Erstbesucher, ohne die deutsche Tiefendoku zu uebernehmen.
Die verbleibende Folgearbeit konzentriert sich jetzt nur noch auf den
ruhigeren README-/Wiki-/`CONTRIBUTING.md`-Handoff (`TSK-0034`).

# Task Slices
- `TSK-0032` - kompakten Contributor-Quickstart und erste PR-Checkliste fuer
  gelegentliche Mitwirkende schneiden.
- `TSK-0033` - englische Entry-Signale fuer internationale Erstbesucher
  staerken, ohne die Tiefendoku voll zu uebersetzen.
- `TSK-0034` - README, Wiki und `CONTRIBUTING.md` als ruhigen Handoff statt
  als lose nebeneinanderstehende Einstiege ausrichten.

# Sequencing
- `TSK-0032` ist abgeschlossen und bildet jetzt die sichtbare Contributor-
  Quickstart-Schicht in `CONTRIBUTING.md`.
- `TSK-0033` ist abgeschlossen.
- Reihenfolge danach: nur noch `TSK-0034`, damit der Handoff auf der bereits
  geschaerften Einstiegsbasis beruhigt werden kann.
