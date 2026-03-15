# POL-003: Backup Retention, Restore Boundaries, Privacy
**Stand:** 2026-03-15
**Status:** active
**Datum:** 2026-03-15

## Ziel

Diese Policy definiert einen verbindlichen Mindestrahmen fuer:

- Aufbewahrung (Retention) von Backup-Snapshots
- klare Restore-Grenzen
- Privacy-/Sicherheitsregeln fuer Backup-Artefakte

## Geltungsbereich

- `scripts/backup_snapshot.sh`
- Ordner `.backup/` und `.releases/`
- Release-/Preflight-Dokumentation

## Retention-Regeln

1. Default-Retention
- Standardwert fuer lokale Snapshots bleibt `--keep 10`.
- Abweichungen sind explizit pro Lauf zu setzen (`--keep N`).

2. Bereinigung
- Alte Snapshots ausserhalb des Keep-Fensters werden automatisch entfernt.
- Das zentrale Register `.backup/index.json` muss danach konsistent bleiben.

3. Betriebsdisziplin
- Backup-Laeufe erfolgen reproduzierbar ueber das Skript, nicht manuell.
- Vor Release sind Dry-Runs zulaessig/erwuenscht (`--dry-run`).

## Restore-Grenzen

1. Garantierter Scope
- Snapshot enthaelt Release-Archiv, optionale `release_log.json`-Kopie und
  Metadaten (`metadata.json`).
- Restore ist auf diese Artefakte ausgelegt; kein vollstaendiger
  Systemzustands-Restore.

2. Nicht garantiert
- Keine Wiederherstellung externer Systeme oder geheimer Laufzeitumgebungen.
- Keine implizite Ruecksetzung lokaler Entwicklerzustande.

## Privacy- und Sicherheitsregeln

1. Datenklassifikation
- Backups koennen sensible Projektinformationen enthalten und werden als intern
  behandelt.

2. Veroeffentlichung
- Inhalte aus `.backup/` werden nicht automatisch committed oder publiziert.
- Weitergabe erfolgt nur bewusst und minimal (Need-to-Know).

3. Notizen/Metadaten
- `--note` darf keine Zugangsdaten, Tokens oder personenbezogenen Rohdaten
  enthalten.

## Referenzen

- `scripts/backup_snapshot.sh`
- `docs/RELEASE_0_9_0_PREFLIGHT.md`
- `docs/README.md`
