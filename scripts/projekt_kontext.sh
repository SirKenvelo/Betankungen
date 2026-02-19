#!/usr/bin/env bash
set -euo pipefail

# projekt_kontext.sh
# UPDATED: 2026-02-19
# Erstellt eine Markdown-Datei mit Git-tracked Struktur und relevanten Dateiinhalten.

SCRIPT_NAME="$(basename "$0")"

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Projekt-Kontext fuer AI-Sessions erzeugen

Usage:
  $SCRIPT_NAME [output.md]

Beschreibung:
  - Liest die Git-tracked Struktur (wie auf GitHub sichtbar)
  - Fuegt den aktuellen Arbeitsstand via "git status --short --branch" ein
  - Zeigt kurze Diff-Summaries fuer unstaged und staged Aenderungen
  - Nimmt Inhalte aus .pas, .lpr, .md, .sh auf
  - Schreibt alles in eine Markdown-Datei (Default: projekt_kontext.md)
EOF_USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if ! command -v git >/dev/null 2>&1; then
  printf 'Fehler: git ist nicht installiert.\n' >&2
  exit 1
fi

ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$ROOT_DIR" ]]; then
  printf 'Fehler: Kein Git-Repository erkannt.\n' >&2
  exit 1
fi

cd "$ROOT_DIR"

OUTPUT_ARG="${1:-projekt_kontext.md}"
if [[ "$OUTPUT_ARG" == /* ]]; then
  OUTPUT_PATH="$OUTPUT_ARG"
else
  OUTPUT_PATH="$ROOT_DIR/$OUTPUT_ARG"
fi

mkdir -p "$(dirname "$OUTPUT_PATH")"

OUTPUT_REL=""
case "$OUTPUT_PATH" in
  "$ROOT_DIR"/*) OUTPUT_REL="${OUTPUT_PATH#"$ROOT_DIR"/}" ;;
esac

DATE_STR="$(date '+%Y-%m-%d %H:%M:%S %Z')"
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || printf 'n/a')"
COMMIT="$(git rev-parse --short HEAD 2>/dev/null || printf 'n/a')"
STATUS_SHORT_BRANCH="$(git status --short --branch || true)"
DIFF_STAT="$(git diff --stat || true)"
CACHED_DIFF_STAT="$(git diff --cached --stat || true)"

{
  printf '# Projekt-Kontext\n\n'
  printf '_Erstellt am: %s_\n\n' "$DATE_STR"
  printf '## Repository\n'
  printf -- '- Root: `%s`\n' "$ROOT_DIR"
  printf -- '- Branch: `%s`\n' "$BRANCH"
  printf -- '- Commit: `%s`\n\n' "$COMMIT"

  printf '## Verzeichnisstruktur (Git-tracked / GitHub-Sicht)\n'
  printf '```text\n'
  git ls-files | LC_ALL=C sort
  printf '```\n\n'

  printf '## Git-Status (short)\n'
  printf '```text\n'
  if [[ -n "$STATUS_SHORT_BRANCH" ]]; then
    printf '%s\n' "$STATUS_SHORT_BRANCH"
  else
    printf '(clean)\n'
  fi
  printf '```\n\n'

  printf '## Aenderungen (diff --stat)\n'
  printf '```text\n'
  if [[ -n "$DIFF_STAT" ]]; then
    printf '%s\n' "$DIFF_STAT"
  else
    printf '(keine unstaged Aenderungen)\n'
  fi
  printf '```\n\n'

  printf '## Staged Aenderungen (diff --cached --stat)\n'
  printf '```text\n'
  if [[ -n "$CACHED_DIFF_STAT" ]]; then
    printf '%s\n' "$CACHED_DIFF_STAT"
  else
    printf '(nichts staged)\n'
  fi
  printf '```\n\n'
} > "$OUTPUT_PATH"

FILE_COUNT=0
while IFS= read -r -d '' file; do
  if [[ -n "$OUTPUT_REL" && "$file" == "$OUTPUT_REL" ]]; then
    continue
  fi

  case "$file" in
    *.pas|*.lpr) lang="pascal" ;;
    *.md) lang="markdown" ;;
    *.sh) lang="bash" ;;
    *) lang="text" ;;
  esac

  {
    printf '## Datei: `%s`\n\n' "$file"
    printf '````%s\n' "$lang"
    cat -- "$file"
    printf '\n````\n\n'
  } >> "$OUTPUT_PATH"

  FILE_COUNT=$((FILE_COUNT + 1))
done < <(git ls-files -z -- '*.pas' '*.lpr' '*.md' '*.sh' | LC_ALL=C sort -z)

printf "Fertig: '%s' erstellt (%d Dateien).\n" "$OUTPUT_PATH" "$FILE_COUNT"
