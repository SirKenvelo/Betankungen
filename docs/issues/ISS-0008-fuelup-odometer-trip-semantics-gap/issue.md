---
id: ISS-0008
title: Fuelup mileage prompt leaves total odometer and trip semantics ambiguous
status: open
priority: P2
type: problem
tags: [fuelups, odometer, semantics, ux, needs-tests]
created: 2026-04-02
updated: 2026-04-02
related:
  - ADR-0014
  - BL-0031
  - BL-0029
---
**Stand:** 2026-04-02

# Summary
The interactive `--add fuelups` flow currently asks only for
`Kilometerstand (km)`, which makes it too easy for a new user to wonder
whether the CLI expects the total vehicle odometer or the distance since the
last fuelup.

# Observation
The runtime and policy layer already behave consistently around the persisted
field `odometer_km`:

- comparisons are against `cars.odometer_start_km`
- monotonicity is enforced against the last fuelup per car
- duplicate or backwards mileage is rejected

What remains unclear is the user-facing semantic framing at input time.

# Expected Behavior
The add flow, help text and user documentation should make it explicit that
the current input means the **total odometer reading of the vehicle**, not a
trip/delta value.

# Actual Behavior
The prompt wording is semantically open enough that a new user can plausibly
hesitate or infer the wrong concept even though the persistence and validation
contract are strict.

# Reproduction
1. Run `Betankungen --add fuelups`.
2. Reach the prompt `Kilometerstand (km):`.
3. Compare the wording with a real-world user expectation of either total
   odometer or trip since the previous fuelup.
4. Observe that the dialog itself does not disambiguate the intended meaning.

# Impact
This is primarily a UX and semantics problem. Users can mistrust correct
validation behavior because the prompt does not clearly communicate the domain
concept behind `odometer_km`.

# Acceptance Criteria
- [ ] The current fuelup input contract is worded as total vehicle odometer.
- [ ] Help and user-facing documentation use the same terminology.
- [ ] Any later trip/delta convenience mode stays explicitly separate from the
      canonical `odometer_km` contract.
