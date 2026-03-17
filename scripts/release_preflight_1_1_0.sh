#!/usr/bin/env bash
set -euo pipefail

# release_preflight_1_1_0.sh
# CREATED: 2026-03-17
# UPDATED: 2026-03-17
# Release-Readiness-Preflight fuer 1.1.0 (lokaler Gate-Run + Dry-Run der Release-Werkzeuge).

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

NOTE="1.1.0 readiness preflight"
SKIP_VERIFY=false
SKIP_DOC_GATES=false

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - 1.1.0 Readiness-Preflight ausfuehren

Usage:
  $SCRIPT_NAME [options]

Options:
  --skip-verify        ueberspringt 'make verify' (nur schnelle Dry-Run-Pruefungen)
  --skip-doc-gates     ueberspringt Gate-Status-/Doku-Guardrails aus den 1.1.0-Dokumenten
  --note TEXT          Notiz fuer kpr/backup dry-run (Default: "$NOTE")
  -h, --help           Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --skip-verify
  $SCRIPT_NAME --skip-doc-gates
  $SCRIPT_NAME --note "Preflight vor 1.1.0 Freigabe"
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

check_doc_gate() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  [[ -f "$file" ]] || die "Dokument fehlt fuer Gate-Check: $file"
  if grep -Eq "$pattern" "$file"; then
    ok "$label"
  else
    die "$label (Pattern nicht gefunden in $file)"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-verify)
      SKIP_VERIFY=true
      shift
      ;;
    --skip-doc-gates)
      SKIP_DOC_GATES=true
      shift
      ;;
    --note)
      [[ $# -ge 2 ]] || die "Option --note braucht einen Text."
      NOTE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unbekannte Option: $1 (nutze --help)"
      ;;
  esac
done

cd "$ROOT_DIR"

command -v make >/dev/null 2>&1 || die "Tool fehlt: make"
command -v fpc >/dev/null 2>&1 || die "Tool fehlt: fpc"
command -v sqlite3 >/dev/null 2>&1 || die "Tool fehlt: sqlite3"
[[ -x "$ROOT_DIR/kpr.sh" ]] || die "kpr.sh nicht ausfuehrbar."
[[ -x "$ROOT_DIR/scripts/backup_snapshot.sh" ]] || die "scripts/backup_snapshot.sh nicht ausfuehrbar."

APP_VERSION="$(awk -F"'" '/APP_VERSION/ {print $2; exit}' "$ROOT_DIR/src/Betankungen.lpr")"
if [[ -z "$APP_VERSION" ]]; then
  die "APP_VERSION konnte aus src/Betankungen.lpr nicht gelesen werden."
fi
info "APP_VERSION erkannt: $APP_VERSION"

if [[ "$APP_VERSION" != "1.1.0-dev" ]]; then
  die "Preflight 1.1.0 erwartet APP_VERSION=1.1.0-dev (gefunden: $APP_VERSION)."
fi
ok "Versionierungs-Guardrail passt (1.1.0-dev aktiv)."

if ! $SKIP_DOC_GATES; then
  info "Pruefe Gate-Status-/Doku-Guardrails fuer 1.1.0."

  check_doc_gate \
    "$ROOT_DIR/docs/BACKLOG.md" \
    'BL-0014[^\n]*Status: `done`' \
    "Backlog-Index fuehrt BL-0014 als done"

  check_doc_gate \
    "$ROOT_DIR/docs/backlog/BL-0014-import-export-package-format/tasks/TSK-0006-define-package-manifest-v1-and-dry-run-fixtures.md" \
    '^status:\s*done$' \
    "TSK-0006 ist auf done gesetzt"

  check_doc_gate \
    "$ROOT_DIR/docs/backlog/BL-0015-release-verify-hardening-1-1-0/item.md" \
    '^status:\s*(approved|in_progress|done)$' \
    "BL-0015 ist als aktiver Hardening-Block dokumentiert"

  check_doc_gate \
    "$ROOT_DIR/docs/ROADMAP_1_1_0.md" \
    'Gate 2: Scope-Freeze 1.1.0' \
    "Roadmap enthaelt Gate-2-Scope-Freeze"

  check_doc_gate \
    "$ROOT_DIR/docs/ROADMAP_1_1_0.md" \
    '(aktiv \(`BL-0014` done, `BL-0015` (in Arbeit|done[^)]*)\)|abgeschlossen am [0-9]{4}-[0-9]{2}-[0-9]{2} \(Gate-4-Start aktiviert\)\.)' \
    "Roadmap zeigt den dokumentierten Gate-3-Status"

  check_doc_gate \
    "$ROOT_DIR/docs/ROADMAP_1_1_0.md" \
    'Gate 4: Release-Candidate-Haertung' \
    "Roadmap enthaelt Gate-4-Block"

  check_doc_gate \
    "$ROOT_DIR/docs/CONTRACT_HARDENING_1_1_0.md" \
    'Preflight-Blueprint.*\| (in_progress|done) \|' \
    "Contract-Hardening-Matrix fuehrt Preflight-Blueprint als aktiv bearbeitet"

  check_doc_gate \
    "$ROOT_DIR/docs/RELEASE_1_1_0_PREFLIGHT.md" \
    '\*\*Status:\*\* (vorbereitet|aktiv)' \
    "Release-Preflight-Blueprint ist dokumentiert"
else
  info "Gate-Status-/Doku-Guardrails wurden via --skip-doc-gates uebersprungen."
fi

if ! $SKIP_VERIFY; then
  info "Starte Vollpruefung: make verify"
  make verify
  ok "make verify erfolgreich."
else
  info "make verify wurde via --skip-verify uebersprungen."
fi

info "Stelle Smoke-Fixtures sicher (lokales Fallback-Archiv in .releases)."
make smoke-fixtures
ok "Smoke-Fixtures vorbereitet."

info "Pruefe Release-Archivierung im Dry-Run."
"$ROOT_DIR/kpr.sh" --dry-run --note "$NOTE"
ok "kpr dry-run erfolgreich."

info "Pruefe Backup-Snapshot im Dry-Run."
"$ROOT_DIR/scripts/backup_snapshot.sh" --dry-run --note "$NOTE"
ok "backup_snapshot dry-run erfolgreich."

ok "1.1.0 Readiness-Preflight abgeschlossen."
