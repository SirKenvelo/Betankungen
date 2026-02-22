#!/usr/bin/env bash
set -euo pipefail

# run_unit_tests.sh
# UPDATED: 2026-02-20
# Kompatibler Wrapper auf den neuen Domain-Policy-Runner.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec "$ROOT_DIR/tests/domain_policy/run_domain_policy_tests.sh" "$@"
