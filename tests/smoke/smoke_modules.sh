#!/usr/bin/env bash
set -euo pipefail

# smoke_modules.sh
# UPDATED: 2026-03-15
# Fokus-Smoke fuer Companion-Binary-Contract (`--module-info`) von Modulen.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MODULE_SRC="$ROOT_DIR/src/betankungen-maintenance.lpr"
MODULE_BIN="$ROOT_DIR/bin/betankungen-maintenance"
CORE_BIN="$ROOT_DIR/bin/Betankungen"
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
OUT_ADD="$TMP_DIR/add.out"
ERR_ADD="$TMP_DIR/add.err"
OUT_LIST_ALL="$TMP_DIR/list_all.out"
ERR_LIST_ALL="$TMP_DIR/list_all.err"
OUT_LIST_FILTER="$TMP_DIR/list_filter.out"
ERR_LIST_FILTER="$TMP_DIR/list_filter.err"
OUT_LIST_EMPTY="$TMP_DIR/list_empty.out"
ERR_LIST_EMPTY="$TMP_DIR/list_empty.err"
OUT_STATS_TEXT="$TMP_DIR/stats_text.out"
ERR_STATS_TEXT="$TMP_DIR/stats_text.err"
OUT_STATS_JSON="$TMP_DIR/stats_json.out"
ERR_STATS_JSON="$TMP_DIR/stats_json.err"
OUT_STATS_JSON_PRETTY="$TMP_DIR/stats_json_pretty.out"
ERR_STATS_JSON_PRETTY="$TMP_DIR/stats_json_pretty.err"
OUT_STATS_JSON_SCOPE="$TMP_DIR/stats_json_scope.out"
ERR_STATS_JSON_SCOPE="$TMP_DIR/stats_json_scope.err"
OUT_BAD="$TMP_DIR/bad.out"
ERR_BAD="$TMP_DIR/bad.err"
OUT_FAIL_1="$TMP_DIR/fail_1.out"
ERR_FAIL_1="$TMP_DIR/fail_1.err"
OUT_FAIL_2="$TMP_DIR/fail_2.out"
ERR_FAIL_2="$TMP_DIR/fail_2.err"
OUT_FAIL_3="$TMP_DIR/fail_3.out"
ERR_FAIL_3="$TMP_DIR/fail_3.err"
OUT_FAIL_4="$TMP_DIR/fail_4.out"
ERR_FAIL_4="$TMP_DIR/fail_4.err"
OUT_CORE_COST_JSON="$TMP_DIR/core_cost_json.out"
ERR_CORE_COST_JSON="$TMP_DIR/core_cost_json.err"
BUILD_LOG="$TMP_DIR/build.log"
MIGRATE_DB="$TMP_DIR/maintenance_module_test.db"
CORE_DB="$TMP_DIR/core_cost_integration.db"

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

expect_cli_fail() {
  local out_file="$1"
  local err_file="$2"
  local rc
  shift 2

  set +e
  "$MODULE_BIN" "$@" >"$out_file" 2>"$err_file"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]]; then
    fail "Erwarteter Fehler blieb aus: $*"
  fi
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

if [[ ! -x "$CORE_BIN" ]]; then
  set +e
  fpc -Mobjfpc -Sh -gl -gw -FE"$ROOT_DIR/bin" -FU"$BUILD_DIR" -Fu"$UNITS_DIR" "$ROOT_DIR/src/Betankungen.lpr" >>"$BUILD_LOG" 2>&1
  RC=$?
  set -e
  if [[ $RC -ne 0 ]] || [[ ! -x "$CORE_BIN" ]]; then
    fail 'Core-Binary konnte fuer Integrationscheck nicht gebaut werden.'
  fi
fi

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
   ! grep -q '^       betankungen-maintenance --add maintenance --car-id <id> --date <YYYY-MM-DD> --type <name> --cost-cents <value> \[--notes <text>\] \[--db <path>\]$' "$OUT_HELP" ||
   ! grep -q '^       betankungen-maintenance --list maintenance \[--car-id <id>\] \[--db <path>\]$' "$OUT_HELP" ||
   ! grep -q '^       betankungen-maintenance --stats maintenance \[--car-id <id>\] \[--json \[--pretty\]\] \[--db <path>\]$' "$OUT_HELP" ||
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
   ! grep -q '"module_name":"maintenance"' "$OUT_INFO" ||
   ! grep -q '"module_version":"' "$OUT_INFO" ||
   ! grep -q '"min_core_version":"' "$OUT_INFO" ||
   ! grep -q '"db_schema_version":' "$OUT_INFO" ||
   ! grep -q '"capabilities":{' "$OUT_INFO" ||
   ! grep -q '"supports_migrate":true' "$OUT_INFO" ||
   ! grep -q '"supports_add_maintenance":true' "$OUT_INFO" ||
   ! grep -q '"supports_list_maintenance":true' "$OUT_INFO" ||
   ! grep -q '"supports_stats_maintenance":true' "$OUT_INFO" ||
   ! grep -q '"supports_stats_json":true' "$OUT_INFO" ||
   ! grep -q '"supports_stats_pretty":true' "$OUT_INFO" ||
   ! grep -q '"supports_car_scope":true' "$OUT_INFO" ||
   ! grep -q '"supports_period_scope":false' "$OUT_INFO"; then
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
   ! grep -Eq '^  "db_schema_version": [0-9]+,$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^  "capabilities": {$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^    "supports_migrate": true,$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^    "supports_add_maintenance": true,$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^    "supports_list_maintenance": true,$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^    "supports_stats_maintenance": true,$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^    "supports_stats_json": true,$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^    "supports_stats_pretty": true,$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^    "supports_car_scope": true,$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^    "supports_period_scope": false$' "$OUT_INFO_PRETTY" ||
   ! grep -q '^  }$' "$OUT_INFO_PRETTY" ||
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
"$MODULE_BIN" --add maintenance --db "$MIGRATE_DB" --car-id 2 --date 2025-03-14 --type service --cost-cents 12345 --notes "smoke-add" >"$OUT_ADD" 2>"$ERR_ADD"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^\[OK\] maintenance_event_id=[0-9][0-9]*$' "$OUT_ADD" ||
   ! grep -q "^\[OK\] db=$MIGRATE_DB$" "$OUT_ADD"; then
  fail '--add maintenance fehlgeschlagen oder Output-Contract instabil.'
fi
if [[ "$(sqlite3 "$MIGRATE_DB" "SELECT COUNT(*) FROM maintenance_events;")" != "1" ]]; then
  fail '--add maintenance: maintenance_events count ist nicht 1.'
fi
if [[ "$(sqlite3 "$MIGRATE_DB" "SELECT car_id || '|' || event_date || '|' || event_type || '|' || cost_cents || '|' || COALESCE(notes,'') FROM maintenance_events LIMIT 1;")" != "2|2025-03-14|service|12345|smoke-add" ]]; then
  fail '--add maintenance: gespeicherte Werte weichen vom Contract ab.'
fi
printf '[OK] Modules: --add maintenance speichert Event\n'

set +e
"$MODULE_BIN" --list maintenance --db "$MIGRATE_DB" >"$OUT_LIST_ALL" 2>"$ERR_LIST_ALL"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^Maintenance Events$' "$OUT_LIST_ALL" ||
   ! grep -q '^Scope: all cars$' "$OUT_LIST_ALL" ||
   ! grep -q '^id | car_id | event_date | event_type | cost_cents | notes$' "$OUT_LIST_ALL" ||
   ! grep -Eq '^[0-9]+ \| 2 \| 2025-03-14 \| service \| 12345 \| smoke-add$' "$OUT_LIST_ALL"; then
  fail '--list maintenance (all) verletzt den Text-Contract.'
fi
printf '[OK] Modules: --list maintenance (all cars)\n'

set +e
"$MODULE_BIN" --list maintenance --db "$MIGRATE_DB" --car-id 2 >"$OUT_LIST_FILTER" 2>"$ERR_LIST_FILTER"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^Scope: car_id=2$' "$OUT_LIST_FILTER" ||
   ! grep -Eq '^[0-9]+ \| 2 \| 2025-03-14 \| service \| 12345 \| smoke-add$' "$OUT_LIST_FILTER"; then
  fail '--list maintenance --car-id 2 verletzt den Filter-Contract.'
fi
printf '[OK] Modules: --list maintenance --car-id (scoped)\n'

set +e
"$MODULE_BIN" --list maintenance --db "$MIGRATE_DB" --car-id 999 >"$OUT_LIST_EMPTY" 2>"$ERR_LIST_EMPTY"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^Scope: car_id=999$' "$OUT_LIST_EMPTY" ||
   ! grep -q '^No maintenance events found\.$' "$OUT_LIST_EMPTY"; then
  fail '--list maintenance --car-id 999 muss leer, aber erfolgreich sein.'
fi
printf '[OK] Modules: --list maintenance leerer Scope ist stabil\n'

set +e
"$MODULE_BIN" --add maintenance --db "$MIGRATE_DB" --car-id 5 --date 2025-03-20 --type repair --cost-cents 5000 --notes "scope-case" >"$TMP_DIR/add_2.out" 2>"$TMP_DIR/add_2.err"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail '2. --add maintenance (Scope-Case) fehlgeschlagen.'
fi

set +e
"$MODULE_BIN" --stats maintenance --db "$MIGRATE_DB" >"$OUT_STATS_TEXT" 2>"$ERR_STATS_TEXT"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^Maintenance-Stats (MVP)$' "$OUT_STATS_TEXT" ||
   ! grep -q '^Scope: all cars$' "$OUT_STATS_TEXT" ||
   ! grep -q '^Events total: 2$' "$OUT_STATS_TEXT" ||
   ! grep -q '^Cars total: 2$' "$OUT_STATS_TEXT" ||
   ! grep -q '^Total cost (cents): 17345$' "$OUT_STATS_TEXT" ||
   ! grep -q '^Average cost per event (cents): 8673$' "$OUT_STATS_TEXT"; then
  fail '--stats maintenance (text) verletzt den Contract.'
fi
printf '[OK] Modules: --stats maintenance text\n'

set +e
"$MODULE_BIN" --stats maintenance --db "$MIGRATE_DB" --json >"$OUT_STATS_JSON" 2>"$ERR_STATS_JSON"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '"contract_version":1' "$OUT_STATS_JSON" ||
   ! grep -q '"kind":"maintenance_stats_v1"' "$OUT_STATS_JSON" ||
   ! grep -q '"app_version":"' "$OUT_STATS_JSON" ||
   ! grep -q '"maintenance":{' "$OUT_STATS_JSON" ||
   ! grep -q '"scope_mode":"all_cars"' "$OUT_STATS_JSON" ||
   ! grep -q '"events_total":2' "$OUT_STATS_JSON" ||
   ! grep -q '"cars_total":2' "$OUT_STATS_JSON" ||
   ! grep -q '"total_cost_cents":17345' "$OUT_STATS_JSON" ||
   ! grep -q '"avg_cost_per_event_cents":8673' "$OUT_STATS_JSON"; then
  fail '--stats maintenance --json verletzt den Contract.'
fi
printf '[OK] Modules: --stats maintenance --json compact\n'

set +e
"$MODULE_BIN" --stats maintenance --db "$MIGRATE_DB" --json --pretty >"$OUT_STATS_JSON_PRETTY" 2>"$ERR_STATS_JSON_PRETTY"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^{$' "$OUT_STATS_JSON_PRETTY" ||
   ! grep -q '^  "contract_version": 1,$' "$OUT_STATS_JSON_PRETTY" ||
   ! grep -q '^  "kind": "maintenance_stats_v1",$' "$OUT_STATS_JSON_PRETTY" ||
   ! grep -q '^  "maintenance": {$' "$OUT_STATS_JSON_PRETTY" ||
   ! grep -q '^    "scope_mode": "all_cars",$' "$OUT_STATS_JSON_PRETTY" ||
   ! grep -q '^    "events_total": 2,$' "$OUT_STATS_JSON_PRETTY" ||
   ! grep -q '^    "cars_total": 2,$' "$OUT_STATS_JSON_PRETTY" ||
   ! grep -q '^    "total_cost_cents": 17345,$' "$OUT_STATS_JSON_PRETTY"; then
  fail '--stats maintenance --json --pretty verletzt den Contract.'
fi
printf '[OK] Modules: --stats maintenance --json --pretty\n'

set +e
"$MODULE_BIN" --stats maintenance --db "$MIGRATE_DB" --car-id 2 --json >"$OUT_STATS_JSON_SCOPE" 2>"$ERR_STATS_JSON_SCOPE"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '"scope_mode":"single_car"' "$OUT_STATS_JSON_SCOPE" ||
   ! grep -q '"scope_car_id":2' "$OUT_STATS_JSON_SCOPE" ||
   ! grep -q '"events_total":1' "$OUT_STATS_JSON_SCOPE" ||
   ! grep -q '"cars_total":1' "$OUT_STATS_JSON_SCOPE" ||
   ! grep -q '"total_cost_cents":12345' "$OUT_STATS_JSON_SCOPE" ||
   ! grep -q '"avg_cost_per_event_cents":12345' "$OUT_STATS_JSON_SCOPE"; then
  fail '--stats maintenance --car-id <id> verletzt den Scope-Contract.'
fi
printf '[OK] Modules: --stats maintenance --car-id scoped JSON\n'

mkdir -p "$TMP_DIR/home_core"
set +e
BETANKUNGEN_MAINTENANCE_BIN="$MODULE_BIN" \
BETANKUNGEN_MAINTENANCE_DB="$MIGRATE_DB" \
HOME="$TMP_DIR/home_core" \
  "$CORE_BIN" --db "$CORE_DB" --stats cost --json --maintenance-source module >"$OUT_CORE_COST_JSON" 2>"$ERR_CORE_COST_JSON"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '"kind":"cost_mvp"' "$OUT_CORE_COST_JSON" ||
   ! grep -q '"maintenance_source_mode":"module"' "$OUT_CORE_COST_JSON" ||
   ! grep -q '"maintenance_source_active":true' "$OUT_CORE_COST_JSON" ||
   ! grep -q '"maintenance_source_note":"module stats loaded' "$OUT_CORE_COST_JSON" ||
   ! grep -q '"maintenance_cents_total":17345' "$OUT_CORE_COST_JSON" ||
   ! grep -q '"total_cents":17345' "$OUT_CORE_COST_JSON"; then
  fail 'Core-Integration mit --maintenance-source module verletzt den Cost-Contract.'
fi
printf '[OK] Modules: Core-Integration --stats cost --maintenance-source module (JSON)\n'

expect_cli_fail "$OUT_FAIL_1" "$ERR_FAIL_1" --stats maintenance --pretty --db "$MIGRATE_DB"
if ! grep -q -- '--pretty ist nur zusammen mit --module-info oder --stats maintenance --json erlaubt' "$ERR_FAIL_1"; then
  fail '--stats maintenance --pretty ohne --json muss klaren Validierungsfehler liefern.'
fi
printf '[OK] Modules: --stats maintenance --pretty ohne --json -> Validierungsfehler\n'

expect_cli_fail "$OUT_FAIL_2" "$ERR_FAIL_2" --stats maintenance --db "$MIGRATE_DB" --date 2025-03-14
if ! grep -q -- '--date ist fuer --stats maintenance nicht erlaubt' "$ERR_FAIL_2"; then
  fail '--stats maintenance --date muss klaren Validierungsfehler liefern.'
fi
printf '[OK] Modules: --stats maintenance --date -> Validierungsfehler\n'

expect_cli_fail "$OUT_FAIL_3" "$ERR_FAIL_3" --stats maintenance --db "$MIGRATE_DB" --cost-cents 1
if ! grep -q -- '--cost-cents ist fuer --stats maintenance nicht erlaubt' "$ERR_FAIL_3"; then
  fail '--stats maintenance --cost-cents muss klaren Validierungsfehler liefern.'
fi
printf '[OK] Modules: --stats maintenance --cost-cents -> Validierungsfehler\n'

expect_cli_fail "$OUT_FAIL_4" "$ERR_FAIL_4" --module-info --json
if ! grep -q -- '--json ist nur zusammen mit --stats maintenance erlaubt' "$ERR_FAIL_4"; then
  fail '--module-info --json muss klaren Validierungsfehler liefern.'
fi
printf '[OK] Modules: --module-info --json -> Validierungsfehler\n'

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
