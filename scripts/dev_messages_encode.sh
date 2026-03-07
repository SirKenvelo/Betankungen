#!/usr/bin/env bash
# Stand: 2026-03-07
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/dev_messages_encode.sh --in <messages.txt> [--out <dev_messages.b64>] [--force]

Input format:
  - Messages are separated by a line containing exactly: ---
  - Multi-line messages are supported.
  - Output format is one base64-encoded message per line.

Example:
  scripts/dev_messages_encode.sh --in /tmp/dev_messages.txt --out data/dev_messages.b64 --force
EOF
}

IN_FILE=""
OUT_FILE=""
FORCE=0

while (($# > 0)); do
  case "$1" in
    --in)
      IN_FILE="${2:-}"
      shift 2
      ;;
    --out)
      OUT_FILE="${2:-}"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown arg: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$IN_FILE" ]]; then
  echo "ERROR: --in is required." >&2
  usage >&2
  exit 2
fi

if [[ ! -f "$IN_FILE" ]]; then
  echo "ERROR: input file not found: $IN_FILE" >&2
  exit 1
fi

if [[ -n "$OUT_FILE" && -e "$OUT_FILE" && "$FORCE" -ne 1 ]]; then
  echo "ERROR: output exists: $OUT_FILE (use --force to overwrite)" >&2
  exit 1
fi

encode_stream() {
  local msg=""
  local line=""
  local has_non_ws=0

  flush_msg() {
    if [[ "$has_non_ws" -eq 1 ]]; then
      printf '%s' "$msg" | base64 -w 0
      printf '\n'
    fi
    msg=""
    has_non_ws=0
  }

  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" == "---" ]]; then
      flush_msg
      continue
    fi

    if [[ -n "$msg" ]]; then
      msg+=$'\n'
    fi
    msg+="$line"

    if [[ "$line" =~ [^[:space:]] ]]; then
      has_non_ws=1
    fi
  done < "$IN_FILE"

  flush_msg
}

if [[ -n "$OUT_FILE" ]]; then
  mkdir -p "$(dirname "$OUT_FILE")"
  encode_stream > "$OUT_FILE"
  echo "OK: wrote $(wc -l < "$OUT_FILE" | tr -d ' ') messages to $OUT_FILE"
else
  encode_stream
fi
