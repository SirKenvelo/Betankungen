#!/usr/bin/env bash
set -euo pipefail

# kpr.sh
# UPDATED: 2026-02-13
# Release-Archiv + Log (Tag-Ersatz ohne Git)

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RELEASE_DIR="$ROOT_DIR/.releases"

APP_VERSION=""
VERSION_TAG=""

if [[ -f "$ROOT_DIR/src/Betankungen.lpr" ]]; then
  APP_VERSION="$(awk -F"'" '/APP_VERSION/ {print $2; exit}' "$ROOT_DIR/src/Betankungen.lpr")"
fi
if [[ -z "$APP_VERSION" ]]; then APP_VERSION="unknown"; fi
VERSION_TAG="${APP_VERSION//./_}"

ARCHIVE_NAME="Betankungen_${VERSION_TAG}.tar"
ARCHIVE_PATH="$RELEASE_DIR/$ARCHIVE_NAME"
LOG_FILE="$RELEASE_DIR/release_log.json"
ARCHIVE_OUT_SET=false

NOTE=""
DRY_RUN=false

usage() {
  cat <<EOF
$SCRIPT_NAME - Release-Archiv erzeugen + Release-Log schreiben

Usage:
  $SCRIPT_NAME [options]

Options:
  -n, --dry-run         Nur anzeigen (kein Archiv/Log wird geschrieben)
  -o, --out FILE        Archivpfad ueberschreiben (Default: $ARCHIVE_PATH)
  --note TEXT           Optionaler Release-Kommentar
  -h, --help            Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --note "Release 0.5.1"
  $SCRIPT_NAME --dry-run
EOF
}

die() {
  printf 'Fehler: %s\n' "$*" >&2
  exit 1
}

json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
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

append_log() {
  local entry="$1"
  if [[ ! -f "$LOG_FILE" || ! -s "$LOG_FILE" ]]; then
    printf '[\n%s\n]\n' "$entry" > "$LOG_FILE"
    return
  fi

  local tmp
  tmp="$(mktemp)"
  python3 - <<'PY' "$LOG_FILE" "$tmp"
import json, sys, pathlib
src = pathlib.Path(sys.argv[1])
dst = pathlib.Path(sys.argv[2])
try:
    data = json.loads(src.read_text())
except Exception:
    data = []
dst.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY

  if grep -q '{' "$tmp"; then
    sed '$d' "$tmp" > "$LOG_FILE"
    printf ',\n%s\n]\n' "$entry" >> "$LOG_FILE"
  else
    printf '[\n%s\n]\n' "$entry" > "$LOG_FILE"
  fi
  rm -f "$tmp"
}

normalize_log() {
  if command -v python3 >/dev/null 2>&1; then
    python3 - <<'PY' "$LOG_FILE"
import json, pathlib, sys
p = pathlib.Path(sys.argv[1])
if not p.exists():
    raise SystemExit(0)
try:
    data = json.loads(p.read_text())
except Exception:
    data = []
p.write_text(json.dumps(data, ensure_ascii=False, separators=(',', ':')) + "\n")
PY
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -o|--out)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument (Archivpfad)."
      ARCHIVE_PATH="$2"
      ARCHIVE_NAME="$(basename "$ARCHIVE_PATH")"
      ARCHIVE_OUT_SET=true
      shift 2
      ;;
    --note)
      [[ $# -ge 2 ]] || die "Option $1 braucht einen Text."
      NOTE="$2"
      shift 2
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

[[ -d "$ROOT_DIR/docs" ]] || die "docs/ nicht gefunden."
[[ -d "$ROOT_DIR/src" ]] || die "src/ nicht gefunden."
[[ -d "$ROOT_DIR/units" ]] || die "units/ nicht gefunden."
mkdir -p "$RELEASE_DIR"

mapfile -d '' FILES < <(cd "$ROOT_DIR" && find docs src units -type f -print0 | sort -z)
(( ${#FILES[@]} > 0 )) || die "Keine Dateien in docs/src/units gefunden."

if $DRY_RUN; then
  printf 'Dry-Run: wuerde Archiv erstellen: %s\n' "$ARCHIVE_PATH"
else
  mkdir -p "$(dirname "$ARCHIVE_PATH")"
  tar -cf "$ARCHIVE_PATH" -C "$ROOT_DIR" docs src units
fi

if $DRY_RUN; then
  printf 'Dry-Run: wuerde release_log.json aktualisieren: %s\n' "$LOG_FILE"
  exit 0
fi

TS="$(date '+%Y-%m-%d %H:%M:%S')"
RUN_ID="$(date '+%Y%m%dT%H%M%S')-$$"
SHA256="$(sha256_file "$ARCHIVE_PATH")"
SIZE_BYTES="$(stat -c %s "$ARCHIVE_PATH")"

FILES_JSON=""
for f in "${FILES[@]}"; do
  esc="$(json_escape "$f")"
  if [[ -n "$FILES_JSON" ]]; then
    FILES_JSON+=", "
  fi
  FILES_JSON+="\"$esc\""
done

NOTE_JSON="$(json_escape "$NOTE")"
SUMMARY_TEXT="Release $APP_VERSION | $ARCHIVE_NAME | sha256=$SHA256 | files=${#FILES[@]} | $TS"
SUMMARY_JSON="$(json_escape "$SUMMARY_TEXT")"

ENTRY="  {\"run_id\":\"$RUN_ID\",\"timestamp\":\"$TS\",\"version\":\"$APP_VERSION\",\"archive\":\"$ARCHIVE_NAME\",\"sha256\":\"$SHA256\",\"size_bytes\":$SIZE_BYTES,\"sources\":[\"docs\",\"src\",\"units\"],\"file_count\":${#FILES[@]},\"files\":[${FILES_JSON}],\"note\":\"$NOTE_JSON\",\"summary\":\"$SUMMARY_JSON\"}"

append_log "$ENTRY"
normalize_log

printf 'OK: %s (sha256=%s)\n' "$ARCHIVE_NAME" "$SHA256"
printf 'Log: %s\n' "$LOG_FILE"
printf 'Summary: %s\n' "$SUMMARY_TEXT"
