#!/usr/bin/env sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TESTDIR="$ROOT/tests"
BINDIR="$ROOT/bin"
BUILDDIR="$ROOT/build"

mkdir -p "$BINDIR"
mkdir -p "$BUILDDIR"

fpc \
  -Mobjfpc -Sh -gl -gw \
  -FE"$BINDIR" \
  -FU"$BUILDDIR" \
  -Fu"$ROOT/units" \
  -Fu"$ROOT/src" \
  "$TESTDIR/test_cli_validate.pas" \
  >/dev/null

"$BINDIR/test_cli_validate"
