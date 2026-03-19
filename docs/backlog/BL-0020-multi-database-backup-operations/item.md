---
id: BL-0020
title: Backup-Operationen fuer einzelne oder alle Tankdatenbanken
status: done
priority: P2
type: improvement
tags: [backup, restore, operations, safety, 'lane:release-blocking']
created: 2026-03-17
updated: 2026-03-18
related:
  - POL-003
---
**Stand:** 2026-03-18

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
- Reproduzierbarer Backup-Index mit Integritaets-/Metadaten je Lauf.
- Dry-Run- und Fehlerpfad-Strategie fuer sichere Operationen.
- Dokumentierte Restore-Grenzen gemaess `POL-003`.

Out of Scope:
- Unkontrollierte Massen-Exports ohne Retention-/Privacy-Regeln.
- Ersatz der bestehenden Release-/Snapshot-Mechanik.
- Harte Runtime-Abhaengigkeit von externen Cloud-/Sync-Diensten.

# Risks
- Fehlkonfiguration kann zu unvollstaendigen Sicherungen fuehren.
- Hoeherer Storage-Bedarf bei parallelen Einzel- und Sammelbackups.

# Output
Release-blocking Operations-Block fuer `1.2.0` ist geliefert:
- operativer Runner `scripts/db_backup_ops.sh` (single/all, dry-run, retention);
- Integritaetsmetadaten und Laufindex unter `.backup/db_ops/`;
- Regression-Check `tests/regression/run_db_backup_ops_check.sh`
  (in `make verify` verankert).

# Derived Tasks
- `TSK-0008` - Multi-DB-Backup-Operations-Contract und Guardrails definieren. (done)
- `TSK-0009` - Multi-DB-Backup-Runner und Regression-Nachweise liefern. (done)
