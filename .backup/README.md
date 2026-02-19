# Backup-Struktur
**Stand:** 2026-02-13

Dieser Ordner enthaelt manuelle Projekt-Snapshots fuer einen Git-losen Workflow.

## Struktur
- `YYYY-MM-DD_HHMM/`: Ein Snapshot pro Zeitpunkt.
- `index.json`: Zentrales Register aller Snapshots.

## Inhalt eines Snapshots
- `Betankungen_<version>.tar`: Kopie des gewaelten Release-Archivs.
- `release_log.json`: Kopie des aktuellen Release-Logs (falls vorhanden).
- `metadata.json`: Hash, Groesse, Quelle, Zeitstempel, optionale Notiz.

## Erzeugung
- Script: `scripts/backup_snapshot.sh`
- Beispiel: `scripts/backup_snapshot.sh --note "Vor groesserem Umbau"`
