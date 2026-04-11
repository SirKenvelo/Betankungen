---
id: BL-0035
title: Public-Repo-Entry-Audit und Onboarding-Hardening
status: in_progress
priority: P2
type: research
tags: [github, public-readiness, audit, ux, onboarding, docs, 'lane:planned']
created: 2026-04-11
updated: 2026-04-11
related:
  - ADR-0012
  - BL-0016
  - BL-0027
---
**Stand:** 2026-04-11

# Goal
Den oeffentlichen GitHub-Einstieg von Betankungen so auditieren, dass
Professionalitaet, Vertrauen, Orientierung und Contributor-Onboarding nicht
nur intern konsistent, sondern fuer Erstbesucher sichtbar besser werden.

# Motivation
`BL-0016` und `BL-0027` haben die Baseline fuer Community-Standards und
Entry-Layer bereits geliefert. Die naechste offene Frage ist nicht mehr
"fehlt noch Doku?", sondern ob ein externer Leser in den ersten 60-120
Sekunden versteht:

- was Betankungen ist
- warum das Projekt relevant oder reif genug wirkt
- wo er sinnvoll starten sollte
- wie gepflegt und serioes das Repository wirkt

Ohne einen bewusst kalten Audit droht Betankungen, eigenes Roadmap-, Doku- und
Governance-Wissen stillschweigend vorauszusetzen.

# Scope
In Scope:
- zweistufiger Audit des oeffentlichen GitHub-Einstiegs: erst Cold-Start auf
  Repo-/Wiki-Einstieg, dann Kontext-Pass mit den kanonischen Entry-Dokumenten
- Bewertung von Professionalitaet, Vertrauen, Navigierbarkeit,
  Nutzenklarheit und Contributor-Onboarding
- Uebersetzung belastbarer Findings in Quick Wins sowie spaetere
  `ISS`-/`BL`-/`ADR`-Kandidaten
- wiederverwendbarer Agenten-Prompt und Auswerteraster fuer spaetere Re-Audits

Out of Scope:
- pauschaler Big-Bang-Umbau der gesamten Doku
- neue Produkt- oder Runtime-Features
- kuenstlich erzeugte Issues ohne belastbare Beobachtung
- ADR-Erzeugung ohne echten strukturellen Entscheidungsbedarf

# Risks
- Zu viel interner Kontext verwischt den Blick eines echten Erstbesuchers.
- Allgemeine Open-Source-Ratschlaege verdraengen repo-spezifische Befunde.
- Einzelne Copy- oder Reihenfolge-Funde werden vorschnell zu Architektur-
  Entscheidungen ueberhoeht.

# Output
Ein belastbarer Audit-Pfad mit Prompt, Bewertungsraster und klarer
Tracker-Logik: konkrete Friktionspunkte gehen spaeter in `ISS`, groessere
Verbesserungsbloecke in `BL`, und `ADR` entsteht nur bei stabilen Struktur-
oder Governance-Entscheidungen. `TSK-0030` liefert den wiederverwendbaren
Audit-Prompt; `TSK-0031` zieht spaetere Findings in den Tracker.

# Audit Guardrails
- Phase 1 beginnt immer ohne tiefe Repo-Kontextlektuere.
- Beobachtung und Interpretation werden strikt getrennt.
- Erst nach Phase 1 duerfen `docs/README_EN.md`, `docs/README.md`,
  `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md` und die Wiki-
  Entry-Layer bewusst in die Bewertung einfliessen.
- Nicht jeder Fund erzeugt einen Tracker-Eintrag; kleine Copy- oder
  Reihenfolge-Korrekturen koennen als Quick Wins gebuendelt werden.

# Derived Tasks
- `TSK-0030` - Agenten-Prompt und Audit-Raster fuer den Public-Repo-Einstieg
  definieren. (done)
- `TSK-0031` - Audit-Funde in Quick Wins, `ISS`, `BL` und nur bei Bedarf
  `ADR`-Kandidaten uebersetzen. (todo)
