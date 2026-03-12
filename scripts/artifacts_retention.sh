#!/usr/bin/env bash
set -euo pipefail

# artifacts_retention.sh
# CREATED: 2026-03-12
# UPDATED: 2026-03-12
# Bereinigt alte .artifacts/*.md|*.diff-Dateien mit Retention,
# behaelt Sprint-Historie standardmaessig vollstaendig.

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACT_DIR="$ROOT_DIR/.artifacts"
KEEP_GENERAL=20
DRY_RUN=false

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - .artifacts Retention mit Sprint-Historien-Schutz

Usage:
  $SCRIPT_NAME [options]

Options:
  -d, --dir DIR      Artefakt-Ordner (Default: .artifacts im Repo)
  -k, --keep N       Anzahl nicht-Sprint-Artefaktgruppen behalten (Default: 20)
                     Gruppe = gleicher Dateistamm, z. B. general_commit_x (md+diff)
  -n, --dry-run      Nur anzeigen, nichts loeschen
  -h, --help         Hilfe anzeigen

Regeln:
  - Sprint-Artefakte im Muster
    sprint_<nr>_commit_<nr>_von_<nr>.md|.diff
    werden nie geloescht.
  - Retention greift nur fuer nicht-Sprint-Dateien (*.md, *.diff).

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --dry-run
  $SCRIPT_NAME --keep 10
  $SCRIPT_NAME --dir /tmp/my_artifacts --keep 5 --dry-run
EOF_USAGE
}

die() {
  printf 'Fehler: %s\n' "$*" >&2
  exit 1
}

is_nonneg_int() {
  [[ "${1:-}" =~ ^[0-9]+$ ]]
}

is_sprint_file() {
  local name="$1"
  [[ "$name" =~ ^sprint_[0-9]+_commit_[0-9]+_von_[0-9]+\.(md|diff)$ ]]
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--dir)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument (Ordner)."
      ARTIFACT_DIR="$2"
      shift 2
      ;;
    -k|--keep)
      [[ $# -ge 2 ]] || die "Option $1 braucht eine nicht-negative Ganzzahl."
      KEEP_GENERAL="$2"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=true
      shift
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

is_nonneg_int "$KEEP_GENERAL" || die "Ungueltiger Wert fuer --keep: $KEEP_GENERAL"
[[ -d "$ARTIFACT_DIR" ]] || die "Artefakt-Ordner nicht gefunden: $ARTIFACT_DIR"

declare -A STEM_MTIME=()
declare -A STEM_FILES=()

SPRINT_PROTECTED=0
MANAGED_TOTAL=0
GENERAL_TOTAL=0

while IFS= read -r -d '' file_path; do
  file_name="$(basename "$file_path")"
  MANAGED_TOTAL=$((MANAGED_TOTAL + 1))

  if is_sprint_file "$file_name"; then
    SPRINT_PROTECTED=$((SPRINT_PROTECTED + 1))
    continue
  fi

  GENERAL_TOTAL=$((GENERAL_TOTAL + 1))
  stem="${file_name%.*}"
  mtime="$(stat -c %Y "$file_path")"

  if [[ -z "${STEM_MTIME[$stem]+x}" || "$mtime" -gt "${STEM_MTIME[$stem]}" ]]; then
    STEM_MTIME[$stem]="$mtime"
  fi

  if [[ -n "${STEM_FILES[$stem]:-}" ]]; then
    STEM_FILES[$stem]+=$'\n'
  fi
  STEM_FILES[$stem]+="$file_name"
done < <(find "$ARTIFACT_DIR" -maxdepth 1 -type f \( -name '*.md' -o -name '*.diff' \) -print0)

GENERAL_GROUPS=${#STEM_MTIME[@]}

printf '[INFO] Artefakt-Ordner: %s\n' "$ARTIFACT_DIR"
printf '[INFO] Verwalte Dateien (*.md/*.diff): %d\n' "$MANAGED_TOTAL"
printf '[INFO] Geschuetzte Sprint-Dateien: %d\n' "$SPRINT_PROTECTED"
printf '[INFO] Nicht-Sprint-Dateien: %d in %d Gruppe(n)\n' "$GENERAL_TOTAL" "$GENERAL_GROUPS"
printf '[INFO] Retention keep=%s fuer Nicht-Sprint-Gruppen\n' "$KEEP_GENERAL"

if (( GENERAL_GROUPS <= KEEP_GENERAL )); then
  printf '[OK] Nichts zu loeschen: Gruppen (%d) <= keep (%s).\n' "$GENERAL_GROUPS" "$KEEP_GENERAL"
  exit 0
fi

mapfile -t ORDERED_STEMS < <(
  for stem in "${!STEM_MTIME[@]}"; do
    printf '%s\t%s\n' "${STEM_MTIME[$stem]}" "$stem"
  done | sort -rn -k1,1 -k2,2 | cut -f2-
)

declare -a DELETE_FILES=()
for ((i = KEEP_GENERAL; i < ${#ORDERED_STEMS[@]}; i += 1)); do
  stem="${ORDERED_STEMS[$i]}"
  while IFS= read -r f; do
    [[ -n "$f" ]] && DELETE_FILES+=("$f")
  done <<< "${STEM_FILES[$stem]}"
done

printf '[INFO] Zu loeschen: %d Datei(en) in %d alter Gruppe(n).\n' "${#DELETE_FILES[@]}" "$(( GENERAL_GROUPS - KEEP_GENERAL ))"

if $DRY_RUN; then
  for f in "${DELETE_FILES[@]}"; do
    printf 'Dry-Run: wuerde loeschen: %s/%s\n' "$ARTIFACT_DIR" "$f"
  done
  printf '[OK] Dry-Run abgeschlossen.\n'
  exit 0
fi

for f in "${DELETE_FILES[@]}"; do
  rm -f "$ARTIFACT_DIR/$f"
  printf '[INFO] Geloescht: %s/%s\n' "$ARTIFACT_DIR" "$f"
done

printf '[OK] Retention abgeschlossen.\n'
