# Betankungen Documentation (English Entry)
**Stand:** 2026-03-29

This is the English entry point for the project documentation.
Detailed documents are currently maintained primarily in German.

## Current State

- Latest release: `1.3.0` (released on 2026-03-26).
- Technical runtime state: `APP_VERSION=1.3.0`.
- The repository is in a deliberate transition hold after `1.3.0`;
  `1.4.0-dev` has not started yet.
- Sprint 29 documents the pre-activation start gate in
  `docs/DEV_START_GATE_1_4_0.md`: current decision is `GO` for a separate
  activation commit, while the activation itself is still pending.
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
- The next planned line remains `1.4.0`, but it is still on hold:
  - current prepared in-repo follow-up scope: `BL-0016`
  - `BL-0011` stays an external handover topic for this repository
    (`docs/BL-0011_SCOPE_DECISION_1_4_0.md`)
- CI/verify governance remains active for `main` (PR-based flow with green verification gate).

## Recommended Reading Order

1. `docs/ARCHITECTURE_EN.md` (compact English architecture summary)
2. `docs/README.md` (main project documentation, German)
3. `docs/DEV_START_GATE_1_4_0.md` (formal pre-activation gate before
   `1.4.0-dev`)
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
