#!/usr/bin/env bash
set -euo pipefail

# backup_snapshot.sh
# UPDATED: 2026-02-13
# Erstellt einen Snapshot in .backup/YYYY-MM-DD_HHMM und pflegt .backup/index.json.

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_ROOT="$ROOT_DIR/.backup"
RELEASE_DIR="$ROOT_DIR/.releases"
INDEX_FILE="$BACKUP_ROOT/index.json"

ARCHIVE_INPUT=""
NOTE=""
DRY_RUN=false

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Backup-Snapshot von Release-Artefakten erstellen

Usage:
  $SCRIPT_NAME [options]

Options:
  -a, --archive FILE    Release-Archiv waehlen (Default: neuestes .releases/Betankungen_*.tar)
  --note TEXT           Optionaler Kommentar fuer index/metadaten
  -n, --dry-run         Nur anzeigen, nichts schreiben
  -h, --help            Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --archive .releases/Betankungen_0_5_2.tar --note "Vor Hotfix"
  $SCRIPT_NAME --dry-run
EOF_USAGE
}

die() {
  printf 'Fehler: %s\n' "$*" >&2
  exit 1
}

sha256_file() {
  local f="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$f" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$f" | awk '{print $1}'
  else
    die "Kein SHA-256 Tool gefunden (sha256sum/shasum)."
  fi
}

resolve_archive() {
  local input="$1"

  if [[ -n "$input" ]]; then
    if [[ -f "$input" ]]; then
      printf '%s\n' "$input"
      return
    fi
    if [[ -f "$RELEASE_DIR/$input" ]]; then
      printf '%s\n' "$RELEASE_DIR/$input"
      return
    fi
    die "Archiv nicht gefunden: $input"
  fi

  local latest
  latest="$(find "$RELEASE_DIR" -maxdepth 1 -type f -name 'Betankungen_*.tar' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | awk '{print $2}')"
  [[ -n "$latest" ]] || die "Kein Release-Archiv in $RELEASE_DIR gefunden."
  printf '%s\n' "$latest"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--archive)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument (Datei)."
      ARCHIVE_INPUT="$2"
      shift 2
      ;;
    --note)
      [[ $# -ge 2 ]] || die "Option $1 braucht einen Text."
      NOTE="$2"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unbekannte Option: $1 (nutze --help)"
      ;;
  esac
done

[[ -d "$RELEASE_DIR" ]] || die ".releases/ nicht gefunden."
mkdir -p "$BACKUP_ROOT"

ARCHIVE_PATH="$(resolve_archive "$ARCHIVE_INPUT")"
ARCHIVE_NAME="$(basename "$ARCHIVE_PATH")"
STAMP="$(date '+%Y-%m-%d_%H%M')"
TS="$(date '+%Y-%m-%d %H:%M:%S')"
TARGET_DIR="$BACKUP_ROOT/$STAMP"
TARGET_ARCHIVE="$TARGET_DIR/$ARCHIVE_NAME"
TARGET_LOG="$TARGET_DIR/release_log.json"
TARGET_META="$TARGET_DIR/metadata.json"

SHA256="$(sha256_file "$ARCHIVE_PATH")"
SIZE_BYTES="$(stat -c %s "$ARCHIVE_PATH")"

if $DRY_RUN; then
  printf 'Dry-Run: wuerde Backup-Verzeichnis anlegen: %s\n' "$TARGET_DIR"
  printf 'Dry-Run: wuerde Archiv kopieren: %s -> %s\n' "$ARCHIVE_PATH" "$TARGET_ARCHIVE"
  if [[ -f "$RELEASE_DIR/release_log.json" ]]; then
    printf 'Dry-Run: wuerde Log kopieren: %s -> %s\n' "$RELEASE_DIR/release_log.json" "$TARGET_LOG"
  else
    printf 'Dry-Run: release_log.json nicht vorhanden, wird ausgelassen.\n'
  fi
  printf 'Dry-Run: wuerde Metadaten schreiben: %s\n' "$TARGET_META"
  printf 'Dry-Run: wuerde Index aktualisieren: %s\n' "$INDEX_FILE"
  exit 0
fi

mkdir -p "$TARGET_DIR"
cp "$ARCHIVE_PATH" "$TARGET_ARCHIVE"
if [[ -f "$RELEASE_DIR/release_log.json" ]]; then
  cp "$RELEASE_DIR/release_log.json" "$TARGET_LOG"
fi

python3 - <<'PY' \
  "$INDEX_FILE" "$TARGET_META" "$TS" "$STAMP" "$ARCHIVE_NAME" "$SHA256" "$SIZE_BYTES" \
  "${ARCHIVE_PATH#$ROOT_DIR/}" "${RELEASE_DIR#$ROOT_DIR/}/release_log.json" "$NOTE"
import json
import pathlib
import sys

index_file = pathlib.Path(sys.argv[1])
meta_file = pathlib.Path(sys.argv[2])
updated = sys.argv[3]
snapshot_id = sys.argv[4]
archive_name = sys.argv[5]
sha256 = sys.argv[6]
size_bytes = int(sys.argv[7])
source_archive = sys.argv[8]
source_release_log = sys.argv[9]
note = sys.argv[10]

entry = {
    "id": snapshot_id,
    "created_at": updated,
    "archive": archive_name,
    "archive_sha256": sha256,
    "archive_size_bytes": size_bytes,
    "path": f".backup/{snapshot_id}",
    "note": note,
}

meta = {
    "id": snapshot_id,
    "created_at": updated,
    "archive": archive_name,
    "archive_sha256": sha256,
    "archive_size_bytes": size_bytes,
    "source_archive": source_archive,
    "source_release_log": source_release_log,
    "note": note,
}
meta_file.write_text(json.dumps(meta, ensure_ascii=False, indent=2) + "\n")

data = {"schema": "backup_index_v1", "updated": updated, "entries": []}
if index_file.exists():
    try:
        loaded = json.loads(index_file.read_text())
        if isinstance(loaded, dict):
            data["schema"] = loaded.get("schema", "backup_index_v1")
            data["entries"] = loaded.get("entries", []) if isinstance(loaded.get("entries", []), list) else []
    except Exception:
        pass

entries = [e for e in data["entries"] if isinstance(e, dict) and e.get("id") != entry.get("id")]
entries.append(entry)
data["entries"] = sorted(entries, key=lambda e: str(e.get("id", "")), reverse=True)
data["updated"] = updated

index_file.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY

printf 'OK: Backup erstellt: %s\n' "$TARGET_DIR"
printf 'Index: %s\n' "$INDEX_FILE"
