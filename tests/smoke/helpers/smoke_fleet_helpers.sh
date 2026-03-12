#!/usr/bin/env bash

# smoke_fleet_helpers.sh
# CREATED: 2026-03-12
# UPDATED: 2026-03-12
# Fleet-spezifische Smoke-Checks fuer tests/smoke/smoke_cli.sh

test_stats_fleet_mvp_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fleet >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q 'Fleet-Stats (MVP)' "$out" &&
     grep -q '^Cars:' "$out" &&
     grep -q '^Fuelups:' "$out" &&
     grep -q '^Total liters (ml):' "$out" &&
     grep -q '^Total cost (cents):' "$out"; then
    printf '[OK] --stats fleet: MVP-Textausgabe\n'
  else
    printf '[FAIL] --stats fleet: MVP-Textausgabe\n'
    add_fail
  fi
}

test_stats_fleet_json_compact_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fleet --json >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '"kind":"fleet_mvp"' "$out" &&
     grep -q '"fleet":{' "$out" &&
     grep -q '"cars_total":' "$out" &&
     grep -q '"fuelups_total":' "$out" &&
     grep -q '"liters_ml_total":' "$out" &&
     grep -q '"total_cents_all":' "$out" &&
     json_has_export_meta_v1 "$out"; then
    printf '[OK] --stats fleet --json: JSON compact + Export-Meta\n'
  else
    printf '[FAIL] --stats fleet --json: JSON compact + Export-Meta\n'
    add_fail
  fi
}

test_stats_fleet_json_pretty_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fleet --json --pretty >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '"kind": "fleet_mvp"' "$out" &&
     grep -q '"fleet": {' "$out" &&
     grep -q '"cars_total":' "$out" &&
     grep -q '"fuelups_total":' "$out" &&
     grep -q '"liters_ml_total":' "$out" &&
     grep -q '"total_cents_all":' "$out" &&
     json_has_export_meta_v1 "$out" &&
     [[ "$(wc -l < "$out" | tr -d ' ')" -gt 5 ]]; then
    printf '[OK] --stats fleet --json --pretty: JSON pretty + Export-Meta\n'
  else
    printf '[FAIL] --stats fleet --json --pretty: JSON pretty + Export-Meta\n'
    add_fail
  fi
}

test_stats_fleet_csv_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fleet --csv >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nur zusammen mit "--stats fuelups"' "$err"; then
    printf '[OK] --stats fleet --csv: Validierungsfehler\n'
  else
    printf '[FAIL] --stats fleet --csv: Validierungsfehler\n'
    add_fail
  fi
}

test_stats_fleet_monthly_yearly_dashboard_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fleet --monthly >"$out" 2>"$err"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]] && grep -q 'Fehler: --monthly ist nur zusammen mit "--stats fuelups" erlaubt.' "$err"; then
    printf '[OK] --stats fleet --monthly: Validierungsfehler\n'
  else
    printf '[FAIL] --stats fleet --monthly: Validierungsfehler\n'
    add_fail
  fi

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fleet --yearly >"$out" 2>"$err"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]] && grep -q 'Fehler: --yearly ist nur zusammen mit "--stats fuelups" erlaubt.' "$err"; then
    printf '[OK] --stats fleet --yearly: Validierungsfehler\n'
  else
    printf '[FAIL] --stats fleet --yearly: Validierungsfehler\n'
    add_fail
  fi

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fleet --dashboard >"$out" 2>"$err"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]] && grep -q 'Fehler: --dashboard ist nur zusammen mit "--stats fuelups" erlaubt.' "$err"; then
    printf '[OK] --stats fleet --dashboard: Validierungsfehler\n'
  else
    printf '[FAIL] --stats fleet --dashboard: Validierungsfehler\n'
    add_fail
  fi
}

test_stats_fleet_period_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fleet --from 2025-01 >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'Fehler: --from/--to ist nur zusammen mit "--stats fuelups" erlaubt.' "$err"; then
    printf '[OK] --stats fleet --from: Validierungsfehler\n'
  else
    printf '[FAIL] --stats fleet --from: Validierungsfehler\n'
    add_fail
  fi
}
