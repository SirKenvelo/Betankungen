#!/usr/bin/env bash
set -euo pipefail

# t_p060__01__stats_skip_interval_missed_previous.sh
# UPDATED: 2026-03-07
# Policy P-060: Stats ueberspringen Intervallbildung ueber Datensaetze mit missed_previous=1.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p060_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"
ASSERT_HELPER="$ROOT_DIR/tests/helpers/assert.sh"
CSV_HELPER="$ROOT_DIR/tests/helpers/csv.sh"

TMP_DIR="$(mktemp -d /tmp/t_p060_stats_XXXXXX)"
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

# shellcheck source=/dev/null
source "$ASSERT_HELPER"
# shellcheck source=/dev/null
source "$CSV_HELPER"

expect_csv_eq() {
  local rowvar="${1-}" col="${2-}" exp="${3-}"
  local got
  got="$(csv_get "$rowvar" "$col")"
  if [[ "$got" != "$exp" ]]; then
    fail "CSV-Feldpruefung fehlgeschlagen: col=${col}, got='${got}', exp='${exp}'"
  fi
}

if [[ ! -x "$APP_BIN" || ! -f "$DB_POLICY" ]]; then
  "$DB_BUILDER" >/dev/null
fi

sqlite3 "$DB_POLICY" < "$FIXTURE_SQL"

set +e
"$APP_BIN" --db "$DB_POLICY" --stats fuelups --csv >"$OUT_FILE" 2>"$ERR_FILE"
RC=$?
set -e

if [[ $RC -ne 0 ]]; then
  fail "Erwartet Exitcode 0 fuer Stats-CSV, erhalten: $RC"
fi

csv_read_header "$OUT_FILE"
csv_assert_has_cols contract_version idx dist_km liters_ml avg_l_per_100km_x100 total_cents

ROW_COUNT="$(csv_row_count "$OUT_FILE")"
if [[ "$ROW_COUNT" != "1" ]]; then
  fail "Erwartet genau 1 Zykluszeile, erhalten: $ROW_COUNT"
fi

declare -a ROW=()
csv_read_row "$OUT_FILE" 1 ROW
expect_csv_eq ROW contract_version "1"
expect_csv_eq ROW idx "1"
expect_csv_eq ROW dist_km "150"
expect_csv_eq ROW liters_ml "40000"
expect_csv_eq ROW avg_l_per_100km_x100 "2667"
expect_csv_eq ROW total_cents "6000"

printf '[OK] P-060/01: Stats ueberspringen Intervall ueber missed_previous=1 deterministisch.\n'
