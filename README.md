# Betankungen
**Stand:** 2026-04-19

CLI-first fuel tracking and full-tank cycle statistics tool for local SQLite
data, built with Free Pascal as a Linux CLI application.
English entry path for first-time visitors: `docs/README_EN.md`. The public
GitHub Wiki is the lighter browsing layer. Detailed repository docs under
`docs/` stay German-first and remain the technical source of truth. The
curated project chronicle lives in `docs/DEV_DIARY.md`; it stays visible from
the entry layer, but it remains secondary to release facts and sprint
traceability.

## What Betankungen Does

- Capture fuel-ups interactively in a local SQLite database.
- Review per-car history in compact and detail views.
- Evaluate full-tank cycles in text, JSON, CSV, monthly, and yearly views.
- Inspect fleet and cost snapshots without moving data into a server workflow.

## Start Here

If you are new to the repository, use this path first:

1. [English docs entry](docs/README_EN.md)
2. [GitHub Wiki](https://github.com/SirKenvelo/Betankungen/wiki)
3. [Getting Started](https://github.com/SirKenvelo/Betankungen/wiki/Getting-Started)
4. [CLI Quick Reference](https://github.com/SirKenvelo/Betankungen/wiki/CLI-Quick-Reference)
5. [Stable release `1.4.0`](https://github.com/SirKenvelo/Betankungen/releases/tag/1.4.0)

The English docs entry is the primary repo entry; the GitHub Wiki is the
lighter public layer. Use the main project documentation in `docs/README.md`
when you need the deeper repository overview.
Repository docs under `docs/` remain the technical source of truth.
Stable release handoff lives on GitHub Releases; if a release does not ship
binary assets, the release notes point to the expected source-build path.

## Quick Start

```bash
make build
./bin/Betankungen
./bin/Betankungen --add stations
./bin/Betankungen --add fuelups
./bin/Betankungen --list fuelups --detail
./bin/Betankungen --stats fuelups
```

On a fresh local setup, running `./bin/Betankungen` without arguments creates
the config and SQLite database if needed and points to the next sensible step.
A new database starts with the default car `Hauptauto (ID 1)`, so you only
need to add a station before the first fuel-up flow.

## Typical Use Cases

- Keep a local fuel log per car.
- Review full-tank cycle efficiency and cost trends.
- Inspect recent fuel-ups in a detail view.
- Export or script statistics through JSON/CSV-friendly CLI paths.

## Current State

- Latest stable release:
  [`1.4.0`](https://github.com/SirKenvelo/Betankungen/releases/tag/1.4.0)
  (released on 2026-04-15)
- Public GitHub release handoff for the stable line is published on
  GitHub Releases for tag `1.4.0`
- Stable release consumption: the current public handoff for `1.4.0` uses
  source-build guidance via `make build`; binary assets are only expected when
  a release explicitly ships them
- Technical runtime state: `APP_VERSION=1.4.0`
- Active repository line: stable hold on `1.4.0`
- Gate 4 and Gate 5 for `1.4.0` are complete; exploratory follow-up blocks
  `BL-0032` and `BL-0034` remain outside the released line
- Release closeout record for the stable line:
  `docs/ROADMAP_1_4_0.md`, `docs/RELEASE_1_4_0_PREFLIGHT.md`
- No automatic `1.5.0-dev` line was started after the release
- `tests/smoke/smoke_cli.sh` exercises `btkgit` through a local bare remote
  with a real `main` ref and a fresh clone instead of overriding Git signing
  policy
- Security features stay mandatory even in test and fixture paths; blockers
  must be documented instead of bypassed
- Roadmap, gate history, and planning detail:
  `docs/STATUS.md`, `docs/CHANGELOG.md`, `docs/SPRINTS.md`

## Documentation

- [English docs entry](docs/README_EN.md)
- [Published GitHub Wiki](https://github.com/SirKenvelo/Betankungen/wiki)
  (recommended public entry)
- [Main project documentation (German)](docs/README.md)
- [English architecture summary](docs/ARCHITECTURE_EN.md)
- [Contribution guide](CONTRIBUTING.md)
- [Code of conduct](CODE_OF_CONDUCT.md)
- [Security reporting policy](SECURITY.md)
- [Versioned wiki source pages](docs/wiki/README.md)
- [Project status and roadmap](docs/STATUS.md)
- [Dev Diary](docs/DEV_DIARY.md)
- [1.4.0 roadmap and gates](docs/ROADMAP_1_4_0.md)
- [1.4.0 release preflight](docs/RELEASE_1_4_0_PREFLIGHT.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Backlog index](docs/BACKLOG.md)
- [ADR index](docs/ADR/README.md)
- [Changelog](docs/CHANGELOG.md)

## Language Note

Most detailed documentation is currently written in German.
GitHub issues, pull requests, and reviews should be written in English.

## License

This project is licensed under the Apache License 2.0.
See `LICENSE`.

## Contributing

Contribution policy and workflow notes: `CONTRIBUTING.md`.
Community standards: `CODE_OF_CONDUCT.md`, `SECURITY.md`,
`.github/ISSUE_TEMPLATE/`, `.github/pull_request_template.md`.
