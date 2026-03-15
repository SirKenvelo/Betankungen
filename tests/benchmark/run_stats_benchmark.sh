#!/usr/bin/env bash
set -euo pipefail

# run_stats_benchmark.sh
# UPDATED: 2026-03-15
# Optionaler, reproduzierbarer Benchmark-Runner fuer Stats-Pfade.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CORE_BIN="$ROOT_DIR/bin/Betankungen"
DEFAULT_DB="$ROOT_DIR/tests/domain_policy/fixtures/Betankungen_Big.db"

ITERATIONS=5
WARMUP=1
DB_PATH=""
JSON_OUT=""

usage() {
  cat <<'EOF_USAGE'
Usage:
  tests/benchmark/run_stats_benchmark.sh [--db <path>] [--iterations <n>] [--warmup <n>] [--json-out <file>]

Defaults:
  --db         tests/domain_policy/fixtures/Betankungen_Big.db
  --iterations 5
  --warmup     1

Hinweise:
  - Runner ist optional und nicht Teil von make verify.
  - Fixture-DB wird bei Bedarf automatisch ueber build_test_dbs erzeugt.
EOF_USAGE
}

is_int_gt_zero() {
  [[ "$1" =~ ^[0-9]+$ ]] && [[ "$1" -gt 0 ]]
}

now_ns() {
  local ts
  ts="$(date +%s%N 2>/dev/null || true)"
  if [[ "$ts" =~ ^[0-9]+$ ]]; then
    printf '%s\n' "$ts"
    return
  fi
  python3 - <<'PY'
import time
print(time.time_ns())
PY
}

run_case() {
  local label="$1"
  shift
  local args=("$@")
  local i elapsed_ns elapsed_ms total_ns=0 min_ns=0 max_ns=0 rc=0

  for ((i=1; i<=WARMUP; i+=1)); do
    "$CORE_BIN" --db "$DB_PATH" "${args[@]}" >/dev/null 2>/dev/null || true
  done

  for ((i=1; i<=ITERATIONS; i+=1)); do
    local start_ns end_ns
    start_ns="$(now_ns)"
    set +e
    "$CORE_BIN" --db "$DB_PATH" "${args[@]}" >/dev/null 2>/dev/null
    rc=$?
    set -e
    end_ns="$(now_ns)"

    elapsed_ns=$((end_ns - start_ns))
    elapsed_ms=$((elapsed_ns / 1000000))

    total_ns=$((total_ns + elapsed_ns))
    if [[ $min_ns -eq 0 || $elapsed_ns -lt $min_ns ]]; then
      min_ns=$elapsed_ns
    fi
    if [[ $elapsed_ns -gt $max_ns ]]; then
      max_ns=$elapsed_ns
    fi
  done

  local avg_ns avg_ms min_ms max_ms
  avg_ns=$((total_ns / ITERATIONS))
  avg_ms=$((avg_ns / 1000000))
  min_ms=$((min_ns / 1000000))
  max_ms=$((max_ns / 1000000))

  printf '%s|%s|%s|%s|%s|%s\n' "$label" "$ITERATIONS" "$avg_ms" "$min_ms" "$max_ms" "$rc"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --db)
      [[ $# -ge 2 ]] || { echo "[FAIL] --db benoetigt einen Wert."; exit 1; }
      DB_PATH="$2"
      shift 2
      ;;
    --iterations)
      [[ $# -ge 2 ]] || { echo "[FAIL] --iterations benoetigt einen Wert."; exit 1; }
      ITERATIONS="$2"
      shift 2
      ;;
    --warmup)
      [[ $# -ge 2 ]] || { echo "[FAIL] --warmup benoetigt einen Wert."; exit 1; }
      WARMUP="$2"
      shift 2
      ;;
    --json-out)
      [[ $# -ge 2 ]] || { echo "[FAIL] --json-out benoetigt einen Wert."; exit 1; }
      JSON_OUT="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[FAIL] Unbekannte Option: $1"
      usage
      exit 1
      ;;
  esac
done

if ! is_int_gt_zero "$ITERATIONS"; then
  echo "[FAIL] --iterations muss > 0 sein."
  exit 1
fi
if ! [[ "$WARMUP" =~ ^[0-9]+$ ]]; then
  echo "[FAIL] --warmup muss >= 0 sein."
  exit 1
fi

if [[ -z "$DB_PATH" ]]; then
  DB_PATH="$DEFAULT_DB"
fi

if [[ ! -x "$CORE_BIN" ]]; then
  mkdir -p "$ROOT_DIR/bin" "$ROOT_DIR/build" "$ROOT_DIR/units"
  fpc -Mobjfpc -Sh -gl -gw -FE"$ROOT_DIR/bin" -FU"$ROOT_DIR/build" -Fuunits "$ROOT_DIR/src/Betankungen.lpr" >/dev/null
fi

if [[ ! -f "$DB_PATH" ]]; then
  "$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh" >/dev/null
fi

if [[ ! -f "$DB_PATH" ]]; then
  echo "[FAIL] Benchmark-DB nicht gefunden: $DB_PATH"
  exit 1
fi

RESULTS=()
RESULTS+=("$(run_case fuelups_text --stats fuelups --car-id 1)")
RESULTS+=("$(run_case fuelups_json --stats fuelups --json --car-id 1)")
RESULTS+=("$(run_case fleet_json --stats fleet --json)")
RESULTS+=("$(run_case cost_json_none --stats cost --json --maintenance-source none)")
RESULTS+=("$(run_case cost_json_scoped --stats cost --json --maintenance-source none --car-id 1)")

printf 'Stats Benchmark\n'
printf 'db=%s iterations=%s warmup=%s\n' "$DB_PATH" "$ITERATIONS" "$WARMUP"
printf 'case|iterations|avg_ms|min_ms|max_ms|last_rc\n'
for line in "${RESULTS[@]}"; do
  printf '%s\n' "$line"
done

if [[ -n "$JSON_OUT" ]]; then
  mkdir -p "$(dirname "$JSON_OUT")"
  {
    printf '{\n'
    printf '  "db": "%s",\n' "$DB_PATH"
    printf '  "iterations": %s,\n' "$ITERATIONS"
    printf '  "warmup": %s,\n' "$WARMUP"
    printf '  "results": [\n'
    for i in "${!RESULTS[@]}"; do
      IFS='|' read -r label iters avg min max rc <<<"${RESULTS[$i]}"
      comma=','
      if [[ $i -eq $((${#RESULTS[@]} - 1)) ]]; then
        comma=''
      fi
      printf '    {"case":"%s","iterations":%s,"avg_ms":%s,"min_ms":%s,"max_ms":%s,"last_rc":%s}%s\n' \
        "$label" "$iters" "$avg" "$min" "$max" "$rc" "$comma"
    done
    printf '  ]\n'
    printf '}\n'
  } >"$JSON_OUT"
fi
