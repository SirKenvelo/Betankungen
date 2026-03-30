# Contributing
**Stand:** 2026-03-30

Thank you for your interest in Betankungen.

## Current Contribution Policy

- The repository is public and currently on the active `1.4.0-dev`
  development line after a dedicated post-`1.3.0` activation commit.
- The main branch follows a PR-based workflow with green verification before
  merge; maintainership stays with the project owner.
- External issues are welcome.
- Pull requests are welcome after prior alignment in an issue/discussion.
- Maintainers may decline changes that do not match scope, roadmap, or quality bar.

## Communication

- GitHub issues, pull requests, and reviews should be written in English.
- Internal project documentation may remain in German.

## Community Standards

- Code of conduct: `CODE_OF_CONDUCT.md`
- Security reporting process: `SECURITY.md`
- Use the repository issue templates for bug reports and feature requests.
- Pull requests should keep the minimum structure `Summary` and `Validation`
  from `.github/pull_request_template.md`.

## Technical Baseline

- Build command (from project root):
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`
- Run relevant smoke/domain-policy checks for changed behavior before opening a PR.

## Scope Expectations

- Keep changes focused and reversible.
- Avoid unrelated refactors in the same PR.
- Update docs when behavior, flags, output format, or architecture decisions change.
- Do not mix version activation, feature scope, and unrelated cleanup in the
  same PR without an explicit reason.

## Wiki Maintenance

- Published GitHub Wiki: curated public entry layer for external readers.
- Repository docs under `docs/` remain the technical source of truth.
- `docs/wiki/` contains the versioned source pages for the published wiki.
- Personal/contextual pages may exist, but they stay secondary to the core
  technical entry path.
- Run `make wiki-link-check` when wiki/source links are touched.

## License

By contributing, you agree that your contributions are provided under the
Apache License 2.0 used by this repository.
