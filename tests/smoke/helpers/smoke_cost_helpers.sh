#!/usr/bin/env bash

# smoke_cost_helpers.sh
# CREATED: 2026-03-12
# UPDATED: 2026-03-12
# Cost-spezifische Smoke-Checks fuer tests/smoke/smoke_cli.sh

test_stats_cost_mvp_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '^Cost-Stats (MVP)$' "$out" &&
     grep -q '^Cars total:' "$out" &&
     grep -q '^Distance (km):' "$out" &&
     grep -q '^Fuel cost (cents):' "$out" &&
     grep -q '^Maintenance cost (cents):' "$out" &&
     grep -q '^Total cost (cents):' "$out" &&
     grep -q '^Total cost per km (EUR):' "$out"; then
    printf '[OK] --stats cost: MVP-Textausgabe (fuel-basiert)\n'
  else
    printf '[FAIL] --stats cost: MVP-Textausgabe (fuel-basiert)\n'
    add_fail
  fi
}

test_stats_cost_json_compact_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --json >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '"kind":"cost_mvp"' "$out" &&
     grep -q '"cost":{' "$out" &&
     grep -q '"cars_total":' "$out" &&
     grep -q '"cars_with_cycles":' "$out" &&
     grep -q '"distance_km_total":' "$out" &&
     grep -q '"fuel_cents_total":' "$out" &&
     grep -q '"maintenance_cents_total":' "$out" &&
     grep -q '"total_cents":' "$out" &&
     grep -q '"cost_per_km_available":' "$out" &&
     grep -q '"fuel_cost_per_km_eur_x1000":' "$out" &&
     grep -q '"maintenance_cost_per_km_eur_x1000":' "$out" &&
     grep -q '"total_cost_per_km_eur_x1000":' "$out" &&
     json_has_export_meta_v1 "$out"; then
    printf '[OK] --stats cost --json: JSON compact + Export-Meta\n'
  else
    printf '[FAIL] --stats cost --json: JSON compact + Export-Meta\n'
    add_fail
  fi
}

test_stats_cost_json_pretty_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --json --pretty >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '"kind": "cost_mvp"' "$out" &&
     grep -q '"cost": {' "$out" &&
     grep -q '"cars_total":' "$out" &&
     grep -q '"cars_with_cycles":' "$out" &&
     grep -q '"distance_km_total":' "$out" &&
     grep -q '"fuel_cents_total":' "$out" &&
     grep -q '"maintenance_cents_total":' "$out" &&
     grep -q '"total_cents":' "$out" &&
     grep -q '"cost_per_km_available":' "$out" &&
     grep -q '"fuel_cost_per_km_eur_x1000":' "$out" &&
     grep -q '"maintenance_cost_per_km_eur_x1000":' "$out" &&
     grep -q '"total_cost_per_km_eur_x1000":' "$out" &&
     json_has_export_meta_v1 "$out" &&
     [[ "$(wc -l < "$out" | tr -d ' ')" -gt 5 ]]; then
    printf '[OK] --stats cost --json --pretty: JSON pretty + Export-Meta\n'
  else
    printf '[FAIL] --stats cost --json --pretty: JSON pretty + Export-Meta\n'
    add_fail
  fi
}

test_stats_cost_csv_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --csv >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nur zusammen mit "--stats fuelups"' "$err"; then
    printf '[OK] --stats cost --csv: Validierungsfehler\n'
  else
    printf '[FAIL] --stats cost --csv: Validierungsfehler\n'
    add_fail
  fi
}

test_stats_cost_monthly_yearly_dashboard_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --monthly >"$out" 2>"$err"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]] && grep -q 'Fehler: --monthly ist nur zusammen mit "--stats fuelups" erlaubt.' "$err"; then
    printf '[OK] --stats cost --monthly: Validierungsfehler\n'
  else
    printf '[FAIL] --stats cost --monthly: Validierungsfehler\n'
    add_fail
  fi

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --yearly >"$out" 2>"$err"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]] && grep -q 'Fehler: --yearly ist nur zusammen mit "--stats fuelups" erlaubt.' "$err"; then
    printf '[OK] --stats cost --yearly: Validierungsfehler\n'
  else
    printf '[FAIL] --stats cost --yearly: Validierungsfehler\n'
    add_fail
  fi

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --dashboard >"$out" 2>"$err"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]] && grep -q 'Fehler: --dashboard ist nur zusammen mit "--stats fuelups" erlaubt.' "$err"; then
    printf '[OK] --stats cost --dashboard: Validierungsfehler\n'
  else
    printf '[FAIL] --stats cost --dashboard: Validierungsfehler\n'
    add_fail
  fi
}

test_stats_cost_period_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --from 2025-01 >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'Fehler: --from/--to ist nur zusammen mit "--stats fuelups" erlaubt.' "$err"; then
    printf '[OK] --stats cost --from: Validierungsfehler\n'
  else
    printf '[FAIL] --stats cost --from: Validierungsfehler\n'
    add_fail
  fi
}

test_stats_cost_car_id_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --car-id 1 >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'Fehler: --car-id ist nur zusammen mit' "$err"; then
    printf '[OK] --stats cost --car-id: Validierungsfehler\n'
  else
    printf '[FAIL] --stats cost --car-id: Validierungsfehler\n'
    add_fail
  fi
}
