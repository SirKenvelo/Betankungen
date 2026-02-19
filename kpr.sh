#!/usr/bin/env bash
set -euo pipefail

# kpr.sh
# UPDATED: 2026-02-13
# Kompatibler Wrapper: delegiert auf scripts/kpr.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$ROOT_DIR/scripts/kpr.sh" "$@"
