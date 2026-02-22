#!/usr/bin/env bash
set -euo pipefail

# run_domain_policy_tests.sh
# UPDATED: 2026-02-22
# Kompiliert/startet alle Domain-Policy-Cases (t_*.pas, t_*.sh).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CASE_DIR="$ROOT_DIR/tests/domain_policy/cases"
BINDIR="$ROOT_DIR/bin"
BUILDDIR="$ROOT_DIR/build"
DB_HELPER="$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"

format_prefixed_lines() {
  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$line" in
      "[OK]"*)
        printf '%b[OK]%b%s\n' "$C_GREEN" "$C_RESET" "${line#\[OK\]}"
        ;;
      "[FAIL]"*)
        printf '%b[FAIL]%b%s\n' "$C_RED" "$C_RESET" "${line#\[FAIL\]}"
        ;;
      "[INFO]"*)
        printf '%b[INFO]%b%s\n' "$C_YELLOW" "$C_RESET" "${line#\[INFO\]}"
        ;;
      *)
        printf '%s\n' "$line"
        ;;
    esac
  done
}

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'
  exec > >(format_prefixed_lines)
  exec 2> >(format_prefixed_lines >&2)
fi

fail() {
  printf '[FAIL] %s\n' "$1"
  exit 1
}

require_tool() {
  local tool="$1"
  if ! command -v "$tool" >/dev/null 2>&1; then
    fail "Benoetigtes Tool fehlt: $tool"
  fi
}

require_tool sqlite3
require_tool fpc

mkdir -p "$BINDIR" "$BUILDDIR"

printf '[INFO] Erzeuge Test-DBs (Big/Policy)\n'
"$DB_HELPER"

mapfile -t CASE_FILES < <(find "$CASE_DIR" -maxdepth 1 -type f -name 't_*' | sort)

if [[ ${#CASE_FILES[@]} -eq 0 ]]; then
  printf '[FAIL] Keine Domain-Policy-Cases gefunden (%s)\n' "$CASE_DIR"
  exit 1
fi

for case_file in "${CASE_FILES[@]}"; do
  case_base="$(basename "$case_file")"
  case_name="${case_base%.*}"
  case_ext="${case_base##*.}"

  case "$case_ext" in
    pas)
      printf '[INFO] Kompiliere Case: %s\n' "$case_name"
      if ! fpc \
        -Mobjfpc -Sh -gl -gw \
        -FE"$BINDIR" \
        -FU"$BUILDDIR" \
        -o"$BINDIR/$case_name" \
        -Fu"$ROOT_DIR/units" \
        -Fu"$ROOT_DIR/src" \
        "$case_file" \
        >/dev/null; then
        printf '[FAIL] FPC-Kompilierung fehlgeschlagen: %s\n' "$case_name"
        exit 1
      fi

      printf '[INFO] Starte Case: %s\n' "$case_name"
      if "$BINDIR/$case_name"; then
        printf '[OK]   Case erfolgreich: %s\n' "$case_name"
      else
        printf '[FAIL] Case fehlgeschlagen: %s\n' "$case_name"
        exit 1
      fi
      ;;
    sh)
      printf '[INFO] Starte Shell-Case: %s\n' "$case_name"
      if bash "$case_file"; then
        printf '[OK]   Case erfolgreich: %s\n' "$case_name"
      else
        printf '[FAIL] Case fehlgeschlagen: %s\n' "$case_name"
        exit 1
      fi
      ;;
    *)
      printf '[INFO] Ueberspringe unbekannten Case-Typ: %s\n' "$case_base"
      ;;
  esac
done

printf '[OK]   Alle Domain-Policy-Cases erfolgreich abgeschlossen\n'
