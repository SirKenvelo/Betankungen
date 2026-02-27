#!/usr/bin/env bash
set -euo pipefail

# smoke_cars_crud.sh
# UPDATED: 2026-02-27
# Kompatibler Wrapper auf tests/smoke/smoke_cars_crud.sh.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec "$ROOT_DIR/tests/smoke/smoke_cars_crud.sh" "$@"
