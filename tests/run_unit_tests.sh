#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TESTDIR="$ROOT/tests"
BINDIR="$ROOT/bin"
BUILDDIR="$ROOT/build"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'
  exec > >(
    while IFS= read -r line; do
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
  )
fi

mkdir -p "$BINDIR"
mkdir -p "$BUILDDIR"

printf '[INFO] Kompiliere Unit-Tests (test_cli_validate)\n'
if ! fpc \
  -Mobjfpc -Sh -gl -gw \
  -FE"$BINDIR" \
  -FU"$BUILDDIR" \
  -Fu"$ROOT/units" \
  -Fu"$ROOT/src" \
  "$TESTDIR/test_cli_validate.pas" \
  >/dev/null; then
  printf '[FAIL] FPC-Kompilierung der Unit-Tests fehlgeschlagen\n'
  exit 1
fi

printf '[INFO] Starte Unit-Tests\n'
if "$BINDIR/test_cli_validate"; then
  printf '[OK]   Unit-Tests erfolgreich abgeschlossen\n'
else
  printf '[FAIL] Unit-Tests fehlgeschlagen\n'
  exit 1
fi
