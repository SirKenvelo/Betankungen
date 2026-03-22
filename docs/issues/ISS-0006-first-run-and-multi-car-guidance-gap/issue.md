---
id: ISS-0006
title: First-run and multi-car guidance leave new CLI users without a clear path
status: resolved
priority: P2
type: bug
tags: [cli, onboarding, cars, ux, needs-tests]
created: 2026-03-20
updated: 2026-03-22
related:
  - BL-0022
  - TSK-0015
---
**Stand:** 2026-03-22

# Summary
Fresh CLI users do not consistently get a clear explanation of what was created
on first start, why a default car exists and when `--car-id` becomes mandatory
in multi-car scenarios.

# Observation
The user-flow tests showed several UX gaps around onboarding and context
switches:

- silent first start although config and DB were created
- unexplained default car `Hauptauto`
- abrupt behavior change once multiple cars exist

# Expected Behavior
The CLI should make the first-run state and the 0/1/>1-car rules explicit
enough that a new user can continue without guessing the next command.

# Actual Behavior
The application currently expects users to infer important state transitions
from side effects, sparse help text or later hard errors.

# Reproduction
1. Start the CLI in a fresh isolated HOME/XDG environment.
2. Observe the generated config/DB state and the initial car setup.
3. Add a second car and retry commands that previously worked without
   `--car-id`.
4. Observe that the guidance is incomplete or only appears after failure.

# Impact
This weakens onboarding, makes the CLI feel unpredictable and raises the risk
that users mistrust otherwise correct strict-mode behavior in multi-car flows.

# Acceptance Criteria
- [x] First-run behavior explicitly communicates what was created and what to do next.
- [x] The default-car behavior is explained or intentionally changed.
- [x] Multi-car help and error contracts consistently point users to `--car-id`.

# Resolution
- First-run bootstrap no longer stays silent in creation paths: it now reports
  created config/DB state and a concrete next step (`Betankungen --list cars`).
- Guidance now explicitly explains the default car `Hauptauto` in the bootstrap
  output.
- Multi-car resolver errors for fuelup flows now include a second guidance hint
  that points users to `--list cars` in addition to `--car-id`.
- Help text and smoke coverage were synchronized with the updated guidance
  contract.
