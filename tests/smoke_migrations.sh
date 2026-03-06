#!/usr/bin/env bash
set -euo pipefail

# smoke_migrations.sh
# UPDATED: 2026-03-06
# Kompatibler Wrapper auf tests/smoke/smoke_migrations.sh.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec "$ROOT_DIR/tests/smoke/smoke_migrations.sh" "$@"
