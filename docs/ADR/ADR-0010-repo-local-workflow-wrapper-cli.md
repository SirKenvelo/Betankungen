# ADR-0010: Repo-lokales Workflow-Wrapper-CLI (`btkgit`)
**Stand:** 2026-03-29
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
  - erklaert Auth-/Remote-/Upstream-Probleme mit gezielten Operator-Hinweisen,
    aendert Credentials oder Remote-Konfiguration aber nicht automatisch
- `btkgit preflight <version>`
  - ruft den passenden versionsspezifischen Preflight auf
- `btkgit ready`
  - menschenlesbarer Wrapper fuer lokale Readiness-Checks
- `btkgit cleanup`
  - nach Merge: `checkout main`, `pull --ff-only`, lokalen Branch nur
    explizit via `--delete-local` loeschen

## Nicht-Ziele (MVP)

- kein blindes `git add .`
- kein implizites Committen ohne explizite Message
- kein Rebase-/History-Rewrite-Automatismus
- keine Verlagerung der eigentlichen Fachlogik aus Make-/Preflight-Skripten
- keine automatische Reparatur von Auth-/Remote-/Tracking-Problemen
- kein implizites lokales oder entferntes Branch-Loeschen

## Konsequenzen

- Wiederkehrende Repo-Pflegeschritte werden reproduzierbarer und schneller.
- Der Einstieg bleibt auditierbar, da bestehende Projektbefehle sichtbar
  aufgerufen werden.
- `btkgit` bleibt ein bewusst kleines Repo-Werkzeug fuer Solo-Maintenance und
  kein GitHub-Autopilot fuer Commits, Pushes oder PRs.
- Kritische Git-Fehler bleiben sichtbar; der Wrapper liefert Kontext und
  Hinweise, versteckt die eigentliche Ursache aber nicht hinter stillen
  Fallbacks.
- Der anschliessende 1.4.0-Zyklus kann mit einem klar abgegrenzten
  Tooling-Startblock beginnen.

## Umsetzungsstand (MVP)

Stand 2026-03-29:

- Root-Wrapper `./btkgit` delegiert auf `scripts/btkgit.sh` und bricht mit
  klarer Fehlermeldung ab, wenn der Script-Entrypoint lokal fehlt.
- `btkgit sync` fuehrt `git fetch --prune origin` und `git pull --ff-only`
  aus.
- Fehlerbilder fuer fehlendes `origin`, fehlenden Branch-Upstream sowie
  Auth-/Remote-Probleme liefern jetzt konkrete Operator-Hinweise
  (`gh auth status`, `git remote -v`, `git push -u origin <branch>`), ohne
  automatische Credential- oder Remote-Mutationen.
- `btkgit preflight <version>` delegiert auf versionsspezifische
  `scripts/release_preflight_<version>.sh` (inkl. `default` fuer
  `scripts/release_preflight.sh`).
- `btkgit ready` liefert menschenlesbaren Status und optionalen lokalen
  Vollcheck via `make verify`.
- `btkgit cleanup` fuehrt den Post-Merge-Pfad transparent aus (`checkout main`,
  Sync auf `main`) und loescht lokale Branches nur noch explizit via
  `--delete-local`; `main` bleibt unloeschbar.
- Nicht-destruktive Smoke-Abdeckung prueft jetzt neben `--help` auch
  `ready --skip-verify`, `preflight default -- --help`, einen klaren
  `sync`-Fehlerpfad ohne `origin`, einen Upstream-Hinweis fuer Feature-Branches
  sowie die konservative vs. explizite `cleanup`-Semantik in isolierten
  Temp-Repositories.

## Referenzen

- `docs/GIT_WORKFLOW.md`
- `AGENTS.md`
- `docs/ROADMAP_1_3_0.md`
- `docs/RELEASE_1_3_0_PREFLIGHT.md`
