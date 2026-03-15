#!/usr/bin/env bash
set -euo pipefail

# run_export_contract_csv_check.sh
# CREATED: 2026-03-15
# UPDATED: 2026-03-15
# Validiert den CSV-Export-Contract aus docs/EXPORT_CONTRACT.md gegen echte CLI-Ausgaben.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOC_FILE="$ROOT_DIR/docs/EXPORT_CONTRACT.md"
BIN_FILE="$ROOT_DIR/bin/Betankungen"
ASSERT_HELPER="$ROOT_DIR/tests/helpers/assert.sh"
CSV_HELPER="$ROOT_DIR/tests/helpers/csv.sh"
TMP_DIR="$(mktemp -d /tmp/betankungen_export_contract_csv_XXXXXX)"

OUT_CSV="$TMP_DIR/fuelups.csv"
ERR_CSV="$TMP_DIR/fuelups.err"
OUT_INVALID="$TMP_DIR/yearly_csv.out"
ERR_INVALID="$TMP_DIR/yearly_csv.err"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  for f in "$ERR_CSV" "$OUT_INVALID" "$ERR_INVALID"; do
    [[ -e "$f" ]] || continue
    [[ -s "$f" ]] || continue
    printf '[INFO] %s:\n' "$(basename "$f")" >&2
    sed -n '1,80p' "$f" >&2
  done
  exit 1
}

require_tool() {
  local tool="$1"
  command -v "$tool" >/dev/null 2>&1 || fail "Benoetigtes Tool fehlt: $tool"
}

assert_csv_header_prefix() {
  local -a expected=(
    contract_version
    idx
    dist_km
    liters_ml
    avg_l_per_100km_x100
    total_cents
  )
  local i

  if ((${#CSV_HEADER[@]} < ${#expected[@]})); then
    fail "CSV-Header zu kurz: erwartet mindestens ${#expected[@]} Spalten, erhalten ${#CSV_HEADER[@]}"
  fi

  for i in "${!expected[@]}"; do
    if [[ "${CSV_HEADER[$i]}" != "${expected[$i]}" ]]; then
      fail "CSV-Header-Mismatch an Position $((i + 1)): erwartet '${expected[$i]}', erhalten '${CSV_HEADER[$i]}'"
    fi
  done

  printf '[OK] CSV-Header-Prefix ist contract-stabil\n'
}

# shellcheck source=/dev/null
source "$ASSERT_HELPER"
# shellcheck source=/dev/null
source "$CSV_HELPER"

require_tool grep
[[ -x "$BIN_FILE" ]] || fail "CLI-Binary fehlt oder ist nicht ausfuehrbar: $BIN_FILE"
[[ -f "$DOC_FILE" ]] || fail "Contract-Dokument fehlt: $DOC_FILE"

# Contract-Dokument enthaelt den erwarteten CSV-Rahmen.
grep -q 'Erste Spalte: `contract_version`' "$DOC_FILE" \
  || fail "CSV-Contract-Regel 'Erste Spalte: contract_version' fehlt in docs/EXPORT_CONTRACT.md"
grep -Eq -- '--yearly.*CSV|kein(en)? CSV-Export' "$DOC_FILE" \
  || fail "CSV-Contract-Regel fuer ungueltiges '--yearly --csv' fehlt in docs/EXPORT_CONTRACT.md"
printf '[OK] CSV-Contract-Regeln im Dokument vorhanden\n'

export HOME="$TMP_DIR/home"
export XDG_CONFIG_HOME="$TMP_DIR/config"
export XDG_DATA_HOME="$TMP_DIR/data"
mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"

# Non-demo Umgebung leise initialisieren, damit Demo-Setup deterministisch bleibt.
"$BIN_FILE" >/dev/null 2>&1 || true
"$BIN_FILE" --seed --force --seed-value 4242 >/dev/null 2>&1 || fail "Seed-Setup fehlgeschlagen."

if "$BIN_FILE" --demo --stats fuelups --csv >"$OUT_CSV" 2>"$ERR_CSV"; then
  printf '[OK] CSV: fuelups full_tank_cycles\n'
else
  fail "CSV: fuelups full_tank_cycles"
fi

csv_read_header "$OUT_CSV"
assert_csv_header_prefix

ROW_COUNT="$(csv_row_count "$OUT_CSV")"
if [[ "$ROW_COUNT" -lt 1 ]]; then
  fail "CSV: keine Datenzeilen fuer --demo --stats fuelups --csv"
fi
printf '[OK] CSV enthaelt %s Datenzeile(n)\n' "$ROW_COUNT"

for ((i = 1; i <= ROW_COUNT; i += 1)); do
  declare -a ROW=()
  csv_read_row "$OUT_CSV" "$i" ROW
  if [[ "$(csv_get ROW contract_version)" != "1" ]]; then
    fail "CSV: contract_version != 1 in Datenzeile $i"
  fi
done
printf '[OK] CSV contract_version ist in allen Zeilen auf 1\n'

set +e
"$BIN_FILE" --demo --stats fuelups --yearly --csv >"$OUT_INVALID" 2>"$ERR_INVALID"
RC=$?
set -e

if [[ $RC -eq 0 ]]; then
  fail "Erwarteter Validierungsfehler fuer --yearly --csv blieb aus"
fi

grep -q '^Usage:' "$OUT_INVALID" || fail "Yearly+CSV-Fehlerpfad: Usage fehlt auf stdout"
grep -q '^Fehler:' "$ERR_INVALID" || fail "Yearly+CSV-Fehlerpfad: Fehler-Zeile fehlt auf stderr"
grep -q '^Tipp:' "$ERR_INVALID" || fail "Yearly+CSV-Fehlerpfad: Tipp-Zeile fehlt auf stderr"
grep -Eq 'nicht als CSV|CSV' "$ERR_INVALID" || fail "Yearly+CSV-Fehlerpfad: CSV-Hinweis fehlt"
printf '[OK] Yearly+CSV Guardrail aktiv (Validierungsfehler stabil)\n'

printf '[OK] Export-Contract CSV-Check erfolgreich (docs -> CLI Outputs konsistent).\n'
