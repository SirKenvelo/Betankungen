# Release-Readiness-Preflight fuer 1.4.0
**Stand:** 2026-04-14
**Status:** aktiv

## Zweck

Dieses Dokument definiert den formalen lokalen Readiness-Rahmen fuer die
`1.4.0`-Linie, ohne eine finale Freigabe vorwegzunehmen.

Der Fokus liegt auf drei Punkten:

1. Scope-Freeze der aktiven `1.4.0-dev`-Linie
2. Governance-Fit ohne Sicherheits-Workarounds
3. reproduzierbarer lokaler Nachweis ueber Verify + Dry-Runs

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

## Lokaler Abschlusslauf

Erwarteter Abschlusslauf fuer diesen Rahmen:

1. `make wiki-link-check`
2. `make verify`
3. `make release-preflight-1-4-0`

## Restkriterien vor finalem Release

Auch bei gruener lokaler Readiness bleibt `1.4.0` erst dann final
freigabefaehig, wenn zusaetzlich gilt:

- kein neuer Scope-Drift nach dem Freeze
- explizite Release-Freigabe fuer den finalen Versionswechsel
- finaler Gate-4-/Gate-5-Snapshot in Roadmap/Status/Changelog/Sprints
- Release-/Backup-Ausfuehrung mit finaler Version statt Dry-Run

## Bewusste Nicht-Ziele dieses Dokuments

- keine finale Release-Freigabe
- kein neuer Versions-Tag
- kein Einschmuggeln explorativer Folgearbeit
- kein Aufweichen von Sicherheits- oder Governance-Regeln
