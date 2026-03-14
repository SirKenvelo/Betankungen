#!/usr/bin/env bash
set -euo pipefail

# smoke_modules.sh
# UPDATED: 2026-03-14
# Fokus-Smoke fuer Companion-Binary-Contract (`--module-info`) von Modulen.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MODULE_SRC="$ROOT_DIR/src/betankungen-maintenance.lpr"
MODULE_BIN="$ROOT_DIR/bin/betankungen-maintenance"
BUILD_DIR="$ROOT_DIR/build"
UNITS_DIR="$ROOT_DIR/units"

TMP_DIR="$(mktemp -d /tmp/betankungen_smoke_modules_XXXXXX)"
OUT_HELP="$TMP_DIR/help.out"
ERR_HELP="$TMP_DIR/help.err"
OUT_VERSION="$TMP_DIR/version.out"
ERR_VERSION="$TMP_DIR/version.err"
OUT_INFO="$TMP_DIR/info.out"
ERR_INFO="$TMP_DIR/info.err"
OUT_INFO_PRETTY="$TMP_DIR/info_pretty.out"
ERR_INFO_PRETTY="$TMP_DIR/info_pretty.err"
OUT_MIGRATE_1="$TMP_DIR/migrate_1.out"
ERR_MIGRATE_1="$TMP_DIR/migrate_1.err"
OUT_MIGRATE_2="$TMP_DIR/migrate_2.out"
ERR_MIGRATE_2="$TMP_DIR/migrate_2.err"
OUT_BAD="$TMP_DIR/bad.out"
ERR_BAD="$TMP_DIR/bad.err"
BUILD_LOG="$TMP_DIR/build.log"
MIGRATE_DB="$TMP_DIR/maintenance_module_test.db"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'
  exec > >(
    while IFS= read -r line; do
      case "$line" in
        "[OK]"*)
          printf '%b[OK]%b%s\n' "$C_GREEN" "$C_RESET" "${line#\[OK\]}"
          ;;
        "[FAIL]"*)
          printf '%b[FAIL]%b%s\n' "$C_RED" "$C_RESET" "${line#\[FAIL\]}"
          ;;
        "[INFO]"*)
          printf '%b[INFO]%b%s\n' "$C_YELLOW" "$C_RESET" "${line#\[INFO\]}"
          ;;
        *)
          printf '%s\n' "$line"
          ;;
      esac
    done
  )
fi

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf '[FAIL] %s\n' "$1"
  for f in "$TMP_DIR"/*.out "$TMP_DIR"/*.err "$BUILD_LOG"; do
    [[ -e "$f" ]] || continue
    if [[ -s "$f" ]]; then
      printf '[INFO] %s:\n' "$(basename "$f")"
      sed -n '1,120p' "$f"
    fi
  done
  exit 1
}

if [[ ! -f "$MODULE_SRC" ]]; then
  fail "Modul-Source fehlt: $MODULE_SRC"
fi

if ! command -v fpc >/dev/null 2>&1; then
  fail 'FPC Compiler nicht gefunden (erwartet: "fpc" im PATH).'
fi
if ! command -v sqlite3 >/dev/null 2>&1; then
  fail 'sqlite3 nicht gefunden (erwartet fuer Migrationschecks).'
fi

mkdir -p "$ROOT_DIR/bin" "$BUILD_DIR"

set +e
fpc -Mobjfpc -Sh -gl -gw -FE"$ROOT_DIR/bin" -FU"$BUILD_DIR" -Fu"$UNITS_DIR" "$MODULE_SRC" >"$BUILD_LOG" 2>&1
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Companion-Binary konnte nicht gebaut werden.'
fi
printf '[OK] Modules: Build erfolgreich (%s)\n' "src/betankungen-maintenance.lpr"

if [[ ! -x "$MODULE_BIN" ]]; then
  fail "Companion-Binary fehlt nach Build: $MODULE_BIN"
fi

set +e
"$MODULE_BIN" --help >"$OUT_HELP" 2>"$ERR_HELP"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^Usage: betankungen-maintenance --module-info \[--pretty\]$' "$OUT_HELP" ||
   ! grep -q '^       betankungen-maintenance --migrate \[--db <path>\]$' "$OUT_HELP" ||
   ! grep -q '^       betankungen-maintenance --help | --version$' "$OUT_HELP"; then
  fail '--help-Contract des Companion-Binary ist nicht stabil.'
fi
printf '[OK] Modules: --help Contract\n'

set +e
"$MODULE_BIN" --version >"$OUT_VERSION" 2>"$ERR_VERSION"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -Eq '^betankungen-maintenance [0-9]+\.[0-9]+\.[0-9]+([-.][A-Za-z0-9._]+)?$' "$OUT_VERSION"; then
  fail '--version-Contract des Companion-Binary ist nicht stabil.'
fi
printf '[OK] Modules: --version Contract\n'

set +e
"$MODULE_BIN" --module-info >"$OUT_INFO" 2>"$ERR_INFO"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -Eq '^\{"module_name":"maintenance","module_version":"[^"]+","min_core_version":"[^"]+","db_schema_version":[0-9]+\}$' "$OUT_INFO"; then
  fail '--module-info (compact) verletzt den JSON-Minimalcontract.'
fi
printf '[OK] Modules: --module-info compact JSON\n'

set +e
"$MODULE_BIN" --module-info --pretty >"$OUT_INFO_PRETTY" 2>"$ERR_INFO_PRETTY"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^{$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^  "module_name": "maintenance",$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^  "module_version": ' "$OUT_INFO_PRETTY" ||
   ! grep -q '^  "min_core_version": ' "$OUT_INFO_PRETTY" ||
   ! grep -Eq '^  "db_schema_version": [0-9]+$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^}$' "$OUT_INFO_PRETTY"; then
  fail '--module-info --pretty verletzt den JSON-Minimalcontract.'
fi
printf '[OK] Modules: --module-info --pretty JSON\n'

set +e
"$MODULE_BIN" --migrate --db "$MIGRATE_DB" >"$OUT_MIGRATE_1" 2>"$ERR_MIGRATE_1"
RC=$?
set -e
if [[ $RC -ne 0 ]] || [[ ! -f "$MIGRATE_DB" ]]; then
  fail '--migrate Erstlauf fehlgeschlagen.'
fi
if [[ "$(sqlite3 "$MIGRATE_DB" "SELECT value FROM module_meta WHERE key='schema_version' LIMIT 1;")" != "1" ]]; then
  fail '--migrate Erstlauf: schema_version ist nicht 1.'
fi
if [[ "$(sqlite3 "$MIGRATE_DB" "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='maintenance_events';")" != "1" ]]; then
  fail '--migrate Erstlauf: maintenance_events fehlt.'
fi
printf '[OK] Modules: --migrate initialisiert Modul-Schema\n'

set +e
"$MODULE_BIN" --migrate --db "$MIGRATE_DB" >"$OUT_MIGRATE_2" 2>"$ERR_MIGRATE_2"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail '--migrate Re-Run fehlgeschlagen.'
fi
if [[ "$(sqlite3 "$MIGRATE_DB" "SELECT value FROM module_meta WHERE key='schema_version' LIMIT 1;")" != "1" ]]; then
  fail '--migrate Re-Run: schema_version ist nicht stabil auf 1.'
fi
if [[ "$(sqlite3 "$MIGRATE_DB" "SELECT COUNT(*) FROM module_meta WHERE key='schema_version';")" != "1" ]]; then
  fail '--migrate Re-Run: schema_version-Key ist nicht eindeutig.'
fi
printf '[OK] Modules: --migrate ist idempotent\n'

set +e
"$MODULE_BIN" --does-not-exist >"$OUT_BAD" 2>"$ERR_BAD"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'Fehler: unbekannte Option.' "$ERR_BAD" ||
   ! grep -q '^Usage: betankungen-maintenance --module-info \[--pretty\]$' "$OUT_BAD"; then
  fail 'Unknown-Flag-Fehlerpfad des Companion-Binary ist nicht stabil.'
fi
printf '[OK] Modules: unknown flag -> sauberer Fehlerpfad\n'

printf 'Smoke modules erfolgreich.\n'
