---
id: BL-0019
title: Tankstellen-Geodaten und Plus-Codes erweitern
status: proposed
priority: P3
type: feature
tags: [stations, geodata, plus-codes, enrichment, 'lane:planned']
created: 2026-03-17
updated: 2026-03-18
related:
  - BL-0018
---
**Stand:** 2026-03-18

# Goal
Tankstellenstammdaten um Koordinaten und optional Plus Codes erweitern.

# Motivation
Geodaten ermoeglichen bessere Zuordnung, Distanz-basierte Auswertungen und
kontextstabile Stationserkennung ueber verschiedene Datenquellen hinweg.

# Scope
In Scope:
- Datenfelder fuer Breiten-/Laengengrad und Plus Codes.
- Validierungsregeln fuer Geodatenfelder.
- Grundlegende Doku fuer Ausgabe-/Nutzungsstrategie.

Out of Scope:
- Kartenvisualisierung oder GUI-Funktionen.
- Vollstaendige Geocoding-Pipeline mit externen Paid-Diensten.

# Risks
- Uneinheitliche Datenqualitaet aus externen Quellen.
- Zusatzaufwand fuer Datenpflege bei fehlenden Plus Codes.

# Output
Ein klar abgegrenzter Geodaten-Erweiterungsrahmen fuer Stationen, kompatibel
mit spaeteren Historien-/Vergleichsfeatures.

# Derived Tasks
- Werden bei Aktivierung als `TSK-xxxx` angelegt.
