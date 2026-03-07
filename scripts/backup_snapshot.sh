#!/usr/bin/env bash
set -euo pipefail

# backup_snapshot.sh
# UPDATED: 2026-03-07
# Erstellt einen Snapshot in .backup/YYYY-MM-DD_HHMM und pflegt .backup/index.json.

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_ROOT="$ROOT_DIR/.backup"
RELEASE_DIR="$ROOT_DIR/.releases"
INDEX_FILE="$BACKUP_ROOT/index.json"

ARCHIVE_INPUT=""
NOTE=""
DRY_RUN=false
KEEP_COUNT=10

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Backup-Snapshot von Release-Artefakten erstellen

Usage:
  $SCRIPT_NAME [options]

Options:
  -a, --archive FILE    Release-Archiv waehlen (Default: neuestes .releases/Betankungen_*.tar)
  --note TEXT           Optionaler Kommentar fuer index/metadaten
  -k, --keep N          Anzahl Snapshot-Ordner behalten (Default: 10)
  -n, --dry-run         Nur anzeigen, nichts schreiben
  -h, --help            Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --archive .releases/Betankungen_0_5_2.tar --note "Vor Hotfix"
  $SCRIPT_NAME --keep 10
  $SCRIPT_NAME --dry-run
EOF_USAGE
}

die() {
  printf 'Fehler: %s\n' "$*" >&2
  exit 1
}

is_posint() {
  [[ "${1:-}" =~ ^[1-9][0-9]*$ ]]
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

list_snapshot_ids_desc() {
  find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
    | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{4}$' \
    | sort -r || true
}

prune_index_to_existing_snapshots() {
  local updated_ts="$1"
  python3 - <<'PY' "$INDEX_FILE" "$BACKUP_ROOT" "$updated_ts"
import json
import pathlib
import re
import sys

index_file = pathlib.Path(sys.argv[1])
backup_root = pathlib.Path(sys.argv[2])
updated_ts = sys.argv[3]

if not index_file.exists():
    raise SystemExit(0)

try:
    data = json.loads(index_file.read_text())
except Exception:
    data = {"schema": "backup_index_v1", "updated": updated_ts, "entries": []}

if not isinstance(data, dict):
    data = {"schema": "backup_index_v1", "updated": updated_ts, "entries": []}

entries = data.get("entries", [])
if not isinstance(entries, list):
    entries = []

pat = re.compile(r"^\d{4}-\d{2}-\d{2}_\d{4}$")
existing = {p.name for p in backup_root.iterdir() if p.is_dir() and pat.match(p.name)}
entries = [e for e in entries if isinstance(e, dict) and str(e.get("id", "")) in existing]
entries = sorted(entries, key=lambda e: str(e.get("id", "")), reverse=True)

data["schema"] = data.get("schema", "backup_index_v1")
data["updated"] = updated_ts
data["entries"] = entries
index_file.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY
}

apply_retention() {
  local keep="$1"
  local updated_ts="$2"
  local -a ids=()
  local i
  mapfile -t ids < <(list_snapshot_ids_desc)

  if (( ${#ids[@]} <= keep )); then
    printf '[INFO] Retention: %d Snapshot(s) vorhanden, Keep=%d (keine Loeschung).\n' "${#ids[@]}" "$keep"
    return
  fi

  for (( i = keep; i < ${#ids[@]}; i += 1 )); do
    rm -rf "$BACKUP_ROOT/${ids[$i]}"
    printf '[INFO] Retention: alter Snapshot entfernt: %s\n' "$BACKUP_ROOT/${ids[$i]}"
  done

  prune_index_to_existing_snapshots "$updated_ts"
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
    -k|--keep)
      [[ $# -ge 2 ]] || die "Option $1 braucht eine positive Ganzzahl."
      KEEP_COUNT="$2"
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
is_posint "$KEEP_COUNT" || die "Ungueltiger Wert fuer --keep: $KEEP_COUNT (erwartet: >= 1)"

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
  printf 'Dry-Run: wuerde Retention anwenden (keep=%s)\n' "$KEEP_COUNT"
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
apply_retention "$KEEP_COUNT" "$TS"
