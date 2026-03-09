# Betankungen Architecture (English Summary)
**Stand:** 2026-03-09

This document is a compact English summary of the system architecture.
The full and authoritative architecture narrative remains in `docs/ARCHITECTURE.md` (German).

## Architectural Baseline

- CLI-first application (no GUI framework, no web frontend)
- SQLite-based local storage
- Strict separation of concerns (parsing/validation/domain/output)
- Stable contracts for machine-readable outputs (JSON/CSV)
- Deterministic behavior for tests and automation

## Core Design Principles

- Immutable IDs: object identity is never reassigned
- Parse -> Validate -> Dispatch pipeline
- Central car-context resolution via `ResolveCarIdOrFail`
- Transaction safety for write operations
- Defensive input handling at system boundaries

## Domain Scope (Current)

- `cars`, `stations`, `fuelups`, `stats` are core
- `fuelups` are append-only
- Multi-car support with strict `car_id` scoping
- No implicit default `car_id=1` in multi-car setups

## Policy Model

- Policy matrix with hard-error vs warning+confirm paths
- Stable policy IDs (`P-xxx`) are engineering contracts
- Tests should assert stable signals (exit code, policy ID, DB state), not localized prose

## i18n Direction

- Sprint-4 policy: incremental i18n with `language=de|en|pl`
- User-facing runtime text moves through `u_i18n` (`TMsgId`, `Tr()`)
- JSON/CSV contracts, CLI flags, and policy IDs remain language-neutral

## Evolution Model

- Architecture decisions: `docs/ADR/README.md`
- Deferred work items: `docs/BACKLOG.md`
- Current status and roadmap: `docs/STATUS.md`
- Detailed architecture (German): `docs/ARCHITECTURE.md`
