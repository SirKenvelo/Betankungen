# ADR-0010: Repo-lokales Workflow-Wrapper-CLI nach 1.3.0
**Stand:** 2026-03-24
**Status:** proposed
**Datum:** 2026-03-24

## Kontext

Der laufende Git-/PR-/Preflight-Workflow fuer Betankungen ist inzwischen klar
strukturiert und reproduzierbar, aber weiterhin stark manuell:

- Session-Sync (`fetch` / `pull --ff-only`)
- versionsspezifische Preflight-Laeufe
- PR-Vorbereitung und Branch-Aufraeumen
- lokale Readiness-Checks vor Merge oder Release

Die vorhandenen Basisbausteine sind bereits belastbar:

- `make verify`
- versionsspezifische Preflight-Skripte
- `gh`-CLI fuer PR-Arbeit
- dokumentierter Branch-/PR-/Merge-Workflow

Der Vorschlag ist, diese wiederkehrenden Schritte spaeter in einem kleinen
repo-lokalen Wrapper-CLI zu kapseln, statt sich auf Editor-Extensions oder
generische externe Werkzeuge zu stuetzen.

Wichtig dabei:

- Die `1.3.0`-Linie soll nicht durch zusaetzliches Tooling-Scoping belastet
  werden.
- Der Einstieg soll klein, nachvollziehbar und lokal scriptbar bleiben.

## Entscheidung

Nach der Finalisierung von `1.3.0` wird ein **kleines repo-lokales
Workflow-Wrapper-CLI** als nachgelagerter Arbeitsblock vorbereitet.

Arbeitstitel:

- `btkgit`

Der Wrapper soll zunaechst nur vorhandene, kanonische Projektbefehle kapseln,
nicht ersetzen.

## Leitplanken

- Start erst **nach** dem Abschluss von `1.3.0`.
- Zunaechst als einfaches Script im Repository, kein separates Produkt.
- Bestehende Befehle bleiben Source of Truth
  (`make verify`, `make release-preflight-*`, `git`, `gh`).
- Keine Blackbox-Automation fuer kritische Git-Schritte.
- Kein Scope-Drift in Richtung generisches GitHub-Tooling in der ersten
  Ausbaustufe.

## Geplanter Startumfang

Moegliche MVP-Kommandos:

- `btkgit sync`
  - `fetch` + `pull --ff-only`
- `btkgit preflight <version>`
  - ruft den passenden versionsspezifischen Preflight auf
- `btkgit ready`
  - menschenlesbarer Wrapper fuer Readiness-/Merge-Checks
- `btkgit cleanup`
  - nach Merge: `checkout main`, `pull --ff-only`, lokalen Branch loeschen
- optional spaeter:
  - `btkgit pr create`

## Nicht-Ziele fuer die erste Ausbaustufe

- Kein automatisches, blindes `git add .`
- Kein implizites Committen ohne explizite Message
- Kein generisches Multi-Repo-GitHub-Produkt
- Keine starke Verlagerung von Logik aus den bestehenden Preflight-/Make-
  Targets in das Wrapper-CLI

## Konsequenzen

- `1.3.0` bleibt frei von zusaetzlichem Workflow-Tooling-Scope.
- Der Vorschlag ist als bewusste Anschlussarbeit sichtbar dokumentiert.
- Nach `1.3.0` kann die Umsetzung als eigener Backlog-/Task-Block sauber und
  klein gestartet werden.
- Das Wrapper-CLI wird als Assistenzschicht gedacht, nicht als Ersatz fuer die
  dokumentierten Projektprozesse.

## Referenzen

- `docs/GIT_WORKFLOW.md`
- `AGENTS.md`
- `docs/ROADMAP_1_3_0.md`
- `docs/RELEASE_1_3_0_PREFLIGHT.md`
