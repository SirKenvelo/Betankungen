# System-Architektur & Design-Dokumentation
**Stand:** 2026-02-20

Dieses Dokument beschreibt die zentralen Designentscheidungen, die Architekturprinzipien und die langfristige Roadmap des Projekts **"Betankungen"**.

---

## Zentrale Designentscheidungen (ADR)

*   **Immutable IDs:** Primärschlüssel (IDs) werden niemals neu vergeben. Einmal vergebene IDs bleiben permanent mit ihrem Datensatz verknüpft, um die Referenzintegrität (z. B. in Backups oder Log-Files) zu garantieren.
*   **Single-Table Source of Truth:** Bevorzugung einer klaren Tabellenstruktur gegenüber künstlicher Über-Normalisierung, um die Abfrage-Logik (SQL) simpel und performant zu halten.
*   **Command-Exclusivity:** Das CLI-Interface folgt einem strikten Dispatcher-Modell. Pro Aufruf wird genau eine Hauptaktion (Add, List, Edit, Delete, Seed oder Stats) ausgeführt, was Fehlbedienungen verhindert.
*   **Separation of Concerns (SoC):** Strikte Trennung zwischen Geschäftslogik (`Business Logic`) und Anzeige/Eingabe (`UI`). Die Fach-Units (z. B. `u_stations`) enthalten keine CLI-Parsing-Logik.
*   **CLI-Pipeline (Parse -> Validate -> Dispatch):** Parsing bleibt auf Syntax/Normalisierung begrenzt (`u_cli_parse`), Policy-Validierung liegt zentral in `u_cli_validate`, und fachliche Ausfuehrung erfolgt erst im Orchestrator-Dispatch.
*   **Transaktions-Sicherheit:** Jede Datenbank-Mutation (Schreiben, Ändern, Löschen) wird als atomare Einheit behandelt. Schlägt ein Teil fehl, erfolgt ein vollständiger Rollback (All-or-Nothing).
*   **Defensive Parsing:** "Garbage in, Garbage out" wird an der Systemgrenze verhindert. Eingaben werden über skalierte Integer-Funktionen (Fixed-Point) validiert, bevor sie die Fachlogik erreichen.

---

## Aktueller Funktionsumfang (Stand 2026-02-20)
Siehe `CHANGELOG.md`, Version `0.5.6` plus `[Unreleased]`.

### Infrastruktur & Tooling
- [x] **XDG-Konformität:** Trennung von Daten (`~/.local/share/`) und Konfiguration (`~/.config/`).
- [x] **Zentrales DB-Handling:** Unterstützung für Default-Pfade, persistente INI-Konfiguration und CLI-Overrides via `--db`.
- [x] **Build-Integration:** Vollständige Synchronisation zwischen Lazarus-IDE und VS Code Build-Tasks.
- [x] **Logging-System:** Global steuerbares Logging mit Debug-Tabelle und Trace-Ausgaben.
- [x] **Demo-DB:** Separater Seed-Workflow via `--seed` und Nutzung via `--demo`.
- [x] **Tabellen-Renderer:** Leichtgewichtige Tabellen-Ausgabe via `TTable` (Stats).
- [x] **Release-Logging:** Archiv + SHA-256 in `.releases/release_log.json` via `scripts/kpr.sh` (Root-Wrapper: `kpr.sh`).
- [x] **Backup-Index:** Zeitgestempelte Snapshots in `.backup/YYYY-MM-DD_HHMM` plus Register `.backup/index.json` via `scripts/backup_snapshot.sh`.
- [x] **Recovery-Doku:** Wiederherstellungsablauf dokumentiert in `docs/RESTORE.md`.
- [x] **Lokale Smoke-Checks:** Schnelle Plausibilitaetstests unter `tests/smoke_cli.sh`.
- [x] **Sauberer Final-Smoke:** Wrapper fuer isolierte HOME/XDG-Laeufe unter `tests/smoke_clean_home.sh`.

### Daten & Logik
- [x] **DB-Bootstrap:** Idempotente Initialisierung des SQLite-Schemas inkl. Metadaten-Tracking.
- [x] **Stations-CRUD:** Vollständige Verwaltung von Tankstellen (Anlegen, Auflisten, Bearbeiten, Löschen).
- [x] **Fixed-Point Engine:** Präzises Parsing von Währungen/Volumina via `u_db_common` ohne Fließkomma-Fehler.
- [x] **CSV-Helper (strict):** `u_fmt` stellt strikte CSV-Token/Zeilen ohne Escaping bereit (CSV-Output fuer Stats vorhanden, kein breiter Export).
- [x] **Interaktive UX:** Benutzerführung mit Sicherheitsabfragen und Validierung von Pflichtfeldern.
- [x] **Fuelups:** `u_fuelups.pas` implementiert (Add/List inkl. Detail-Ansicht, JOIN auf `stations`).
- [x] **Stats:** `--stats fuelups` mit Volltank-Zyklus-Auswertung inkl. Kosten.
- [x] **Schema v4:** Tabelle `fuelups` mit Foreign Keys auf `stations` und `cars` plus `missed_previous`.
- [x] **Cars-Datenmodell:** `cars` fuehrt Start-KM/Start-Datum (`odometer_start_km`, `odometer_start_date`) als Domain-Startpunkt.
- [x] **Car-sichere Stats:** Zyklusbildung trennt Daten strikt pro `car_id`.
- [x] **Golden-Info-Reset:** `missed_previous` unterbricht bewusst laufende Zyklen in der Auswertung.

---

## Roadmap & Evolution

### Version 0.3.0 – Fuelups (Kernfeature) — abgeschlossen
*Ziel: Erfassung und Speicherung von Tankereignissen.*
- [x] Schema v3 mit Tabelle `fuelups` und Foreign Key auf `stations`.
- [x] Unit `u_fuelups.pas` implementiert.
- [x] Commands `--add fuelup` und `--list fuelups` (inkl. `--detail`).

### Version 0.4.0 – Demo-DB & Seed — abgeschlossen
*Ziel: Reproduzierbare Demo-Daten fuer Tests und Vorfuehrungen.*
- [x] Seed-Workflow fuer Demo-DB (`--seed`) inkl. Force/SeedValue.
- [x] Demo-DB-Nutzung fuer einen Lauf (`--demo`).
- [x] Erweiterte CLI-Hilfe inkl. Beispiele und Hinweise.

### Version 0.4.1 – Stats & Logging — abgeschlossen
*Ziel: Auswertungen und klarere Diagnoseausgaben.*
- [x] `--stats fuelups` (Volltank-Zyklen, Strecke, Verbrauch, Zeitraum).
- [x] Logging-Policy: `Msg` fuer informative Ausgaben, `Dbg` fuer Trace.
- [x] `--trace` als separates Diagnose-Flag.

### Version 0.4.2 – JSON-Stats — abgeschlossen
*Ziel: Maschinenlesbare Stats-Ausgabe.*
- [x] `--stats fuelups --json` (JSON-Output der Zyklusdaten).
- [x] CLI-Validierung: `--json` nur mit `--stats fuelups`.

### Version 0.5.0 – Komfort & Auswertung — abgeschlossen
*Ziel: Daten nutzbar machen.*
- [x] Filter & Zeitraeume fuer `--stats fuelups`: `--from`/`--to` (YYYY-MM-DD; optional YYYY-MM).
- [x] Filter wirken auf Kopfwerte (Zeitraum, Counts) und Zyklusbildung (nur Fuelups im Zeitraum).
- [x] Keine Datenmanipulation: nur `SELECT` + Berechnung.
- [x] Periodische Auswertungen: Monats-Summary (km, liters_ml, avg, total_cents).
- [x] Output: Tabelle (Text) und JSON mit `kind: "fuelups_monthly"`.
- [x] CSV-Output fuer Stats (strict, CLI + API).
- [x] Konsolen-Dashboards fuer die Auswertung (kompakt, scanbar, ohne CLI-Umbau).
- [x] Export-Story fuer Stats festgelegt: JSON bleibt Source of Truth; CSV ist auf Stats fokussiert.
- [x] Jahres-Summary bewusst verschoben und nicht rueckwirkend 0.5.3 zugeordnet (siehe 0.5.5).
- [x] Umsetzungsschritte: 1) `--from`/`--to` Parser + Validierung. 2) Stats-Query mit `WHERE fueled_at BETWEEN ...`. 3) Zyklusgrenzen im Zeitraum. 4) Monatsaggregation. 5) JSON-Schema erweitern (neue kinds, `period` bleibt).
- [x] Nicht-Ziele 0.5.0 eingehalten: keine Station-Filter, keine Multi-Car-Logik, kein Import/Sync/Editor, kein CLI-Umbau (keine neuen Subcommands).

### Version 0.5.2 – Dashboard & Unicode-Box-Engine — abgeschlossen
*Ziel: Kompakte, scanbare Stats-Ansicht ohne CLI-Umbau.*
- [x] Dashboard-Renderer via `--stats fuelups --dashboard` im CLI verfuegbar.
- [x] Unicode-Box-Engine in `u_fmt` fuer kompakte Status-/Dashboard-Ausgaben.
- [x] UTF-8-sichere Breitenberechnung fuer stabiles Layout bei Mehrbyte-Zeichen.
- [x] Dynamische Farblogik fuer Kostenbalken (relativ/statisch).
- [x] Exklusive Flag-Validierung (`--dashboard` vs `--json`/`--csv`).

### Version 0.5.3 – Reifegrad & Vervollstaendigung
*Ziel: Stabilisieren, strukturieren, vorbereiten.*
- [x] Scope-Entscheidung: kein massiver Feature-Zuwachs, Fokus auf interne Klarheit und Vollstaendigkeit.
- [x] Jahres-Summary in 0.5.3 explizit nicht umgesetzt; Monatsaggregation bleibt Basis.
- [x] Entscheidung: Jahres-Summary nicht rueckwirkend 0.5.3 zuordnen, sondern auf 0.5.5 verschieben.
- [x] Interne Strukturierung `u_stats`: Collector -> `TStatsCollected`, Renderer (`RenderFuelupStatsText`, `RenderFuelupStatsJson`, `RenderFuelupStatsCsv`) als klare Output-Schicht.

### Post-0.5.3 – Quality/Docs Backlog (verschoben, nicht Teil von 0.5.3)
- [ ] Export/CSV-Contract dokumentieren (Entities, Header-Versionierung, Escape-Regeln, JSON als Source of Truth).
- [x] CLI-Usage-Konsistenz-Audit / Help-Rework in 0.5.6 abgeschlossen.

### Version 0.5.4 – First-Run UX & Initialisierung — abgeschlossen
*Ziel: "Run it - it just works." ohne Konfigurationswissen.*
- [x] Bei fehlender Config/DB automatisch Default-Pfad nutzen: `~/.local/share/Betankungen/betankungen.db`.
- [x] Verzeichnis bei Bedarf automatisch anlegen, DB + Schema automatisch provisionieren.
- [x] Einmalige Erststart-Meldung mit klaren Pfaden und `--help`-Hinweis ausgeben.
- [x] Interaktiver Prompt nur als Fallback bei nicht nutzbarem DB-Pfad.
- [x] Retry-Flow bei Fallback umgesetzt (erneute Pfadabfrage bis speicherbarer Pfad vorliegt).
- [x] No-Command-Bootstrap ohne Prompt fuer frische bzw. unvollstaendige lokale Umgebung (`config.ini` fehlt oder DB fehlt).

### Version 0.5.5 – Jahres-Summary (Zeitachsen-Vervollstaendigung) — abgeschlossen
*Ziel: Monatsaggregation um Jahresaggregation ergaenzen.*
- [x] CLI: `Betankungen --stats fuelups --yearly`.
- [x] CLI: `Betankungen --stats fuelups --json --yearly`.
- [x] Reine Aggregation im Collector auf Basis bestehender Monatsdaten (keine neue SQL-Logik).
- [x] JSON-Kind fuer Jahresausgabe (`kind: "fuelups_yearly"`).
- [x] Validierung: `--yearly` nur mit `--stats fuelups`, exklusiv zu `--monthly`, kein Mix mit `--csv`/`--dashboard`.

### Version 0.5.6 – Help/Usage Rework — abgeschlossen
*Ziel: Konsistente CLI-Hilfe, Validierungstexte und Beispiele ohne neue Fachlogik.*
- [x] Usage-Texte und Hilfebeispiele vereinheitlichen.
- [x] Validierungsfehler sprachlich/strukturell harmonisieren.
- [x] Doku und CLI-Hilfe auf denselben Flag-/Kombi-Stand bringen.

### Version 0.5.6-0 – Zwischenversion Unit-Vorbereitung
*Ziel: Zwischenversion vor 0.6.0 fuer die Einfuehrung einer zusaetzlichen Unit.*
- [ ] Zusaetzliche Unit erstellen und sauber in den bestehenden CLI-Flow integrieren.
- [ ] Verantwortung/Abgrenzung der neuen Unit in Doku und Headern klarziehen.
- [ ] Keine verpflichtende neue Fachlogik; Fokus auf Struktur und Wartbarkeit.

### Version 0.6.0 – Fundament fuer Fahrzeug-Domain (danach)
*Ziel: stabile Struktur fuer spaeteres Multi-Car ohne sofortigen Feature-Ausbau.*
- [x] Projektstruktur fuer Wissensarchiv/Backups/Skripte/Tests ist etabliert (`knowledge_archive/`, `.backup/`, `scripts/`, `tests/`).
- [x] Technische Basis `cars` + `fuelups.car_id` + `missed_previous` ist im aktuellen Arbeitsstand vorhanden.
- [ ] Release-Zuordnung und fachliche Konsolidierung als 0.6.0-Rahmen dokumentieren (Hauptauto-Flow ohne Multi-Car-CLI-Ausbau).
- [ ] Migrations-/Domainregeln weiter konsolidieren (Immutability, Hard-Errors vs Warnings, Gap-Semantik fuer Stats).

### Langfristige Evolutionslinie
- [x] `0.5.3`: Reife, Struktur, Vorbereitung.
- [x] `0.5.5`: `--yearly` (Text/JSON) + Validation + Smoke.
- [x] `0.5.6`: Help/Usage Rework (kurzer Fehlerpfad + strukturierter `--help`).
- [ ] `0.5.6-0`: Zwischenversion fuer zusaetzliche Unit.
- [ ] `0.6.0`: Fahrzeug-Struktur konsolidieren (Hauptauto + FK als stabiles Fundament).
- [ ] `0.7.x`: echtes Multi-Car-Feature.
- [ ] `0.8.x` (optional): Export/Output Contracts (CSV/JSON Versionierung, Schema/Headers, Escape-Regeln).
- [ ] `1.0.0`: stabile Domain + Export + ausgereifte Stats.

Festgezurrte Detailentscheidungen (2026-02-09)
- Offene Grenzen bei Filtern sind datengetrieben: nur `--from` => `to = MAX(fueled_at)`, nur `--to` => `from = MIN(fueled_at)` (kein "heute").
- Zyklusregel am Rand: Zyklus zählt nur, wenn Start- und End-Volltank im Zeitraum liegen (vollständig im Zeitraum).
- JSON-avg: `avg_l_per_100km` als scaled Integer (z. B. `avg_l_per_100km_x100`), keine Strings.

### Langfristig (v1.0.0+)
- [ ] Daten-Interoperabilitaet: vollstaendiger CSV-Export fuer externe Analysen.
- [ ] Batch-Import: Migrationstools für Altdaten aus Drittsystemen.
- [ ] Vollstaendige CLI-Unterstuetzung fuer mehrere Fahrzeuge innerhalb einer Datenbank.

---

## Meta-Fazit
Das Projekt ist als robuste CLI-Anwendung konzipiert, mit klaren Schichten, stabiler Datenhaltung und konsistenter Benutzerfuehrung. Die Architektur ist modular und transaktionssicher, die Verantwortlichkeiten sind sauber getrennt, und die Basis ist bewusst so gehalten, dass kuenftige Auswertungen und Erweiterungen ohne strukturelle Brueche moeglich sind.
