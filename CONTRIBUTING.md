# Contributing
**Stand:** 2026-04-19

Thank you for your interest in Betankungen.

This guide picks up after the public entry layer (`README.md`,
`docs/README_EN.md`, and the wiki) has already given enough orientation.

## Quickstart for a Small First Contribution

1. Align the idea in a GitHub issue or discussion before starting
   implementation.
2. Create a short-lived branch from `main` and keep the change focused,
   small, and reversible.
3. Update docs when behavior, flags, output format, or architecture guidance
   changes.
4. Run the minimum local path from the repository root:

```bash
make build
make verify
```

5. Add targeted checks when your change touches these areas:
   - tracker files under `docs/backlog/`, `docs/issues/`, or `docs/policies/`:
     `scripts/projtrack_lint.sh`
   - wiki source pages under `docs/wiki/` or wiki-facing links:
     `make wiki-link-check`
6. Open a pull request against `main` in English and keep the minimum PR
   structure `Summary` and `Validation`.
7. Mark the PR ready for review only after the relevant checks are green.

## Minimal PR Checklist

- Scope aligned in an issue or discussion
- Branch stays focused and does not mix unrelated cleanup
- Relevant docs updated for visible behavior or workflow changes
- `make verify` passed locally
- Extra targeted checks passed when tracker or wiki files were touched
- PR title, description, and review comments are written in English

## Current Contribution Policy

- The repository is public and currently held on the stable `1.4.0` line for
  maintenance, audits, and small documentation/governance follow-ups.
- No automatic `1.5.0-dev` line was started after the `1.4.0` release.
- The main branch follows a PR-based workflow with green verification before
  merge; maintainership stays with the project owner.
- External issues are welcome.
- Pull requests are welcome after prior alignment in an issue/discussion.
- Maintainers may decline changes that do not match scope, roadmap, or quality bar.

## Communication

- GitHub issues, pull requests, and reviews should be written in English.
- Public-facing entry and policy pages stay in English where they shape first
  contact or contribution truth (`README.md`, `docs/README_EN.md`, the wiki,
  `CONTRIBUTING.md`, `SECURITY.md`).
- Internal project documentation and deeper planning/tracker docs may remain
  German-first.

## Community Standards

- Code of conduct: `CODE_OF_CONDUCT.md`
- Security reporting process: `SECURITY.md`
- Use the repository issue templates for bug reports and feature requests.
- Pull requests should keep the minimum structure `Summary` and `Validation`
  from `.github/pull_request_template.md`.

## Technical Baseline

- Recommended contributor path from the project root:
  `make build` and `make verify`
- Canonical compiler invocation:
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
- Repository docs under `docs/` remain the technical source of truth and the
  canonical handoff for deeper context.
- `docs/wiki/` contains the versioned source pages for the published wiki and
  should stay link-oriented instead of restating deep documentation.
- Personal/contextual pages may exist, but they stay secondary to the core
  technical entry path.
- Run `make wiki-link-check` when wiki/source links are touched.

## License

By contributing, you agree that your contributions are provided under the
Apache License 2.0 used by this repository.
