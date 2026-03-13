---
id: ISS-0001
title: Negative odometer values should fail with a clear hard error
status: open
priority: P1
type: bug
tags: [cli, validation, regression, needs-tests]
created: 2026-03-13
updated: 2026-03-13
related:
  - BL-0011
  - TSK-0001
  - POL-001
---
**Stand:** 2026-03-13

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
- [ ] Negative odometer values are rejected consistently in all relevant paths.
- [ ] Error text is clear and aligned with policy/CLI conventions.
- [ ] Regression coverage exists (domain policy and/or smoke where relevant).
