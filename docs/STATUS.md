# Aktueller Projektstatus – Betankungen
**Stand:** 2026-02-24
**Zielversion:** 0.7.x

## Fundament & Architektur (erledigt)
- CLI-first-Architektur mit klarem Orchestrator (`Betankungen.lpr`)
- Saubere Modultrennung: DB-Init / Seed / Common / Domain / Stats / Logging / Tabellen
- Design Principles, Constraints und Quiet-Policy definiert und dokumentiert
- Kein Overengineering, keine externen Frameworks
- Dokumentation als First-Class-Artifacts:
  - `ARCHITECTURE.md`
  - `CHANGELOG.md`
  - `DESIGN_PRINCIPLES.md`
  - `WAS_WIR_NICHT_TUN.md`
  - `INITIAL_CONTEXT.md`
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
- Danach: 0.7.x (echtes Multi-Car-Feature)
- Architektur & Prinzipien klar und konsistent
- Scope bleibt bewusst klein, explizit und testbar
