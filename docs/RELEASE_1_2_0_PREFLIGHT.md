# Release Preflight 1.2.0
**Stand:** 2026-03-19
**Status:** abgeschlossen (Gate 4 Exit in S22C3)

## Ziel

Frueher, reproduzierbarer Vorab-Check fuer die 1.2.0-Linie. Dieses Dokument
definiert den Soll-Preflight fuer Gate 4/5 und die zugehoerigen Doku-Gates.

## Preflight-Checkpunkte (Soll)

1. Branch-/Version-Guardrails
- Arbeitsstand liegt auf PR-Branch (nicht direkt auf `main`).
- `APP_VERSION` entspricht dem erwarteten Zyklusstand
  (`1.2.0-dev` bis zum Umschalt-Commit, danach `1.2.0`).

2. Verify-Block
- `make verify` laeuft gruen.

3. Tracker-/Scope-Gates
- Scope-Freeze bleibt konsistent:
  - Ops-/Feature-Block `BL-0020` + `TSK-0008`, `TSK-0009`
  - Feature-Block `BL-0021` + `TSK-0010`, `TSK-0011`
- Keine ungeplanten 1.2.0-Blocks ohne dokumentierte Freigabe.

4. Contract-/Policy-Gates
- Contract-Hardening-Matrix ist aktuell:
  `docs/CONTRACT_HARDENING_1_2_0.md`.
- Keine stillen Breaking-Changes (`POL-002`).
- Privacy-/Retention-Leitplanken eingehalten (`POL-003`).

5. Release-/Backup-Dry-Runs
- Release-Skript und Backup-Skript lassen sich im Dry-Run-Pfad pruefen, ohne
  finale Artefakte vor Gate 5 zu erzeugen.

## Skriptbasis (Plan)

- Geplanter operativer Preflight-Entrypoint:
  - `scripts/release_preflight_1_2_0.sh`
- Geplanter Make-Entrypoint:
  - `make release-preflight-1-2-0`

Hinweis: Die operative Verdrahtung ist Teil des Gate-3-Umsetzungsblocks
(`S20C4/4`), nicht Bestandteil von `S20C3/4`.

## Doku-Sync-Gates (Pflicht)

- `docs/ROADMAP_1_2_0.md`
- `docs/STATUS.md`
- `docs/SPRINTS.md`
- `docs/CHANGELOG.md`
- `docs/README.md`

Alle muessen denselben Gate-Stand fuer 1.2.0 widerspruchsfrei zeigen.

## Gate-Status-Snapshot (Stand 2026-03-19)

- Gate 1: abgeschlossen am 2026-03-18.
- Gate 2: abgeschlossen am 2026-03-18.
- Gate 3: abgeschlossen am 2026-03-19 (release-blocking Scope geliefert).
- Gate 4: abgeschlossen am 2026-03-19 (RC-Nachweise dokumentiert).
- Gate 5: aktiv (Finalisierung 1.2.0).
- Scope-Freeze bleibt unverletzt (`BL-0020` + `BL-0021` als einziger
  release-blockierender 1.2.0-Fokus).

## Feature-Freeze-Snapshot (Soll fuer Gate 4)

### In-Scope (release-blockierend)
- `BL-0020` + `TSK-0008`, `TSK-0009`
- `BL-0021` + `TSK-0010`, `TSK-0011`

### Nicht als 1.2.0-Release-Blocker eingeplant
- `BL-0016` (Community-Standards)
- `BL-0017` und `BL-0018` (API-Evaluation/Polling-Historie)
- `BL-0019` (Geodaten/Plus-Codes)
- `BL-0011` (Projekt-Scaffolder)

### Out-of-Scope bleibt unveraendert
- Runtime-Config-Profile im Core (`ADR-0009` = rejected)
- Produktive API-Polling-Integration in 1.2.0
- Architekturwechsel weg vom CLI-Kern

## RC-Abschlussnachweis (S22C3, Stand 2026-03-19)

- Scope-Freeze unverletzt:
  - `BL-0020` + `TSK-0008`/`TSK-0009`: done
  - `BL-0021` + `TSK-0010`/`TSK-0011`: done
- Contract-Hardening 1.2.0 steht auf Gate-3-Abschlussstand:
  - `docs/CONTRACT_HARDENING_1_2_0.md` = abgeschlossen
- Doku-Gates fuer Gate 4 sind konsistent:
  - `docs/ROADMAP_1_2_0.md`
  - `docs/STATUS.md`
  - `docs/SPRINTS.md`
  - `docs/CHANGELOG.md`
  - `docs/README.md`
- Lokaler Vollnachweis:
  - `make verify` erfolgreich (inkl. Lint/Build/Contract-/Regression-/Domain-
    Policy-/Smoke-Gates).
- CI-Referenz auf `main`:
  - Workflow: `CI`
  - Run: `23307738745`
  - Status: `success`
  - Commit: `3e9be17`
- Offene RC-Schritte: keine; Uebergang auf Gate 5 ist freigegeben.
