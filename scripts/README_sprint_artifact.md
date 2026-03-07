# Sprint Artifact Script
**Stand:** 2026-03-07

Dieses Dokument beschreibt die Nutzung von `scripts/sprint_artifact.sh`.

## Zweck

Das Skript erzeugt lokale Sprint-Artefakte fuer einen bestehenden Commit:
- `.diff` mit vollem Patch (`git show --stat --patch`)
- `.md` mit kompakter Zusammenfassung (Hash, Message, Dateiuebersicht)

Standardziel ist `.artifacts/`.

## Aufruf

```bash
scripts/sprint_artifact.sh <sprint_nr> <commit_nr> <commit_total> [--commit HASH] [--outdir DIR] [--force]
```

## Parameter

- `<sprint_nr>`: Sprint-Nummer, z. B. `4`
- `<commit_nr>`: Commit-Nummer innerhalb des Sprints, z. B. `2`
- `<commit_total>`: Gesamtzahl der Commit-Bloecke im Sprint, z. B. `3`

## Optionen

- `--commit HASH`: Commit-Hash/Ref (Default: `HEAD`)
- `--outdir DIR`: Zielordner (Default: `.artifacts`)
- `--force`: Vorhandene Artefakte ueberschreiben
- `-h`, `--help`: Hilfe anzeigen

## Beispiele

Artefakte fuer aktuellen `HEAD` erzeugen:

```bash
scripts/sprint_artifact.sh 4 2 3
```

Artefakte fuer expliziten Commit erzeugen:

```bash
scripts/sprint_artifact.sh 4 2 3 --commit c1a6348
```

In anderem Zielordner erzeugen:

```bash
scripts/sprint_artifact.sh 4 2 3 --outdir /tmp/artifacts
```

Bestehende Dateien ersetzen:

```bash
scripts/sprint_artifact.sh 4 2 3 --force
```

## Ausgabe

Bei Sprint `4`, Commit `2/3` entstehen standardmaessig:

- `.artifacts/sprint_4_commit_2_von_3.diff`
- `.artifacts/sprint_4_commit_2_von_3.md`

## Hinweise / Guardrails

- Das Skript erzeugt nur **lokale** Artefakte.
- `.artifacts/` ist in `.gitignore` enthalten.
- Ohne `--force` wird nie still ueberschrieben.
- Der Commit muss im lokalen Git-Repo existieren.

## Typischer Workflow

1. Sprint-Commit erstellen und pushen.
2. Commit-Hash notieren (z. B. `git rev-parse --short=7 HEAD`).
3. Artefakte erzeugen:

```bash
scripts/sprint_artifact.sh <sprint_nr> <commit_nr> <commit_total> --commit <hash>
```

4. Hash in `docs/CHANGELOG.md` und `docs/SPRINTS.md` nachziehen (falls noch offen).
