#!/usr/bin/env bash
set -euo pipefail

# wiki_link_check.sh
# CREATED: 2026-03-15
# UPDATED: 2026-03-15
# Guardrail-Check fuer das Public-Readiness-Wiki-v1-Quellpaket.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WIKI_DIR="$ROOT_DIR/docs/wiki"

FAILED=0

info() {
  printf '[INFO] %s\n' "$*"
}

ok() {
  printf '[OK] %s\n' "$*"
}

fail() {
  printf '[FAIL] %s\n' "$*" >&2
  FAILED=1
}

require_file() {
  local path="$1"
  local label="$2"
  if [[ -f "$path" ]]; then
    ok "$label"
  else
    fail "$label fehlt: ${path#$ROOT_DIR/}"
  fi
}

require_pattern() {
  local path="$1"
  local pattern="$2"
  local label="$3"
  if grep -Eq "$pattern" "$path"; then
    ok "$label"
  else
    fail "$label nicht gefunden in ${path#$ROOT_DIR/}"
  fi
}

reject_pattern() {
  local path="$1"
  local pattern="$2"
  local label="$3"
  if grep -Eq "$pattern" "$path"; then
    fail "$label gefunden in ${path#$ROOT_DIR/}"
  else
    ok "$label"
  fi
}

check_relative_links() {
  local page="$1"
  local page_dir
  page_dir="$(dirname "$page")"

  while IFS= read -r token; do
    local rel target abs
    rel="${token#](}"
    rel="${rel%)}"
    rel="${rel%%#*}"
    [[ -n "$rel" ]] || continue

    target="$page_dir/$rel"
    abs="$(realpath -m "$target")"
    if [[ "$abs" != "$ROOT_DIR"/* ]]; then
      continue
    fi
    if [[ ! -f "$abs" ]]; then
      fail "Broken relative link in ${page#$ROOT_DIR/}: $rel"
    fi
  done < <(grep -oE ']\((\./|\.\./)[^)#]+' "$page" || true)
}

info "Pruefe Wiki-v1-Dateien"

require_file "$WIKI_DIR/README.md" "Wiki source readme"
require_file "$WIKI_DIR/Home.md" "Wiki page Home"
require_file "$WIKI_DIR/Getting-Started.md" "Wiki page Getting Started"
require_file "$WIKI_DIR/CLI-Quick-Reference.md" "Wiki page CLI Quick Reference"
require_file "$WIKI_DIR/Architecture-Short-Guide.md" "Wiki page Architecture Short Guide"
require_file "$WIKI_DIR/FAQ-Troubleshooting.md" "Wiki page FAQ/Troubleshooting"
require_file "$WIKI_DIR/Troubleshooting-Playbooks.md" "Wiki page Troubleshooting Playbooks"

info "Pruefe Pflichtreferenzen auf Source-of-Truth-Doku"

require_pattern "$WIKI_DIR/Home.md" 'https://github\.com/SirKenvelo/Betankungen/blob/main/docs/README_EN\.md' "Home verlinkt English docs entry"
require_pattern "$WIKI_DIR/Getting-Started.md" 'https://github\.com/SirKenvelo/Betankungen/blob/main/docs/README\.md' "Getting Started verlinkt docs README"
require_pattern "$WIKI_DIR/CLI-Quick-Reference.md" 'https://github\.com/SirKenvelo/Betankungen/blob/main/docs/EXPORT_CONTRACT\.md' "CLI Quick Reference verlinkt Export Contract"
require_pattern "$WIKI_DIR/Architecture-Short-Guide.md" 'https://github\.com/SirKenvelo/Betankungen/blob/main/docs/ARCHITECTURE_EN\.md' "Architecture guide verlinkt EN architecture"
require_pattern "$WIKI_DIR/FAQ-Troubleshooting.md" 'Troubleshooting-Playbooks\.md' "FAQ verlinkt Playbooks"
require_pattern "$WIKI_DIR/Troubleshooting-Playbooks.md" 'https://github\.com/SirKenvelo/Betankungen/blob/main/docs/MODULES_ARCHITECTURE\.md' "Playbooks verlinken Module-Architektur"

info "Pruefe bidirektionale Entry-Verlinkung"

require_pattern "$ROOT_DIR/README.md" 'docs/wiki/README\.md' "Root README verweist auf Wiki-Source"
require_pattern "$ROOT_DIR/CONTRIBUTING.md" 'docs/wiki/README\.md|docs/wiki/' "CONTRIBUTING verweist auf Wiki-Source"

info "Pruefe, dass Wiki-Seiten keine ../-Repo-Links verwenden"

for page in \
  "$WIKI_DIR/Home.md" \
  "$WIKI_DIR/Getting-Started.md" \
  "$WIKI_DIR/CLI-Quick-Reference.md" \
  "$WIKI_DIR/Architecture-Short-Guide.md" \
  "$WIKI_DIR/FAQ-Troubleshooting.md" \
  "$WIKI_DIR/Troubleshooting-Playbooks.md"; do
  reject_pattern "$page" ']\((\./|\.\./)' "Keine repo-relativen Links"
done

info "Pruefe relative Links in Wiki-Seiten"

for page in \
  "$WIKI_DIR/README.md" \
  "$WIKI_DIR/Home.md" \
  "$WIKI_DIR/Getting-Started.md" \
  "$WIKI_DIR/CLI-Quick-Reference.md" \
  "$WIKI_DIR/Architecture-Short-Guide.md" \
  "$WIKI_DIR/FAQ-Troubleshooting.md" \
  "$WIKI_DIR/Troubleshooting-Playbooks.md"; do
  check_relative_links "$page"
done

if [[ "$FAILED" -ne 0 ]]; then
  exit 1
fi

ok "Wiki Link-Check erfolgreich"
