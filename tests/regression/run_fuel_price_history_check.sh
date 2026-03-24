#!/usr/bin/env bash
set -euo pipefail

# run_fuel_price_history_check.sh
# CREATED: 2026-03-24
# UPDATED: 2026-03-24
# Regression-Check fuer scripts/fuel_price_polling_run.sh.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/fuel_price_polling_run.sh"
FIXTURE_DIR="$ROOT_DIR/tests/regression/fixtures/fuel_price_history"
VALID_FIXTURE="$FIXTURE_DIR/tankerkoenig_valid_nearby_stations.json"
INVALID_FIXTURE="$FIXTURE_DIR/tankerkoenig_invalid_missing_station_id.json"

TMP_DIR="$(mktemp -d /tmp/betankungen_fuel_price_history_XXXXXX)"
DATA_ROOT="$TMP_DIR/data_root"
LAST_OUT="$TMP_DIR/last.out"
LAST_ERR="$TMP_DIR/last.err"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ok() {
  printf '[OK] %s\n' "$1"
}

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  for f in "$LAST_OUT" "$LAST_ERR"; do
    [[ -s "$f" ]] || continue
    printf '[INFO] %s:\n' "$(basename "$f")" >&2
    sed -n '1,120p' "$f" >&2
  done
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

assert_sqlite_value() {
  local db="$1"
  local sql="$2"
  local expected="$3"
  local got
  got="$(sqlite3 "$db" "$sql")"
  [[ "$got" == "$expected" ]] || fail "SQLite-Assertion fehlgeschlagen: got=$got expected=$expected sql=$sql"
}

main() {
  require_tool python3
  require_tool sqlite3
  [[ -x "$SCRIPT" ]] || fail "Script fehlt oder ist nicht ausfuehrbar: $SCRIPT"
  [[ -f "$VALID_FIXTURE" ]] || fail "Fixture fehlt: $VALID_FIXTURE"
  [[ -f "$INVALID_FIXTURE" ]] || fail "Fixture fehlt: $INVALID_FIXTURE"

  run_expect_fail "Guardrail: fehlender Scope" \
    "$SCRIPT" --provider tankerkoenig --snapshot-file "$VALID_FIXTURE" --fetched-at 2026-03-24T18:30:00Z --data-root "$DATA_ROOT"

  run_expect_ok "Dry-Run schreibt keine Historie" \
    "$SCRIPT" --provider tankerkoenig --snapshot-file "$VALID_FIXTURE" \
    --scope nearby-stations --fetched-at 2026-03-24T18:30:00Z --data-root "$DATA_ROOT" --dry-run

  [[ ! -d "$DATA_ROOT" ]] || fail "Dry-Run darf keine Datenwurzel anlegen"

  run_expect_ok "Valides Tankerkoenig-Fixture wird persistiert" \
    "$SCRIPT" --provider tankerkoenig --snapshot-file "$VALID_FIXTURE" \
    --scope nearby-stations --fetched-at 2026-03-24T18:30:00Z \
    --source-url "https://creativecommons.tankerkoenig.de/json/list.php?lat=52.5&lng=13.4&rad=5&apikey=test" \
    --data-root "$DATA_ROOT"

  local raw_path="$DATA_ROOT/raw/tankerkoenig/2026/03/24/tankerkoenig_2026-03-24T18-30-00Z_nearby-stations.json"
  local db_path="$DATA_ROOT/db/fuel_price_history.db"
  local state_path="$DATA_ROOT/state/tankerkoenig_last_run.json"

  [[ -f "$raw_path" ]] || fail "Raw-Snapshot fehlt: $raw_path"
  [[ -f "$db_path" ]] || fail "Historien-DB fehlt: $db_path"
  [[ -f "$state_path" ]] || fail "State-Datei fehlt: $state_path"

  assert_sqlite_value "$db_path" "SELECT COUNT(*) FROM provider_snapshots;" "1"
  assert_sqlite_value "$db_path" "SELECT station_count FROM provider_snapshots LIMIT 1;" "2"
  assert_sqlite_value "$db_path" "SELECT ingest_status FROM provider_snapshots LIMIT 1;" "ok"
  assert_sqlite_value "$db_path" "SELECT COUNT(*) FROM station_price_history;" "6"
  assert_sqlite_value "$db_path" "SELECT COUNT(*) FROM station_price_history WHERE provider_station_id = 'station-alpha';" "3"
  assert_sqlite_value "$db_path" "SELECT last_success_at_utc FROM provider_state WHERE provider = 'tankerkoenig';" "2026-03-24T18:30:00Z"

  python3 - <<'PY' "$state_path"
import json
import pathlib
import sys

state = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
assert state["schema"] == "fuel_price_history_state_v1"
assert state["provider"] == "tankerkoenig"
assert state["request_scope"] == "nearby-stations"
assert state["station_count"] == 2
assert state["price_points_count"] == 6
assert state["raw_path"].endswith("tankerkoenig_2026-03-24T18-30-00Z_nearby-stations.json")
assert state["db_path"].endswith("fuel_price_history.db")
PY
  ok "State-Datei konsistent"

  run_expect_fail "Duplikat-Guardrail fuer identischen Run" \
    "$SCRIPT" --provider tankerkoenig --snapshot-file "$VALID_FIXTURE" \
    --scope nearby-stations --fetched-at 2026-03-24T18:30:00Z --data-root "$DATA_ROOT"

  assert_sqlite_value "$db_path" "SELECT COUNT(*) FROM provider_snapshots;" "1"

  run_expect_fail "Fehlerpfad: invalides Snapshot-Fixture" \
    "$SCRIPT" --provider tankerkoenig --snapshot-file "$INVALID_FIXTURE" \
    --scope nearby-stations --fetched-at 2026-03-24T18:45:00Z --data-root "$DATA_ROOT"

  [[ ! -f "$DATA_ROOT/raw/tankerkoenig/2026/03/24/tankerkoenig_2026-03-24T18-45-00Z_nearby-stations.json" ]] \
    || fail "Invalides Fixture darf keinen Raw-Snapshot hinterlassen"

  assert_sqlite_value "$db_path" "SELECT COUNT(*) FROM provider_snapshots;" "1"
  assert_sqlite_value "$db_path" "SELECT COUNT(*) FROM station_price_history;" "6"

  ok "Fuel-price-History-Regression erfolgreich"
}

main "$@"
