---
id: BL-0018
title: Historische Tankstellenpreis-Erfassung via API-Polling
status: approved
priority: P2
type: feature
tags: [api, polling, history, analytics, docker, 'lane:release-blocking']
created: 2026-03-17
updated: 2026-03-24
related:
  - BL-0017
  - BL-010
  - POL-003
  - TSK-0020
  - TSK-0021
---
**Stand:** 2026-03-24

# Goal
Tankstellenpreise zyklisch (z. B. alle 15 Minuten) erfassen und als auswertbare
Historie in einer separaten Datenbasis aufbauen.

# Motivation
Mit Zeitreihen zu externen Preisen werden historische Analysen und Vergleiche
mit eigenen Tankdaten moeglich.

# Scope
In Scope:
- Polling-Pipeline fuer Preisdaten im festen Intervall.
- Rohdatenhaltung (JSON/CSV) plus normalisierte Historienablage.
- Auswertungsbasis fuer Sortierung, Trends und Vergleich mit eigenen Fuelups.

Out of Scope:
- Endgueltige API-Auswahl (siehe `BL-0017`).
- Vermischung mit produktiven Core-Datenbanken ohne klares Trennkonzept.
- Harte Realtime-Anforderungen unterhalb des geplanten Intervalls.

# Risks
- Datenvolumen und Retention wachsen schneller als erwartet.
- Polling-Ausfaelle verfaelschen Historien-Auswertungen.

# Output
Ein definierter Implementierungsrahmen fuer Preis-Historie inklusive
Speicherformat- und Datenmodell-Leitplanken.

# Derived Tasks
- `TSK-0020` - Polling-/Historien-Contract und Datenpfad-Trennung fuer 1.3.0 definieren. (todo)
- `TSK-0021` - Polling-Basis, Persistenzpfad und Regression-/Audit-Nachweise fuer 1.3.0 liefern. (todo)
