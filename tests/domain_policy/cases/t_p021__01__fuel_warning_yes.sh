#!/usr/bin/env bash
set -euo pipefail

# t_p021__01__fuel_warning_yes.sh
# UPDATED: 2026-02-22
# Policy P-021: liters > 150 mit Confirm=YES speichert normal.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p021_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p021_yes_XXXXXX)"
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
    sed -n '1,120p' "$OUT_FILE"
  fi
  if [[ -s "$ERR_FILE" ]]; then
    printf '[INFO] stderr:\n'
    sed -n '1,120p' "$ERR_FILE"
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
#  6) confirm_large_tank_warning (y/n)
#  7) price_per_liter_eur
#  8) is_full_tank (y/n)
#  9) fuel_type (optional)
# 10) payment_type (optional)
# 11) pump_no (optional)
# 12) note (optional)
INPUT_LINES=(
  '1'
  '2025-02-01 08:00:00'
  '10100'
  '250,00'
  '151,00'
  'y'
  '1,655'
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

if ! grep -q 'P-021: Warnung: Sehr grosse Tankmenge' "$OUT_FILE"; then
  fail 'Erwartete P-021-Warnung nicht gefunden.'
fi

COUNT_ROW="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups WHERE odometer_km = 10100;")"
if [[ "$COUNT_ROW" != "1" ]]; then
  fail "Erwartet genau einen Datensatz fuer odometer_km=10100, erhalten: $COUNT_ROW"
fi

printf '[OK] P-021/01: Confirm=YES speichert nach Fuel-Warnung normal.\n'
