---
id: ISS-0002
title: Seed and demo flow are contractually inconsistent
status: open
priority: P1
type: bug
tags: [cli, demo, seed, regression, needs-tests]
created: 2026-03-20
updated: 2026-03-20
related:
  - BL-0022
  - TSK-0013
---
**Stand:** 2026-03-20

# Summary
`--seed` reports success and recommends `--demo` as a follow-up path, but the
direct `--demo` call can still fail immediately afterwards in a fresh
environment.

# Observation
The CLI currently promises an attachment path that is not reliably available
right after the seed run.

# Expected Behavior
If `--seed` reports success, at least one documented follow-up path must work
reliably:

- `Betankungen --demo ...`
- or only the explicit `--db <demo-path>` flow is advertised as canonical

# Actual Behavior
`--seed` succeeds, but `--demo --list stations` can still report that the
demo DB was not found, while the explicit `--db <printed-path>` call works.

# Reproduction
1. Run `Betankungen --seed --stations 3 --fuelups 5 --seed-value 7 --force` in
   a fresh isolated HOME/XDG environment.
2. Run `Betankungen --demo --list stations`.
3. Observe that the CLI can still fail with `Demo-DB nicht gefunden`.

# Impact
This breaks a prominent onboarding and demo path and directly weakens trust in
the CLI guidance.

# Acceptance Criteria
- [ ] `--seed` and `--demo` are behaviorally aligned.
- [ ] Success messaging only advertises guaranteed follow-up paths.
- [ ] Regression coverage exists for the fresh-environment path.
