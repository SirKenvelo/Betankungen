# Betankungen Documentation (English Entry)
**Stand:** 2026-03-24

This is the English entry point for the project documentation.
Detailed documents are currently maintained primarily in German.

## Current State

- Latest release: `1.2.0` (released on 2026-03-24).
- Current development line: `1.3.0-dev`.
- The active binding roadmap is `1.3.0` (`docs/ROADMAP_1_3_0.md`):
  - Gate 1 and Gate 2 are completed.
  - Gate 3 is active.
- Release-blocking scope for the completed `1.2.0` line is delivered:
  - `BL-0020` multi-database backup operations: done.
  - `BL-0021` receipt-photo link references: done.
- The next binding version sequence is fixed:
  - `1.3.0`: Option B (`BL-0017` + `BL-0018`).
  - `1.4.0`: Option C (`BL-0016` + `BL-0011`).
- Scope freeze for `1.3.0` is set:
  - `BL-0017` with `TSK-0018` / `TSK-0019` is release-blocking.
  - `BL-0018` with `TSK-0020` / `TSK-0021` is release-blocking.
- `BL-0017` is now completed; the provider decision baseline is documented in
  `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md` (primary source:
  `Tankerkoenig`, fallback: `Benzinpreis-Aktuell.de`).
- Non-blocking hardening stream `BL-0022` is completed and delivered key fixes:
  - EOF-safe fuelup dialog and seed/demo smoke hardening.
  - Fuelup cross-field validation guardrail (`P-033`).
  - Station master-data plausibility validation (`P-080` to `P-084`).
  - Multi-car resolver smoke sync for the extra `P-050` prompt.
  - Improved first-run and multi-car guidance in CLI/help paths.
- CI/verify governance remains active for `main` (PR-based flow with green verification gate).

## Recommended Reading Order

1. `docs/ARCHITECTURE_EN.md` (compact English architecture summary)
2. `docs/README.md` (main project documentation, German)
3. `docs/STATUS.md` (current roadmap and completion state)
4. `docs/ARCHITECTURE.md` (full architecture and long-term design, German)
5. `docs/ADR/README.md` (architecture decisions index)
6. `docs/BACKLOG.md` (deferred/planned topics index)
7. `docs/CHANGELOG.md` (dated change history)
8. `docs/DEV_DIARY.md` (curated project chronicle, German)

## Language Policy

- GitHub issues, pull requests, and code reviews: English
- Detailed project documentation: currently German-first, with incremental English entry docs

## Notes For Contributors

- See `CONTRIBUTING.md` in the project root.
- Public-readiness wiki source pages: `docs/wiki/README.md`.
- Build baseline:
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`
