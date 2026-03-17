# Release Preflight 1.1.0
**Stand:** 2026-03-17
**Status:** vorbereitet (Gate 3)

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
- Operative Ausfuehrung als RC-Nachweis folgt in Gate 4.
