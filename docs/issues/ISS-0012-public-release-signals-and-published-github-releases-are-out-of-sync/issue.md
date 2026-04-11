---
id: ISS-0012
title: Public release signals and published GitHub releases are out of sync
status: open
priority: P1
type: problem
tags: [release, github, public-readiness, trust, docs]
created: 2026-04-11
updated: 2026-04-11
related:
  - BL-0035
---
**Stand:** 2026-04-11

# Summary
The public repository currently signals stable release availability more
strongly than the visible GitHub release surface supports, which weakens trust
for new users looking for a clear download or release-notes path.

# Observation
The external entry audit found a public consistency gap:

- the repository entry surfaces a latest stable release line
- the GitHub `Releases` page does not provide an equally clear public release
  handoff with published notes or user-facing delivery guidance

This creates friction even if source-based builds remain the intended default.

# Expected Behavior
Public release messaging, GitHub release surfaces and user expectations should
align clearly.

If stable releases are announced prominently, visitors should also find a
matching public release path with notes, delivery guidance or an explicitly
documented source-build expectation.

# Actual Behavior
The repository communicates release maturity, but the corresponding public
GitHub release surface does not yet provide the same level of visible closure
for first-time visitors.

# Reproduction
1. Open the public GitHub repository landing page.
2. Note the visible release messaging in the main entry documents.
3. Open the GitHub `Releases` page.
4. Observe that the public release surface does not yet reflect the same
   level of release guidance or distribution clarity.

# Impact
This is a trust and maintenance-signaling problem. New users can infer that
the project is release-oriented, then hesitate when the public GitHub release
surface does not clearly confirm how a stable release should be consumed.

# Acceptance Criteria
- [ ] Public release messaging and the GitHub `Releases` surface communicate a
      consistent release story.
- [ ] Stable releases expose at least one clear public handoff: release notes,
      download artifacts, or explicit source-build guidance.
- [ ] The chosen release strategy is documented consistently across the repo
      entry layer.
