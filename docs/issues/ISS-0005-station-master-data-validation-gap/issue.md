---
id: ISS-0005
title: Station dialog accepts implausible mis-slotted master data
status: open
priority: P1
type: bug
tags: [stations, validation, ux, data-quality, needs-tests]
created: 2026-03-20
updated: 2026-03-20
related:
  - BL-0022
  - TSK-0014
---
**Stand:** 2026-03-20

# Summary
The station dialog currently accepts obviously implausible or shifted values and
stores them silently in master data fields.

# Observation
Examples such as `zip = 44abc`, `city = 44135` or `phone = Dortmund` can be
persisted without clear blocking or guided correction.

# Expected Behavior
The CLI should catch obviously implausible values or at least warn and
re-prompt when fields appear shifted.

# Actual Behavior
The dialog proceeds and stores the values, which later propagate into detail
views and station selections.

# Reproduction
1. Run `Betankungen --add stations`.
2. Enter deliberately sloppy or shifted values across address fields.
3. Inspect `--list stations --detail`.
4. Observe that implausible values were stored unchanged.

# Impact
This is a data-quality and UX defect: it creates avoidable data garbage and can
make later CLI output look untrustworthy.

# Acceptance Criteria
- [ ] Obvious field-shift and plausibility problems are detected.
- [ ] The dialog provides clear correction guidance instead of silent acceptance.
- [ ] Regression or user-flow coverage exists for representative bad inputs.
