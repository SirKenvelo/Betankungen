# Release Preflight 1.1.0
**Stand:** 2026-03-18
**Status:** aktiv (Gate 4 abgeschlossen, Gate-5-Finalisierung vorbereitet)

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

## Gate-Status-Snapshot (S17C4, historisch, Stand 2026-03-17)

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

## Gate-4-Arbeitspaket (historisch)

- `S18C2/4`: RC-Checkliste/Feature-Freeze-Snapshot auf aktuellen Gate-Stand
  synchronisieren.
- `S18C3/4`: RC-Abschlusslauf fuer Gate 4 mit lokalem Voll-Preflight und
  aktualisierter CI-Referenz auf `main` dokumentieren.
- `S18C4/4`: Gate-4-Exit-Kriterium in Roadmap/Status auf `abgeschlossen`
  setzen und Handover auf Gate 5 finalisieren.

## Gate-4-Closeout-Nachweis (S18C4, Stand 2026-03-18)

- Gate-4-Exit-Kriterium ist dokumentiert:
  `docs/ROADMAP_1_1_0.md` fuehrt Gate 4 als abgeschlossen.
- Gate-4-Handover auf Gate 5 ist dokumentiert:
  `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md` und
  `docs/CHANGELOG.md` zeigen konsistent den Fokus auf Gate 5.
- RC-Nachweise aus `S18C3/4` bleiben unveraendert gueltig
  (lokaler Voll-Preflight + CI-Referenz auf `main`).

## Naechster Schritt (Gate 5)

- Finalen Release-Umschalt-Commit vorbereiten (`APP_VERSION` von
  `1.1.0-dev` auf `1.1.0`).
- Finalen Doku-Sync fuer die 1.1.0-Freigabe durchziehen
  (`ROADMAP_1_1_0`, `STATUS`, `SPRINTS`, `CHANGELOG`, `README`).
- Nach expliziter Freigabe: Release-/Backup-Ausfuehrung final statt Dry-Run.

## Gate-5-Kickoff-Update (S19C1)

- Gate 5 ist als aktiver Arbeitsblock dokumentiert (`docs/ROADMAP_1_1_0.md`,
  `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md`).
- BL-Triage-Lanes sind als leichte Priorisierung geschuetzt
  (`release-blocking`/`planned`/`exploratory`), ohne den Scope-Freeze fuer
  1.1.0 aufzuweichen.

## Gate-4-Kickoff-Update (S18C1)

- Kickoff in Sprint-Narrative verankert (`docs/SPRINTS.md`).
- Roadmap-/Status-/Entry-Doku zeigen konsistent: Gate 3 abgeschlossen, Gate 4
  aktiv (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/README.md`).
- Nicht-blockierender Folgeeintrag fuer externe Belegfoto-Links als `BL-0021`
  im kanonischen Tracker erfasst (`docs/backlog/BL-0021-receipt-photo-link-references/item.md`).

## RC-Checklisten-Snapshot (S18C2, historisch, Stand 2026-03-18)

- Gate-Konsistenz ist dokumentiert: Gate 1/2/3 abgeschlossen, Gate 4 aktiv,
  Gate 5 pending (`docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`).
- Versionierungs-Guardrail unveraendert: `APP_VERSION=1.1.0-dev`
  bis Gate 5.
- Doku-Sync-Gates konsistent:
  `docs/ROADMAP_1_1_0.md`, `docs/STATUS.md`, `docs/SPRINTS.md`,
  `docs/CHANGELOG.md`, `docs/README.md`.
- Governance-Mindeststand fuer `main` bleibt:
  PR-only, gruener Required-Check `verify`, up-to-date-Branch-Pflicht.

## Feature-Freeze-Snapshot (S18C2)

### In-Scope (release-blockierend)
- `BL-0014` + `TSK-0006` (done)
- `BL-0015` + `TSK-0007` (done)

### Nicht als 1.1.0-Release-Blocker eingeplant
- `BL-0016` (Community-Standards-Follow-up, non-blocking)
- `BL-0021` (externe Tankbeleg-Foto-Links, non-blocking)

### Out-of-Scope bleibt unveraendert
- Runtime-Config-Profile im Core (`ADR-0009` = rejected)
- Vollstaendige Import-Pipeline in 1.1.0
- Architekturwechsel weg vom CLI-Kern

## RC-Abschlusslauf-Nachweis (S18C3)

### Lokal (2026-03-18)
- Befehl: `make release-preflight-1-1-0`
- Ergebnis: erfolgreich (inkl. `make verify`, Doku-Gates,
  Release-/Backup-Dry-Runs).

### CI-Referenz auf `main`
- Workflow: `CI` (`verify`)
- Run-ID: `23241536267`
- Commit: `6b1a0c1` (`S18c2 gate4 checklist freeze sync (#26)`)
- Ergebnis: `success`
- URL: `https://github.com/SirKenvelo/Betankungen/actions/runs/23241536267`
