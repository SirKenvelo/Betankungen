# ADR-0013: `btkgit` Safety- und Betriebsvertrag
**Stand:** 2026-03-30
**Status:** accepted
**Datum:** 2026-03-29

## Kontext

`ADR-0010` hat `btkgit` als kleines repo-lokales Workflow-Wrapper-CLI
eingefuehrt. Sprint 28 hat den realen Sicherheits- und Betriebsrahmen danach
geschaerft: Failure-UX bei `sync`, konservatives `cleanup` und
nicht-destruktive Smoke-Abdeckung.

Was bisher fehlte, war ein expliziter Vertrag fuer die Frage, **wie weit
`btkgit` gehen darf und wo der Wrapper bewusst stoppt**.

## Entscheidung

`btkgit` bleibt ein bewusst kleines Assistenzwerkzeug ueber den bestehenden
Projektbefehlen und folgt diesen verbindlichen Regeln:

- `sync` erklaert Auth-/Remote-/Upstream-Probleme gezielt, veraendert aber
  weder Credentials noch Remotes oder Tracking-Konfiguration automatisch
- `cleanup` bleibt konservativ; lokales Branch-Loeschen ist nur explizit via
  `--delete-local` erlaubt, `main` bleibt unloeschbar und Remote-Loeschungen
  sind nicht Teil des Wrappers
- `preflight` und `ready` bleiben transparente Wrapper ueber bestehende
  Repo-Pruefungen statt eigene Fachlogik einzufuehren
- dokumentierte Safe Paths und Failure-Pfade muessen nicht-destruktiv
  regression-gesichert sein
- `btkgit` ist kein Autopilot fuer Commit, Push, PR, Merge, Rebase oder
  Remote-Reparatur

## Leitplanken

- Keine Blackbox-Automation fuer Auth-, Remote- oder Delete-Schritte.
- Keine destruktiven Defaults im Namen von Komfort.
- Wenn Verhalten und Doku auseinanderlaufen, muessen ADR/Doku und Smoke-Pfade
  gemeinsam nachgezogen werden.
- `git`, `gh`, `make verify` und versionsspezifische Preflights bleiben die
  kanonischen Ausfuehrungsbausteine.

## Nicht-Ziele

- kein generisches Multi-Repo-GitHub-Tooling
- keine automatische Fehlerheilung fuer Netzwerk-, Auth- oder Tracking-Probleme
- keine Erweiterung zum Branch-/PR-/Merge-Autopiloten

## Konsequenzen

- Solo-Maintenance wird reproduzierbarer, ohne versteckte Seiteneffekte zu
  akzeptieren.
- Sicherheits- und Erwartungsrahmen des Wrappers sind auch fuer spaetere
  Doku- oder Testpflege explizit festgehalten.
- Der Wrapper bleibt bewusst kleiner als die darunterliegenden Standardtools.

## Referenzen

- `docs/ADR/ADR-0010-repo-local-workflow-wrapper-cli.md`
- `scripts/btkgit.sh`
- `tests/smoke/smoke_cli.sh`
- `docs/README.md`
- `docs/backlog/BL-0028-btkgit-safety-guardrails/item.md`
