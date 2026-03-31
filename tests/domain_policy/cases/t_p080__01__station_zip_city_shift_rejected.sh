#!/usr/bin/env bash
set -euo pipefail

# t_p080__01__station_zip_city_shift_rejected.sh
# UPDATED: 2026-03-31
# Policy P-080: offensichtliche zip/city-Feldverschiebung wird geblockt.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p080_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p080_shift_XXXXXX)"
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

COUNT_BEFORE="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM stations;")"

INPUT_LINES=(
  'ShiftStation'
  'Testweg'
  '10'
  'Dortmund'
  '44135'
  ''
  ''
  ''
  ''
  ''
)

set +e
printf '%s\n' "${INPUT_LINES[@]}" \
  | "$APP_BIN" --db "$DB_POLICY" --add stations >"$OUT_FILE" 2>"$ERR_FILE"
RC=$?
set -e

if [[ $RC -eq 0 ]]; then
  fail 'Erwartet Exitcode != 0 fuer P-080, erhalten: 0'
fi

if ! grep -q 'P-080' "$ERR_FILE"; then
  fail 'Erwartete P-080-Fehlermeldung nicht gefunden.'
fi

COUNT_AFTER="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM stations;")"
if [[ "$COUNT_AFTER" != "$COUNT_BEFORE" ]]; then
  fail "Erwartet unveraenderten stations-Count ($COUNT_BEFORE), erhalten: $COUNT_AFTER"
fi

printf '[OK] P-080/01: zip/city-Feldverschiebung wird sauber geblockt.\n'
