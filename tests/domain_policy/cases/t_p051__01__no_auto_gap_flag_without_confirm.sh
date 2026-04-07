#!/usr/bin/env bash
set -euo pipefail

# t_p051__01__no_auto_gap_flag_without_confirm.sh
# UPDATED: 2026-04-07
# Policy P-051: ohne expliziten Ausnahme-Opt-in gibt es bei kleiner Distanz weder Auto-Reset noch P-050-Standardprompt.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p051_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p051_guard_XXXXXX)"
OUT_FILE="$TMP_DIR/stdout.txt"
ERR_FILE="$TMP_DIR/stderr.txt"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf '[FAIL] %s\n' "$1"
  if [[ -s "$OUT_FILE" ]]; then
    printf '[INFO] stdout:\n'
    sed -n '1,140p' "$OUT_FILE"
  fi
  if [[ -s "$ERR_FILE" ]]; then
    printf '[INFO] stderr:\n'
    sed -n '1,140p' "$ERR_FILE"
  fi
  exit 1
}

if [[ ! -x "$APP_BIN" || ! -f "$DB_POLICY" ]]; then
  "$DB_BUILDER" >/dev/null
fi

sqlite3 "$DB_POLICY" < "$FIXTURE_SQL"

# Input-Mapping:
#  1) station_id
#  2) fueled_at
#  3) odometer_km
#  4) total_eur
#  5) liters
#  6) price_per_liter_eur
#  7) is_full_tank (y/n)
#  8) fuel_type (optional)
#  9) payment_type (optional)
# 10) pump_no (optional)
# 11) note (optional)
INPUT_LINES=(
  '1'
  '2025-02-01 08:00:00'
  '10100'
  '60,00'
  '40,00'
  '1,500'
  'y'
  ''
  ''
  ''
  ''
)

set +e
printf '%s\n' "${INPUT_LINES[@]}" \
  | "$APP_BIN" --db "$DB_POLICY" --add fuelups --car-id 1 >"$OUT_FILE" 2>"$ERR_FILE"
RC=$?
set -e

if [[ $RC -ne 0 ]]; then
  fail "Erwartet Exitcode 0, erhalten: $RC"
fi

if grep -q 'P-050:' "$OUT_FILE"; then
  fail 'P-051 verletzt: normaler Kurzdistanz-Fall darf keinen P-050-Prompt mehr zeigen.'
fi

COUNT_ROW="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups WHERE odometer_km = 10100;")"
if [[ "$COUNT_ROW" != "1" ]]; then
  fail "Erwartet genau einen Datensatz fuer odometer_km=10100, erhalten: $COUNT_ROW"
fi

MISSED_PREVIOUS="$(sqlite3 "$DB_POLICY" "SELECT missed_previous FROM fuelups WHERE odometer_km = 10100 LIMIT 1;")"
if [[ "$MISSED_PREVIOUS" != "0" ]]; then
  fail "P-051 verletzt: missed_previous wurde ohne Confirm gesetzt (erhalten=${MISSED_PREVIOUS:-<leer>})."
fi

printf '[OK] P-051/01: ohne --missed-previous bleibt missed_previous=0 und es gibt keinen P-050-Prompt.\n'
