#!/usr/bin/env bash
set -euo pipefail

# run_station_geodata_contract_check.sh
# UPDATED: 2026-04-01
# Contract-Check fuer Stations-Geodaten und Plus-Code-Sichtbarkeit.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BIN_FILE="$ROOT_DIR/bin/Betankungen"
TMP_DIR="$(mktemp -d /tmp/betankungen_station_geodata_check_XXXXXX)"
DB_FILE=""
LAST_OUT="$TMP_DIR/last.out"
LAST_ERR="$TMP_DIR/last.err"
LAST_RC=0

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ok() {
  printf '[OK] %s\n' "$1"
}

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  if [[ -s "$LAST_OUT" ]]; then
    printf '[INFO] stdout:\n' >&2
    sed -n '1,160p' "$LAST_OUT" >&2
  fi
  if [[ -s "$LAST_ERR" ]]; then
    printf '[INFO] stderr:\n' >&2
    sed -n '1,160p' "$LAST_ERR" >&2
  fi
  exit 1
}

run_capture() {
  : >"$LAST_OUT"
  : >"$LAST_ERR"
  set +e
  "$@" >"$LAST_OUT" 2>"$LAST_ERR"
  LAST_RC=$?
  set -e
}

assert_contains() {
  local file="$1"
  local needle="$2"
  local message="$3"
  if ! grep -Fq "$needle" "$file"; then
    fail "$message"
  fi
}

assert_not_contains() {
  local file="$1"
  local needle="$2"
  local message="$3"
  if grep -Fq "$needle" "$file"; then
    fail "$message"
  fi
}

require_tool() {
  local tool="$1"
  command -v "$tool" >/dev/null 2>&1 || fail "Benoetigtes Tool fehlt: $tool"
}

require_tool sqlite3
[[ -x "$BIN_FILE" ]] || fail "CLI-Binary fehlt oder ist nicht ausfuehrbar: $BIN_FILE"

export HOME="$TMP_DIR/home"
export XDG_CONFIG_HOME="$TMP_DIR/config"
export XDG_DATA_HOME="$TMP_DIR/data"
mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"
DB_FILE="$HOME/.local/share/Betankungen/betankungen.db"

run_capture "$BIN_FILE"
if [[ $LAST_RC -ne 0 ]]; then
  fail 'Bootstrap ohne Kommando fehlgeschlagen.'
fi
ok 'Bootstrap initialisiert Standard-DB'

set +e
printf '%s\n' \
  'GeoStation' \
  'GeoStreet' \
  '12' \
  '44135' \
  'Dortmund' \
  '+49 231 123456' \
  'GeoOwner' \
  '51,514200' \
  '7.465300' \
  'GC2M+H4 Dortmund' \
  | "$BIN_FILE" --add stations >"$LAST_OUT" 2>"$LAST_ERR"
LAST_RC=$?
set -e
if [[ $LAST_RC -ne 0 ]]; then
  fail 'Add-Flow fuer Station mit Geodaten und short plus code fehlgeschlagen.'
fi
assert_contains "$LAST_OUT" 'OK: Tankstelle' 'Add-Flow liefert keine Erfolgsmeldung.'
ok 'Add-Flow speichert Station mit Geodaten und short plus code'

ROW="$(sqlite3 "$DB_FILE" "SELECT latitude_e6 || '|' || longitude_e6 || '|' || plus_code FROM stations WHERE brand='GeoStation';")"
IFS='|' read -r STORED_LAT STORED_LON STORED_PLUS_CODE <<< "$ROW"

if [[ "$STORED_LAT" != '51514200' || "$STORED_LON" != '7465300' ]]; then
  fail "Persistierte Koordinaten unerwartet: ${ROW:-<leer>}"
fi

if [[ ! "$STORED_PLUS_CODE" =~ ^[23456789CFGHJMPQRVWX]{8}\+[23456789CFGHJMPQRVWX]{2,6}$ ]]; then
  fail "Persistierter plus_code ist kein kanonischer Vollcode: ${STORED_PLUS_CODE:-<leer>}"
fi

if [[ "$STORED_PLUS_CODE" != *GC2M+H4 ]]; then
  fail "Persistierter plus_code behaelt das erwartete Short-Code-Suffix nicht: ${STORED_PLUS_CODE:-<leer>}"
fi

ok 'Persistenz normalisiert Koordinaten und ermittelt einen kanonischen Vollcode'

run_capture "$BIN_FILE" --list stations
if [[ $LAST_RC -ne 0 ]]; then
  fail '--list stations fehlgeschlagen.'
fi
assert_contains "$LAST_OUT" 'GeoStation (GeoStreet 12, 44135 Dortmund)' 'Kompakte Stationsliste enthaelt die neue Station nicht.'
assert_not_contains "$LAST_OUT" 'geodata:' 'Kompakte Stationsliste soll keine Geodaten-Zeile zeigen.'
assert_not_contains "$LAST_OUT" '9F4MGC2M+H4' 'Kompakte Stationsliste soll keinen Plus Code zeigen.'
ok 'Kompakte Stationsliste bleibt ohne Geodaten-Zusatz'

run_capture "$BIN_FILE" --list stations --detail
if [[ $LAST_RC -ne 0 ]]; then
  fail '--list stations --detail fehlgeschlagen.'
fi
assert_contains "$LAST_OUT" 'geodata: lat=51.514200 lon=7.465300 plus_code=' 'Detail-Ausgabe zeigt die Geodaten-Zeile nicht im erwarteten Format.'
assert_contains "$LAST_OUT" 'GC2M+H4' 'Detail-Ausgabe zeigt den normalisierten Vollcode nicht mit erwartetem Short-Code-Suffix.'
ok 'Detail-Ausgabe zeigt normalisierte Geodaten-Zeile'

ok 'Station-Geodata-Contract erfolgreich'
