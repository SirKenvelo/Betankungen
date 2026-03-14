# Betankungen Documentation (English Entry)
**Stand:** 2026-03-14

This is the English entry point for the project documentation.
Detailed documents are currently maintained primarily in German.

## Current State

- Latest release: `0.8.0`
- Current development line: road to `0.9.x`
- S6 baseline is in place: module strategy accepted, companion handshake (`--module-info`) implemented, module smoke path available (`tests/smoke_modules.sh` / `--modules`)
- Sprint 10 C1 started: maintenance companion now has schema migration baseline via `--migrate [--db <path>]` (idempotent module schema init).
- Sprint 10 C2 delivered CRUD baseline in the maintenance companion: `--add maintenance` and `--list maintenance`.
- Sprint 10 C3 delivered maintenance stats baseline: `--stats maintenance` (text + JSON/pretty) with optional car scope (`--car-id`).
- Sprint 10 C4 hardened the module contract and smoke coverage (invalid stats/json combinations now explicitly regression-tested).
- Sprint 11 C1/C2 delivered an explicit cost integration mode: `--maintenance-source none|module`; `module` is now active and pulls maintenance cost from the companion binary with explicit fallback metadata when unavailable.
- Sprint 11 C3 hardened verification/CI for both integration modes with a dedicated regression gate (`tests/regression/run_cost_integration_modes_check.sh`) covering `none`, active `module`, and explicit fallback scenarios.
- S7 progressed to Fleet JSON MVP: `--stats fleet --json [--pretty]` plus export-meta baseline
- S7 guardrails hardened: fleet keeps strict rejects for `--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`
- Sprint 7 is functionally complete (Fleet MVP text + JSON + guardrail coverage)
- Sprint 8 progressed to Cost JSON MVP: `--stats cost --json [--pretty]` with export-meta baseline (`kind: "cost_mvp"`)
- Sprint 8 guardrails hardened for cost: invalid combos (`--csv`, `--monthly`, `--yearly`, `--dashboard`) are regression-covered
- Sprint 9 C1/C2/C3/C4: cost scope is active end-to-end and guardrailed. `--stats cost` accepts `--from/--to` and `--car-id`, collector/output apply the filters, cost JSON includes scope/period contract fields, and domain-policy `P-061` protects car/period isolation.
- Sprint 8 is functionally complete (Cost MVP text + JSON + guardrails, verified in domain-policy and smoke suites)

## Recommended Reading Order

1. `docs/ARCHITECTURE_EN.md` (compact English architecture summary)
2. `docs/README.md` (main project documentation, German)
3. `docs/STATUS.md` (current roadmap and completion state)
4. `docs/ARCHITECTURE.md` (full architecture and long-term design, German)
5. `docs/ADR/README.md` (architecture decisions index)
6. `docs/BACKLOG.md` (deferred/planned topics index)
7. `docs/CHANGELOG.md` (dated change history)

## Language Policy

- GitHub issues, pull requests, and code reviews: English
- Detailed project documentation: currently German-first, with incremental English entry docs

## Notes For Contributors

- See `CONTRIBUTING.md` in the project root.
- Build baseline:
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`
