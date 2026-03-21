---
id: ISS-0004
title: Fuelups can be stored with contradictory price-liter-total combinations
status: resolved
priority: P1
type: bug
tags: [validation, fuelups, data-quality, needs-tests]
created: 2026-03-20
updated: 2026-03-21
related:
  - BL-0022
  - TSK-0014
---
**Stand:** 2026-03-21

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
- [x] Cross-field validation exists with a documented tolerance rule.
- [x] Grossly inconsistent values are blocked or require a defined override path.
- [x] Positive and negative regression coverage exists.

# Resolution
- `P-033` eingefuehrt: Cross-Field-Guardrail fuer `total_cents` vs.
  `liters_ml * price_per_liter_milli_eur` mit dokumentierter
  Rundungs-/Toleranzregel (`<= 10` Cent).
- Bei starker Abweichung wird `Warning+Confirm` genutzt; bei `Confirm=NO` wird
  der Write-Pfad sauber abgebrochen.
- Domain-Policy-Abdeckung erweitert um:
  - `t_p033__01__price_total_mismatch_warn_yes.sh`
  - `t_p033__02__price_total_mismatch_warn_no.sh`
