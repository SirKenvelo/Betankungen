---
id: ISS-0010
title: P-050 reset prompt is misleading for normal short-distance fuelups
status: open
priority: P2
type: problem
tags: [fuelups, guidance, ux, policy, needs-tests]
created: 2026-04-03
updated: 2026-04-03
related:
  - ADR-0014
  - BL-0031
  - ISS-0009
  - TSK-0028
---
**Stand:** 2026-04-03

# Summary
Real usage showed that the current `P-050` prompt in `--add fuelups` can read
like a default suspicion that the user may have forgotten a fuelup even when
entering a normal short-distance fuelup.

# Observation
The current policy layer already separates two different situations:

- `P-012` handles large distance gaps and asks whether a fuelup may have been
  missed
- `P-050` allows a deliberate `missed_previous=1` reset even when the
  distance is small

That distinction is not communicated clearly enough in real usage. The recent
P1/P2 delta audit around the odometer guidance stayed green, but a later real
user run exposed this separate orange finding: the short-distance reset prompt
still feels too close to the normal add flow.

# Expected Behavior
Normal short-distance fuelups should proceed without a misleading reset
question. If a manual reset for small distances remains supported, it should
be framed as an explicit exception path, not as the default dialog
interpretation of a normal fuelup.

# Actual Behavior
The current `P-050` wording is technically correct for the underlying
`missed_previous` flag, but its phrasing and placement can suggest that a
normal short-distance fuelup is suspicious or incomplete.

# Reproduction
1. Run `Betankungen --add fuelups`.
2. Enter a normal fuelup with only a small distance since the previous entry.
3. Reach the current `P-050` interaction.
4. Observe that the wording reads like a possible missed-fuelup prompt even
   though the situation is not a large-distance gap.

# Impact
This is a UX and policy-framing problem. It can reduce confidence in the add
flow, blur the clear distinction between `P-012` and `P-050`, and make a
normal fuelup feel like a special-case correction path.

# Acceptance Criteria
- [ ] The short-distance reset case is tracked separately from the already
      open car-context / receipt-link guidance work.
- [ ] A follow-up task explicitly keeps `P-012` for large distance gaps
      unchanged.
- [ ] Any future manual reset for small distances is treated as an explicit
      exception flow instead of a misleading default prompt in normal fuelup
      entry.
