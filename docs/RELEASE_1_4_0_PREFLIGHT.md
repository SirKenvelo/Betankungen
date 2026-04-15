# Release-Readiness-Preflight fuer 1.4.0
**Stand:** 2026-04-15
**Status:** abgeschlossen (Gate 5 / Finalisierung abgeschlossen)

## Zweck

Dieses Dokument definiert den formalen lokalen Readiness-Rahmen fuer die
`1.4.0`-Linie, dokumentiert den finalen Gate-4-Abschlusslauf und haelt den
ausgefuehrten Gate-5-Closeout fest.

Der Fokus liegt auf drei Punkten:

1. Scope-Freeze der aktiven `1.4.0-dev`-Linie
2. Governance-Fit ohne Sicherheits-Workarounds
3. reproduzierbarer lokaler Nachweis ueber Verify + Dry-Runs vor dem finalen
   Versionswechsel

## Scope-Freeze

Die `1.4.0`-Release-Linie umfasst nur die bereits in die aktive Linie
integrierte Arbeit plus den formalen Freeze-/Readiness-Rahmen.

Explizit ausserhalb der 1.4.0-Release-Linie bleiben:

- `BL-0032` als spaeterer Receipt-Storage-/Managed-Archive-Hybridpfad
- `BL-0034` als spaeterer TUI-Form-/Input-Block
- neue Produkt-, CLI-, TUI-, Receipt- oder EV-Features

## Governance-Fit

- Sicherheitsfeatures werden nicht deaktiviert oder umgangen.
- Smoke-/Fixture-Strategien duerfen insbesondere keine lokale
  Commit-Signatur-Policy per `commit.gpgsign false` abschalten.
- Wenn ein aktives Sicherheitsfeature einen Task blockiert, ist das ein
  sichtbarer Blocker und kein Anlass fuer einen stillen Test-Bypass.

## Sichere Fixture-Strategie

- `tests/smoke/smoke_cli.sh` prueft `btkgit` ueber einen Clone-only-Pfad:
  lokales Bare-Remote aus dem aktuellen Repo-Snapshot, echte `main`-Ref und
  frischer Arbeitsclone fuer Sync-/Cleanup-Faelle.
- Der Fixture-Pfad braucht damit keinen lokalen Git-Config-Override fuer
  Signaturen.
- Sollte kuenftig doch ein Commit im Fixture-Pfad noetig werden und ein
  aktives Sicherheitsfeature blockieren, gilt das als sichtbarer Blocker und
  nicht als Test-Workaround.

## Operativer Entrypoint

- Skript: `scripts/release_preflight_1_4_0.sh`
- Make-Target: `make release-preflight-1-4-0`
- Wrapper-CLI: `./btkgit preflight 1.4.0`

## Was der Preflight prueft

1. `APP_VERSION=1.4.0-dev`
2. kein verbliebener Signatur-Bypass in `tests/smoke/smoke_cli.sh`
3. konsistenter Gate-/Freeze-Stand in:
   - `docs/ROADMAP_1_4_0.md`
   - `docs/STATUS.md`
   - `docs/RELEASE_1_4_0_PREFLIGHT.md`
4. lokales Pflichtgate `make verify`
5. `kpr.sh` Dry-Run
6. `scripts/backup_snapshot.sh` Dry-Run

## Lokaler Abschlusslauf fuer Gate 4

Ausgefuehrter Abschlusslauf am 2026-04-15:

1. `make wiki-link-check`
2. `make verify`
3. `make release-preflight-1-4-0`

## Gate-5-Closeout

Der finale Release-Block wurde als eigener Abschlusslauf nach gruener
Gate-4-Readiness ausgefuehrt.

- Finaler Versionswechsel auf `APP_VERSION=1.4.0`.
- Finaler Gate-4-/Gate-5-Snapshot in Roadmap/Status/Changelog/Sprints.
- Release-/Backup-Ausfuehrung mit finaler Version statt Dry-Run.
- Bewusster Post-Release-Hold auf `1.4.0` ohne automatische `1.5.0-dev`-
  Fortschreibung.
- Release-Artefakt: `.releases/Betankungen_1_4_0.tar`
  (SHA-256 `79dcf14b23ea51fb723662eb2ec496919c27fe8ca8f2598ce4363b265b6d898e`).
- Snapshot: `.backup/2026-04-15_1822`.
- GitHub-Release-Handoff fuer den bestehenden Tag `1.4.0` ist publiziert.

## Bewertungslogik dieses Preflights

- Ein gruener Preflight bedeutet: Die Linie ist lokal als Gate-4-Kandidat
  bewertbar und Gate 4 kann auf Dokumentenebene abgeschlossen werden.
- Ein gruener Preflight bedeutete nicht: `1.4.0` ist bereits final
  freigegeben.
- Der Preflight ersetzt weder die explizite Release-Freigabe noch den
  finalen Versionswechsel.

## Gate-4-Closeout-Snapshot (Stand 2026-04-15)

- Gate 4 ist formal abgeschlossen.
- Der finale RC-Abschlusslauf ist lokal vollstaendig gruen dokumentiert:
  `make wiki-link-check`, `make verify`, `make release-preflight-1-4-0`.
- `scripts/release_preflight_1_4_0.sh` bleibt der historische
  Dev-Stand-Guardrail und erwartet bis zum finalen Umschaltpunkt weiter
  `APP_VERSION=1.4.0-dev`.
- Scope-Freeze bleibt unverletzt; `BL-0032` und `BL-0034` bleiben weiterhin
  ausserhalb der `1.4.0`-Release-Linie.
- Gate 5 wurde anschliessend als explizit getrennter Abschlussblock fuer
  Versionswechsel, Release-/Backup-Ausfuehrung und den bewussten Hold auf
  `1.4.0` ausgefuehrt.

## Finalstand

- `APP_VERSION=1.4.0` ist gesetzt.
- Gate 4 und Gate 5 sind abgeschlossen.
- `scripts/release_preflight_1_4_0.sh` bleibt als historischer
  Gate-4-Guardrail fuer den dev-basierten Abschlusslauf erhalten; der
  Post-Release-Stand selbst bleibt bewusst auf `1.4.0`.
- Der sichtbare Public-Handoff auf GitHub Releases ist fuer `1.4.0`
  publiziert.

## Bewusste Nicht-Ziele dieses Dokuments

- keine finale Release-Freigabe
- kein neuer Versions-Tag
- kein Einschmuggeln explorativer Folgearbeit
- kein Aufweichen von Sicherheits- oder Governance-Regeln
