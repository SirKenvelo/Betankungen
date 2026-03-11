#!/usr/bin/env bash
set -euo pipefail

# repo_sync.sh
# CREATED: 2026-03-11
# UPDATED: 2026-03-11
# Stabiler, sequentieller Repo-Sync ohne parallele fetch/pull-Rennen.

usage() {
  cat <<'EOF_USAGE'
Usage:
  scripts/repo_sync.sh [--remote <name>] [--branch <name>] [--status-only] [-h]

Optionen:
  --remote <name>   Remote fuer Sync (Default: origin)
  --branch <name>   Ziel-Branch fuer fetch/rebase (Default: aktueller Branch)
  --status-only     Nur Branch/Upstream/Status anzeigen, kein Sync
  -h, --help        Diese Hilfe anzeigen
EOF_USAGE
}

REMOTE="origin"
BRANCH=""
STATUS_ONLY=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --remote)
      REMOTE="${2:-}"
      shift 2
      ;;
    --branch)
      BRANCH="${2:-}"
      shift 2
      ;;
    --status-only)
      STATUS_ONLY=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf '[FAIL] Unbekannte Option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$REMOTE" ]]; then
  printf '[FAIL] --remote darf nicht leer sein.\n' >&2
  exit 2
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

CURRENT_BRANCH="$(git branch --show-current || true)"
if [[ -z "$CURRENT_BRANCH" ]]; then
  printf '[FAIL] Kein lokaler Branch aktiv (detached HEAD).\n' >&2
  exit 3
fi

if [[ -z "$BRANCH" ]]; then
  BRANCH="$CURRENT_BRANCH"
fi

printf '[INFO] Repo: %s\n' "$ROOT_DIR"
printf '[INFO] Branch: %s\n' "$CURRENT_BRANCH"
printf '[INFO] Remote/Branch: %s/%s\n' "$REMOTE" "$BRANCH"

if $STATUS_ONLY; then
  git status --short --branch
  exit 0
fi

# Sequentiell und eindeutig: erst genau einen Branch fetchen, dann darauf rebasen.
git fetch "$REMOTE" "$BRANCH"
git rebase "$REMOTE/$BRANCH"
git status --short --branch

