# BL-011 - Projekt-Scaffolder (Repo Bootstrap)
**Stand:** 2026-03-11
**Status:** geplant
**Typ:** Tooling-/Meta-Projekt (separates Repository)

## Motivation

Neues Projekt-Setup kostet wiederholt Zeit und ist fehleranfaellig:

- Ordnerstruktur wird nicht immer konsistent angelegt
- Basis-Skripte fehlen oder unterscheiden sich je Projekt
- `AGENTS.md`/Doku-Grundlagen werden unvollstaendig kopiert

Ein kleiner Scaffolder soll diesen Start standardisieren.

## Positionierung

Nicht als Bestandteil von `Betankungen`, sondern als eigenes Projekt.

Ziel: generischer Bootstrap fuer neue Repositories.

## Scope v0.1

Interaktiver Start mit minimalen Eingaben:

- Pflicht: Projektname
- Optional: Sprache/Basisprofil (`de` oder `en`)

Erzeugt mindestens:

- Ordner: `src/`, `docs/`, `tests/`, `scripts/`, `.artifacts/`
- Dateien: `README.md`, `docs/CHANGELOG.md`, `docs/STATUS.md`, `AGENTS.md`, `.gitignore`
- Basis-Skripte fuer Repo-Pflege/Test-Einstieg (Template-basiert)

Optionaler Schalter:

- `--git-init` (Repo initialisieren, erster Commit)

## Nicht-Ziele v0.1

- Kein vollautomatischer CI/CD-Stack
- Kein Framework-spezifisches Dependency-Bootstraping
- Keine umfangreiche Projektkonfiguration jenseits des Grundgeruests

## Akzeptanzkriterien

- Ein einzelner Aufruf erzeugt reproduzierbar dasselbe Grundgeruest.
- Template-Platzhalter (Projektname, Datum, Basisregeln) werden korrekt eingesetzt.
- Ergebnis ist direkt commitbar und ohne manuelle Nacharbeit startklar.

## Offene Fragen

- Name des neuen Projekts (Arbeitstitel: `repo-bootstrapper`).
- CLI-Technik (Shell, Go, Python, Pascal).
- Template-Strategie (statisch vs. profile-basiert).
