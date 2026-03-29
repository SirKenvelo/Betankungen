# Backlog Tracker
**Stand:** 2026-03-29

Dieser Ordner ist der kanonische Arbeitsbereich fuer neue Backlog-Items
(`BL-xxxx`) und neue Tasks (`TSK-xxxx`) gemaess
`docs/policies/POL-001-tracker-standard.md`.

`docs/BACKLOG.md` bleibt der uebergreifende Navigationsindex; historische
BL-0xx unter `docs/BACKLOG/` bleiben lesbar und referenzierbar.

## Verbindlicher Einsatz heute

- Neue `BL-xxxx` und neue `TSK-xxxx` werden nur in `docs/backlog/` angelegt.
- `docs/tasks/` enthaelt nur bestehende Legacy-Tasks und ist kein Zielpfad
  fuer neue Arbeit.
- Architektur-/Produktentscheidungen gehoeren nicht in diesen Ordner, sondern
  aktuell nach `docs/ADR/`.

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
- Bereits vorhandene Alt-Tasks unter `docs/tasks/` bleiben gueltig, werden
  aber nicht fortgesetzt.
