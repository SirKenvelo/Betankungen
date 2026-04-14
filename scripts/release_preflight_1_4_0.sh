#!/usr/bin/env bash
set -euo pipefail

# release_preflight_1_4_0.sh
# CREATED: 2026-04-14
# UPDATED: 2026-04-14
# Release-Readiness-Preflight fuer 1.4.0 (Scope-Freeze, Governance-Fit und lokaler Gate-Run).

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

NOTE="1.4.0 readiness preflight"
SKIP_VERIFY=false
SKIP_DOC_GATES=false

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - 1.4.0 Readiness-Preflight ausfuehren

Usage:
  $SCRIPT_NAME [options]

Options:
  --skip-verify        ueberspringt 'make verify' (nur schnelle Dry-Run-Pruefungen)
  --skip-doc-gates     ueberspringt Gate-Status-/Doku-Guardrails aus den 1.4.0-Dokumenten
  --note TEXT          Notiz fuer kpr/backup dry-run (Default: "$NOTE")
  -h, --help           Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --skip-verify
  $SCRIPT_NAME --skip-doc-gates
  $SCRIPT_NAME --note "Preflight vor 1.4.0 Freigabe"
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

if [[ "$APP_VERSION" != "1.4.0-dev" ]]; then
  die "Preflight 1.4.0 erwartet APP_VERSION=1.4.0-dev (gefunden: $APP_VERSION)."
fi
ok "Versionierungs-Guardrail passt (1.4.0-dev aktiv)."

if grep -Eq 'commit\.gpgsign[[:space:]]+false' "$ROOT_DIR/tests/smoke/smoke_cli.sh"; then
  die "Smoke-Fixture deaktiviert weiterhin commit.gpgsign; Governance-Widerspruch ist nicht aufgeloest."
fi
ok "Smoke-Fixture deaktiviert keine Commit-Signatur-Policy."

if ! $SKIP_DOC_GATES; then
  info "Pruefe Gate-Status-/Doku-Guardrails fuer 1.4.0."

  check_doc_gate \
    "$ROOT_DIR/docs/ROADMAP_1_4_0.md" \
    '^# Verbindlicher Fahrplan bis Version 1\.4\.0$' \
    "Roadmap 1.4.0 ist vorhanden"

  check_doc_gate \
    "$ROOT_DIR/docs/ROADMAP_1_4_0.md" \
    'Gate 2: Scope-Freeze und Governance-Konsolidierung' \
    "Roadmap enthaelt Gate-2-Block"

  check_doc_gate \
    "$ROOT_DIR/docs/ROADMAP_1_4_0.md" \
    'abgeschlossen am 2026-04-14\.' \
    "Roadmap dokumentiert den Scope-Freeze-/Governance-Abschluss"

  check_doc_gate \
    "$ROOT_DIR/docs/ROADMAP_1_4_0.md" \
    'BL-0032' \
    "Roadmap referenziert BL-0032 im Scope-Freeze"

  check_doc_gate \
    "$ROOT_DIR/docs/ROADMAP_1_4_0.md" \
    'BL-0034' \
    "Roadmap referenziert BL-0034 im Scope-Freeze"

  check_doc_gate \
    "$ROOT_DIR/docs/STATUS.md" \
    '## Roadmap 1\.4\.0 - verbindlicher Fahrplan \(aktiv\)' \
    "Status-Doku fuehrt die aktive 1.4.0-Roadmap"

  check_doc_gate \
    "$ROOT_DIR/docs/STATUS.md" \
    'Gate 3 abgeschlossen am 2026-04-14' \
    "Status-Doku dokumentiert den Readiness-Rahmen"

  check_doc_gate \
    "$ROOT_DIR/docs/RELEASE_1_4_0_PREFLIGHT.md" \
    '\*\*Status:\*\* aktiv' \
    "Release-Preflight 1.4.0 ist als aktiv dokumentiert"

  check_doc_gate \
    "$ROOT_DIR/docs/RELEASE_1_4_0_PREFLIGHT.md" \
    'BL-0032' \
    "Release-Preflight referenziert den Scope-Freeze gegen BL-0032"

  check_doc_gate \
    "$ROOT_DIR/docs/RELEASE_1_4_0_PREFLIGHT.md" \
    'BL-0034' \
    "Release-Preflight referenziert den Scope-Freeze gegen BL-0034"
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

ok "1.4.0 Readiness-Preflight abgeschlossen."
