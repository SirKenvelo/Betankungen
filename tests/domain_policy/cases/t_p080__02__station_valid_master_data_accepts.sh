#!/usr/bin/env bash
set -euo pipefail

# t_p080__02__station_valid_master_data_accepts.sh
# UPDATED: 2026-03-31
# Positive Referenz fuer den P-080..P-088-Block: valide Stammdaten werden gespeichert.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p080_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p080_valid_XXXXXX)"
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

INPUT_LINES=(
  'ValidStation'
  'Musterweg'
  '12a'
  '44135'
  'Dortmund'
  '+49 231 123456'
  'TestOwner'
  '51,514200'
  '7.465300'
  '9f4m gc2m+h4'
)

set +e
printf '%s\n' "${INPUT_LINES[@]}" \
  | "$APP_BIN" --db "$DB_POLICY" --add stations >"$OUT_FILE" 2>"$ERR_FILE"
RC=$?
set -e

if [[ $RC -ne 0 ]]; then
  fail "Erwartet Exitcode 0 fuer valide Stammdaten, erhalten: $RC"
fi

if ! grep -q 'OK: Tankstelle' "$OUT_FILE"; then
  fail 'Erwartete Erfolgsmeldung nicht gefunden.'
fi

ROW_OK="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM stations WHERE brand='ValidStation' AND zip='44135' AND city='Dortmund' AND latitude_e6=51514200 AND longitude_e6=7465300 AND plus_code='9F4MGC2M+H4';")"
if [[ "$ROW_OK" != "1" ]]; then
  fail "Erwartet genau einen gueltigen Stationssatz, erhalten: $ROW_OK"
fi

printf '[OK] P-080/02: valide Stations-Stammdaten inkl. Geodaten werden gespeichert.\n'
