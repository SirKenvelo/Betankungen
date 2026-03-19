# Verbindlicher Fahrplan bis Version 1.2.0
**Stand:** 2026-03-18
**Status:** aktiv (`APP_VERSION=1.2.0-dev`)

## Ausgangslage

- `1.1.0` wurde am 2026-03-18 final freigegeben.
- Die naechste Entwicklungsbasis laeuft auf `1.2.0-dev`.
- Dieser Fahrplan bleibt gate-basiert (Qualitaetskriterien vor Kalenderdatum).

## Verbindliche Leitplanken

- CLI-first bleibt unveraendert (kein GUI-/Web-API-Shift).
- Kein Overengineering: zuerst korrekt, dann schnell, dann schoen.
- Keine Runtime-Config-Profile im Core (`ADR-0009` bleibt `rejected`).
- Contract-Evolution strikt nach `POL-002` (additiv bevorzugt, Breaking nur explizit).
- Backup-/Restore-/Privacy-Regeln strikt nach `POL-003`.
- `main` bleibt geschuetzter PR-Branch mit gruenem `verify` als Mindestgate.

## Scope fuer 1.2.0

### Muss (release-blockierend)

1. Multi-DB-Backup-Operations liefern (`BL-0020`):
- selektive Sicherung einzelner DBs und Sammelsicherung mehrerer DBs;
- reproduzierbare Metadaten/Index je Lauf inkl. Integritaetsnachweis;
- klare Fehlerpfade und Dry-Run-Strategie fuer sichere Operationen.

2. Receipt-Photo-Link-References liefern (`BL-0021`):
- externe Belegreferenzen als optionales Link-Feld (kein Binary-Blob in SQLite);
- append-only-kompatibler Schreibpfad fuer neue Fuelups;
- output-/privacy-konforme Sichtbarkeit fuer Linkfelder (inkl. JSON-Contract).

3. Contract-/Policy-Haertung fuer 1.2.0:
- keine stillen Breaking-Changes in CLI/JSON/CSV;
- Domain-/Smoke-/Regression-Nachweise fuer neue Guardrails;
- Doku-Sync fuer Roadmap/Status/Entry/Changelog/Sprints.

### Soll (nicht release-blockierend)

- Vorbereitende Schnittstellen-/Entscheidungsskizzen fuer den Folgescope `1.3.0`
  (`BL-0017` API-Evaluation, `BL-0018` Polling-Historie), ohne produktive
  Runtime-Integration in `1.2.0`.

### Nicht Teil von 1.2.0

- Produktive API-Integration fuer externe Tankstellenpreisquellen.
- Polling-/Historienpipeline fuer externe Preisdaten.
- Community-Standards-Paket (`BL-0016`) als Release-Blocker.
- Projekt-Scaffolder-Umsetzung (`BL-0011`) als Release-Blocker.

## Gate-Plan bis 1.2.0

### Gate 1: Zyklusstart

- Entwicklungsbasis auf `1.2.0-dev` setzen.
- Verbindlichen 1.2.0-Fahrplan dokumentieren.
- Entry-Doku auf den aktiven 1.2-Zyklus synchronisieren.

Exit-Kriterium:
- Der 1.2.0-Zyklus ist mit klaren Leitplanken gestartet.

Status:
- abgeschlossen am 2026-03-18.

### Gate 2: Scope-Freeze 1.2.0

- Priorisierte Bloecke sind final festgelegt:
  - Feature-/Ops-Block `BL-0020` + `TSK-0008`, `TSK-0009`
  - Feature-Block `BL-0021` + `TSK-0010`, `TSK-0011`
- Out-of-Scope-Liste ist explizit dokumentiert.
- Reihenfolge der Folgeversionen ist verbindlich festgelegt:
  - `1.3.0`: Option B (`BL-0017` + `BL-0018`)
  - `1.4.0`: Option C (`BL-0016` + `BL-0011`)

Exit-Kriterium:
- Kein fachlicher Scope-Drift fuer den laufenden 1.2.0-Zyklus.

Status:
- abgeschlossen am 2026-03-18.

### Gate 3: Umsetzung + Contract-Haertung

- Verify-/Contract-DoD fuer die 1.2.0-Linie konkretisieren.
- Verify-/Contract-Matrix ist festgezogen:
  `docs/CONTRACT_HARDENING_1_2_0.md`.
- Preflight-Blueprint fuer Gate 4/5 ist als Soll-Rahmen definiert:
  `docs/RELEASE_1_2_0_PREFLIGHT.md`.
- Umsetzungsblock fuer `BL-0020`/`BL-0021` auf Basis der Tasks liefern.
- Nachweise in Domain-/Smoke-/Regression und Doku synchronisieren.

Exit-Kriterium:
- Zyklusumfang fachlich fertig und regressionssicher.

Status:
- aktiv (DoD konkretisiert am 2026-03-18).
- Fortschritt:
  - erster regressionssicherer Lieferstand ist umgesetzt (`S20C4/4`):
    `BL-0020` (Multi-DB-Backup-Operations) steht auf `done`.
  - zweiter release-blocking Lieferstand ist umgesetzt:
    `BL-0021` (Receipt-Photo-Link-References) steht auf `done`.

### Gate 4: Release-Candidate-Haertung

- Feature-Freeze aktiv.
- Vollstaendiger Verify-/Preflight-Lauf ohne offene Blocker.
- RC-Nachweis lokal + per CI-Referenz auf `main` dokumentiert.

Exit-Kriterium:
- RC-Kandidat ist releasefaehig und reproduzierbar.

Status:
- ausstehend.

### Gate 5: Finalisierung 1.2.0

- `APP_VERSION` von `1.2.0-dev` auf `1.2.0`.
- Finaler Doku-Sync und Release-/Backup-Ausfuehrung.
- Abschluss als nachvollziehbares Gate-5-Closeout dokumentieren.

Exit-Kriterium:
- 1.2.0 ist final freigegeben und nachvollziehbar dokumentiert.

Status:
- ausstehend.

## Verbindliche Abweichungsregel

Abweichungen von diesem Fahrplan sind nur gueltig, wenn sie im gleichen Change
explizit dokumentiert werden in:

- `docs/ROADMAP_1_2_0.md`
- `docs/STATUS.md`
- `docs/CHANGELOG.md` (unter `[Unreleased] -> Changed`)
