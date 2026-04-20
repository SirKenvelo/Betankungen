# POL-001: Tracker Standard (Maintainer Schema)
**Stand:** 2026-04-20
**Status:** active
**Datum:** 2026-04-20

## Ziel

Dieses Dokument definiert ein einheitliches Tracker-System fuer:

- Entscheidungen (ADR)
- Backlog-Planung (BL)
- konkrete Probleme (ISS)
- umsetzbare Arbeitsschritte (TSK)
- formale Regeln/Vertraege (POL)

Die Regeln sind so ausgelegt, dass sie manuell lesbar und gleichzeitig
tool-freundlich (z. B. `projtrack`) sind.

## Geltungsbereich

Verbindlich fuer:

- Tracker-Dateien in `docs/`
- Referenzen zwischen Tracker-Dateien
- ID-Referenzen in Code-Kommentaren
- Validierungsregeln fuer kuenftige Tracker-Tools

Nicht Bestandteil dieser Policy sind PR-Bodies, Merge-Commit-Messages,
Tag-Messages oder Prompt-/Template-Quellen ausserhalb der Tracker-Domaene.

## Tracker-Domain-Abgrenzung

- Die uebergreifende Artefaktmatrix liegt in
  `docs/policies/POL-004-artifact-domain-matrix.md`.
- Diese Policy regelt nur Tracker-Artefakte und deren technische Pruefpfade.
- `# Notes` bleibt fuer Tracker-Dateien die kanonische Notes-Form, wenn ein
  Notes-Abschnitt fachlich noetig ist.
- `## Note` und `## Notes` bleiben in Tracker-Dateien unzulaessig.
- PR-Bodies folgen nicht dieser Tracker-Regel, sondern der separaten
  PR-Allowlist aus `POL-004`, `AGENTS.md` und `docs/GIT_WORKFLOW.md`.

## Source of Truth

- Repo-Dateien sind die fachliche Source of Truth.
- GitHub-Issues koennen als Eingangskanal oder Diskussionsebene genutzt werden.
- Falls GitHub-Issues genutzt werden, referenzieren sie die Repo-ID (`ISS-xxxx`).

## Artefaktarten und Verzeichnisse

### Verbindlicher Arbeitszustand im Repository

- `docs/backlog/` fuer neue Backlog-Items (`BL-xxxx`) und neue Tasks
  (`TSK-xxxx`)
- `docs/issues/` fuer neue Issues (`ISS-xxxx`)
- `docs/policies/` fuer Policies/Standards (`POL-xxx`)
- `docs/ADR/` fuer ADRs (`ADR-xxxx`), bis ein separater ADR-
  Migrationsschritt explizit beschlossen wird
- `docs/BACKLOG.md` als uebergreifender Navigationsindex fuer kanonischen und
  Legacy-Backlog-Bestand

### Legacy- und Sonderfaelle

- `docs/BACKLOG/` bleibt als lesbarer Legacy-Bestand gueltig und
  referenzierbar.
- `docs/tasks/` bleibt nur fuer bereits vorhandene Alt-Tasks gueltig; neue
  Tasks werden dort nicht mehr angelegt.
- `docs/adr/` ist aktuell kein aktiver Zielpfad in diesem Repository. Eine
  Umstellung dorthin waere ein separater Folgeschritt und wird nicht implizit
  parallel gestartet.
- Es gibt keine harte Massenumbenennung in einem Schritt.

## ID-Regeln

Nur folgende Prefixe sind zulaessig:

- `ADR` (Architecture Decision Record)
- `BL` (Backlog Item)
- `ISS` (Issue/Bug/Incident)
- `TSK` (Task)
- `POL` (Policy/Contract/Standard)

### Gueltige Formate

- `ADR`: `^ADR-[0-9]{4}$`
- `BL`: `^BL-([0-9]{4}|[0-9]{3})$` (`3`-stellig = Legacy)
- `ISS`: `^ISS-([0-9]{4}|[0-9]{3})$` (`3`-stellig = Legacy)
- `TSK`: `^TSK-([0-9]{4}|[0-9]{3})$` (`3`-stellig = Legacy)
- `POL`: `^POL-[0-9]{3}$`

### Erzeugungsregel fuer neue Eintraege

- Neue `ADR`, `BL`, `ISS`, `TSK` werden nur noch `4`-stellig erzeugt.
- `POL` bleibt `3`-stellig.
- Legacy-IDs bleiben les- und referenzierbar.

## Pflicht-Metadaten (Frontmatter)

Jede Hauptdatei (`item.md`, `issue.md`, `TSK-*.md`, `ADR-*.md`, `POL-*.md`)
enthaelt Frontmatter mit mindestens:

- `id`
- `title`
- `status`
- `priority`
- `type`
- `tags`
- `created`
- `updated`

Optionale Felder:

- `parent` (z. B. Task -> Backlog)
- `related` (Liste referenzierter IDs)
- `owner`, `due`, `links`

Datumsformat: `YYYY-MM-DD`.

## Templates

Kanonische Vorlagen liegen unter:

- `docs/policies/templates/issue.template.md`
- `docs/policies/templates/backlog-item.template.md`
- `docs/policies/templates/task.template.md`

Die Vorlagen sind Startpunkte und muessen pro Eintrag vollstaendig angepasst
werden (ID, Titel, Datum, Status, Prioritaet, Referenzen).

## Statuswerte

### Issues

- `open`
- `investigating`
- `blocked`
- `resolved`
- `closed`
- `wontfix`
- `duplicate`

### Backlog

- `idea`
- `proposed`
- `approved`
- `in_progress`
- `blocked`
- `done`
- `dropped`

Legacy-Mapping Backlog:

- `icebox -> idea`
- `geplant -> proposed`
- `next -> approved`

### Tasks

- `todo`
- `doing`
- `blocked`
- `done`
- `cancelled`

### ADR

- `proposed`
- `accepted`
- `superseded`
- `deprecated`
- `rejected`

## Prioritaet

Zulaessige Werte:

- `P0` (kritisch)
- `P1` (hoch)
- `P2` (normal)
- `P3` (niedrig)
- `P4` (spaeter)

## Typregeln

`type` ist genau ein Wert (kein Array).

Erlaubte Werte je Artefaktart:

- Issues: `bug`, `incident`, `problem`
- Backlog: `feature`, `improvement`, `refactor`, `debt`, `research`
- Tasks: `task`
- ADR: `decision`
- Policies: `policy`

## Tag-Regeln

- `tags` ist eine Liste.
- Tags sind optional, aber empfohlen.
- `untagged` ist kein echter Tag, sondern ein Tool-Befund.
- Kategorien (Empfehlung): Bereich, Charakter/Risiko, Arbeitszustand.
- Empfohlene Priorisierungs-Lanes fuer Backlog-Items:
  - `lane:release-blocking`
  - `lane:planned`
  - `lane:exploratory`

## Task-Struktur

- Tasks sind global eindeutig ueber `TSK-xxxx`.
- Neue Tasks liegen unter dem zugehoerigen Backlog-Ordner in
  `docs/backlog/BL-0010-.../tasks/TSK-0001-...md`.
- Bestehende Alt-Tasks unter `docs/tasks/` bleiben lesbar und lintbar, werden
  aber nicht als Zielpfad fuer neue Arbeit verwendet.

## Code-Kommentar-Referenzen

Kanonische Formen:

- `TODO(BL-xxxx): ...`
- `FIXME(ISS-xxxx): ...`
- `NOTE(ADR-xxxx): ...`
- `REF(POL-xxx): ...`

Zusaetzlich erlaubt:

- `TODO(ISS-xxxx): ...` fuer konkrete Issue-Follow-ups.

Nicht kanonisch (vermeiden):

- `// ISSUE: ISS-xxxx` als separate Markerzeile ohne Kommentar-Typ.

## Validierungsregeln fuer `projtrack`

Muss pruefen:

- fehlende Pflicht-Metadaten (`missing-meta`)
- ungueltige IDs/Formate
- doppelte IDs (`duplicate-ids`)
- ungueltige `status`/`priority`/`type`
- verwaiste Tasks (`parent` fehlt oder falscher Typ)
- defekte Referenzen in `related`
- defekte Code-Referenzen (`TODO/FIXME/NOTE/REF` auf nicht vorhandene IDs)

Sollte melden:

- ungetaggte Eintraege
- unbekannte Tags (Warnung, kein Hard Error)

Referenzimplementierung (v1):

- `scripts/projtrack_lint.sh`

## Migrationsplan (ohne harte Umbenennung)

1. Policy-Baseline
- Dieses Dokument ist die verbindliche Referenz.

2. Read-Kompatibilitaet in Tools
- Parser lesen Alt- und Neuformat (IDs, Verzeichnisse, Status-Mapping).

3. Neuanlage nach Standard
- Neue `BL`/`TSK` unter `docs/backlog/`, neue `ISS` unter `docs/issues`, neue
  `POL` unter `docs/policies/`.
- Neue `ADR` verbleiben bis auf Weiteres unter `docs/ADR/`.

4. Schrittweise Bereinigung
- Legacy-Dateien werden nur bei inhaltlicher Bearbeitung sanft ueberfuehrt.
- `docs/tasks/` bekommt keine neuen Eintraege mehr.
- Eine moegliche ADR-Pfadumstellung auf `docs/adr/` ist ein separater
  spaeterer Entscheid.
- Keine globale Rename-Aktion als Big-Bang.
