# Security Policy
**Stand:** 2026-04-19

## Supported Versions

| Version line | Status |
| --- | --- |
| `1.4.0` | current maintained stable line |
| `1.3.0` | previous stable release line |
| `<= 1.2.x` | no active support commitment |

Security fixes will normally be prepared against the currently maintained
`1.4.0` line first and then evaluated for backporting when needed.

## Reporting a Vulnerability

- Do not open a public issue for exploitable security problems.
- Prefer GitHub private vulnerability reporting for this repository when that
  channel is available.
- If private vulnerability reporting is unavailable, contact the maintainer
  through a private GitHub channel before any public disclosure.
- Include affected version or commit, impact, reproduction steps, and any
  proposed mitigation if you already have one.

## Response Expectations

- Initial acknowledgement is targeted within 7 days.
- Valid reports will be triaged, reproduced when possible, and coordinated
  toward a fix or mitigation.
- Public disclosure should wait until a fix, mitigation, or explicit maintainer
  agreement exists.

## Out of Scope

- Pure documentation typos without security impact.
- Requests for general hardening advice without a reproducible issue.
- Reports that only restate automated scanner output without concrete impact
  or reproduction.

## Operational Notes

- Please avoid posting secrets, tokens, personal data, or production-like
  datasets in reports.
- For non-sensitive quality gaps, use the normal issue tracker and templates.
