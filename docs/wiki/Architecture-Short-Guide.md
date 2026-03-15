# Architecture Short Guide
**Stand:** 2026-03-15

Betankungen follows a CLI-first architecture with explicit contracts and
regression gates.

## Core Principles

- Core orchestrates; units keep domain logic separated.
- SQLite local database, no server dependency.
- Additive contracts and no silent semantic breaks.
- Optional companion modules via explicit integration contracts.

## Where To Dive Deeper

- [Architecture summary (EN)](https://github.com/SirKenvelo/Betankungen/blob/main/docs/ARCHITECTURE_EN.md)
- [Full architecture (DE)](https://github.com/SirKenvelo/Betankungen/blob/main/docs/ARCHITECTURE.md)
- [Modules architecture](https://github.com/SirKenvelo/Betankungen/blob/main/docs/MODULES_ARCHITECTURE.md)
- [ADR index](https://github.com/SirKenvelo/Betankungen/blob/main/docs/ADR/README.md)
- [Tracker policy (POL-001)](https://github.com/SirKenvelo/Betankungen/blob/main/docs/policies/POL-001-tracker-standard.md)
