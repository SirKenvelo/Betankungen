---
id: BL-0020
title: Backup-Operationen fuer einzelne oder alle Tankdatenbanken
status: proposed
priority: P2
type: improvement
tags: [backup, restore, operations, safety]
created: 2026-03-17
updated: 2026-03-17
related:
  - POL-003
---
**Stand:** 2026-03-17

# Goal
Gezielte Backup-Funktionen fuer eigene Tankdatenbanken bereitstellen (einzeln
oder gesammelt), ohne bestehende Sicherheitspfade aufzuweichen.

# Motivation
Im Betrieb mit mehreren Datenbanken (z. B. auf Raspberry Pi / Docker) wird ein
praeziser Backup-Workflow fuer Wartung und Datensicherheit benoetigt.

# Scope
In Scope:
- Selektive Sicherung einzelner Datenbanken.
- Sammelsicherung aller erkannten Datenbanken in einem Lauf.
- Dokumentierte Restore-Grenzen gemaess `POL-003`.

Out of Scope:
- Unkontrollierte Massen-Exports ohne Retention-/Privacy-Regeln.
- Ersatz der bestehenden Release-/Snapshot-Mechanik.

# Risks
- Fehlkonfiguration kann zu unvollstaendigen Sicherungen fuehren.
- Hoeherer Storage-Bedarf bei parallelen Einzel- und Sammelbackups.

# Output
Ein belastbarer Operations-Backlog fuer datenbankspezifische Backups im
Mehr-DB-Betrieb.

# Derived Tasks
- Werden bei Aktivierung als `TSK-xxxx` angelegt.
