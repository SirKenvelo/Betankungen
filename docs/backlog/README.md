# Backlog Tracker
**Stand:** 2026-03-18

Dieser Ordner enthaelt das neue Backlog-Tracker-Schema (`BL-xxxx`) gemaess
`docs/policies/POL-001-tracker-standard.md`.

## Struktur

- Pro Backlog-Eintrag ein Ordner:
  - `docs/backlog/BL-0001-kurzer-slug/`
- Hauptdatei:
  - `item.md`
- Abgeleitete Tasks:
  - `tasks/TSK-0001-kurzer-slug.md`

## Pflichtpunkte

- Frontmatter gemaess `POL-001` in `item.md` und allen `TSK`-Dateien.
- `id` fuer Backlog mit Prefix `BL` (neu 4-stellig, Legacy 3-stellig lesbar).
- Task-Dateien nutzen globale IDs (`TSK-xxxx`) und setzen `parent: BL-xxxx`.

## Priorisierungs-Lanes (empfohlen)

Fuer viele parallele BL-Eintraege wird eine leichte Lane-Sortierung empfohlen:

- `release-blocking`: gehoert in den aktiven Release-Scope (Core fuer die
  aktuelle Linie).
- `planned`: sinnvoll und umsetzbar, aber nicht release-blockierend
  (klassisches "nice to have").
- `exploratory`: Forschungsideen mit unsicherem ROI/Scope
  (kontrollierte "crazy ideas").

Empfohlene Abbildung in den `tags` von `item.md`:
- `lane:release-blocking`
- `lane:planned`
- `lane:exploratory`

## Legacy-Hinweis

- Historische Backlog-Dateien unter `docs/BACKLOG/` bleiben waehrend der
  Migration gueltig.
- Neue Eintraege werden im kanonischen Pfad `docs/backlog/` angelegt.
