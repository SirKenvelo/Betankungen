#!/usr/bin/env bash
set -euo pipefail

# run_receipt_link_contract_check.sh
# CREATED: 2026-03-18
# UPDATED: 2026-03-18
# Regression fuer Receipt-Link-Contract (Scope-Guardrails, Write-Path, Text/JSON-Sichtbarkeit).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BIN_FILE="$ROOT_DIR/bin/Betankungen"
TMP_DIR="$(mktemp -d /tmp/betankungen_receipt_link_XXXXXX)"
DB_FILE="$TMP_DIR/home/.local/share/Betankungen/betankungen.db"
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

main() {
  require_tool sqlite3
  require_tool python3
  [[ -x "$BIN_FILE" ]] || fail "CLI-Binary fehlt oder ist nicht ausfuehrbar: $BIN_FILE"

  export HOME="$TMP_DIR/home"
  export XDG_CONFIG_HOME="$TMP_DIR/config"
  export XDG_DATA_HOME="$TMP_DIR/data"
  mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"

  # Initiale DB + Schema erzeugen (inkl. fuelups.receipt_link)
  run_expect_ok "Bootstrap ohne Kommando" "$BIN_FILE"

  sqlite3 "$DB_FILE" <<'SQL'
INSERT OR IGNORE INTO stations(
  id, brand, street, house_no, zip, city, phone, owner, created_at
) VALUES (
  1, 'ReceiptSmoke', 'Teststrasse', '1', '12345', 'Unna', '', '', datetime('now')
);
SQL
  ok "Test-Station angelegt"

  # Write-Path: validierter Link via --receipt-link im Add-Flow speichern.
  run_expect_ok "Add fuelup mit --receipt-link" bash -lc "
    printf '1\n2026-03-17 10:00:00\n1000\n50,01\n30,00\n1,667\ny\n\n\n\n\n' | \"$BIN_FILE\" --add fuelups --car-id 1 --receipt-link file:///data/receipts/first.jpg
  "

  local saved_link
  saved_link="$(sqlite3 "$DB_FILE" "SELECT COALESCE(receipt_link,'') FROM fuelups WHERE id=1;")"
  [[ "$saved_link" == "file:///data/receipts/first.jpg" ]] || fail "Write-Path: receipt_link wurde nicht korrekt gespeichert"
  ok "Write-Path persistiert receipt_link"

  # Zweiter Datensatz ohne Link fuer gesetzt/fehlend-Matrix.
  sqlite3 "$DB_FILE" <<'SQL'
INSERT INTO fuelups(
  station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents,
  price_per_liter_milli_eur, is_full_tank, missed_previous, fuel_type, payment_type, pump_no, note
) VALUES (
  1, 1, '2026-03-18 10:00:00', 1500, 32000, 5334, 1667, 1, 0, 'E10', 'EC', '3', 'no link row'
);
SQL
  ok "Referenzdatensatz ohne receipt_link angelegt"

  run_expect_ok "List detail zeigt Receipt-Link" "$BIN_FILE" --list fuelups --detail --car-id 1
  assert_contains "$LAST_OUT" "Receipt link: file:///data/receipts/first.jpg" "Detail-Ausgabe enthaelt den gesetzten Receipt-Link nicht."
  ok "Detail-Ausgabe zeigt Receipt-Link"

  run_expect_ok "Stats fuelups JSON full" "$BIN_FILE" --stats fuelups --json --car-id 1
  python3 - "$LAST_OUT" <<'PY'
import json
import pathlib
import sys

payload = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
if payload.get("receipt_links_set") != 1:
    raise SystemExit("receipt_links_set != 1")
if payload.get("receipt_links_missing") != 1:
    raise SystemExit("receipt_links_missing != 1")
PY
  ok "JSON full: receipt_links_set/missing korrekt"

  run_expect_ok "Stats fuelups JSON monthly" "$BIN_FILE" --stats fuelups --json --monthly --car-id 1
  python3 - "$LAST_OUT" <<'PY'
import json
import pathlib
import sys

payload = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
if payload.get("receipt_links_set") != 1 or payload.get("receipt_links_missing") != 1:
    raise SystemExit("monthly receipt-link keys unexpected")
PY
  ok "JSON monthly: receipt_links_set/missing korrekt"

  run_expect_ok "Stats fuelups JSON yearly" "$BIN_FILE" --stats fuelups --json --yearly --car-id 1
  python3 - "$LAST_OUT" <<'PY'
import json
import pathlib
import sys

payload = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
if payload.get("receipt_links_set") != 1 or payload.get("receipt_links_missing") != 1:
    raise SystemExit("yearly receipt-link keys unexpected")
PY
  ok "JSON yearly: receipt_links_set/missing korrekt"

  run_expect_fail "Guardrail: --receipt-link ausserhalb add fuelups" "$BIN_FILE" --list fuelups --receipt-link file:///tmp/x.jpg
  assert_contains "$LAST_ERR" "--receipt-link ist nur zusammen mit \"--add fuelups\" erlaubt" "Scope-Guardrail-Fehlertext fuer --receipt-link fehlt."
  ok "Scope-Guardrail fuer --receipt-link"

  run_expect_fail "Guardrail: --receipt-link ohne Wert" "$BIN_FILE" --add fuelups --receipt-link
  assert_contains "$LAST_ERR" "--receipt-link benoetigt einen Wert" "Missing-Value-Guardrail fuer --receipt-link fehlt."
  ok "Missing-Value-Guardrail fuer --receipt-link"

  run_expect_fail "Guardrail: --receipt-link mit folgendem Flag statt Wert" "$BIN_FILE" --add fuelups --receipt-link --car-id 1
  assert_contains "$LAST_ERR" "--receipt-link benoetigt einen Wert" "Flag-as-value-Guardrail fuer --receipt-link fehlt."
  ok "Flag-as-value-Guardrail fuer --receipt-link"

  ok "Receipt-Link-Regression erfolgreich"
}

main "$@"
