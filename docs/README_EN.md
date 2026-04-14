# Betankungen Documentation (English Entry)
**Stand:** 2026-04-14

Betankungen is a CLI-first fuel tracking and full-tank cycle statistics tool
for local SQLite data.
Use this page as the English repository entry; the public wiki is the lighter
browsing layer. Detailed repository docs under `docs/` remain German-first
and are the technical source of truth.

## Start Here

Recommended first path for new visitors:

1. [GitHub Wiki](https://github.com/SirKenvelo/Betankungen/wiki)
2. [Getting Started](https://github.com/SirKenvelo/Betankungen/wiki/Getting-Started)
3. [CLI Quick Reference](https://github.com/SirKenvelo/Betankungen/wiki/CLI-Quick-Reference)
4. [Stable release `1.3.0`](https://github.com/SirKenvelo/Betankungen/releases/tag/1.3.0)

If you need the repository-level overview, continue with `README.md`.
The wiki is the lighter public entry layer.
Repository docs under `docs/` remain the technical source of truth.
Stable release handoff lives on GitHub Releases; when a release does not ship
binary assets, the release notes state the source-build expectation clearly.

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

- Latest stable release:
  [`1.3.0`](https://github.com/SirKenvelo/Betankungen/releases/tag/1.3.0)
  (released on 2026-03-26)
- Stable release consumption: the current public handoff for `1.3.0` uses
  source-build guidance via `make build`; binary assets are only expected when
  a release explicitly ships them
- Technical runtime state: `APP_VERSION=1.4.0-dev`
- Active repository line: `1.4.0-dev`
- Formal `1.4.0` scope freeze is active; exploratory follow-up blocks
  `BL-0032` and `BL-0034` stay outside the release line
- Release-readiness framework for the active line:
  `ROADMAP_1_4_0.md`, `RELEASE_1_4_0_PREFLIGHT.md`
- `tests/smoke/smoke_cli.sh` exercises `btkgit` through a local bare remote
  with a real `main` ref and a fresh clone instead of overriding Git signing
  policy
- Security features stay mandatory in test and fixture paths; blockers must
  be documented, not bypassed
- Status, roadmap, and planning detail: `docs/STATUS.md`,
  `docs/CHANGELOG.md`, `docs/SPRINTS.md`

## Recommended Reading Order

1. [Main project documentation (German)](README.md)
2. [Project status and roadmap](STATUS.md)
3. [English architecture summary](ARCHITECTURE_EN.md)
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
