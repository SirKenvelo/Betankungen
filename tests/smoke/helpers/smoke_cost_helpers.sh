#!/usr/bin/env bash

# smoke_cost_helpers.sh
# CREATED: 2026-03-12
# UPDATED: 2026-03-14
# Cost-spezifische Smoke-Checks fuer tests/smoke/smoke_cli.sh

cost_read_metric() {
  local file="$1"
  local key="$2"
  awk -F': ' -v k="$key" '$1 == k { print $2; exit }' "$file" | tr -d '[:space:]'
}

prepare_seeded_demo_home_for_cost_scope() {
  local home
  home="$(register_tmp_dir)"

  if ! HOME="$home" "$ROOT_DIR/bin/Betankungen" --seed --force --seed-value 4242 >/dev/null 2>&1; then
    printf '[FAIL] Cost-Scope-Setup: --seed --force fehlgeschlagen\n'
    add_fail
  fi

  printf '%s\n' "$home"
}

inject_cost_scope_car_fixture() {
  local home="$1"
  local db station_id

  db="$home/.local/share/Betankungen/betankungen_demo.db"
  station_id="$(sqlite3 "$db" 'SELECT id FROM stations ORDER BY id LIMIT 1;')"
  if [[ -z "$station_id" ]]; then
    printf '[FAIL] Cost-Scope-Setup: keine Station in Demo-DB gefunden\n'
    add_fail
    printf '%s\n' ""
    return
  fi

  sqlite3 "$db" "
    INSERT INTO cars(name, plate, note, odometer_start_km, odometer_start_date)
    VALUES('ScopeCar', 'SC-9002', 'scope-fixture', 1, '2025-01-01');
    INSERT INTO fuelups(station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents, price_per_liter_milli_eur, is_full_tank, missed_previous)
    VALUES($station_id, (SELECT id FROM cars WHERE name='ScopeCar'), '2025-01-01 10:00:00', 10000, 40000, 10000, 2500, 1, 0);
    INSERT INTO fuelups(station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents, price_per_liter_milli_eur, is_full_tank, missed_previous)
    VALUES($station_id, (SELECT id FROM cars WHERE name='ScopeCar'), '2025-02-01 10:00:00', 10500, 35000, 9000, 2571, 1, 0);
  " >/dev/null

  sqlite3 "$db" "SELECT id FROM cars WHERE name='ScopeCar' LIMIT 1;"
}

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
     grep -q '^Scope: all cars$' "$out" &&
     grep -q '^Maintenance source mode: none$' "$out" &&
     grep -q '^Maintenance source active: no$' "$out" &&
     grep -q '^Period filter: none$' "$out" &&
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
     grep -q '"scope_mode":' "$out" &&
     grep -q '"scope_car_id":' "$out" &&
     grep -q '"maintenance_source_mode":' "$out" &&
     grep -q '"maintenance_source_active":' "$out" &&
     grep -q '"period_enabled":' "$out" &&
     grep -q '"period_from":' "$out" &&
     grep -q '"period_to_exclusive":' "$out" &&
     grep -q '"period_from_provided":' "$out" &&
     grep -q '"period_to_provided":' "$out" &&
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
     grep -q '"scope_mode":' "$out" &&
     grep -q '"scope_car_id":' "$out" &&
     grep -q '"maintenance_source_mode":' "$out" &&
     grep -q '"maintenance_source_active":' "$out" &&
     grep -q '"period_enabled":' "$out" &&
     grep -q '"period_from":' "$out" &&
     grep -q '"period_to_exclusive":' "$out" &&
     grep -q '"period_from_provided":' "$out" &&
     grep -q '"period_to_provided":' "$out" &&
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

test_stats_cost_json_scope_fields_ok() {
  local home scope_car_id out err rc

  home="$(prepare_seeded_demo_home_for_cost_scope)"
  scope_car_id="$(inject_cost_scope_car_fixture "$home")"
  out="$home/out_scope_json.txt"
  err="$home/err_scope_json.txt"

  if [[ -z "$scope_car_id" ]]; then
    printf '[FAIL] --stats cost --json scope: Fixture car konnte nicht angelegt werden\n'
    add_fail
    return
  fi

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats cost --json --car-id "$scope_car_id" --from 2099-01 >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '"scope_mode":"single_car"' "$out" &&
     grep -q "\"scope_car_id\":$scope_car_id" "$out" &&
     grep -q '"maintenance_source_mode":"none"' "$out" &&
     grep -q '"maintenance_source_active":false' "$out" &&
     grep -q '"period_enabled":true' "$out" &&
     grep -q '"period_from_provided":true' "$out" &&
     grep -q '"period_to_provided":false' "$out" &&
     grep -q '"period_from":"2099-01-01 00:00:00"' "$out" &&
     grep -q '"period_to_exclusive":""' "$out"; then
    printf '[OK] --stats cost --json scope: Contract-Felder + Werte\n'
  else
    printf '[FAIL] --stats cost --json scope: Contract-Felder + Werte\n'
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

test_stats_cost_period_ok() {
  local home out_base out_filtered err_base err_filtered rc_base rc_filtered
  local total_base total_filtered

  home="$(prepare_seeded_demo_home_for_cost_scope)"
  out_base="$home/out_base.txt"
  out_filtered="$home/out_filtered.txt"
  err_base="$home/err_base.txt"
  err_filtered="$home/err_filtered.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats cost >"$out_base" 2>"$err_base"
  rc_base=$?
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats cost --from 2099-01 >"$out_filtered" 2>"$err_filtered"
  rc_filtered=$?
  set -e

  total_base="$(cost_read_metric "$out_base" 'Total cost (cents)')"
  total_filtered="$(cost_read_metric "$out_filtered" 'Total cost (cents)')"

  if [[ $rc_base -eq 0 ]] &&
     [[ $rc_filtered -eq 0 ]] &&
     [[ -n "$total_base" ]] &&
     [[ -n "$total_filtered" ]] &&
     [[ "$total_base" -gt "$total_filtered" ]] &&
     [[ "$total_filtered" -eq 0 ]] &&
     grep -q '^Period filter: 2099-01-01 00:00:00 ... open$' "$out_filtered"; then
    printf '[OK] --stats cost --from: Period-Scope wirkt auf Aggregation\n'
  else
    printf '[FAIL] --stats cost --from: Period-Scope wirkt auf Aggregation\n'
    add_fail
  fi
}

test_stats_cost_car_id_ok() {
  local home out_all out_scoped err_all err_scoped rc_all rc_scoped
  local scope_car_id total_all total_scoped dist_scoped cars_scoped cycles_scoped

  home="$(prepare_seeded_demo_home_for_cost_scope)"
  scope_car_id="$(inject_cost_scope_car_fixture "$home")"
  out_all="$home/out_all.txt"
  out_scoped="$home/out_scoped.txt"
  err_all="$home/err_all.txt"
  err_scoped="$home/err_scoped.txt"

  if [[ -z "$scope_car_id" ]]; then
    printf '[FAIL] --stats cost --car-id: Fixture car konnte nicht angelegt werden\n'
    add_fail
    return
  fi

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats cost >"$out_all" 2>"$err_all"
  rc_all=$?
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats cost --car-id "$scope_car_id" >"$out_scoped" 2>"$err_scoped"
  rc_scoped=$?
  set -e

  total_all="$(cost_read_metric "$out_all" 'Total cost (cents)')"
  total_scoped="$(cost_read_metric "$out_scoped" 'Total cost (cents)')"
  dist_scoped="$(cost_read_metric "$out_scoped" 'Distance (km)')"
  cars_scoped="$(cost_read_metric "$out_scoped" 'Cars total')"
  cycles_scoped="$(cost_read_metric "$out_scoped" 'Cars with valid full-tank cycles')"

  if [[ $rc_all -eq 0 ]] &&
     [[ $rc_scoped -eq 0 ]] &&
     [[ -n "$total_all" ]] &&
     [[ -n "$total_scoped" ]] &&
     [[ "$total_all" -gt "$total_scoped" ]] &&
     [[ "$total_scoped" -eq 9000 ]] &&
     [[ "$dist_scoped" -eq 500 ]] &&
     [[ "$cars_scoped" -eq 1 ]] &&
     [[ "$cycles_scoped" -eq 1 ]] &&
     grep -q "^Scope: car_id=$scope_car_id$" "$out_scoped"; then
    printf '[OK] --stats cost --car-id: Car-Scope wirkt auf Aggregation\n'
  else
    printf '[FAIL] --stats cost --car-id: Car-Scope wirkt auf Aggregation\n'
    add_fail
  fi
}

test_stats_cost_maintenance_source_none_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --maintenance-source none >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '^Maintenance source mode: none$' "$out" &&
     grep -q '^Maintenance source active: no$' "$out"; then
    printf '[OK] --stats cost --maintenance-source none: expliziter Integrationsmodus aktiv\n'
  else
    printf '[FAIL] --stats cost --maintenance-source none: expliziter Integrationsmodus aktiv\n'
    add_fail
  fi
}

test_stats_cost_maintenance_source_context_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --maintenance-source none >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] &&
     grep -q 'Fehler: --maintenance-source ist nur zusammen mit "--stats cost" erlaubt.' "$err"; then
    printf '[OK] --maintenance-source ausserhalb cost: Validierungsfehler\n'
  else
    printf '[FAIL] --maintenance-source ausserhalb cost: Validierungsfehler\n'
    add_fail
  fi
}

test_stats_cost_maintenance_source_module_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats cost --maintenance-source module >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] &&
     grep -q 'S11C2/4' "$err"; then
    printf '[OK] --stats cost --maintenance-source module: klarer Not-Active-Fehler\n'
  else
    printf '[FAIL] --stats cost --maintenance-source module: klarer Not-Active-Fehler\n'
    add_fail
  fi
}
