# Verbindlicher Fahrplan bis Version 1.3.0
**Stand:** 2026-03-24
**Status:** aktiv (`APP_VERSION=1.3.0-dev`)

## Ausgangslage

- `1.2.0` wurde am 2026-03-24 final freigegeben.
- Der Entscheidungsentwurf v0.1 vom 2026-03-18 legt die verbindliche
  Reihenfolge der Folgeversionen fest:
  - `1.3.0`: Option B (`BL-0017` + `BL-0018`)
  - `1.4.0`: Option C (`BL-0016` + `BL-0011`)
- Die Entwicklungsbasis wurde nach dem 1.2.0-Release auf `1.3.0-dev`
  angehoben.

## Verbindliche Leitplanken

- CLI-first bleibt unveraendert (kein GUI-/Web-API-Shift).
- Kein Overengineering: zuerst korrekt, dann robust, dann bequem.
- Keine Runtime-Config-Profile im Core (`ADR-0009` bleibt `rejected`).
- Externe Preisquellen duerfen erst nach expliziter API-/Lizenzbewertung aus
  `BL-0017` verbindlich eingebunden werden.
- Polling-/Historien-Daten aus `BL-0018` bleiben konzeptionell getrennt von
  produktiven Core-Datenbanken, bis Speicher- und Trennregeln dokumentiert
  sind.
- Contract-Evolution strikt nach `POL-002` (additiv bevorzugt, Breaking nur
  explizit).
- Backup-/Restore-/Privacy-Regeln strikt nach `POL-003`.
- Externe Audits folgen der triggerbasierten Audit-Strategie unter
  `/home/christof/Projekte/Audit/Betankungen/strategy/`; kein pauschales
  Vollaudit pro Change, sondern Delta-/Risiko-Audits nach Aenderungsart.
- `main` bleibt geschuetzter PR-Branch mit gruenem `verify` als Mindestgate.

## Scope fuer 1.3.0

### Muss (release-blockierend)

1. API-Evaluation fuer externe Tankstellenpreise liefern (`BL-0017`):
- tragfaehige kostenlose API-Quelle identifizieren;
- Lizenz-/Rate-Limit-/Betriebsgrenzen fuer Raspberry-Pi-/Home-Setup klaeren;
- v1-Empfehlung mit dokumentierter Fallback-Option festhalten.

2. Polling-/Historienbasis fuer externe Preisdaten liefern (`BL-0018`):
- zyklische Erfassung von Tankstellenpreisen in klar getrenntem Datenpfad;
- Rohdaten-/Historienablage mit nachvollziehbarem Speicherformat;
- technische Grundlage fuer spaetere historische Auswertungen schaffen.

3. Integrations- und Contract-Haertung fuer die 1.3.0-Linie:
- keine stillen Breaking-Changes in CLI/JSON/CSV;
- klare Trennung zwischen Core-Daten und externer Preis-Historie;
- Doku-Sync fuer Roadmap/Status/Entry/Changelog/Sprints.

### Soll (nicht release-blockierend)

- Vorbereitende Leitplanken fuer die Folgeversion `1.4.0` sichtbar halten,
  ohne `BL-0016` oder `BL-0011` in den 1.3.0-Release-Kern zu ziehen.

### Nicht Teil von 1.3.0

- Community-Standards-Baseline (`BL-0016`) als Release-Blocker.
- Projekt-Scaffolder/Repo-Bootstrap (`BL-0011`) als Release-Blocker.
- Direkte Vermischung externer Preis-Historie mit produktiven Tankdatenbanken
  ohne dokumentiertes Trennkonzept.

## Gate-Plan bis 1.3.0

### Gate 1: Zyklusstart

- Entwicklungsbasis auf `1.3.0-dev` setzen.
- Verbindlichen 1.3.0-Fahrplan dokumentieren.
- Entry-Doku auf den aktiven 1.3-Zyklus synchronisieren.

Exit-Kriterium:
- Der 1.3.0-Zyklus ist mit klaren Leitplanken gestartet.

Status:
- abgeschlossen am 2026-03-24.

### Gate 2: Scope-Freeze 1.3.0

- Release-Kern gemaess Entscheidungsentwurf operativ festziehen:
  `BL-0017` + `BL-0018`.
- Folgeversion `1.4.0` explizit auf `BL-0016` + `BL-0011` festhalten.
- Out-of-Scope-Liste und Integrationsgrenzen transparent dokumentieren.

Exit-Kriterium:
- Kein fachlicher Scope-Drift fuer den laufenden 1.3.0-Zyklus.

Status:
- abgeschlossen am 2026-03-24.

### Gate 3: Umsetzung + Contract-Haertung

- API-Entscheidung und Polling-/Historienbasis fachlich liefern.
- Verify-/Regression-Nachweise fuer die neuen Guardrails verankern.
- Doku- und Contract-Grenzen auf Abschlussstand synchronisieren.

Exit-Kriterium:
- Zyklusumfang fachlich fertig und regressionssicher.

Status:
- abgeschlossen am 2026-03-24.
- Abschlussstand:
  - `BL-0017` ist abgeschlossen; die Evaluationsmatrix, Betriebsgrenzen,
    Primaerquelle, Fallback-Strategie und Audit-Leitplanken liegen in
    `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md` vor.
  - `BL-0018` ist abgeschlossen: separater Polling-Runner,
    Raw-/DB-/State-Persistenz und Regressionsevidenz liegen in
    `scripts/fuel_price_polling_run.sh`,
    `docs/FUEL_PRICE_POLLING_RUNTIME_1_3_0.md` und
    `tests/regression/run_fuel_price_history_check.sh` vor.
  - Vollstaendiger Abschlusslauf `make verify` ist auf diesem Stand gruen.

### Gate 4: Release-Candidate-Haertung

- Feature-Freeze aktiv.
- Vollstaendiger Verify-/Preflight-Lauf ohne offene Blocker.
- RC-Nachweis lokal und per CI-Referenz dokumentiert.
- Release-Audit gemaess triggerbasierter Audit-Strategie ist entschieden und
  dokumentiert (mindestens Release-Audit; Vollaudit nur bei Risikotriggern).
- Preflight-Blueprint fuer Gate 4/5 ist als Soll-Rahmen definiert:
  `docs/RELEASE_1_3_0_PREFLIGHT.md`.

Exit-Kriterium:
- RC-Kandidat ist releasefaehig und reproduzierbar.

Status:
- aktiv.
- Fortschritt:
  - Gate-4-Preflight-Blueprint und Doku-Gates sind in
    `docs/RELEASE_1_3_0_PREFLIGHT.md` verankert.
  - Operativer Readiness-Preflight ist eingefuehrt:
    `scripts/release_preflight_1_3_0.sh` und
    `make release-preflight-1-3-0`.
  - Lokaler RC-Kickoff-Lauf `make release-preflight-1-3-0` ist gruen
    dokumentiert.
  - RC-Checklisten-/Freeze-Snapshot fuer Gate 4 ist in
    `docs/RELEASE_1_3_0_PREFLIGHT.md` dokumentiert, inkl. CI-Referenz auf
    `main` (Run `23514165068`, Commit `ce5a574`).

### Gate 5: Finalisierung 1.3.0

- `APP_VERSION` von `1.3.0-dev` auf `1.3.0`.
- Finaler Doku-Sync und Release-/Backup-Ausfuehrung.
- Abschluss als nachvollziehbares Gate-5-Closeout dokumentieren.
- Audit-Evidenz fuer den finalen Release-Entscheid ist referenziert, falls fuer
  die 1.3.0-Linie ein Release-/Vollaudit gefahren wurde.

Exit-Kriterium:
- 1.3.0 ist final freigegeben und nachvollziehbar dokumentiert.

Status:
- offen.

## Verbindliche Abweichungsregel

Abweichungen von diesem Fahrplan sind nur gueltig, wenn sie im gleichen Change
explizit dokumentiert werden in:

- `docs/ROADMAP_1_3_0.md`
- `docs/STATUS.md`
- `docs/CHANGELOG.md` (unter `[Unreleased] -> Changed`)
