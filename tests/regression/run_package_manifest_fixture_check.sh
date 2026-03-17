#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FIXTURE_ROOT="$ROOT_DIR/tests/regression/fixtures/package_manifest_v1"

ok() {
  printf '[OK] %s\n' "$1"
}

fail() {
  printf '[FAIL] %s\n' "$1" >&2
}

validate_bundle() {
  local bundle_dir="$1"

  python3 - "$bundle_dir" <<'PY'
import hashlib
import json
import os
import re
import sys

bundle = sys.argv[1]
manifest_path = os.path.join(bundle, "manifest.json")

if not os.path.isfile(manifest_path):
    raise SystemExit("manifest.json fehlt")

with open(manifest_path, "r", encoding="utf-8") as fh:
    manifest = json.load(fh)

required_top = ["manifest_version", "package_kind", "created_at", "source", "payload_files"]
for key in required_top:
    if key not in manifest:
        raise SystemExit(f"Pflichtfeld fehlt: {key}")

if manifest["manifest_version"] != 1:
    raise SystemExit("manifest_version muss 1 sein")

if not isinstance(manifest["package_kind"], str) or not manifest["package_kind"].strip():
    raise SystemExit("package_kind muss nicht-leerer String sein")

if not isinstance(manifest["created_at"], str) or not re.match(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$", manifest["created_at"]):
    raise SystemExit("created_at muss UTC ISO-8601 mit Z sein")

source = manifest["source"]
if not isinstance(source, dict):
    raise SystemExit("source muss Objekt sein")

required_source = ["app_version", "export_contract_version", "db_schema_version", "generated_by"]
for key in required_source:
    if key not in source:
        raise SystemExit(f"source-Pflichtfeld fehlt: {key}")

if not isinstance(source["app_version"], str) or not source["app_version"].strip():
    raise SystemExit("source.app_version muss nicht-leerer String sein")

for key in ("export_contract_version", "db_schema_version"):
    if not isinstance(source[key], int) or source[key] < 1:
        raise SystemExit(f"source.{key} muss int >= 1 sein")

if not isinstance(source["generated_by"], str) or not source["generated_by"].strip():
    raise SystemExit("source.generated_by muss nicht-leerer String sein")

payload_files = manifest["payload_files"]
if not isinstance(payload_files, list) or not payload_files:
    raise SystemExit("payload_files muss nicht-leere Liste sein")

seen_paths = set()
for idx, entry in enumerate(payload_files):
    if not isinstance(entry, dict):
        raise SystemExit(f"payload_files[{idx}] muss Objekt sein")

    for key in ("path", "sha256", "bytes"):
        if key not in entry:
            raise SystemExit(f"payload_files[{idx}] Pflichtfeld fehlt: {key}")

    rel_path = entry["path"]
    if not isinstance(rel_path, str) or not rel_path.strip():
        raise SystemExit(f"payload_files[{idx}].path muss nicht-leerer String sein")

    norm_path = os.path.normpath(rel_path)
    if os.path.isabs(norm_path) or norm_path.startswith("..") or "/.." in norm_path:
        raise SystemExit(f"payload_files[{idx}].path verlaesst Bundle-Kontext")

    if norm_path in seen_paths:
        raise SystemExit(f"payload_files[{idx}].path ist doppelt: {norm_path}")
    seen_paths.add(norm_path)

    sha_expected = entry["sha256"]
    if not isinstance(sha_expected, str) or not re.match(r"^[0-9a-f]{64}$", sha_expected):
        raise SystemExit(f"payload_files[{idx}].sha256 muss 64-stellig hex sein")

    bytes_expected = entry["bytes"]
    if not isinstance(bytes_expected, int) or bytes_expected < 0:
        raise SystemExit(f"payload_files[{idx}].bytes muss int >= 0 sein")

    file_path = os.path.join(bundle, norm_path)
    if not os.path.isfile(file_path):
        raise SystemExit(f"Payload-Datei fehlt: {norm_path}")

    file_size = os.path.getsize(file_path)
    if file_size != bytes_expected:
        raise SystemExit(
            f"Bytes-Mismatch fuer {norm_path}: expected={bytes_expected}, actual={file_size}"
        )

    hasher = hashlib.sha256()
    with open(file_path, "rb") as fh:
        for chunk in iter(lambda: fh.read(65536), b""):
            hasher.update(chunk)
    sha_actual = hasher.hexdigest()

    if sha_actual != sha_expected:
        raise SystemExit(
            f"Checksum-Mismatch fuer {norm_path}: expected={sha_expected}, actual={sha_actual}"
        )
PY
}

run_case() {
  local case_name="$1"
  local expected="$2"
  local bundle_dir="$FIXTURE_ROOT/$case_name"

  if [[ ! -d "$bundle_dir" ]]; then
    fail "Fixture fehlt: $case_name"
    return 1
  fi

  if validate_bundle "$bundle_dir" >/tmp/manifest_case_out.$$ 2>/tmp/manifest_case_err.$$; then
    if [[ "$expected" == "pass" ]]; then
      ok "$case_name: valid"
      rm -f /tmp/manifest_case_out.$$ /tmp/manifest_case_err.$$
      return 0
    fi
    fail "$case_name: erwarteter Fehler, aber valid"
    cat /tmp/manifest_case_out.$$ /tmp/manifest_case_err.$$ >&2 || true
    rm -f /tmp/manifest_case_out.$$ /tmp/manifest_case_err.$$
    return 1
  fi

  if [[ "$expected" == "fail" ]]; then
    ok "$case_name: invalid (erwartet)"
    rm -f /tmp/manifest_case_out.$$ /tmp/manifest_case_err.$$
    return 0
  fi

  fail "$case_name: unerwarteter Fehler"
  cat /tmp/manifest_case_out.$$ /tmp/manifest_case_err.$$ >&2 || true
  rm -f /tmp/manifest_case_out.$$ /tmp/manifest_case_err.$$
  return 1
}

main() {
  run_case "valid_minimal" "pass"
  run_case "invalid_missing_source_app_version" "fail"
  run_case "invalid_checksum_mismatch" "fail"
  run_case "invalid_payload_path_traversal" "fail"
  ok "Package-Manifest-Fixture-Check erfolgreich"
}

main "$@"
