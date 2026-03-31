#!/usr/bin/env bash
set -euo pipefail

# smoke_migrations.sh
# UPDATED: 2026-03-31
# Dedizierte Smoke-Checks fuer DB-Schema-Migrationen.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
APP_BIN="$ROOT_DIR/bin/Betankungen"

RUN_V4_TO_V6=false
RUN_V5_TO_V6=false
LIST_ONLY=false

usage() {
  cat <<'EOF_USAGE'
smoke_migrations.sh - Smoke-Checks fuer DB-Migrationen

Usage:
  tests/smoke/smoke_migrations.sh [--v4-to-v6] [--v5-to-v6] [--all] [-l|--list] [-h|--help]

Optionen:
  --v4-to-v6    Fuehrt nur den Migrations-Check v4 -> v6 aus
  --v5-to-v6    Fuehrt nur den Migrations-Check v5 -> v6 aus
  --v4-to-v5    Kompatibilitaetsalias fuer den Legacy-Check auf aktuellen Zielstand
  --all         Fuehrt alle bekannten Migrations-Checks aus (Default)
  -l, --list    Nur Testplan anzeigen
  -h, --help    Hilfe anzeigen
EOF_USAGE
}

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'
  C_CYAN=$'\033[36m'
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
        "[LIST]"*)
          printf '%b[LIST]%b%s\n' "$C_CYAN" "$C_RESET" "${line#\[LIST\]}"
          ;;
        *)
          printf '%s\n' "$line"
          ;;
      esac
    done
  )
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --v4-to-v6|--v4-to-v5)
      RUN_V4_TO_V6=true
      shift
      ;;
    --v5-to-v6)
      RUN_V5_TO_V6=true
      shift
      ;;
    --all)
      RUN_V4_TO_V6=true
      RUN_V5_TO_V6=true
      shift
      ;;
    -l|--list)
      LIST_ONLY=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Fehler: Unbekannte Option: %s\n' "$1" >&2
      usage
      exit 1
      ;;
  esac
done

if ! $RUN_V4_TO_V6 && ! $RUN_V5_TO_V6; then
  RUN_V4_TO_V6=true
  RUN_V5_TO_V6=true
fi

print_plan() {
  printf '[INFO] List-Mode aktiv: folgende Migrations-Checks wuerden laufen.\n'
  if $RUN_V4_TO_V6; then
    printf '[LIST] v4 -> v6: cars(vin/reg_doc_*), fuelups(receipt_link) und stations(latitude_e6/longitude_e6/plus_code), schema_version=6, idempotenter Re-Run\n'
  fi
  if $RUN_V5_TO_V6; then
    printf '[LIST] v5 -> v6: stations(latitude_e6/longitude_e6/plus_code), schema_version=6, idempotenter Re-Run\n'
  fi
  printf '[INFO] Ende der Testliste.\n'
}

if $LIST_ONLY; then
  print_plan
  exit 0
fi

TMP_DIR="$(mktemp -d /tmp/betankungen_smoke_migrations_XXXXXX)"
OUT="$TMP_DIR/tmp.out"
ERR="$TMP_DIR/tmp.err"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf '[FAIL] %s\n' "$1"
  for f in "$TMP_DIR"/*.out "$TMP_DIR"/*.err "$OUT" "$ERR"; do
    [[ -e "$f" ]] || continue
    if [[ -s "$f" ]]; then
      printf '[INFO] %s:\n' "$(basename "$f")"
      sed -n '1,200p' "$f"
    fi
  done
  exit 1
}

assert_has_column() {
  local db="$1"
  local table_name="$2"
  local column_name="$3"

  if [[ "$(sqlite3 "$db" "SELECT COUNT(*) FROM pragma_table_info('$table_name') WHERE name='$column_name';")" != "1" ]]; then
    fail "Spalte fehlt nach Migration: ${table_name}.${column_name}"
  fi
}

create_v4_fixture_db() {
  local db="$1"
  sqlite3 "$db" <<'SQL'
PRAGMA foreign_keys = ON;

CREATE TABLE meta (
  key   TEXT PRIMARY KEY,
  value TEXT
);

INSERT INTO meta(key, value) VALUES('schema_version', '4');
INSERT INTO meta(key, value) VALUES('app_name', 'Betankungen');
INSERT INTO meta(key, value) VALUES('odometer_start_km', '123');
INSERT INTO meta(key, value) VALUES('odometer_start_date', '2020-01-01');

CREATE TABLE stations (
  id         INTEGER PRIMARY KEY,
  brand      TEXT NOT NULL,
  street     TEXT NOT NULL,
  house_no   TEXT NOT NULL,
  zip        TEXT NOT NULL,
  city       TEXT NOT NULL,
  phone      TEXT,
  owner      TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT
);

CREATE TABLE cars (
  id                  INTEGER PRIMARY KEY,
  name                TEXT    NOT NULL,
  plate               TEXT,
  note                TEXT,
  odometer_start_km   INTEGER NOT NULL CHECK (odometer_start_km > 0),
  odometer_start_date TEXT    NOT NULL,
  created_at          TEXT    NOT NULL DEFAULT (datetime('now')),
  updated_at          TEXT,
  UNIQUE(name)
);

CREATE TABLE fuelups (
  id                         INTEGER PRIMARY KEY,
  station_id                 INTEGER NOT NULL,
  car_id                     INTEGER NOT NULL,
  fueled_at                  TEXT    NOT NULL,
  odometer_km                INTEGER NOT NULL,
  liters_ml                  INTEGER NOT NULL,
  total_cents                INTEGER NOT NULL,
  price_per_liter_milli_eur  INTEGER NOT NULL,
  is_full_tank               INTEGER NOT NULL DEFAULT 0,
  missed_previous            INTEGER NOT NULL DEFAULT 0,
  fuel_type                  TEXT,
  payment_type               TEXT,
  pump_no                    TEXT,
  note                       TEXT,
  created_at                 TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at                 TEXT,
  FOREIGN KEY(station_id) REFERENCES stations(id) ON DELETE RESTRICT,
  FOREIGN KEY(car_id)     REFERENCES cars(id)     ON DELETE RESTRICT,
  CHECK (odometer_km > 0),
  CHECK (liters_ml > 0),
  CHECK (total_cents >= 0),
  CHECK (price_per_liter_milli_eur >= 0),
  CHECK (is_full_tank IN (0,1)),
  CHECK (missed_previous IN (0,1))
);

INSERT INTO stations(id, brand, street, house_no, zip, city, created_at)
VALUES(1, 'Fixture', 'Main', '1', '12345', 'Town', datetime('now'));

INSERT INTO cars(id, name, plate, note, odometer_start_km, odometer_start_date, created_at)
VALUES(1, 'FixtureCar', 'F-123', 'legacy-note', 123, '2020-01-01', datetime('now'));

INSERT INTO fuelups(
  id, station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents,
  price_per_liter_milli_eur, is_full_tank, missed_previous, created_at
)
VALUES(
  1, 1, 1, '2026-03-01 10:00:00', 200, 10000, 1500,
  1500, 1, 0, datetime('now')
);
SQL
}

create_v5_fixture_db() {
  local db="$1"
  sqlite3 "$db" <<'SQL'
PRAGMA foreign_keys = ON;

CREATE TABLE meta (
  key   TEXT PRIMARY KEY,
  value TEXT
);

INSERT INTO meta(key, value) VALUES('schema_version', '5');
INSERT INTO meta(key, value) VALUES('app_name', 'Betankungen');
INSERT INTO meta(key, value) VALUES('odometer_start_km', '123');
INSERT INTO meta(key, value) VALUES('odometer_start_date', '2020-01-01');

CREATE TABLE stations (
  id         INTEGER PRIMARY KEY,
  brand      TEXT NOT NULL,
  street     TEXT NOT NULL,
  house_no   TEXT NOT NULL,
  zip        TEXT NOT NULL,
  city       TEXT NOT NULL,
  phone      TEXT,
  owner      TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT
);

CREATE TABLE cars (
  id                  INTEGER PRIMARY KEY,
  name                TEXT    NOT NULL,
  plate               TEXT,
  note                TEXT,
  vin                 TEXT,
  reg_doc_path        TEXT,
  reg_doc_sha256      TEXT,
  odometer_start_km   INTEGER NOT NULL CHECK (odometer_start_km > 0),
  odometer_start_date TEXT    NOT NULL,
  created_at          TEXT    NOT NULL DEFAULT (datetime('now')),
  updated_at          TEXT,
  UNIQUE(name)
);

CREATE TABLE fuelups (
  id                         INTEGER PRIMARY KEY,
  station_id                 INTEGER NOT NULL,
  car_id                     INTEGER NOT NULL,
  fueled_at                  TEXT    NOT NULL,
  odometer_km                INTEGER NOT NULL,
  liters_ml                  INTEGER NOT NULL,
  total_cents                INTEGER NOT NULL,
  price_per_liter_milli_eur  INTEGER NOT NULL,
  is_full_tank               INTEGER NOT NULL DEFAULT 0,
  missed_previous            INTEGER NOT NULL DEFAULT 0,
  fuel_type                  TEXT,
  payment_type               TEXT,
  pump_no                    TEXT,
  note                       TEXT,
  receipt_link               TEXT,
  created_at                 TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at                 TEXT,
  FOREIGN KEY(station_id) REFERENCES stations(id) ON DELETE RESTRICT,
  FOREIGN KEY(car_id)     REFERENCES cars(id)     ON DELETE RESTRICT,
  CHECK (odometer_km > 0),
  CHECK (liters_ml > 0),
  CHECK (total_cents >= 0),
  CHECK (price_per_liter_milli_eur >= 0),
  CHECK (is_full_tank IN (0,1)),
  CHECK (missed_previous IN (0,1))
);

INSERT INTO stations(id, brand, street, house_no, zip, city, phone, owner, created_at)
VALUES(1, 'FixtureV5', 'GeoMain', '2', '44135', 'Dortmund', '+49 231 123456', 'FixtureOwner', datetime('now'));

INSERT INTO cars(id, name, plate, note, vin, reg_doc_path, reg_doc_sha256, odometer_start_km, odometer_start_date, created_at)
VALUES(1, 'FixtureCar', 'F-123', 'legacy-note', NULL, NULL, NULL, 123, '2020-01-01', datetime('now'));

INSERT INTO fuelups(
  id, station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents,
  price_per_liter_milli_eur, is_full_tank, missed_previous, receipt_link, created_at
)
VALUES(
  1, 1, 1, '2026-03-01 10:00:00', 200, 10000, 1500,
  1500, 1, 0, NULL, datetime('now')
);
SQL
}

run_v4_to_v6_check() {
  local db="$TMP_DIR/v4_to_v6.db"
  local rc schema_version cars_count preserved_row station_geo_row

  create_v4_fixture_db "$db"

  if [[ "$(sqlite3 "$db" "SELECT COUNT(*) FROM pragma_table_info('cars') WHERE name IN ('vin','reg_doc_path','reg_doc_sha256');")" != "0" ]]; then
    fail 'Fixture-Setup fehlerhaft: v4-DB enthaelt bereits v5-Spalten.'
  fi
  if [[ "$(sqlite3 "$db" "SELECT COUNT(*) FROM pragma_table_info('stations') WHERE name IN ('latitude_e6','longitude_e6','plus_code');")" != "0" ]]; then
    fail 'Fixture-Setup fehlerhaft: v4-DB enthaelt bereits v6-Stationsspalten.'
  fi

  set +e
  "$APP_BIN" --db "$db" --list cars >"$OUT" 2>"$ERR"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]]; then
    fail 'v4 -> v6: App-Start zur Migration fehlgeschlagen.'
  fi

  schema_version="$(sqlite3 "$db" "SELECT value FROM meta WHERE key='schema_version' LIMIT 1;")"
  if [[ "$schema_version" != "6" ]]; then
    fail "v4 -> v6: schema_version erwartet=6, ist=${schema_version:-<leer>}"
  fi

  assert_has_column "$db" cars vin
  assert_has_column "$db" cars reg_doc_path
  assert_has_column "$db" cars reg_doc_sha256
  assert_has_column "$db" fuelups receipt_link
  assert_has_column "$db" stations latitude_e6
  assert_has_column "$db" stations longitude_e6
  assert_has_column "$db" stations plus_code

  cars_count="$(sqlite3 "$db" "SELECT COUNT(*) FROM cars;")"
  if [[ "$cars_count" != "1" ]]; then
    fail "v4 -> v6: erwartet genau 1 Car-Datensatz, ist=${cars_count}"
  fi

  preserved_row="$(sqlite3 "$db" "SELECT name || '|' || plate || '|' || note || '|' || odometer_start_km || '|' || odometer_start_date FROM cars WHERE id=1;")"
  if [[ "$preserved_row" != "FixtureCar|F-123|legacy-note|123|2020-01-01" ]]; then
    fail "v4 -> v6: bestehende Car-Daten wurden unerwartet veraendert (${preserved_row})"
  fi

  if [[ "$(sqlite3 "$db" "SELECT COALESCE(vin, '<null>') || '|' || COALESCE(reg_doc_path, '<null>') || '|' || COALESCE(reg_doc_sha256, '<null>') FROM cars WHERE id=1;")" != "<null>|<null>|<null>" ]]; then
    fail 'v4 -> v6: neue Car-Spalten sollten fuer Legacy-Row initial NULL sein.'
  fi

  station_geo_row="$(sqlite3 "$db" "SELECT COALESCE(latitude_e6, '<null>') || '|' || COALESCE(longitude_e6, '<null>') || '|' || COALESCE(plus_code, '<null>') FROM stations WHERE id=1;")"
  if [[ "$station_geo_row" != "<null>|<null>|<null>" ]]; then
    fail "v4 -> v6: neue Stations-Geospalten sollten fuer Legacy-Row initial NULL sein (${station_geo_row})"
  fi

  set +e
  "$APP_BIN" --db "$db" --list cars >"$TMP_DIR/rerun_v4.out" 2>"$TMP_DIR/rerun_v4.err"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]]; then
    fail 'v4 -> v6: idempotenter Re-Run fehlgeschlagen.'
  fi

  if [[ "$(sqlite3 "$db" "SELECT value FROM meta WHERE key='schema_version' LIMIT 1;")" != "6" ]]; then
    fail 'v4 -> v6: schema_version ist nach Re-Run nicht stabil auf 6.'
  fi

  printf '[OK] v4 -> v6: Legacy-Migration + schema_version + Idempotenz geprueft\n'
}

run_v5_to_v6_check() {
  local db="$TMP_DIR/v5_to_v6.db"
  local rc schema_version station_row

  create_v5_fixture_db "$db"

  if [[ "$(sqlite3 "$db" "SELECT COUNT(*) FROM pragma_table_info('stations') WHERE name IN ('latitude_e6','longitude_e6','plus_code');")" != "0" ]]; then
    fail 'Fixture-Setup fehlerhaft: v5-DB enthaelt bereits v6-Stationsspalten.'
  fi

  set +e
  "$APP_BIN" --db "$db" --list stations >"$OUT" 2>"$ERR"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]]; then
    fail 'v5 -> v6: App-Start zur Migration fehlgeschlagen.'
  fi

  schema_version="$(sqlite3 "$db" "SELECT value FROM meta WHERE key='schema_version' LIMIT 1;")"
  if [[ "$schema_version" != "6" ]]; then
    fail "v5 -> v6: schema_version erwartet=6, ist=${schema_version:-<leer>}"
  fi

  assert_has_column "$db" stations latitude_e6
  assert_has_column "$db" stations longitude_e6
  assert_has_column "$db" stations plus_code

  station_row="$(sqlite3 "$db" "SELECT brand || '|' || zip || '|' || city || '|' || COALESCE(latitude_e6, '<null>') || '|' || COALESCE(longitude_e6, '<null>') || '|' || COALESCE(plus_code, '<null>') FROM stations WHERE id=1;")"
  if [[ "$station_row" != "FixtureV5|44135|Dortmund|<null>|<null>|<null>" ]]; then
    fail "v5 -> v6: bestehende Stationsdaten wurden unerwartet veraendert (${station_row})"
  fi

  set +e
  "$APP_BIN" --db "$db" --list stations >"$TMP_DIR/rerun_v5.out" 2>"$TMP_DIR/rerun_v5.err"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]]; then
    fail 'v5 -> v6: idempotenter Re-Run fehlgeschlagen.'
  fi

  if [[ "$(sqlite3 "$db" "SELECT value FROM meta WHERE key='schema_version' LIMIT 1;")" != "6" ]]; then
    fail 'v5 -> v6: schema_version ist nach Re-Run nicht stabil auf 6.'
  fi

  printf '[OK] v5 -> v6: Stations-Geodaten-Migration + schema_version + Idempotenz geprueft\n'
}

if [[ ! -x "$APP_BIN" ]]; then
  fail "Binary fehlt: $APP_BIN"
fi

if ! command -v sqlite3 >/dev/null 2>&1; then
  fail 'sqlite3 fehlt im PATH.'
fi

printf '[INFO] Starte Migration-Smoke in %s\n' "$ROOT_DIR"

if $RUN_V4_TO_V6; then
  run_v4_to_v6_check
fi

if $RUN_V5_TO_V6; then
  run_v5_to_v6_check
fi

printf 'Migration-Smoke erfolgreich.\n'
