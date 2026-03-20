---
id: ISS-0003
title: Fuelup dialog can loop on EOF in empty-state paths
status: open
priority: P0
type: bug
tags: [cli, fuelups, eof, robustness, needs-tests]
created: 2026-03-20
updated: 2026-03-20
related:
  - BL-0022
  - TSK-0012
  - TSK-0013
---
**Stand:** 2026-03-20

# Summary
Interactive fuelup flows can enter a repeating error loop when stdin is EOF and
the dialog still tries to continue through an empty-state station selection.

# Observation
`--add fuelups < /dev/null` does not terminate cleanly in all cases and can
spam the same input error repeatedly.

# Expected Behavior
EOF and other non-interactive abort conditions must be detected explicitly and
must terminate the command with a controlled error contract.

# Actual Behavior
The command can continue prompting and repeatedly emit
`Fehler: Bitte eine gültige Zahl eingeben.` instead of stopping.

# Reproduction
1. Ensure there are no stations in the active DB.
2. Run `Betankungen --add fuelups < /dev/null`.
3. Observe the repeated invalid-number output instead of a clean EOF abort.

# Impact
The current behavior is a real robustness defect for scripting, CI-style use
and operator confidence.

# Acceptance Criteria
- [ ] EOF is detected and terminates the dialog immediately.
- [ ] Empty-state station handling does not fall through into a prompt loop.
- [ ] Regression or smoke coverage exists for the non-interactive path.
