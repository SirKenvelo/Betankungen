#!/usr/bin/env bash
set -euo pipefail

# t_p002__01__car_id_missing_fk.sh
# UPDATED: 2026-02-22
# Policy P-002: nicht existente car_id (FK) muss als Hard Error abbrechen (kein Write).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p002_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p002_fk_XXXXXX)"
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

if [[ "$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM cars WHERE id = 1;")" != "1" ]]; then
  fail 'Fixture ungueltig: Default-Car id=1 fehlt.'
fi

COUNT_BEFORE="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups;")"

set +e
"$APP_BIN" --db "$DB_POLICY" --add fuelups --car-id 999999 >"$OUT_FILE" 2>"$ERR_FILE" </dev/null
RC=$?
set -e

if [[ $RC -eq 0 ]]; then
  fail 'Erwartet Exitcode != 0 fuer --car-id 999999, erhalten: 0'
fi

if ! grep -q 'P-002' "$ERR_FILE"; then
  fail 'Erwartete P-002-Fehlermeldung nicht gefunden.'
fi

if grep -q 'P-001' "$ERR_FILE"; then
  fail 'Fehler wurde faelschlich als P-001 klassifiziert.'
fi

COUNT_AFTER="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups;")"
if [[ "$COUNT_AFTER" != "$COUNT_BEFORE" ]]; then
  fail "Erwartet unveraenderten fuelups-Count ($COUNT_BEFORE), erhalten: $COUNT_AFTER"
fi

printf '[OK] P-002/01: --car-id 999999 fuehrt zu FK-Hard-Error ohne Insert.\n'
