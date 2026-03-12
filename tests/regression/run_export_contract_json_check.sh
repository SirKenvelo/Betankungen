#!/usr/bin/env bash
set -euo pipefail

# run_export_contract_json_check.sh
# CREATED: 2026-03-12
# UPDATED: 2026-03-12
# Validiert den JSON-Export-Contract aus docs/EXPORT_CONTRACT.md gegen echte CLI-Ausgaben.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DOC_FILE="$ROOT_DIR/docs/EXPORT_CONTRACT.md"
BIN_FILE="$ROOT_DIR/bin/Betankungen"
TMP_DIR="$(mktemp -d /tmp/betankungen_export_contract_XXXXXX)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

require_tool() {
  local tool="$1"
  command -v "$tool" >/dev/null 2>&1 || fail "Benoetigtes Tool fehlt: $tool"
}

run_json_capture() {
  local label="$1"
  local out_file="$2"
  shift 2
  local err_file="${out_file%.json}.err"

  if "$@" >"$out_file" 2>"$err_file"; then
    printf '[OK] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    if [[ -s "$err_file" ]]; then
      sed -n '1,60p' "$err_file" >&2
    fi
    exit 1
  fi
}

require_tool python3
[[ -x "$BIN_FILE" ]] || fail "CLI-Binary fehlt oder ist nicht ausfuehrbar: $BIN_FILE"
[[ -f "$DOC_FILE" ]] || fail "Contract-Dokument fehlt: $DOC_FILE"

export HOME="$TMP_DIR/home"
export XDG_CONFIG_HOME="$TMP_DIR/config"
export XDG_DATA_HOME="$TMP_DIR/data"
mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"

# Non-demo Umgebung leise initialisieren, damit spaetere JSON-Ausgaben sauber bleiben.
"$BIN_FILE" >/dev/null 2>&1 || true
# Demo-Daten fuer fuelups-json Varianten vorbereiten.
"$BIN_FILE" --seed --force --seed-value 4242 >/dev/null 2>&1 || fail "Seed-Setup fehlgeschlagen."

run_json_capture 'JSON: fuelups full_tank_cycles' "$TMP_DIR/fuelups_full.json" \
  "$BIN_FILE" --demo --stats fuelups --json
run_json_capture 'JSON: fuelups monthly' "$TMP_DIR/fuelups_monthly.json" \
  "$BIN_FILE" --demo --stats fuelups --json --monthly
run_json_capture 'JSON: fuelups yearly' "$TMP_DIR/fuelups_yearly.json" \
  "$BIN_FILE" --demo --stats fuelups --json --yearly
run_json_capture 'JSON: fleet_mvp' "$TMP_DIR/fleet.json" \
  "$BIN_FILE" --stats fleet --json
run_json_capture 'JSON: cost_mvp' "$TMP_DIR/cost.json" \
  "$BIN_FILE" --stats cost --json

python3 - "$DOC_FILE" "$TMP_DIR" <<'PY'
import json
import re
import sys
from pathlib import Path

BACKTICK_RE = re.compile(r"`([^`]+)`")


def parse_doc_contract(doc_path: Path):
    text = doc_path.read_text(encoding="utf-8")
    start = text.find("## JSON Contract")
    end = text.find("## CSV Contract", start)
    if start < 0 or end < 0:
        raise RuntimeError("JSON/CSV Contract-Sektion in docs/EXPORT_CONTRACT.md nicht gefunden.")

    section = text[start:end]
    lines = section.splitlines()

    meta_keys = []
    in_meta_block = False
    for line in lines:
        stripped = line.strip()
        if stripped == "Pflichtfelder:":
            in_meta_block = True
            continue
        if in_meta_block:
            if stripped.startswith("-"):
                meta_keys.extend(BACKTICK_RE.findall(line))
                continue
            if stripped == "":
                in_meta_block = False

    kinds = []
    for line in lines:
        if "Report-Kennung" in line:
            kinds = BACKTICK_RE.findall(line)
            break

    top_level_keys = {}
    nested_keys = {}

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("- fuelups monthly/yearly:"):
            keys = set(BACKTICK_RE.findall(line))
            top_level_keys["fuelups_monthly"] = set(keys)
            top_level_keys["fuelups_yearly"] = set(keys)
        elif stripped.startswith("- fuelups full_tank_cycles:"):
            top_level_keys["fuelups_full_tank_cycles"] = set(BACKTICK_RE.findall(line))
        elif stripped.startswith("- fleet_mvp:"):
            keys = BACKTICK_RE.findall(line)
            if keys:
                container = keys[0]
                top_level_keys["fleet_mvp"] = {container}
                nested_keys["fleet_mvp"] = {container: set(keys[1:])}
        elif stripped.startswith("- cost_mvp:"):
            keys = BACKTICK_RE.findall(line)
            if keys:
                container = keys[0]
                top_level_keys["cost_mvp"] = {container}
                nested_keys["cost_mvp"] = {container: set(keys[1:])}

    return {
        "meta_keys": list(dict.fromkeys(meta_keys)),
        "kinds": kinds,
        "top_level_keys": top_level_keys,
        "nested_keys": nested_keys,
    }


def load_json(path: Path):
    raw = path.read_text(encoding="utf-8").strip()
    return json.loads(raw)


def main(doc_file: str, tmp_dir: str) -> int:
    doc_path = Path(doc_file)
    out_dir = Path(tmp_dir)

    contract = parse_doc_contract(doc_path)

    required_meta = contract["meta_keys"]
    documented_kinds = set(contract["kinds"])
    top_level = contract["top_level_keys"]
    nested = contract["nested_keys"]

    scenarios = {
        "fuelups_full": ("fuelups_full_tank_cycles", out_dir / "fuelups_full.json"),
        "fuelups_monthly": ("fuelups_monthly", out_dir / "fuelups_monthly.json"),
        "fuelups_yearly": ("fuelups_yearly", out_dir / "fuelups_yearly.json"),
        "fleet": ("fleet_mvp", out_dir / "fleet.json"),
        "cost": ("cost_mvp", out_dir / "cost.json"),
    }

    errors = []

    if not required_meta:
        errors.append("Pflichtfelder konnten aus docs/EXPORT_CONTRACT.md nicht geparst werden.")

    for required_kind in {v[0] for v in scenarios.values()}:
        if required_kind not in documented_kinds:
            errors.append(f"Kind '{required_kind}' fehlt in der Report-Kennung des Dokuments.")
        if required_kind not in top_level:
            errors.append(f"Payload-Definition fuer Kind '{required_kind}' fehlt im Dokument.")

    for scenario, (expected_kind, file_path) in scenarios.items():
        if not file_path.exists():
            errors.append(f"{scenario}: JSON-Ausgabe fehlt ({file_path}).")
            continue

        try:
            payload = load_json(file_path)
        except Exception as exc:  # noqa: BLE001
            errors.append(f"{scenario}: JSON unlesbar ({exc}).")
            continue

        kind = payload.get("kind")
        if kind != expected_kind:
            errors.append(f"{scenario}: erwarteter kind='{expected_kind}', erhalten='{kind}'.")
            continue

        missing_meta = sorted([k for k in required_meta if k not in payload])
        if missing_meta:
            errors.append(f"{scenario}: fehlende Meta-Keys: {', '.join(missing_meta)}")

        missing_top = sorted([k for k in top_level.get(expected_kind, set()) if k not in payload])
        if missing_top:
            errors.append(f"{scenario}: fehlende Payload-Top-Keys: {', '.join(missing_top)}")

        kind_nested = nested.get(expected_kind, {})
        for container, nested_expected in kind_nested.items():
            container_obj = payload.get(container)
            if not isinstance(container_obj, dict):
                errors.append(f"{scenario}: Container '{container}' fehlt oder ist kein Objekt.")
                continue
            missing_nested = sorted([k for k in nested_expected if k not in container_obj])
            if missing_nested:
                errors.append(
                    f"{scenario}: fehlende Nested-Keys in '{container}': {', '.join(missing_nested)}"
                )

    if errors:
        for err in errors:
            print(f"[FAIL] {err}")
        return 1

    print("[OK] Export-Contract JSON-Check erfolgreich (docs -> CLI Outputs konsistent).")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1], sys.argv[2]))
PY

printf '[OK] Contract-Check abgeschlossen.\n'
