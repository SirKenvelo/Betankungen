#!/usr/bin/env bash
set -euo pipefail

# btkgit.sh
# CREATED: 2026-03-27
# UPDATED: 2026-03-27
# Repo-lokales Workflow-Wrapper-CLI gemaess ADR-0010.

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat <<'EOF_USAGE'
btkgit - repo-lokales Workflow-Wrapper-CLI

Usage:
  btkgit <command> [options]

Commands:
  sync
      Fuehrt Session-Sync aus: git fetch --prune origin + git pull --ff-only.

  preflight <version> [-- <args...>]
      Startet den versionsspezifischen Readiness-Preflight.
      Beispiel: btkgit preflight 1.3.0 -- --skip-verify

  ready [--skip-verify]
      Menschenlesbarer lokaler Readiness-Wrapper (Status + optional make verify).

  cleanup [--branch <name>]
      Nach Merge: checkout main, sync main, lokalen Branch loeschen.
      Ohne --branch wird (falls nicht auf main) der aktuelle Branch geloescht.

  help
      Diese Hilfe anzeigen.
EOF_USAGE
}

die() {
  printf '[FAIL] %s\n' "$*" >&2
  exit 1
}

info() {
  printf '[INFO] %s\n' "$*"
}

ok() {
  printf '[OK] %s\n' "$*"
}

run_cmd() {
  printf '[RUN]'
  for arg in "$@"; do
    printf ' %q' "$arg"
  done
  printf '\n'
  "$@"
}

require_repo() {
  [[ -d "$ROOT_DIR/.git" ]] || die "Kein Git-Repository gefunden unter $ROOT_DIR"
}

current_branch() {
  git -C "$ROOT_DIR" branch --show-current
}

cmd_sync() {
  require_repo
  run_cmd git -C "$ROOT_DIR" fetch --prune origin
  run_cmd git -C "$ROOT_DIR" pull --ff-only
  ok "Sync abgeschlossen."
}

list_available_preflights() {
  local path file base version
  for path in "$ROOT_DIR"/scripts/release_preflight_*.sh; do
    [[ -e "$path" ]] || continue
    file="$(basename "$path")"
    base="${file#release_preflight_}"
    version="${base%.sh}"
    version="${version//_/.}"
    printf '  - %s\n' "$version"
  done
}

resolve_preflight_script() {
  local version="$1"
  local normalized
  if [[ "$version" == "default" ]]; then
    printf '%s\n' "$ROOT_DIR/scripts/release_preflight.sh"
    return 0
  fi

  normalized="${version//./_}"
  printf '%s\n' "$ROOT_DIR/scripts/release_preflight_${normalized}.sh"
}

cmd_preflight() {
  require_repo
  local version script
  [[ $# -ge 1 ]] || die "preflight braucht eine Version (z. B. 1.3.0)."
  version="$1"
  shift

  # Erlaubt expliziten Argument-Passthrough via `--`.
  if [[ "${1:-}" == "--" ]]; then
    shift
  fi

  script="$(resolve_preflight_script "$version")"
  if [[ ! -x "$script" ]]; then
    printf '[FAIL] Kein passendes Preflight-Skript gefunden fuer Version: %s\n' "$version" >&2
    printf '[INFO] Verfuegbare Versionen:\n'
    list_available_preflights
    printf '[INFO] Fuer den allgemeinen Preflight ohne Versionssuffix nutze: btkgit preflight default\n'
    exit 1
  fi

  run_cmd "$script" "$@"
  ok "Preflight abgeschlossen fuer Version: $version"
}

cmd_ready() {
  require_repo
  local skip_verify=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --skip-verify)
        skip_verify=true
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unbekannte Option fuer ready: $1"
        ;;
    esac
  done

  run_cmd git -C "$ROOT_DIR" status --short --branch

  if $skip_verify; then
    info "make verify wurde via --skip-verify uebersprungen."
  else
    run_cmd make -C "$ROOT_DIR" verify
  fi

  ok "Readiness-Check abgeschlossen."
}

cmd_cleanup() {
  require_repo

  local explicit_branch=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --branch)
        [[ $# -ge 2 ]] || die "Option --branch braucht einen Branchnamen."
        explicit_branch="$2"
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        die "Unbekannte Option fuer cleanup: $1"
        ;;
    esac
  done

  local start_branch delete_branch
  start_branch="$(current_branch)"
  [[ -n "$start_branch" ]] || die "Kein aktiver Branch (detached HEAD)."

  delete_branch="$explicit_branch"
  if [[ -z "$delete_branch" && "$start_branch" != "main" ]]; then
    delete_branch="$start_branch"
  fi

  if [[ "$start_branch" != "main" ]]; then
    run_cmd git -C "$ROOT_DIR" checkout main
  fi

  run_cmd git -C "$ROOT_DIR" fetch --prune origin
  run_cmd git -C "$ROOT_DIR" pull --ff-only

  if [[ -n "$delete_branch" ]]; then
    [[ "$delete_branch" != "main" ]] || die "Branch 'main' darf nicht geloescht werden."
    run_cmd git -C "$ROOT_DIR" branch -d "$delete_branch"
    ok "Cleanup abgeschlossen (lokaler Branch geloescht: $delete_branch)."
  else
    info "Kein Loeschziel angegeben; lokaler Branch bleibt unveraendert."
    ok "Cleanup abgeschlossen."
  fi
}

main() {
  local cmd="${1:-help}"
  if [[ $# -gt 0 ]]; then
    shift
  fi

  case "$cmd" in
    sync)
      cmd_sync "$@"
      ;;
    preflight)
      cmd_preflight "$@"
      ;;
    ready)
      cmd_ready "$@"
      ;;
    cleanup)
      cmd_cleanup "$@"
      ;;
    help|-h|--help)
      usage
      ;;
    *)
      die "Unbekanntes Kommando: $cmd (nutze: btkgit help)"
      ;;
  esac
}

main "$@"
