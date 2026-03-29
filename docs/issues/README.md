# Issues Tracker
**Stand:** 2026-03-29

Dieser Ordner enthaelt konkrete Problemfaelle (`ISS-xxxx`) gemaess
`docs/policies/POL-001-tracker-standard.md`.

## Struktur

- Pro Issue ein eigener Ordner:
  - `docs/issues/ISS-0001-kurzer-slug/`
- Hauptdatei pro Issue:
  - `issue.md`

## Pflichtpunkte

- Frontmatter gemaess `POL-001` (u. a. `id`, `status`, `priority`, `type`,
  `tags`, `created`, `updated`).
- `id` mit Prefix `ISS` (neu 4-stellig, Legacy 3-stellig lesbar).
- `type` ist genau ein Wert (`bug`, `incident`, `problem`).

## Verweise

- Beziehungen zu Backlog/Tasks/Policies immer ueber IDs in `related`.
- Neue Folge-Tasks werden unter dem zugehoerigen Backlog-Ordner in
  `docs/backlog/BL-xxxx-.../tasks/` angelegt.
- `docs/tasks/` enthaelt nur historische Ausnahmefaelle und ist kein
  Zielpfad fuer neue Arbeit.
- Code-Kommentare bevorzugt als `FIXME(ISS-xxxx): ...` oder
  `TODO(ISS-xxxx): ...`.
