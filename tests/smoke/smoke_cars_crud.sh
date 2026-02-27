#!/usr/bin/env bash
set -euo pipefail

# smoke_cars_crud.sh
# UPDATED: 2026-02-27
# Fokus-Smoke fuer Cars-CRUD inkl. Delete-Guard bei vorhandenen fuelups
# und Car-Resolver-Scope fuer fuelups add/list/stats.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
APP_BIN="$ROOT_DIR/bin/Betankungen"

TMP_DIR="$(mktemp -d /tmp/betankungen_smoke_cars_crud_XXXXXX)"
DB_PATH="$TMP_DIR/cars_crud.db"

OUT_ADD="$TMP_DIR/add.out"
ERR_ADD="$TMP_DIR/add.err"
OUT_LIST="$TMP_DIR/list.out"
ERR_LIST="$TMP_DIR/list.err"
OUT_EDIT="$TMP_DIR/edit.out"
ERR_EDIT="$TMP_DIR/edit.err"
OUT_DEL="$TMP_DIR/del.out"
ERR_DEL="$TMP_DIR/del.err"
OUT_DEL_BLOCK="$TMP_DIR/del_block.out"
ERR_DEL_BLOCK="$TMP_DIR/del_block.err"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf '[FAIL] %s\n' "$1"
  for f in "$TMP_DIR"/*.out "$TMP_DIR"/*.err; do
    [[ -e "$f" ]] || continue
    if [[ -s "$f" ]]; then
      printf '[INFO] %s:\n' "$(basename "$f")"
      sed -n '1,120p' "$f"
    fi
  done
  exit 1
}

if [[ ! -x "$APP_BIN" ]]; then
  fail "Binary fehlt: $APP_BIN"
fi

set +e
printf 'SmokeCar\nSC-001\nInitial note\n1234\n2026-02-24\n' \
  | "$APP_BIN" --db "$DB_PATH" --add cars >"$OUT_ADD" 2>"$ERR_ADD"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail '--add cars fehlgeschlagen.'
fi

CAR_ID="$(grep -Eo 'id=[0-9]+' "$OUT_ADD" | tail -n 1 | cut -d= -f2)"
if [[ -z "${CAR_ID:-}" ]]; then
  fail 'Car-ID konnte aus --add cars nicht extrahiert werden.'
fi
printf '[OK] Cars CRUD: add (id=%s)\n' "$CAR_ID"

set +e
"$APP_BIN" --db "$DB_PATH" --list cars >"$OUT_LIST" 2>"$ERR_LIST"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail '--list cars fehlgeschlagen.'
fi
if ! grep -q 'SmokeCar' "$OUT_LIST"; then
  fail '--list cars enthaelt den neuen Datensatz nicht.'
fi
printf '[OK] Cars CRUD: list\n'

set +e
printf 'SmokeCarEdited\nSC-002\nEdited note\n' \
  | "$APP_BIN" --db "$DB_PATH" --edit cars --car-id "$CAR_ID" >"$OUT_EDIT" 2>"$ERR_EDIT"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail '--edit cars fehlgeschlagen.'
fi
if ! grep -q 'OK: Car aktualisiert' "$OUT_EDIT"; then
  fail '--edit cars liefert keine Erfolgsmeldung.'
fi
printf '[OK] Cars CRUD: edit\n'

set +e
printf 'y\n' | "$APP_BIN" --db "$DB_PATH" --delete cars --car-id "$CAR_ID" >"$OUT_DEL" 2>"$ERR_DEL"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail '--delete cars (ohne fuelups) fehlgeschlagen.'
fi
if ! grep -q 'OK: Car geloescht' "$OUT_DEL"; then
  fail '--delete cars (ohne fuelups) liefert keine Erfolgsmeldung.'
fi

"$APP_BIN" --db "$DB_PATH" --list cars >"$OUT_LIST" 2>"$ERR_LIST"
if grep -q 'SmokeCarEdited' "$OUT_LIST"; then
  fail 'Geloeschtes Fahrzeug erscheint weiterhin in --list cars.'
fi
printf '[OK] Cars CRUD: delete ohne fuelups\n'

sqlite3 "$DB_PATH" <<'SQL'
INSERT OR IGNORE INTO stations(
  id, brand, street, house_no, zip, city, phone, owner, created_at
) VALUES (
  1, 'Smoke', 'Road', '1', '12345', 'City', '', '', datetime('now')
);
INSERT OR IGNORE INTO fuelups(
  id, station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents,
  price_per_liter_milli_eur, is_full_tank, missed_previous, created_at
) VALUES (
  1, 1, 1, datetime('now'), 1000, 10000, 1500, 1500, 1, 0, datetime('now')
);
SQL

set +e
"$APP_BIN" --db "$DB_PATH" --delete cars --car-id 1 >"$OUT_DEL_BLOCK" 2>"$ERR_DEL_BLOCK"
RC=$?
set -e
if [[ $RC -eq 0 ]]; then
  fail '--delete cars mit fuelups wurde faelschlich erlaubt.'
fi
if ! grep -q 'P-070' "$ERR_DEL_BLOCK"; then
  fail 'Delete-Guard meldet nicht P-070.'
fi
if grep -q 'loeschen (y/N)' "$OUT_DEL_BLOCK"; then
  fail 'Delete-Guard greift zu spaet (Prompt erschien trotz P-070).'
fi
if [[ "$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM cars WHERE id = 1;")" != "1" ]]; then
  fail 'Delete-Guard verletzt: car_id=1 wurde trotz Referenzen geloescht.'
fi
printf '[OK] Cars CRUD: delete mit fuelups -> P-070-Guard\n'

RES_DB="$TMP_DIR/fuelups_scope.db"
OUT_SCOPE_ADD_STATION="$TMP_DIR/scope_add_station.out"
ERR_SCOPE_ADD_STATION="$TMP_DIR/scope_add_station.err"
OUT_SCOPE_ADD_ONE_NOID="$TMP_DIR/scope_add_one_noid.out"
ERR_SCOPE_ADD_ONE_NOID="$TMP_DIR/scope_add_one_noid.err"
OUT_SCOPE_LIST_ONE_NOID="$TMP_DIR/scope_list_one_noid.out"
ERR_SCOPE_LIST_ONE_NOID="$TMP_DIR/scope_list_one_noid.err"
OUT_SCOPE_ADD_CAR2="$TMP_DIR/scope_add_car2.out"
ERR_SCOPE_ADD_CAR2="$TMP_DIR/scope_add_car2.err"
OUT_SCOPE_ADD_TWO_NOID="$TMP_DIR/scope_add_two_noid.out"
ERR_SCOPE_ADD_TWO_NOID="$TMP_DIR/scope_add_two_noid.err"
OUT_SCOPE_ADD_TWO_WITHID="$TMP_DIR/scope_add_two_withid.out"
ERR_SCOPE_ADD_TWO_WITHID="$TMP_DIR/scope_add_two_withid.err"
OUT_SCOPE_LIST_TWO_NOID="$TMP_DIR/scope_list_two_noid.out"
ERR_SCOPE_LIST_TWO_NOID="$TMP_DIR/scope_list_two_noid.err"
OUT_SCOPE_LIST_CAR1="$TMP_DIR/scope_list_car1.out"
ERR_SCOPE_LIST_CAR1="$TMP_DIR/scope_list_car1.err"
OUT_SCOPE_LIST_CAR2="$TMP_DIR/scope_list_car2.out"
ERR_SCOPE_LIST_CAR2="$TMP_DIR/scope_list_car2.err"
OUT_SCOPE_STATS_ONE_NOID="$TMP_DIR/scope_stats_one_noid.out"
ERR_SCOPE_STATS_ONE_NOID="$TMP_DIR/scope_stats_one_noid.err"
OUT_SCOPE_STATS_TWO_NOID="$TMP_DIR/scope_stats_two_noid.out"
ERR_SCOPE_STATS_TWO_NOID="$TMP_DIR/scope_stats_two_noid.err"
OUT_SCOPE_STATS_CAR1="$TMP_DIR/scope_stats_car1.out"
ERR_SCOPE_STATS_CAR1="$TMP_DIR/scope_stats_car1.err"
OUT_SCOPE_STATS_CAR2="$TMP_DIR/scope_stats_car2.out"
ERR_SCOPE_STATS_CAR2="$TMP_DIR/scope_stats_car2.err"

set +e
printf 'ScopeBrand\nScopeStreet\n1\n12345\nScopeCity\n\n\n' \
  | "$APP_BIN" --db "$RES_DB" --add stations >"$OUT_SCOPE_ADD_STATION" 2>"$ERR_SCOPE_ADD_STATION"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Scope-Smoke: --add stations fehlgeschlagen.'
fi

set +e
printf '1\n2026-02-01 12:00:00\n120\n50,00\n30,00\n1,666\ny\n\n\n\n\n' \
  | "$APP_BIN" --db "$RES_DB" --add fuelups >"$OUT_SCOPE_ADD_ONE_NOID" 2>"$ERR_SCOPE_ADD_ONE_NOID"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Scope-Smoke: --add fuelups ohne --car-id (1 Car) fehlgeschlagen.'
fi
if [[ "$(sqlite3 "$RES_DB" "SELECT car_id FROM fuelups ORDER BY id DESC LIMIT 1;")" != "1" ]]; then
  fail 'Scope-Smoke: erster Fuelup wurde nicht mit car_id=1 gespeichert.'
fi
printf '[OK] Fuelups Scope: add ohne --car-id bei 1 Car\n'

set +e
"$APP_BIN" --db "$RES_DB" --list fuelups >"$OUT_SCOPE_LIST_ONE_NOID" 2>"$ERR_SCOPE_LIST_ONE_NOID"
RC=$?
set -e
if [[ $RC -ne 0 ]] || ! grep -q '2026-02-01 12:00:00' "$OUT_SCOPE_LIST_ONE_NOID"; then
  fail 'Scope-Smoke: --list fuelups ohne --car-id (1 Car) fehlgeschlagen.'
fi
printf '[OK] Fuelups Scope: list ohne --car-id bei 1 Car\n'

set +e
"$APP_BIN" --db "$RES_DB" --stats fuelups >"$OUT_SCOPE_STATS_ONE_NOID" 2>"$ERR_SCOPE_STATS_ONE_NOID"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Scope-Smoke: --stats fuelups ohne --car-id (1 Car) fehlgeschlagen.'
fi
printf '[OK] Fuelups Scope: stats ohne --car-id bei 1 Car\n'

set +e
printf 'ScopeCarTwo\nSC-002\n\n100\n2026-01-01\n' \
  | "$APP_BIN" --db "$RES_DB" --add cars >"$OUT_SCOPE_ADD_CAR2" 2>"$ERR_SCOPE_ADD_CAR2"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Scope-Smoke: zweites Car konnte nicht angelegt werden.'
fi

CAR2_ID="$(sqlite3 "$RES_DB" "SELECT id FROM cars WHERE name = 'ScopeCarTwo' ORDER BY id DESC LIMIT 1;")"
if [[ -z "${CAR2_ID:-}" ]]; then
  fail 'Scope-Smoke: car_id fuer ScopeCarTwo konnte nicht ermittelt werden.'
fi

set +e
"$APP_BIN" --db "$RES_DB" --add fuelups >"$OUT_SCOPE_ADD_TWO_NOID" 2>"$ERR_SCOPE_ADD_TWO_NOID"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'ERROR: multiple cars found.' "$ERR_SCOPE_ADD_TWO_NOID" ||
   ! grep -q 'Hint: specify --car-id <id>' "$ERR_SCOPE_ADD_TWO_NOID"; then
  fail 'Scope-Smoke: --add fuelups ohne --car-id bei 2 Cars wurde nicht sauber geblockt.'
fi
printf '[OK] Fuelups Scope: add ohne --car-id bei 2 Cars -> Hard Error\n'

set +e
printf '1\n2026-02-02 12:00:00\n140\n55,00\n31,00\n1,774\ny\n\n\n\n\n' \
  | "$APP_BIN" --db "$RES_DB" --add fuelups --car-id "$CAR2_ID" >"$OUT_SCOPE_ADD_TWO_WITHID" 2>"$ERR_SCOPE_ADD_TWO_WITHID"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Scope-Smoke: --add fuelups --car-id <id> bei 2 Cars fehlgeschlagen.'
fi
printf '[OK] Fuelups Scope: add mit --car-id bei 2 Cars\n'

set +e
"$APP_BIN" --db "$RES_DB" --list fuelups >"$OUT_SCOPE_LIST_TWO_NOID" 2>"$ERR_SCOPE_LIST_TWO_NOID"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'ERROR: multiple cars found.' "$ERR_SCOPE_LIST_TWO_NOID" ||
   ! grep -q 'Hint: specify --car-id <id>' "$ERR_SCOPE_LIST_TWO_NOID"; then
  fail 'Scope-Smoke: --list fuelups ohne --car-id bei 2 Cars wurde nicht sauber geblockt.'
fi
printf '[OK] Fuelups Scope: list ohne --car-id bei 2 Cars -> Hard Error\n'

set +e
"$APP_BIN" --db "$RES_DB" --stats fuelups >"$OUT_SCOPE_STATS_TWO_NOID" 2>"$ERR_SCOPE_STATS_TWO_NOID"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'ERROR: multiple cars found.' "$ERR_SCOPE_STATS_TWO_NOID" ||
   ! grep -q 'Hint: specify --car-id <id>' "$ERR_SCOPE_STATS_TWO_NOID"; then
  fail 'Scope-Smoke: --stats fuelups ohne --car-id bei 2 Cars wurde nicht sauber geblockt.'
fi
printf '[OK] Fuelups Scope: stats ohne --car-id bei 2 Cars -> Hard Error\n'

set +e
"$APP_BIN" --db "$RES_DB" --list fuelups --car-id 1 >"$OUT_SCOPE_LIST_CAR1" 2>"$ERR_SCOPE_LIST_CAR1"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '2026-02-01 12:00:00' "$OUT_SCOPE_LIST_CAR1" ||
   grep -q '2026-02-02 12:00:00' "$OUT_SCOPE_LIST_CAR1"; then
  fail 'Scope-Smoke: --list fuelups --car-id 1 ist nicht car-scoped.'
fi

set +e
"$APP_BIN" --db "$RES_DB" --list fuelups --car-id "$CAR2_ID" >"$OUT_SCOPE_LIST_CAR2" 2>"$ERR_SCOPE_LIST_CAR2"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '2026-02-02 12:00:00' "$OUT_SCOPE_LIST_CAR2" ||
   grep -q '2026-02-01 12:00:00' "$OUT_SCOPE_LIST_CAR2"; then
  fail 'Scope-Smoke: --list fuelups --car-id <id> ist nicht car-scoped.'
fi
printf '[OK] Fuelups Scope: list mit --car-id ist strikt scoped\n'

sqlite3 "$RES_DB" <<SQL
INSERT INTO fuelups(
  station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents,
  price_per_liter_milli_eur, is_full_tank, missed_previous, created_at
) VALUES (
  1, 1, '2026-02-03 12:00:00', 220, 50000, 8000, 1600, 1, 0, datetime('now')
);
INSERT INTO fuelups(
  station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents,
  price_per_liter_milli_eur, is_full_tank, missed_previous, created_at
) VALUES (
  1, $CAR2_ID, '2026-02-04 12:00:00', 240, 55000, 9000, 1636, 1, 0, datetime('now')
);
SQL

set +e
"$APP_BIN" --db "$RES_DB" --stats fuelups --csv --car-id 1 >"$OUT_SCOPE_STATS_CAR1" 2>"$ERR_SCOPE_STATS_CAR1"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^1,100,50000,5000,8000$' "$OUT_SCOPE_STATS_CAR1" ||
   grep -q '^1,100,55000,5500,9000$' "$OUT_SCOPE_STATS_CAR1"; then
  fail 'Scope-Smoke: --stats fuelups --csv --car-id 1 ist nicht strikt car-scoped.'
fi

set +e
"$APP_BIN" --db "$RES_DB" --stats fuelups --csv --car-id "$CAR2_ID" >"$OUT_SCOPE_STATS_CAR2" 2>"$ERR_SCOPE_STATS_CAR2"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '^1,100,55000,5500,9000$' "$OUT_SCOPE_STATS_CAR2" ||
   grep -q '^1,100,50000,5000,8000$' "$OUT_SCOPE_STATS_CAR2"; then
  fail 'Scope-Smoke: --stats fuelups --csv --car-id <id> ist nicht strikt car-scoped.'
fi
printf '[OK] Fuelups Scope: stats mit --car-id ist strikt scoped\n'

printf '[OK] smoke_cars_crud: alle Cars-CRUD-Checks erfolgreich.\n'
