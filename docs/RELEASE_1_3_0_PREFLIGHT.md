# Release Preflight 1.3.0
**Stand:** 2026-03-24
**Status:** aktiv (Gate 4 / RC-Haertung laeuft)

## Ziel

Frueher, reproduzierbarer Vorab-Check fuer die `1.3.0`-Linie. Dieses Dokument
definiert den Soll-Preflight fuer Gate 4/5 und die zugehoerigen Doku-Gates.

## Preflight-Checkpunkte (Soll)

1. Branch-/Version-Guardrails
- Arbeitsstand liegt auf PR-Branch (nicht direkt auf `main`).
- `APP_VERSION` entspricht dem erwarteten Zyklusstand
  (`1.3.0-dev` bis zum Umschalt-Commit, danach `1.3.0`).

2. Verify-Block
- `make verify` laeuft gruen.

3. Tracker-/Scope-Gates
- Scope-Freeze bleibt konsistent:
  - `BL-0017` + `TSK-0018`, `TSK-0019`
  - `BL-0018` + `TSK-0020`, `TSK-0021`
- Keine ungeplanten `1.3.0`-Blocks ohne dokumentierte Freigabe.

4. Contract-/Policy-Gates
- Keine stillen Breaking-Changes (`POL-002`).
- Privacy-/Retention-Leitplanken eingehalten (`POL-003`).
- Polling-/Historienpfad bleibt getrennt von produktiven Core-Datenbanken.

5. Release-/Backup-Dry-Runs
- Release-Skript und Backup-Skript lassen sich im Dry-Run-Pfad pruefen, ohne
  finale Artefakte vor Gate 5 zu erzeugen.

6. Audit-Gate
- Release-Audit-Entscheid ist dokumentiert.
- Mindestziel fuer Gate 4: Release-Audit gemaess triggerbasierter
  Audit-Strategie.
- Vollaudit nur bei explizitem Risikotrigger.

## Skriptbasis

- Operativer Preflight-Entrypoint:
  - `scripts/release_preflight_1_3_0.sh`
- Make-Entrypoint:
  - `make release-preflight-1-3-0`

## Doku-Sync-Gates (Pflicht)

- `docs/ROADMAP_1_3_0.md`
- `docs/STATUS.md`
- `docs/SPRINTS.md`
- `docs/CHANGELOG.md`
- `docs/README.md`

Alle muessen denselben Gate-Stand fuer `1.3.0` widerspruchsfrei zeigen.

## Aktueller Preflight-Stand

- Blueprint ist definiert.
- Operative Skriptbasis ist eingefuehrt (`scripts/release_preflight_1_3_0.sh`).
- RC-Kickoff-Nachweis ist lokal reproduzierbar ueber
  `make release-preflight-1-3-0`.
- Lokaler RC-Kickoff-Lauf ist erfolgreich dokumentiert.

## Gate-Status-Snapshot (Stand 2026-03-24)

- Gate 1: abgeschlossen am 2026-03-24.
- Gate 2: abgeschlossen am 2026-03-24.
- Gate 3: abgeschlossen am 2026-03-24.
- Gate 4: aktiv.
- Gate 5: offen.
- Scope-Freeze bleibt unverletzt (`BL-0017` + `BL-0018` als einziger
  release-blockierender `1.3.0`-Fokus).

## RC-Kickoff-Snapshot fuer Gate 4

### In-Scope (release-blockierend)
- `BL-0017` + `TSK-0018`, `TSK-0019` (done)
- `BL-0018` + `TSK-0020`, `TSK-0021` (done)

### Nicht als 1.3.0-Release-Blocker eingeplant
- `BL-0016` (Community-Standards-Baseline)
- `BL-0011` (Projekt-Scaffolder / Repo-Bootstrap)
- `BL-0019` (Geodaten / Plus-Codes)
- `BL-0024` (Cookie-Wiki-Notiz)

### Out-of-Scope bleibt unveraendert
- Runtime-Config-Profile im Core (`ADR-0009` = rejected)
- Vermischung externer Preis-Historie mit produktiven Tankdatenbanken
- Architekturwechsel weg vom CLI-Kern

## Lokaler RC-Kickoff-Nachweis

### Lokal (2026-03-24)
- Befehl: `make release-preflight-1-3-0`
- Ergebnis: erfolgreich (inkl. `make verify`, Doku-Gates sowie
  Release-/Backup-Dry-Runs).

## Audit-Entscheid fuer Gate 4

- Aktueller Zielpfad: Release-Audit fuer die `1.3.0`-Linie.
- Aktuell kein dokumentierter Zwang zu einem Vollaudit.
- Wenn bis Gate-5-Freigabe ein neuer Risikotrigger sichtbar wird
  (z. B. Scope-Erweiterung, Datenpfadbruch, unerwartete Persistenz-/Restore-
  Abweichung), muss die Entscheidung vor dem finalen Release aktualisiert
  werden.

## Offene Gate-4-Schritte

- CI-Referenz auf `main` fuer den aktuellen RC-Stand dokumentieren.
- RC-Abschlusslauf auf den finalen Gate-4-Stand verdichten.
- Roadmap-/Status-/Entry-Doku auf Gate-4-Closeout und Gate-5-Handover
  umstellen.
