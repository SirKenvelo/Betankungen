---
id: BL-0035
title: Public-Repo-Entry-Audit und Onboarding-Hardening
status: done
priority: P2
type: research
tags: [github, public-readiness, audit, ux, onboarding, docs, 'lane:planned']
created: 2026-04-11
updated: 2026-04-11
related:
  - ADR-0012
  - BL-0016
  - BL-0027
  - BL-0036
  - ISS-0011
  - ISS-0012
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
Der Audit-Pfad ist jetzt komplett: ein wiederverwendbarer Prompt, ein
abgeschlossener externer Audit-Lauf und die Uebersetzung der belastbaren
Findings in konkrete Tracker-Folgen. Der Block hat zwei direkte `ISS`-
Kandidaten (`ISS-0011`, `ISS-0012`) und einen groesseren Folgeblock
(`BL-0036`) geschnitten; ein neuer `ADR` war dafuer nicht noetig.

# Audit Guardrails
- Phase 1 beginnt immer ohne tiefe Repo-Kontextlektuere.
- Beobachtung und Interpretation werden strikt getrennt.
- Erst nach Phase 1 duerfen `docs/README_EN.md`, `docs/README.md`,
  `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md` und die Wiki-
  Entry-Layer bewusst in die Bewertung einfliessen.
- Nicht jeder Fund erzeugt einen Tracker-Eintrag; kleine Copy- oder
  Reihenfolge-Korrekturen koennen als Quick Wins gebuendelt werden.

# Audit Outcome
- Der externe Public-Repo-Entry-Audit vom 2026-04-11 liegt vor und bestaetigt
  Professionalitaet und Governance-Basis, zeigt aber sichtbare Friktion im
  README-/Entry-Flow.
- `ISS-0011` adressiert den zu statuslastigen README-Einstieg und den zu
  spaet sichtbaren Quick-Start-Pfad.
- `ISS-0012` adressiert die Luecke zwischen oeffentlichem Release-Signal und
  sichtbarer GitHub-Release-Oberflaeche.
- `BL-0036` buendelt das spaetere Contributor-Onboarding- und
  English-Entry-Layer-Hardening.
- Ein neuer `ADR` ist aktuell nicht erforderlich; die Befunde sind
  Discoverability- und Entry-Layer-Follow-ups, keine neue Strukturentscheidung.

# Derived Tasks
- `TSK-0030` - Agenten-Prompt und Audit-Raster fuer den Public-Repo-Einstieg
  definieren. (done)
- `TSK-0031` - Audit-Funde in Quick Wins, `ISS`, `BL` und nur bei Bedarf
  `ADR`-Kandidaten uebersetzen. (done)
