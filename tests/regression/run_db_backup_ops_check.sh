#!/usr/bin/env bash
set -euo pipefail

# run_db_backup_ops_check.sh
# CREATED: 2026-03-18
# UPDATED: 2026-03-18
# Regression-Check fuer scripts/db_backup_ops.sh (single/all, dry-run, retention, index).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/db_backup_ops.sh"
TMP_DIR="$(mktemp -d /tmp/betankungen_db_backup_ops_XXXXXX)"
SRC_DIR="$TMP_DIR/source"
OUT_DIR="$TMP_DIR/out"
EMPTY_DIR="$TMP_DIR/empty"

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

run_expect_ok() {
  local label="$1"
  shift

  "$@" >"$LAST_OUT" 2>"$LAST_ERR" || fail "$label: unerwarteter Fehler"
  ok "$label"
}

assert_run_dir_count() {
  local expected="$1"
  local count
  count="$(find "$OUT_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
  [[ "$count" == "$expected" ]] || fail "Run-Dir-Anzahl unerwartet: got=$count expected=$expected"
}

assert_index_entries() {
  local expected="$1"
  python3 - <<'PY' "$OUT_DIR/index.json" "$expected"
import json
import pathlib
import sys

index_file = pathlib.Path(sys.argv[1])
expected = int(sys.argv[2])
if not index_file.exists():
    raise SystemExit("index.json fehlt")

raw = json.loads(index_file.read_text())
entries = raw.get("entries", []) if isinstance(raw, dict) else []
if len(entries) != expected:
    raise SystemExit(f"entries mismatch: got={len(entries)} expected={expected}")
PY
}

assert_latest_mode() {
  local expected_mode="$1"
  python3 - <<'PY' "$OUT_DIR/index.json" "$expected_mode"
import json
import pathlib
import sys

index_file = pathlib.Path(sys.argv[1])
expected_mode = sys.argv[2]
raw = json.loads(index_file.read_text())
entries = raw.get("entries", []) if isinstance(raw, dict) else []
if not entries:
    raise SystemExit("index entries leer")
if entries[0].get("mode") != expected_mode:
    raise SystemExit(f"mode mismatch: got={entries[0].get('mode')} expected={expected_mode}")
PY
}

assert_latest_metadata_files() {
  local expected_count="$1"
  python3 - <<'PY' "$OUT_DIR" "$expected_count"
import json
import pathlib
import re
import sys

out_dir = pathlib.Path(sys.argv[1])
expected = int(sys.argv[2])
pat = re.compile(r"^\d{4}-\d{2}-\d{2}_\d{6}(_\d{2})?$")
runs = sorted([p for p in out_dir.iterdir() if p.is_dir() and pat.match(p.name)], reverse=True)
if not runs:
    raise SystemExit("keine Run-Verzeichnisse gefunden")
meta_file = runs[0] / "metadata.json"
if not meta_file.exists():
    raise SystemExit("metadata.json fehlt")
meta = json.loads(meta_file.read_text())
files = meta.get("files", []) if isinstance(meta, dict) else []
if len(files) != expected:
    raise SystemExit(f"files mismatch: got={len(files)} expected={expected}")
for idx, item in enumerate(files):
    if not item.get("sha256"):
        raise SystemExit(f"sha256 fehlt in files[{idx}]")
    if int(item.get("size_bytes", -1)) < 0:
        raise SystemExit(f"size_bytes ungueltig in files[{idx}]")
PY
}

main() {
  require_tool sqlite3
  require_tool python3
  [[ -x "$SCRIPT" ]] || fail "Script fehlt oder nicht ausfuehrbar: $SCRIPT"

  mkdir -p "$SRC_DIR/sub" "$EMPTY_DIR"

  sqlite3 "$SRC_DIR/alpha.db" 'CREATE TABLE t(id INTEGER); INSERT INTO t(id) VALUES (1);'
  sqlite3 "$SRC_DIR/sub/beta.db" 'CREATE TABLE t(id INTEGER); INSERT INTO t(id) VALUES (2);'

  run_expect_fail "Scope-Guardrail: ohne --db/--all" \
    "$SCRIPT" --out-root "$OUT_DIR"

  run_expect_fail "Scope-Guardrail: --db + --all ungueltig" \
    "$SCRIPT" --all --db "$SRC_DIR/alpha.db" --out-root "$OUT_DIR"

  run_expect_fail "--all ohne DB-Fund" \
    "$SCRIPT" --all --source-dir "$EMPTY_DIR" --out-root "$OUT_DIR"

  run_expect_ok "Dry-Run fuer single" \
    "$SCRIPT" --db "$SRC_DIR/alpha.db" --db "$SRC_DIR/sub/beta.db" --out-root "$OUT_DIR" --dry-run

  [[ ! -d "$OUT_DIR" ]] || fail "Dry-Run darf kein Ausgabeverzeichnis anlegen"

  run_expect_ok "Single-Run (2 DBs)" \
    "$SCRIPT" --db "$SRC_DIR/alpha.db" --db "$SRC_DIR/sub/beta.db" --out-root "$OUT_DIR" --note "single test"

  assert_run_dir_count 1
  assert_index_entries 1
  assert_latest_mode db
  assert_latest_metadata_files 2
  ok "Single-Run-Metadaten und Index konsistent"

  run_expect_ok "All-Run (2 DBs unter source-dir)" \
    "$SCRIPT" --all --source-dir "$SRC_DIR" --out-root "$OUT_DIR" --note "all test"

  assert_run_dir_count 2
  assert_index_entries 2
  assert_latest_mode all
  assert_latest_metadata_files 2
  ok "All-Run-Metadaten und Index konsistent"

  run_expect_ok "Retention (keep=1)" \
    "$SCRIPT" --all --source-dir "$SRC_DIR" --out-root "$OUT_DIR" --keep 1 --note "retention test"

  assert_run_dir_count 1
  assert_index_entries 1
  assert_latest_mode all
  assert_latest_metadata_files 2
  ok "Retention/Index-Konsistenz erfolgreich"

  ok "DB-Backup-Ops-Regression erfolgreich"
}

main "$@"
