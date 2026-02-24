#!/usr/bin/env bash
set -euo pipefail

# smoke_clean_home.sh
# UPDATED: 2026-02-24
# Fuehrt tests/smoke/smoke_cli.sh in einer sauberen HOME/XDG-Sandbox aus.

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
KEEP_HOME=false
TMP_HOME=""
EXTRA_ARGS=()

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Finaler Smoke-Run in sauberer HOME-Sandbox

Usage:
  tests/smoke/$SCRIPT_NAME [--keep-home] [-m] [-y] [-c] [-a] [-l] [--keep-going]

Options:
  --keep-home   Temp-HOME nach dem Lauf behalten (zur Analyse)
  -m            Monthly-Zusatzsuite an smoke_cli.sh durchreichen
  -y            Yearly-Zusatzsuite an smoke_cli.sh durchreichen
  -c            Cars-Zusatzsuite an smoke_cli.sh durchreichen
  -a            Beide Zusatzsuiten an smoke_cli.sh durchreichen
  -l, --list    Nur Testliste anzeigen (keine Ausfuehrung)
  --keep-going  Fehler sammeln statt fail-fast
  -h, --help    Hilfe anzeigen
EOF_USAGE
}

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

while [[ $# -gt 0 ]]; do
  case "$1" in
    --keep-home)
      KEEP_HOME=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -m|-y|-c|--cars|-a|-l|--list|--keep-going)
      EXTRA_ARGS+=("$1")
      shift
      ;;
    *)
      printf 'Fehler: Unbekannte Option: %s\n' "$1" >&2
      usage
      exit 1
      ;;
  esac
done

TMP_HOME="$(mktemp -d /tmp/betankungen_final_smoke_XXXXXX)"

cleanup() {
  if $KEEP_HOME; then
    printf '[INFO] Temp-HOME behalten: %s\n' "$TMP_HOME"
  else
    rm -rf "$TMP_HOME"
  fi
}
trap cleanup EXIT

export HOME="$TMP_HOME"
export XDG_CONFIG_HOME="$TMP_HOME/.config"
export XDG_DATA_HOME="$TMP_HOME/.local/share"

printf '[INFO] Starte Smoke-Run in sauberer Sandbox: %s\n' "$TMP_HOME"
set +e
"$ROOT_DIR/tests/smoke/smoke_cli.sh" "${EXTRA_ARGS[@]}"
RC=$?
set -e

if [[ $RC -eq 0 ]]; then
  printf '[OK] Finaler Smoke-Run erfolgreich (RC=0)\n'
else
  printf '[FAIL] Finaler Smoke-Run fehlgeschlagen (RC=%d)\n' "$RC"
fi

exit $RC
