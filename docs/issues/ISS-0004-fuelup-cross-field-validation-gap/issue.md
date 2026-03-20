---
id: ISS-0004
title: Fuelups can be stored with contradictory price-liter-total combinations
status: open
priority: P1
type: bug
tags: [validation, fuelups, data-quality, needs-tests]
created: 2026-03-20
updated: 2026-03-20
related:
  - BL-0022
  - TSK-0014
---
**Stand:** 2026-03-20

# Summary
Fuelup records can currently be stored even when `total`, `liters` and
`price_per_liter` contradict each other by a large margin.

# Observation
Format-level validation exists, but cross-field plausibility validation is
missing.

# Expected Behavior
The CLI should reject or explicitly guard against grossly inconsistent
combinations of total price, liters and price per liter.

# Actual Behavior
A record such as `10.00 EUR`, `40.00 L`, `3.000 EUR/L` can be stored and then
flows unchanged into detail output and statistics.

# Reproduction
1. Run `Betankungen --add fuelups`.
2. Enter a valid station and otherwise syntactically valid values.
3. Use contradictory values for total, liters and price per liter.
4. Observe that the record is saved successfully.

# Impact
The application can persist data that is obviously wrong and then build
statistics on top of it.

# Acceptance Criteria
- [ ] Cross-field validation exists with a documented tolerance rule.
- [ ] Grossly inconsistent values are blocked or require a defined override path.
- [ ] Positive and negative regression coverage exists.
