#!/usr/bin/env bash
set -euo pipefail

# t_p060__02__car_isolation.sh
# UPDATED: 2026-02-27
# Policy P-060: Stats-Zyklen muessen pro Car isoliert bleiben (strict car-scope).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p060_car_isolation_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p060_car_iso_XXXXXX)"
OUT_FILE_CAR1="$TMP_DIR/stdout_car1.txt"
ERR_FILE_CAR1="$TMP_DIR/stderr_car1.txt"
OUT_FILE_CAR2="$TMP_DIR/stdout_car2.txt"
ERR_FILE_CAR2="$TMP_DIR/stderr_car2.txt"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf '[FAIL] %s\n' "$1"
  if [[ -s "$OUT_FILE_CAR1" ]]; then
    printf '[INFO] stdout car1:\n'
    sed -n '1,140p' "$OUT_FILE_CAR1"
  fi
  if [[ -s "$ERR_FILE_CAR1" ]]; then
    printf '[INFO] stderr car1:\n'
    sed -n '1,140p' "$ERR_FILE_CAR1"
  fi
  if [[ -s "$OUT_FILE_CAR2" ]]; then
    printf '[INFO] stdout car2:\n'
    sed -n '1,140p' "$OUT_FILE_CAR2"
  fi
  if [[ -s "$ERR_FILE_CAR2" ]]; then
    printf '[INFO] stderr car2:\n'
    sed -n '1,140p' "$ERR_FILE_CAR2"
  fi
  exit 1
}

if [[ ! -x "$APP_BIN" || ! -f "$DB_POLICY" ]]; then
  "$DB_BUILDER" >/dev/null
fi

sqlite3 "$DB_POLICY" < "$FIXTURE_SQL"

set +e
"$APP_BIN" --db "$DB_POLICY" --stats fuelups --csv --car-id 2 >"$OUT_FILE_CAR2" 2>"$ERR_FILE_CAR2"
RC=$?
set -e

if [[ $RC -ne 0 ]]; then
  fail "Erwartet Exitcode 0 fuer Stats-CSV (car-id=2), erhalten: $RC"
fi

if ! grep -q '^idx,dist_km,liters_ml,avg_l_per_100km_x100,total_cents$' "$OUT_FILE_CAR2"; then
  fail 'CSV-Header fuer Stats nicht gefunden.'
fi

# Erwartet: Nur Car-2 liefert einen gueltigen Zyklus (120 km, 42.000 ml, 6.300 cents).
if ! grep -q '^1,120,42000,3500,6300$' "$OUT_FILE_CAR2"; then
  fail 'Erwartete Car-2-Zykluszeile nicht gefunden (Car-Isolation fehlerhaft).'
fi

ROW_COUNT="$(grep -Ec '^[0-9]+,' "$OUT_FILE_CAR2" || true)"
if [[ "$ROW_COUNT" != "1" ]]; then
  fail "Erwartet genau 1 Zykluszeile fuer car-id=2, erhalten: $ROW_COUNT"
fi

if grep -q ',39900,' "$OUT_FILE_CAR2"; then
  fail 'Unerwarteter Cross-Car-Zyklus erkannt (Car-Isolation verletzt).'
fi

set +e
"$APP_BIN" --db "$DB_POLICY" --stats fuelups --csv --car-id 1 >"$OUT_FILE_CAR1" 2>"$ERR_FILE_CAR1"
RC=$?
set -e

if [[ $RC -ne 0 ]]; then
  fail "Erwartet Exitcode 0 fuer Stats-CSV (car-id=1), erhalten: $RC"
fi

if ! grep -q '^idx,dist_km,liters_ml,avg_l_per_100km_x100,total_cents$' "$OUT_FILE_CAR1"; then
  fail 'CSV-Header fuer Stats (car-id=1) nicht gefunden.'
fi

ROW_COUNT="$(grep -Ec '^[0-9]+,' "$OUT_FILE_CAR1" || true)"
if [[ "$ROW_COUNT" != "0" ]]; then
  fail "Erwartet 0 Zykluszeilen fuer car-id=1, erhalten: $ROW_COUNT"
fi

if grep -q '^1,120,42000,3500,6300$' "$OUT_FILE_CAR1"; then
  fail 'Car-2-Zyklus ist in car-id=1 Ausgabe aufgetaucht (Car-Isolation verletzt).'
fi

printf '[OK] P-060/02: Car-Isolation in Stats ist stabil (strikt car-scoped).\n'
