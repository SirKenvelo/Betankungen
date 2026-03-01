#!/usr/bin/env bash
set -euo pipefail

# assert.sh
# UPDATED: 2026-03-01
#

_fail() {
  echo "FAIL: $*" >&2
  exit 1
}

_ok() {
  echo "$*"
}

assert_eq() {
  local got="${1-}" exp="${2-}" msg="${3-}"
  [[ "$got" == "$exp" ]] || _fail "${msg:-assert_eq} (got='$got' exp='$exp')"
}

assert_ne() {
  local got="${1-}" bad="${2-}" msg="${3-}"
  [[ "$got" != "$bad" ]] || _fail "${msg:-assert_ne} (got='$got' bad='$bad')"
}

assert_nonempty() {
  local got="${1-}" msg="${2-}"
  [[ -n "$got" ]] || _fail "${msg:-assert_nonempty} (empty)"
}

assert_int_ge() {
  local got="${1-}" min="${2-}" msg="${3-}"
  [[ "$got" =~ ^-?[0-9]+$ ]] || _fail "${msg:-assert_int_ge} (not int: '$got')"
  (( got >= min )) || _fail "${msg:-assert_int_ge} (got=$got min=$min)"
}

assert_file_exists() {
  local f="${1-}"
  [[ -f "$f" ]] || _fail "file missing: $f"
}