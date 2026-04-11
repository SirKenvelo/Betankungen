# Betankungen
**Stand:** 2026-04-11

CLI-first fuel tracking and full-tank cycle statistics tool for local SQLite
data, built with Free Pascal/Lazarus.

## What Betankungen Does

- Capture fuel-ups interactively in a local SQLite database.
- Review per-car history in compact and detail views.
- Evaluate full-tank cycles in text, JSON, CSV, monthly, and yearly views.
- Inspect fleet and cost snapshots without moving data into a server workflow.

## Start Here

If you are new to the repository, use this path first:

1. [GitHub Wiki](https://github.com/SirKenvelo/Betankungen/wiki)
2. [Getting Started](https://github.com/SirKenvelo/Betankungen/wiki/Getting-Started)
3. [CLI Quick Reference](https://github.com/SirKenvelo/Betankungen/wiki/CLI-Quick-Reference)
4. [English docs entry](docs/README_EN.md)

The GitHub Wiki is the recommended public entry layer.
Repository docs under `docs/` remain the technical source of truth.

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

- Latest release: `1.3.0` (released on 2026-03-26)
- Technical runtime state: `APP_VERSION=1.4.0-dev`
- Active repository line: `1.4.0-dev`
- Roadmap, gate history, and planning detail:
  `docs/STATUS.md`, `docs/CHANGELOG.md`, `docs/SPRINTS.md`

## Documentation

- [Published GitHub Wiki](https://github.com/SirKenvelo/Betankungen/wiki)
  (recommended public entry)
- [English docs entry](docs/README_EN.md)
- [Main project documentation (German)](docs/README.md)
- [English architecture summary](docs/ARCHITECTURE_EN.md)
- [Contribution guide](CONTRIBUTING.md)
- [Code of conduct](CODE_OF_CONDUCT.md)
- [Security reporting policy](SECURITY.md)
- [Versioned wiki source pages](docs/wiki/README.md)
- [Project status and roadmap](docs/STATUS.md)
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
