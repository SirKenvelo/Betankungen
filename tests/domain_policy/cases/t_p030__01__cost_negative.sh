#!/usr/bin/env bash
set -euo pipefail

# t_p030__01__cost_negative.sh
# UPDATED: 2026-02-22
# Policy P-030: cost_cents < 0 fuehrt zu Hard Error ohne Write.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p030_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p030_negative_XXXXXX)"
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
# 4) total_eur
INPUT_LINES=(
  '1'
  '2025-02-01 08:00:00'
  '10100'
  '-1,00'
)

set +e
printf '%s\n' "${INPUT_LINES[@]}" \
  | "$APP_BIN" --db "$DB_POLICY" --add fuelups --car-id 1 >"$OUT_FILE" 2>"$ERR_FILE"
RC=$?
set -e

if [[ $RC -eq 0 ]]; then
  fail 'Erwartet Exitcode != 0 fuer P-030, erhalten: 0'
fi

if ! grep -q 'P-030' "$ERR_FILE"; then
  fail 'Erwartete P-030-Fehlermeldung nicht gefunden.'
fi

COUNT_AFTER="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups;")"
if [[ "$COUNT_AFTER" != "$COUNT_BEFORE" ]]; then
  fail "Erwartet unveraenderten fuelups-Count ($COUNT_BEFORE), erhalten: $COUNT_AFTER"
fi

printf '[OK] P-030/01: negativer Gesamtpreis fuehrt zu Hard Error ohne Insert.\n'
