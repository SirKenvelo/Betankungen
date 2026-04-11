---
id: ISS-0011
title: README entry flow hides product value and quick start
status: open
priority: P1
type: problem
tags: [readme, docs, onboarding, public-readiness, ux]
created: 2026-04-11
updated: 2026-04-11
related:
  - BL-0035
  - BL-0036
---
**Stand:** 2026-04-11

# Summary
The public repository entry currently surfaces project-state and governance
detail too early, while the user-facing product value, quick start path and
recommended first steps stay too easy to miss.

# Observation
The external entry audit showed a repeatable first-visit friction point:

- the repository `About` box gives a short product summary
- the `README` then moves quickly into `Project State`, sprint context and
  backlog references
- the most useful first-run hints live in the wiki, but the wiki entry is not
  surfaced early enough in the repo landing flow

This makes the repository feel maintained, but not immediately easy to try.

# Expected Behavior
The `README` should first answer three questions for a new visitor:

- what the tool does
- why it is useful
- how to try it quickly

Status, roadmap and internal planning detail should stay available, but not
dominate the first entry flow.

# Actual Behavior
The current landing sequence requires a new visitor to read through internal
state and planning cues before finding a clear quick-start or trial path.

# Reproduction
1. Open the public GitHub repository landing page as a first-time visitor.
2. Read the `About` box and the first screenful of the `README`.
3. Look for a short product explanation, installation hint and recommended
   first command path.
4. Observe that project-state and planning detail appear earlier and more
   prominently than the actionable entry path.

# Impact
This is a public-entry and discoverability problem. It reduces immediate
product clarity, raises the cognitive load for first-time visitors and makes
the wiki-based quick-start path harder to discover than necessary.

# Acceptance Criteria
- [ ] The top of the `README` leads with concise product value and primary use
      cases before internal status detail.
- [ ] A visible quick-start path appears near the top of the `README`.
- [ ] The recommended wiki or entry-layer path is surfaced early enough for a
      cold-start visitor.
- [ ] Internal status, sprint and backlog context remain available but no
      longer dominate the first repo-entry flow.
