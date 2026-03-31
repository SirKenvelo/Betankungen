# Aktueller Projektstatus – Betankungen
**Stand:** 2026-03-31
**Zielversion:** Aktive Entwicklungsbasis `1.4.0-dev` (technischer Stand `APP_VERSION=1.4.0-dev`; Sprint-29-Startgate per separatem Aktivierungs-Commit eingeloest)

## Fundament & Architektur (erledigt)
- CLI-first-Architektur mit klarem Orchestrator (`Betankungen.lpr`)
- Saubere Modultrennung: DB-Init / Seed / Common / Domain / Stats / Logging / Tabellen
- Design Principles, Constraints und Quiet-Policy definiert und dokumentiert
- Kein Overengineering, keine externen Frameworks
- Dokumentation als First-Class-Artifacts:
  - `ARCHITECTURE.md`
  - `BACKLOG.md` (uebergreifender Tracker-Index)
  - `backlog/` (kanonischer Pfad fuer neue BL/TSK)
  - `issues/` (kanonischer Pfad fuer neue ISS)
  - `policies/` (POL-Standards, inkl. Tracker-Standard)
  - `ADR/README.md` + `ADR/ADR-*.md` (aktueller ADR-Pfad; separate
    Pfadmigration offen)
  - `BACKLOG/` und `tasks/` als lesbarer Legacy-Bestand
  - `CHANGELOG.md`
  - `DESIGN_PRINCIPLES.md`
  - `SPRINTS.md`
- Release-Logging via `scripts/kpr.sh` (kompatibel via Root-Wrapper `kpr.sh`)
- Git-loser Snapshot-Workflow via `scripts/backup_snapshot.sh` (`.backup/YYYY-MM-DD_HHMM` + `.backup/index.json`)
- Restore-Ablauf dokumentiert in `RESTORE.md`
- Legacy-Wissensarchiv in `knowledge_archive/` (read-only; Git-Historie ist
  der primaere Rueckgriff fuer fruehere Implementationsstaende)
- Smoke-Checks unter `tests/smoke/smoke_cli.sh` (kompatibel via `tests/smoke_cli.sh`)

## Datenmodell & Domain-Logik (erledigt)
- SQLite-Schema v5 stabil (`cars`, `fuelups.car_id`, `fuelups.missed_previous`, additives Feld `fuelups.receipt_link`)
- `stations` voll editierbar
- `fuelups` append-only, historisch korrekt
- Fuelups referenzieren `stations` und `cars` (FK)
- `cars` enthaelt Startwerte (`odometer_start_km`, `odometer_start_date`) als Validierungsbasis pro Fahrzeug
- Car-Kontext wird zentral ueber `ResolveCarIdOrFail` aufgeloest (0/1/>1 Cars, unknown/invalid `car_id`)
- Kein implizites Default `car_id=1` mehr; bei mehreren Fahrzeugen ist `--car-id` Pflicht
- `--add/--list fuelups` und `--stats fuelups` sind strikt car-gescoped (`WHERE car_id = :car_id`)
- Fixed-Point-Arithmetik:
  - Geld: Cent
  - Volumen: ml
  - Preis: milli-EUR
- Domain-Regeln strikt umgesetzt:
  - kein Edit/Delete bei `fuelups`
  - defensive Validierung
  - Odometer muss pro Fahrzeug monoton steigen; grosse Luecken triggern Golden-Info-Abfrage

## Domain-Policy-Matrix v1 (abgeschlossen)
- Matrix v1 ist in `tests/domain_policy/` durchgaengig umgesetzt und per Runner regression-gesichert.
- Abgedeckte Bloecke:
  - `P-001..P-002` (Car-ID Hard Errors)
  - `P-010..P-013` (Odometer + Gap Confirm)
  - `P-020..P-022` (Fuel/Plausibility)
  - `P-030..P-032` (Cost/Price)
  - `P-040..P-041` (Date)
  - `P-050..P-051` (Gap-Flag Design Guards)
  - `P-060` inkl. `P-060/02` Car-Isolation (kein Cross-Car-Zyklus)
  - `P-070` Cars-Delete-Guard (kein Loeschen bei vorhandenen fuelup-Referenzen)

## CLI & Usability (weitgehend erledigt)
- Subcommand-Modell (`TCommand`)
- Flags: `--add`, `--list`, `--edit`, `--delete`, `--stats`
- Demo & Seed: `--seed`, `--demo`
- Config-Handling: `--db`, `--db-set`
- Stats-Zeitachsen: `--monthly` und `--yearly` fuer `--stats fuelups` (Text/JSON)
- XDG-konforme INI
- Demo-Datenbank reproduzierbar via `--seed [--force]`
- strikt getrennt von produktiver DB

## Logging & Ausgabe (konzeptionell fertig, funktional)
- Zentrale Logging-Schicht (`u_log`)
- Klare Trennung:
  - Command-Result -> `WriteLn` in Domain-Units erlaubt
  - Debug / Trace / Meta -> ausschließlich über `u_log`
- Flags:
  - `--debug` -> Meta-Infos / Debug-Tabelle
  - `--detail` -> fachliche Detailausgabe
  - `--quiet` -> nur fachliches Ergebnis (inkl. "0 Eintraege", "keine Daten")
- Quiet-Policy klar definiert und dokumentiert
- Stats-Debug: Effektiver Zeitraum wird einmalig nach Kopf-Query geloggt (open-ended/closed, plus no-rows Hinweis)
- CSV-Helper (strict, ohne Escaping) in `u_fmt`

## Stats – Version 0.4.2 (abgeschlossen)
Bereits erledigt:
- `--stats fuelups` implementiert
- Volltank-Zyklen, Strecke, Liter, Ø-Verbrauch
- Kostenstatistik (Summe pro Zyklus + Gesamt)
- Tabellen-Ausgabe inkl. Summenzeile
- JSON-Ausgabe via `--stats fuelups --json`
- CLI-Validierung fuer `--json`

## Roadmap 0.5.0 – Komfort & Auswertung (abgeschlossen)
- Filter & Zeitraeume fuer `--stats fuelups`: `--from`/`--to` (YYYY-MM-DD; optional YYYY-MM).
- Filter wirken auf Kopfwerte (Zeitraum, Counts) und Zyklusbildung (nur Fuelups im Zeitraum).
- Keine Datenmanipulation: nur `SELECT` + Berechnung.
- Periodische Auswertungen: Monats-Summary (km, liters_ml, avg, total_cents).
- Output: Tabelle (Text) und JSON mit `kind: "fuelups_monthly"`.
- Export-Story: JSON bleibt Source of Truth; CSV-Output aktuell fuer Stats (CLI + API). Breiter Export weiterhin offen.
- Umsetzungsschritte: 1) `--from`/`--to` Parser + Validierung im Orchestrator. 2) Stats-Query mit `WHERE fueled_at BETWEEN ...`. 3) Zyklusgrenzen im Zeitraum definieren. 4) Monatsaggregation (intern, dann Output). 5) JSON-Schema erweitern (neue kinds, `period` bleibt).
- Nicht-Ziele 0.5.0: keine Station-Filter, keine Multi-Car-Logik, kein Import/Sync/Editor, kein CLI-Umbau (keine neuen Subcommands).

## 0.5.2 – Dashboard & Unicode-Box-Engine (abgeschlossen)
- `--dashboard`: alternativer Renderer fuer `--stats fuelups`
- Unicode-Box-Engine in `u_fmt`
- Dynamische (relative) Farblogik fuer Kostenbalken
- UTF-8-sichere Breitenberechnung (Mehrbyte-Zeichen stabil)
- Exklusive Flag-Validierung (`--dashboard` vs `--json`/`--csv`)

## Roadmap 0.5.3 – Reifegrad & Vervollstaendigung (abgeschlossen)
- Ziel: Stabilisieren, strukturieren, vorbereiten (kein massiver Feature-Zuwachs).
- Jahres-Summary ist explizit nicht Teil von 0.5.3; Monatsaggregation bleibt die aktuelle Zeitachsenbasis.
- Entscheidung: Jahres-Summary wird auf 0.5.5 verschoben (keine rueckwirkende Zuordnung zu 0.5.3).
- Interne Strukturierung von `u_stats`: Collector -> `TStatsResult`; Renderer sauber getrennt (`RenderText`, `RenderJson`, `RenderCsv`, `RenderDashboard`) ohne Verhaltensaenderung.
- CSV-Export-Policy in der Doku vorbereiten (Entities, Header-Versionierung, Escape-Regeln, Source-of-Truth-Regel fuer JSON), ohne globalen Export umzusetzen.
- Einmaliger CLI-Usage-Konsistenz-Audit (Flags, Help-Texte, Beispiele, JSON-Beispiele, Ordnung).

## 0.5.4 – First-Run UX & Initialisierung (abgeschlossen)
- Erststart ohne Konfigurationswissen: Default-DB-Pfad wird automatisch genutzt (`~/.local/share/Betankungen/betankungen.db`).
- Verzeichnisse werden bei Bedarf automatisch angelegt; DB + Schema werden automatisch provisioniert.
- Frischstart ohne Argumente laeuft still (kein Fehler "Kein Kommando"), sofern Bootstrap fehlt.
- Bei vorhandener Config und fehlender DB wird die DB still am konfigurierten Pfad neu angelegt.
- Interaktiv nur als Fallback bei nicht nutzbarem DB-Pfad; Retry ist moeglich.
- Smoke-Abdeckung erweitert (`tests/smoke/smoke_cli.sh`, `tests/smoke/smoke_clean_home.sh`).

## 0.5.5 – Jahres-Summary (abgeschlossen)
- CLI umgesetzt: `Betankungen --stats fuelups --yearly` und `Betankungen --stats fuelups --json --yearly`.
- Umsetzung im Collector auf Basis der Monatsaggregation (keine neue SQL-Logik).
- JSON-Kind fuer Jahreswerte umgesetzt: `fuelups_yearly`.
- Validierung erweitert: `--yearly` nur mit `--stats fuelups`, exklusiv zu `--monthly`, nicht kombinierbar mit `--csv`/`--dashboard`.
- Smoke-Abdeckung erweitert: Yearly- und Monthly-Zusatzsuiten (`-m`, `-y`, `-a`) inkl. `--list` und `--keep-going`.

## Roadmap 0.5.6 – Help/Usage Rework (abgeschlossen)
- Help/Usage-Texte konsolidieren und CLI-Beispiele vereinheitlichen.
- Validierungsfehler sprachlich/strukturell harmonisieren (konsistente Fokus-Flags + klare Handlungsanweisung).
- Doku- und CLI-Ausgabe fuer Flags (`--monthly`, `--yearly`, `--csv`, `--dashboard`, `--pretty`) inhaltlich synchron halten.
- Keine neue Fachlogik; Fokus auf UX-Klarheit und Konsistenz.

## Roadmap 0.5.6-0 – Zwischenversion Unit-Vorbereitung (abgeschlossen)
- Ziel: gezielte Zwischenversion vor 0.6.0 zur Einfuehrung einer zusaetzlichen Unit.
- Fokus: strukturierte Extraktion in eine neue Unit mit sauberer Verdrahtung im bestehenden CLI-Flow.
- Erreicht: Parse/Validate-Trennung mit dedizierter Unit `u_cli_validate` (Meta-/Action-Flow, Domain-Policies, Output-/Format-Policies, Period-Policies).
- Erreicht: Framework-freie Domain-Policy-Cases fuer den Validate-Layer (`tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`) und Runner-Integration in den Basis-Smoke.
- Keine neue Fachlogik eingefuehrt; Schwerpunkt auf Struktur, Lesbarkeit und wartbarer Zustandsfuehrung umgesetzt.

## Roadmap 0.6.0 – Fundament fuer Fahrzeug-Domain (abgeschlossen)
- Ziel: stabile Grundlage fuer spaeteres Multi-Car, ohne sofort Multi-Car-Feature auszurollen.
- Erreicht: Hauptauto-Flow und Fahrzeugbasis (`cars`, `fuelups.car_id`, `missed_previous`) als konsolidiertes Fundament stabilisiert.
- Erreicht: Domain-Policy-Matrix v1 vollstaendig umgesetzt und regressionsgesichert (`P-001..P-060` inkl. Car-Isolation `P-060/02`).
- Erreicht: Migrations-/Domainregeln und Policy-Haertegrade (Hard Error vs Warning+Confirm) als konsistenter Rahmen dokumentiert und getestet.
- Nicht-Ziele 0.6.0 eingehalten: keine GUI, keine Web-API, kein Subcommand-Umbau, kein Overengineering.

## Roadmap 0.7.x – Multi-Car CLI (abgeschlossen / 0.7.0 freigegeben)
- Cars-CRUD: umgesetzt.
- Resolver + kein implizites Default: umgesetzt.
- Strict Scoping fuer `--add/--list fuelups` und `--stats fuelups`: umgesetzt.
- Tests/Smokes fuer Resolver-Matrix und Cross-Car-Isolation: umgesetzt.
- Docs/Vision/Status-Sync auf Ist-Zustand: umgesetzt.
- Konsistenzschritt Policy-Contract vs. Runtime-Text: umgesetzt (Tests/Doku entkoppelt, Runtime unveraendert).

## Roadmap 0.8.x – Export-/Contract-Phase (abgeschlossen / 0.8.0 freigegeben)
- Feldbasierte CSV-Assertions (Token-Parsing) finalisiert (`S5C1/1`: Domain-Policy `P-060/01` und `P-060/02`).
- Export-/Output-Contracts fuer CSV/JSON sind dokumentiert (`docs/EXPORT_CONTRACT.md`) und testseitig abgesichert.
- DoD 0.8.x ist erreicht (CSV-Contract-Haertung, VIN-/i18n-Vorbereitung, Multi-Car-Smokes stabil gruen).

## Roadmap 0.9.x – abgeschlossen / 0.9.0 freigegeben
- 0.9.0 wurde am 2026-03-15 final freigegeben.
- Priorisierung und Scope-Freeze fuer 0.9.x festziehen (keine Scope-Drift).
- Performance Sweep nur trigger-basiert (kein Selbstzweck; nur bei messbarem Schmerz).
- Weiterfuehrung entlang klarer Guardrails: erst korrekt, dann schnell, dann schoen.
- Erreicht (S6-Baseline): Modulstrategie ist auf `accepted`, technischer Modul-Handshake (`--module-info`) ist implementiert und per dediziertem Modules-Smoke regressionsgesichert.
- Gestartet (S7C1/4): CLI-Wiring fuer `--stats fleet` inkl. Validate/Dispatch und MVP-Textausgabe.
- Erreicht (S7C2/4): Fleet-JSON-MVP (`--stats fleet --json [--pretty]`) inkl. Export-Meta und Tests.
- Erreicht (S7C3/4): Fleet-Guardrails gehaertet und regressionsgesichert (ungueltige Fleet-Optionen werden stabil abgefangen).
- Erreicht (S7C4/4): Sprint-7-Abschluss mit finalem Verifikationslauf und Doku-Sync.
- Gestartet (S8C1/4): Cost-MVP-Basis via `--stats cost` (Text, fuel-basiert, maintenance-ready Placeholder).
- Erreicht (S8C2/4): Cost-JSON-MVP (`--stats cost --json [--pretty]`) inkl. Export-Meta und Contract-Update.
- Erreicht (S8C3/4): Cost-Guardrails gehaertet und regressionsgesichert fuer ungueltige Cost-Optionen.
- Erreicht (S8C4/4): Sprint-8-Abschluss mit finaler Verifikation und Doku-Sync.
- Gestartet (S9): Cost Scoped Analytics v1.1 (Period-/Car-Scope fuer `--stats cost`).
- Erreicht (S9C1/4): CLI-Scope-Enablement fuer Cost (`--from/--to`, `--car-id`) in Validate/Help/Dispatch aktiviert.
- Erreicht (S9C2/4): Cost-Collector und Textausgabe auf aktiven Period-/Car-Scope erweitert.
- Erreicht (S9C3/4): Cost-JSON-Contract um Scope-/Period-Felder erweitert und Contract-Check synchronisiert.
- Erreicht (S9C4/4): Cost-Scope-Guardrails via Domain-Policy `P-061` regressionssicher erweitert (Car-/Period-Isolation) und Sprint 9 fachlich abgeschlossen.
- Gestartet (S10): Maintenance-Companion von Handshake auf fachliche v0.2-Basis heben.
- Erreicht (S10C1/4): Modul-Schema + idempotente Migration fuer `betankungen-maintenance` umgesetzt (`--migrate [--db <path>]`, `module_meta`, `maintenance_events`).
- Erreicht (S10C2/4): Companion-CRUD-Basis umgesetzt (`--add maintenance`, `--list maintenance` inkl. Scope via `--car-id`).
- Erreicht (S10C3/4): Companion-Stats-Basis umgesetzt (`--stats maintenance` Text + JSON/Pretty inkl. Scope via `--car-id` und Contract `maintenance_stats_v1`).
- Erreicht (S10C4/4): Modul-Smoke-/Contract-Haertung finalisiert (Guardrails fuer ungueltige Stats-/JSON-Kombinationen regressionsgesichert, Contract-Doku synchronisiert).
- Erreicht (S11): Core-zu-Modul-Kostenintegration plus 0.9.0-Readiness-Paket.

## Roadmap 1.0.0 - verbindlicher Fahrplan (abgeschlossen)

- Der verbindliche Gate-Plan liegt in `docs/ROADMAP_1_0_0.md`.
- Gate-Stand:
  - Gate 1 (S12) abgeschlossen am 2026-03-15.
  - Gate 2 (S13) abgeschlossen am 2026-03-15 (Contract + Modulfaehigkeiten; `BL-0012` done, zentrale CSV-Contract-Regression in Verify/CI verankert, Deprecation-Status gemaess `POL-002` explizit dokumentiert, Abschlusslauf `S13C4/4` mit `make verify` gruen).
  - Gate 3 (S14) abgeschlossen am 2026-03-15: Wiki-v1 ist live, `BL-012` ist `done`, Source-of-Truth-Links sind auf absolute Repo-Ziele gehaertet und interne Wiki-Links rendern ohne `.md`-Raw-Redirect.
  - Gate 4 (S15) abgeschlossen am 2026-03-16: RC-Haertung ist dokumentiert abgeschlossen (S15C1/4 bis S15C4/4), inkl. lokalem Voll-Preflight und CI-Referenz (`scripts/release_preflight_1_0_0.sh`, `make release-preflight-1-0-0`, `docs/RELEASE_1_0_0_PREFLIGHT.md`, CI-Run `23153384396`).
  - Gate 5 abgeschlossen am 2026-03-16: finale Release-Freigabe ist erfolgt (`APP_VERSION=1.0.0`, finaler Doku-Sync, Release-Artefakt `.releases/Betankungen_1_0_0.tar`, Backup `.backup/2026-03-16_1736`).
  - Repo-Governance aktiv: `main` ist PR-only mit Required-Check `verify`, Up-to-date-Pflicht, Conversation-Resolution und Admin-Enforcement; im Solo-Maintainer-Betrieb ohne verpflichtende Approvals.
- Ergebnis fuer die 1.0.0-Linie:
  - `1.0.0` ist final freigegeben.
  - Die naechste Entwicklungsbasis ist aktiv auf `APP_VERSION=1.1.0-dev` gesetzt.
- Fokus fuer den 1.0.0-Zyklus:
  - Module Capability Discovery (`BL-0012`) produktiv und regressionssicher.
  - Contract-Haertung gemaess `POL-002` (JSON/CSV/CLI, keine stillen Semantikwechsel), operationalisiert ueber `docs/CONTRACT_HARDENING_1_0_0.md`.
  - Public-Readiness-Mindestpaket gemaess `BL-012`.
  - Release-Haertung ueber standardisierte Verify-/Preflight-Gates.
- Optional erreicht:
  - Trigger-basierter Stats-Benchmark-Harness (`BL-0013`) ist als optionaler Runner verfuegbar.
- Explizit out of scope:
  - Runtime-Config-Profile im Core (`ADR-0009` = `rejected`).
  - Import-/Export-Paketformat (`BL-0014`) als spaeterer Forschungsblock.

## Roadmap 1.1.0 - verbindlicher Fahrplan (abgeschlossen)

- Der aktive Gate-Plan liegt in `docs/ROADMAP_1_1_0.md`.
- Gate-Stand:
  - Gate 1 abgeschlossen am 2026-03-16 (Zyklusstart auf `APP_VERSION=1.1.0-dev` und Doku-Sync).
  - Gate 2 abgeschlossen am 2026-03-16 (Scope-Freeze im Tracker: `BL-0014` + `TSK-0006` als priorisierter Feature-Block, `BL-0015` + `TSK-0007` als priorisierter Hardening-Block, inkl. explizitem Out-of-Scope).
  - Gate 3 abgeschlossen am 2026-03-17 (Feature-/Hardening-Block `BL-0014`/`BL-0015` final auf `done`, Matrix komplett auf `done`, lokaler Abschlusslauf `make release-preflight-1-1-0` gruen; letzte CI-Referenz auf `main`: Run `23208794011`, Commit `e67860f`).
  - Gate 4 abgeschlossen am 2026-03-18 (Kickoff + RC-Checklisten-/Freeze-Snapshot + RC-Abschlusslauf + Exit-/Handover-Narrativ bis `S18C4/4` dokumentiert; CI-Referenz auf `main`: Run `23241536267`, Commit `6b1a0c1`).
  - Gate 5 abgeschlossen am 2026-03-18 (Kickoff `S19C1/4` + Checklisten-/Scope-Snapshot `S19C2/4` + Release-Umschaltpaket `S19C3/4` + finaler Release-/Backup-Run in `S19C4/4`; Artefakt `.releases/Betankungen_1_1_0.tar`, SHA-256 `f3c1f5ef4a8daa3a5a1cf9d4cb74c871c2799c1338e1eafe2422a6bfbeb026f3`, Snapshot `.backup/2026-03-18_1331`).
- Leitplanken fuer die 1.1.0-Linie:
  - keine Runtime-Config-Profile im Core (`ADR-0009` bleibt `rejected`);
  - Contract-Evolution strikt nach `POL-002` (keine stillen Breaks);
  - Public-Repo-Governance mit PR-only auf `main` und gruener `verify`-Pflicht.
- Operativer Fokus:
  - 1.1.0 ist final freigegeben (`APP_VERSION=1.1.0`, historischer Abschlussstand).
  - BL-Triage-Lanes im kanonischen Tracker bleiben als leichte Priorisierung aktiv (`release-blocking`/`planned`/`exploratory`).

## Roadmap 1.3.0 - verbindlicher Fahrplan (abgeschlossen)

- Der verbindliche Gate-Plan der abgeschlossenen 1.3.0-Linie liegt in
  `docs/ROADMAP_1_3_0.md`.
- Gate-Stand:
  - Gate 1 abgeschlossen am 2026-03-24 (Zyklusstart auf
    `APP_VERSION=1.3.0-dev`, neue Roadmap verankert).
  - Gate 2 abgeschlossen am 2026-03-24 (Scope-Freeze: `BL-0017` +
    `TSK-0018`/`TSK-0019` sowie `BL-0018` + `TSK-0020`/`TSK-0021` als
    release-blocking; die Folgeversion `1.4.0` wurde initial auf
    `BL-0016` + `BL-0011` vorgemerkt und in Sprint 24 repo-seitig
    nachgeschaerft).
  - Gate 3 abgeschlossen am 2026-03-24 (`BL-0017` + `BL-0018` auf `done`,
    Polling-Runner/Regression geliefert, lokaler Abschlusslauf `make verify`
    gruen).
  - Gate 4 abgeschlossen am 2026-03-26 (RC-Kickoff, RC-Checklisten-/Freeze-
    Snapshot und finaler RC-Abschlusslauf mit lokalem Vollnachweis
    `make release-preflight-1-3-0`).
  - Gate 5 abgeschlossen am 2026-03-26 (finaler Versionswechsel
    `APP_VERSION=1.3.0`, finaler Doku-Sync sowie finale Release-/
    Backup-Ausfuehrung; Artefakt `.releases/Betankungen_1_3_0.tar`, SHA-256
    `d9e61f0c6516c67c5191882c163bb28f664db2a1d1f41397766830a1280653de`,
    Snapshot `.backup/2026-03-26_1918`).
- Leitplanken fuer die 1.3.0-Linie:
  - keine Runtime-Config-Profile im Core (`ADR-0009` bleibt `rejected`);
  - externe Preisquellen nur auf Basis einer expliziten API-/Lizenzentscheidung
    aus `BL-0017`;
  - Polling-/Historien-Daten bleiben konzeptionell getrennt von produktiven
    Core-Datenbanken, bis das Trennkonzept fuer `BL-0018` dokumentiert ist;
  - Contract-Evolution strikt nach `POL-002` (keine stillen Breaks);
  - Backup-/Restore-/Privacy strikt nach `POL-003`;
  - Public-Repo-Governance mit PR-only auf `main` und gruener `verify`-Pflicht.
- Operativer Fokus:
  - `1.3.0` ist seit 2026-03-26 final freigegeben.
  - Finaler technischer Stand der abgeschlossenen 1.3.0-Linie bleibt
    `APP_VERSION=1.3.0` als historischer Release-Stand.
  - Die aktive Entwicklungsbasis wurde jetzt per separatem
    Aktivierungs-Commit auf `APP_VERSION=1.4.0-dev` gesetzt.
  - Sprint 29 dokumentiert den formalen Startgate vor `1.4.0-dev` in
    `docs/DEV_START_GATE_1_4_0.md`; dieser Gate ist durch den separaten
    Startschritt in Sprint 30 eingeloest.
  - Die Gate-Leitplanke bleibt verbindlich erfuellt:
    kein impliziter Dev-Start, keine Vermischung des Versionswechsels mit
    `BL-0016` oder spaeteren Inhaltsarbeiten.
  - Die Abgrenzung ist verbindlich geschaerft:
    abgeschlossener Vorbereitungsblock (Sprint 23-28) != Startfreigabe
    (Sprint 29) != eigentlicher Dev-Start (`APP_VERSION -> 1.4.0-dev` in
    eigenem Commit Sprint 30).
  - `ADR-0010` ist als MVP jetzt umgesetzt: repo-lokales Wrapper-CLI
    `btkgit` ist verfuegbar (`./btkgit`, `scripts/btkgit.sh`) fuer
    `sync`, `preflight`, `ready` und `cleanup`.
  - `BL-0024` ist abgeschlossen: Cookie-Notiz ist als kuratierte,
    unaufdringliche Wiki-Seite veroeffentlicht
    (`docs/wiki/Cookie-Note.md`) und Navigation/Link-Checks sind synchron.
  - Der verbindliche Release-Kern fuer `1.3.0` folgt Option B:
    `BL-0017` (API-Evaluation) + `BL-0018` (Polling/Historisierung).
  - `BL-0017` ist abgeschlossen: Entscheidungsvorlage und Betriebsgrenzen fuer
    den Provider-Fit liegen in `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md` vor
    (Primaerquelle `Tankerkoenig`, Fallback `Benzinpreis-Aktuell.de`).
  - `BL-0018` ist abgeschlossen: Polling-/Historien-Contract, separater
    Runtime-Pfad und Regressionsevidenz liegen in
    `docs/FUEL_PRICE_POLLING_HISTORY_CONTRACT_1_3_0.md`,
    `docs/FUEL_PRICE_POLLING_RUNTIME_1_3_0.md`,
    `scripts/fuel_price_polling_run.sh` und
    `tests/regression/run_fuel_price_history_check.sh` vor.
  - Scope-Freeze fuer `1.3.0` ist gesetzt:
    `BL-0017` + `TSK-0018`/`TSK-0019` sowie `BL-0018` +
    `TSK-0020`/`TSK-0021` sind als release-blocking verankert.
  - Gate 3 ist auf Abschlussstand: `make verify` enthaelt jetzt zusaetzlich den
    Fuel-Price-History-Regression-Check und lief lokal gruen.
  - Der fruehere Planungsmarker `1.4.0 = BL-0016 + BL-0011` ist
    repo-seitig abgeschlossen: `BL-0016` wurde als Community-Standards-
    Baseline geliefert; `BL-0011` ist als externes Scaffolder-Thema final
    externalisiert und fuer `Betankungen` repo-seitig geschlossen.
  - Tracker-Endzustand vor `1.4.0-dev` ist fuer neue Arbeit explizit
    festgelegt: neue `BL`/`TSK` unter `docs/backlog/`, neue `ISS` unter
    `docs/issues/`, neue `POL` unter `docs/policies/`; `docs/ADR/` bleibt bis
    zu einer separaten Migrationsentscheidung der aktive ADR-Pfad, waehrend
    `docs/BACKLOG/` und `docs/tasks/` als Legacy lesbar bleiben.
  - Die abgeschlossenen Sprints 25 bis 28 sind dafuer jetzt auch ueber
    kanonische Backfill-Artefakte referenzierbar: `BL-0025` bis `BL-0028`
    sowie `ADR-0011` bis `ADR-0013` dokumentieren Tracker-Endzustand,
    Entry-/Wiki-Layer und `btkgit`-Safety explizit, ohne neuen Scope zu
    aktivieren.
  - Der dokumentierte Handover-/Externalisierungsstand fuer `BL-0011` liegt
    in `docs/BL-0011_SCOPE_DECISION_1_4_0.md`; eventuelle Folgearbeit findet
    nur in einem separaten Zielprojekt statt, solange keine neue Re-Entry-
    Entscheidung getroffen wird.
  - Gate-4-Blueprint liegt in `docs/RELEASE_1_3_0_PREFLIGHT.md`; operativer
    Entrypoint ist `make release-preflight-1-3-0`.
  - Lokaler RC-Kickoff und finaler RC-Abschlusslauf fuer Gate 4 sind
    erfolgreich gelaufen (`make release-preflight-1-3-0` inklusive
    `make verify` und Dry-Runs).
  - RC-Checklisten-/Freeze-Snapshot und Gate-4-Closeout sind dokumentiert;
    aktuelle CI-Referenz auf `main`: Run `23515516312`, Commit `027e963`,
    Status `success`.
  - Gate-5-Closeout ist in `docs/RELEASE_1_3_0_PREFLIGHT.md` dokumentiert
    (Scope/Version/Audit/Exit-Checks, finaler Umschalt- und Release-Block).
  - Die aktive Folgeversion ist jetzt `1.4.0-dev`; `BL-0016` wurde als erster
    In-Repo-Block geliefert und bildet jetzt die Community-Standards-
    Baseline des Public-Repositories.
  - Geliefert wurden `CODE_OF_CONDUCT.md`, `SECURITY.md`, standardisierte
    Bug-/Feature-Issue-Templates sowie ein PR-Template mit `Summary` und
    `Validation`; `BL-0011` gilt fuer `Betankungen` jetzt als sauber
    externalisiert und repo-seitig abgeschlossen.

## Roadmap 1.2.0 - verbindlicher Fahrplan (abgeschlossen)

- Der verbindliche Gate-Plan liegt in `docs/ROADMAP_1_2_0.md`.
- Gate-Stand:
  - Gate 1 abgeschlossen am 2026-03-18 (Zyklusstart auf `APP_VERSION=1.2.0-dev`, neue Roadmap verankert).
  - Gate 2 abgeschlossen am 2026-03-18 (Scope-Freeze: `BL-0020` + `TSK-0008`/`TSK-0009` sowie `BL-0021` + `TSK-0010`/`TSK-0011` als release-blocking).
  - Gate 3 abgeschlossen am 2026-03-19 (release-blocking Scope geliefert: `BL-0020` + `BL-0021` auf `done`, Contract-Hardening auf Abschlussstand).
  - Gate 4 abgeschlossen am 2026-03-19 (RC-Checklisten-/Freeze-Snapshot + lokaler Vollnachweis `make verify` + CI-Referenz auf `main`: Run `23307738745`, Commit `3e9be17`).
  - Gate 5 abgeschlossen am 2026-03-24 (finaler Versionswechsel
    `APP_VERSION=1.2.0`, finaler Doku-Sync sowie finale Release-/
    Backup-Ausfuehrung; Artefakt `.releases/Betankungen_1_2_0.tar`, SHA-256
    `b8798ab376bdc0b4cd17c7e8f47f6904d5337b26e96472a2b2ab99dcfddbca1d`,
    Snapshot `.backup/2026-03-24_1809`).
- Leitplanken fuer die 1.2.0-Linie:
  - keine Runtime-Config-Profile im Core (`ADR-0009` bleibt `rejected`);
  - Contract-Evolution strikt nach `POL-002` (keine stillen Breaks);
  - Backup-/Restore-/Privacy strikt nach `POL-003`;
  - Public-Repo-Governance mit PR-only auf `main` und gruener `verify`-Pflicht.
- Operativer Fokus:
  - 1.2.0 ist final freigegeben (`APP_VERSION=1.2.0`).
  - release-blocking Scope fuer 1.2.0: `BL-0020` (Multi-DB-Backup-Operations, done) und `BL-0021` (Receipt-Photo-Link-References, done).
  - Gate-5-Closeout ist abgeschlossen (Version-Umschalt-/Release-/Backup-
    Paket und Doku-Sync final dokumentiert).
  - Non-blocking Hardening-Stream `BL-0022` ist abgeschlossen: dokumentierte
    Nutzertest-Funde (`ISS-0002` bis `ISS-0006`) sind behoben und ueber
    `TSK-0012` jetzt mit priorisiertem User-Flow-/Break-Regression-Check
    (`tests/regression/run_user_flow_break_matrix_check.sh`) in `make verify`
    verankert.
  - Non-blocking Doku-Stream `BL-0023` ist abgeschlossen: Dev-Diary-Baustein
    (`docs/DEV_DIARY.md`) mit initialem Eintrag und Tracker-/Navigations-Sync
    ist verankert.
  - historische Folge-Reihenfolge beim 1.2.0-Abschluss: `1.3.0` = Option B
    (`BL-0017` + `BL-0018`); `1.4.0` war initial als Option C
    (`BL-0016` + `BL-0011`) vorgemerkt und wurde in Sprint 24 fuer das
    `Betankungen`-Repo auf `BL-0016` als In-Repo-Scope plus externes
    `BL-0011` praezisiert.

### Vorschlagsabgleich (ADR/BL) vom 2026-03-15

- Abgeschlossen: Integrationscontract Core<->Modul und Cost-Scope-UX sind bereits umgesetzt und als Duplikate markiert (`docs/BACKLOG/BL-010-cost-analytics.md`).
- Public-Readiness-Doku-Paket wurde in `BL-012` konsolidiert (inkl. FAQ/Troubleshooting/Link-Check-Richtung).
- Neue Folgeeintraege im kanonischen Tracker:
  - `BL-0012` (Module Capability Discovery, post-0.9.0)
  - `BL-0013` (Stats Performance Benchmark Harness, trigger-basiert)
  - `BL-0014` (Import/Export Paketformat mit Manifest/Checksum; in Gate 3 der 1.1.0-Linie abgeschlossen)
  - `BL-0021` (Tankbeleg-Foto-Links als externe Referenz, nicht blockierend fuer 1.1.0)
- Neue Policies:
  - `POL-002` (Contract Evolution + Deprecation)
  - `POL-003` (Backup Retention/Restore/Privacy)
- Runtime-Config-Profile wurden als out-of-scope fuer den Core formal abgelehnt (`ADR-0009`, `rejected`).

## Roadmap Sprint 9 - Cost Scoped Analytics v1.1

- Status: abgeschlossen (`S9C1/4` bis `S9C4/4`)
- Ziel: `--stats cost` von MVP auf nutzbaren Analysemodus mit kontrolliertem Scope heben.

### S9C1/4 - CLI-Scope-Enablement

- Erreicht: Validate-/Help-/Dispatch-Freigabe fuer `--stats cost` mit `--from/--to` und `--car-id`.
- Erreicht: Konfliktregeln fuer ungueltige Kombinationen bleiben fuer Cost-MVP-Formate weiter strikt (`--csv`, `--monthly`, `--yearly`, `--dashboard`).

### S9C2/4 - Collector + Textausgabe

- Erreicht: Cost-Collector um Zeitraum- und Fahrzeug-Scope erweitert.
- Erreicht: Textausgabe um klaren Scope-/Period-Hinweis ergaenzt.

### S9C3/4 - JSON-Contract Ausbau

- Erreicht: Cost-JSON um Scope-/Period-Felder erweitert.
- Erreicht: `docs/EXPORT_CONTRACT.md` und Contract-Regression entsprechend synchronisiert.

### S9C4/4 - Guardrails + Finalisierung

- Erreicht: Domain-Policy/Smoke fuer neue Cost-Scope-Pfade vollstaendig abgesichert (inkl. neuer Policy `P-061` fuer Car-/Period-Isolation bei `--stats cost`).
- Erreicht: Sprint-/Status-/Entry-Doku auf finalen Sprint-9-Stand synchronisiert.

## Roadmap Sprint 10 - Maintenance Companion v0.2

- Status: abgeschlossen (`S10C1/4` bis `S10C4/4`)
- Ziel: `betankungen-maintenance` von Contract-Skeleton auf fachliche Nutzbarkeit heben.

### S10C1/4 - Modul-Schema + Migration

- Erreicht: eigenes Maintenance-Schema (`maintenance_events`) und getrennte Modul-Meta (`module_meta.schema_version`) eingefuehrt.
- Erreicht: idempotente Modul-Migration via `betankungen-maintenance --migrate [--db <path>]` umgesetzt und per Module-Smoke regressionsgesichert.

### S10C2/4 - Modul-CLI Basis

- Erreicht: `--add maintenance` mit validierten Pflichtfeldern (`--car-id`, `--date`, `--type`, `--cost-cents`) im Companion-Modul umgesetzt.
- Erreicht: `--list maintenance` inkl. optionalem Car-Scope (`--car-id`) mit stabilem Text-Output umgesetzt.

### S10C3/4 - Modul-Stats + Export

- Erreicht: `--stats maintenance` als Textausgabe mit Scope-/Period-Transparenz (`all cars` bzw. `car_id=<id>`) und Kennzahlen (`events_total`, `cars_total`, `total_cost_cents`, `avg_cost_per_event_cents`).
- Erreicht: JSON-Contract fuer Modul-Stats eingefuehrt (`contract_version=1`, `kind="maintenance_stats_v1"`, `generated_at`, `app_version`, Payload `maintenance` inkl. Scope-/Period-Feldern) sowie Pretty-Variante via `--json --pretty`.

### S10C4/4 - Modul-Qualitaetsgate

- Erreicht: Module-Smoke deckt Guardrails fuer ungueltige Stats-/JSON-Kombinationen explizit ab (`--stats maintenance --pretty` ohne `--json`, Add-Parameter im Stats-Kontext, `--module-info --json`).
- Erreicht: Contract-Doku fuer `maintenance_stats_v1` in `docs/EXPORT_CONTRACT.md` finalisiert und Modul-/Entry-Doku auf den finalen S10-Stand synchronisiert.

## Roadmap Sprint 11 - Integration + 0.9.0 Readiness

- Status: abgeschlossen (`S11C1/4` + `S11C2/4` + `S11C3/4` + `S11C4/4` umgesetzt)
- Ziel: fuel + maintenance konsistent integrieren und Release-Reife vorbereiten.

### S11C1/4 - Integrationscontract

- Erreicht: expliziter Integrationsmodus fuer Cost-Stats eingefuehrt (`--maintenance-source none|module`).
- Erreicht: Kontext-Policy verdrahtet (`--maintenance-source` nur fuer `--stats cost`).
- Erreicht: Core-Cost gibt den Integrationsmodus transparent aus (Text + JSON-Contract-Felder `maintenance_source_mode`, `maintenance_source_active`).
- Erreicht: Guardrails fuer den Modus wurden regressionssicher verdrahtet (Smoke + Validate).

### S11C2/4 - Kostenaggregation

- Erreicht: Cost-Aggregation integriert Maintenance-Anteil im Modus `--maintenance-source module` ueber Companion-Stats (`maintenance_stats_v1`).
- Erreicht: robuster, expliziter Fallback statt Hard-Fail oder stillem Verhalten (bei fehlender/ungueltiger Modulquelle: `maintenance_source_active=false` + `maintenance_source_note`).
- Erreicht: optionale Integrations-Overrides fuer Binary/DB (`BETANKUNGEN_MAINTENANCE_BIN`, `BETANKUNGEN_MAINTENANCE_DB`) eingefuehrt.

### S11C3/4 - Regression + CI-Haertung

- Erreicht: dedizierte Integrations-Regression `tests/regression/run_cost_integration_modes_check.sh` eingefuehrt.
- Erreicht: Check deckt beide Modi robust ab (`--maintenance-source none|module`) inkl. aktivem Modulpfad und expliziten Fallback-Szenarien (fehlendes Binary, period-gefilterter Modulmodus).
- Erreicht: lokales Verify-Gate erweitert (`make verify` enthaelt jetzt `cost-integration-check`).
- Erreicht: CI-Gate erweitert (`.github/workflows/ci.yml` fuehrt den neuen Cost-Integrations-Check als Pflichtschritt im Job `verify` aus).

### S11C4/4 - Release-Readiness

- Erreicht: Scope-Freeze fuer die 0.9.0-Linie dokumentiert (klarer In-/Out-of-Scope-Rahmen).
- Erreicht: standardisierter lokaler Preflight eingefuehrt (`scripts/release_preflight.sh`, `make release-preflight`).
- Erreicht: Release-Readiness-Checkliste fuer 0.9.0 verankert (`docs/RELEASE_0_9_0_PREFLIGHT.md`).

## Roadmap Sprint 6 - Modulstrategie operationalisieren

- Status: done (`S6C1/4` + `S6C2/4` + `S6C3/4` + `S6C4/4` umgesetzt)
- Ziel: Modulstrategie verbindlich machen und mit einem lauffaehigen Contract-Baseline-Flow absichern.

### S6C1/4 - ADR-Finalisierung

- Erreicht: `ADR-0005` auf `accepted` gesetzt.
- Erreicht: Scope-Grenzen fuer Core-vs-Module verbindlich dokumentiert.

### S6C2/4 - Minimaler Modul-Handshake

- Erreicht: Shared Contract-Unit `u_module_info` fuer `--module-info` JSON eingefuehrt.
- Erreicht: Companion-Skeleton `src/betankungen-maintenance.lpr` aufgebaut (`--help`, `--version`, `--module-info`, `--module-info --pretty`).
- Erreicht: Core-Entwicklungslinie auf `APP_VERSION 0.9.0-dev` synchronisiert.

### S6C3/4 - Smoke-Haertung

- Erreicht: dedizierte Modules-Suite `tests/smoke/smoke_modules.sh` eingefuehrt.
- Erreicht: Wrapper `tests/smoke_modules.sh` und Integration in `smoke_cli`/`smoke_clean_home` via `--modules`.

### S6C4/4 - Contract-v1 Abschluss

- Erreicht: `docs/MODULES_ARCHITECTURE.md` von Draft auf operative v1-Baseline gehoben.
- Erreicht: Feldsemantik fuer `--module-info` eindeutig dokumentiert (`db_schema_version` = Modul-Schema, nicht Core-Schema).
- Erreicht: Entry-Doku (DE/EN) und Sprint-/Statusdoku auf den S6-Abschluss synchronisiert.

## Roadmap Sprint 7 - Fleet Stats MVP

- Status: done (`S7C1/4` + `S7C2/4` + `S7C3/4` + `S7C4/4` umgesetzt)
- Ziel: schrittweise Einfuehrung von `--stats fleet` als klaren, fahrzeuguebergreifenden Stats-Modus.

### S7C1/4 - CLI Validate/Dispatch

- Erreicht: CLI akzeptiert `--stats fleet` als eigenen Stats-Target-Pfad.
- Erreicht: Dispatch im Orchestrator verdrahtet.
- Erreicht: MVP-Textausgabe mit aggregierten Fleet-Basiswerten (Cars/Fuelups/Liters/Cost).

### S7C2/4 - Fleet JSON MVP

- Erreicht: `--stats fleet --json` und `--stats fleet --json --pretty` im Core verdrahtet.
- Erreicht: JSON-Output mit Export-Meta (`contract_version`, `generated_at`, `app_version`) und `kind: "fleet_mvp"`.
- Erreicht: Fleet-Payload `fleet` mit `cars_total`, `fuelups_total`, `liters_ml_total`, `total_cents_all`.
- Erreicht: Smoke- und Validate-Tests fuer Fleet-JSON nachgezogen.

### S7C3/4 - Fleet Guardrails Hardening

- Erreicht: Fleet-Policy-Guardrails in Validate-Tests erweitert (`--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`).
- Erreicht: Smoke-Baseline um Fleet-Fehlerpfade fuer ungueltige Optionen erweitert.
- Erreicht: Doku auf den gehaerteten Fleet-MVP-Contract synchronisiert.

### S7C4/4 - Sprint-Abschluss

- Erreicht: Sprint-7-DoD final verifiziert (Fleet Text/JSON/Guardrails stabil in Domain-Policy + Smoke).
- Erreicht: Sprint-/Status-/Changelog-Narrative auf finalen Sprint-7-Stand synchronisiert.

## Roadmap Sprint 8 - Cost Analytics MVP

- Status: done (`S8C1/4` + `S8C2/4` + `S8C3/4` + `S8C4/4`)
- Ziel: `--stats cost` als erste Kostenperspektive einziehen und fuer spaetere Maintenance-Integration vorbereiten.

### S8C1/4 - CLI + Text MVP

- Erreicht: CLI akzeptiert `--stats cost` als eigenen Stats-Target-Pfad.
- Erreicht: Cost-MVP-Textausgabe im Core verdrahtet (fuel-basiert, maintenance als Placeholder `0`).
- Erreicht: Domain-Policy-/Smoke-Abdeckung fuer den initialen Cost-Pfad (`--stats cost`) als Basis fuer den nachfolgenden JSON-Ausbau.

### S8C2/4 - JSON MVP + Contract

- Erreicht: `--stats cost --json [--pretty]` im Core verdrahtet (Dispatch + Renderer in `u_stats`).
- Erreicht: Export-Meta fuer Cost-JSON aktiv (`contract_version`, `generated_at`, `app_version`, `kind: "cost_mvp"`).
- Erreicht: Cost-Payload im Contract dokumentiert (`docs/EXPORT_CONTRACT.md`) und Domain-Policy-/Smoke-Abdeckung auf JSON compact/pretty umgestellt.

### S8C3/4 - Guardrails + Regression

- Erreicht: Cost-Guardrails fuer ungueltige Optionen regressionsgesichert (`--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`, `--car-id`).
- Erreicht: Domain-Policy-Case `t_p000__01__cli_validate_core` um Cost-Fehlerpfade erweitert.
- Erreicht: Smoke-Baseline (`tests/smoke/smoke_cli.sh`) um dedizierte Cost-Guardrail-Checks erweitert.

### S8C4/4 - Sprint-Abschluss

- Erreicht: Sprint-8-DoD final verifiziert (Cost Text/JSON/Guardrails stabil in Domain-Policy + Smoke).
- Erreicht: Abschluss-Verifikation inkl. Clean-Home-Smoke (`tests/smoke/smoke_clean_home.sh --modules`) erfolgreich.
- Erreicht: Sprint-/Status-/Changelog-Narrative auf finalen Sprint-8-Stand synchronisiert.

## Roadmap Sprint 4 - i18n First (Docs/Policy before Wiring)

- Status: done (`S4C1/3` + `S4C2/3` + `S4C3/3` umgesetzt)
- Ziel: klare i18n-Regelbasis vor jeglicher Skeleton-Verdrahtung

### S4C1/3 - Policy- und Architektur-Doku

- i18n-Begruendung und Zielbild dokumentieren
- Sprachscope `language=de|en|pl` festlegen
- Testregel "keine Kopplung an lokalisierte Vollsaetze" verbindlich festhalten
- Migrationsgrenzen fuer Sprint 4 dokumentieren (in/out of scope)

### S4C2/3 - Minimaler i18n-Skeleton (nach Doku-Freigabe)

- Erreicht: `u_i18n.pas` als zentrale i18n-Unit eingefuehrt.
- Erreicht: `TMsgId` als stabiler Message-Key-Contract angelegt.
- Erreicht: `Tr()` als zentraler Lookup-Einstiegspunkt vorbereitet.
- Erreicht: `language=de|en|pl` im Config-Flow verankert (Normalisierung, Default `de`, Persistenz in `config.ini`).
- Guardrails eingehalten: keine breite Lauftext-Migration, keine invasive Massenaenderung bestehender Flows.

### S4C3/3 - Kontrollierte Textmigration + Testhaertung

- Erreicht: Kleine Auswahl risikoarmer Runtime-Meta-Texte auf `TMsgId` + `Tr()` migriert (Config-/First-Run-/generische Systemmeldungen).
- Erreicht: Keine breite Help-Uebersetzung und keine vollstaendige Fehlertext-Migration.
- Erreicht: Teststrategie bleibt stabil (keine textgetriebenen Test-Anpassungen, keine Contract-Aenderungen in JSON/CSV).

### Sprint-4 Nicht-Ziele

- Keine Aenderung an JSON-/CSV-Contracts
- Keine Aenderung an CLI-Flag-Semantik
- Keine automatische Locale-Erkennung ausserhalb des expliziten Sprachparameters

## Entscheidungen 0.5.0 (festgezurrt, 2026-02-09)
- Offene Grenzen bei Filtern sind datengetrieben: nur `--from` => `to = MAX(fueled_at)`, nur `--to` => `from = MIN(fueled_at)` (kein "heute").
- Zyklusregel am Rand: Zyklus zählt nur, wenn Start- und End-Volltank im Zeitraum liegen (vollständig im Zeitraum).
- JSON-avg: `avg_l_per_100km` als scaled Integer (z. B. `avg_l_per_100km_x100`), keine Strings.

## 0.5.1 – CLI Flags (umgesetzt)
- `--csv`: nur bei `--stats fuelups`, exklusiv (kein Mix mit Text/JSON)
- `--pretty`: nur zusammen mit `--json` (damit nur bei `--stats fuelups`)
- Validierung: `--csv` nur mit `--stats fuelups`; `--pretty` nur mit `--json`; `--csv` nicht mit `--json`
- Dispatch (fuelups/stats): `--csv` -> `ShowFuelupStatsCsv(...)`, sonst `--json` -> `ShowFuelupStatsJson(... Pretty=Cmd.Pretty)`, sonst Text -> `ShowFuelupStats(...)`

## Qualitaet & Reifegrad
- Projekt ist stabil, testbar und reproduzierbar
- Kein Experimentier-Chaos
- Iterative Entwicklung mit bewusstem Scope
- Polishing (Tabellen-Layout, Usage-Text) bewusst nachgelagert

## Kurzfazit
- 0.4.2 abgeschlossen und stabil
- 0.5.2 freigegeben (Dashboard, Unicode-Box-Engine, UTF-8/ANSI-Layoutstabilitaet)
- 0.5.3 freigegeben (Struktur-/Reife-Release); Jahres-Summary bleibt bewusst auf 0.5.5 verschoben
- 0.5.4 freigegeben (First-Run UX & Initialisierung inkl. Smoke-Absicherung)
- 0.5.5 freigegeben (Jahres-Summary inkl. Text/JSON + Validierung + Smoke-Regression)
- 0.5.6 freigegeben (Help/Usage Rework inkl. strukturierter Vollhilfe und konsistentem Kurz-Fehlerpfad).
- 0.5.5-Release-Artefakt final inkl. Post-Release-Doku-Sync erstellt (siehe `.releases/release_log.json`).
- 0.5.6-Release-Artefakt final erstellt (siehe `.releases/release_log.json`).
- 0.5.6-0-Release-Artefakt final erstellt (siehe `.releases/release_log.json`).
- 0.5.6-0 freigegeben (CLI-Validate-Layer finalisiert inkl. Unit-Tests + Smoke-Integration).
- 0.6.0-Release-Artefakt final erstellt (siehe `.releases/release_log.json`).
- 0.6.0 freigegeben (Fahrzeug-Domain konsolidiert inkl. Domain-Policy-Matrix v1 und Car-Isolation-Regression).
- Domain-Policy-Matrix v1 ist testseitig konsolidiert (inkl. Car-Isolation-Regression fuer Stats).
- 0.7.0-Release-Artefakt final erstellt (siehe `.releases/release_log.json`, `sha256=bb4769ec0b63c6299c3bfd6cac2f93c57df9efc50503ad87d2a02179ce1466ef`).
- 0.7.0 freigegeben (Multi-Car-CLI inkl. Resolver, strict car scope und finaler Matrix-Haertung).
- 0.8.0-Release-Artefakt final erstellt (lokal via `kpr.sh`, `sha256=72c26a025bfeaf166af7212e05e2baf688ba6f39ea41a8317c35c0f54435414d`).
- Backup-Snapshot nach 0.8.0 erstellt (`.backup/2026-03-07_2010`, via `scripts/backup_snapshot.sh`).
- Naechster Fokus: 0.9.x (Scope-Freeze + priorisierte Folgeziele).
- Architektur & Prinzipien klar und konsistent
- Scope bleibt bewusst klein, explizit und testbar
