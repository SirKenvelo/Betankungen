# Betankungen Documentation (English Entry)
**Stand:** 2026-04-11

Betankungen is a CLI-first fuel tracking and full-tank cycle statistics tool
for local SQLite data.
This page is the English repository entry when you need a little more context
than the public wiki provides.

## Start Here

Recommended first path for new visitors:

1. [GitHub Wiki](https://github.com/SirKenvelo/Betankungen/wiki)
2. [Getting Started](https://github.com/SirKenvelo/Betankungen/wiki/Getting-Started)
3. [CLI Quick Reference](https://github.com/SirKenvelo/Betankungen/wiki/CLI-Quick-Reference)
4. [Main project documentation (German)](README.md)

The wiki is the lighter public entry layer.
Repository docs under `docs/` remain the technical source of truth.

## Quick Project Fit

- Interactive fuel-up capture in a local SQLite database
- Multi-car workflow with strict car isolation
- Full-tank cycle statistics in text, JSON, CSV, monthly, and yearly views
- Additional fleet and cost views for broader snapshots

## Quick Repo Start

```bash
make build
./bin/Betankungen
./bin/Betankungen --add stations
./bin/Betankungen --add fuelups
./bin/Betankungen --stats fuelups
```

On a fresh local setup, running `./bin/Betankungen` without arguments creates
the config and SQLite database if needed and points to the next sensible step.
A new database starts with the default car `Hauptauto (ID 1)`, so you only
need to add a station before the first fuel-up flow.

## Current State

- Latest release: `1.3.0` (released on 2026-03-26)
- Technical runtime state: `APP_VERSION=1.4.0-dev`
- Active repository line: `1.4.0-dev`
- Status, roadmap, and planning detail: `docs/STATUS.md`,
  `docs/CHANGELOG.md`, `docs/SPRINTS.md`

## Recommended Reading Order

1. [English architecture summary](ARCHITECTURE_EN.md)
2. [Main project documentation (German)](README.md)
3. [Project status and roadmap](STATUS.md)
4. [Architecture decisions index](ADR/README.md)
5. [Backlog index](BACKLOG.md)
6. [Versioned wiki source pages](wiki/README.md)

## Language And Contribution Notes

- GitHub issues, pull requests, and code reviews: English
- Detailed project documentation: currently German-first, with incremental
  English entry docs
- Contribution guide: `../CONTRIBUTING.md`
- Community standards: `../CODE_OF_CONDUCT.md`, `../SECURITY.md`,
  `../.github/ISSUE_TEMPLATE/`, `../.github/pull_request_template.md`
- Build baseline:
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`
