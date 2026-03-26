# Release Preflight 1.3.0
**Stand:** 2026-03-26
**Status:** aktiv (Gate 5 / Finalisierung vorbereitet)

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
- Finaler RC-Abschlusslauf ist erfolgreich dokumentiert
  (`make release-preflight-1-3-0` inklusive `make verify`).

## Gate-Status-Snapshot (Stand 2026-03-26)

- Gate 1: abgeschlossen am 2026-03-24.
- Gate 2: abgeschlossen am 2026-03-24.
- Gate 3: abgeschlossen am 2026-03-24.
- Gate 4: abgeschlossen am 2026-03-26.
- Gate 5: aktiv.
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

## Lokaler RC-Nachweis

### Lokal (2026-03-24)
- Befehl: `make release-preflight-1-3-0`
- Ergebnis: erfolgreich (inkl. `make verify`, Doku-Gates sowie
  Release-/Backup-Dry-Runs).

### Lokal (2026-03-26, Gate-4-Abschlusslauf)
- Befehl: `make release-preflight-1-3-0`
- Ergebnis: erfolgreich (inkl. `make verify`, Doku-Gates sowie
  Release-/Backup-Dry-Runs).

### CI-Referenz auf `main`
- Workflow: `CI`
- Run-ID: `23515516312`
- Commit: `027e963`
- Ergebnis: `success`

## RC-Checklisten-/Freeze-Snapshot (Stand 2026-03-24)

- Gate-Konsistenz ist dokumentiert: Gate 1/2/3 abgeschlossen, Gate 4 aktiv,
  Gate 5 offen.
- Versionierungs-Guardrail unveraendert: `APP_VERSION=1.3.0-dev` bis Gate 5.
- Doku-Sync-Gates konsistent:
  - `docs/ROADMAP_1_3_0.md`
  - `docs/STATUS.md`
  - `docs/SPRINTS.md`
  - `docs/CHANGELOG.md`
  - `docs/README.md`
- Governance-Mindeststand fuer `main` bleibt:
  PR-only, gruener Required-Check `verify`, up-to-date-Branch-Pflicht.
- Release-blockierender Scope bleibt unveraendert abgeschlossen:
  - `BL-0017` + `TSK-0018`/`TSK-0019`
  - `BL-0018` + `TSK-0020`/`TSK-0021`

## Gate-4-Closeout-/Handover-Snapshot (Stand 2026-03-26)

- Gate 4 ist formal abgeschlossen.
- Der finale RC-Abschlusslauf ist lokal vollstaendig gruen dokumentiert
  (`make release-preflight-1-3-0` inklusive `make verify` und Dry-Runs).
- CI-Referenz auf `main` ist auf dem aktuellen dokumentierten Stand
  (`CI` Run `23515516312`, Commit `027e963`, `success`).
- Roadmap-/Status-/Entry-Doku ist auf Gate-4-Closeout und Gate-5-Handover
  synchronisiert.
- Gate 5 ist aktiv; `APP_VERSION` bleibt bis zur finalen Freigabe auf
  `1.3.0-dev`.

## Gate-5-Kickoff-Snapshot (Stand 2026-03-26)

### Scope-Snapshot
- Release-blockierender Scope bleibt unveraendert:
  - `BL-0017` + `TSK-0018`/`TSK-0019` (`done`)
  - `BL-0018` + `TSK-0020`/`TSK-0021` (`done`)
- Kein neuer `1.3.0`-Scope ist zusaetzlich freigegeben.

### Versions-Snapshot
- Aktueller technischer Stand: `APP_VERSION=1.3.0-dev`.
- Der finale Umschalt-Commit auf `APP_VERSION=1.3.0` bleibt ein eigener
  Gate-5-Release-Schritt nach expliziter Freigabe.

### Audit-Snapshot
- Release-Audit bleibt der Zielpfad fuer die `1.3.0`-Finalisierung.
- Aktuell kein dokumentierter Zwang zu einem Vollaudit.
- Bei neuem Risikotrigger vor Gate-5-Abschluss muss die Audit-Entscheidung
  vor dem finalen Release aktualisiert werden.

### Finale Exit-Checks (Gate 5)
- Check 1: finalen Release-Umschalt-Block vorbereiten
  (`APP_VERSION`-Umschaltpunkt + Doku-Update-Liste).
- Check 2: finalen lokalen Abschlusslauf auf dem Release-Stand dokumentieren
  (`make verify`, `make release-preflight-1-3-0`).
- Check 3: finalen Doku-Sync auf `1.3.0` durchziehen
  (Roadmap/Status/Entry/Preflight/Sprints/Changelog).
- Check 4: finale Release-/Backup-Ausfuehrung nach Freigabe dokumentieren
  (`kpr.sh`, `backup_snapshot.sh`).
- Check 5: Gate-5-Closeout nachvollziehbar abschliessen.

## Audit-Entscheid fuer Gate 4

- Aktueller Zielpfad: Release-Audit fuer die `1.3.0`-Linie.
- Aktuell kein dokumentierter Zwang zu einem Vollaudit.
- Wenn bis Gate-5-Freigabe ein neuer Risikotrigger sichtbar wird
  (z. B. Scope-Erweiterung, Datenpfadbruch, unerwartete Persistenz-/Restore-
  Abweichung), muss die Entscheidung vor dem finalen Release aktualisiert
  werden.

## Gate-5-Handover (naechste Schritte)

- Gate-5-Kickoff-Snapshot (Scope/Version/Audit/Exit-Checks) ist gesetzt.
- Finalen Release-Umschalt-Block vorbereiten (`APP_VERSION` -> `1.3.0`).
- Finalen Doku-Sync sowie Release-/Backup-Ausfuehrung nach Freigabe
  durchziehen.
