#!/usr/bin/env bash
set -euo pipefail

# smoke_clean_home.sh
# UPDATED: 2026-02-20
# Kompatibler Wrapper auf tests/smoke/smoke_clean_home.sh.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec "$ROOT_DIR/tests/smoke/smoke_clean_home.sh" "$@"
