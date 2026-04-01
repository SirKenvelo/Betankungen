---
id: BL-0019
title: Tankstellen-Geodaten und Plus-Codes erweitern
status: done
priority: P3
type: feature
tags: [stations, geodata, plus-codes, enrichment, 'lane:planned']
created: 2026-03-17
updated: 2026-04-01
related:
  - BL-0018
  - ISS-0007
---
**Stand:** 2026-04-01

# Goal
Tankstellenstammdaten um belastbare Geokoordinaten und optionale Plus Codes
erweitern.

# Motivation
Geodaten ermoeglichen bessere Zuordnung, Distanz-basierte Auswertungen und
kontextstabile Stationserkennung ueber verschiedene Datenquellen hinweg.

# Scope
In Scope:
- Datenfelder fuer Breiten-/Laengengrad und optionale Plus Codes.
- Validierungsregeln fuer Geodatenfelder und Plus-Code-Normalisierung.
- Additive Schema-Migration fuer Bestandsdatenbanken.
- Grundlegende Doku fuer Ausgabe-/Nutzungsstrategie.

Out of Scope:
- Kartenvisualisierung oder GUI-Funktionen.
- Vollstaendige Geocoding-Pipeline mit externen Paid-Diensten.

# Implemented Rules
- Koordinaten werden als optionales Stationsmerkmal gefuehrt, aber immer als
  Paar (`latitude` + `longitude`) geschrieben.
- Werte werden vor Persistenz in Dezimalgrad validiert und intern als
  `latitude_e6` / `longitude_e6` gespeichert.
- Plus Codes bleiben optional, werden normalisiert und als voller Open
  Location Code gespeichert; zusaetzlich sind lokale/short Codes erlaubt,
  wenn `latitude` und `longitude` gesetzt sind.
- Die kompakte Stationsliste bleibt ruhig; Geodaten und Plus Codes erscheinen
  nur in `--list stations --detail`.

# Source of Truth
- Die lokale `stations`-Tabelle ist die technische Source of Truth fuer
  manuell gepflegte Geodaten.
- Plus Codes sind ein zusaetzlicher Locator und keine Identitaets- oder
  Duplikatsquelle fuer Stationen.
- Es gibt bewusst keine automatische Geocoding- oder Plus-Code-Ableitung im
  Core.

# Risks
- Uneinheitliche Datenqualitaet aus externen Quellen bleibt moeglich und wird
  nur ueber Eingabevalidierung, nicht ueber externe Verifikation, begrenzt.
- Historische Bestandsdaten ohne Geodaten bleiben bewusst zulaessig.

# Output
Ein klar abgegrenzter Geodaten-Erweiterungsrahmen fuer Stationen, kompatibel
mit spaeteren Distanz-, Vergleichs- und Quellenabgleich-Features, ohne den
aktuellen CLI-Flow in Richtung Mapping/GUI auszubauen.

# Validation
- Schema-/Migrations-Smoke fuer `v4 -> v6` und `v5 -> v6`
- Domain-Policy-Block `P-085` bis `P-088`
- Regression fuer Persistenz und kompakte vs. Detail-Sichtbarkeit in
  `--list stations`

# Derived Tasks
- Keine separaten Folge-Tasks erforderlich; der Block wurde direkt als Sprint
  33 geschlossen.
