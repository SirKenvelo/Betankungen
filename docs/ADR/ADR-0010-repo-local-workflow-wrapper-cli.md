# ADR-0010: Repo-lokales Workflow-Wrapper-CLI (`btkgit`)
**Stand:** 2026-03-26
**Status:** accepted
**Datum:** 2026-03-26

## Kontext

Die `1.3.0`-Linie ist abgeschlossen (Gate 5 finalisiert am 2026-03-26). Der
Git-/PR-/Preflight-Ablauf ist stabil dokumentiert, aber in der taeglichen
Nutzung weiterhin stark manuell:

- Session-Sync (`fetch` / `pull --ff-only`)
- versionsspezifische Preflight-Laeufe
- Readiness-/Merge-Pruefungen
- Branch-Aufraeumen nach Merges

Die vorhandenen Bausteine sind belastbar (`make verify`,
`make release-preflight-*`, `git`, `gh`), aber die Bedienung bleibt verteilt
auf viele Einzelbefehle.

## Entscheidung

Betankungen fuehrt ein **kleines repo-lokales Workflow-Wrapper-CLI** mit dem
Arbeitstitel `btkgit` ein.

Das Wrapper-CLI ist eine Assistenzschicht ueber bestehende Standardbefehle und
ersetzt deren fachliche Source of Truth nicht.

## Leitplanken

- Start der Umsetzung erst nach dem offiziellen Abschluss der `1.3.0`-Linie.
- Erste Ausbaustufe als einfaches Repo-Skript, kein separates Produkt.
- Keine Blackbox-Automation fuer kritische Git-Schritte.
- Bestehende Befehle bleiben kanonisch:
  `make verify`, `make release-preflight-*`, `git`, `gh`.
- Kein Scope-Drift in Richtung generisches Multi-Repo-GitHub-Tooling.

## Startumfang (MVP)

- `btkgit sync`
  - `fetch` + `pull --ff-only`
- `btkgit preflight <version>`
  - ruft den passenden versionsspezifischen Preflight auf
- `btkgit ready`
  - menschenlesbarer Wrapper fuer lokale Readiness-Checks
- `btkgit cleanup`
  - nach Merge: `checkout main`, `pull --ff-only`, lokalen Branch loeschen

## Nicht-Ziele (MVP)

- kein blindes `git add .`
- kein implizites Committen ohne explizite Message
- kein Rebase-/History-Rewrite-Automatismus
- keine Verlagerung der eigentlichen Fachlogik aus Make-/Preflight-Skripten

## Konsequenzen

- Wiederkehrende Repo-Pflegeschritte werden reproduzierbarer und schneller.
- Der Einstieg bleibt auditierbar, da bestehende Projektbefehle sichtbar
  aufgerufen werden.
- Der anschliessende 1.4.0-Zyklus kann mit einem klar abgegrenzten
  Tooling-Startblock beginnen.

## Referenzen

- `docs/GIT_WORKFLOW.md`
- `AGENTS.md`
- `docs/ROADMAP_1_3_0.md`
- `docs/RELEASE_1_3_0_PREFLIGHT.md`
