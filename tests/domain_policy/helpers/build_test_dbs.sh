#!/usr/bin/env bash
set -euo pipefail

# build_test_dbs.sh
# UPDATED: 2026-02-20
# Erzeugt reproduzierbare Test-DBs fuer Output/Perf (Big) und Domain-Policies (Policy).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
FIXTURE_DIR="$ROOT_DIR/tests/domain_policy/fixtures"
BIG_DB="$FIXTURE_DIR/Betankungen_Big.db"
POLICY_DB="$FIXTURE_DIR/Betankungen_Policy.db"
BIG_SQL="$FIXTURE_DIR/seed_big.sql"
POLICY_SQL="$FIXTURE_DIR/seed_policy.sql"
APP_BIN="$ROOT_DIR/bin/Betankungen"

ensure_binary() {
  local need_build=false

  if [[ ! -x "$APP_BIN" ]]; then
    need_build=true
  elif find "$ROOT_DIR/src" "$ROOT_DIR/units" -type f \( -name '*.pas' -o -name '*.lpr' \) -newer "$APP_BIN" | grep -q .; then
    need_build=true
  fi

  if [[ "$need_build" == false ]]; then
    return
  fi

  printf '[INFO] Betankungen-Binary fehlt/veraltet, kompiliere mit Build-Standard...\n'
  (
    cd "$ROOT_DIR"
    fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr >/dev/null
  )
}

init_schema() {
  local db_path="$1"
  local tmp_home rc

  tmp_home="$(mktemp -d /tmp/betankungen_dbbuild_XXXXXX)"
  set +e
  HOME="$tmp_home" "$APP_BIN" --db "$db_path" --list stations >/dev/null 2>&1
  rc=$?
  set -e
  rm -rf "$tmp_home"

  if [[ $rc -ne 0 ]]; then
    printf '[FAIL] Schema-Initialisierung fehlgeschlagen: %s\n' "$db_path" >&2
    exit 1
  fi
}

seed_db() {
  local db_path="$1"
  local sql_path="$2"
  sqlite3 "$db_path" < "$sql_path"
}

verify_count() {
  local db_path="$1"
  local expected="$2"
  local label="$3"
  local got

  got="$(sqlite3 "$db_path" "SELECT COUNT(*) FROM fuelups;")"
  if [[ "$got" != "$expected" ]]; then
    printf '[FAIL] %s: erwartete Fuelups=%s, erhalten=%s\n' "$label" "$expected" "$got" >&2
    exit 1
  fi
}

mkdir -p "$FIXTURE_DIR"

for required in "$BIG_SQL" "$POLICY_SQL"; do
  if [[ ! -f "$required" ]]; then
    printf '[FAIL] Fixture fehlt: %s\n' "$required" >&2
    exit 1
  fi
done

ensure_binary

rm -f "$BIG_DB" "$POLICY_DB"

init_schema "$BIG_DB"
init_schema "$POLICY_DB"

seed_db "$BIG_DB" "$BIG_SQL"
seed_db "$POLICY_DB" "$POLICY_SQL"

verify_count "$BIG_DB" "500" "Betankungen_Big.db"
verify_count "$POLICY_DB" "3" "Betankungen_Policy.db"

printf '[OK] Betankungen_Big.db erstellt: %s\n' "$BIG_DB"
printf '[OK] Betankungen_Policy.db erstellt: %s\n' "$POLICY_DB"
