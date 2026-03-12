# Contributing
**Stand:** 2026-03-12

Thank you for your interest in Betankungen.

## Current Contribution Policy

- The repository may be private during pre-1.0 preparation, but maintainership stays with the project owner.
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

## License

By contributing, you agree that your contributions are provided under the
Apache License 2.0 used by this repository.
