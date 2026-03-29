# Betankungen
**Stand:** 2026-03-29

CLI project for fuel tracking, built with Free Pascal/Lazarus and SQLite.

## Project State

- Latest release: `1.3.0` (released on 2026-03-26)
- Technical runtime state: `APP_VERSION=1.3.0`
- Current repository state: deliberate transition hold after `1.3.0`
  (`1.4.0-dev` has not started yet)
- Sprint-29 start gate is documented in `docs/DEV_START_GATE_1_4_0.md`:
  current decision is `GO` for a separate activation commit, while the
  repository intentionally remains on `APP_VERSION=1.3.0`
- Most recently completed release roadmap: `1.3.0`
  (`docs/ROADMAP_1_3_0.md`, Gate 1 to Gate 5 completed)
- Planned next line: `1.4.0` remains pending; current in-repo follow-up scope
  is `BL-0016`, while `BL-0011` stays an external handover topic
  (`docs/BL-0011_SCOPE_DECISION_1_4_0.md`)

## Documentation

- Published GitHub Wiki (curated public entry): `https://github.com/SirKenvelo/Betankungen/wiki`
- English docs entry: `docs/README_EN.md`
- English architecture summary: `docs/ARCHITECTURE_EN.md`
- Main project documentation (currently German): `docs/README.md`
- Pre-activation start gate for `1.4.0-dev`: `docs/DEV_START_GATE_1_4_0.md`
- Fuel-price provider decision baseline: `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md`
- Fuel-price polling/history contract baseline: `docs/FUEL_PRICE_POLLING_HISTORY_CONTRACT_1_3_0.md`
- Fuel-price polling runtime baseline: `docs/FUEL_PRICE_POLLING_RUNTIME_1_3_0.md`
- Fuel-price release preflight baseline: `docs/RELEASE_1_3_0_PREFLIGHT.md`
- Curated project chronicle (Dev Diary): `docs/DEV_DIARY.md`
- Test strategy and matrix: `docs/TEST_MATRIX.md`
- Versioned wiki source pages: `docs/wiki/README.md`
- Architecture: `docs/ARCHITECTURE.md`
- Backlog index: `docs/BACKLOG.md`
- ADR index: `docs/ADR/README.md`
- Changelog: `docs/CHANGELOG.md`

## Language Note

Most detailed documentation is currently written in German.
The GitHub Wiki is a lighter public entry layer; binding technical details stay
in the repository docs under `docs/`.
Issue/PR/review communication on GitHub is expected in English.

## License

This project is licensed under the Apache License 2.0.
See `LICENSE`.

## Contributing

Contribution policy and workflow notes: `CONTRIBUTING.md`.
