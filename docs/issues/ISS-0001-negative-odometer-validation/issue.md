---
id: ISS-0001
title: Negative odometer values should fail with a clear hard error
status: resolved
priority: P1
type: bug
tags: [cli, validation, regression, needs-tests]
created: 2026-03-13
updated: 2026-03-31
related:
  - BL-0029
  - TSK-0001
  - POL-001
---
**Stand:** 2026-03-31

# Summary
Negative odometer values are not consistently rejected with a clear, actionable
error message in all relevant CLI input paths.

# Observation
Validation feedback differs between code paths and does not always point users
directly to the root cause (`odometer_km` must be >= 0 and monotonic per car).

# Expected Behavior
All affected commands reject negative odometer input with one consistent hard
error contract and non-zero exit status.

# Actual Behavior
Current behavior can vary across paths and may produce less explicit guidance
than desired.

# Reproduction
1. Run `Betankungen --add fuelups` (interactive flow).
2. Enter a negative value for odometer when prompted.
3. Observe whether the same hard-error contract and exit behavior is used as in
   non-interactive validation paths.

# Impact
Inconsistent validation feedback reduces operator confidence and can slow down
debugging and support.

# Acceptance Criteria
- [x] Negative odometer values are rejected consistently in all relevant paths.
- [x] Error text is clear and aligned with policy/CLI conventions.
- [x] Regression coverage exists (domain policy and/or smoke where relevant).

# Resolution
- The fuelup dialog now applies one canonical lower-bound input guard before
  any DB-relative odometer checks run.
- Negative values no longer drift into `P-010` based on car state; they fail
  with one actionable CLI contract that requires `odometer_km` to be a
  non-negative integer.
- Regression coverage now includes:
  - `tests/domain_policy/cases/t_p010__02__negative_odometer_input_contract.sh`
  - `tests/smoke/smoke_multi_car_context.sh` (1-car auto-resolve path)
