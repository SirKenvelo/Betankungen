#!/usr/bin/env bash
set -euo pipefail

# btkgit.sh
# CREATED: 2026-03-27
# UPDATED: 2026-03-29
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
      Bei Auth-/Remote-/Upstream-Problemen gibt btkgit klare Hinweise aus,
      repariert Credentials oder Remote-Konfiguration aber nicht automatisch.

  preflight <version> [-- <args...>]
      Startet den versionsspezifischen Readiness-Preflight.
      Beispiel: btkgit preflight 1.3.0 -- --skip-verify

  ready [--skip-verify]
      Menschenlesbarer lokaler Readiness-Wrapper (Status + optional make verify).

  cleanup [--branch <name>] [--delete-local]
      Nach Merge: checkout main, sync main, lokalen Branch optional loeschen.
      Ohne --delete-local bleibt der lokale Branch bewusst erhalten.

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

hint() {
  printf '[INFO] %s\n' "$*" >&2
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

run_cmd_checked() {
  local output rc
  printf '[RUN]'
  for arg in "$@"; do
    printf ' %q' "$arg"
  done
  printf '\n'

  set +e
  output="$("$@" 2>&1)"
  rc=$?
  set -e

  if [[ -n "$output" ]]; then
    if [[ $rc -eq 0 ]]; then
      printf '%s\n' "$output"
    else
      printf '%s\n' "$output" >&2
    fi
  fi

  return $rc
}

require_repo() {
  [[ -d "$ROOT_DIR/.git" ]] || die "Kein Git-Repository gefunden unter $ROOT_DIR"
}

current_branch() {
  git -C "$ROOT_DIR" branch --show-current
}

origin_remote_url() {
  git -C "$ROOT_DIR" remote get-url origin 2>/dev/null || true
}

require_origin_remote() {
  local remote_url
  remote_url="$(origin_remote_url)"
  [[ -n "$remote_url" ]] || die "Remote 'origin' fehlt. btkgit erwartet einen origin-Remote fuer sync und cleanup."
}

print_git_failure_guidance() {
  local context="$1"
  local output="$2"
  local branch="${3:-}"
  local remote_url auth_hint=false remote_hint=false branch_hint=false network_hint=false

  remote_url="$(origin_remote_url)"
  if [[ -n "$remote_url" ]]; then
    hint "Kontext $context: origin -> $remote_url"
  else
    hint "Kontext $context: origin ist nicht konfiguriert."
  fi

  if grep -Eqi \
    'Authentication failed|Permission denied|could not read Username|access denied|Repository not found|requested URL returned error: 401|requested URL returned error: 403|403 Forbidden' \
    <<<"$output"; then
    auth_hint=true
    if [[ "$remote_url" == https://* ]]; then
      hint "Auth-Hinweis: pruefe 'gh auth status' oder erneuere die HTTPS-Credentials fuer GitHub."
    else
      hint "Auth-Hinweis: pruefe SSH-Key/Agent oder die Zugangsdaten fuer den Remote."
    fi
  fi

  if grep -Eqi \
    "No such remote 'origin'|does not appear to be a git repository|Could not read from remote repository|couldn't find remote ref" \
    <<<"$output"; then
    remote_hint=true
    hint "Remote-Hinweis: pruefe 'git remote -v' und den Zugriff auf 'origin'."
  fi

  if grep -Eqi \
    "There is no tracking information for the current branch|no upstream configured for branch" \
    <<<"$output"; then
    branch_hint=true
    if [[ -n "$branch" ]]; then
      hint "Branch-Hinweis: '$branch' hat noch kein Upstream. Nutze z. B.: git push -u origin $branch"
    else
      hint "Branch-Hinweis: dem aktuellen Branch fehlt ein Upstream. Nutze z. B.: git push -u origin <branch>"
    fi
  fi

  if grep -Eqi \
    "Could not resolve host|Failed to connect|Connection timed out|Connection refused|Network is unreachable|Operation timed out|Couldn't connect" \
    <<<"$output"; then
    network_hint=true
    hint "Netzwerk-Hinweis: pruefe Verbindung, Proxy/VPN oder GitHub-Erreichbarkeit und wiederhole danach den Befehl."
  fi

  if ! $auth_hint && ! $remote_hint && ! $branch_hint && ! $network_hint; then
    hint "btkgit fuehrt Git-Schritte transparent aus, behebt aber keine Remote- oder Credential-Probleme automatisch."
  fi
}

run_git_cmd_checked() {
  local context="$1"
  local branch output rc
  shift
  branch="$(current_branch 2>/dev/null || true)"

  set +e
  output="$(
    run_cmd_checked "$@" 2>&1
  )"
  rc=$?
  set -e

  if [[ -n "$output" ]]; then
    if [[ $rc -eq 0 ]]; then
      printf '%s\n' "$output"
    else
      printf '%s\n' "$output" >&2
    fi
  fi

  if [[ $rc -ne 0 ]]; then
    print_git_failure_guidance "$context" "$output" "$branch"
  fi

  return $rc
}

delete_local_branch() {
  local branch="$1"
  local output rc

  set +e
  output="$(
    run_cmd_checked git -C "$ROOT_DIR" branch -d "$branch" 2>&1
  )"
  rc=$?
  set -e

  if [[ -n "$output" ]]; then
    if [[ $rc -eq 0 ]]; then
      printf '%s\n' "$output"
    else
      printf '%s\n' "$output" >&2
    fi
  fi

  if [[ $rc -ne 0 ]]; then
    if grep -Eqi 'not fully merged' <<<"$output"; then
      hint "Cleanup-Hinweis: lokale Branch-Loeschung bleibt absichtlich konservativ ('git branch -d'). Merge oder pruefe den Branch zuerst manuell."
    elif grep -Eqi 'not found' <<<"$output"; then
      hint "Cleanup-Hinweis: pruefe den Branchnamen mit 'git branch --list'."
    fi
    die "Lokales Branch-Cleanup fehlgeschlagen."
  fi
}

cmd_sync() {
  require_repo
  require_origin_remote

  run_git_cmd_checked "git fetch --prune origin" \
    git -C "$ROOT_DIR" fetch --prune origin || die "Session-Sync konnte nicht abgeschlossen werden."
  run_git_cmd_checked "git pull --ff-only" \
    git -C "$ROOT_DIR" pull --ff-only || die "Session-Sync konnte nicht abgeschlossen werden."
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
  require_origin_remote

  local explicit_branch=""
  local delete_local=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --branch)
        [[ $# -ge 2 ]] || die "Option --branch braucht einen Branchnamen."
        explicit_branch="$2"
        shift 2
        ;;
      --delete-local)
        delete_local=true
        shift
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
  if $delete_local && [[ -z "$delete_branch" && "$start_branch" != "main" ]]; then
    delete_branch="$start_branch"
  fi

  if $delete_local && [[ -z "$delete_branch" ]]; then
    die "cleanup --delete-local braucht auf 'main' zusaetzlich --branch <name>."
  fi

  if [[ -n "$delete_branch" && "$delete_branch" == "main" ]]; then
    die "Branch 'main' darf nicht geloescht werden."
  fi

  if [[ "$start_branch" != "main" ]]; then
    run_git_cmd_checked "git checkout main" \
      git -C "$ROOT_DIR" checkout main || die "Cleanup konnte 'main' nicht auschecken."
  fi

  run_git_cmd_checked "git fetch --prune origin" \
    git -C "$ROOT_DIR" fetch --prune origin || die "Cleanup-Sync konnte nicht abgeschlossen werden."
  run_git_cmd_checked "git pull --ff-only" \
    git -C "$ROOT_DIR" pull --ff-only || die "Cleanup-Sync konnte nicht abgeschlossen werden."

  if $delete_local; then
    delete_local_branch "$delete_branch"
    ok "Cleanup abgeschlossen (lokaler Branch geloescht: $delete_branch)."
  else
    if [[ -n "$explicit_branch" ]]; then
      info "Branch '$explicit_branch' bleibt erhalten; fuer lokale Loeschung explizit --delete-local angeben."
    else
      info "Kein lokales Branch-Delete angefordert; cleanup bleibt bewusst konservativ."
    fi
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
