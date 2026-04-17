# System-Architektur & Design-Dokumentation
**Stand:** 2026-04-17

Dieses Dokument beschreibt die zentralen Designentscheidungen, die Architekturprinzipien und die langfristige Roadmap des Projekts **"Betankungen"**.

---

## Zentrale Designentscheidungen (ADR)

Formalisierte Entscheidungsprotokolle liegen unter `docs/ADR/` (Index: `docs/ADR/README.md`).
Die folgenden Punkte sind die dauerhaften Architekturleitlinien auf hoher Ebene.

*   **Immutable IDs:** Primärschlüssel (IDs) werden niemals neu vergeben. Einmal vergebene IDs bleiben permanent mit ihrem Datensatz verknüpft, um die Referenzintegrität (z. B. in Backups oder Log-Files) zu garantieren.
*   **Single-Table Source of Truth:** Bevorzugung einer klaren Tabellenstruktur gegenüber künstlicher Über-Normalisierung, um die Abfrage-Logik (SQL) simpel und performant zu halten.
*   **Command-Exclusivity:** Das CLI-Interface folgt einem strikten Dispatcher-Modell. Pro Aufruf wird genau eine Hauptaktion (Add, List, Edit, Delete, Seed oder Stats) ausgeführt, was Fehlbedienungen verhindert.
*   **Separation of Concerns (SoC):** Strikte Trennung zwischen Geschäftslogik (`Business Logic`) und Anzeige/Eingabe (`UI`). Die Fach-Units (z. B. `u_stations`) enthalten keine CLI-Parsing-Logik.
*   **CLI-Pipeline (Parse -> Validate -> Dispatch):** Parsing bleibt auf Syntax/Normalisierung begrenzt (`u_cli_parse`), Policy-Validierung liegt zentral in `u_cli_validate`, und fachliche Ausfuehrung erfolgt erst im Orchestrator-Dispatch.
*   **Car Context Layer:** `ResolveCarIdOrFail` ist die zentrale Instanz fuer die Car-Aufloesung. Das Regelwerk (0/1/>1 Cars, unknown/invalid `--car-id`) ist einmalig implementiert und wird in car-sensitiven Flows konsistent wiederverwendet.
*   **Module Contract:** Das verbindliche technische Integrationsmodell fuer Companion-Module (Build, CLI, DB, Stats) ist in `docs/MODULES_ARCHITECTURE.md` dokumentiert und wird bei neuen Modulen als Gate verwendet.
*   **Transaktions-Sicherheit:** Jede Datenbank-Mutation (Schreiben, Ändern, Löschen) wird als atomare Einheit behandelt. Schlägt ein Teil fehl, erfolgt ein vollständiger Rollback (All-or-Nothing).
*   **Defensive Parsing:** "Garbage in, Garbage out" wird an der Systemgrenze verhindert. Eingaben werden über skalierte Integer-Funktionen (Fixed-Point) validiert, bevor sie die Fachlogik erreichen.

---

## I18n Policy (Sprint 4)

### Ziel und Reihenfolge

Fuer Sprint 4 gilt bewusst: zuerst Doku und Policy, danach technisches Wiring.
Es wird kein i18n-Skeleton verdrahtet, bevor die Regelbasis dokumentiert und abgestimmt ist.

### Warum i18n jetzt kommt

Die Anwendung hat eine stabile Fachbasis und klare Policy-Contracts erreicht.
Der naechste Schritt ist eine kontrollierte Internationalisierung der User-Texte, ohne bestehende Guards oder Output-Contracts zu destabilisieren.
i18n wird als Architekturthema behandelt, nicht als reines Text-Refactoring.

### Warum `language=de|en|pl`

Die Sprachwahl ist in Sprint 4 bewusst explizit und begrenzt: `de`, `en`, `pl`.
Diese kleine, feste Menge reduziert Komplexitaet, erlaubt klare Testbarkeit und verhindert implizite Locale-Guessing-Logik.
Andere Sprachen sind kein Sprint-4-Ziel und werden spaeter ueber denselben Mechanismus erweiterbar gehalten.

### Architekturrolle von `u_i18n.pas`, `TMsgId`, `Tr()`

`u_i18n.pas` ist die zentrale i18n-Unit fuer Sprachkontext und Textauflosung.
`TMsgId` ist der stabile interne Contract fuer Message-Keys (statt freier String-Literale im Code).
`Tr()` ist der einzige erlaubte Zugriffspfad fuer translatierbare Runtime-Texte.

Regel:
- User-facing Runtime-Text wird ueber `TMsgId` + `Tr()` erzeugt.
- Direkte, frei formulierte Runtime-Strings in Domain-/Orchestrator-Code werden fuer migrierte Bereiche vermieden.

### Test-Policy: keine Kopplung an uebersetzte Runtime-Texte

Tests duerfen nicht auf vollstaendige, lokalisierte Saetze gematcht werden.
Stattdessen nutzen Tests stabile Signale:
- Exit-Code
- Policy-ID (z. B. `P-041`)
- DB-State / No-Write-Guard
- Contract-Felder und Struktur (JSON/CSV)

Runtime-Text darf sprachlich evolvieren, solange Semantik und Guardrails stabil bleiben.

### Scope Sprint 4: was migriert wird

- User-facing Fehler-/Hinweis-/Prompt-Texte in zentralen CLI-Pfaden
- Resolver-Hinweise fuer Car-Kontext
- Validierungs- und Confirm-Texte in interaktiven Flows
- Help-/Usage-Texte, soweit sie direkte Nutzerfuehrung sind

### Scope Sprint 4: was nicht migriert wird

- JSON-/CSV-Contract-Felder, Header, Keys, `kind`-Werte
- CLI-Flags, Commands und technische Tokens
- Policy-IDs (`P-xxx`) als Engineering-Contract
- Reine Debug-/Trace-Metaausgaben
- Testskript-interne Ausgaben

## Aktueller Funktionsumfang (Stand 2026-02-28)
Siehe `CHANGELOG.md`, Version `0.6.0` plus `[Unreleased]` (0.7.x-Workstream).

### Infrastruktur & Tooling
- [x] **XDG-Konformität:** Trennung von Daten (`~/.local/share/`) und Konfiguration (`~/.config/`).
- [x] **Zentrales DB-Handling:** Unterstützung für Default-Pfade, persistente INI-Konfiguration und CLI-Overrides via `--db`.
- [x] **Migration Source-of-Truth:** Aktive Schema-Migrationen laufen runtime-idempotent in `units/u_db_init.pas`; `migrations/` ist ein historisches SQL-Archiv (aktuell `v3_to_v4.sql`).
- [x] **I18n-Skeleton (Sprint 4):** Sprachkontext `language=de|en|pl` ist im Config-Flow verankert; zentrale i18n-Unit `u_i18n` stellt `TMsgId` und `Tr()` als Einstiegspunkt bereit (ohne breite Textmigration).
- [x] **I18n Runtime Mini-Rollout (S4C3/3):** Erste risikoarme Meta-/Konfigurationsmeldungen laufen ueber `Tr()` (u. a. Config-Status, First-Run-Hinweise, generische Systemmeldung), ohne breite Help-/Fehlertext-Migration.
- [x] **Build-Truth:** `make build`, CI und Editor-Frontends fuehren denselben FPC-CLI-Build fuer `src/Betankungen.lpr` aus.
- [x] **FPC-/CLI-Purity:** Der aktive Source-, Build- und Testpfad ist ohne Lazarus-/LCL-Abhaengigkeit; historische Erwaehnungen bleiben auf explizite Legacy-Kontexte begrenzt.
- [x] **Logging-System:** Global steuerbares Logging mit Debug-Tabelle und Trace-Ausgaben.
- [x] **Demo-DB:** Separater Seed-Workflow via `--seed` und Nutzung via `--demo`.
- [x] **Tabellen-Renderer:** Leichtgewichtige Tabellen-Ausgabe via `TTable` (Stats).
- [x] **Release-Logging:** Archiv + SHA-256 in `.releases/release_log.json` via `scripts/kpr.sh` (Root-Wrapper: `kpr.sh`).
- [x] **Backup-Index:** Zeitgestempelte Snapshots in `.backup/YYYY-MM-DD_HHMM` plus Register `.backup/index.json` via `scripts/backup_snapshot.sh`.
- [x] **Recovery-Doku:** Wiederherstellungsablauf dokumentiert in `docs/RESTORE.md`.
- [x] **Lokale Smoke-Checks:** Schnelle Plausibilitaetstests unter `tests/smoke/smoke_cli.sh` (kompatibel via `tests/smoke_cli.sh`).
- [x] **Sauberer Final-Smoke:** Wrapper fuer isolierte HOME/XDG-Laeufe unter `tests/smoke/smoke_clean_home.sh` (kompatibel via `tests/smoke_clean_home.sh`).

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
- [x] **Cars-Schema v5 (Vorbereitung):** `cars` enthaelt optionale VIN-/Dokument-Metadaten (`vin`, `reg_doc_path`, `reg_doc_sha256`); aktuell rein strukturell, noch ohne CLI-Wiring/Validierung und ohne aktive Runtime-Nutzung.
- [x] **VIN-Policy/UX-Prep dokumentiert:** VIN ist empfohlen, aber optional (kein Primaerschluessel-Ersatz); Registrierungsdokumente bleiben Referenzen via `reg_doc_path`/`reg_doc_sha256` (siehe `docs/VIN_POLICY_UX_PREP.md`).
- [x] **Car Context Resolver:** Zentraler Resolver `ResolveCarIdOrFail` als Single Source of Truth fuer Car-Auswahl (0/1/>1 Cars, unknown/invalid `car_id`).
- [x] **Kein implizites Default `car_id=1` mehr:** Car-ID wird nicht geraten; bei mehreren Fahrzeugen ist `--car-id` verpflichtend.
- [x] **Strict Car Scoping:** `--add fuelups`, `--list fuelups` und `--stats fuelups` laufen strikt car-gescoped (`WHERE car_id = :car_id`).
- [x] **0-Cars Architektur-Guard (Smoke):** Der 0-Cars-Pfad wird in der Smoke-Suite explizit erzwungen (Test-Trigger + leere `cars`) und prueft konsistente Resolver-Hard-Errors fuer 0/1/>1 Cars; bei Schema-/Migrationsaenderungen ist dieser Guard verpflichtend mitzudenken.
- [x] **Car-sichere Stats:** Zyklusbildung trennt Daten strikt pro `car_id`.
- [x] **Golden-Info-Reset:** `missed_previous` unterbricht bewusst laufende Zyklen in der Auswertung.
- [x] **Domain-Policy-Matrix v1:** Abgedeckte Policy-Bloecke `P-001..P-002`, `P-010..P-013`, `P-020..P-022`, `P-030..P-032`, `P-040..P-041`, `P-050..P-051`, `P-060` (inkl. Car-Isolation-Guardrail `P-060/02`) und `P-070` (Cars-Delete-Guard bei Referenzen).

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

### Version 0.5.6-0 – Zwischenversion Unit-Vorbereitung — abgeschlossen
*Ziel: Zwischenversion vor 0.6.0 fuer die Einfuehrung einer zusaetzlichen Unit.*
- [x] Zusaetzliche Unit erstellt und sauber in den bestehenden CLI-Flow integriert (`u_cli_validate`).
- [x] Verantwortung/Abgrenzung der neuen Unit in Doku und Headern klargezogen.
- [x] Keine neue Fachlogik eingefuehrt; Fokus auf Struktur und Wartbarkeit eingehalten.
- [x] Parse/Validate/Dispatch-Pipeline explizit verankert und durch Domain-Policy-Cases (`tests/domain_policy/cases/t_p000__01__cli_validate_core.pas`) abgesichert.

### Version 0.6.0 – Fundament fuer Fahrzeug-Domain — abgeschlossen
*Ziel: stabile Struktur fuer spaeteres Multi-Car ohne sofortigen Feature-Ausbau.*
- [x] Projektstruktur fuer Legacy-Wissensarchiv/Backups/Skripte/Tests ist etabliert (`knowledge_archive/` bleibt read-only im Repo; Git-Historie ist der primaere Rueckgriff fuer fruehere Implementationsstaende).
- [x] Technische Basis `cars` + `fuelups.car_id` + `missed_previous` ist im aktuellen Arbeitsstand vorhanden.
- [x] Domain-Policy-Matrix v1 als Regression-Fundament aufgebaut (inkl. Gap-/Date-/Cost-/Price-/Stats-Guards).
- [x] Release-Zuordnung und fachliche Konsolidierung als 0.6.0-Rahmen dokumentiert (Hauptauto-Flow ohne Multi-Car-CLI-Ausbau).
- [x] Migrations-/Domainregeln weiter konsolidiert (Immutability, Hard-Errors vs Warnings, Gap-Semantik fuer Stats).
- [x] Anschluss in 0.7.x umgesetzt: Multi-Car-CLI mit Resolver und strict car scope.

### Langfristige Evolutionslinie
- [x] `0.5.3`: Reife, Struktur, Vorbereitung.
- [x] `0.5.5`: `--yearly` (Text/JSON) + Validation + Smoke.
- [x] `0.5.6`: Help/Usage Rework (kurzer Fehlerpfad + strukturierter `--help`).
- [x] `0.5.6-0`: Zwischenversion fuer zusaetzliche Unit (Parse/Validate-Entkopplung + Tests).
- [x] `0.6.0`: Fahrzeug-Struktur konsolidiert (Hauptauto + FK als stabiles Fundament).
- [x] `0.7.x`: Multi-Car-CLI (Cars-CRUD + Car-Resolver + strict scoping fuer fuelups/list/stats, keine impliziten Defaults).
- [x] `0.8.x` (abgeschlossen als `0.8.0`): Export/Output Contracts (CSV/JSON Versionierung, Schema/Headers, Escape-Regeln).
- [ ] `0.9.x`: naechste priorisierte Entwicklungsphase nach Scope-Freeze.
- [ ] `1.0.0`: stabile Domain + Export + ausgereifte Stats.

Festgezurrte Detailentscheidungen (2026-02-09)
- Offene Grenzen bei Filtern sind datengetrieben: nur `--from` => `to = MAX(fueled_at)`, nur `--to` => `from = MIN(fueled_at)` (kein "heute").
- Zyklusregel am Rand: Zyklus zählt nur, wenn Start- und End-Volltank im Zeitraum liegen (vollständig im Zeitraum).
- JSON-avg: `avg_l_per_100km` als scaled Integer (z. B. `avg_l_per_100km_x100`), keine Strings.

### Langfristig (v1.0.0+)
- [ ] Daten-Interoperabilitaet: vollstaendiger CSV-Export fuer externe Analysen.
- [ ] Batch-Import: Migrationstools für Altdaten aus Drittsystemen.
- [x] Vollstaendige CLI-Unterstuetzung fuer mehrere Fahrzeuge innerhalb einer Datenbank (strict car scope, `--car-id` Pflicht bei >1 Cars).
- [ ] Cross-Car/Fleet-Analytics als optionaler zusaetzlicher Report-Layer (ohne Aufweichen des strict car scope in bestehenden Commands).

---

## Meta-Fazit
Das Projekt ist als robuste CLI-Anwendung konzipiert, mit klaren Schichten, stabiler Datenhaltung und konsistenter Benutzerfuehrung. Die Architektur ist modular und transaktionssicher, die Verantwortlichkeiten sind sauber getrennt, und die Basis ist bewusst so gehalten, dass kuenftige Auswertungen und Erweiterungen ohne strukturelle Brueche moeglich sind.
