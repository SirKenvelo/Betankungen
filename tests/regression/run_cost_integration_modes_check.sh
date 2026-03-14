#!/usr/bin/env bash
set -euo pipefail

# run_cost_integration_modes_check.sh
# CREATED: 2026-03-14
# UPDATED: 2026-03-14
# Validiert den Cost-Integrationscontract fuer beide Modi:
# - none
# - module (aktiv)
# - module (Fallback bei fehlendem Binary)
# - module + period (expliziter Fallback)

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_BIN="$ROOT_DIR/bin/Betankungen"
MODULE_SRC="$ROOT_DIR/src/betankungen-maintenance.lpr"
MODULE_BIN="$ROOT_DIR/bin/betankungen-maintenance"
BUILD_DIR="$ROOT_DIR/build"
UNITS_DIR="$ROOT_DIR/units"
TMP_DIR="$(mktemp -d /tmp/betankungen_cost_modes_XXXXXX)"

BUILD_LOG="$TMP_DIR/module_build.log"
MODULE_DB="$TMP_DIR/maintenance_module.db"
CORE_DB="$TMP_DIR/core_cost.db"

OUT_NONE="$TMP_DIR/cost_none.json"
ERR_NONE="$TMP_DIR/cost_none.err"
OUT_FALLBACK_MISSING="$TMP_DIR/cost_module_fallback_missing_bin.json"
ERR_FALLBACK_MISSING="$TMP_DIR/cost_module_fallback_missing_bin.err"
OUT_MODULE_ACTIVE="$TMP_DIR/cost_module_active.json"
ERR_MODULE_ACTIVE="$TMP_DIR/cost_module_active.err"
OUT_MODULE_PERIOD="$TMP_DIR/cost_module_period_fallback.json"
ERR_MODULE_PERIOD="$TMP_DIR/cost_module_period_fallback.err"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  for f in "$TMP_DIR"/*.err "$BUILD_LOG"; do
    [[ -e "$f" ]] || continue
    [[ -s "$f" ]] || continue
    printf '[INFO] %s:\n' "$(basename "$f")" >&2
    sed -n '1,80p' "$f" >&2
  done
  exit 1
}

require_tool() {
  local tool="$1"
  command -v "$tool" >/dev/null 2>&1 || fail "Benoetigtes Tool fehlt: $tool"
}

run_json_capture() {
  local label="$1"
  local out_file="$2"
  local err_file="$3"
  shift 3
  if "$@" >"$out_file" 2>"$err_file"; then
    printf '[OK] %s\n' "$label"
  else
    fail "$label"
  fi
}

assert_contains() {
  local file="$1"
  local needle="$2"
  local label="$3"
  if grep -q "$needle" "$file"; then
    printf '[OK] %s\n' "$label"
  else
    fail "$label (Pattern fehlt: $needle)"
  fi
}

require_tool fpc
require_tool sqlite3
[[ -x "$CORE_BIN" ]] || fail "Core-Binary fehlt oder ist nicht ausfuehrbar: $CORE_BIN"
[[ -f "$MODULE_SRC" ]] || fail "Companion-Source fehlt: $MODULE_SRC"

mkdir -p "$ROOT_DIR/bin" "$BUILD_DIR" "$UNITS_DIR"

set +e
fpc -Mobjfpc -Sh -gl -gw -FE"$ROOT_DIR/bin" -FU"$BUILD_DIR" -Fu"$UNITS_DIR" "$MODULE_SRC" >"$BUILD_LOG" 2>&1
RC=$?
set -e
if [[ $RC -ne 0 ]] || [[ ! -x "$MODULE_BIN" ]]; then
  fail 'Companion-Binary konnte nicht gebaut werden.'
fi
printf '[OK] Companion-Build erfolgreich\n'

export HOME="$TMP_DIR/home"
export XDG_CONFIG_HOME="$TMP_DIR/config"
export XDG_DATA_HOME="$TMP_DIR/data"
mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"

run_json_capture \
  'Maintenance DB migrate' \
  "$TMP_DIR/module_migrate.out" \
  "$TMP_DIR/module_migrate.err" \
  "$MODULE_BIN" --migrate --db "$MODULE_DB"

run_json_capture \
  'Maintenance event add #1' \
  "$TMP_DIR/module_add_1.out" \
  "$TMP_DIR/module_add_1.err" \
  "$MODULE_BIN" --add maintenance --db "$MODULE_DB" --car-id 2 --date 2025-03-14 --type service --cost-cents 12345 --notes "integration-a"

run_json_capture \
  'Maintenance event add #2' \
  "$TMP_DIR/module_add_2.out" \
  "$TMP_DIR/module_add_2.err" \
  "$MODULE_BIN" --add maintenance --db "$MODULE_DB" --car-id 5 --date 2025-03-20 --type repair --cost-cents 5000 --notes "integration-b"

if [[ "$(sqlite3 "$MODULE_DB" 'SELECT COUNT(*) FROM maintenance_events;')" != "2" ]]; then
  fail 'Maintenance-Fixture unvollstaendig (events != 2).'
fi
printf '[OK] Maintenance-Fixture erstellt (2 Events)\n'

run_json_capture \
  'Cost mode none' \
  "$OUT_NONE" \
  "$ERR_NONE" \
  "$CORE_BIN" --db "$CORE_DB" --stats cost --json --maintenance-source none

assert_contains "$OUT_NONE" '"maintenance_source_mode":"none"' 'Cost none: source_mode'
assert_contains "$OUT_NONE" '"maintenance_source_active":false' 'Cost none: source_active=false'
assert_contains "$OUT_NONE" '"maintenance_source_note":"core-only mode (none)"' 'Cost none: source_note'
assert_contains "$OUT_NONE" '"maintenance_cents_total":0' 'Cost none: maintenance=0'

run_json_capture \
  'Cost mode module fallback (missing binary)' \
  "$OUT_FALLBACK_MISSING" \
  "$ERR_FALLBACK_MISSING" \
  env BETANKUNGEN_MAINTENANCE_BIN="$TMP_DIR/missing/betankungen-maintenance" \
  "$CORE_BIN" --db "$CORE_DB" --stats cost --json --maintenance-source module

assert_contains "$OUT_FALLBACK_MISSING" '"maintenance_source_mode":"module"' 'Cost fallback missing-bin: source_mode'
assert_contains "$OUT_FALLBACK_MISSING" '"maintenance_source_active":false' 'Cost fallback missing-bin: source_active=false'
assert_contains "$OUT_FALLBACK_MISSING" '"maintenance_source_note":"maintenance companion binary not found:' 'Cost fallback missing-bin: source_note'
assert_contains "$OUT_FALLBACK_MISSING" '"maintenance_cents_total":0' 'Cost fallback missing-bin: maintenance=0'

run_json_capture \
  'Cost mode module active (companion + db override)' \
  "$OUT_MODULE_ACTIVE" \
  "$ERR_MODULE_ACTIVE" \
  env BETANKUNGEN_MAINTENANCE_BIN="$MODULE_BIN" BETANKUNGEN_MAINTENANCE_DB="$MODULE_DB" \
  "$CORE_BIN" --db "$CORE_DB" --stats cost --json --maintenance-source module

assert_contains "$OUT_MODULE_ACTIVE" '"maintenance_source_mode":"module"' 'Cost module active: source_mode'
assert_contains "$OUT_MODULE_ACTIVE" '"maintenance_source_active":true' 'Cost module active: source_active=true'
assert_contains "$OUT_MODULE_ACTIVE" '"maintenance_source_note":"module stats loaded via BETANKUNGEN_MAINTENANCE_DB"' 'Cost module active: source_note'
assert_contains "$OUT_MODULE_ACTIVE" '"maintenance_cents_total":17345' 'Cost module active: maintenance=17345'
assert_contains "$OUT_MODULE_ACTIVE" '"total_cents":17345' 'Cost module active: total=17345'

run_json_capture \
  'Cost mode module + period fallback' \
  "$OUT_MODULE_PERIOD" \
  "$ERR_MODULE_PERIOD" \
  env BETANKUNGEN_MAINTENANCE_BIN="$MODULE_BIN" BETANKUNGEN_MAINTENANCE_DB="$MODULE_DB" \
  "$CORE_BIN" --db "$CORE_DB" --stats cost --json --maintenance-source module --from 2025-01

assert_contains "$OUT_MODULE_PERIOD" '"maintenance_source_mode":"module"' 'Cost module period: source_mode'
assert_contains "$OUT_MODULE_PERIOD" '"maintenance_source_active":false' 'Cost module period: source_active=false'
assert_contains "$OUT_MODULE_PERIOD" '"maintenance_source_note":"module source currently supports no --from/--to; fallback to 0"' 'Cost module period: source_note'
assert_contains "$OUT_MODULE_PERIOD" '"maintenance_cents_total":0' 'Cost module period: maintenance=0'

printf '[OK] Cost-Integrationsmodus-Regression erfolgreich (none/module/fallback).\n'
