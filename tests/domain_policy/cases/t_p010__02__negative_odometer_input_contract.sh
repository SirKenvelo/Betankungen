#!/usr/bin/env bash
set -euo pipefail

# t_p010__02__negative_odometer_input_contract.sh
# UPDATED: 2026-03-31
# Negativer odometer_km-Wert fuehrt ueber alle Fuelup-CLI-Pfade in denselben Hard Error ohne Write.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p010_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p010_negative_odometer_XXXXXX)"
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

COUNT_BEFORE="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups;")"

# Input-Mapping:
# 1) station_id
# 2) fueled_at
# 3) odometer_km
INPUT_LINES=(
  '1'
  '2025-02-01 08:00:00'
  '-1'
)

set +e
printf '%s\n' "${INPUT_LINES[@]}" \
  | "$APP_BIN" --db "$DB_POLICY" --add fuelups --car-id 1 >"$OUT_FILE" 2>"$ERR_FILE"
RC=$?
set -e

if [[ $RC -eq 0 ]]; then
  fail 'Erwartet Exitcode != 0 fuer negativen odometer_km, erhalten: 0'
fi

if ! grep -q 'odometer_km muss eine Ganzzahl >= 0 sein' "$ERR_FILE"; then
  fail 'Erwartete Odometer-Untergrenzen-Fehlermeldung nicht gefunden.'
fi

if grep -q 'P-010\|P-011\|P-013' "$ERR_FILE"; then
  fail 'Negativer odometer_km wurde faelschlich als DB-bezogene Odometer-Policy klassifiziert.'
fi

COUNT_AFTER="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups;")"
if [[ "$COUNT_AFTER" != "$COUNT_BEFORE" ]]; then
  fail "Erwartet unveraenderten fuelups-Count ($COUNT_BEFORE), erhalten: $COUNT_AFTER"
fi

printf '[OK] negativer odometer_km fuehrt zum kanonischen Hard Error ohne Insert.\n'
