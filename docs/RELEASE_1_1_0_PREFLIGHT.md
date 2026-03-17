# Release Preflight 1.1.0
**Stand:** 2026-03-17
**Status:** aktiv (Gate 4 gestartet, nach abgeschlossenem Gate 3)

## Ziel

Frueher, reproduzierbarer Vorab-Check fuer die 1.1.0-Linie. Dieses Dokument
definiert den Soll-Preflight fuer Gate 4/5 und die zugehoerigen Doku-Gates.

## Preflight-Checkpunkte (Soll)

1. Branch-/Version-Guardrails
- Arbeitsstand liegt auf PR-Branch (nicht direkt auf `main`).
- `APP_VERSION` entspricht dem erwarteten Zyklusstand (`1.1.0-dev` bis Gate 5).

2. Verify-Block
- `make verify` laeuft gruen.

3. Tracker-/Scope-Gates
- Scope-Freeze bleibt konsistent:
  - Feature-Block `BL-0014` + `TSK-0006`
  - Hardening-Block `BL-0015` + `TSK-0007`
- Keine ungeplanten 1.1.0-Blocks ohne dokumentierte Freigabe.

4. Contract-/Policy-Gates
- Contract-Hardening-Matrix ist aktuell:
  `docs/CONTRACT_HARDENING_1_1_0.md`.
- Keine stillen Breaking-Changes (`POL-002`).
- Privacy-/Retention-Leitplanken eingehalten (`POL-003`).

5. Release-/Backup-Dry-Runs
- Release-Skript und Backup-Skript lassen sich im Dry-Run-Pfad pruefen, ohne
  finale Artefakte vor Gate 5 zu erzeugen.

## Skriptbasis

- Operativer Preflight-Entrypoint:
  - `scripts/release_preflight_1_1_0.sh`
- Make-Entrypoint:
  - `make release-preflight-1-1-0`

## Doku-Sync-Gates (Pflicht)

- `docs/ROADMAP_1_1_0.md`
- `docs/STATUS.md`
- `docs/SPRINTS.md`
- `docs/CHANGELOG.md`
- `docs/README.md`

Alle muessen denselben Gate-Stand fuer 1.1.0 widerspruchsfrei zeigen.

## Aktueller Preflight-Stand

- Blueprint ist definiert.
- Paket-Contract-Block aus Gate 3 ist konkretisiert (`docs/EXPORT_PACKAGE_CONTRACT.md`,
  Fixture-Runner `tests/regression/run_package_manifest_fixture_check.sh`).
- Operative Skriptbasis ist nachweisbar ausgefuehrt (`make release-preflight-1-1-0`).

## Gate-Status-Snapshot (S17C4, Stand 2026-03-17)

- Gate 1: abgeschlossen am 2026-03-16.
- Gate 2: abgeschlossen am 2026-03-16.
- Gate 3: abgeschlossen am 2026-03-17 (Exit-Kriterien voll erfuellt).
- Gate 4: aktiv (Start dokumentiert in `S17C4/4`).
- Gate 5: pending.
- Scope-Freeze bleibt unverletzt (`BL-0014` + `BL-0015` als einziger
  release-blockierender 1.1.0-Fokus).

## RC-Handover-Stand fuer Gate 4 (S17C4)

### Lokal
- Befehl: `make release-preflight-1-1-0`
- Ergebnis: erfolgreich (inkl. `make verify`, Doku-Gates sowie
  Release-/Backup-Dry-Runs).

### CI-Referenz auf `main`
- Workflow: `CI` (`verify`)
- Run-ID: `23208794011`
- Commit: `e67860f` (`S17c3 gate3 closeout handover (#23)`)
- Ergebnis: `success`
- URL: `https://github.com/SirKenvelo/Betankungen/actions/runs/23208794011`

## Naechster Schritt (Gate 4)

- RC-Abschlusslauf fuer Gate 4 mit lokalem Voll-Preflight und aktualisierter
  CI-Referenz auf `main` dokumentieren.
- Danach Gate-4-Exit-Kriterium in Roadmap/Status explizit auf `abgeschlossen`
  setzen.
