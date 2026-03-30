# ADR-0011: Tracker-Endzustand und Legacy-Read-Policy
**Stand:** 2026-03-30
**Status:** accepted
**Datum:** 2026-03-29

## Kontext

Sprint 25 hat die Tracker-Struktur fuer neue Arbeit faktisch festgezogen, aber
die dauerhafte Repo-Entscheidung dazu war nur verteilt ueber `POL-001`,
Indizes und Statusdoku sichtbar.

Das Repository nutzt absichtlich kanonische und historische Pfade parallel:

- neue `BL`/`TSK` unter `docs/backlog/`
- neue `ISS` unter `docs/issues/`
- neue `POL` unter `docs/policies/`
- aktive `ADR` weiter unter `docs/ADR/`
- lesbarer Legacy-Bestand unter `docs/BACKLOG/` und `docs/tasks/`

Ohne explizite ADR droht dieser Zustand spaeter wieder als halbfertige
Migration missverstanden zu werden.

## Entscheidung

Betankungen behandelt den aktuellen Tracker-Zuschnitt als bewussten
**Endzustand fuer neue Arbeit mit Read-Kompatibilitaet fuer Legacy-Bestand**.

Verbindlich gilt:

- neue `BL`/`TSK` werden nur unter `docs/backlog/` angelegt
- neue `ISS` werden nur unter `docs/issues/` angelegt
- neue `POL` werden nur unter `docs/policies/` angelegt
- `docs/ADR/` bleibt bis zu einer separaten spaeteren Entscheidung der aktive
  ADR-Pfad
- `docs/BACKLOG/` und `docs/tasks/` bleiben lesbar und referenzierbar, sind
  aber keine Zielpfade fuer neue Arbeit

## Leitplanken

- Keine Big-Bang-Rename- oder Migrationsaktion als Nebenprodukt anderer
  Sprints.
- Legacy-Dateien duerfen fuer historische Nachvollziehbarkeit bestehen
  bleiben.
- Backfills duerfen fehlende kanonische Referenzen fuer bereits
  abgeschlossene Arbeit nachziehen, ohne den historischen Sprint-Scope neu zu
  definieren.
- Eine moegliche spaetere ADR-Pfadmigration nach `docs/adr/` ist ein eigener
  Folgeschritt und wird nicht implizit vorweggenommen.

## Nicht-Ziele

- keine globale Umbenennung bestehender `BL-0xx`-/`TSK`-Bestandsdateien
- keine Rueckmigration aller Legacy-Eintraege in neue Verzeichnisse
- keine stille Zusammenlegung von aktiver und historischer Ablage

## Konsequenzen

- Neue Contributor erhalten eine klare Erzeugungsregel fuer heutige Arbeit.
- Historische Links bleiben gueltig, auch wenn der Lesepfad doppelt wirkt.
- Die Komplexitaet des parallelen Read-Bestands wird bewusst akzeptiert, bis
  ein separater Migrationsentscheid getroffen wird.

## Referenzen

- `docs/policies/POL-001-tracker-standard.md`
- `docs/BACKLOG.md`
- `docs/ADR/README.md`
- `docs/STATUS.md`
- `docs/backlog/BL-0025-tracker-end-state-legacy-boundaries/item.md`
