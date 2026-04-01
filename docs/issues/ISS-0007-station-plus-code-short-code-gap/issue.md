---
id: ISS-0007
title: Station geodata flow rejects local short plus codes from common map UIs
status: resolved
priority: P2
type: bug
tags: [stations, geodata, plus-codes, ux, needs-tests]
created: 2026-04-01
updated: 2026-04-01
related:
  - BL-0019
---
**Stand:** 2026-04-01

# Summary
The station add/edit flow previously accepted only full Open Location Codes and
rejected local/short plus codes such as those commonly shown by Google Maps on
mobile devices.

# Observation
Users often see a short code plus locality suffix (for example
`GC2M+H4 Dortmund` or `GMMJ+JM Unna`) rather than the global code. Requiring a
separate conversion step makes the geodata flow unnecessarily frustrating.

# Expected Behavior
- Full/global plus codes should continue to work directly.
- Local/short plus codes should also be accepted when sufficient station
  coordinates are present.
- Error messages and prompts should clearly explain the rule.

# Actual Behavior
The CLI required a full Open Location Code and failed with `P-088` even when a
user provided a plausible short code from a map UI together with station
coordinates.

# Reproduction
1. Run `Betankungen --add stations` or `Betankungen --edit stations`.
2. Provide `latitude` and `longitude`.
3. Enter a short/local plus code with optional locality suffix
   (for example `GC2M+H4 Dortmund`).
4. Observe that the dialog aborts with `P-088`.

# Impact
This is a UX and data-entry defect: it blocks a realistic user path for
stations with geodata and asks users to perform manual conversion work outside
the application.

# Acceptance Criteria
- [x] Full/global plus codes remain accepted.
- [x] Local/short plus codes are accepted when `latitude` and `longitude` are set.
- [x] Local/short plus codes without coordinates fail with a clear guidance error.
- [x] Stored `plus_code` values remain canonical full codes.
- [x] Regression and domain-policy coverage exist for the new contract.

# Resolution
- `u_stations` now accepts either a full Open Location Code or a local/short
  plus code when station coordinates are present.
- Locality suffixes from common map UIs are ignored during normalization if
  the first token already contains the plus code.
- Short codes are recovered to a canonical full code from the provided
  coordinates before persistence, so the database keeps a consistent
  `plus_code` value.
- Prompts, policy docs, regression coverage and user-facing documentation were
  synchronized to the new contract.
