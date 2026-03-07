#!/usr/bin/env bash
set -euo pipefail

# sprint_artifact.sh
# UPDATED: 2026-03-07
# Erzeugt lokale Sprint-Artefakte fuer einen bestehenden Commit:
# - .artifacts/sprint_<nr>_commit_<nr>_von_<nr>.diff
# - .artifacts/sprint_<nr>_commit_<nr>_von_<nr>.md

SCRIPT_NAME="$(basename "$0")"

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Lokale Sprint-Artefakte aus bestehendem Commit erzeugen

Usage:
  $SCRIPT_NAME <sprint_nr> <commit_nr> <commit_total> [--commit HASH] [--outdir DIR] [--force]

Args:
  <sprint_nr>      Sprint-Nummer, z. B. 4
  <commit_nr>      Commit-Nummer im Sprint, z. B. 2
  <commit_total>   Gesamtzahl der Commit-Bloecke im Sprint, z. B. 3

Options:
  --commit HASH    Commit-Hash oder Ref (Default: HEAD)
  --outdir DIR     Zielordner fuer Artefakte (Default: .artifacts)
  --force          Bestehende Artefakte ueberschreiben
  -h, --help       Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME 4 2 3
  $SCRIPT_NAME 4 2 3 --commit c1a6348
  $SCRIPT_NAME 4 2 3 --outdir .artifacts
  $SCRIPT_NAME 4 2 3 --force
EOF_USAGE
}

die() {
  printf 'Fehler: %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Benoetigtes Kommando fehlt: $1"
}

is_posint() {
  [[ "${1:-}" =~ ^[1-9][0-9]*$ ]]
}

require_cmd git
require_cmd date

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

COMMIT_REF="HEAD"
OUTDIR=".artifacts"
FORCE=0
POSITIONAL=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --commit)
      [[ $# -ge 2 ]] || die "--commit erwartet einen Wert"
      COMMIT_REF="$2"
      shift 2
      ;;
    --outdir)
      [[ $# -ge 2 ]] || die "--outdir erwartet einen Wert"
      OUTDIR="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -* )
      die "Unbekannter Parameter: $1"
      ;;
    *)
      POSITIONAL+=("$1")
      shift
      ;;
  esac
done

[[ ${#POSITIONAL[@]} -eq 3 ]] || die "Es werden genau 3 Positionsargumente erwartet: <sprint_nr> <commit_nr> <commit_total>"

SPRINT_NR="${POSITIONAL[0]}"
COMMIT_NR="${POSITIONAL[1]}"
COMMIT_TOTAL="${POSITIONAL[2]}"

is_posint "$SPRINT_NR" || die "Sprint-Nummer muss eine positive Ganzzahl sein"
is_posint "$COMMIT_NR" || die "Commit-Nummer muss eine positive Ganzzahl sein"
is_posint "$COMMIT_TOTAL" || die "Commit-Gesamtzahl muss eine positive Ganzzahl sein"

if (( COMMIT_NR > COMMIT_TOTAL )); then
  die "Commit-Nummer darf nicht groesser als Commit-Gesamtzahl sein"
fi

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "Kein Git-Repository"
git rev-parse --verify "${COMMIT_REF}^{commit}" >/dev/null 2>&1 || die "Commit/Ref nicht gefunden: ${COMMIT_REF}"

FULL_HASH="$(git rev-parse "${COMMIT_REF}^{commit}")"
SHORT_HASH="$(git rev-parse --short=7 "${COMMIT_REF}^{commit}")"
SUBJECT="$(git log -1 --pretty=%s "$FULL_HASH")"
DATE_ISO="$(date +%F)"
COMMIT_DATE_ISO="$(git show -s --date=format:%F --format=%cd "$FULL_HASH")"

mkdir -p "$OUTDIR"

BASE="sprint_${SPRINT_NR}_commit_${COMMIT_NR}_von_${COMMIT_TOTAL}"
DIFF_FILE="${OUTDIR%/}/${BASE}.diff"
MD_FILE="${OUTDIR%/}/${BASE}.md"

if [[ $FORCE -ne 1 ]]; then
  [[ ! -e "$DIFF_FILE" ]] || die "Datei existiert bereits: $DIFF_FILE (verwende --force zum Ueberschreiben)"
  [[ ! -e "$MD_FILE" ]] || die "Datei existiert bereits: $MD_FILE (verwende --force zum Ueberschreiben)"
fi

# Diff/Show-Artefakt
git show --stat --patch --format=fuller "$FULL_HASH" > "$DIFF_FILE"

# Betroffene Dateien robust sammeln (inkl. Merge-Commits).
mapfile -t CHANGED_FILES < <(git show --name-only --pretty=format: "$FULL_HASH" | sed '/^$/d')

# Markdown-Datei erzeugen.
{
  printf '# Sprint %s - Commit %s von %s (S%sC%s/%s)\n' "$SPRINT_NR" "$COMMIT_NR" "$COMMIT_TOTAL" "$SPRINT_NR" "$COMMIT_NR" "$COMMIT_TOTAL"
  printf '**Stand:** %s\n\n' "$DATE_ISO"

  printf '## Ziel\n'
  printf 'Lokales Sprint-Artefakt fuer bestehenden Commit erzeugen.\n\n'

  printf '## Commit\n'
  printf -- '- Prefix: `[S%sC%s/%s]`\n' "$SPRINT_NR" "$COMMIT_NR" "$COMMIT_TOTAL"
  printf -- '- Hash: `%s`\n' "$SHORT_HASH"
  printf -- '- Voller Hash: `%s`\n' "$FULL_HASH"
  printf -- '- Message: `%s`\n' "$SUBJECT"
  printf -- '- Commit-Datum: `%s`\n\n' "$COMMIT_DATE_ISO"

  printf '## Enthaltene Aenderungen\n'
  if [[ ${#CHANGED_FILES[@]} -eq 0 ]]; then
    printf -- '- (keine geaenderten Dateien erkannt)\n'
  else
    for file in "${CHANGED_FILES[@]}"; do
      printf -- '- `%s`\n' "$file"
    done
  fi
  printf '\n'

  printf '## Artefakte\n'
  printf -- '- `%s`\n' "$(basename "$MD_FILE")"
  printf -- '- `%s`\n' "$(basename "$DIFF_FILE")"
} > "$MD_FILE"

printf 'Artefakte erstellt:\n'
printf '  %s\n' "$MD_FILE"
printf '  %s\n' "$DIFF_FILE"
printf 'Commit: %s (%s)\n' "$SHORT_HASH" "$SUBJECT"
