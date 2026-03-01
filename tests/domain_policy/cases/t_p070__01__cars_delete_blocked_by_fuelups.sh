#!/usr/bin/env bash
set -euo pipefail

# t_p070__01__cars_delete_blocked_by_fuelups.sh
# UPDATED: 2026-03-01
# Policy P-070: cars delete darf bei vorhandenen fuelup-Referenzen nicht durchrutschen.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DB_POLICY="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Policy.db"
FIXTURE_SQL="$ROOT_DIR/tests/domain_policy/fixtures/p070_base.sql"
DB_BUILDER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/t_p070_guard_XXXXXX)"
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

COUNT_CARS_BEFORE="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM cars WHERE id = 1;")"
COUNT_FUELUPS_BEFORE="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups WHERE car_id = 1;")"

set +e
"$APP_BIN" --db "$DB_POLICY" --delete cars --car-id 1 >"$OUT_FILE" 2>"$ERR_FILE"
RC=$?
set -e

if [[ $RC -eq 0 ]]; then
  fail 'Erwartet Exitcode != 0 fuer delete cars bei Referenzen, erhalten: 0'
fi

if ! grep -q 'geloescht' "$ERR_FILE"; then
  fail 'Erwarteter Kernhinweis auf blockiertes Loeschen nicht gefunden.'
fi

if ! grep -q 'fuelups vorhanden' "$ERR_FILE"; then
  fail 'Erwarteter Guard-Hinweis auf vorhandene fuelups fehlt.'
fi

if grep -q 'loeschen (y/N)' "$OUT_FILE"; then
  fail 'Delete-Prompt erschien trotz Delete-Guard (Policy greift zu spaet).'
fi

COUNT_CARS_AFTER="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM cars WHERE id = 1;")"
COUNT_FUELUPS_AFTER="$(sqlite3 "$DB_POLICY" "SELECT COUNT(*) FROM fuelups WHERE car_id = 1;")"

if [[ "$COUNT_CARS_AFTER" != "$COUNT_CARS_BEFORE" ]]; then
  fail "Cars-Count geaendert (vorher=$COUNT_CARS_BEFORE, nachher=$COUNT_CARS_AFTER)."
fi

if [[ "$COUNT_FUELUPS_AFTER" != "$COUNT_FUELUPS_BEFORE" ]]; then
  fail "Fuelups-Count geaendert (vorher=$COUNT_FUELUPS_BEFORE, nachher=$COUNT_FUELUPS_AFTER)."
fi

printf '[OK] P-070/01: Delete-Guard blockiert cars delete bei Referenzen stabil.\n'
