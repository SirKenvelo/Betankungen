#!/usr/bin/env bash
set -euo pipefail

# db_backup_ops.sh
# CREATED: 2026-03-18
# UPDATED: 2026-03-18
# Operative DB-Backups (single/all) mit Integritaetsmetadaten und Laufindex.

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

OUT_ROOT="$ROOT_DIR/.backup/db_ops"
NOTE=""
MODE=""
SOURCE_DIR=""
DRY_RUN=false
KEEP_COUNT=20

declare -a DB_INPUTS=()
declare -a SOURCES=()
declare -a TARGET_NAMES=()
declare -a TARGET_HASHES=()
declare -a TARGET_SIZES=()

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - DB-Backups fuer einzelne oder mehrere Betankungen-Datenbanken

Usage:
  $SCRIPT_NAME [scope] [options]

Scope (genau eins):
  --db FILE            einzelne Datenbank sichern (mehrfach nutzbar)
  --all                alle erkannten *.db-Dateien unter --source-dir sichern

Options:
  --source-dir DIR     Suchwurzel fuer --all (Default: XDG Betankungen-Datenpfad)
  --out-root DIR       Zielwurzel fuer Backup-Laeufe (Default: .backup/db_ops)
  --note TEXT          optionale Notiz fuer Index/Metadaten
  -k, --keep N         Anzahl Laeufe behalten (Default: 20)
  -n, --dry-run        nur anzeigen, nichts schreiben
  -h, --help           Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME --db ~/.local/share/Betankungen/betankungen.db
  $SCRIPT_NAME --db data/a.db --db data/b.db --note "manueller Sicherungslauf"
  $SCRIPT_NAME --all --source-dir /srv/betankungen --keep 30
  $SCRIPT_NAME --all --source-dir /srv/betankungen --dry-run
EOF_USAGE
}

die() {
  printf '[FAIL] %s\n' "$*" >&2
  exit 1
}

info() {
  printf '[INFO] %s\n' "$*"
}

ok() {
  printf '[OK] %s\n' "$*"
}

is_posint() {
  [[ "${1:-}" =~ ^[1-9][0-9]*$ ]]
}

default_source_dir() {
  if [[ -n "${XDG_DATA_HOME:-}" ]]; then
    printf '%s/Betankungen\n' "$XDG_DATA_HOME"
  else
    printf '%s/.local/share/Betankungen\n' "$HOME"
  fi
}

canonical_file() {
  local raw="$1"
  local d b
  d="$(cd "$(dirname "$raw")" && pwd -P)" || return 1
  b="$(basename "$raw")"
  printf '%s/%s\n' "$d" "$b"
}

canonical_path_any() {
  local p="$1"
  if [[ "$p" == /* ]]; then
    printf '%s\n' "${p%/}"
  else
    printf '%s/%s\n' "$PWD" "${p#./}"
  fi
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

file_size_bytes() {
  local f="$1"
  if stat -c %s "$f" >/dev/null 2>&1; then
    stat -c %s "$f"
  else
    stat -f %z "$f"
  fi
}

sanitize_name() {
  local s="$1"
  s="${s//\//__}"
  s="${s// /_}"
  s="${s//:/_}"
  s="$(printf '%s' "$s" | tr -cd 'A-Za-z0-9._-')"
  [[ -n "$s" ]] || s="db"
  printf '%s\n' "$s"
}

snapshot_id_pattern() {
  printf '%s\n' '^[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{6}(_[0-9]{2})?$'
}

list_run_ids_desc() {
  local pat
  pat="$(snapshot_id_pattern)"
  find "$OUT_ROOT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
    | grep -E "$pat" \
    | sort -r || true
}

prune_index_to_existing_runs() {
  local updated_ts="$1"
  python3 - <<'PY' "$OUT_ROOT/index.json" "$OUT_ROOT" "$updated_ts"
import json
import pathlib
import re
import sys

index_file = pathlib.Path(sys.argv[1])
out_root = pathlib.Path(sys.argv[2])
updated_ts = sys.argv[3]

if not index_file.exists():
    raise SystemExit(0)

try:
    data = json.loads(index_file.read_text())
except Exception:
    data = {"schema": "db_backup_ops_index_v1", "updated": updated_ts, "entries": []}

if not isinstance(data, dict):
    data = {"schema": "db_backup_ops_index_v1", "updated": updated_ts, "entries": []}

entries = data.get("entries", [])
if not isinstance(entries, list):
    entries = []

pat = re.compile(r"^\d{4}-\d{2}-\d{2}_\d{6}(_\d{2})?$")
existing = {p.name for p in out_root.iterdir() if p.is_dir() and pat.match(p.name)}
entries = [e for e in entries if isinstance(e, dict) and str(e.get("id", "")) in existing]
entries = sorted(entries, key=lambda e: str(e.get("id", "")), reverse=True)

data["schema"] = data.get("schema", "db_backup_ops_index_v1")
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

  mapfile -t ids < <(list_run_ids_desc)
  if (( ${#ids[@]} <= keep )); then
    info "Retention: ${#ids[@]} Lauf/Laeufe vorhanden, Keep=$keep (keine Loeschung)."
    return
  fi

  for (( i = keep; i < ${#ids[@]}; i += 1 )); do
    rm -rf "$OUT_ROOT/${ids[$i]}"
    info "Retention: alter Lauf entfernt: $OUT_ROOT/${ids[$i]}"
  done

  prune_index_to_existing_runs "$updated_ts"
}

next_snapshot_id() {
  local base stamp n
  base="$(date '+%Y-%m-%d_%H%M%S')"
  stamp="$base"
  n=1
  while [[ -e "$OUT_ROOT/$stamp" || -e "$OUT_ROOT/.tmp_$stamp" || -e "$OUT_ROOT/.tmp_${stamp}_$n" ]]; do
    stamp="$(printf '%s_%02d' "$base" "$n")"
    n=$((n + 1))
  done
  printf '%s\n' "$stamp"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --db)
      [[ $# -ge 2 ]] || die "Option --db braucht eine Datei."
      DB_INPUTS+=("$2")
      shift 2
      ;;
    --all)
      MODE="all"
      shift
      ;;
    --source-dir)
      [[ $# -ge 2 ]] || die "Option --source-dir braucht ein Verzeichnis."
      SOURCE_DIR="$2"
      shift 2
      ;;
    --out-root)
      [[ $# -ge 2 ]] || die "Option --out-root braucht ein Verzeichnis."
      OUT_ROOT="$2"
      shift 2
      ;;
    --note)
      [[ $# -ge 2 ]] || die "Option --note braucht einen Text."
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

if (( ${#DB_INPUTS[@]} > 0 )); then
  [[ "$MODE" != "all" ]] || die "Genau eine Scope-Variante erlaubt: --db oder --all."
  MODE="db"
fi

[[ "$MODE" == "db" || "$MODE" == "all" ]] || die "Genau eine Scope-Variante erforderlich: --db oder --all."
is_posint "$KEEP_COUNT" || die "Ungueltiger Wert fuer --keep: $KEEP_COUNT (erwartet: >= 1)"

if [[ "$MODE" == "all" ]]; then
  [[ -n "$SOURCE_DIR" ]] || SOURCE_DIR="$(default_source_dir)"
  SOURCE_DIR="$(canonical_path_any "$SOURCE_DIR")"
  [[ -d "$SOURCE_DIR" ]] || die "source-dir nicht gefunden: $SOURCE_DIR"

  while IFS= read -r -d '' db_file; do
    SOURCES+=("$db_file")
  done < <(find "$SOURCE_DIR" -maxdepth 3 -type f -name '*.db' -print0 | sort -z)

  ((${#SOURCES[@]} > 0)) || die "Keine *.db-Dateien unter --source-dir gefunden: $SOURCE_DIR"
else
  for raw in "${DB_INPUTS[@]}"; do
    db_file="$(canonical_file "$raw")" || die "DB-Pfad nicht lesbar: $raw"
    [[ -f "$db_file" ]] || die "DB-Datei nicht gefunden: $db_file"
    SOURCES+=("$db_file")
  done
fi

# Duplikate entfernen, Reihenfolge stabil halten.
declare -A seen=()
declare -a dedup_sources=()
for src in "${SOURCES[@]}"; do
  [[ -r "$src" ]] || die "DB-Datei nicht lesbar: $src"
  if [[ -z "${seen[$src]:-}" ]]; then
    dedup_sources+=("$src")
    seen[$src]=1
  fi
done
SOURCES=("${dedup_sources[@]}")

OUT_ROOT="$(canonical_path_any "$OUT_ROOT")"
STAMP="$(next_snapshot_id)"
TS="$(date '+%Y-%m-%d %H:%M:%S')"
RUN_DIR="$OUT_ROOT/$STAMP"
WORK_DIR="$OUT_ROOT/.tmp_$STAMP"
WORK_DATA_DIR="$WORK_DIR/databases"
WORK_META_FILE="$WORK_DIR/metadata.json"
WORK_FILES_TSV="$WORK_DIR/files.tsv"
INDEX_FILE="$OUT_ROOT/index.json"

cleanup_workdir() {
  if [[ -d "$WORK_DIR" ]]; then
    rm -rf "$WORK_DIR"
  fi
}

if $DRY_RUN; then
  info "Dry-Run aktiv"
  info "Mode: $MODE"
  if [[ "$MODE" == "all" ]]; then
    info "Source-Dir: $SOURCE_DIR"
  fi
  info "Zielwurzel: $OUT_ROOT"
  info "Lauf-ID: $STAMP"
  for src in "${SOURCES[@]}"; do
    info "wuerde sichern: $src"
  done
  info "wuerde Metadaten schreiben: $RUN_DIR/metadata.json"
  info "wuerde Index aktualisieren: $INDEX_FILE"
  info "wuerde Retention anwenden: keep=$KEEP_COUNT"
  exit 0
fi

mkdir -p "$OUT_ROOT" "$WORK_DATA_DIR"
trap cleanup_workdir EXIT

for i in "${!SOURCES[@]}"; do
  src="${SOURCES[$i]}"
  if [[ "$MODE" == "all" ]]; then
    rel="${src#"$SOURCE_DIR"/}"
  else
    rel="$(basename "$src")"
  fi

  safe_rel="$(sanitize_name "$rel")"
  target_name="$(printf '%02d_%s' "$((i + 1))" "$safe_rel")"
  target_path="$WORK_DATA_DIR/$target_name"

  cp "$src" "$target_path"

  file_hash="$(sha256_file "$target_path")"
  file_size="$(file_size_bytes "$target_path")"
  TARGET_NAMES+=("$target_name")
  TARGET_HASHES+=("$file_hash")
  TARGET_SIZES+=("$file_size")
  printf '%s\t%s\t%s\t%s\n' \
    "$src" \
    "$target_name" \
    "$file_hash" \
    "$file_size" >>"$WORK_FILES_TSV"
done

python3 - <<'PY' \
  "$WORK_META_FILE" "$WORK_FILES_TSV" "$TS" "$STAMP" "$MODE" "$NOTE" "${SOURCE_DIR:-}"
import json
import pathlib
import sys

meta_file = pathlib.Path(sys.argv[1])
files_tsv = sys.argv[2]
created_at = sys.argv[3]
snapshot_id = sys.argv[4]
mode = sys.argv[5]
note = sys.argv[6]
source_dir = sys.argv[7]

files = []
with open(files_tsv, "r", encoding="utf-8") as fh:
    lines = [ln.rstrip("\n") for ln in fh if ln.strip()]

for line in lines:
    parts = line.split("\t")
    if len(parts) != 4:
        raise SystemExit(f"Metadaten-Konsistenzfehler in files.tsv: {line!r}")

    source_path, target_name, sha256, size_raw = parts
    files.append(
        {
            "source_path": source_path,
            "backup_file": f"databases/{target_name}",
            "sha256": sha256,
            "size_bytes": int(size_raw),
        }
    )

meta = {
    "id": snapshot_id,
    "created_at": created_at,
    "mode": mode,
    "source_dir": source_dir if mode == "all" else None,
    "note": note,
    "files": files,
}

meta_file.write_text(json.dumps(meta, ensure_ascii=False, indent=2) + "\n")
PY

mv "$WORK_DIR" "$RUN_DIR"
trap - EXIT

RUN_PATH_REL="${RUN_DIR#$ROOT_DIR/}"
python3 - <<'PY' \
  "$INDEX_FILE" "$TS" "$STAMP" "$MODE" "$NOTE" "$RUN_PATH_REL" "${#SOURCES[@]}"
import json
import pathlib
import sys

index_file = pathlib.Path(sys.argv[1])
updated = sys.argv[2]
snapshot_id = sys.argv[3]
mode = sys.argv[4]
note = sys.argv[5]
path_rel = sys.argv[6]
sources_total = int(sys.argv[7])

entry = {
    "id": snapshot_id,
    "created_at": updated,
    "mode": mode,
    "sources_total": sources_total,
    "path": path_rel,
    "note": note,
}

data = {"schema": "db_backup_ops_index_v1", "updated": updated, "entries": []}
if index_file.exists():
    try:
        loaded = json.loads(index_file.read_text())
        if isinstance(loaded, dict):
            data["schema"] = loaded.get("schema", "db_backup_ops_index_v1")
            current = loaded.get("entries", [])
            if isinstance(current, list):
                data["entries"] = current
    except Exception:
        pass

entries = [e for e in data["entries"] if isinstance(e, dict) and e.get("id") != snapshot_id]
entries.append(entry)
data["entries"] = sorted(entries, key=lambda e: str(e.get("id", "")), reverse=True)
data["updated"] = updated

index_file.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY

apply_retention "$KEEP_COUNT" "$TS"

ok "DB-Backup-Lauf erstellt: $RUN_DIR"
ok "Index aktualisiert: $INDEX_FILE"
