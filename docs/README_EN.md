# Betankungen Documentation (English Entry)
**Stand:** 2026-03-26

This is the English entry point for the project documentation.
Detailed documents are currently maintained primarily in German.

## Current State

- Latest release: `1.2.0` (released on 2026-03-24).
- Current development line: `1.3.0-dev`.
- The active binding roadmap is `1.3.0` (`docs/ROADMAP_1_3_0.md`):
  - Gate 1 and Gate 2 are completed.
  - Gate 3 is completed.
  - Gate 4 is completed.
  - Gate 5 is active.
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
- `TSK-0020` for `BL-0018` is completed; the polling/history contract,
  storage-path separation, and minimal persistence baseline are documented in
  `docs/FUEL_PRICE_POLLING_HISTORY_CONTRACT_1_3_0.md`.
- `TSK-0021` for `BL-0018` is completed; the runtime baseline now includes the
  separate polling runner, raw/database/state persistence, and regression
  evidence in `docs/FUEL_PRICE_POLLING_RUNTIME_1_3_0.md`.
- Gate 4 is now backed by a dedicated `1.3.0` release-preflight blueprint and
  local entrypoint (`docs/RELEASE_1_3_0_PREFLIGHT.md`,
  `make release-preflight-1-3-0`).
- The Gate-4 closeout snapshot is documented, including the final local RC run
  and the latest CI reference on `main` (run `23515516312`,
  commit `027e963`).
- The Gate-5 kickoff snapshot for `1.3.0` is documented
  (`docs/RELEASE_1_3_0_PREFLIGHT.md`), including scope/version/audit/exit
  checkpoints for the finalization phase.
- The final Gate-5 release-switch package is prepared (target files and
  execution order are documented in `docs/RELEASE_1_3_0_PREFLIGHT.md`,
  without an early `APP_VERSION` switch).
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
