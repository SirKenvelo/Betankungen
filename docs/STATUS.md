# Aktueller Projektstatus – Betankungen
**Stand:** 2026-03-10
**Zielversion:** 0.9.x

## Fundament & Architektur (erledigt)
- CLI-first-Architektur mit klarem Orchestrator (`Betankungen.lpr`)
- Saubere Modultrennung: DB-Init / Seed / Common / Domain / Stats / Logging / Tabellen
- Design Principles, Constraints und Quiet-Policy definiert und dokumentiert
- Kein Overengineering, keine externen Frameworks
- Dokumentation als First-Class-Artifacts:
  - `ARCHITECTURE.md`
  - `BACKLOG.md`
  - `BACKLOG/` (Einzeldateien je Backlog-Item)
  - `CHANGELOG.md`
  - `DESIGN_PRINCIPLES.md`
  - `SPRINTS.md`
  - `ADR/README.md`
- Release-Logging via `scripts/kpr.sh` (kompatibel via Root-Wrapper `kpr.sh`)
- Git-loser Snapshot-Workflow via `scripts/backup_snapshot.sh` (`.backup/YYYY-MM-DD_HHMM` + `.backup/index.json`)
- Restore-Ablauf dokumentiert in `RESTORE.md`
- Wissens-Archiv fuer verworfene Snippets in `knowledge_archive/`
- Smoke-Checks unter `tests/smoke/smoke_cli.sh` (kompatibel via `tests/smoke_cli.sh`)

## Datenmodell & Domain-Logik (erledigt)
- SQLite-Schema v4 stabil (`cars`, `fuelups.car_id`, `fuelups.missed_previous`)
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

## Roadmap 0.9.x – naechster Fokus
- Priorisierung und Scope-Freeze fuer 0.9.x festziehen (keine Scope-Drift).
- Performance Sweep nur trigger-basiert (kein Selbstzweck; nur bei messbarem Schmerz).
- Weiterfuehrung entlang klarer Guardrails: erst korrekt, dann schnell, dann schoen.
- Erreicht (S6-Baseline): Modulstrategie ist auf `accepted`, technischer Modul-Handshake (`--module-info`) ist implementiert und per dediziertem Modules-Smoke regressionsgesichert.
- Gestartet (S7C1/4): CLI-Wiring fuer `--stats fleet` inkl. Validate/Dispatch und MVP-Textausgabe.

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

- Status: in progress (`S7C1/4` gestartet)
- Ziel: schrittweise Einfuehrung von `--stats fleet` als klaren, fahrzeuguebergreifenden Stats-Modus.

### S7C1/4 - CLI Validate/Dispatch

- Erreicht: CLI akzeptiert `--stats fleet` als eigenen Stats-Target-Pfad.
- Erreicht: Dispatch im Orchestrator verdrahtet.
- Erreicht: MVP-Textausgabe mit aggregierten Fleet-Basiswerten (Cars/Fuelups/Liters/Cost).

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
