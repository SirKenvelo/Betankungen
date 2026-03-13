#!/usr/bin/env bash
set -euo pipefail

# t_p061__01__cost_scope_isolation.sh
# UPDATED: 2026-03-13
# Policy P-061: Cost-Stats bleiben strikt in Car-/Period-Scope (keine Cross-Scope-Leaks).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p061_cost_scope_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p061_cost_scope_XXXXXX)"
OUT_FILE_BASE="$TMP_DIR/stdout_base.txt"
ERR_FILE_BASE="$TMP_DIR/stderr_base.txt"
OUT_FILE_PERIOD="$TMP_DIR/stdout_period.txt"
ERR_FILE_PERIOD="$TMP_DIR/stderr_period.txt"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf '[FAIL] %s\n' "$1"
  if [[ -s "$OUT_FILE_BASE" ]]; then
    printf '[INFO] stdout base:\n'
    sed -n '1,140p' "$OUT_FILE_BASE"
  fi
  if [[ -s "$ERR_FILE_BASE" ]]; then
    printf '[INFO] stderr base:\n'
    sed -n '1,140p' "$ERR_FILE_BASE"
  fi
  if [[ -s "$OUT_FILE_PERIOD" ]]; then
    printf '[INFO] stdout period:\n'
    sed -n '1,140p' "$OUT_FILE_PERIOD"
  fi
  if [[ -s "$ERR_FILE_PERIOD" ]]; then
    printf '[INFO] stderr period:\n'
    sed -n '1,140p' "$ERR_FILE_PERIOD"
  fi
  exit 1
}

read_metric() {
  local file="$1"
  local key="$2"
  awk -F': ' -v k="$key" '$1 == k { print $2; exit }' "$file" | tr -d '[:space:]'
}

if [[ ! -x "$APP_BIN" || ! -f "$DB_POLICY" ]]; then
  "$DB_BUILDER" >/dev/null
fi

sqlite3 "$DB_POLICY" < "$FIXTURE_SQL"

set +e
"$APP_BIN" --db "$DB_POLICY" --stats cost --car-id 2 >"$OUT_FILE_BASE" 2>"$ERR_FILE_BASE"
RC_BASE=$?
"$APP_BIN" --db "$DB_POLICY" --stats cost --car-id 2 --from 2024-02 --to 2024-02 >"$OUT_FILE_PERIOD" 2>"$ERR_FILE_PERIOD"
RC_PERIOD=$?
set -e

if [[ $RC_BASE -ne 0 ]]; then
  fail "Erwartet Exitcode 0 fuer Cost-Scope baseline, erhalten: $RC_BASE"
fi
if [[ $RC_PERIOD -ne 0 ]]; then
  fail "Erwartet Exitcode 0 fuer Cost-Scope period, erhalten: $RC_PERIOD"
fi

BASE_TOTAL="$(read_metric "$OUT_FILE_BASE" 'Total cost (cents)')"
BASE_DIST="$(read_metric "$OUT_FILE_BASE" 'Distance (km)')"
BASE_CARS="$(read_metric "$OUT_FILE_BASE" 'Cars total')"
BASE_CYCLES="$(read_metric "$OUT_FILE_BASE" 'Cars with valid full-tank cycles')"

PERIOD_TOTAL="$(read_metric "$OUT_FILE_PERIOD" 'Total cost (cents)')"
PERIOD_DIST="$(read_metric "$OUT_FILE_PERIOD" 'Distance (km)')"
PERIOD_CARS="$(read_metric "$OUT_FILE_PERIOD" 'Cars total')"
PERIOD_CYCLES="$(read_metric "$OUT_FILE_PERIOD" 'Cars with valid full-tank cycles')"

if [[ "$BASE_TOTAL" != "6200" ]]; then
  fail "Baseline total_cents unerwartet: ${BASE_TOTAL:-<leer>} (erwartet 6200)"
fi
if [[ "$BASE_DIST" != "500" ]]; then
  fail "Baseline distance unerwartet: ${BASE_DIST:-<leer>} (erwartet 500)"
fi
if [[ "$BASE_CARS" != "1" || "$BASE_CYCLES" != "1" ]]; then
  fail "Baseline scope counters unerwartet: cars=${BASE_CARS:-<leer>}, cycles=${BASE_CYCLES:-<leer>}"
fi
if ! grep -q '^Scope: car_id=2$' "$OUT_FILE_BASE"; then
  fail 'Baseline Scope-Zeile fehlt oder falsch.'
fi
if ! grep -q '^Period filter: none$' "$OUT_FILE_BASE"; then
  fail 'Baseline Period-Label unerwartet.'
fi

if [[ "$PERIOD_TOTAL" != "0" ]]; then
  fail "Period total_cents unerwartet: ${PERIOD_TOTAL:-<leer>} (erwartet 0)"
fi
if [[ "$PERIOD_DIST" != "0" ]]; then
  fail "Period distance unerwartet: ${PERIOD_DIST:-<leer>} (erwartet 0)"
fi
if [[ "$PERIOD_CARS" != "1" || "$PERIOD_CYCLES" != "0" ]]; then
  fail "Period scope counters unerwartet: cars=${PERIOD_CARS:-<leer>}, cycles=${PERIOD_CYCLES:-<leer>}"
fi
if ! grep -q '^Scope: car_id=2$' "$OUT_FILE_PERIOD"; then
  fail 'Period Scope-Zeile fehlt oder falsch.'
fi
if ! grep -q '^Period filter: 2024-02-01 00:00:00 ... 2024-03-01 00:00:00 (exclusive)$' "$OUT_FILE_PERIOD"; then
  fail 'Period-Label unerwartet fuer --from/--to.'
fi

printf '[OK] P-061/01: Cost-Stats bleiben strikt in Car-/Period-Scope.\n'
