#!/usr/bin/env bash
set -euo pipefail

# t_p032__02__price_zero_warn_no.sh
# UPDATED: 2026-02-22
# Policy P-032: price_cents_per_liter <= 0 mit Confirm=NO bricht ab und speichert nicht.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p032_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p032_no_XXXXXX)"
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
# 5) liters
# 6) price_per_liter_eur
# 7) confirm_zero_price_warning (y/n)
INPUT_LINES=(
  '1'
  '2025-02-01 08:00:00'
  '10100'
  '60,00'
  '40,00'
  '0,000'
  'n'
)

set +e
printf '%s\n' "${INPUT_LINES[@]}" \
  | "$APP_BIN" --db "$DB_POLICY" --add fuelups --car-id 1 >"$OUT_FILE" 2>"$ERR_FILE"
RC=$?
set -e

if [[ $RC -eq 0 ]]; then
  fail 'Erwartet Exitcode != 0 bei Confirm=NO, erhalten: 0'
fi

if ! grep -q 'P-032' "$ERR_FILE"; then
  fail 'Erwartete P-032-Fehlermeldung nicht gefunden.'
fi

if ! grep -q 'Abbruch durch Benutzer (Preis/Liter<=0).' "$ERR_FILE"; then
  fail 'Erwartete Abbruchmeldung fuer P-032 nicht gefunden.'
fi

COUNT_AFTER="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups;")"
if [[ "$COUNT_AFTER" != "$COUNT_BEFORE" ]]; then
  fail "Erwartet unveraenderten fuelups-Count ($COUNT_BEFORE), erhalten: $COUNT_AFTER"
fi

printf '[OK] P-032/02: Confirm=NO bricht bei Preis/Liter=0 ab und speichert nicht.\n'
