#!/usr/bin/env bash
set -euo pipefail

# smoke_multi_car_context.sh
# UPDATED: 2026-02-28
# Kompatibler Wrapper auf tests/smoke/smoke_multi_car_context.sh.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec "$ROOT_DIR/tests/smoke/smoke_multi_car_context.sh" "$@"
