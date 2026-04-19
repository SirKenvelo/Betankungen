---
id: BL-0038
title: Dokumentations-, Wiki- und Evidence-Ausrichtung nachschaerfen
status: proposed
priority: P2
type: improvement
tags: [docs, wiki, audit, evidence, public-readiness, navigation, 'lane:planned']
created: 2026-04-18
updated: 2026-04-19
related:
  - BL-0023
  - BL-0035
  - BL-0036
---
**Stand:** 2026-04-19

# Goal
Die im Audit vom 2026-04-18 gefundenen Doku-, Wiki- und Evidence-Friktionen in
einen klar geschnittenen Hardening-Block uebersetzen, ohne die gesamte
Projekt- oder Historien-Doku in einem Big-Bang umzubauen.

# Motivation
Der Audit bestaetigt eine stabile technische Source of Truth fuer `1.4.0`,
zeigt aber drei reale Restluecken:

- die oeffentliche Wiki-Quick-Reference ist teilweise nicht mehr auf dem
  aktuellen CLI-/Build-Stand,
- `docs/DEV_DIARY.md` ist vorhanden und sauber gerahmt, aber im sichtbaren
  Entry-/Wiki-Handoff nur schwach verortet,
- die externe Audit-Ablage und der separate Nutzertest-Ordner besitzen noch
  keine wirklich klare gemeinsame Evidence-Indexschicht.

Ohne einen gebuendelten Folgeblock bleibt die Lage zwar nicht kaputt, aber
weiter unnötig streuend: korrekte Technik, ungleichmaessige Sichtbarkeit und
ein paar veraltete oeffentliche Beispiele.

# Scope
In Scope:
- oeffentliche Wiki-/Entry-Beispiele und Linkpfade gegen den aktuellen
  CLI-/Build- und Modulstand ziehen
- Rollen von Public Entry, tiefen Repo-Dokumenten, `DEV_DIARY` und externer
  Evidence bewusst nachschaerfen
- externe Audit-/Nutzertest-Ablage ueber eine klare Index- oder
  Brueckenschicht lesbarer machen
- selektive englische Folgearbeit nur dort schneiden, wo sie fuer Public
  Entry, Orientierung oder Evidence-Nutzung echten Mehrwert bringt

Out of Scope:
- Big-Bang-Umbau der gesamten Doku
- Volluebersetzung von Roadmaps, Statushistorien oder interner Steuerungsdoku
- Runtime-, Build- oder Datenmodell-Aenderungen
- sofortige `knowledge_archive/`-Migration

# Risks
- Ein reiner Copy-Fix ohne Rollenrahmung wuerde die Sichtbarkeitsprobleme nur
  teilweise loesen.
- Eine zu grosse Englisch-Offensive wuerde den Audit-Befund ueberdehnen.
- Externe Evidence kann weiter korrekt, aber fuer Dritte schwer navigierbar
  bleiben, wenn nur Repo-Seiten angepasst werden.

# Output
Der Folgeblock soll die oeffentliche Einstiegs- und Evidence-Schicht ruhig,
technisch wahr und besser navigierbar machen: aktuelle Wiki-Kommandos,
klarere DEV-Diary-Einordnung, eine lesbare Bruecke zwischen Audit-Ordner und
Nutzertest-Ablage sowie ein bewusst begrenzter Plan fuer weitere englische
Entry-Signale.

# Progress
- `TSK-0037` ist `done`: Die Wiki-Quick-Reference fuehrt wieder auf den
  aktuellen Core-CLI-/Build-Stand.
- `TSK-0038` ist `done`: Die externe Audit-Ablage hat jetzt eine kleine
  Evidence-Indexschicht und eine explizite Bruecke zur separaten
  Nutzertest-Ablage.
- `TSK-0039` ist `done`: `docs/DEV_DIARY.md` ist im Entry-/Wiki-Handoff
  sichtbarer und eindeutiger als kuratierte Chronik gerahmt.
- `TSK-0040` bleibt als getrennte Folgearbeit offen.

# Derived Tasks
- `TSK-0037` - Wiki-Quick-Reference auf aktuellen CLI-/Build-Stand ziehen.
- `TSK-0038` - Externe Evidence-Indexschicht und Nutzertest-Bruecke definieren.
- `TSK-0039` - `DEV_DIARY`-Sichtbarkeit und Rollenrahmung im Doku-Handoff nachschaerfen.
- `TSK-0040` - Selektive English-Public-Readiness fuer Doku- und Evidence-Einstiege schneiden.
