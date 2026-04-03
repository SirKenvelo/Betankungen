#!/usr/bin/env bash
set -euo pipefail

# run_receipt_link_contract_check.sh
# CREATED: 2026-03-18
# UPDATED: 2026-04-03
# Regression fuer Receipt-Link-Contract (Scope-Guardrails, Write-Path, lokale
# Pfadnormalisierung, Missing-File-Guidance, Text/JSON-Sichtbarkeit).

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

assert_not_contains() {
  local file="$1"
  local needle="$2"
  local label="$3"
  if grep -Fq -- "$needle" "$file"; then
    fail "$label"
  fi
}

to_file_uri() {
  python3 - "$1" <<'PY'
import pathlib
import sys

print(pathlib.Path(sys.argv[1]).resolve().as_uri())
PY
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

  local existing_receipt
  local existing_uri
  local missing_receipt
  local missing_uri
  mkdir -p "$TMP_DIR/receipts"
  existing_receipt="$TMP_DIR/receipts/first receipt.jpg"
  printf 'dummy receipt\n' >"$existing_receipt"
  existing_uri="$(to_file_uri "$existing_receipt")"
  missing_receipt="$TMP_DIR/receipts/missing receipt.jpg"
  missing_uri="$(to_file_uri "$missing_receipt")"

  # Write-Path: absoluter lokaler Pfad wird auf kanonisches file:// normalisiert.
  run_expect_ok "Add fuelup mit lokalem Receipt-Pfad" bash -lc "
    printf '1\n2026-03-17 10:00:00\n1000\n50,01\n30,00\n1,667\ny\n\n\n\n\n' | \"$BIN_FILE\" --add fuelups --car-id 1 --receipt-link \"$existing_receipt\"
  "

  local saved_link
  saved_link="$(sqlite3 "$DB_FILE" "SELECT COALESCE(receipt_link,'') FROM fuelups WHERE id=1;")"
  [[ "$saved_link" == "$existing_uri" ]] || fail "Write-Path: receipt_link wurde nicht als kanonischer file://-Wert gespeichert"
  assert_contains "$LAST_OUT" "Aktiver Fahrzeugkontext: Hauptauto (ID 1)" "Add-Flow zeigt den aktiven Fahrzeugkontext nicht."
  assert_contains "$LAST_OUT" "Receipt-Link (vorab): $existing_uri" "Add-Flow zeigt den normalisierten Receipt-Link nicht."
  assert_contains "$LAST_OUT" "Lokale Receipt-Referenzen werden kanonisch als file:// gespeichert." "Add-Flow nennt die lokale Path-Normalisierung nicht."
  ok "Write-Path persistiert normalisierten receipt_link"

  local count_before_missing
  local count_after_missing
  count_before_missing="$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM fuelups;")"
  run_expect_fail "Missing local receipt-link bricht nach Confirm=NO ab" bash -lc "
    printf 'n\n' | \"$BIN_FILE\" --add fuelups --car-id 1 --receipt-link \"$missing_uri\"
  "
  count_after_missing="$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM fuelups;")"
  [[ "$count_after_missing" == "$count_before_missing" ]] || fail "Missing-File-Abbruch hat trotzdem einen Fuelup gespeichert"
  assert_contains "$LAST_OUT" "Warnung: Lokale Receipt-Datei nicht gefunden" "Missing-File-Warnung fuer lokalen Receipt-Link fehlt."
  assert_contains "$LAST_ERR" "fehlende lokale Receipt-Datei" "Abbruchtext fuer fehlende lokale Receipt-Datei fehlt."
  ok "Missing-File-Guidance fuer lokale Receipt-Links"

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

  run_expect_ok "List kompakt bleibt stationsfokussiert" "$BIN_FILE" --list fuelups --car-id 1
  assert_contains "$LAST_OUT" "ReceiptSmoke (Unna)" "Kompakte Liste zeigt den Stationsnamen nicht."
  assert_not_contains "$LAST_OUT" "ReceiptSmoke (Unna) / Hauptauto" "Kompakte Liste haengt unnoetig den Fahrzeugnamen an die Stationsspalte an."
  ok "Kompakte Liste zeigt die Station ohne abgeschnittenen Car-Suffix"

  run_expect_ok "List detail zeigt Receipt-Link" "$BIN_FILE" --list fuelups --detail --car-id 1
  assert_contains "$LAST_OUT" "Car: Hauptauto" "Detail-Ausgabe enthaelt den Fahrzeugkontext nicht separat."
  assert_contains "$LAST_OUT" "Receipt link: $existing_uri" "Detail-Ausgabe enthaelt den gesetzten Receipt-Link nicht."
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
