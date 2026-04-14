# Wiki Source
**Stand:** 2026-04-14

This folder contains the versioned source pages for the published
public-readiness wiki entry.

## Purpose

- GitHub Wiki: calm external entry layer for navigation and orientation.
- `Home.md`: visible entry page that points English-first visitors to
  `docs/README_EN.md` and keeps the German deep docs clearly separated.
- Repository docs (`docs/`): technical source of truth and deeper repository
  context.
- `docs/wiki/`: editorial source for the published wiki pages, not a second
  deep-documentation tree.

## Page Set

- `Home.md`
- `Getting-Started.md`
- `CLI-Quick-Reference.md`
- `Architecture-Short-Guide.md`
- `FAQ-Troubleshooting.md`
- `Troubleshooting-Playbooks.md`
- `Cookie-Note.md`

## Editorial Guardrails

- Keep wiki pages short, readable, and link-oriented.
- Let `docs/README_EN.md` and `docs/README.md` carry repository context while
  `docs/` carries contracts, release details, tracker state, and long-form
  history.
- Keep personal/contextual pages such as `Cookie-Note.md` secondary to the
  technical start path.
- Every page should point to concrete repository source-of-truth documents.

## Maintenance Flow

1. Edit wiki source pages in this folder.
2. Run `make wiki-link-check`.
3. Publish/sync the same content to the GitHub Wiki pages.
4. Keep deep technical details in `docs/` and link to them from wiki pages.
