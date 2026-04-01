#!/usr/bin/env bash
set -euo pipefail

# t_p088__03__station_short_plus_code_with_coordinates_accepts.sh
# UPDATED: 2026-04-01
# Policy P-088: lokaler/short plus_code wird mit Koordinaten akzeptiert.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p080_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p088_short_plus_code_accepts_XXXXXX)"
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
  'ShortCodeStation'
  'Musterweg'
  '12a'
  '44135'
  'Dortmund'
  '+49 231 123456'
  'TestOwner'
  '51,514200'
  '7.465300'
  'GC2M+H4 Dortmund'
)

set +e
printf '%s\n' "${INPUT_LINES[@]}" \
  | "$APP_BIN" --db "$DB_POLICY" --add stations >"$OUT_FILE" 2>"$ERR_FILE"
RC=$?
set -e

if [[ $RC -ne 0 ]]; then
  fail "Erwartet Exitcode 0 fuer short plus_code mit Koordinaten, erhalten: $RC"
fi

if ! grep -q 'OK: Tankstelle' "$OUT_FILE"; then
  fail 'Erwartete Erfolgsmeldung nicht gefunden.'
fi

STORED_PLUS_CODE="$(sqlite3 "$DB_POLICY" "SELECT plus_code FROM stations WHERE brand='ShortCodeStation' AND zip='44135' AND city='Dortmund' AND latitude_e6=51514200 AND longitude_e6=7465300;")"
if [[ -z "$STORED_PLUS_CODE" ]]; then
  fail 'Erwartete gespeicherte Station mit Geodaten wurde nicht gefunden.'
fi

if [[ ! "$STORED_PLUS_CODE" =~ ^[23456789CFGHJMPQRVWX]{8}\+[23456789CFGHJMPQRVWX]{2,6}$ ]]; then
  fail "Gespeicherter plus_code ist kein kanonischer Vollcode: $STORED_PLUS_CODE"
fi

if [[ "$STORED_PLUS_CODE" != *GC2M+H4 ]]; then
  fail "Gespeicherter plus_code behaelt das erwartete Short-Code-Suffix nicht: $STORED_PLUS_CODE"
fi

printf '[OK] P-088/03: short plus_code mit Koordinaten wird auf einen kanonischen Vollcode normalisiert.\n'
