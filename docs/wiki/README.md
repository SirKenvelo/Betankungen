# Wiki Source (v1)
**Stand:** 2026-03-27

This folder contains the versioned source pages for the public-readiness wiki
bootstrap (`BL-012` / `TSK-0005`).

## Purpose

- GitHub Wiki: curated entry layer for external readers.
- Repository docs (`docs/`): technical source of truth.

## v1 Pages

- `Home.md`
- `Getting-Started.md`
- `CLI-Quick-Reference.md`
- `Architecture-Short-Guide.md`
- `FAQ-Troubleshooting.md`
- `Troubleshooting-Playbooks.md`
- `Cookie-Note.md`

## Maintenance Flow

1. Edit wiki source pages in this folder.
2. Run `make wiki-link-check`.
3. Publish/sync the same content to the GitHub Wiki pages.
4. Keep deep technical details in `docs/` and link to them from wiki pages.

## Governance

- Keep wiki pages short and navigational.
- Avoid duplicating deep contracts or full historical details.
- Every page should link to concrete source-of-truth documents in `docs/`.
