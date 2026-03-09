# Betankungen Documentation (English Entry)
**Stand:** 2026-03-09

This is the English entry point for the project documentation.
Detailed documents are currently maintained primarily in German.

## Current State

- Latest release: `0.8.0`
- Current development line: road to `0.9.x`

## Recommended Reading Order

1. `docs/README.md` (main project documentation, German)
2. `docs/STATUS.md` (current roadmap and completion state)
3. `docs/ARCHITECTURE.md` (system architecture and long-term design)
4. `docs/ADR/README.md` (architecture decisions index)
5. `docs/BACKLOG.md` (deferred/planned topics index)
6. `docs/CHANGELOG.md` (dated change history)

## Language Policy

- GitHub issues, pull requests, and code reviews: English
- Detailed project documentation: currently German-first, with incremental English entry docs

## Notes For Contributors

- See `CONTRIBUTING.md` in the project root.
- Build baseline:
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`
