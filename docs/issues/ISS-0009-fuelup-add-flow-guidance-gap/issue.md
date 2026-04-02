---
id: ISS-0009
title: Fuelup add flow hides active car context and receipt-link timing
status: open
priority: P2
type: problem
tags: [fuelups, cars, receipts, guidance, ux, needs-tests]
created: 2026-04-02
updated: 2026-04-02
related:
  - BL-0021
  - BL-0031
  - ISS-0006
---
**Stand:** 2026-04-02

# Summary
The interactive `--add fuelups` flow currently makes two important pieces of
context too easy to miss for new users: which car is active and when a
`--receipt-link` must be supplied.

# Observation
Real usage showed two guidance gaps:

- the add flow does not make the resolved car context visible enough once the
  resolver picked a car
- users can finish the dialog and only then realize that a receipt link would
  have needed the upfront flag `--receipt-link`

This matters because fuelups are append-only and cannot be edited later.

# Expected Behavior
The add flow should make the active car context and the receipt-link timing
clear before the user commits data.

# Actual Behavior
The resolver and receipt-link contract are technically correct, but the dialog
guidance stays too implicit for first-time or infrequent users.

# Reproduction
1. Run `Betankungen --add fuelups`.
2. Let the command resolve a car automatically or rely on remembered car
   context from a previous run.
3. Complete the interactive prompts without `--receipt-link`.
4. Observe that the car assignment is not highlighted enough and the missing
   receipt-link timing becomes obvious only after the fact.

# Impact
This weakens confidence in multi-car usage, increases the chance of storing a
fuelup under the wrong mental context and makes the receipt-link feature easy
to miss despite the append-only design.

# Acceptance Criteria
- [ ] The add flow makes the active car context visible before data entry
      continues.
- [ ] User-facing help/docs explain that `--receipt-link` must be provided
      before the interactive add flow starts.
- [ ] The append-only nature of `fuelups` is referenced where this guidance is
      needed most.
