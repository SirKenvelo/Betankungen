#!/usr/bin/env bash
set -euo pipefail

# csv.sh
# UPDATED: 2026-03-01
# Requires: tests/helpers/assert.sh
# Strict CSV assumption: comma-separated, NO quoted commas/escapes.

# Globals for last loaded header
declare -gA CSV_H=()
declare -ga CSV_HEADER=()

_csv_split_line() {
  local line="${1-}"
  local -a out=()
  # Preserve empty fields: Bash read with IFS keeps empties between delimiters.
  IFS=',' read -r -a out <<< "$line"
  printf '%s\0' "${out[@]}"
}

csv_read_header() {
  local file="${1-}"
  assert_file_exists "$file"

  local header
  header="$(head -n 1 "$file")"
  [[ -n "$header" ]] || _fail "CSV header empty: $file"

  CSV_H=()
  CSV_HEADER=()

  local -a cols=()
  # read NUL-delimited from helper
  while IFS= read -r -d '' c; do cols+=("$c"); done < <(_csv_split_line "$header")

  local i=0
  for c in "${cols[@]}"; do
    [[ -n "$c" ]] || _fail "CSV has empty column name at index $i: $file"
    CSV_HEADER+=("$c")
    CSV_H["$c"]="$i"
    ((i += 1))
  done
}

csv_has_col() {
  local col="${1-}"
  [[ -n "${CSV_H[$col]+x}" ]]
}

csv_assert_has_cols() {
  local missing=()
  for col in "$@"; do
    csv_has_col "$col" || missing+=("$col")
  done
  if ((${#missing[@]}!=0)); then
    local have=""
    if ((${#CSV_HEADER[@]}!=0)); then
      have="${CSV_HEADER[*]}"
    else
      have="<empty>"
    fi
    _fail "CSV missing columns: ${missing[*]} (have: ${have})"
  fi
}

# Read Nth data row (1 = first data row after header) into array variable name.
csv_read_row() {
  local file="${1-}"
  local n="${2-}"
  local outvar="${3-}"

  assert_file_exists "$file"
  [[ "$n" =~ ^[0-9]+$ ]] || _fail "csv_read_row: n must be int, got '$n'"
  (( n >= 1 )) || _fail "csv_read_row: n must be >= 1"

  local line
  line="$(tail -n +2 "$file" | sed -n "${n}p")"
  [[ -n "$line" ]] || _fail "CSV row $n not found in $file"

  local -a fields=()
  while IFS= read -r -d '' f; do fields+=("$f"); done < <(_csv_split_line "$line")

  # nameref assignment
  declare -n _out="$outvar"
  _out=("${fields[@]}")
}

csv_get() {
  local rowvar="${1-}"
  local col="${2-}"

  csv_has_col "$col" || _fail "csv_get: unknown column '$col'"

  declare -n _row="$rowvar"
  local idx="${CSV_H[$col]}"

  # if idx beyond array, return empty (but usually indicates mismatch)
  if (( idx >= ${#_row[@]} )); then
    echo ""
  else
    echo "${_row[$idx]}"
  fi
}

csv_assert_eq() {
  local rowvar="${1-}" col="${2-}" exp="${3-}"
  local got
  got="$(csv_get "$rowvar" "$col")"
  assert_eq "$got" "$exp" "csv_assert_eq col=$col"
}

csv_assert_ne() {
  local rowvar="${1-}" col="${2-}" bad="${3-}"
  local got
  got="$(csv_get "$rowvar" "$col")"
  assert_ne "$got" "$bad" "csv_assert_ne col=$col"
}

csv_assert_int_ge() {
  local rowvar="${1-}" col="${2-}" min="${3-}"
  local got
  got="$(csv_get "$rowvar" "$col")"
  assert_int_ge "$got" "$min" "csv_assert_int_ge col=$col"
}

csv_assert_nonempty() {
  local rowvar="${1-}" col="${2-}"
  local got
  got="$(csv_get "$rowvar" "$col")"
  assert_nonempty "$got" "csv_assert_nonempty col=$col"
}
