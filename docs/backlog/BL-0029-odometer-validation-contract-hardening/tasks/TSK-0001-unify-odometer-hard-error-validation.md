---
id: TSK-0001
title: Unify hard-error validation for negative odometer inputs
status: done
priority: P1
type: task
tags: [validation, cli, tests]
created: 2026-03-13
updated: 2026-03-31
parent: BL-0029
related:
  - BL-0029
  - ISS-0001
  - POL-001
---
**Stand:** 2026-03-31

# Task
Harmonize negative-odometer validation behavior so all relevant code paths
enforce the same hard-error contract and user-facing message quality.

# Notes
- Keep behavior aligned with existing domain-policy conventions.
- Prefer one canonical validation path to avoid drift.
- Ensure wording remains concise and action-oriented.
- Negative `odometer_km` inputs are now blocked before DB-relative checks and
  reuse one canonical CLI message.

# Done When
- [x] Validation logic is consistent across interactive/non-interactive paths.
- [x] Error output is policy-conform and deterministic.
- [x] Regression checks are added or updated.
