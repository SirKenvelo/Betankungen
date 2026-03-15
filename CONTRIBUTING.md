# Contributing
**Stand:** 2026-03-15

Thank you for your interest in Betankungen.

## Current Contribution Policy

- The repository is public during pre-1.0 preparation; maintainership stays with the project owner.
- External issues are welcome.
- Pull requests are welcome after prior alignment in an issue/discussion.
- Maintainers may decline changes that do not match scope, roadmap, or quality bar.

## Communication

- GitHub issues, pull requests, and reviews should be written in English.
- Internal project documentation may remain in German.

## Technical Baseline

- Build command (from project root):
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`
- Run relevant smoke/domain-policy checks for changed behavior before opening a PR.

## Scope Expectations

- Keep changes focused and reversible.
- Avoid unrelated refactors in the same PR.
- Update docs when behavior, flags, output format, or architecture decisions change.

## Wiki Maintenance

- Public-readiness wiki pages are versioned under `docs/wiki/`.
- Wiki is an entry layer; repository docs under `docs/` remain source of truth.
- Run `make wiki-link-check` when wiki/source links are touched.

## License

By contributing, you agree that your contributions are provided under the
Apache License 2.0 used by this repository.
