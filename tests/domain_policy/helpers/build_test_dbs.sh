#!/usr/bin/env bash
set -euo pipefail

# build_test_dbs.sh
# UPDATED: 2026-03-11
# Erzeugt reproduzierbare Test-DBs fuer Output/Perf (Big) und Domain-Policies (Policy).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
FIXTURE_DIR="$ROOT_DIR/tests/domain_policy/fixtures"
BIG_DB="$FIXTURE_DIR/Betankungen_Big.db"
POLICY_DB="$FIXTURE_DIR/Betankungen_Policy.db"
LOCK_FILE="$FIXTURE_DIR/.build_test_dbs.lock"
BIG_SQL="$FIXTURE_DIR/seed_big.sql"
POLICY_SQL="$FIXTURE_DIR/seed_policy.sql"
APP_BIN="$ROOT_DIR/bin/Betankungen"
BIG_DB_TMP=""
POLICY_DB_TMP=""
LOCK_DIR=""

cleanup() {
  if [[ -n "$BIG_DB_TMP" ]]; then
    rm -f "$BIG_DB_TMP"
  fi
  if [[ -n "$POLICY_DB_TMP" ]]; then
    rm -f "$POLICY_DB_TMP"
  fi
  if [[ -n "$LOCK_DIR" ]]; then
    rm -rf "$LOCK_DIR"
  fi
}

trap cleanup EXIT

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

acquire_build_lock() {
  mkdir -p "$FIXTURE_DIR"

  if command -v flock >/dev/null 2>&1; then
    exec 9>"$LOCK_FILE"
    if ! flock -w 120 9; then
      printf '[FAIL] Konnte Build-Lock nicht erhalten: %s\n' "$LOCK_FILE" >&2
      exit 1
    fi
    return
  fi

  LOCK_DIR="${LOCK_FILE}.d"
  local tries=0
  while ! mkdir "$LOCK_DIR" 2>/dev/null; do
    tries=$((tries + 1))
    if [[ $tries -ge 120 ]]; then
      printf '[FAIL] Konnte Fallback-Build-Lock nicht erhalten: %s\n' "$LOCK_DIR" >&2
      exit 1
    fi
    sleep 1
  done
}

mkdir -p "$FIXTURE_DIR"

for required in "$BIG_SQL" "$POLICY_SQL"; do
  if [[ ! -f "$required" ]]; then
    printf '[FAIL] Fixture fehlt: %s\n' "$required" >&2
    exit 1
  fi
done

acquire_build_lock
ensure_binary

BIG_DB_TMP="$(mktemp "$FIXTURE_DIR/.Betankungen_Big.db.tmp.XXXXXX")"
POLICY_DB_TMP="$(mktemp "$FIXTURE_DIR/.Betankungen_Policy.db.tmp.XXXXXX")"
rm -f "$BIG_DB_TMP" "$POLICY_DB_TMP"

init_schema "$BIG_DB_TMP"
init_schema "$POLICY_DB_TMP"

seed_db "$BIG_DB_TMP" "$BIG_SQL"
seed_db "$POLICY_DB_TMP" "$POLICY_SQL"

verify_count "$BIG_DB_TMP" "500" "Betankungen_Big.db"
verify_count "$POLICY_DB_TMP" "3" "Betankungen_Policy.db"

mv -f "$BIG_DB_TMP" "$BIG_DB"
mv -f "$POLICY_DB_TMP" "$POLICY_DB"
BIG_DB_TMP=""
POLICY_DB_TMP=""

printf '[OK] Betankungen_Big.db erstellt: %s\n' "$BIG_DB"
printf '[OK] Betankungen_Policy.db erstellt: %s\n' "$POLICY_DB"
