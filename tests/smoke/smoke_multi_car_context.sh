#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd)"

# Helpers (Sprint 1)
# shellcheck source=tests/helpers/assert.sh
source "$ROOT_DIR/tests/helpers/assert.sh"
# shellcheck source=tests/helpers/csv.sh
source "$ROOT_DIR/tests/helpers/csv.sh"

# smoke_multi_car_context.sh
# UPDATED: 2026-03-31
# Finale Resolver-/CLI-Matrix fuer 0/1/>1 Cars:
# - add/list/stats fuelups (inkl. scoped Output, unknown car_id, invalid car_id)
# - edit/delete cars Guards (required/unknown/valid)
APP_BIN="$ROOT_DIR/bin/Betankungen"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'
  exec > >(
    while IFS= read -r line; do
      case "$line" in
        "[OK]"*)
          printf '%b[OK]%b%s\n' "$C_GREEN" "$C_RESET" "${line#\[OK\]}"
          ;;
        "[FAIL]"*)
          printf '%b[FAIL]%b%s\n' "$C_RED" "$C_RESET" "${line#\[FAIL\]}"
          ;;
        "[INFO]"*)
          printf '%b[INFO]%b%s\n' "$C_YELLOW" "$C_RESET" "${line#\[INFO\]}"
          ;;
        *)
          printf '%s\n' "$line"
          ;;
      esac
    done
  )
fi

TMP_DIR="$(mktemp -d /tmp/betankungen_smoke_multi_car_context_XXXXXX)"
DB_ZERO="$TMP_DIR/zero_cars.db"
DB_ONE="$TMP_DIR/one_car.db"
DB_MULTI="$TMP_DIR/multi_car.db"

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
      sed -n '1,160p' "$f"
    fi
  done
  exit 1
}

if [[ ! -x "$APP_BIN" ]]; then
  fail "Binary fehlt: $APP_BIN"
fi

OUT="$TMP_DIR/tmp.out"
ERR="$TMP_DIR/tmp.err"

# ---------------------------------------------------------------------------
# A) 0 Cars
"$APP_BIN" --db "$DB_ZERO" --list cars >/dev/null 2>&1
# Guard: bootstrap legt standardmaessig car id=1 an.
# Der Trigger erzwingt fuer diesen Testzustand dauerhaft "0 Cars".
sqlite3 "$DB_ZERO" \
  "CREATE TRIGGER IF NOT EXISTS trg_block_default_car_insert
   BEFORE INSERT ON cars
   BEGIN
     SELECT RAISE(IGNORE);
   END;
   DELETE FROM fuelups;
   DELETE FROM cars;"

set +e
"$APP_BIN" --db "$DB_ZERO" --list fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'ERROR: no cars found.' "$ERR" ||
   ! grep -q 'Hint: create one first using --add cars' "$ERR"; then
  fail 'Matrix 0 Cars: --list fuelups wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_ZERO" --stats fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'ERROR: no cars found.' "$ERR" ||
   ! grep -q 'Hint: create one first using --add cars' "$ERR"; then
  fail 'Matrix 0 Cars: --stats fuelups wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_ZERO" --add fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'ERROR: no cars found.' "$ERR" ||
   ! grep -q 'Hint: create one first using --add cars' "$ERR"; then
  fail 'Matrix 0 Cars: --add fuelups wurde nicht korrekt geblockt.'
fi
printf '[OK] Matrix 0 Cars: add/list/stats -> Hard Error\n'

# ---------------------------------------------------------------------------
# B) 1 Car
"$APP_BIN" --db "$DB_ONE" --list cars >/dev/null 2>&1
CAR1_ID="$(sqlite3 "$DB_ONE" "SELECT id FROM cars ORDER BY id LIMIT 1;")"
if [[ -z "${CAR1_ID:-}" ]]; then
  fail 'Matrix 1 Car: keine Car-ID gefunden.'
fi

set +e
printf 'OneBrand\nOneStreet\n1\n12345\nOneCity\n\n\n\n\n\n' \
  | "$APP_BIN" --db "$DB_ONE" --add stations >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix 1 Car: --add stations fehlgeschlagen.'
fi

# ohne --car-id => OK
set +e
"$APP_BIN" --db "$DB_ONE" --list fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix 1 Car: --list fuelups ohne --car-id fehlgeschlagen.'
fi

set +e
"$APP_BIN" --db "$DB_ONE" --stats fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix 1 Car: --stats fuelups ohne --car-id fehlgeschlagen.'
fi

COUNT_BEFORE_NEG_ONE="$(sqlite3 "$DB_ONE" "SELECT COUNT(*) FROM fuelups;")"
set +e
printf '1\n2026-02-09 12:00:00\n-1\n' \
  | "$APP_BIN" --db "$DB_ONE" --add fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
COUNT_AFTER_NEG_ONE="$(sqlite3 "$DB_ONE" "SELECT COUNT(*) FROM fuelups;")"
if [[ $RC -eq 0 ]] ||
   ! grep -q 'odometer_km muss eine Ganzzahl >= 0 sein' "$ERR" ||
   [[ "$COUNT_AFTER_NEG_ONE" != "$COUNT_BEFORE_NEG_ONE" ]]; then
  fail 'Matrix 1 Car: negativer odometer_km ohne --car-id wurde nicht konsistent als Hard Error geblockt.'
fi

set +e
printf '1\n2026-02-10 12:00:00\n120\n50,00\n30,00\n1,666\ny\n\n\n\n\n' \
  | "$APP_BIN" --db "$DB_ONE" --add fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix 1 Car: --add fuelups ohne --car-id fehlgeschlagen.'
fi

# mit gueltiger --car-id => OK
set +e
"$APP_BIN" --db "$DB_ONE" --list fuelups --car-id "$CAR1_ID" >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix 1 Car: --list fuelups mit gueltiger --car-id fehlgeschlagen.'
fi

set +e
"$APP_BIN" --db "$DB_ONE" --stats fuelups --car-id "$CAR1_ID" >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix 1 Car: --stats fuelups mit gueltiger --car-id fehlgeschlagen.'
fi

set +e
# Der zweite Fuelup im 1-Car-Pfad triggert P-050 (kleine Distanz); daher
# explizit mit "n" bestaetigen, damit der Dialog nicht in EOF laeuft.
printf '1\n2026-02-11 12:00:00\n220\n80,00\n50,00\n1,600\ny\nn\n\n\n\n\n' \
  | "$APP_BIN" --db "$DB_ONE" --add fuelups --car-id "$CAR1_ID" >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix 1 Car: --add fuelups mit gueltiger --car-id fehlgeschlagen.'
fi

# mit ungueltiger --car-id => unknown
set +e
"$APP_BIN" --db "$DB_ONE" --list fuelups --car-id 999999 >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q 'ERROR: unknown car_id=999999.' "$ERR"; then
  fail 'Matrix 1 Car: --list fuelups mit ungueltiger --car-id wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_ONE" --stats fuelups --car-id 999999 >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q 'ERROR: unknown car_id=999999.' "$ERR"; then
  fail 'Matrix 1 Car: --stats fuelups mit ungueltiger --car-id wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_ONE" --add fuelups --car-id 999999 >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q 'ERROR: unknown car_id=999999.' "$ERR"; then
  fail 'Matrix 1 Car: --add fuelups mit ungueltiger --car-id wurde nicht korrekt geblockt.'
fi
printf '[OK] Matrix 1 Car: no-id OK, valid-id OK, invalid-id Hard Error\n'

# ---------------------------------------------------------------------------
# C) >1 Cars
"$APP_BIN" --db "$DB_MULTI" --list cars >/dev/null 2>&1
CAR_A_ID="$(sqlite3 "$DB_MULTI" "SELECT id FROM cars ORDER BY id LIMIT 1;")"
if [[ -z "${CAR_A_ID:-}" ]]; then
  fail 'Matrix >1 Cars: keine initiale Car-ID gefunden.'
fi

set +e
printf 'MatrixCarB\nMC-B\n\n100\n2026-01-01\n' \
  | "$APP_BIN" --db "$DB_MULTI" --add cars >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix >1 Cars: Anlage von MatrixCarB fehlgeschlagen.'
fi

set +e
printf 'MatrixCarC\nMC-C\n\n100\n2026-01-01\n' \
  | "$APP_BIN" --db "$DB_MULTI" --add cars >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix >1 Cars: Anlage von MatrixCarC fehlgeschlagen.'
fi

CAR_B_ID="$(sqlite3 "$DB_MULTI" "SELECT id FROM cars WHERE name='MatrixCarB' ORDER BY id DESC LIMIT 1;")"
CAR_C_ID="$(sqlite3 "$DB_MULTI" "SELECT id FROM cars WHERE name='MatrixCarC' ORDER BY id DESC LIMIT 1;")"
if [[ -z "${CAR_B_ID:-}" || -z "${CAR_C_ID:-}" ]]; then
  fail 'Matrix >1 Cars: Car-IDs fuer B/C konnten nicht ermittelt werden.'
fi

set +e
printf 'MultiBrand\nMultiStreet\n1\n12345\nMultiCity\n\n\n\n\n\n' \
  | "$APP_BIN" --db "$DB_MULTI" --add stations >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix >1 Cars: --add stations fehlgeschlagen.'
fi

# ohne --car-id => multiple cars hard error
set +e
"$APP_BIN" --db "$DB_MULTI" --add fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'ERROR: multiple cars found.' "$ERR" ||
   ! grep -q 'Hint: specify --car-id <id>' "$ERR" ||
   ! grep -q 'Hint: use --list cars to inspect available IDs' "$ERR"; then
  fail 'Matrix >1 Cars: --add fuelups ohne --car-id wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_MULTI" --list fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'ERROR: multiple cars found.' "$ERR" ||
   ! grep -q 'Hint: specify --car-id <id>' "$ERR" ||
   ! grep -q 'Hint: use --list cars to inspect available IDs' "$ERR"; then
  fail 'Matrix >1 Cars: --list fuelups ohne --car-id wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_MULTI" --stats fuelups >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] ||
   ! grep -q 'ERROR: multiple cars found.' "$ERR" ||
   ! grep -q 'Hint: specify --car-id <id>' "$ERR" ||
   ! grep -q 'Hint: use --list cars to inspect available IDs' "$ERR"; then
  fail 'Matrix >1 Cars: --stats fuelups ohne --car-id wurde nicht korrekt geblockt.'
fi
printf '[OK] Matrix >1 Cars: no-id -> Hard Error\n'

# Daten fuer Cross-Car-Isolation vorbereiten (je 2 Fuelups pro Car => je 1 Zyklus)
set +e
printf '1\n2026-02-01 08:00:00\n120\n30,00\n20,00\n1,500\ny\n\n\n\n\n' \
  | "$APP_BIN" --db "$DB_MULTI" --add fuelups --car-id "$CAR_A_ID" >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix >1 Cars: carA first fuelup fehlgeschlagen.'
fi

set +e
printf '1\n2026-02-02 08:00:00\n220\n80,00\n50,00\n1,600\ny\nn\n\n\n\n\n' \
  | "$APP_BIN" --db "$DB_MULTI" --add fuelups --car-id "$CAR_A_ID" >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix >1 Cars: carA second fuelup fehlgeschlagen.'
fi

set +e
printf '1\n2026-02-03 08:00:00\n140\n25,00\n15,00\n1,666\ny\n\n\n\n\n' \
  | "$APP_BIN" --db "$DB_MULTI" --add fuelups --car-id "$CAR_B_ID" >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix >1 Cars: carB first fuelup fehlgeschlagen.'
fi

set +e
printf '1\n2026-02-04 08:00:00\n240\n90,00\n55,00\n1,636\ny\nn\n\n\n\n\n' \
  | "$APP_BIN" --db "$DB_MULTI" --add fuelups --car-id "$CAR_B_ID" >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail 'Matrix >1 Cars: carB second fuelup fehlgeschlagen.'
fi

# list scoped
OUT_LIST_A="$TMP_DIR/list_a.out"
ERR_LIST_A="$TMP_DIR/list_a.err"
OUT_LIST_B="$TMP_DIR/list_b.out"
ERR_LIST_B="$TMP_DIR/list_b.err"

set +e
"$APP_BIN" --db "$DB_MULTI" --list fuelups --car-id "$CAR_A_ID" >"$OUT_LIST_A" 2>"$ERR_LIST_A"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '2026-02-01 08:00:00' "$OUT_LIST_A" ||
   ! grep -q '2026-02-02 08:00:00' "$OUT_LIST_A" ||
   grep -q '2026-02-03 08:00:00' "$OUT_LIST_A"; then
  fail 'Matrix >1 Cars: list scope fuer carA ist nicht korrekt.'
fi

set +e
"$APP_BIN" --db "$DB_MULTI" --list fuelups --car-id "$CAR_B_ID" >"$OUT_LIST_B" 2>"$ERR_LIST_B"
RC=$?
set -e
if [[ $RC -ne 0 ]] ||
   ! grep -q '2026-02-03 08:00:00' "$OUT_LIST_B" ||
   ! grep -q '2026-02-04 08:00:00' "$OUT_LIST_B" ||
   grep -q '2026-02-01 08:00:00' "$OUT_LIST_B"; then
  fail 'Matrix >1 Cars: list scope fuer carB ist nicht korrekt.'
fi

# stats scoped + cross-car isolation
OUT_STATS_A="$TMP_DIR/stats_a.out"
ERR_STATS_A="$TMP_DIR/stats_a.err"
OUT_STATS_B="$TMP_DIR/stats_b.out"
ERR_STATS_B="$TMP_DIR/stats_b.err"

set +e
"$APP_BIN" --db "$DB_MULTI" --stats fuelups --csv --car-id "$CAR_A_ID" >"$OUT_STATS_A" 2>"$ERR_STATS_A"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail "Matrix >1 Cars: stats scope fuer carA: command failed (rc=$RC)."
fi

# CSV scoped checks (feldbasiert)
csv_read_header "$OUT_STATS_A"
csv_assert_has_cols contract_version idx dist_km liters_ml avg_l_per_100km_x100 total_cents

ROWS_A="$(csv_row_count "$OUT_STATS_A")"
(( ROWS_A == 1 )) || fail "Matrix >1 Cars: stats carA: expected 1 data row, got $ROWS_A"

declare -a R_A=()
csv_read_row "$OUT_STATS_A" 1 R_A

csv_assert_eq R_A contract_version "1"
csv_assert_eq R_A idx "1"
csv_assert_eq R_A dist_km "100"
csv_assert_eq R_A liters_ml "50000"
csv_assert_eq R_A avg_l_per_100km_x100 "5000"
csv_assert_eq R_A total_cents "8000"

set +e
"$APP_BIN" --db "$DB_MULTI" --stats fuelups --csv --car-id "$CAR_B_ID" >"$OUT_STATS_B" 2>"$ERR_STATS_B"
RC=$?
set -e
if [[ $RC -ne 0 ]]; then
  fail "Matrix >1 Cars: stats scope fuer carB: command failed (rc=$RC)."
fi

csv_read_header "$OUT_STATS_B"
csv_assert_has_cols contract_version idx dist_km liters_ml avg_l_per_100km_x100 total_cents

ROWS_B="$(csv_row_count "$OUT_STATS_B")"
(( ROWS_B == 1 )) || fail "Matrix >1 Cars: stats carB: expected 1 data row, got $ROWS_B"

declare -a R_B=()
csv_read_row "$OUT_STATS_B" 1 R_B

csv_assert_eq R_B contract_version "1"
csv_assert_eq R_B idx "1"
csv_assert_eq R_B dist_km "100"
csv_assert_eq R_B liters_ml "55000"
csv_assert_eq R_B avg_l_per_100km_x100 "5500"
csv_assert_eq R_B total_cents "9000"

DB_COUNT_A="$(sqlite3 "$DB_MULTI" "SELECT COUNT(*) FROM fuelups WHERE car_id = $CAR_A_ID;")"
DB_COUNT_B="$(sqlite3 "$DB_MULTI" "SELECT COUNT(*) FROM fuelups WHERE car_id = $CAR_B_ID;")"
EXP_ROWS_A="$((DB_COUNT_A - 1))"
EXP_ROWS_B="$((DB_COUNT_B - 1))"
if [[ "$ROWS_A" != "$EXP_ROWS_A" || "$ROWS_B" != "$EXP_ROWS_B" ]]; then
  fail 'Matrix >1 Cars: Cross-Car-Isolation Check ist nicht konsistent (DB vs. Stats).'
fi
printf '[OK] Matrix >1 Cars: scoped add/list/stats + Cross-Car-Isolation\n'

# invalid --car-id bei >1 cars => unknown
set +e
"$APP_BIN" --db "$DB_MULTI" --add fuelups --car-id 999999 >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q 'ERROR: unknown car_id=999999.' "$ERR"; then
  fail 'Matrix >1 Cars: --add fuelups mit invalid car_id wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_MULTI" --list fuelups --car-id 999999 >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q 'ERROR: unknown car_id=999999.' "$ERR"; then
  fail 'Matrix >1 Cars: --list fuelups mit invalid car_id wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_MULTI" --stats fuelups --car-id 999999 >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q 'ERROR: unknown car_id=999999.' "$ERR"; then
  fail 'Matrix >1 Cars: --stats fuelups mit invalid car_id wurde nicht korrekt geblockt.'
fi
printf '[OK] Matrix >1 Cars: invalid car_id -> Hard Error\n'

# ---------------------------------------------------------------------------
# edit/delete cars guards nach Presence-Refactor
set +e
"$APP_BIN" --db "$DB_MULTI" --edit cars >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q -- '--car-id ist fuer "--edit cars" und "--delete cars" erforderlich.' "$ERR"; then
  fail 'Matrix Cars-Guard: --edit cars ohne --car-id wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_MULTI" --delete cars >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q -- '--car-id ist fuer "--edit cars" und "--delete cars" erforderlich.' "$ERR"; then
  fail 'Matrix Cars-Guard: --delete cars ohne --car-id wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_MULTI" --edit cars --car-id 999999 >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q 'car_id' "$ERR" || ! grep -q 'existiert nicht' "$ERR"; then
  fail 'Matrix Cars-Guard: --edit cars --car-id 999999 wurde nicht korrekt geblockt.'
fi

set +e
"$APP_BIN" --db "$DB_MULTI" --delete cars --car-id 999999 >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q 'car_id' "$ERR" || ! grep -q 'existiert nicht' "$ERR"; then
  fail 'Matrix Cars-Guard: --delete cars --car-id 999999 wurde nicht korrekt geblockt.'
fi

# valid edit/delete auf carC (ohne fuelups)
set +e
printf '\n\n\n' | "$APP_BIN" --db "$DB_MULTI" --edit cars --car-id "$CAR_C_ID" >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]] || ! grep -q 'OK: Car aktualisiert' "$OUT"; then
  fail 'Matrix Cars-Guard: --edit cars mit gueltiger car_id fehlgeschlagen.'
fi

set +e
printf 'y\n' | "$APP_BIN" --db "$DB_MULTI" --delete cars --car-id "$CAR_C_ID" >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -ne 0 ]] || ! grep -q 'OK: Car geloescht' "$OUT"; then
  fail 'Matrix Cars-Guard: --delete cars mit gueltiger car_id fehlgeschlagen.'
fi

# optional extra guard: --car-id 0 bleibt invalid (input policy)
set +e
"$APP_BIN" --db "$DB_MULTI" --list fuelups --car-id 0 >"$OUT" 2>"$ERR"
RC=$?
set -e
if [[ $RC -eq 0 ]] || ! grep -q 'car_id fehlt/ungueltig' "$ERR"; then
  fail 'Matrix Extra-Guard: --car-id 0 wurde nicht als invalid input geblockt.'
fi
printf '[OK] Matrix Cars-Guards: required/unknown/valid + invalid input fuer --car-id 0\n'

printf '[OK] smoke_multi_car_context: komplette Resolver-/CLI-Matrix erfolgreich.\n'
