#!/usr/bin/env bash
set -euo pipefail

# run_user_flow_break_matrix_check.sh
# CREATED: 2026-03-24
# UPDATED: 2026-03-24
# Regressions-/Coverage-Check fuer priorisierte User-Flow- und Break-Pfade
# aus docs/TEST_MATRIX.md (TSK-0012).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BIN_FILE="$ROOT_DIR/bin/Betankungen"
TMP_DIR="$(mktemp -d /tmp/betankungen_userflow_break_XXXXXX)"
LAST_OUT="$TMP_DIR/last.out"
LAST_ERR="$TMP_DIR/last.err"

HOME_DIR="$TMP_DIR/home"
CFG_DIR="$TMP_DIR/config"
DATA_DIR="$TMP_DIR/data"
MAIN_DB="$HOME_DIR/.local/share/Betankungen/betankungen.db"
DEMO_DB="$HOME_DIR/.local/share/Betankungen/betankungen_demo.db"
CFG_FILE="$HOME_DIR/.config/Betankungen/config.ini"

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
    printf '[INFO] last.out:\n' >&2
    sed -n '1,120p' "$LAST_OUT" >&2
  fi
  if [[ -s "$LAST_ERR" ]]; then
    printf '[INFO] last.err:\n' >&2
    sed -n '1,120p' "$LAST_ERR" >&2
  fi
  exit 1
}

require_tool() {
  local tool="$1"
  command -v "$tool" >/dev/null 2>&1 || fail "Benoetigtes Tool fehlt: $tool"
}

run_expect_ok() {
  local label="$1"
  shift
  "$@" >"$LAST_OUT" 2>"$LAST_ERR" || fail "$label: unerwarteter Fehler"
  ok "$label"
}

run_expect_fail() {
  local label="$1"
  shift
  set +e
  "$@" >"$LAST_OUT" 2>"$LAST_ERR"
  local rc=$?
  set -e
  [[ $rc -ne 0 ]] || fail "$label: erwarteter Fehler blieb aus"
  ok "$label"
}

assert_contains() {
  local file="$1"
  local needle="$2"
  local label="$3"
  grep -Fq -- "$needle" "$file" || fail "$label"
}

assert_not_contains() {
  local file="$1"
  local needle="$2"
  local label="$3"
  if grep -Fq -- "$needle" "$file"; then
    fail "$label"
  fi
}

main() {
  require_tool sqlite3
  [[ -x "$BIN_FILE" ]] || fail "CLI-Binary fehlt oder ist nicht ausfuehrbar: $BIN_FILE"

  export HOME="$HOME_DIR"
  export XDG_CONFIG_HOME="$CFG_DIR"
  export XDG_DATA_HOME="$DATA_DIR"
  mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"

  run_expect_ok "[INIT-001] Bootstrap in leerer Umgebung" "$BIN_FILE"
  [[ -f "$CFG_FILE" ]] || fail "[INIT-001] config.ini wurde nicht angelegt"
  [[ -f "$MAIN_DB" ]] || fail "[INIT-001] Haupt-DB wurde nicht angelegt"
  assert_contains "$LAST_OUT" "Erststart: Config angelegt:" "[INIT-001] Erststart-Hinweis fehlt."
  assert_contains "$LAST_OUT" "Naechster Schritt: Betankungen --list cars" "[INIT-001] Next-Step-Hinweis fehlt."

  run_expect_ok "[INIT-003] --show-config nach Erststart" "$BIN_FILE" --show-config
  assert_contains "$LAST_OUT" "Config existiert:   True" "[INIT-003] Config-Status fehlt."
  assert_contains "$LAST_OUT" "DB existiert:       True" "[INIT-003] DB-Status fehlt."

  run_expect_ok "[INIT-004] --list cars nach Erststart" "$BIN_FILE" --list cars
  assert_contains "$LAST_OUT" "Hauptauto" "[INIT-004] Standardfahrzeug fehlt in Ausgabe."

  run_expect_ok "[INIT-005] --list stations leer" "$BIN_FILE" --list stations
  assert_contains "$LAST_OUT" "Keine Tankstellen vorhanden." "[INIT-005] Leerzustand stations nicht stabil."

  run_expect_ok "[INIT-006] --list fuelups leer" "$BIN_FILE" --list fuelups
  assert_contains "$LAST_OUT" "Keine Betankungsdaten gefunden." "[INIT-006] Leerzustand fuelups nicht stabil."

  run_expect_fail "[DEMO-005] --demo ohne Seed endet kontrolliert" "$BIN_FILE" --demo --list stations
  assert_contains "$LAST_ERR" "Demo-DB nicht gefunden" "[DEMO-005] Erwarteter Demo-Fehlertext fehlt."

  run_expect_ok "[DEMO-001] --seed in leerer Umgebung" "$BIN_FILE" --seed
  assert_contains "$LAST_OUT" "OK: Demo-DB erstellt/aktualisiert" "[DEMO-001] Seed-Erfolgsmeldung fehlt."

  [[ -f "$DEMO_DB" ]] || fail "[DEMO-002] Demo-DB wurde nicht angelegt"
  [[ "$MAIN_DB" != "$DEMO_DB" ]] || fail "[DEMO-002] Demo-DB muss getrennt zur Haupt-DB sein"
  ok "[DEMO-002] Demo-DB ist getrennt von Haupt-DB"

  run_expect_ok "[DEMO-003] --demo --list stations" "$BIN_FILE" --demo --list stations
  assert_not_contains "$LAST_OUT" "Keine Tankstellen vorhanden." "[DEMO-003] Ausgabe meldet unerwartet leere Stationen."
  grep -Eq '.+\(.+, [0-9]{5} .+\)' "$LAST_OUT" || fail "[DEMO-003] Demo-Stationen fehlen in Ausgabe."

  run_expect_ok "[DEMO-004] --demo --stats fuelups --monthly" "$BIN_FILE" --demo --stats fuelups --monthly
  assert_contains "$LAST_OUT" "Monatsstatistik" "[DEMO-004] Monatsauswertung nicht sichtbar."

  run_expect_fail "[CLI-001] unknown flag liefert Fehler" "$BIN_FILE" --unknown-flag
  assert_contains "$LAST_ERR" "Unbekanntes Argument: --unknown-flag" "[CLI-001] Unknown-Flag-Fehlertext fehlt."

  run_expect_fail "[ERR/EOF] --add fuelups </dev/null in leerem Stationszustand" bash -lc "\"$BIN_FILE\" --add fuelups </dev/null"
  assert_contains "$LAST_ERR" "Keine Tankstellen vorhanden. Bitte zuerst --add stations ausfuehren." "[ERR/EOF] Leerer Stationszustand nicht sauber abgefangen."
  assert_not_contains "$LAST_ERR" "Bitte eine gueltige Zahl eingeben." "[ERR/EOF] Dialog ist in Input-Loop gefallen."

  sqlite3 "$MAIN_DB" <<'SQL'
INSERT INTO cars(name, odometer_start_km, odometer_start_date)
VALUES ('Zweitwagen', 1, '2026-03-24');
SQL
  run_expect_fail "[ISS-0006] Multi-Car ohne --car-id gibt Guidance-Hints" "$BIN_FILE" --list fuelups
  assert_contains "$LAST_ERR" "Hint: specify --car-id <id>" "[ISS-0006] --car-id-Hint fehlt."
  assert_contains "$LAST_ERR" "Hint: use --list cars to inspect available IDs" "[ISS-0006] --list-cars-Hint fehlt."

  ok "User-Flow-/Break-Matrix-Check erfolgreich"
}

main "$@"
