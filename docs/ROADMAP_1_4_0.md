# Verbindlicher Fahrplan bis Version 1.4.0
**Stand:** 2026-04-15
**Status:** abgeschlossen (`APP_VERSION=1.4.0`; Gate 4 und Gate 5 abgeschlossen; stabiler Hold aktiv)

## Ausgangslage

- `1.3.0` wurde am 2026-03-26 final freigegeben.
- Der Dev-Start fuer `1.4.0-dev` wurde nach separatem Vorstart-Gate in
  Sprint 30 isoliert aktiviert; das formale Vorgate bleibt in
  `docs/DEV_START_GATE_1_4_0.md` nachvollziehbar.
- `BL-0011` ist fuer `Betankungen` repo-seitig geschlossen und bleibt
  ausserhalb des Implementierungsscope dieser Linie:
  `docs/BL-0011_SCOPE_DECISION_1_4_0.md`.
- Der sichtbare Entry-/Onboarding-Folgeblock `BL-0036` ist abgeschlossen;
  damit kann die Linie formal auf Release-Readiness und Scope-Freeze
  konsolidiert werden.
- Explorative Folgearbeit bleibt bewusst getrennt:
  `BL-0032` (Receipt-Storage-Hybridpfad) und `BL-0034` (TUI-Form-System)
  werden nicht mehr in die `1.4.0`-Release-Linie gezogen.

## Verbindliche Leitplanken

- Keine neuen Produkt-, CLI-, TUI-, Receipt- oder EV-Features in diesem
  Freeze-/Readiness-Block.
- Sicherheitsfeatures werden weder deaktiviert noch umgangen; das gilt
  explizit auch fuer Commit-/Tag-Signaturen, Review-/Policy-Gates und
  vergleichbare Schutzmechanismen.
- `main` bleibt geschuetzter PR-Branch mit gruener `verify`-Pflicht.
- `Squash and merge` und Rebase-Merge bleiben fuer diese Linie nicht der
  Standardpfad.
- Nach dem finalen Gate-5-Umschalt-Commit bleibt `APP_VERSION=1.4.0`
  bewusst als stabiler Pflege-/Audit-Stand aktiv; eine automatische
  Fortschreibung auf `1.5.0-dev` erfolgt nicht.

## Scope fuer 1.4.0

### In Scope

1. Bereits gelieferte `1.4.x`-Arbeit stabilisieren und in einen formal
   release-bewertbaren Rahmen ziehen:
   `BL-0016`, `BL-0019`, `BL-0029`, `BL-0031`, `BL-0033`, `BL-0035`,
   `BL-0036` sowie die dazugehoerige Doku-/Governance-Synchronisierung.
2. Governance-/Release-Hardening fuer die aktuelle Linie:
   Scope-Freeze, Readiness-Preflight, konsistente Status-/Entry-Doku und
   saubere Test-/Fixture-Strategie ohne Signatur-Bypaesse.
3. Nachvollziehbare Freigabevorbereitung:
   `make verify`, `make wiki-link-check`, `make release-preflight-1-4-0`,
   Release-/Backup-Dry-Runs und dokumentierte Restkriterien.

### Nicht Teil von 1.4.0

- `BL-0032` bleibt als spaeterer Hybrid-/Komfortpfad ausserhalb der
  1.4.0-Release-Linie.
- `BL-0034` bleibt als spaeterer Formular-/Input-Block ausserhalb der
  1.4.0-Release-Linie.
- Neue Runtime- oder Produktfeatures ueber die bereits gemergte 1.4.x-Arbeit
  hinaus.
- Start einer neuen Release-Linie oder finaler Versionswechsel ohne
  explizite Freigabe.
- Testgruene durch Deaktivieren oder Umgehen aktiver Sicherheitsfeatures.

## Gate-Plan bis 1.4.0

### Gate 1: Zyklusstart `1.4.0-dev`

- Separaten Aktivierungs-Commit nach dokumentiertem Vorstart-Gate ausfuehren.
- Aktive Status-/Entry-Doku auf `1.4.0-dev` setzen.

Exit-Kriterium:
- `1.4.0-dev` ist aktiv, ohne mit inhaltlicher Folgearbeit vermischt zu
  sein.

Status:
- abgeschlossen am 2026-03-30.

### Gate 2: Scope-Freeze und Governance-Konsolidierung

- Den verbleibenden In-Repo-Scope der Linie explizit festziehen.
- `BL-0011` als externes Thema bestaetigen und im Freeze-Rahmen verankern.
- Explorative Folgearbeit (`BL-0032`, `BL-0034`) sichtbar ausserhalb der
  1.4.0-Release-Linie halten.
- Governance-Widerspruch in der Test-/Fixture-Strategie aufloesen:
  Smoke-Fixtures pruefen `btkgit` ueber lokales Bare-Remote plus frischen
  Clone statt ueber lokale Commit-Signatur-Deaktivierung.

Exit-Kriterium:
- Kein offener Scope-Drift in Richtung Explorations-/Folgearbeit und kein
  dokumentierter Widerspruch zu Sicherheitsfeatures.

Status:
- abgeschlossen am 2026-04-14.

### Gate 3: Release-Readiness-Rahmen

- Einen eigenen `1.4.0`-Roadmap-/Preflight-Pfad verankern.
- Doku, Entry-Layer und Status auf denselben Freeze-/Readiness-Stand ziehen.
- Die Security-Hygiene und verbleibenden Gate-4/5-Kriterien als explizite
  Readiness-Evidenz sichtbar machen.
- Lokalen Abschlusslauf fuer den Readiness-Rahmen dokumentieren.

Exit-Kriterium:
- `make verify` und `make release-preflight-1-4-0` laufen gruen.
- Scope-Freeze, Governance-Fit und Preflight-Rahmen sind repo-seitig
  bewertbar.

Status:
- abgeschlossen am 2026-04-14.

### Gate 4: Release-Candidate-Freeze

- Keine neue Linienausweitung mehr; nur verbleibende release-relevante
  Nachweise oder klar dokumentierte Blocker.
- Finalen RC-Snapshot mit aktuellem Verify-/Preflight-Stand dokumentieren.
- Release-Entscheid explizit vom Scope-Freeze und vom Dev-Start trennen.

Exit-Kriterium:
- RC-Kandidat ist fachlich eingefroren, reproduzierbar und ohne offene
  Governance-Widersprueche.

Status:
- abgeschlossen am 2026-04-15.

### Gate 5: Finalisierung 1.4.0

- `APP_VERSION` von `1.4.0-dev` auf `1.4.0` setzen.
- Finalen Doku-Sync sowie Release-/Backup-Ausfuehrung dokumentieren.
- Finalen Release nur nach expliziter Freigabe durchfuehren.
- Nach dem Release bewusst auf `1.4.0` bleiben; kein automatischer Sprung auf
  `1.5.0-dev`.

Exit-Kriterium:
- `1.4.0` ist final freigegeben und nachvollziehbar dokumentiert.

Status:
- abgeschlossen am 2026-04-15.

## Finalstand am 2026-04-15

- Dev-Start und fruehe Linienarbeit sind historisch geliefert.
- Scope-Freeze fuer `1.4.0` ist jetzt formal gesetzt.
- Explorative Folgearbeit (`BL-0032`, `BL-0034`) bleibt bewusst ausserhalb der
  aktiven Release-Linie.
- Ein eigener lokaler Readiness-Preflight existiert:
  `scripts/release_preflight_1_4_0.sh` / `make release-preflight-1-4-0`.
- Gate 4 ist jetzt als finaler RC-/Freeze-Snapshot dokumentiert:
  `make wiki-link-check`, `make verify` und `make release-preflight-1-4-0`
  liefen lokal gruen; Release-/Backup-Werkzeuge sind ueber Dry-Runs
  nachvollziehbar abgesichert.
- Gate 5 ist jetzt ausgefuehrt:
  finaler Versionswechsel auf `1.4.0`, finaler Doku-Sync und bewusster
  Post-Release-Hold ohne `1.5.0-dev`.
- Release-Artefakt und Direkt-Backup sind lokal ausgefuehrt:
  `.releases/Betankungen_1_4_0.tar`
  (SHA-256 `79dcf14b23ea51fb723662eb2ec496919c27fe8ca8f2598ce4363b265b6d898e`)
  und `.backup/2026-04-15_1822`.

## Formale Evidenz fuer Gate 2 bis Gate 5

- `tests/smoke/smoke_cli.sh` prueft `btkgit` ueber einen Clone-only-
  Fixture-Pfad mit lokalem Bare-Remote und echter `main`-Ref; ein lokaler
  Signing-Bypass gehoert nicht mehr zur Strategie.
- `scripts/release_preflight_1_4_0.sh` blockiert ein Rueckfallen auf
  `commit.gpgsign false` und bleibt als historischer Dev-Stand-Guardrail fuer
  den Gate-4-Abschlusslauf erhalten.
- Der finale Gate-4-Abschlusslauf ist lokal auf dem dev-Stand dokumentiert:
  `make wiki-link-check`, `make verify`, `make release-preflight-1-4-0`.
- `README.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`,
  `docs/DEV_START_GATE_1_4_0.md` und
  `docs/BL-0011_SCOPE_DECISION_1_4_0.md` fuehren denselben Freeze-/
  Readiness-Stand.
- Gate 4 und Gate 5 sind abgeschlossen; `1.4.0` bleibt der dokumentierte
  stabile Stand fuer Pflege und Audits.

## Verbindliche Abweichungsregel

Abweichungen von diesem Fahrplan sind nur gueltig, wenn sie im gleichen Change
explizit dokumentiert werden in:

- `docs/ROADMAP_1_4_0.md`
- `docs/STATUS.md`
- `docs/CHANGELOG.md` (unter `[Unreleased] -> Changed`)
