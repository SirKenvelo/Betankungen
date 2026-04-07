---
id: BL-0033
title: TUI Presentation and View-Layer Refresh
status: proposed
priority: P3
type: improvement
tags: [tui, ui, terminal, renderer, views, 'lane:planned']
created: 2026-04-07
updated: 2026-04-07
related:
  - ADR-0015
  - BL-0034
---
**Stand:** 2026-04-07

# Goal
Die read-only Darstellung von Betankungen kontrolliert modernisieren, ohne die
CLI-first-Basis aufzuweichen oder sofort ein vollstaendiges Form-System
einzufuehren.

# Motivation
Die aktuelle Terminaldarstellung ist funktional, aber visuell noch zu roh:

- zu viele Boxen und harte Linien
- zu wenig visuelle Hierarchie
- Listen und Detailbloecke wirken technisch korrekt, aber nicht bewusst
  gestaltet
- die Anwendung fuehlt sich eher wie ein korrektes Lernprojekt als wie ein
  gereiftes Terminal-Werkzeug an

Bevor interaktive Komfortformulare angegangen werden, braucht Betankungen
zunaechst eine bewaehrte, wiederverwendbare Darstellungsbasis fuer
read-only-Views.

# Scope
In Scope:
- einen einzelnen Referenzscreen als ersten TUI-Migrationskandidaten
  definieren und modernisieren, z. B. `fuelups --list --detail`
- leichte Render-Abstraktion fuer Terminal-/Painter-/View-Trennung
  vorbereiten oder einziehen
- visuelle Hierarchie, Weissraum und Tabellen-/Detaildarstellung verbessern
- Render-Konventionen fuer weitere spaetere Views ableiten
- CLI-first und bestehende Text-/Automationspfade unangetastet lassen

Out of Scope:
- generisches Form-System fuer Add-/Edit-Flows
- Big-Bang-Umbau aller Screens
- neue Fachlogik oder geaenderte CLI-Semantik
- verpflichtende Themes, 24-bit-Farben oder Design-Spielereien ohne klaren
  Nutzwert
- schwergewichtiges Fremdframework als neue UI-Basis

# Risks
- Zu fruehe Abstraktion erzeugt mehr Renderer-Komplexitaet als echten
  Nutzwert.
- Ausgabe-Regressionen in bestehenden Listen-/Detail-Contracts werden
  versehentlich eingeschleppt.
- Visual Polish wird mit Produktlogik vermischt, obwohl nur die
  Darstellungsoberflaeche verbessert werden soll.

# Output
Ein bewusst begrenzter TUI-View-Refresh-Block mit einem bewaehrten
Referenzscreen, klaren Render-Konventionen und einer wiederverwendbaren Basis
fuer spaetere weitere read-only Views.
