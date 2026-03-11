# Betankungen Documentation (English Entry)
**Stand:** 2026-03-11

This is the English entry point for the project documentation.
Detailed documents are currently maintained primarily in German.

## Current State

- Latest release: `0.8.0`
- Current development line: road to `0.9.x`
- S6 baseline is in place: module strategy accepted, companion handshake (`--module-info`) implemented, module smoke path available (`tests/smoke_modules.sh` / `--modules`)
- S7 progressed to Fleet JSON MVP: `--stats fleet --json [--pretty]` plus export meta baseline
- S7 guardrails hardened: fleet keeps strict rejects for `--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`
- Sprint 7 is functionally complete (Fleet MVP text + JSON + guardrail coverage)
- Sprint 8 started with Cost MVP baseline: `--stats cost` (text, fuel-based; maintenance placeholder)

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
