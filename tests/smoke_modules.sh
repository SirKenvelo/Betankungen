#!/usr/bin/env bash
set -euo pipefail

# smoke_modules.sh
# UPDATED: 2026-03-10
# Kompatibler Wrapper auf tests/smoke/smoke_modules.sh.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec "$ROOT_DIR/tests/smoke/smoke_modules.sh" "$@"
