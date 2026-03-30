# Betankungen Documentation (English Entry)
**Stand:** 2026-03-30

This is the English entry point for the project documentation.
Detailed documents are currently maintained primarily in German.

## Current State

- Latest release: `1.3.0` (released on 2026-03-26).
- Technical runtime state: `APP_VERSION=1.4.0-dev`.
- The repository is now on the active `1.4.0-dev` development line, started
  through a dedicated activation commit after the Sprint-29 gate.
- Sprint 29 remains documented in `docs/DEV_START_GATE_1_4_0.md` as the
  formal pre-activation gate record for this separate start step.
- The most recently completed binding roadmap is `1.3.0`
  (`docs/ROADMAP_1_3_0.md`):
  - Gate 1 and Gate 2 are completed.
  - Gate 3 is completed.
  - Gate 4 is completed.
  - Gate 5 is completed.
- The delivered release-blocking scope for the completed `1.3.0` line is:
  - `BL-0017`: provider decision baseline documented in
    `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md` (primary source:
    `Tankerkoenig`, fallback `Benzinpreis-Aktuell.de`).
  - `BL-0018`: polling/history contract and runtime baselines documented in
    `docs/FUEL_PRICE_POLLING_HISTORY_CONTRACT_1_3_0.md` and
    `docs/FUEL_PRICE_POLLING_RUNTIME_1_3_0.md`.
- The Gate-4 and Gate-5 closeouts for `1.3.0` are documented in
  `docs/RELEASE_1_3_0_PREFLIGHT.md`, including the final local RC run, final
  version switch, release/backup execution, and artifact references.
- The active in-repo follow-up scope for `1.4.0-dev` is now:
  - `BL-0016` as the first repository-internal content block
  - `BL-0011` as an external handover topic for this repository
    (`docs/BL-0011_SCOPE_DECISION_1_4_0.md`)
- CI/verify governance remains active for `main` (PR-based flow with green verification gate).

## Recommended Reading Order

1. `docs/ARCHITECTURE_EN.md` (compact English architecture summary)
2. `docs/README.md` (main project documentation, German)
3. `docs/DEV_START_GATE_1_4_0.md` (formal pre-activation gate record before
   the separate `1.4.0-dev` start)
4. `docs/STATUS.md` (current roadmap and completion state)
5. `docs/ARCHITECTURE.md` (full architecture and long-term design, German)
6. `docs/ADR/README.md` (architecture decisions index)
7. `docs/BACKLOG.md` (deferred/planned topics index)
8. `docs/CHANGELOG.md` (dated change history)
9. `docs/DEV_DIARY.md` (curated project chronicle, German)

## Language Policy

- GitHub issues, pull requests, and code reviews: English
- Detailed project documentation: currently German-first, with incremental English entry docs

## Notes For Contributors

- See `CONTRIBUTING.md` in the project root.
- Published public-readiness wiki entry:
  `https://github.com/SirKenvelo/Betankungen/wiki`.
- Versioned wiki source pages: `docs/wiki/README.md`.
- Build baseline:
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`
