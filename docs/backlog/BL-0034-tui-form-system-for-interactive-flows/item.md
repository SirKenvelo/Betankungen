---
id: BL-0034
title: TUI Form System for Interactive Flows
status: proposed
priority: P3
type: feature
tags: [tui, forms, input, widgets, cli, 'lane:exploratory']
created: 2026-04-07
updated: 2026-04-07
related:
  - ADR-0015
  - BL-0033
  - BL-0031
---
**Stand:** 2026-04-07

# Goal
Ein spaeteres, optionales TUI-Form-System fuer interaktive Add-/Edit-Flows
vorbereiten, das die Bedienung verbessert, ohne die klassische CLI-Steuerung
oder non-interactive Workflows zu verdraengen.

# Motivation
Die aktuelle feldweise RETURN-Eingabe ist robust und einfach, wirkt aber bei
haeufig genutzten interaktiven Flows zunehmend unkomfortabel. Nach einer
bewaehrten View-/Painter-Basis kann ein Formularsystem den naechsten
Ergonomieschritt liefern:

- klarere Fokusfuehrung
- schnellere Eingabe
- geringere Fehlerrate
- wiederverwendbare Widgets statt ad-hoc Dialoglogik

Dieser Schritt ist jedoch groesser und riskanter als ein reiner
Darstellungs-Refresh und soll deshalb erst nach einem erfolgreichen
Referenzscreen folgen.

# Scope
In Scope:
- spaetere Input-/Widget-/Form-Architektur fuer interaktive TUI-Flows
  definieren
- Wiederverwendbarkeit fuer Add-/Edit-Dialoge vorbereiten
- Tastatur-first-Navigation (Tab, Shift+Tab, Enter, Esc, Pfeiltasten)
  als Komfortpfad evaluieren
- CLI-Flags und non-interactive Parameter als steuernde Einstiegsschicht
  unveraendert beibehalten

Out of Scope:
- sofortige Runtime-Einfuehrung eines vollstaendigen Form-Frameworks
- Ersetzen aller bestehenden interaktiven Flows auf einmal
- Verlagerung von Domainvalidierung in Widgets oder Rendercode
- GUI-/Maus-/Fenstersystem ausserhalb des Terminalkontexts
- neue Produktlogik oder neue Persistenzsemantik

# Risks
- Formlogik waechst zu frueh zu einem zweiten Orchestrator neben der CLI an.
- Validierungs- und Domainregeln verteilen sich unkontrolliert zwischen
  Formular- und Fachschicht.
- Ein zu grosser Einstieg blockiert kleinere CLI-/UX-Hardening-Schritte.

# Output
Ein klar abgegrenzter spaeterer Backlogblock fuer optionale TUI-Formulare, der
erst nach einer bewaehrten View-/Painter-Basis aktiviert wird und die
CLI-first-Strategie ausdruecklich beibehaelt.
