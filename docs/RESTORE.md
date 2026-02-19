# Restore-Anleitung
**Stand:** 2026-02-13

Diese Anleitung beschreibt den Wiederherstellungsprozess ohne Git.

## Voraussetzungen
- Verfuegbares Release-Archiv in `.releases/` oder Backup in `.backup/YYYY-MM-DD_HHMM/`.
- `tar` und ein SHA-256 Tool (`sha256sum` oder `shasum`).

## 1. Gewuenschten Stand auswaehlen
- Primärquelle: `.releases/Betankungen_<version>.tar`
- Alternativ: `.backup/YYYY-MM-DD_HHMM/Betankungen_<version>.tar`

Optional:
- Historie in `.releases/release_log.json` oder `.backup/index.json` prüfen.

## 2. Integritaet pruefen
Wenn die SHA-256 Summe bekannt ist:
- `sha256sum <archiv.tar>` oder `shasum -a 256 <archiv.tar>`
- Ergebnis mit dokumentierter Summe vergleichen.

## 3. Wiederherstellen
Im Projektroot ausfuehren:
- `tar -xf <archiv.tar>`

Das Archiv enthaelt standardmaessig:
- `docs/`
- `src/`
- `units/`

## 4. Plausibilitaetscheck
- Build/Run-Test starten (z. B. `bin/Betankungen --version` sofern vorhanden).
- Optional: `tests/smoke_cli.sh` ausfuehren.
- Doku-Stand und `docs/CHANGELOG.md` prüfen.

## 5. Optionalen Backup-Snapshot anlegen
Nach erfolgreichem Restore kann ein Snapshot angelegt werden:
- `scripts/backup_snapshot.sh --note "Nach Restore validiert"`
