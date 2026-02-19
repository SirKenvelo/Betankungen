# Projekt-Kontext

_Erstellt am: 2026-02-19 19:40:33 CET_

## Repository
- Root: `/home/christof/Projekte/Betankungen`
- Branch: `main`
- Commit: `3c8b959`

## Verzeichnisstruktur (Git-tracked / GitHub-Sicht)
```text
.editorconfig
.gitignore
AGENTS.md
docs/ARCHITECTURE.md
docs/BENUTZERHANDBUCH.md
docs/CHANGELOG.md
docs/CONSTRAINTS.md
docs/DESIGN_PRINCIPLES.md
docs/README.md
docs/RESTORE.md
docs/STATUS.md
knowledge_archive/README.md
knowledge_archive/archive_ExactlyOne.pas
knowledge_archive/archive_ParseEurPerLiterToMilli.pas
knowledge_archive/archive_ParseEuroToCents.pas
knowledge_archive/archive_ParseFlagWithArg.pas
knowledge_archive/archive_ParseLitersToMl.pas
knowledge_archive/archive_ParseRequiredValueFlag.pas
knowledge_archive/archive_ParseToMinorUnit.pas
knowledge_archive/archive_TryParseFlag.pas
kpr.sh
migrations/v3_to_v4.sql
scripts/backup_snapshot.sh
scripts/kpr.sh
scripts/net_recover.sh
src/Betankungen.lpr
tests/README.md
tests/smoke_clean_home.sh
tests/smoke_cli.sh
units/u_cli_help.pas
units/u_cli_parse.pas
units/u_cli_types.pas
units/u_db_common.pas
units/u_db_init.pas
units/u_db_seed.pas
units/u_fmt.pas
units/u_fuelups.pas
units/u_log.pas
units/u_stations.pas
units/u_stats.pas
units/u_table.pas
```

## Git-Status (short)
```text
 M docs/CHANGELOG.md
 M docs/README.md
?? .vscode/
?? scripts/projekt_kontext.sh
```

## Datei: `AGENTS.md`

````markdown
# AGENTS
**Stand:** 2026-02-14

<INSTRUCTIONS>

## Allgemeine Kommunikation
- Kommunikation immer auf Deutsch.
- Bei der ersten Änderung an einer Datei pro Task: Datum im Header/Metadaten auf das aktuelle Datum setzen.
- Wenn Dateien geändert werden: vorhandene Header/Metadaten an die neue Funktionalität anpassen, falls diese nicht mehr korrekt sind.

## Build-Standard
- FPC-Compile immer mit folgendem Befehl aus dem Projektroot ausfuehren:
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`

## Dokumentations-Management
- Dokumentation im `docs`-Ordner bei Hoch/Mittel-Priorität selbstständig mitpflegen.
- `docs/CHANGELOG.md` bei JEDER Änderung aktualisieren (inkl. aktuellem Datum).
- CHANGELOG-Einträge im bestehenden Stil der Datei pflegen (gleiches Format/Abschnitt wie bisherige Codex-Einträge).
- CHANGELOG-Kennzeichnung: Änderungen von Usern unter „Changed (User-Edits)“, Änderungen von Codex unter „Changed (Codex)“.
- CHANGELOG-Ort: Einträge immer unter `[Unreleased]` und in den bestehenden Unterabschnitten erfassen.
- Beispiel (Format, `[Unreleased] -> Changed (Codex)`): `- u_fmt: CSV-Helper ergaenzt. (YYYY-MM-DD)`
- Beispiel (Format, `[Unreleased] -> Changed (User-Edits)`): `- README: Abschnitt zu u_stats aktualisiert. (YYYY-MM-DD)`

## Priorisierung von Änderungen & Dokumentations-Pflicht
Nach Änderungen muss die KI die Relevanz für die Dokumentation (insb. im `docs`-Ordner) wie folgt bewerten:

1. **HOHE PRIORITÄT (Update zwingend erforderlich):**
   - Neue Features, Subcommands oder öffentliche API/Units.
   - Änderungen am Datenmodell oder Schema.
   - Anpassung von Ausgabeformaten (Text, JSON, CSV) oder CLI-Flags/Verhalten.
   - Refactors, die eine Funktionsänderung oder neue Logik beinhalten.
   - *Aktion:* Dokumentation sofort und eigenständig aktualisieren.

2. **MITTLERE PRIORITÄT (Update-Prüfung erforderlich):**
   - Optimierung bestehender Funktionen oder signifikante interne Logikänderungen.
   - Neue Fehlermeldungen oder geändertes Validierungsverhalten.
   - *Aktion:* Dokumentation prüfen und proaktiv vorschlagen ("Soll ich die Doku für X anpassen?").

3. **KEINE PRIORITÄT (Kein Update nötig):**
   - Korrektur von Tippfehlern, reine Code-Formatierung (Linting).
   - Refactors ohne jegliche Änderung der externen Funktionsweise.

## Checkliste für Dokumentations-Konsistenz
Bevor ein Task mit **Hoher** oder **Mittlerer** Priorität abgeschlossen wird, muss die KI folgende Punkte in den betroffenen Dokumenten validieren:
- [ ] **Vollständigkeit:** Sind alle neuen Parameter, Flags oder Funktionen beschrieben?
- [ ] **Beispiele:** Sind Code-Beispiele und Beispiel-Outputs (JSON/CSV) noch aktuell?
- [ ] **Referenzen:** Passen alle internen Verweise und Links noch zum neuen Stand?
- [ ] **Sprache:** Bleiben Terminologie und Tonfall konsistent zum Rest der Dokumentation?
</INSTRUCTIONS>

````

## Datei: `docs/ARCHITECTURE.md`

````markdown
# System-Architektur & Design-Dokumentation
**Stand:** 2026-02-19

Dieses Dokument beschreibt die zentralen Designentscheidungen, die Architekturprinzipien und die langfristige Roadmap des Projekts **"Betankungen"**.

---

## Zentrale Designentscheidungen (ADR)

*   **Immutable IDs:** Primärschlüssel (IDs) werden niemals neu vergeben. Einmal vergebene IDs bleiben permanent mit ihrem Datensatz verknüpft, um die Referenzintegrität (z. B. in Backups oder Log-Files) zu garantieren.
*   **Single-Table Source of Truth:** Bevorzugung einer klaren Tabellenstruktur gegenüber künstlicher Über-Normalisierung, um die Abfrage-Logik (SQL) simpel und performant zu halten.
*   **Command-Exclusivity:** Das CLI-Interface folgt einem strikten Dispatcher-Modell. Pro Aufruf wird genau eine Hauptaktion (Add, List, Edit, Delete, Seed oder Stats) ausgeführt, was Fehlbedienungen verhindert.
*   **Separation of Concerns (SoC):** Strikte Trennung zwischen Geschäftslogik (`Business Logic`) und Anzeige/Eingabe (`UI`). Die Fach-Units (z. B. `u_stations`) enthalten keine CLI-Parsing-Logik.
*   **Transaktions-Sicherheit:** Jede Datenbank-Mutation (Schreiben, Ändern, Löschen) wird als atomare Einheit behandelt. Schlägt ein Teil fehl, erfolgt ein vollständiger Rollback (All-or-Nothing).
*   **Defensive Parsing:** "Garbage in, Garbage out" wird an der Systemgrenze verhindert. Eingaben werden über skalierte Integer-Funktionen (Fixed-Point) validiert, bevor sie die Fachlogik erreichen.

---

## Aktueller Funktionsumfang (Stand 2026-02-19)
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

````

## Datei: `docs/BENUTZERHANDBUCH.md`

````markdown
# Benutzerhandbuch Betankungen
**Stand:** 2026-02-17

CLI-Anwendung zum Erfassen und Auswerten von Tankvorgaengen (SQLite, lokal).

---

**Kurzueberblick**
- Erfassen von Tankstellen und Betankungen (interaktiv).
- Listen mit Standard- und Detailansicht.
- Volltank-Zyklus-Statistiken (Text und JSON).
- XDG-konforme Speicherung von Konfiguration und Datenbank.

**Start und Hilfe**
- Hilfe: `Betankungen --help`
- Version: `Betankungen --version`
- About inkl. Danksagung: `Betankungen --about`

**Datenbank und Konfiguration**
- Standard-DB: `~/.local/share/Betankungen/betankungen.db`
- Demo-DB: `~/.local/share/Betankungen/betankungen_demo.db`
- Config-Datei: `~/.config/Betankungen/config.ini`
- Erststart ohne vorhandene Config: Standard-DB wird automatisch genutzt und in der Config gespeichert.
- Frischer Start ohne Argumente: Config + DB werden still angelegt, kein Fehler "Kein Kommando".
- Config vorhanden, DB fehlt: Die DB wird automatisch am konfigurierten Pfad neu angelegt (ohne Prompt).
- Prompt nur als Fallback: Eine interaktive DB-Pfadabfrage erscheint nur, wenn die DB-Provisionierung fehlschlaegt.
- Pfad dauerhaft setzen: `Betankungen --db-set /pfad/zur/db.sqlite`
- Pfad nur fuer diesen Lauf: `Betankungen --db /pfad/zur/db.sqlite <command>`
- Config anzeigen: `Betankungen --show-config`
- Config loeschen: `Betankungen --reset-config`

**Demo-Datenbank**
- Demo-DB erstellen/aktualisieren:  
  `Betankungen --seed [--stations N] [--fuelups N] [--seed-value N] [--force]`
- Demo-DB fuer einen Lauf nutzen:  
  `Betankungen --demo <command>`
- Seed-Datensatz: Fuelups werden im Bereich 300-500 erzeugt (bei Werten ausserhalb dieses Bereichs wird intern in den Zielbereich normalisiert) und ueber 3-5 Jahre verteilt.
- Hinweis: `--seed` ist exklusiv und darf nicht mit `--db`, `--db-set` oder anderen Kommandos kombiniert werden.

**Tankstellen verwalten**
Kommandos:
- `Betankungen --add stations`
- `Betankungen --list stations`
- `Betankungen --list stations --detail`
- `Betankungen --edit stations`
- `Betankungen --delete stations`

Eingabe bei `--add stations`:
- Pflichtfelder: Brand, Street, HouseNo, Plz, City
- Optional: Phone, Owner

**Betankungen erfassen**
Kommandos:
- `Betankungen --add fuelups`
- `Betankungen --list fuelups`
- `Betankungen --list fuelups --detail`

Eingabe bei `--add fuelups`:
- Fahrzeugauswahl (`cars`) - bei genau einem Fahrzeug automatische Auswahl
- Auswahl der Tankstelle (Liste mit IDs)
- Datum+Uhrzeit: `YYYY-MM-DD HH:MM:SS`
- Kilometerstand (km)
- Odometer-Checks pro Fahrzeug:
  - muss >= Fahrzeug-Start-KM sein
  - muss strikt groesser als der letzte Odometer des Fahrzeugs sein
- Bei grosser Distanzluecke (> 1500 km) wird gezielt nach "fehlender vorheriger Betankung" gefragt (`missed_previous`)
- Gesamtpreis (EUR, z.B. `50,01`)
- Getankte Menge (Liter, z.B. `28,76`)
- Preis pro Liter (EUR/L, z.B. `1,739`)
- Vollgetankt? (y/n)
- Bei sehr grosser Tankmenge (> 150 L) kommt eine Warnung mit Bestaetigungsabfrage
- Optional: Spritart, Bezahlart, Zapfsaeule, Notiz

**Statistiken: Volltank-Zyklen, Monate und Jahre**
- Textausgabe: `Betankungen --stats fuelups`
- Dashboard-Ausgabe (exklusiv): `Betankungen --stats fuelups --dashboard` (kein Mix mit `--json`/`--csv`)
- JSON-Ausgabe (kompakt): `Betankungen --stats fuelups --json`
- JSON-Ausgabe (pretty): `Betankungen --stats fuelups --json --pretty` (nur mit `--json`)
- CSV-Ausgabe (exklusiv): `Betankungen --stats fuelups --csv` (mit `--monthly` moeglich, kein Mix mit `--json`)
- Monatsausgabe (Text, Monats-Tabelle): `Betankungen --stats fuelups --monthly`
- Monatsausgabe (JSON): `Betankungen --stats fuelups --json --monthly`
- Jahresausgabe (Text): `Betankungen --stats fuelups --yearly` (Jahrestabelle mit km/Liter/Ø L/100/km/Kosten)
- Jahresausgabe (JSON): `Betankungen --stats fuelups --json --yearly` (`kind: "fuelups_yearly"`, Felder analog zu monthly)
- Zeitraum-Filter:  
  `Betankungen --stats fuelups --from YYYY-MM[-DD] --to YYYY-MM[-DD]`
- Regeln: `--from` ist inklusiv, `--to` ist exklusiv. Zyklen zaehlen nur, wenn Start- und End-Volltank im Zeitraum liegen. Bei nur `--from` oder nur `--to` werden die fehlenden Grenzen datengetrieben gesetzt.
- Bei mehreren Fahrzeugen werden Zyklen intern strikt pro `car_id` gebildet.
- Falls `missed_previous=1` gesetzt wurde, wird der laufende Zyklus bewusst resettet.
- Yearly-Regeln: `--yearly` und `--monthly` sind exklusiv; `--yearly` ist nicht mit `--csv` oder `--dashboard` kombinierbar.

**Schnellbeispiele (Dashboard)**
- `Betankungen --stats fuelups --dashboard`
- `Betankungen --stats fuelups --dashboard --from 2025-01 --to 2025-03`
- `Betankungen --stats fuelups --dashboard --monthly`

**Schnellbeispiele (Yearly)**
- `Betankungen --stats fuelups --yearly`
- `Betankungen --stats fuelups --json --pretty --yearly`

**Diagnose und Ausgabe**
- Debug-Tabelle: `--debug`
- Trace-Logs: `--trace`
- Ruhiger Modus (unterdrueckt normale Ausgaben): `--quiet`

**Typischer Ablauf**
1. `Betankungen --db-set /pfad/zur/db.sqlite` (optional, wenn Standardpfad nicht gewuenscht)
2. `Betankungen --add stations`
3. `Betankungen --add fuelups`
4. `Betankungen --list fuelups --detail`
5. `Betankungen --stats fuelups --from 2025-01 --to 2025-03`

````

## Datei: `docs/CHANGELOG.md`

````markdown
# CHANGELOG
**Stand:** 2026-02-19

Alle wichtigen Änderungen an diesem Projekt werden hier dokumentiert.

## [Unreleased]
### Zielversion
0.5.6-0
Ziel: Zwischenversion fuer die Vorbereitung einer zusaetzlichen Unit.

### Changed (User-Edits)
- Keine Eintraege.

### Changed (Codex)
- Meta: `scripts/projekt_kontext.sh` um Snapshot des Arbeitsstands erweitert (`git status --short` als eigener Abschnitt im Export); Doku in `docs/README.md` nachgezogen. (2026-02-19)
- Meta: Neues Skript `scripts/projekt_kontext.sh` fuer Session-Kontext ergaenzt (Git-tracked Struktur wie auf GitHub + Volltext-Export fuer `.pas`, `.lpr`, `.md`, `.sh` in `projekt_kontext.md`); `docs/README.md` um Nutzung/Beispiele erweitert. (2026-02-19)
- Meta: Projektweite `.gitignore` im Root erstellt (FPC-Buildartefakte, Laufzeitdaten wie `.backup/.releases` und DB-Dateien sowie Editor-/OS-Tempdateien). (2026-02-19)
- Docs: Zielversion im Unreleased-Block von `0.6.0` auf `0.5.6-0` umgestellt und Roadmap-Referenzen auf Zwischenversion/Folgeversion nachgezogen (`docs/STATUS.md`, `docs/ARCHITECTURE.md`, `docs/README.md`). (2026-02-19)

## 0.5.6 – 2026-02-19

### Changed (User-Edits)
- Keine Eintraege.

### Changed (Codex)
- Meta: Finales Release-Archiv `Betankungen_0_5_6.tar` per `scripts/kpr.sh --note "Release 0.5.6 final"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=28be5b44c5478c2ff6358caa08dcb8152055d3f2794d254947c445b859845839`). (2026-02-19)
- Docs: Releaseabschluss 0.5.6 im CHANGELOG durchgefuehrt; `[Unreleased]` auf Zielversion `0.6.0` vorbereitet. (2026-02-19)
- Docs: `docs/STATUS.md`, `docs/ARCHITECTURE.md` und `docs/README.md` auf 0.5.6-Abschluss und naechsten Fokus 0.6.0 aktualisiert. (2026-02-19)
- CLI-Parser: Parsing/Validierung aus `src/Betankungen.lpr` in neue Unit `units/u_cli_parse.pas` ausgelagert (`ParseCommand` + `BuildCommand` intern 1:1); Orchestrator nutzt nun `Cmd := ParseCommand` bei unveraenderter Logik. (2026-02-19)
- CLI-Help: `PrintUsage` auf Kompatibilitaets-Alias umgestellt und `PrintHelp` als strukturierte Vollhilfe neu aufgebaut (Usage/Commands/Common/Advanced/Stats/Examples, inkl. konsolidierter Optionen und Beispiele). (2026-02-19)
- CLI/Tests: Help-Struktur um Abschnitt `Stats options` erweitert und Smoke-Basislauf um drei feste Guardrails ergaenzt (`--help`-Keyword-Check, `--stats stations` Fehlerformat, `--stats fuelups --json --csv` als 3-Zeilen-Kurzfehler ohne Voll-Help). Doku in `tests/README.md` aktualisiert. (2026-02-18)
- CLI-Help: Tipp-Dopplung im Fehlerpfad behoben (`PrintUsageShort` Default ohne eingebettetes `"(Tipp: --help)"`, Tipp bleibt als eigene dritte Zeile aus `FailUsage`). (2026-02-18)
- Tests: `tests/smoke_cli.sh` Monthly/Yearly-Validierungschecks auf den neuen Fehlerkanal umgestellt (`stderr` statt `stdout` bei erwarteten Fehlerfaellen wie `--monthly` ohne Stats, Flag-Konflikte, `--pretty` ohne JSON). (2026-02-18)
- Tests: `tests/smoke_cli.sh` Checks fuer Fehlerpfade `--demo` ohne Seed und fehlerhaften `--db` auf den neuen Fehlerkanal angepasst (Fehlermeldungen jetzt in `stderr` statt `stdout`). (2026-02-18)
- Tests: `tests/smoke_cli.sh` um optionalen Guardrail fuer `--reset-config`-Fehlerpfad erweitert (Config nicht loeschbar via Schreibschutz-Simulation, mit Skip falls im Laufzeitumfeld nicht reproduzierbar); Doku in `tests/README.md` aktualisiert. (2026-02-18)
- CLI: `src/Betankungen.lpr` nutzt in Reset-/Exception-Pfaden jetzt konsistent `FailUsage` statt direkter `WriteLn/Halt`-Kombinationen (Config-Loeschfehler + unerwartete Exceptions), inklusive passendem Exit-Code/Fokus. (2026-02-18)
- CLI-Help: `units/u_cli_help.pas` um `PrintUsageShort` erweitert; `FailUsage` auf kompakten 3-Zeilen-Fehlerpfad (Fehlerzeile, kontextsensitive Kurz-Usage, `--help`-Tipp) umgestellt. (2026-02-18)
- Meta: Header in `src/Betankungen.lpr` an die aktuelle Help-Architektur angepasst (Usage/About/FailUsage delegiert an `u_cli_help`, Parserzustand/Output-Trennung klarer dokumentiert). (2026-02-17)
- CLI-Help: `units/u_cli_help.pas` auf zentrale Help-Ausgabe umgestellt und an `u_cli_types` angebunden (`TErrorFocus` + `ErrorFocusToFlag`); `PrintUsage`, `PrintAbout` und `FailUsage` aus `src/Betankungen.lpr` in die Unit uebernommen (inkl. `--about`). (2026-02-17)
- CLI: Lokale Help-Helfer in `src/Betankungen.lpr` entfernt und Aufrufe auf `u_cli_help` umverdrahtet. (2026-02-17)
- Meta/Docs: Header- und Kommentarkonsistenz fuer `src/Betankungen.lpr` sowie alle Kern-Units (ausser `u_cli_help.pas`/`u_cli_types.pas`) professionell vereinheitlicht: erweiterte Datei-Header, konsistente `CREATED/UPDATED`-Metadaten und praezisere API-/Abschnittskommentare in `u_db_common`, `u_db_init`, `u_db_seed`, `u_fmt`, `u_fuelups`, `u_log`, `u_stations`, `u_stats`, `u_table`. (2026-02-17)
- CLI-Types: `units/u_cli_types.pas` fachlich/professionell voll kommentiert (erweiterter Unit-Header, klare Enum-/Record-Felddoku und Mapping-Helper-Kommentare) bei unveraenderter Logik. (2026-02-17)
- CLI-Types: `units/u_cli_types.pas` bereinigt und als zentrale Typquelle konsolidiert (einheitliche Definitionen fuer `TTableKind`, `TCommandKind`, `TErrorFocus`, `TCommand` + Helper `ErrorFocusToFlag`). (2026-02-17)
- CLI: Lokale Typduplikate in `src/Betankungen.lpr` entfernt; Parser/FailUsage auf `u_cli_types` inkl. `TErrorFocus`-Enum umgestellt. (2026-02-17)
- CLI-Types: Template-Hinweis bei `TErrorFocus` in `units/u_cli_types.pas` durch konkrete Produktiv-Doku fuer Parser-/Short-Usage-Mapping ersetzt. (2026-02-17)
- CLI: Neues Meta-Flag `--about` in `src/Betankungen.lpr` ergaenzt (Parsing, Usage, Meta-Dispatch) inkl. Ausgabe einer About-Seite mit Danksagung. (2026-02-17)
- Docs: `docs/README.md` um Meta-Kommandos + Danksagung erweitert und `docs/BENUTZERHANDBUCH.md` um `--about` aktualisiert. (2026-02-17)
- Changed: `scripts/net_recover.sh` um `--only-if-offline` erweitert; Interface-Neustart erfolgt damit nur bei fehlgeschlagenen Connectivity-Checks. (2026-02-17)
- Added: Neues Hilfsskript `scripts/net_recover.sh` fuer Linux-Netzwerkdiagnose und Interface-Neustart (inkl. `--info-only`, Auto-Interface-Erkennung, Connectivity-Checks). (2026-02-17)
- Docs: `docs/README.md` um `scripts/net_recover.sh` ergaenzt und Skript-Uebersicht aktualisiert. (2026-02-17)
- Meta: Release-Archiv `Betankungen_0_5_5.tar` nach STATUS/CHANGELOG-Feinschliff erneut via `scripts/kpr.sh --note "Post-release docs sync: STATUS + CHANGELOG final note"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=3fad313df723976f2aff3c083d0acfc628780ed456d14bfd240f48a7a4e2aba4`). (2026-02-16)
- Docs: `docs/STATUS.md` um kurzen Hinweis auf finalisiertes 0.5.5-Release-Artefakt inkl. Post-Release-Doku-Sync ergänzt. (2026-02-16)
- Meta: Release-Archiv `Betankungen_0_5_5.tar` nach Doku-Konsistenzbereinigung erneut via `scripts/kpr.sh --note "Post-release docs consistency sync: 0.5.5 changelog cleanup"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=845ac6833039675a51a4f7aca4e3ffae683192c61b76219ec7096970a3eb2c2c`). (2026-02-16)
- Docs: Konsistenz-Bereinigung im CHANGELOG: 0.5.5-Abschnitt auf finalen Release-Stand reduziert (entfernte 0.5.4-Resteintraege und veraltete Zwischenstaende wie "TODO/ohne Wirkung" bei Yearly). (2026-02-16)

## 0.5.5 – 2026-02-16

### Changed (User-Edits)
- Keine Eintraege.

### Changed (Codex)
- Meta: Finales Release-Archiv `Betankungen_0_5_5.tar` per `scripts/kpr.sh --note "Release 0.5.5 final"` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=1ede5cdb00f9e28c1e3d056d96756eaf430deda78c1449e1cdec3e16a776b512`). (2026-02-16)
- Meta: Header-Metadaten in `src/Betankungen.lpr` an den aktuellen Stats-Umfang angepasst (Statistik-Dispatch jetzt explizit inkl. Monats- und Jahresoptionen). (2026-02-16)
- Added: `--yearly` fuer `--stats fuelups` finalisiert (Text + JSON mit `kind: "fuelups_yearly"`; Jahresaggregation aus Monatsdaten). (2026-02-16)
- Fixed: CLI-Validierung fuer Yearly-Kombinationen konsolidiert (`--yearly` nur mit `--stats fuelups`, exklusiv zu `--monthly`, kein Mix mit `--csv`/`--dashboard`). (2026-02-16)
- Changed: Smoke-Suite fuer Monthly/Yearly ausgebaut und steuerbar gemacht (`-m`, `-y`, `-a`, `-l/--list`, `--keep-going`) inkl. farblicher Ausgabe und Wrapper-Forwarding. (2026-02-16)
- Changed: Doku fuer 0.5.5-Abschluss nachgezogen (`docs/README.md`, `docs/BENUTZERHANDBUCH.md`, `docs/STATUS.md`, `docs/ARCHITECTURE.md`; Yearly-Feature + Restriktionen + Fokus 0.5.6). (2026-02-16)
- Tests: `tests/smoke_cli.sh` um `-l/--list` erweitert (Dry-List aller geplanten Checks ohne Ausfuehrung) und um Fail-Mode-Schalter `--keep-going`; Standard ist jetzt fail-fast. (2026-02-16)
- Tests: Smoke-Ausgaben in `tests/smoke_cli.sh` und `tests/smoke_clean_home.sh` farblich markiert (`[INFO]` gelb, `[OK]` gruen, `[FAIL]` rot; `[LIST]` cyan in `smoke_cli.sh`). (2026-02-16)
- Tests: `tests/smoke_clean_home.sh` reicht zusaetzlich `-l/--list` und `--keep-going` an `smoke_cli.sh` durch. (2026-02-16)
- Tests: Smoke-Suites fuer Monthly/Yearly per Flags steuerbar gemacht (`tests/smoke_cli.sh`: `-m`, `-y`, `-a`); Defaultlauf bleibt kurz ohne Zusatzsuiten. (2026-02-16)
- Tests: `tests/smoke_clean_home.sh` reicht `-m/-y/-a` an `smoke_cli.sh` durch und dokumentiert die Optionen. (2026-02-16)
- Tests: `tests/smoke_cli.sh` um eine vollstaendige Yearly-Smoke-Suite erweitert (Erfolgsfaelle, Validierungskonflikte, JSON-Strukturchecks, Period-/Pretty-Kombinationen inkl. leerer DB-Fall). (2026-02-16)
- Docs: `tests/README.md` um die neue Yearly-Regression-Suite erweitert und Stand-Datum aktualisiert. (2026-02-16)
- Seed: Demo-Befuellung in `u_db_seed` auf groesseren Datensatz erweitert: effektive Fuelup-Zielmenge 300-500 (bei abweichender Anfrage Normalisierung in den Zielbereich) und Zeitverteilung ueber 3-5 Jahre. (2026-02-16)
- Stats: Abschnitt 5 umgesetzt: echte Jahresaggregation (`--yearly`) in Text und JSON aus Monatsdaten gefaltet (`TYearAgg`, `YearAggAdd/Sort`, JSON `kind: "fuelups_yearly"`). (2026-02-16)
- Stats: `ShowFuelupStatsJson` auf eine zentrale Signatur konsolidiert (`Monthly, Yearly, Pretty`) und Forward-/Implementierungsreihenfolge vereinheitlicht; behebt FPC-Fehler "var name changes Pretty => Yearly". (2026-02-16)

## 0.5.4 – 2026-02-15

### Changed (User-Edits)
- Keine Eintraege.

### Changed (Codex)
- CLI: `src/Betankungen.lpr` auf `APP_VERSION 0.5.4` angehoben und First-Run-/DB-Path-Flow angepasst (Default/Config ohne Prompt, interaktive Pfadabfrage nur als Fallback bei fehlgeschlagener DB-Provisionierung inkl. Retry + Erststart-Hinweis). (2026-02-15)
- Docs: `docs/BENUTZERHANDBUCH.md` auf den neuen First-Run-Flow aktualisiert (Default ohne Prompt, interaktive Pfadabfrage nur als Fallback). (2026-02-15)
- CLI: `ResolveDbPath`-Aufruf in `src/Betankungen.lpr` gegen IO-Fehler abgesichert (`try/except`) und auf denselben Fallback-UX umgeleitet (nur interaktiv ohne `--db`/`--demo`, inkl. Config-Speicherung). (2026-02-15)
- CLI: Frischstart ohne Argumente initialisiert jetzt still `config.ini` + Default-DB vor dem Command-Parsing; dadurch kein Fehler "Kein Kommando" beim ersten Aufruf. (2026-02-15)
- Docs: `docs/README.md` und `docs/BENUTZERHANDBUCH.md` um das Verhalten "frischer Start ohne Argumente" ergänzt. (2026-02-15)
- CLI: No-Command-Bootstrap erweitert: Bei vorhandener Config aber fehlender DB wird die DB jetzt ebenfalls still automatisch angelegt. (2026-02-15)
- CLI: Pfad-Getter (`GetDefaultDbPath`/`GetConfigPath`) ohne IO-Seiteneffekte; Verzeichnisanlage erfolgt nun gezielt in Schreibpfaden. (2026-02-15)
- CLI: Interaktiver Fallback auf zentralen Retry-Helper (`PromptAndPersistDbPath`) umgestellt, sodass bei nicht speicherbaren Eingabepfaden erneut abgefragt wird. (2026-02-15)
- Docs: `docs/README.md` und `docs/BENUTZERHANDBUCH.md` um den Fall "Config vorhanden, DB fehlt" ergänzt. (2026-02-15)
- Tests: `tests/smoke_cli.sh` um 0.5.4-First-Run-Szenarien erweitert (frischer Start, Config ohne DB, nicht schreibbarer Default mit Prompt-Retry). (2026-02-15)
- Docs: `tests/README.md` um die neuen Smoke-Fälle ergänzt und Stand-Datum aktualisiert. (2026-02-15)
- Tests: `tests/smoke_cli.sh` um weitere CLI-Guardrail-Checks erweitert (`--show-config` fresh HOME, `--reset-config` behaelt DB, `--demo` ohne Seed ohne Prompt, fehlerhafter `--db` ohne Prompt). (2026-02-15)
- Docs: `tests/README.md` um die zusaetzlichen Guardrail-Checks ergaenzt. (2026-02-15)
- Tests: Neues Wrapper-Script `tests/smoke_clean_home.sh` fuer den finalen Smoke-Run in sauberer HOME/XDG-Sandbox eingefuehrt (`--keep-home` optional). (2026-02-15)
- Docs: `tests/README.md` um Nutzung von `tests/smoke_clean_home.sh` ergaenzt. (2026-02-15)

## 0.5.3 – 2026-02-14

### Changed (User-Edits)
- CLI: `APP_VERSION` auf `0.5.3` gesetzt und Datumsstand in `src/Betankungen.lpr` aktualisiert. (2026-02-14)

### Changed (Codex)
- Meta: Finales Release-Archiv `Betankungen_0_5_3.tar` per `scripts/kpr.sh` erzeugt und in `.releases/release_log.json` protokolliert (`sha256=5a6ecf54d24a72bc96110622d47a5140680b532f9dc485a1274db66b8f243338`). (2026-02-14)
- Docs: Releaseabschluss 0.5.3 im CHANGELOG durchgefuehrt; `[Unreleased]` auf Zielversion `0.5.4` vorbereitet. (2026-02-14)
- Docs: `STATUS` auf Zielversion `0.5.4` umgestellt und 0.5.3 als abgeschlossen markiert. (2026-02-14)
- Docs: `README` um konsistenten Roadmap-Kurzstand erweitert (0.5.3/0.5.4/0.5.5/0.6.0) und Jahres-Summary explizit auf 0.5.5 verankert; Stand-Datum aktualisiert. (2026-02-14)
- Docs: Roadmap-Dokumentation auf neue Evolutionslinie ausgerichtet (0.5.3 Reifegrad, 0.5.4 First-Run-UX, 0.5.5 Jahres-Summary, 0.6.0 Fahrzeug-Domain-Konsolidierung) in `ARCHITECTURE`, `STATUS` und `BENUTZERHANDBUCH`. (2026-02-14)
- Meta: `AGENTS.md` um verbindlichen FPC-Build-Standard erweitert (`fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`) und Stand-Datum aktualisiert. (2026-02-14)
- Stats: `u_stats` Zyklus-Collector auf v4-Reihenfolge gebracht (`car_id`/`missed_previous` zuerst), inkl. Reset bei Car-Wechsel und bestaetigter Luecke vor Datensatzverarbeitung. (2026-02-14)
- DB: `u_db_init` um Cars-Immutability-Trigger (`odometer_start_km`/`odometer_start_date`) erweitert; Header auf aktuellen Stand gesetzt. (2026-02-14)
- Fuelups: `u_fuelups` auf Default-Car-Flow (`car_id=1`) angepasst; Odometer-/Gap-Checks und Tankmengen-Warnung gem. Diff-Reihenfolge ausgerichtet. (2026-02-14)
- DB: `u_db_init` setzt v4-Meta-Defaults (`odometer_start_km/date`) nur bei neuen DBs und nutzt `meta` als Migrationsquelle fuer `cars`-Startwerte. (2026-02-13)
- DB: `u_db_init` migriert `cars` auf erweitertes v4-Schema (`plate`, `note`, `odometer_start_km`, `odometer_start_date`) und legt Default-Fahrzeug `Hauptauto` an. (2026-02-13)
- Seed: `u_db_seed` erweitert `cars` auf v4-full inkl. kompatibler ALTER-Faelle und schreibt Default `Hauptauto` mit Startwerten. (2026-02-13)
- Fuelups: Odometer-Domainvalidierung pro Fahrzeug ergaenzt (Start-KM-Grenze, monotone Reihenfolge, Gap-Threshold fuer `missed_previous`, Tankmengen-Warnung >150L). (2026-02-13)
- Stats: Zyklus-Collector wertet `missed_previous` aus und resettet laufende Sammler bei gesetzter Luecke. (2026-02-13)
- Docs: README/BENUTZERHANDBUCH/ARCHITECTURE/STATUS um neue v4-Details und Validierungslogik aktualisiert. (2026-02-13)
- DB: `migrations/v3_to_v4.sql` FK-PRAGMA-Reihenfolge auf robuste SQLite-Variante korrigiert (`foreign_keys=OFF` vor `BEGIN`, `ON` nach `COMMIT`). (2026-02-13)
- DB: Manuelle SQL-Migration `migrations/v3_to_v4.sql` fuer Fuelups-Rebuild (car_id + missed_previous), v4-Indizes und Trigger-Recreate ergaenzt. (2026-02-13)
- Docs: README-Projektstruktur um Ordner `migrations/` ergaenzt. (2026-02-13)
- DB: Schema auf v4 erweitert (`cars`, `fuelups.car_id`, `fuelups.missed_previous`) inkl. v3->v4 Migration in `u_db_init` ueber `fuelups_new` + Datenuebernahme. (2026-02-13)
- Fuelups: `--add fuelups` schreibt nun `car_id` und `missed_previous`; Fahrzeugauswahl ist bei mehreren Fahrzeugen interaktiv, bei einem Fahrzeug automatisch. (2026-02-13)
- Fuelups: Listenansicht zeigt Fahrzeugbezug (`car_name`) und Detailblock zeigt `MissPrev`-Status. (2026-02-13)
- Seed: Demo-Schema auf v4 angehoben (cars + neue fuelups-Felder), inkl. kompatibler ALTER-Faelle fuer bestehende Demo-DBs. (2026-02-13)
- Stats: Zyklusbildung trennt Daten strikt pro `car_id` (keine Vermischung zwischen Fahrzeugen). (2026-02-13)
- Docs: README/BENUTZERHANDBUCH/STATUS/ARCHITECTURE fuer Schema v4 und neues Fuelup-Verhalten aktualisiert. (2026-02-13)
- Meta: Erster Snapshot per `scripts/backup_snapshot.sh` angelegt (`.backup/2026-02-13_1757`, Note: "Initial 0.5.3 workflow"). (2026-02-13)
- Meta: `.archive/` nach `knowledge_archive/` umbenannt und als Wissens-Archiv dokumentiert (`knowledge_archive/README.md`). (2026-02-13)
- Meta: `kpr.sh` nach `scripts/kpr.sh` verlagert; Projektroot behaelt kompatiblen Wrapper `kpr.sh`. (2026-02-13)
- Meta: Backup-Snapshot-Skript `scripts/backup_snapshot.sh` mit `.backup/index.json`-Pflege ergaenzt. (2026-02-13)
- Docs: Restore-Dokumentation `docs/RESTORE.md` ergaenzt (Auswahl, Hash-Pruefung, Entpacken, Plausibilitaetscheck). (2026-02-13)
- QA: `tests/` mit `tests/smoke_cli.sh` und `tests/README.md` fuer lokale Smoke-Checks ergaenzt. (2026-02-13)
- Docs: README/ARCHITECTURE/STATUS/DESIGN_PRINCIPLES auf neue Ordnerstruktur (`scripts`, `.backup`, `knowledge_archive`) aktualisiert. (2026-02-13)
- Docs: README-Releaseabschnitt um expliziten Ordner `.releases/` fuer finalisierte `.tar`-Archive + `release_log.json` erweitert. (2026-02-13)
- Meta: `kpr.sh` schreibt Release-Archive standardmaessig nach `.releases/` und pflegt Log in `.releases/release_log.json`. (2026-02-12)
- Docs: README/STATUS/ARCHITECTURE/DESIGN_PRINCIPLES auf `.releases`-Pfade fuer Release-Artefakte aktualisiert. (2026-02-12)
- Docs: STATUS auf konsistenten 0.5.2-Abschluss gebracht und Kurzfazit auf "0.5.2 freigegeben" aktualisiert. (2026-02-12)
- Docs: ARCHITECTURE auf Stand 0.5.2 aktualisiert (Stand-Datum, Funktionsumfang, abgeschlossener 0.5.2-Abschnitt). (2026-02-12)
- Docs: README/BENUTZERHANDBUCH um konkrete Dashboard-Schnellbeispiele ergaenzt. (2026-02-12)
- Docs: DESIGN_PRINCIPLES-Nummerierung konsolidiert (doppelte "9" entfernt) und Stand-Datum aktualisiert. (2026-02-12)

## 0.5.2 – 2026-02-12

### Added
Ziel von 0.5.2:
- Ein kompaktes, scanbares Konsolen-Dashboard fuer `--stats fuelups`, das sich visuell klar von der Tabellen-Ausgabe unterscheidet und langfristig als Grundlage fuer ein einheitliches Unicode-Box-Design dient.
- Kein CLI-Umbau.
- Kein neues Subcommand.
- Keine GUI.
- Dashboard ist ein alternativer Renderer innerhalb des bestehenden Stats-Systems.

### Changed (User-Edits)
- u_fmt: Dashboard-Bar (Kosten-Balken) inkl. Farblogik, ANSI-sichere Box-Zeilen und Konfig-Variablen ergaenzt; `FmtScaledInt` ins Interface gehoben. (2026-02-11)
- u_stats: Dashboard-Renderer (`RenderFuelupDashboardText`) und `ShowFuelupDashboard`-Overloads ergaenzt (API). (2026-02-11)

### Changed (Codex)
- u_fmt: Dashboard-Farblogik um `TDashColorMode` erweitert (static/relative); `ResolveDashColor` nutzt nun `Cents` + `MaxCents`. (2026-02-12)
- Docs: README um Hinweis auf umschaltbare Dashboard-Farblogik (Cent vs. Promille) ergaenzt. (2026-02-12)
- u_fmt: `AnsiVisibleLen` auf UTF-8-sichtbare Laenge (nach `StripAnsi`) umgestellt; Padding bei Mehrbyte-Zeichen stabilisiert. (2026-02-12)
- CLI: Stats-Dispatch strukturell refaktoriert (`--dashboard`-Pfad im finalen Else-Block), Verhalten unveraendert. (2026-02-12)
- CLI: `--dashboard` fuer `--stats fuelups` ergaenzt (Parsing, Usage, Validierung, Dispatch zu `ShowFuelupDashboard`). (2026-02-12)
- Docs: README/BENUTZERHANDBUCH/STATUS auf `--dashboard`-Flag und CLI-Status aktualisiert. (2026-02-12)
- u_table: UTF-8-sichtbare Breite/Cut fuer stabiles Tabellenlayout mit Mehrbyte-Zeichen ergaenzt. (2026-02-12)
- Docs: README um UTF-8-Hinweis bei `u_table.pas` ergaenzt. (2026-02-12)
- Meta: `kpr.sh` nutzt versionierten Archivnamen `Betankungen_<version>.tar`. (2026-02-11)
- Docs: README/DESIGN_PRINCIPLES auf versionierten `kpr.sh`-Archivnamen aktualisiert. (2026-02-11)
- CLI: Temporaere Dashboard-Testverdrahtung in `--stats fuelups` wieder entfernt. (2026-02-11)
- Docs: STATUS-Hinweis zur temporaeren CLI-Verdrahtung entfernt. (2026-02-11)
- Docs: README/STATUS auf Dashboard-API und Box-Engine-Erweiterungen aktualisiert. (2026-02-11)
- u_stats: Header-Doku um Dashboard-Ausgabe ergaenzt. (2026-02-11)
- u_fmt: Unicode-Box-Engine (BoxTop/BoxSep/BoxBottom/BoxLine/BoxKV) ergaenzt. (2026-02-11)
- Docs: README um Unicode-Box-Engine in `u_fmt` ergaenzt. (2026-02-11)
- Docs: Zielbeschreibung 0.5.2 in STATUS/CHANGELOG ergaenzt. (2026-02-11)
- Docs: Roadmap 0.5.2 um Status-Dashboard ergaenzt. (2026-02-11)
- Docs: Release-Prep 0.5.1 (CHANGELOG/STATUS/ARCHITECTURE) konsolidiert. (2026-02-11)
- Docs: DESIGN_PRINCIPLES Stand + Output-Formate-Policy ergaenzt. (2026-02-11)
- Meta: `kpr.sh` als Release-Archiv + Log-Skript im Projektroot ergaenzt. (2026-02-11)
- Meta: `kpr.sh` APP_VERSION-Auslese im Log korrigiert. (2026-02-11)
- Meta: `kpr.sh` schreibt Release-Summary ins Log und gibt sie auf STDOUT aus. (2026-02-11)
- Meta: `kpr.sh` normalisiert `release_log.json` auf kompakte JSON-Form. (2026-02-11)
- Meta: `kpr.sh` Log-Append robust gegen ungueltige JSONs (Neuschreiben via Python). (2026-02-11)

## 0.5.1 – 2026-02-11
### Decisions
- Offene Grenzen bei Filtern datengetrieben festgelegt: nur `--from` => `to = MAX(fueled_at)`, nur `--to` => `from = MIN(fueled_at)` (kein "heute"). (2026-02-09)
- Zyklusregel am Rand festgelegt: Zyklus zählt nur, wenn Start- und End-Volltank im Zeitraum liegen (vollständig im Zeitraum). (2026-02-09)
- JSON-avg festgelegt: `avg_l_per_100km` als scaled Integer (z. B. `avg_l_per_100km_x100`), keine Strings. (2026-02-09)

### Changed (User-Edits)
- CLI: `--csv`/`--pretty` Flags inkl. Validierung/Usage/Dispatch fuer `--stats fuelups` ergaenzt. (2026-02-11)
- CLI: `--from`/`--to` Parsing (YYYY-MM oder YYYY-MM-DD) mit Normalisierung auf `PeriodFromIso`/`PeriodToExclIso`. (2026-02-09)
- CLI: Zentrale Validierung von `--from/--to` (nur mit `--stats fuelups`, from < to, Open-Ended-Reset). (2026-02-09)
- CLI: `--monthly` Flag fuer `--stats fuelups` ergaenzt (Parsing, Validierung, Usage, Dispatch). (2026-02-10)
- u_fmt: CSV-Helper `CsvTokenStrict`/`CsvJoin`/`CsvJoinInt64` ergänzt. (2026-02-10)
- Meta: Projektweite Codex-Regeln in `AGENTS.md` definiert. (2026-02-10)
- Meta: Definition „größere Änderungen“ und Prioritäten in `AGENTS.md` ergänzt. (2026-02-10)
- Meta: Präzisierungen zu Header-Datum, vorhandenen Headern und Doku-Priorität in `AGENTS.md`. (2026-02-10)
- Meta: CHANGELOG-Pflege folgt dem bestehenden Datei-Stil/Abschnitt. (2026-02-10)
- Meta: CHANGELOG-Kennzeichnung User vs. Codex in `AGENTS.md` festgelegt. (2026-02-10)
- Meta: CHANGELOG-Einträge immer unter `[Unreleased]` in bestehenden Unterabschnitten. (2026-02-10)
- Meta: CHANGELOG-Beispielformat in `AGENTS.md` ergänzt. (2026-02-10)
- Meta: CHANGELOG-Beispiel explizit unter „Changed (Codex)“ verankert. (2026-02-10)
- Meta: CHANGELOG-Beispiel auch fuer „Changed (User-Edits)“ ergänzt. (2026-02-10)
- Meta: CHANGELOG-Beispiele in `AGENTS.md` konkretisiert. (2026-02-10)
- Stats: Helper `ResolvePeriodBounds` und `ApplyPeriodWhere` in `u_stats.pas` eingefuegt. (2026-02-09)
- Stats: `ShowFuelupStats` nutzt Period-Resolve + optionales WHERE in Kopf- und Zyklus-Query. (2026-02-09)
- Stats: `ShowFuelupStatsJson` nutzt Period-Resolve + optionales WHERE und gibt `avg_l_per_100km_x100` aus. (2026-02-09)
- Docs: README-Abschnitt zu `u_stats.pas` auf `avg_l_per_100km_x100` aktualisiert. (2026-02-09)
- Orchestrator: `--stats fuelups` Dispatch reicht Period-Parameter an `u_stats` durch (Text/JSON). (2026-02-09)
- Docs: JSON-Beispielausgabe fuer `--stats fuelups --json` in README ergaenzt. (2026-02-09)

### Changed (Codex)
- Docs: BENUTZERHANDBUCH/README/STATUS/ARCHITECTURE auf `--csv`/`--pretty` aktualisiert. (2026-02-11)
- Docs: 0.5.1 CLI-Flag-Skizze (csv/pretty + Validierung/Dispatch) in STATUS ergänzt. (2026-02-11)
- Docs: ARCHITECTURE CSV-Helper Hinweis an Stats-CSV-Realitaet angepasst. (2026-02-11)
- Stats: `ShowFuelupStatsJson` nutzt Collector-Resultat konsistent via `R`. (2026-02-11)
- Stats: `ShowFuelupStatsCsv` nutzt Collector-Resultat konsistent via `R`. (2026-02-11)
- Stats: `ShowFuelupStats` nutzt Collector-Resultat konsistent via `R`. (2026-02-11)
- Stats: JSON-Renderer auf R-Parameter-Namenskonvention angepasst. (2026-02-11)
- Stats: CSV-Renderer an Vorgabe angepasst (feste Kopfzeilen, Rows via CsvJoin, striktes Token nur fuer Month). (2026-02-11)
- Stats: Collector-Init auf FillChar/Nullstart umgestellt (vereinheitlicht). (2026-02-11)
- Stats: JSON-Writer (compact/pretty) fuer `RenderFuelupStatsJson` eingefuehrt. (2026-02-11)
- Stats: Sammelstruktur + Collector/Renderer fuer Fuelup-Stats eingefuehrt. (2026-02-11)
- Stats: CSV-Ausgabe fuer Zyklen/Monate in `u_stats.pas` ergaenzt. (2026-02-11)
- Stats: JSON-Pretty-Overload eingefuehrt; Standardausgabe nun kompakt. (2026-02-11)
- Stats: Monats-Textausgabe zeigt nur die Monats-Tabelle (keine Zyklusliste). (2026-02-11)
- Docs: README/BENUTZERHANDBUCH/STATUS/ARCHITECTURE auf CSV/JSON-Stand aktualisiert. (2026-02-11)
- CLI: Kalender-validiertes Datums-Parsing fuer `YYYY-MM-DD` implementiert. (2026-02-09)
- Build: DateUtils fuer Datumsarithmetik (`IncDay`, `IncMonth`) eingebunden. (2026-02-09)
- Stats: Public API von `u_stats.pas` um Overloads mit Zeitraum-Parametern erweitert. (2026-02-09)
- Stats: `ShowFuelupStats`/`ShowFuelupStatsJson` Signaturen um `Monthly` erweitert. (2026-02-10)
- Stats: Monatsaggregation (Text) fuer `--stats fuelups --monthly` ergaenzt. (2026-02-10)
- Stats: JSON-Ausgabe fuer `--stats fuelups --json --monthly` mit `kind: "fuelups_monthly"`. (2026-02-10)
- Stats: Debug-Helper `DbgEffectivePeriod` eingefuegt (open-ended/closed, no-rows Hinweis). (2026-02-09)
- Stats: Effektiver Zeitraum nach Kopf-Query einmalig geloggt (Text + JSON). (2026-02-09)
- Stats: Zyklus-Algorithmus kanonisiert (Sammler nur zwischen Volltanks; End-Volltank schliesst Zyklus). (2026-02-09)
- Stats: Accumulator-Namen vereinheitlicht (`Acc*` statt `Bucket*`). (2026-02-09)
- Docs: README/STATUS um Stats-Debug-Hinweis (Kopf-Query, open-ended/closed, no-rows) ergaenzt. (2026-02-09)
- Stats: `ShowFuelupStats(DbPath)`/`ShowFuelupStatsJson(DbPath)` als Wrapper auf die Overloads umgestellt. (2026-02-09)

### Fixed (Codex)
- CLI: `--csv`/`--pretty` werden nach Parsing zentral validiert; Kombinationen mit `--json` werden sauber abgelehnt. (2026-02-11)
- Stats: Advanced records aktiviert und Monats-Sortierung auf lokale Kopie umgestellt (const-sicher). (2026-02-11)
- Stats: Zyklusabschluss zaehlt End-Volltank in Liter- und Kosten-Summe (kein 0,0 bei Endtank ohne Teilbetankung). (`units/u_stats.pas`) (2026-02-10)
- Build: `--to` Parsing ohne inline `var` (objfpc-kompatibel). (2026-02-09)
- Build: `TryParseYYYYMMDD` gibt nun korrekt `Result` und Werte zurueck. (2026-02-09)
- Stats: `u_stats.pas` Compile-Fixes (doppelte Var-Deklaration, `Q.SQL.Text` ohne `+=`). (2026-02-09)
- Stats: `ShowFuelupStatsJson` fehlende Eff-Variablen ergänzt; doppelte Eff-Deklaration bereinigt. (2026-02-09)
- Stats: NULL-sichere Summen/Counts (`FieldInt64OrZero`) zur Vermeidung leerer Integer-Konvertierung. (2026-02-09)

## 0.4.2 – 2026-02-07
### Added
- Vorbereitung auf Subcommands (internes Modell), CLI bleibt unverändert.
- Neues Backup-Skript `kpr.sh`: tar von docs/src/units, SHA-256 + JSON-Log. (2026-02-04)
- Stats: JSON-Ausgabe fuer `--stats fuelups` (`--json`). (2026-02-07)

### Changed
- u_db_init: Header auf einheitliches UPDATED/AUTHOR-Format gebracht. (2026-02-07)
- u_fmt: Header-Hinweis zum Dezimaltrennzeichen korrigiert. (2026-02-07)
- u_stats: Header um JSON-Stats ergaenzt. (2026-02-07)
- CLI: `--json` für `--stats fuelups` ergänzt (Parsing, Validierung, Usage, Dispatch). (2026-02-07)
- Stats: Leerzeile zwischen Header und Tabelle ergänzt. (2026-02-07)
- Docs: Stand-Datum in `INITIAL_CONTEXT.md` und `CONSTRAINTS.md` auf 2026-02-07 aktualisiert. (2026-02-07)
- Docs: Release-Logging in `DESIGN_PRINCIPLES.md` und `STATUS.md` ergänzt. (2026-02-07)
- Docs: Hinweis auf `kpr.sh` (Release-Log) in README/ARCHITECTURE ergänzt. (2026-02-07)
- Backup: `kpr.sh` loggt Release-Infos in `release_log.json` und erfasst Quellen im JSON. (2026-02-07)
- Stats: Header-UPDATED in `u_stats.pas` auf 2026-02-07 gesetzt. (2026-02-07)
- Stats: Zyklus-Tabelle erst nach Header/Checks ausgeben; Kosten klarer zwischen SQL-Summe und Zyklus-Summe getrennt. (2026-02-07)
- Docs: README/ARCHITECTURE/STATUS auf aktuellen Funktionsumfang gebracht (Fuelups, Stats-Kosten, Tabellen-Renderer, Input-Parsing, JSON). (2026-02-07)
- Logging-Doku: Quiet unterdrueckt explizit alle Ausgaben; `Dbg(...)` nutzt `[TRC]`. (2026-02-04)
- Design-Prinzipien: neue Ausgabe- & Logging-Regel plus Quiet Output Policy (`--quiet`). (2026-02-04)
- Stats: `total_cents` in den SELECTs erfasst und im Debug geloggt. (2026-02-04)
- Stats: Aggregation von `total_cents` und Gesamtkosten-Ausgabe ergänzt. (2026-02-04)
- Stats: Gesamtkosten mit Tausenderpunkt formatiert. (2026-02-04)
- Stats: Tabellen-Setup mit TTable-Spalten initialisiert (Vorbereitung Renderer). (2026-02-04)
- Stats: Zyklusabschluss fügt Tabellenzeile inkl. Kosten hinzu. (2026-02-04)
- Stats: Gesamtzeile (Summe) via TTable-Footer ergänzt. (2026-02-04)
- Stats: TTable-Ausgabe via `T.Write` ergänzt. (2026-02-04)
- Stats: Kostenformatierung in `FormatCentsAsEuro` auf Integer-Format umgestellt. (2026-02-04)
- Tabellen-Renderer: `TTable` in `u_table` ergänzt (Spalten, Zeilen, Separator, Write). (2026-02-04)
- Tabellen-Renderer: Separatoren unterstützen jetzt Doppellinie fuer Footer (`=`). (2026-02-04)
- Tabellen-Renderer: Header-Trennlinie als Doppellinie formatiert. (2026-02-04)
- u_stats: Header-Doku an aktuellen Funktionsumfang angepasst. (2026-02-04)
- u_table: Header-Doku um TTable-Renderer erweitert. (2026-02-04)
- Stats: Kosten gesamt wieder strikt als Fixed-Point formatiert. (2026-02-04)
- Stats: Kraftstoff-Ausgabe nutzt Fixed-Point-Formatter statt Float. (2026-02-04)
- Stats: Summenzeile wird nur bei vorhandenen Zyklen in die Tabelle gesetzt. (2026-02-04)
- Stats: Ausgabe-Block nach DB-Block gezogen (Lesbarkeit). (2026-02-04)
- Stats: Tabellen-Write direkt nach Summenzeile platziert. (2026-02-04)

### Fixed
- `--quiet` unterdrueckt jetzt auch die leere Zeile vor der Debug-Tabelle. (2026-02-04)

---

## 0.4.1 – 2026-02-03
### Added
- `--stats fuelups` mit Volltank-Zyklus-Auswertung (Strecke, Verbrauch, Zeitraum).
- `u_stats.pas` als neue Unit fuer Auswertungen.
- `--trace` fuer gezielte Trace-Ausgaben.
### Changed
- Logging-Policy: informative Ausgaben ueber `Msg(...)` (respektiert Quiet).
- Debug/Trace getrennt: `Dbg` nutzt Trace, Debug-Tabelle bleibt bei `--debug`.
### Fixed
- Ausgaben bei `--seed` in Quiet sauber und maschinenfreundlich.

---

## 0.4.0 – 2026-02-01
### Added
- Demo-DB-Workflow: `--seed` zum Erzeugen/Aktualisieren, `--demo` zur Nutzung.
- Seed-Parameter: `--stations`, `--fuelups`, `--seed-value`, `--force`.
- Erweiterte Usage-/Hilfeausgabe inkl. Beispiele und Hinweise.
### Changed
- CLI-Policy erweitert: `--seed` ist exklusiv und nutzt immer die Demo-DB.
- Demo-Seed-Daten auf ASCII angepasst (Umlaute als ae/oe/ue).
### Fixed
- Stabilere Fehlerausgabe beim Seeding (saubere Fehlermeldung statt Stacktrace).
- `sqlite_sequence`-Reset defensiv, falls Tabelle fehlt.

---

## 0.3.0 – 2026-01-28
### Added
- Vollständige Fachlogik für Betankungen (`fuelups`): add / list / `--detail`, JOIN auf `stations`
- Bon-exaktes Parsing für `fuelups` (skalierte Integer, keine Float-Rundungsfehler)
- Striktes Transaktionshandling pro Business-Aktion (fuelups)
- Neues, standardisiertes Header-System für alle Units zur besseren Wartbarkeit
### Changed
- Schema-Version auf v3 aktualisiert (inkl. `fuelups`)

---

## 0.2.2 – 2026-01-21 (Projektstruktur & DB-Pfad-Handling)
### Added
- **Persistenz:** DB-Pfad wird nun in `~/.config/Betankungen/config.ini` gespeichert.
- **XDG-Support:** Automatische Nutzung von Standardverzeichnissen für Daten und Konfiguration.
- **CLI-Tools:** Befehle `--show-config` und `--reset-config` für einfachere Wartung hinzugefügt.
- **Flexibilität:** Mit `--db` kann der Pfad nun für einzelne Aufrufe überschrieben werden.

### Fixed
- Build-Umgebung: Inkonsistenzen zwischen Lazarus-IDE und VS Code (fpc) behoben.
- Bereinigung verwaister Lazarus-Projekt-Metadaten.

---

## 0.2.1 – Stabilisierung & Dokumentation
### Changed
- **Robustheit:** Umfassende Einführung von `try...finally` zur sicheren Ressourcen-Freigabe (Memory Leaks verhindert).
- **UX:** Fehlermeldungen verständlicher gestaltet und interaktive Texte verfeinert.
- **Logging:** Debug-Ausgaben vereinheitlicht und lesbarer formatiert.


---

## 0.2.0 – Stations-CRUD
- Vollständige CRUD-Funktionalität für `stations`
- Interaktive Eingabe und Bearbeitung
- Alt-/Neu-Vergleich bei Änderungen
- Detail- und Standardlisten
- UNIQUE-Constraint auf Adresse
- Debug-Logging mit Tabellenlayout
- Zentrale Logging-Unit (`u_log`)

---

## 0.1.0 – Initiale Basis
- SQLite-Initialisierung (`EnsureDatabase`)
- Technische Meta-Tabelle (`meta`)
- Schema-Versionierung
- CLI-Grundgerüst mit Flag-Parsing
- Debug- und Quiet-Modus

````

## Datei: `docs/CONSTRAINTS.md`

````markdown
# WAS WIR NICHT TUN – Projekt „Betankungen“
**Stand:** 2026-02-07

Diese Liste definiert bewusst gesetzte Grenzen.
Alles hier ist **kein Bug**, sondern **Design-Entscheidung**.

---

## Architektur & Struktur

- Keine Fachlogik im `.lpr`
  - `.lpr` ist **reiner Orchestrator**
  - keine SQLs, keine Berechnungen, keine UI-Logik

- Keine „God-Units“
  - Jede Unit hat **eine klar abgegrenzte Verantwortung**
  - keine Sammel-Helper ohne Domainbezug

- Kein vorschnelles „Refactor Everything™“
  - Umbauten nur, wenn sie:
    - Komplexität **reduzieren**
    - oder neue Features **ermöglichen**

---

## CLI & UX

- Keine stillschweigenden Annahmen
  - Jeder Befehl ist explizit
  - Fehler führen zu klarer Fehlermeldung + Usage

- Kein Mischmasch aus Flags & impliziten Zuständen
  - alles geht über `TCommand`
  - keine globalen „Sonderfälle“

- Kein „magisches Verhalten“
  - `--seed` überschreibt **nie** ohne `--force`
  - Demo-DB ist **immer** getrennt von produktiver DB

---

## Domain-Regeln

- Keine Manipulation von `fuelups`
  - kein edit
  - kein delete
  - Tankvorgänge sind **historisch unveränderlich**

- Keine stillen Korrekturen von Benutzerdaten
  - Parsing ist strikt
  - Fehler werden früh abgefangen

- Keine Gleitkomma-Arithmetik für Geld / Volumen
  - ausschließlich Fixed-Point (`Int64`)
  - Cent / ml / milli-EUR

---

## Logging & Debugging

- Kein `WriteLn` in Fachlogik
  - Logging läuft **zentral** über `u_log`

- Kein unkontrolliertes Debug-Spamming
  - `[DBG]` nur bei `--debug`
  - keine Debug-Ausgaben im Normalbetrieb

- `--quiet` bedeutet wirklich **quiet**
  - keine Meta-Tabelle
  - keine Debug-Ausgaben
  - nur fachliches Ergebnis

---

## Feature-Umfang

- Keine GUI
  - bewusstes CLI-Projekt

- Keine Web-API
  - kein HTTP
  - kein REST
  - kein JSON-over-HTTP

- Kein Overengineering
  - keine ORM
  - keine DI-Container
  - keine Pattern nur „weil man sie kennt“

---

## Entwicklung & Prozess

- Keine Features ohne klare Motivation
  - jede neue Funktion beantwortet:
    - *Welches Problem löst sie?*

- Kein Perfektionismus in frühen Phasen
  - Polishing kommt **später**
  - zuerst korrekt, dann schön

- Kein Selbstzweifel-getriebener Umbau
  - funktionierender Code ist **wertvoll**
  - Iteration schlägt Neu-Anfang

---

## Grundhaltung

- Wir bauen kein Spielzeug
- Wir bauen keine Wegwerf-Software
- Wir bauen nichts für „alle“

Wir bauen ein **robustes, lernorientiertes, ehrliches Werkzeug**

````

## Datei: `docs/DESIGN_PRINCIPLES.md`

````markdown
# DESIGN-PRINZIPIEN – Projekt „Betankungen“
**Stand:** 2026-02-13

Diese Prinzipien beschreiben die bewusst gewählten Leitlinien
für Architektur, Code und Weiterentwicklung.

---

## 1. CLI-zuerst & Fokus
- Betankungen ist eine **Terminal-Anwendung**, kein GUI- oder Web-Projekt.
- Alle Funktionen sind über explizite CLI-Kommandos erreichbar.
- Jede CLI-Ausführung hat **genau eine Hauptaktion**.

---

## 2. Orchestrator statt God-Objekt
- Das Hauptprogramm (`.lpr`) koordiniert ausschließlich:
  - Parsing
  - Dispatch
  - Policy
- Fachlogik lebt ausschließlich in dedizierten Units.

---

## 3. Klare Verantwortlichkeiten
- Jede Unit hat **eine klar umrissene Aufgabe**.
- Anzeige, Eingabe und Geschäftslogik sind strikt getrennt (SoC).
- Keine Unit kennt CLI-Parsing oder globale Zustände außerhalb ihres Zwecks.

---

## 4. Daten sind historisch korrekt
- Tankvorgänge (`fuelups`) sind **append-only**.
- Einmal gespeicherte Daten werden nicht stillschweigend verändert.
- Statistiken basieren auf nachvollziehbaren, reproduzierbaren Regeln.

---

## 5. Präzision vor Bequemlichkeit
- Geld, Volumen und Preise werden ausschließlich als **Fixed-Point Integer**
  (Cent, ml, milli-EUR) verarbeitet.
- Keine Gleitkomma-Arithmetik in der Fachlogik.

---

## 6. Defensive Systemgrenzen
- Ungültige Eingaben werden **früh abgefangen**.
- Fehler werden klar benannt, nicht „korrigiert“.
- Transaktionen folgen strikt dem All-or-Nothing-Prinzip.

---

## 7. Transparente Debugbarkeit
- Fehlersuche ist **explizit aktivierbar**.
- Logging-Ebenen sind klar getrennt:
  - Debug (Meta)
  - Trace (Ablauf)
  - Detail (fachliche Ausgabe)
  - Quiet (nur Ergebnis)
- Kein verstecktes Logging.

---

## 8. Ausgabe- & Logging-Regel (Command-Result vs. Meta)
- Domain-Units dürfen **Command-Ergebnisse** direkt ausgeben
  (z. B. Listen, Statistiken, Exporte).
- Diese Ausgaben stellen das **primäre Ergebnis** eines explizit
  aufgerufenen CLI-Kommandos dar.
- Logging, Debug-, Trace- und Meta-Ausgaben sind **keine**
  Command-Ergebnisse und dürfen **nicht** per `WriteLn` in Domain-Units
  erfolgen.
- Solche Ausgaben laufen ausschließlich über die zentrale Logging-Schicht
  (`u_log`) oder werden im Orchestrator (`.lpr`) erzeugt.
- Faustregel:
  > Wenn ein Nutzer bei `--quiet` diese Ausgabe trotzdem erwartet,
  > ist `WriteLn` zulässig.
  > Andernfalls handelt es sich um Logging oder Meta-Information.
- Diese Regel erlaubt klare, lesbare Fachausgaben
  und stellt gleichzeitig sicher, dass `--debug`, `--detail`
  und `--quiet` konsistent funktionieren.

---

## 9. Output-Formate (Policy)
- CSV ist exklusiv: `--csv` nur bei `--stats fuelups` und ohne `--json`.
- Pretty ist JSON-only: `--pretty` nur zusammen mit `--json`.

---

## 10. Quiet Output Policy (`--quiet`)
Der Schalter `--quiet` reduziert die Ausgabe auf das **fachliche Ergebnis**
eines Kommandos, ohne dessen inhaltliche Aussage zu verfälschen.

### Grundsatz
- `--quiet` unterdrückt **Meta-, Debug-, Trace- und Begleittexte**.
- Das **Command-Ergebnis selbst** bleibt sichtbar.

### Erlaubt bei `--quiet` (Result-Output)
- Tabellen, Listen und Statistiken
- Aussagen über das Ergebnis, z. B.:
  - „Keine Daten gefunden.“
  - „0 Einträge.“
  - „Zyklen: 0 (keine gültigen Volltank-Zyklen)“
- Fehler, die die Ausführung verhindern (über `FailUsage`)

Diese Ausgaben sind Teil der fachlichen Aussage und werden vom Nutzer
auch bei `--quiet` erwartet.

### Nicht erlaubt bei `--quiet` (Meta/Noise)
- Erfolgsmeldungen wie „OK: …“
- Hinweise, Tipps oder Beispiele
- Debug- oder Trace-Ausgaben (`[DBG] …`, `[TRC] …`)
- Meta-Tabellen oder Konfigurationsübersichten

### Ziel
`--quiet` liefert eine **knappe, skriptfreundliche und dennoch
inhaltlich vollständige Ausgabe**, ohne zusätzliche Erläuterungen.

---

## 11. Reproduzierbarkeit
- Demo-Datenbank ist strikt getrennt von produktiven Daten.
- `--seed` erzeugt reproduzierbare Testzustände.
- Tests und Vorführungen sind jederzeit wiederholbar.

---

## 12. Evolution statt Big Bang
- Features wachsen inkrementell.
- Umbauten erfolgen nur, wenn sie:
  - Komplexität reduzieren oder
  - neue Funktionen ermöglichen.
- Polishing ist bewusst nachgelagert.

---

## 13. Dokumentation ist Teil des Systems
- Architektur- und Changelog-Dokumente sind **first-class artifacts**.
- Entscheidungen werden nachvollziehbar festgehalten (ADR-Gedanke).
- Dokumentation folgt der Realität – nicht umgekehrt.

---

## 14. Release-Transparenz
- Releases/Backups werden reproduzierbar archiviert.
- `scripts/kpr.sh` (kompatibel via Root-Wrapper `kpr.sh`) erzeugt `.releases/Betankungen_<version>.tar` (Punkte -> `_`) aus `docs`, `src`, `units`.
- Hash + Metadaten werden in `.releases/release_log.json` geführt.
- Snapshot-Backups werden in `.backup/YYYY-MM-DD_HHMM` mit zentralem Register `.backup/index.json` geführt.

````

## Datei: `docs/README.md`

````markdown
# Betankungen
**Stand:** 2026-02-19
CLI-Projekt mit Free Pascal / Lazarus & SQLite

---

## Ziel

**Betankungen** ist ein terminalbasiertes CLI-Projekt, das schrittweise zu einer
real nutzbaren Anwendung wächst.

Der Fokus liegt bewusst auf:

- klarer Architektur
- sauberer Trennung von Verantwortung
- robuster, nachvollziehbarer Implementierung
- Wartbarkeit statt „Quick & Dirty“

Das Projekt ist **lernorientiert**, aber nicht als Spielzeug gedacht.

---

## Meta-Kommandos

- Hilfe: `Betankungen --help`
- Version: `Betankungen --version`
- About inkl. Danksagung: `Betankungen --about`

---

## Architektur – Überblick

- Terminalbasierte CLI-Anwendung (bewusst ohne GUI)
- SQLite als lokale Datenbank (eine Datei, kein Server)
- Modularer Aufbau mit klar getrennten Units
- Keine Fach- oder SQL-Logik im Hauptprogramm
- Demo-Datenbank fuer Tests und Vorfuehrungen (`--seed`, `--demo`)
- Frischer Start ohne Argumente initialisiert Config + DB automatisch (ohne "Kein Kommando")
- Fehlt nur die DB bei vorhandener Config, wird sie automatisch am konfigurierten Pfad erstellt

**Zentrale Idee:**
Das Hauptprogramm steuert – die Units arbeiten.

---

## Roadmap – Kurzstand

- `0.5.3`: Reifegrad & Vervollstaendigung (Struktur-Release, kein massiver Feature-Zuwachs)
- `0.5.4`: First-Run UX & Initialisierung (Default-DB ohne Konfig-Wissen, Prompt nur als Fallback)
- `0.5.5`: Jahres-Summary fuer Stats (`--yearly`) auf Basis der Monatsaggregation
- `0.5.6`: Help/Usage Rework (abgeschlossen)
- `0.5.6-0`: Zwischenversion fuer die Einfuehrung einer zusaetzlichen Unit (naechster Fokus)
- `0.6.0`: Fahrzeug-Domain konsolidieren (danach; stabile Grundlage, noch kein echtes Multi-Car-Feature)
- Wichtig: Jahres-Summary ist bewusst nicht Teil von `0.5.3`, sondern auf `0.5.5` verschoben.

Details und Fortschritt: `docs/STATUS.md` und `docs/ARCHITECTURE.md`.

---

## Projektstruktur

### Root-Ordner (Workflow ohne Git)
- `scripts/`: Wartungsskripte (Release/Backup/Netzwerkdiagnose)
- `migrations/`: manuelle SQL-Migrationen fuer Schema-Upgrades
- `knowledge_archive/`: Wissens-Archiv fuer verworfene oder spaeter nutzbare Snippets
- `.releases/`: finale Release-Artefakte (`.tar`) + `release_log.json`
- `.backup/`: zeitgestempelte Snapshot-Backups + `index.json`
- `tests/`: Smoke-/Plausibilitaetstests fuer den lokalen Workflow

### `Betankungen.lpr`
Einstiegspunkt und Orchestrator der Anwendung.

**Aufgaben**
- Parsen und Validieren der CLI-Argumente
- Aktivieren von Modus-Flags (`--debug`, `--trace`, `--quiet`, `--detail`)
- Initialisierung der SQLite-Datenbank
- Sicherstellen, dass genau **ein** Kommando ausgeführt wird
- Dispatch an die zuständigen Fach-Units
- Verwaltung der Demo-DB (Erzeugen via `--seed`, Nutzung via `--demo`)
- Ausgabe von Statistiken (`--stats fuelups`)

---

### `u_db_init.pas`
Technisches DB-Bootstrapping.

**Verantwortung**
- Anlegen der Datenbankdatei
- Erstellen und Aktualisieren des Schemas (idempotent)
- Pflege technischer Metadaten (`meta`)
- Schema-Versionierung (aktuell v4: `cars`, `fuelups.car_id`, `fuelups.missed_previous`)
- Migriert v3-Startwerte aus `meta` nach `cars.odometer_start_km` / `cars.odometer_start_date`

---

### `u_db_common.pas`
Zentrale Infrastruktur für Konsolen-Interaktion und striktes Daten-Parsing.

**Verantwortung**
- Eingabe-Helper (Pflicht/Optional/Keep)
- Validierung von Pflichtfeldern
- Fixed-Point-Parsing (EUR, Liter, EUR/L) ohne Float

---

### `u_db_seed.pas`
Demo-Datenbank-Modul.

**Verantwortung**
- Erzeugt/aktualisiert eine separate Demo-DB (`--seed`)
- Befüllt Demo-Daten für `stations` und `fuelups`
- Legt ein Default-Fahrzeug (`Hauptauto`) in `cars` inkl. Start-KM/-Datum an und befuellt `fuelups` mit `car_id`
- Seed-Befuellung nutzt einen groesseren Demo-Zeitraum (3-5 Jahre) und eine Zielmenge von 300-500 Fuelups
- Optionale Reproduktion via `--seed-value` und Reset via `--force`

---

### `u_log.pas`
Zentrale Logging- und Debug-Unit.

**Features**
- Trace-Ausgaben via `Dbg(...)` (nur bei `--trace`)
- Strukturierte Debug-Tabelle (`--debug`)
- Optionale ANSI-Farben
- Global steuerbar

---

### `u_fuelups.pas`
Fachlogik für Betankungen (`fuelups`).

**Funktionen**
- Hinzufügen
- Auflisten (Standard / Detail)
- Zuordnung zu Fahrzeugen (`car_id`, aktuell Default-Fahrzeug bei Single-Car-Workflow)
- Golden-Info-Flag `missed_previous` (vorheriger Tankstopp fehlt) wird bei grosser KM-Luecke gezielt abgefragt
- Plausibilitaetsregeln: `odometer_km >= car.odometer_start_km`, streng monoton pro Fahrzeug, Warnung bei sehr grosser Tankmenge
- Append-only (keine Edit/Delete)

---

### `u_stats.pas`
Statistik-Modul für Betankungen (`fuelups`).

**Funktionen**
- Volltank-Zyklus-Auswertung (`--stats fuelups`)
- Zeitraum, Strecke, Verbrauch, Kosten
- Zyklusbildung strikt pro Fahrzeug (`car_id`), keine Vermischung zwischen Autos
- `missed_previous=1` resettet die laufende Zyklus-Sammlung, um verfaelschte Zyklen zu vermeiden
- Tabellarische Zyklusliste inkl. Summenzeile (Standardmodus)
- Dashboard-Renderer (Unicode-Boxen) als alternative Textausgabe (`--stats fuelups --dashboard`)
- Dashboard nutzt Unicode + ANSI-Farben und ist fuer UTF-8-Terminals optimiert.
- JSON-Ausgabe (`--stats fuelups --json`, standardmaessig kompakt; Pretty optional via `--pretty`)
- CSV-Ausgabe (strict, maschinenlesbar) fuer Zyklen/Monate (`--stats fuelups --csv`)
- Monatsstatistik (`--stats fuelups --monthly`, Monats-Tabelle ohne Zyklusliste)
- JSON-Monatsausgabe (`--stats fuelups --json --monthly`, `kind: "fuelups_monthly"`)
- Jahresstatistik (`--stats fuelups --yearly`, Jahres-Tabelle auf Basis der Monatsaggregation)
- JSON-Jahresausgabe (`--stats fuelups --json --yearly`, `kind: "fuelups_yearly"`)
- Flag-Regeln fuer Yearly: exklusiv zu `--monthly`, nicht kombinierbar mit `--csv` oder `--dashboard`
- JSON-avg als scaled Integer: `avg_l_per_100km_x100`
- Debug: Effektiver Zeitraum wird einmalig nach der Kopf-Query geloggt (open-ended/closed, plus no-rows Hinweis)

Beispiele (Dashboard):
- `Betankungen --stats fuelups --dashboard`
- `Betankungen --stats fuelups --dashboard --from 2025-01 --to 2025-03`
- `Betankungen --stats fuelups --dashboard --monthly`

Beispiele (Yearly):
- `Betankungen --stats fuelups --yearly`
- `Betankungen --stats fuelups --json --yearly`

Beispiel (JSON, pretty formatiert, gekuerzt):
```json
{
  "kind": "fuelups_full_tank_cycles",
  "period": {"from": "2025-01-01 00:00:00", "to": "2025-02-28 23:59:59"},
  "fuelups_total": 12,
  "fuelups_full": 7,
  "cycles": [
    {"idx": 1, "dist_km": 523, "liters_ml": 38210, "avg_l_per_100km_x100": 731, "total_cents": 6245}
  ],
  "sum": {"cycles": 3, "dist_km": 1460, "liters_ml": 104900, "avg_l_per_100km_x100": 719, "total_cents_all": 18240, "total_cents_cycles": 17650}
}
```

Beispiel (JSON monthly, pretty formatiert, gekuerzt):
```json
{
  "kind": "fuelups_monthly",
  "period": {"from": "2025-01-01 00:00:00", "to": "2025-02-28 23:59:59"},
  "fuelups_total": 12,
  "fuelups_full": 7,
  "rows": [
    {"month":"2025-01", "dist_km": 523, "liters_ml": 38210, "avg_l_per_100km_x100": 731, "total_cents": 6245}
  ]
}
```

---

### `u_stations.pas`
Fachlogik für Tankstellen (`stations`).

**Funktionen**
- Hinzufügen
- Auflisten (Standard / Detail)
- Bearbeiten (Alt-/Neu-Vergleich)
- Löschen mit Sicherheitsabfrage

---

### `u_table.pas`
Leichter Tabellen-Renderer für kompakte CLI-Ausgaben.

**Funktionen**
- Spalten/Zeilen/Separatoren
- Kopf-/Footer-Rendering
- UTF-8-bewusste Breitenberechnung und Kuerzung fuer stabiles Layout bei Mehrbyte-Zeichen

---

### `u_fmt.pas`
Formatierungs- und Ausgabelogik für CLI.

**Funktionen**
- Fixed-Point-Formatter (Cents, ml, EUR/L)
- Fuelups-Tabellenlayout inkl. Detailzeilen
- Unicode-Box-Engine fuer Dashboards/kompakte Statusausgaben
- ANSI-sichere Box-Zeilen mit UTF-8-sichtbarer Breitenberechnung + Kosten-Balken (Dashboard-Bar)
- Dashboard-Farblogik umschaltbar: statische Cent-Schwellen oder relative Promille-Schwellen (gegen Max-Wert)
- CSV-Helper fuer strikt maschinenlesbare Zeilen (ohne Escaping)

---

## Werkzeuge

### `kpr.sh`
Release-Skript fuer das Projekt.
Hinweis: `kpr.sh` im Projektroot ist ein kompatibler Wrapper auf `scripts/kpr.sh`.

**Funktionen**
- Verwendet den Release-Ordner `.releases/` fuer finalisierte Release-Artefakte (`.tar`) und die JSON-Logdatei `release_log.json`
- Erstellt `.releases/Betankungen_<version>.tar` (Punkte durch `_`, z. B. `.releases/Betankungen_0_5_1.tar`) aus `docs`, `src`, `units`
- Schreibt Prüfsumme + Metadaten in `.releases/release_log.json`

### `scripts/backup_snapshot.sh`
Backup-Skript fuer zeitgestempelte Snapshots in `.backup/`.

**Funktionen**
- Legt Snapshot-Ordner nach Schema `YYYY-MM-DD_HHMM` an
- Kopiert ein Release-Archiv (`.tar`) und optional `.releases/release_log.json`
- Schreibt Snapshot-Metadaten in `metadata.json`
- Pflegt das zentrale Backup-Register `.backup/index.json`

### `scripts/net_recover.sh`
Netzwerkdiagnose mit optionalem Interface-Neustart bei "verbunden, aber kein Internet".

**Funktionen**
- Zeigt Link-, IP-, Route- und DNS-Status fuer das aktive Interface
- Fuehrt Konnektivitaetstests durch (Ping auf IP, DNS-Aufloesung, Ping auf Host)
- Startet das Interface neu (primaer via `nmcli`, sonst Fallback `ip link down/up`)
- Unterstuetzt `--info-only` fuer reine Diagnose ohne Neustart
- Unterstuetzt `--only-if-offline` fuer einen konditionalen Reset nur bei erkannten Fehlern

### `scripts/projekt_kontext.sh`
Session-Helfer fuer AI-Kontext am Ende/Anfang einer Coding-Session.

**Funktionen**
- Nutzt die Git-tracked Dateiliste (`git ls-files`) als Struktur wie auf GitHub
- Fuegt den aktuellen Arbeitsstand als `git status --short` ein
- Exportiert relevante Quellen in eine Markdown-Datei: `.pas`, `.lpr`, `.md`, `.sh`
- Schreibt standardmaessig nach `projekt_kontext.md` (optional eigener Ausgabepfad)
- Liefert zusaetzlich Repo-Metadaten (Root, Branch, Commit)

Beispiel:
- `scripts/projekt_kontext.sh`
- `scripts/projekt_kontext.sh /tmp/projekt_kontext.md`

### Restore
- Wiederherstellungsschritte sind in `docs/RESTORE.md` dokumentiert.

---

## Danksagung

Mein besonderer Dank waehrend der Entwicklungsphase geht an CFO Cookie,
meine 2 Jahre alte Shih-Tzu-Huendin. Mit ihrer Art hat sie mir oft mentale
und konstruktive Unterstuetzung gegeben: mal ablenkend, mal erdend, aber vor
allem mit viel Zuwendung auch in stressigen Phasen.

````

## Datei: `docs/RESTORE.md`

````markdown
# Restore-Anleitung
**Stand:** 2026-02-13

Diese Anleitung beschreibt den Wiederherstellungsprozess ohne Git.

## Voraussetzungen
- Verfuegbares Release-Archiv in `.releases/` oder Backup in `.backup/YYYY-MM-DD_HHMM/`.
- `tar` und ein SHA-256 Tool (`sha256sum` oder `shasum`).

## 1. Gewuenschten Stand auswaehlen
- Primärquelle: `.releases/Betankungen_<version>.tar`
- Alternativ: `.backup/YYYY-MM-DD_HHMM/Betankungen_<version>.tar`

Optional:
- Historie in `.releases/release_log.json` oder `.backup/index.json` prüfen.

## 2. Integritaet pruefen
Wenn die SHA-256 Summe bekannt ist:
- `sha256sum <archiv.tar>` oder `shasum -a 256 <archiv.tar>`
- Ergebnis mit dokumentierter Summe vergleichen.

## 3. Wiederherstellen
Im Projektroot ausfuehren:
- `tar -xf <archiv.tar>`

Das Archiv enthaelt standardmaessig:
- `docs/`
- `src/`
- `units/`

## 4. Plausibilitaetscheck
- Build/Run-Test starten (z. B. `bin/Betankungen --version` sofern vorhanden).
- Optional: `tests/smoke_cli.sh` ausfuehren.
- Doku-Stand und `docs/CHANGELOG.md` prüfen.

## 5. Optionalen Backup-Snapshot anlegen
Nach erfolgreichem Restore kann ein Snapshot angelegt werden:
- `scripts/backup_snapshot.sh --note "Nach Restore validiert"`

````

## Datei: `docs/STATUS.md`

````markdown
# Aktueller Projektstatus – Betankungen
**Stand:** 2026-02-19
**Zielversion:** 0.5.6-0

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
- Smoke-Checks unter `tests/smoke_cli.sh`

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
- Smoke-Abdeckung erweitert (`tests/smoke_cli.sh`, `tests/smoke_clean_home.sh`).

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

## Roadmap 0.5.6-0 – Zwischenversion Unit-Vorbereitung (naechster Fokus)
- Ziel: gezielte Zwischenversion vor 0.6.0 zur Einfuehrung einer zusaetzlichen Unit.
- Fokus: strukturierte Extraktion in eine neue Unit mit sauberer Verdrahtung im bestehenden CLI-Flow.
- Keine neue Fachlogik als Pflicht; Schwerpunkt auf Struktur, Lesbarkeit und wartbarer Zustandsfuehrung.

## Roadmap 0.6.0 – Fundament fuer Fahrzeug-Domain (geplant/konsolidierend, danach)
- Ziel: stabile Grundlage fuer spaeteres Multi-Car, ohne sofort Multi-Car-Feature auszurollen.
- Hinweis zum Ist-Stand: `cars`, `fuelups.car_id` und `missed_previous` sind im aktuellen Arbeitsstand bereits technisch vorhanden.
- 0.6.0 fokussiert die saubere fachliche Konsolidierung (Hauptauto-Flow, Migrationsregeln, Validierungsregeln, Gap-Semantik fuer Stats).
- Nicht-Ziele 0.6.0: keine GUI, keine Web-API, kein Subcommand-Umbau, kein Overengineering.

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
- Naechster Fokus: 0.5.6-0 (Zwischenversion fuer zusaetzliche Unit)
- Danach: 0.6.0 (Fahrzeug-Domain konsolidieren)
- Architektur & Prinzipien klar und konsistent
- Scope bleibt bewusst klein, explizit und testbar

````

## Datei: `knowledge_archive/README.md`

````markdown
# Knowledge Archive
**Stand:** 2026-02-13

Dieser Ordner ist ein Wissens-Archiv fuer Code-Snippets, die bewusst nicht in der finalen Implementierung gelandet sind.

## Zweck
- Ideen, Loesungsansaetze und verworfene Varianten nachvollziehbar aufbewahren.
- Bei spaeteren Refactors gezielt auf fruehere Ansätze zurueckgreifen.

## Ablage-Regeln
- Dateiname mit klarem Bezug zur Funktion, z. B. `archive_ParseEuroToCents.pas`.
- Jede Datei enthaelt kurz den Kontext (warum verworfen, wann hilfreich).
- Keine produktive Nutzung direkt aus diesem Ordner.

## Hinweis
Dieses Archiv ersetzt keine Release-Sicherung. Finale, reproduzierbare Staende liegen unter `.releases/` und `.backup/`.

````

## Datei: `knowledge_archive/archive_ExactlyOne.pas`

````pascal
{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : Betankungen.lpr
  REMOVED  : 2026-01-31
  REASON   : Umstellung auf internes Command-Modell
  CONTEXT  : Validierung, dass genau eine Kommando-Option gesetzt ist
  CONTEXT  : Kommando-Validierung (zuvor in der zentralen Ermittlung/Dispatch)
  BEISPIEL : if not ExactlyOne([IsAdd, IsList, IsDelete, IsEdit],
  BEISPIEL :   ['--add', '--list', '--delete', '--edit'], CmdError) then
  BEISPIEL :   FailUsage(CmdError);
}


// Stellt sicher, dass genau eine Kommando-Option gesetzt ist und liefert eine sprechende Fehlermeldung
  function ExactlyOne(const Flags: array of boolean; const Names: array of string;
    out ErrorMsg: string): boolean;
  var
    i, Count: integer;
  begin
    ErrorMsg := '';
    Count := 0;

    for i := Low(Flags) to High(Flags) do
      if Flags[i] then
      begin
        Inc(Count);
        if ErrorMsg <> '' then ErrorMsg := ErrorMsg + ' ';
        ErrorMsg := ErrorMsg + Names[i];
      end;

    if Count > 1 then
    begin
      ErrorMsg := 'Fehler: Diese Kommandos dürfen nicht zusammen verwendet werden: ' + ErrorMsg;
      Exit(False);
    end;

    if Count = 0 then
    begin
      ErrorMsg := 'Fehler: Kein Kommando angegeben.';
      Exit(False);
    end;

    Result := (Count = 1);
  end;

````

## Datei: `knowledge_archive/archive_ParseEurPerLiterToMilli.pas`

````pascal
{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : u_db_common.pas
  REMOVED  : 2026-01-21
  REASON   : Ersetzt durch stringbasiertes Parsing (bon-exakt)
  CONTEXT  : Prototyp-Funktion zur Umrechnung [EUR/L] > [ml]
}

function ParseEurPerLiterToMilli(const S: string): int64;
var
  LValue: Double;
  LSettings: TFormatSettings;
  LNormalizedS: string;
begin
  Result := 0;
  if Trim(S) = '' then Exit;

  // 1. Normalisierung: Komma zu Punkt wandeln
  LNormalizedS := StringReplace(S, ',', '.', [rfReplaceAll]);

  // 2. FormatSettings für punkt-basierte Konvertierung vorbereiten
  LSettings := DefaultFormatSettings; 
  LSettings.DecimalSeparator := '.';

  try
    // 3. String zu Fließkommazahl wandeln
    LValue := StrToFloat(LNormalizedS, LSettings);

    // 4. Negativ Eingaben abfangen
    if LValue < 0 then
      raise Exception.Create('ParseEurPerLiterToMilli: Wert darf nicht negativ sein');
    
    // 5. In Cents umrechnen und sicher runden
    Result := Round(LValue * 1000);
  except
    on E: EConvertError do
      raise Exception.Create('ParseLitersToMl: Ungültiger Wert ("' + S + '")');
  end;
end;
````

## Datei: `knowledge_archive/archive_ParseEuroToCents.pas`

````pascal
{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : u_db_common.pas
  REMOVED  : 2026-01-21
  REASON   : Ersetzt durch stringbasiertes Parsing (bon-exakt)
  CONTEXT  : Prototyp-Funktion zur Umrechnung [EUR] > [cent]
}

function ParseEuroToCents(const S: string): int64;
var
  LValue: Double;
  LSettings: TFormatSettings;
  LNormalizedS: string;
begin
  Result := 0;
  if Trim(S) = '' then Exit;

  // 1. Normalisierung: Komma zu Punkt wandeln
  LNormalizedS := StringReplace(S, ',', '.', [rfReplaceAll]);

  // 2. FormatSettings für punkt-basierte Konvertierung vorbereiten
  LSettings := DefaultFormatSettings; 
  LSettings.DecimalSeparator := '.';

  try
    // 3. String zu Fließkommazahl wandeln
    LValue := StrToFloat(LNormalizedS, LSettings);

    // 4. Negativ Eingaben abfangen
    if LValue < 0 then
      raise Exception.Create('ParseEuroToCents: Wert darf nicht negativ sein');
    
    // 5. In Cents umrechnen und sicher runden
    Result := Round(LValue * 100);
  except
    on E: EConvertError do
      raise Exception.Create('ParseLitersToMl: Ungültiger Wert ("' + S + '")');
  end;
end;
````

## Datei: `knowledge_archive/archive_ParseFlagWithArg.pas`

````pascal
{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : Betankungen.lpr
  REMOVED  : 2026-01-31
  REASON   : Umstellung auf internes Command-Modell (BuildCommand)
  CONTEXT  : CLI-Parsing: Option mit optionalem Argument (z. B. --add stations)
  BEISPIEL : if ParamStr(i) = '--add' then
  BEISPIEL :   ParseFlagWithArg('--add', IsAdd, TableName);
}


  // Liest eine Option mit optionalem Argument (z. B. --add stations)
  procedure ParseFlagWithArg(const Flag: string; var Enabled: boolean; var Arg: string);
  begin
    if ParamStr(i) = Flag then
    begin
      Enabled := True;
      if (i + 1 <= ParamCount) and (ParamStr(i + 1)[1] <> '-') then
      begin
        Inc(i);
        Arg := ParamStr(i);
      end;
    end;
  end;

````

## Datei: `knowledge_archive/archive_ParseLitersToMl.pas`

````pascal
{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : u_db_common.pas
  REMOVED  : 2026-01-21
  REASON   : Ersetzt durch stringbasiertes Parsing (bon-exakt)
  CONTEXT  : Prototyp-Funktion zur Umrechnung [L] > [ml]
}

function ParseLitersToMl(const S: string): int64;
var
  LValue: Double;
  LSettings: TFormatSettings;
  LNormalizedS: string;
begin
  Result := 0;
  if Trim(S) = '' then Exit;

  // 1. Normalisierung: Komma zu Punkt wandeln
  LNormalizedS := StringReplace(S, ',', '.', [rfReplaceAll]);

  // 2. FormatSettings für punkt-basierte Konvertierung vorbereiten
  LSettings := DefaultFormatSettings; 
  LSettings.DecimalSeparator := '.';

  try
    // 3. String zu Fließkommazahl wandeln
    LValue := StrToFloat(LNormalizedS, LSettings);
    
    // 4. Negativ Eingaben abfangen
    if LValue < 0 then
      raise Exception.Create('ParseLitersToMl: Wert darf nicht negativ sein');

    // 5. In Milliliter umrechnen und sicher runden
    Result := Round(LValue * 1000);
  except
    on E: EConvertError do
      raise Exception.Create('ParseLitersToMl: Ungültiger Wert ("' + S + '")');
  end;
end;
````

## Datei: `knowledge_archive/archive_ParseRequiredValueFlag.pas`

````pascal
{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : Betankungen.lpr
  REMOVED  : 2026-01-31
  REASON   : Umstellung auf internes Command-Modell (BuildCommand)
  CONTEXT  : CLI-Parsing: Option mit Pflicht-Argument (konsumiert Flag + Wert)
  BEISPIEL : if ParseRequiredValueFlag('--db', DbOverride) then
  BEISPIEL :   Continue;
}

  // Liest eine Option mit Pflicht-Argument und konsumiert Flag + Wert (Inc(i, 2))
  function ParseRequiredValueFlag(const Flag: string; var Value: string): boolean;
  begin
    Result := False;
    if ParamStr(i) = Flag then
    begin
      if i + 1 > ParamCount then
      begin
        FailUsage('Fehler: ' + Flag + ' benötigt einen Pfad.', Flag);
      end;
      Value := ParamStr(i + 1);
      Inc(i, 2);
      Result := True;
    end;
  end;

````

## Datei: `knowledge_archive/archive_ParseToMinorUnit.pas`

````pascal
{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : u_db_common.pas
  REMOVED  : 2026-01-21
  REASON   : Ersetzt durch stringbasiertes Parsing (bon-exakt)
  CONTEXT  : Prototyp-Funktion zur Vereinheitlichung von
             ParseEuroToCents / ParseEurPerLiterToMilli / ParseLitersToMl
}

function ParseToMinorUnit(const S: string; const AMultiplier: Integer): int64;
var
  LValue: Double;
  LSettings: TFormatSettings;
  LNormalizedS: string;
begin
  Result := 0;
  if Trim(S) = '' then Exit;

  LNormalizedS := StringReplace(S, ',', '.', [rfReplaceAll]);
  LSettings := DefaultFormatSettings; 
  LSettings.DecimalSeparator := '.';

  try
    LValue := StrToFloat(LNormalizedS, LSettings);

    // Negativ Eingaben abfangen
    if LValue < 0 then
      raise Exception.Create('ParseToMinorUnit: Wert darf nicht negativ sein');

    // Der Multiplikator bestimmt die Ziel-Einheit (100 für Cent, 1000 für Milli-Einheiten)
    Result := Round(LValue * AMultiplier);
  except
    on E: EConvertError do
      raise Exception.Create('Konvertierungsfehler bei Wert: ' + S);
  end;
end;
````

## Datei: `knowledge_archive/archive_TryParseFlag.pas`

````pascal
{ 
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : Betankungen.lpr
  REMOVED  : 2026-01-31
  REASON   : Umstellung auf internes Command-Modell (BuildCommand)
  CONTEXT  : CLI-Parsing: Einfaches Flag ohne Argument (z. B. --debug)
  BEISPIEL : if TryParseFlag('--debug', IsDebug) then
  BEISPIEL :   Continue;
}

  // Prueft einfache Optionen ohne Argument (z. B. --debug)
  function TryParseFlag(const Target: string; var FlagVar: boolean): boolean;
  begin
    Result := ParamStr(i) = Target;
    if Result then
      FlagVar := True;
  end;

````

## Datei: `kpr.sh`

````bash
#!/usr/bin/env bash
set -euo pipefail

# kpr.sh
# UPDATED: 2026-02-13
# Kompatibler Wrapper: delegiert auf scripts/kpr.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$ROOT_DIR/scripts/kpr.sh" "$@"

````

## Datei: `scripts/backup_snapshot.sh`

````bash
#!/usr/bin/env bash
set -euo pipefail

# backup_snapshot.sh
# UPDATED: 2026-02-13
# Erstellt einen Snapshot in .backup/YYYY-MM-DD_HHMM und pflegt .backup/index.json.

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_ROOT="$ROOT_DIR/.backup"
RELEASE_DIR="$ROOT_DIR/.releases"
INDEX_FILE="$BACKUP_ROOT/index.json"

ARCHIVE_INPUT=""
NOTE=""
DRY_RUN=false

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Backup-Snapshot von Release-Artefakten erstellen

Usage:
  $SCRIPT_NAME [options]

Options:
  -a, --archive FILE    Release-Archiv waehlen (Default: neuestes .releases/Betankungen_*.tar)
  --note TEXT           Optionaler Kommentar fuer index/metadaten
  -n, --dry-run         Nur anzeigen, nichts schreiben
  -h, --help            Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --archive .releases/Betankungen_0_5_2.tar --note "Vor Hotfix"
  $SCRIPT_NAME --dry-run
EOF_USAGE
}

die() {
  printf 'Fehler: %s\n' "$*" >&2
  exit 1
}

sha256_file() {
  local f="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$f" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$f" | awk '{print $1}'
  else
    die "Kein SHA-256 Tool gefunden (sha256sum/shasum)."
  fi
}

resolve_archive() {
  local input="$1"

  if [[ -n "$input" ]]; then
    if [[ -f "$input" ]]; then
      printf '%s\n' "$input"
      return
    fi
    if [[ -f "$RELEASE_DIR/$input" ]]; then
      printf '%s\n' "$RELEASE_DIR/$input"
      return
    fi
    die "Archiv nicht gefunden: $input"
  fi

  local latest
  latest="$(find "$RELEASE_DIR" -maxdepth 1 -type f -name 'Betankungen_*.tar' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | awk '{print $2}')"
  [[ -n "$latest" ]] || die "Kein Release-Archiv in $RELEASE_DIR gefunden."
  printf '%s\n' "$latest"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -a|--archive)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument (Datei)."
      ARCHIVE_INPUT="$2"
      shift 2
      ;;
    --note)
      [[ $# -ge 2 ]] || die "Option $1 braucht einen Text."
      NOTE="$2"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unbekannte Option: $1 (nutze --help)"
      ;;
  esac
done

[[ -d "$RELEASE_DIR" ]] || die ".releases/ nicht gefunden."
mkdir -p "$BACKUP_ROOT"

ARCHIVE_PATH="$(resolve_archive "$ARCHIVE_INPUT")"
ARCHIVE_NAME="$(basename "$ARCHIVE_PATH")"
STAMP="$(date '+%Y-%m-%d_%H%M')"
TS="$(date '+%Y-%m-%d %H:%M:%S')"
TARGET_DIR="$BACKUP_ROOT/$STAMP"
TARGET_ARCHIVE="$TARGET_DIR/$ARCHIVE_NAME"
TARGET_LOG="$TARGET_DIR/release_log.json"
TARGET_META="$TARGET_DIR/metadata.json"

SHA256="$(sha256_file "$ARCHIVE_PATH")"
SIZE_BYTES="$(stat -c %s "$ARCHIVE_PATH")"

if $DRY_RUN; then
  printf 'Dry-Run: wuerde Backup-Verzeichnis anlegen: %s\n' "$TARGET_DIR"
  printf 'Dry-Run: wuerde Archiv kopieren: %s -> %s\n' "$ARCHIVE_PATH" "$TARGET_ARCHIVE"
  if [[ -f "$RELEASE_DIR/release_log.json" ]]; then
    printf 'Dry-Run: wuerde Log kopieren: %s -> %s\n' "$RELEASE_DIR/release_log.json" "$TARGET_LOG"
  else
    printf 'Dry-Run: release_log.json nicht vorhanden, wird ausgelassen.\n'
  fi
  printf 'Dry-Run: wuerde Metadaten schreiben: %s\n' "$TARGET_META"
  printf 'Dry-Run: wuerde Index aktualisieren: %s\n' "$INDEX_FILE"
  exit 0
fi

mkdir -p "$TARGET_DIR"
cp "$ARCHIVE_PATH" "$TARGET_ARCHIVE"
if [[ -f "$RELEASE_DIR/release_log.json" ]]; then
  cp "$RELEASE_DIR/release_log.json" "$TARGET_LOG"
fi

python3 - <<'PY' \
  "$INDEX_FILE" "$TARGET_META" "$TS" "$STAMP" "$ARCHIVE_NAME" "$SHA256" "$SIZE_BYTES" \
  "${ARCHIVE_PATH#$ROOT_DIR/}" "${RELEASE_DIR#$ROOT_DIR/}/release_log.json" "$NOTE"
import json
import pathlib
import sys

index_file = pathlib.Path(sys.argv[1])
meta_file = pathlib.Path(sys.argv[2])
updated = sys.argv[3]
snapshot_id = sys.argv[4]
archive_name = sys.argv[5]
sha256 = sys.argv[6]
size_bytes = int(sys.argv[7])
source_archive = sys.argv[8]
source_release_log = sys.argv[9]
note = sys.argv[10]

entry = {
    "id": snapshot_id,
    "created_at": updated,
    "archive": archive_name,
    "archive_sha256": sha256,
    "archive_size_bytes": size_bytes,
    "path": f".backup/{snapshot_id}",
    "note": note,
}

meta = {
    "id": snapshot_id,
    "created_at": updated,
    "archive": archive_name,
    "archive_sha256": sha256,
    "archive_size_bytes": size_bytes,
    "source_archive": source_archive,
    "source_release_log": source_release_log,
    "note": note,
}
meta_file.write_text(json.dumps(meta, ensure_ascii=False, indent=2) + "\n")

data = {"schema": "backup_index_v1", "updated": updated, "entries": []}
if index_file.exists():
    try:
        loaded = json.loads(index_file.read_text())
        if isinstance(loaded, dict):
            data["schema"] = loaded.get("schema", "backup_index_v1")
            data["entries"] = loaded.get("entries", []) if isinstance(loaded.get("entries", []), list) else []
    except Exception:
        pass

entries = [e for e in data["entries"] if isinstance(e, dict) and e.get("id") != entry.get("id")]
entries.append(entry)
data["entries"] = sorted(entries, key=lambda e: str(e.get("id", "")), reverse=True)
data["updated"] = updated

index_file.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY

printf 'OK: Backup erstellt: %s\n' "$TARGET_DIR"
printf 'Index: %s\n' "$INDEX_FILE"

````

## Datei: `scripts/kpr.sh`

````bash
#!/usr/bin/env bash
set -euo pipefail

# kpr.sh
# UPDATED: 2026-02-13
# Release-Archiv + Log (Tag-Ersatz ohne Git)

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RELEASE_DIR="$ROOT_DIR/.releases"

APP_VERSION=""
VERSION_TAG=""

if [[ -f "$ROOT_DIR/src/Betankungen.lpr" ]]; then
  APP_VERSION="$(awk -F"'" '/APP_VERSION/ {print $2; exit}' "$ROOT_DIR/src/Betankungen.lpr")"
fi
if [[ -z "$APP_VERSION" ]]; then APP_VERSION="unknown"; fi
VERSION_TAG="${APP_VERSION//./_}"

ARCHIVE_NAME="Betankungen_${VERSION_TAG}.tar"
ARCHIVE_PATH="$RELEASE_DIR/$ARCHIVE_NAME"
LOG_FILE="$RELEASE_DIR/release_log.json"
ARCHIVE_OUT_SET=false

NOTE=""
DRY_RUN=false

usage() {
  cat <<EOF
$SCRIPT_NAME - Release-Archiv erzeugen + Release-Log schreiben

Usage:
  $SCRIPT_NAME [options]

Options:
  -n, --dry-run         Nur anzeigen (kein Archiv/Log wird geschrieben)
  -o, --out FILE        Archivpfad ueberschreiben (Default: $ARCHIVE_PATH)
  --note TEXT           Optionaler Release-Kommentar
  -h, --help            Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --note "Release 0.5.1"
  $SCRIPT_NAME --dry-run
EOF
}

die() {
  printf 'Fehler: %s\n' "$*" >&2
  exit 1
}

json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

sha256_file() {
  local f="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$f" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$f" | awk '{print $1}'
  else
    die "Kein SHA-256 Tool gefunden (sha256sum/shasum)."
  fi
}

append_log() {
  local entry="$1"
  if [[ ! -f "$LOG_FILE" || ! -s "$LOG_FILE" ]]; then
    printf '[\n%s\n]\n' "$entry" > "$LOG_FILE"
    return
  fi

  local tmp
  tmp="$(mktemp)"
  python3 - <<'PY' "$LOG_FILE" "$tmp"
import json, sys, pathlib
src = pathlib.Path(sys.argv[1])
dst = pathlib.Path(sys.argv[2])
try:
    data = json.loads(src.read_text())
except Exception:
    data = []
dst.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
PY

  if grep -q '{' "$tmp"; then
    sed '$d' "$tmp" > "$LOG_FILE"
    printf ',\n%s\n]\n' "$entry" >> "$LOG_FILE"
  else
    printf '[\n%s\n]\n' "$entry" > "$LOG_FILE"
  fi
  rm -f "$tmp"
}

normalize_log() {
  if command -v python3 >/dev/null 2>&1; then
    python3 - <<'PY' "$LOG_FILE"
import json, pathlib, sys
p = pathlib.Path(sys.argv[1])
if not p.exists():
    raise SystemExit(0)
try:
    data = json.loads(p.read_text())
except Exception:
    data = []
p.write_text(json.dumps(data, ensure_ascii=False, separators=(',', ':')) + "\n")
PY
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -o|--out)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument (Archivpfad)."
      ARCHIVE_PATH="$2"
      ARCHIVE_NAME="$(basename "$ARCHIVE_PATH")"
      ARCHIVE_OUT_SET=true
      shift 2
      ;;
    --note)
      [[ $# -ge 2 ]] || die "Option $1 braucht einen Text."
      NOTE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unbekannte Option: $1 (nutze --help)"
      ;;
  esac
done

[[ -d "$ROOT_DIR/docs" ]] || die "docs/ nicht gefunden."
[[ -d "$ROOT_DIR/src" ]] || die "src/ nicht gefunden."
[[ -d "$ROOT_DIR/units" ]] || die "units/ nicht gefunden."
mkdir -p "$RELEASE_DIR"

mapfile -d '' FILES < <(cd "$ROOT_DIR" && find docs src units -type f -print0 | sort -z)
(( ${#FILES[@]} > 0 )) || die "Keine Dateien in docs/src/units gefunden."

if $DRY_RUN; then
  printf 'Dry-Run: wuerde Archiv erstellen: %s\n' "$ARCHIVE_PATH"
else
  mkdir -p "$(dirname "$ARCHIVE_PATH")"
  tar -cf "$ARCHIVE_PATH" -C "$ROOT_DIR" docs src units
fi

if $DRY_RUN; then
  printf 'Dry-Run: wuerde release_log.json aktualisieren: %s\n' "$LOG_FILE"
  exit 0
fi

TS="$(date '+%Y-%m-%d %H:%M:%S')"
RUN_ID="$(date '+%Y%m%dT%H%M%S')-$$"
SHA256="$(sha256_file "$ARCHIVE_PATH")"
SIZE_BYTES="$(stat -c %s "$ARCHIVE_PATH")"

FILES_JSON=""
for f in "${FILES[@]}"; do
  esc="$(json_escape "$f")"
  if [[ -n "$FILES_JSON" ]]; then
    FILES_JSON+=", "
  fi
  FILES_JSON+="\"$esc\""
done

NOTE_JSON="$(json_escape "$NOTE")"
SUMMARY_TEXT="Release $APP_VERSION | $ARCHIVE_NAME | sha256=$SHA256 | files=${#FILES[@]} | $TS"
SUMMARY_JSON="$(json_escape "$SUMMARY_TEXT")"

ENTRY="  {\"run_id\":\"$RUN_ID\",\"timestamp\":\"$TS\",\"version\":\"$APP_VERSION\",\"archive\":\"$ARCHIVE_NAME\",\"sha256\":\"$SHA256\",\"size_bytes\":$SIZE_BYTES,\"sources\":[\"docs\",\"src\",\"units\"],\"file_count\":${#FILES[@]},\"files\":[${FILES_JSON}],\"note\":\"$NOTE_JSON\",\"summary\":\"$SUMMARY_JSON\"}"

append_log "$ENTRY"
normalize_log

printf 'OK: %s (sha256=%s)\n' "$ARCHIVE_NAME" "$SHA256"
printf 'Log: %s\n' "$LOG_FILE"
printf 'Summary: %s\n' "$SUMMARY_TEXT"

````

## Datei: `scripts/net_recover.sh`

````bash
#!/usr/bin/env bash
set -euo pipefail

# net_recover.sh
# UPDATED: 2026-02-17
# Zeigt Netzwerkdiagnose und startet bei Bedarf das aktive Interface neu.

SCRIPT_NAME="$(basename "$0")"
IFACE=""
PING_IP="1.1.1.1"
PING_DNS="example.com"
WAIT_SECONDS=4
ONLY_INFO=false
ONLY_IF_OFFLINE=false
LAST_CONNECTIVITY_OK=false

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Netzwerkdiagnose + Interface-Reset

Usage:
  $SCRIPT_NAME [options]

Options:
  -i, --iface NAME      Interface explizit setzen (z. B. wlan0, enp3s0)
      --ping-ip IP      Ping-Test auf IP (Default: $PING_IP)
      --ping-dns HOST   DNS/Ping-Test auf Host (Default: $PING_DNS)
      --wait SEC        Wartezeit nach Reset (Default: $WAIT_SECONDS)
      --only-if-offline Reset nur dann ausfuehren, wenn Checks fehlschlagen
      --info-only       Nur Infos anzeigen, kein Neustart
  -h, --help            Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --iface wlan0
  $SCRIPT_NAME --info-only
EOF_USAGE
}

log() {
  printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

warn() {
  printf '[WARN] %s\n' "$*" >&2
}

die() {
  printf 'Fehler: %s\n' "$*" >&2
  exit 1
}

run_as_root() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
    return
  fi
  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
    return
  fi
  die "Fuer diese Aktion wird root oder sudo benoetigt: $*"
}

require_base_tools() {
  command -v ip >/dev/null 2>&1 || die "'ip' wurde nicht gefunden (iproute2 fehlt)."
}

detect_iface() {
  if [[ -n "$IFACE" ]]; then
    return
  fi

  IFACE="$(ip route show default 2>/dev/null | awk '/default/ {print $5; exit}' || true)"
  if [[ -z "$IFACE" ]]; then
    IFACE="$(ip -o link show 2>/dev/null | awk -F': ' '$2 != "lo" {print $2; exit}' || true)"
  fi
  [[ -n "$IFACE" ]] || die "Kein Netzwerk-Interface gefunden. Nutze --iface NAME."
}

check_connectivity() {
  local phase="$1"
  local failed=0
  printf '\n-- Konnektivitaet (%s) --\n' "$phase"

  if command -v ping >/dev/null 2>&1; then
    if ping -c1 -W2 "$PING_IP" >/dev/null 2>&1; then
      printf '[OK] Ping IP %s\n' "$PING_IP"
    else
      printf '[FAIL] Ping IP %s\n' "$PING_IP"
      failed=$((failed + 1))
    fi
  else
    printf '[WARN] ping nicht installiert, IP-Test uebersprungen\n'
    failed=$((failed + 1))
  fi

  if command -v getent >/dev/null 2>&1; then
    if getent hosts "$PING_DNS" >/dev/null 2>&1; then
      printf '[OK] DNS-Aufloesung %s\n' "$PING_DNS"
    else
      printf '[FAIL] DNS-Aufloesung %s\n' "$PING_DNS"
      failed=$((failed + 1))
    fi
  else
    printf '[WARN] getent nicht installiert, DNS-Aufloesung uebersprungen\n'
    failed=$((failed + 1))
  fi

  if command -v ping >/dev/null 2>&1; then
    if ping -c1 -W2 "$PING_DNS" >/dev/null 2>&1; then
      printf '[OK] Ping Host %s\n' "$PING_DNS"
    else
      printf '[FAIL] Ping Host %s\n' "$PING_DNS"
      failed=$((failed + 1))
    fi
  fi

  if [[ "$failed" -eq 0 ]]; then
    LAST_CONNECTIVITY_OK=true
  else
    LAST_CONNECTIVITY_OK=false
  fi
}

print_diag() {
  local phase="$1"
  printf '\n=== %s (%s) ===\n' "$phase" "$(date '+%Y-%m-%d %H:%M:%S')"
  printf 'Host: %s\n' "$(hostname)"
  printf 'Interface: %s\n' "$IFACE"

  printf '\n-- Link --\n'
  ip -br link show dev "$IFACE" || true

  printf '\n-- Adressen --\n'
  ip -br addr show dev "$IFACE" || true

  printf '\n-- Routing (default) --\n'
  ip route show default || true

  printf '\n-- DNS (/etc/resolv.conf) --\n'
  if [[ -r /etc/resolv.conf ]]; then
    grep -E '^(nameserver|search|options)' /etc/resolv.conf || cat /etc/resolv.conf
  else
    printf 'Nicht lesbar.\n'
  fi

  if command -v nmcli >/dev/null 2>&1; then
    printf '\n-- NetworkManager --\n'
    nmcli -t -f GENERAL.STATE,GENERAL.CONNECTION device show "$IFACE" 2>/dev/null || true
  fi

  check_connectivity "$phase"
}

restart_iface() {
  log "Starte Interface '$IFACE' neu ..."

  if command -v nmcli >/dev/null 2>&1 && command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active --quiet NetworkManager; then
      log "Nutze NetworkManager (disconnect/connect)."
      nmcli device disconnect "$IFACE" >/dev/null 2>&1 || warn "Disconnect meldete Fehler."
      sleep 2
      nmcli device connect "$IFACE" >/dev/null 2>&1 || warn "Connect meldete Fehler."
      sleep "$WAIT_SECONDS"
      return
    fi
  fi

  log "Fallback: ip link down/up (ggf. sudo Passwort)."
  run_as_root ip link set dev "$IFACE" down
  sleep 2
  run_as_root ip link set dev "$IFACE" up
  sleep "$WAIT_SECONDS"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--iface)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument."
      IFACE="$2"
      shift 2
      ;;
    --ping-ip)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument."
      PING_IP="$2"
      shift 2
      ;;
    --ping-dns)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument."
      PING_DNS="$2"
      shift 2
      ;;
    --wait)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument."
      WAIT_SECONDS="$2"
      shift 2
      ;;
    --info-only)
      ONLY_INFO=true
      shift
      ;;
    --only-if-offline)
      ONLY_IF_OFFLINE=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unbekannte Option: $1 (nutze --help)"
      ;;
  esac
done

require_base_tools
detect_iface

print_diag "Vorher"

if $ONLY_INFO; then
  log "Info-only aktiv, kein Neustart."
  exit 0
fi

if $ONLY_IF_OFFLINE && $LAST_CONNECTIVITY_OK; then
  log "Konnektivitaet ist bereits OK, kein Neustart."
  exit 0
fi

restart_iface
print_diag "Nachher"

if $ONLY_IF_OFFLINE; then
  if $LAST_CONNECTIVITY_OK; then
    log "Nach Reset ist die Konnektivitaet wieder OK."
  else
    warn "Nach Reset bestehen weiterhin Probleme."
  fi
fi

log "Fertig."

````

## Datei: `src/Betankungen.lpr`

````pascal
{
  Betankungen.lpr
  ---------------------------------------------------------------------------
  CREATED: 2026-01-19
  UPDATED: 2026-02-19
  AUTHOR : Christof Kempinski
  Haupteinstiegspunkt und Kommandozeilen-Schnittstelle (CLI) der
  Betankungs-Verwaltung.

  Verantwortlichkeiten:
  - CLI-Steuerung: ParseCommand (Parsing + Regelpruefung) und
    Steuerung des Programmflusses (Hinzufuegen, Auflisten, Bearbeiten, Loeschen).
  - Demo-Datenbank: Erstellen/aktualisieren der Demo-DB (--seed) und Nutzung
    der Demo-DB fuer einen Lauf (--demo).
  - Konfigurations-Management: XDG-konforme Persistenz von DB-Pfaden per INI
    sowie direkte Speicherung via --db-set.
  - Zustandspruefung: Exklusivitaet von Kommandos, Konfliktpruefung bei DB-Optionen
    sowie Validierung erforderlicher Argumente (ParseCommand).
  - Abhaengigkeitsinjektion: Initialisierung der Datenbankverbindung und
    Weitergabe des Pfad-Kontexts an die zustaendigen Fachmodule.
  - Help-Delegation: Weitergabe von Usage/Help/About/FailUsage an `u_cli_help`
    (inkl. Fokus-Mapping ueber `TErrorFocus` aus `u_cli_types`).
  - Typkonsistenz: Nutzung zentraler CLI-Typen aus `u_cli_types`
    (TCommand, TCommandKind, TTableKind, TErrorFocus).
  - Statistik-Dispatch: Weiterleitung von Zeitraum-, Monats- und Jahresoptionen
    fuer `--stats fuelups` (Text/Dashboard/JSON/CSV, JSON optional pretty).

  Betriebsmodi:
  - Bootstrap-Modus: Aufruf ohne Argumente initialisiert fehlende Config/DB still.
  - Interaktiver Fallback-Modus: Pfadabfrage nur bei nicht nutzbarem DB-Pfad.
  - Automatisierter Modus: Direkte Ausfuehrung ueber Schalter fuer Skripte/Fortgeschrittene.
  - Diagnose-Modus: Integrierte Hilfe- und Konfigurationsanzeige (--show-config).
  - Meta-Modus: Ausgabe von Hilfe (--help), Version (--version) und About (--about).
  - Trace-Modus: Einfache Laufzeitmeldungen ueber --trace.
  - Demo-Modus: Nutzung einer separaten Demo-DB (--demo) oder Aufbau per --seed.

  Tabellen / Operationen:
  - Stations: hinzufuegen/auflisten/bearbeiten/loeschen
  - Fuelups: hinzufuegen/auflisten (nur anhaengen)

  Design-Entscheidungen:
  - Minimalismus: Das Hauptprogramm enthaelt keine SQL-Statements oder
    Berechnungslogik; es fungiert rein als Weiterleiter.
  - Zustandszentriert: Parserzustand liegt in `TCommand` und steuert
    Validierung, Meta-Pfade und Fach-Dispatch deterministisch.
  - Fehlersicherheit: Verwendung von EXIT_* bei Parametrierungsfehlern zur
    Unterstuetzung von Shell-Verarbeitungsketten.
  - Ausgabe-Trennung: Help/Usage/About-Textbausteine liegen ausserhalb des
    Orchestrators in `u_cli_help`; Parsing/Regelwerk in `u_cli_parse`.

  Exit-Codes:
  - 0 OK
  - 1 CLI / Argumentfehler
  - 2 Config / Datei / Pfad
  - 3 DB / SQL
  - 4 Unerwarteter Laufzeitfehler

  Exit-Code-Konstanten:
  - EXIT_OK = 0
  - EXIT_CLI = 1
  - EXIT_CONFIG = 2
  - EXIT_DB = 3
  - EXIT_UNEXPECTED = 4

  Konfigurationspfade (XDG):
  - Config-Datei: ~/.config/Betankungen/config.ini
  - Standard-DB:  ~/.local/share/Betankungen/betankungen.db
  - Demo-DB:      ~/.local/share/Betankungen/betankungen_demo.db
  ---------------------------------------------------------------------------
}
program Betankungen;

{$mode objfpc}{$H+}

uses
  SysUtils,
  IniFiles,
  u_db_init,
  u_db_seed,
  u_log,
  u_stations,
  u_fuelups,
  u_stats,
  u_cli_help,
  u_cli_types,
  u_cli_parse;

const
  EXIT_OK = 0;
  EXIT_CLI = 1;
  EXIT_CONFIG = 2;
  EXIT_DB = 3;
  EXIT_UNEXPECTED = 4;
  
  // Anwendungsmetadaten fuer --version/--about
  APP_NAME    = 'Betankungen';
  APP_VERSION = '0.5.6';
  APP_AUTHOR  = 'Christof Kempinski';

var
  // Pfad zur SQLite-Datenbank
  DbPath: string;
  WasCreated: boolean;
  NoCommandInitNeeded: boolean;
  CfgDbPath: string;

  // First-Run / Config-Status (0.5.4)
  CfgExisted: boolean;
  FirstRun: boolean;

  // Zentrales Parser-Ergebnis (Definition in u_cli_types).
  Cmd: TCommand;

  // ----------------
  // XDG-konformer Standard-DB-Pfad
  function GetDefaultDbPath: string;
  var
    BaseDir: string;
  begin
    BaseDir := ExpandFileName(GetUserDir + '.local/share/Betankungen');
    Result := BaseDir + PathDelim + 'betankungen.db';
  end;

  // XDG-konformer Konfigurationspfad
  function GetConfigPath: string;
  var
    CfgDir: string;
  begin
    CfgDir := ExpandFileName(GetUserDir + '.config/Betankungen');
    Result := CfgDir + PathDelim + 'config.ini';
  end;

  function LoadDbPathFromConfig(out APath: string): boolean;
  var
    Ini: TIniFile;
    Cfg: string;
  begin
    APath := '';
    Cfg := GetConfigPath;
    Result := FileExists(Cfg);
    if not Result then Exit;

    Ini := TIniFile.Create(Cfg);
    try
      APath := Ini.ReadString('database', 'path', '');
      Result := APath <> '';
    finally
      Ini.Free;
    end;
  end;

  procedure SaveDbPathToConfig(const APath: string);
  var
    Ini: TIniFile;
    CfgPath: string;
  begin
    CfgPath := GetConfigPath;
    ForceDirectories(ExtractFileDir(CfgPath));
    Ini := TIniFile.Create(CfgPath);
    try
      Ini.WriteString('database', 'path', APath);
    finally
      Ini.Free;
    end;
  end;

  procedure ShowConfigAndExit;
  var
    CfgPath, CfgDbPath, DefaultDb: string;
  begin
    CfgPath := GetConfigPath;
    DefaultDb := GetDefaultDbPath;

    WriteLn('--- Betankungen: Config-Status ---');
    WriteLn('Config-Datei:      ', CfgPath);
    WriteLn('Config existiert:   ', BoolToStr(FileExists(CfgPath), True));

    if LoadDbPathFromConfig(CfgDbPath) then
    begin
      CfgDbPath := ExpandFileName(CfgDbPath);
      WriteLn('Config DB-Pfad:     ', CfgDbPath);
      WriteLn('DB existiert:       ', BoolToStr(FileExists(CfgDbPath), True));
    end
    else
    begin
      WriteLn('Config DB-Pfad:     (nicht gesetzt)');
    end;

    WriteLn('Default DB-Pfad:    ', DefaultDb);
    WriteLn('Default existiert:  ', BoolToStr(FileExists(DefaultDb), True));
    WriteLn('---------------------------------');
    Halt(EXIT_OK);
  end;

  procedure ResetConfigAndExit;
  var
    CfgPath: string;
  begin
    CfgPath := GetConfigPath;

    if FileExists(CfgPath) then
    begin
      if DeleteFile(CfgPath) then
        WriteLn('Config geloescht: ', CfgPath)
      else
        FailUsage('Konnte Config nicht loeschen: ' + CfgPath, efMeta, EXIT_CONFIG);
    end
    else
      Msg('Keine Config vorhanden (nichts zu loeschen).');

    Msg('Hinweis: Die DB-Datei wurde NICHT geloescht.');
    Halt(EXIT_OK);
  end;

  // Interaktive Abfrage des DB-Pfads (Eingabetaste = Standard)
  // Hinweis: Validierung/Retry erfolgt in der Provisionierungs-Phase (EnsureDatabase-Loop).
  function AskDbPathInteractive: string;
  var
    DefaultPath: string;
    Input: string;
  begin
    DefaultPath := GetDefaultDbPath;

    WriteLn('DB-Pfad konnte nicht verwendet werden.');
    WriteLn('Bitte DB-Pfad angeben oder Enter fuer Default:');
    WriteLn('  Default: ', DefaultPath);
    Write('DB-Pfad> ');
    ReadLn(Input);

    Input := Trim(Input);
    if Input = '' then
      Result := DefaultPath
    else
      Result := ExpandFileName(Input);
  end;

  // Interaktiver Fallback mit persistenter Speicherung (inkl. Retry bei ungueltigem/unbeschreibbarem Pfad)
  procedure PromptAndPersistDbPath(out APath: string);
  var
    Candidate: string;
  begin
    while True do
    begin
      Candidate := AskDbPathInteractive;
      try
        ForceDirectories(ExtractFileDir(Candidate));
        SaveDbPathToConfig(Candidate);
        APath := Candidate;
        Exit;
      except
        on E: Exception do
        begin
          Msg('Warnung: DB-Pfad konnte nicht gespeichert werden: ' + Candidate);
          Msg('Grund: ' + E.Message);
        end;
      end;
    end;
  end;

  // Ermittelt den endgueltigen DB-Pfad in fester Prioritaet (db-set, db, demo/seed, config, default)
  // 0.5.4: Kein Prompt mehr im Normalfall. Prompt nur als Fallback wenn Provisionierung fehlschlaegt.
  function ResolveDbPath: string;
  var
    FromCfg: string;
    DefaultPath: string;
  begin
    // --db: nur fuer diesen Lauf
    if Cmd.DbOverride <> '' then
    begin
      Result := ExpandFileName(Cmd.DbOverride);
      ForceDirectories(ExtractFileDir(Result));
      Exit;
    end;

    // Demo-DB: explizit via --demo oder implizit via --seed
    if Cmd.UseDemoDb or (Cmd.HasCommand and (Cmd.Kind = ckSeed)) then
    begin
      Result := GetDefaultDemoDbPath;
      ForceDirectories(ExtractFileDir(Result));
      Exit;
    end;

    // Konfiguration
    if LoadDbPathFromConfig(FromCfg) then
    begin
      FromCfg := ExpandFileName(FromCfg);
      // 0.5.4: Config-Pfad immer akzeptieren, auch wenn DB (noch) nicht existiert.
      // Die DB wird spaeter automatisch angelegt.
      if (not FileExists(FromCfg)) then
        Msg('Hinweis: Konfiguration gefunden, aber DB-Datei existiert nicht (wird neu angelegt): ' + FromCfg);
      Result := FromCfg;
      ForceDirectories(ExtractFileDir(Result));
      Exit;
    end;

    // 0.5.4: Standardpfad immer verwenden (auch wenn DB noch nicht existiert)
    DefaultPath := GetDefaultDbPath;
    Result := DefaultPath;
    ForceDirectories(ExtractFileDir(Result));
    SaveDbPathToConfig(Result);
    FirstRun := True;
  end;

begin
  // 0.5.4: Kein Kommando + fehlender Bootstrap -> stille Initialisierung.
  // Deckt Erststart und "Config vorhanden, DB fehlt" ohne Prompt/Fehler ab.
  NoCommandInitNeeded := False;
  if ParamCount = 0 then
  begin
    if not LoadDbPathFromConfig(CfgDbPath) then
      NoCommandInitNeeded := True
    else
    begin
      CfgDbPath := ExpandFileName(CfgDbPath);
      NoCommandInitNeeded := not FileExists(CfgDbPath);
    end;
  end;

  if NoCommandInitNeeded then
  begin
    SetQuiet(True);
    try
      // identischer Flow wie im regulären Pfad, aber ohne Kommandopflicht
      try
        DbPath := ResolveDbPath;
      except
        on E: Exception do
        begin
          PromptAndPersistDbPath(DbPath);
          FirstRun := True;
        end;
      end;

      while True do
      begin
        try
          EnsureDatabase(DbPath);
          Break;
        except
          on E: Exception do
          begin
            PromptAndPersistDbPath(DbPath);
          end;
        end;
      end;

      Halt(EXIT_OK);
    except
      on E: Exception do
      begin
        FailUsage(E.Message, efNone, EXIT_UNEXPECTED);
      end;
    end;
  end;

  Cmd := ParseCommand;
  if Cmd.ErrorMsg <> '' then
    FailUsage(Cmd.ErrorMsg, Cmd.ErrorFocus);

  // Quiet zuerst, damit alles danach darauf reagiert
  SetQuiet(Cmd.Quiet);
  // Debug-Tabelle
  SetDebug(Cmd.Debug);
  // Trace explizit nur bei --trace
  SetTrace(Cmd.Trace);
  Dbg(
    'Cmd: Kind=' + IntToStr(Ord(Cmd.Kind)) +
    ' Target=' + IntToStr(Ord(Cmd.Target)) +
    ' Detail=' + BoolToStr(Cmd.Detail, True) +
    ' Json=' + BoolToStr(Cmd.Json, True) +
    ' Monthly=' + BoolToStr(Cmd.Monthly, True) +
    ' Yearly=' + BoolToStr(Cmd.Yearly, True) +
    ' Csv=' + BoolToStr(Cmd.Csv, True) +
    ' Dashboard=' + BoolToStr(Cmd.Dashboard, True) +
    ' Pretty=' + BoolToStr(Cmd.Pretty, True) +
    ' DbOverride=' + BoolToStr(Cmd.DbOverride <> '', True) +
    ' UseDemoDb=' + BoolToStr(Cmd.UseDemoDb, True)
  );

  if Cmd.Help then
  begin
    PrintUsage;
    Halt(EXIT_OK);
  end;

  if Cmd.Version then
  begin
    WriteLn('Betankungen ', APP_VERSION);
    Halt(EXIT_OK);
  end;

  if Cmd.About then
  begin
    PrintAbout(APP_NAME, APP_VERSION, APP_AUTHOR);
    Halt(EXIT_OK);
  end;

  if Cmd.DbSet <> '' then
  begin
    SaveDbPathToConfig(Cmd.DbSet);
    Msg('OK: DB-Pfad in der Konfiguration gespeichert.');
    Halt(EXIT_OK);
  end;

  if Cmd.ResetConfig then
    ResetConfigAndExit;

  if Cmd.ShowConfig then
    ShowConfigAndExit;

  // 0.5.4: First-Run Erkennung (vor ResolveDbPath)
  CfgExisted := FileExists(GetConfigPath);
  FirstRun := False;

  if Cmd.HasCommand and (Cmd.Kind = ckSeed) then
  begin
    DbPath := GetDefaultDemoDbPath;
    Dbg('Seed: Pfad=' + DbPath);
    Dbg(
      'Seed: stations=' + IntToStr(Cmd.SeedStations) +
      ' fuelups=' + IntToStr(Cmd.SeedFuelups) +
      ' seed_value=' + IntToStr(Cmd.SeedValue) +
      ' force=' + BoolToStr(Cmd.SeedForce, True)
    );
    try
      SeedDemoDatabase(DbPath, Cmd.SeedStations, Cmd.SeedFuelups, Cmd.SeedValue, Cmd.SeedForce);
      if Cmd.Quiet then
      begin
        // Maschinenfreundlich
        WriteLn(DbPath);
      end
      else
      begin
        Msg('OK: Demo-DB erstellt/aktualisiert');
        Msg('Pfad: ' + DbPath);
        Msg('Beispiel:');
        Msg('  Betankungen --db "' + DbPath + '" --list stations');
        Msg('Oder:');
        Msg('  Betankungen --demo --list stations');
      end;
      Halt(EXIT_OK);
    except
      on E: Exception do
        FailUsage('Fehler: ' + E.Message, efSeed);
    end;
  end;

  // DB-Pfad vorbereiten (Ueberschreibung hat Prio)
  // 0.5.4: ResolveDbPath kann IO ausloesen (ForceDirectories/Config schreiben).
  // Deshalb hier abfangen und auf Fallback-UX umleiten statt Hard-Crash.
  try
    DbPath := ResolveDbPath;
  except
    on E: Exception do
    begin
      // Bei explizitem --db niemals interaktiv werden
      if Cmd.DbOverride <> '' then
        FailUsage('Fehler: DB-Pfad nicht nutzbar: ' + ExpandFileName(Cmd.DbOverride) + ' (' + E.Message + ')', efDb);

      // Bei Demo-DB ebenfalls nicht interaktiv (reproduzierbar bleiben)
      if Cmd.UseDemoDb then
        FailUsage('Fehler: Demo-DB Pfad nicht nutzbar: ' + GetDefaultDemoDbPath + ' (' + E.Message + ')', efDemo);

      // Fallback: neuen Pfad abfragen + speichern
      Msg('Warnung: DB-Pfad konnte nicht vorbereitet werden.');
      Msg('Grund: ' + E.Message);
      PromptAndPersistDbPath(DbPath);
      FirstRun := True; // wir haben jetzt aktiv eine neue Config geschrieben
    end;
  end;

  if Cmd.UseDemoDb and (not FileExists(DbPath)) then
    FailUsage('Fehler: Demo-DB nicht gefunden. Bitte zuerst "Betankungen --seed" ausführen.', efDemo);

  try
    // Datenbank sicherstellen und initialisieren
    // 0.5.4: Prompt nur als Fallback (wenn Provisionierung fehlschlaegt) + Retry-Loop
    while True do
    begin
      try
        WasCreated := EnsureDatabase(DbPath);
        Break;
      except
        on E: Exception do
        begin
          // Bei explizitem --db niemals interaktiv werden
          if Cmd.DbOverride <> '' then
            FailUsage('Fehler: DB-Pfad nicht nutzbar: ' + DbPath + ' (' + E.Message + ')', efDb);

          // Bei Demo-DB ebenfalls nicht interaktiv (soll reproduzierbar bleiben)
          if Cmd.UseDemoDb then
            FailUsage('Fehler: Demo-DB Pfad nicht nutzbar: ' + DbPath + ' (' + E.Message + ')', efDemo);

          // Fallback: neuen Pfad abfragen + speichern + erneut versuchen
          Msg('Warnung: DB konnte nicht angelegt/geoeffnet werden: ' + DbPath);
          Msg('Grund: ' + E.Message);
          PromptAndPersistDbPath(DbPath);
          // danach retry
        end;
      end;
    end;

    // 0.5.4: Einmalige Erststart-Meldung (nur wenn Config neu angelegt wurde)
    // (CfgExisted ist vor ResolveDbPath gesetzt; FirstRun wird in ResolveDbPath gesetzt)
    if (not Cmd.Quiet) and (not CfgExisted) and FirstRun then
    begin
      Msg('Erststart: Config angelegt: ' + GetConfigPath);
      Msg('Erststart: DB: ' + ExpandFileName(DbPath));
      Msg('Tipp: Betankungen --help');
    end;

    // ----------------
    // Weiterleitung
    case Cmd.Target of
      tkStations:
        case Cmd.Kind of
          ckAdd: AddStationInteractive(DbPath);
          ckList: ListStations(DbPath, Cmd.Detail);
          ckEdit: EditStationInteractive(DbPath);
          ckDelete: DeleteStationInteractive(DbPath);
        else
          FailUsage('Interner Fehler: Ungültiges stations-Kommando.');
        end;

      tkFuelups:
        case Cmd.Kind of
          ckAdd: AddFuelupInteractive(DbPath);
          ckList: ListFuelups(DbPath, Cmd.Detail);
          ckStats:
            begin
              if Cmd.Csv then
                ShowFuelupStatsCsv(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.Monthly)
              else if Cmd.Json then
                ShowFuelupStatsJson(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.Monthly,
                  Cmd.Yearly,
                  Cmd.Pretty)
              else
              begin
                if Cmd.Dashboard then
                  ShowFuelupDashboard(DbPath,
                    Cmd.PeriodEnabled,
                    Cmd.PeriodFromIso,
                    Cmd.PeriodToExclIso,
                    Cmd.FromProvided,
                    Cmd.ToProvided,
                    Cmd.Monthly)
                else
                  ShowFuelupStats(DbPath,
                    Cmd.PeriodEnabled,
                    Cmd.PeriodFromIso,
                    Cmd.PeriodToExclIso,
                    Cmd.FromProvided,
                    Cmd.ToProvided,
                    Cmd.Monthly,
                    Cmd.Yearly);
              end;
            end;
        else
          FailUsage('Interner Fehler: Ungültiges fuelups-Kommando.');
        end;
    else
      FailUsage('Interner Fehler: Unbekannter Target.');
    end;

    // ----------------
    // Statusausgabe
    // Nur melden, wenn die DB wirklich neu angelegt wurde.
    
    if (not Cmd.Debug) and WasCreated then
      Msg('Datenbank angelegt');

    // ----------------
    // Debug-Tabelle (nur bei Debug)
    if Cmd.Debug and (not Cmd.Quiet) then
    begin
      WriteLn('');
      DbgSep;
      DbgRow('Key', 'Value');
      DbgSep;
      DbgRow('DB-Pfad', ExpandFileName(DbPath));
      DbgRow('schema_version', ReadMetaValue(DbPath, 'schema_version'));
      DbgRow('app_name', ReadMetaValue(DbPath, 'app_name'));
      DbgRow('db_created_at', ReadMetaValue(DbPath, 'db_created_at'));
      DbgRow('db_last_run', ReadMetaValue(DbPath, 'db_last_run'));
      DbgRow('odometer_start_km', ReadMetaValue(DbPath, 'odometer_start_km'));
      DbgRow('odometer_start_date', ReadMetaValue(DbPath, 'odometer_start_date'));
      DbgSep;
    end;

  except
    on E: Exception do
    begin
      FailUsage(E.Message, efNone, EXIT_UNEXPECTED);
    end;
  end;
end.

````

## Datei: `tests/README.md`

````markdown
# Tests
**Stand:** 2026-02-18

## Smoke-Test
- Script: `tests/smoke_cli.sh`
- Zweck: schneller Plausibilitaetscheck fuer Ordnerstruktur, Release-/Backup-Skripte und CLI-Binary.
- Default-Lauf ohne Zusatzflags bleibt kurz (Basis-Smoke + Core-Guardrails).
- Enthaltene First-Run-Faelle:
  - Frischer Start ohne Config/DB -> stille Anlage von Config + DB.
  - Config vorhanden, DB fehlt -> stille Neuanlage der DB am konfigurierten Pfad.
  - Nicht schreibbarer Default-Pfad -> Prompt-Fallback mit Retry.
- Weitere CLI-Guardrails:
  - `--help` wird als Struktur-Stabilitaet geprueft (Keywords: `Commands`, `Stats options`, `Examples`, `--yearly`, `--dashboard`).
  - `--stats stations` muss im Fehlerfall `Fehler` + `Usage` + `Tipp` liefern.
  - `--stats fuelups --json --csv` muss als Kurzfehler im 3-Zeilen-Format laufen (kein Voll-Help).
  - `--show-config` funktioniert auch in frischer HOME-Umgebung.
  - `--reset-config` loescht nur die Config, nicht die DB-Datei.
  - `--reset-config` prueft optional den Fehlerpfad bei nicht loeschbarer Config (Skip, falls im System nicht reproduzierbar).
  - `--demo` ohne Seed liefert einen sauberen Fehler ohne interaktiven Prompt.
  - Fehlerhafter `--db`-Pfad bleibt non-interactive (kein Prompt-Fallback).
- Zusatzsuiten (optional):
  - `-m`: Monthly-Regression-Suite (Text/JSON compact+pretty, Zeitraum, Validierung, No-Data-Fall).
  - `-y`: Yearly-Regression-Suite (Text/JSON compact+pretty, Zeitraum, Validierungskonflikte, JSON-Struktur, No-Data-Fall).
  - `-a`: beide Zusatzsuiten (`-m` + `-y`).
- Steuerung:
  - Default ist **fail-fast** (Abbruch beim ersten Fehler).
  - `--keep-going` sammelt Fehler und liefert am Ende eine Gesamtsumme.
  - `-l` bzw. `--list` zeigt nur die geplanten Checks (keine Ausfuehrung).
- Ausgabe:
  - Prefixe sind farblich markiert (`[INFO]` gelb, `[OK]` gruen, `[FAIL]` rot; `[LIST]` cyan in `smoke_cli.sh`).

Ausfuehrung im Projektroot:
- `tests/smoke_cli.sh`
- `tests/smoke_cli.sh -m`
- `tests/smoke_cli.sh -y`
- `tests/smoke_cli.sh -a`
- `tests/smoke_cli.sh -a --keep-going`
- `tests/smoke_cli.sh -a -l`

## Finaler Smoke in sauberer HOME-Sandbox
- Script: `tests/smoke_clean_home.sh`
- Zweck: reproduzierbarer End-to-End-Lauf in isolierter HOME/XDG-Umgebung.
- Ausfuehrung:
  - `tests/smoke_clean_home.sh`
  - `tests/smoke_clean_home.sh -m|-y|-a`
  - `tests/smoke_clean_home.sh -a --keep-going`
  - `tests/smoke_clean_home.sh -a -l`
  - optional: `tests/smoke_clean_home.sh --keep-home` (Sandbox bleibt zur Analyse erhalten)

````

## Datei: `tests/smoke_clean_home.sh`

````bash
#!/usr/bin/env bash
set -euo pipefail

# smoke_clean_home.sh
# UPDATED: 2026-02-16
# Fuehrt tests/smoke_cli.sh in einer sauberen HOME/XDG-Sandbox aus.

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEEP_HOME=false
TMP_HOME=""
EXTRA_ARGS=()

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Finaler Smoke-Run in sauberer HOME-Sandbox

Usage:
  tests/$SCRIPT_NAME [--keep-home] [-m] [-y] [-a] [-l] [--keep-going]

Options:
  --keep-home   Temp-HOME nach dem Lauf behalten (zur Analyse)
  -m            Monthly-Zusatzsuite an smoke_cli.sh durchreichen
  -y            Yearly-Zusatzsuite an smoke_cli.sh durchreichen
  -a            Beide Zusatzsuiten an smoke_cli.sh durchreichen
  -l, --list    Nur Testliste anzeigen (keine Ausfuehrung)
  --keep-going  Fehler sammeln statt fail-fast
  -h, --help    Hilfe anzeigen
EOF_USAGE
}

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'
  exec > >(
    while IFS= read -r line; do
      case "$line" in
        "[OK]"*)
          printf '%b[OK]%b%s\n' "$C_GREEN" "$C_RESET" "${line#\[OK\]}"
          ;;
        "[FAIL]"*)
          printf '%b[FAIL]%b%s\n' "$C_RED" "$C_RESET" "${line#\[FAIL\]}"
          ;;
        "[INFO]"*)
          printf '%b[INFO]%b%s\n' "$C_YELLOW" "$C_RESET" "${line#\[INFO\]}"
          ;;
        *)
          printf '%s\n' "$line"
          ;;
      esac
    done
  )
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --keep-home)
      KEEP_HOME=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -m|-y|-a|-l|--list|--keep-going)
      EXTRA_ARGS+=("$1")
      shift
      ;;
    *)
      printf 'Fehler: Unbekannte Option: %s\n' "$1" >&2
      usage
      exit 1
      ;;
  esac
done

TMP_HOME="$(mktemp -d /tmp/betankungen_final_smoke_XXXXXX)"

cleanup() {
  if $KEEP_HOME; then
    printf '[INFO] Temp-HOME behalten: %s\n' "$TMP_HOME"
  else
    rm -rf "$TMP_HOME"
  fi
}
trap cleanup EXIT

export HOME="$TMP_HOME"
export XDG_CONFIG_HOME="$TMP_HOME/.config"
export XDG_DATA_HOME="$TMP_HOME/.local/share"

printf '[INFO] Starte Smoke-Run in sauberer Sandbox: %s\n' "$TMP_HOME"
set +e
"$ROOT_DIR/tests/smoke_cli.sh" "${EXTRA_ARGS[@]}"
RC=$?
set -e

if [[ $RC -eq 0 ]]; then
  printf '[OK] Finaler Smoke-Run erfolgreich (RC=0)\n'
else
  printf '[FAIL] Finaler Smoke-Run fehlgeschlagen (RC=%d)\n' "$RC"
fi

exit $RC

````

## Datei: `tests/smoke_cli.sh`

````bash
#!/usr/bin/env bash
set -euo pipefail

# smoke_cli.sh
# UPDATED: 2026-02-18
# Leichtgewichtiger Smoke-Test fuer Struktur + Kernkommandos.
# Erweitert um First-Run-/Bootstrap-Faelle und robuste CLI-Guardrails (0.5.4).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILS=0
TMP_DIRS=()
RUN_MONTHLY_SUITE=false
RUN_YEARLY_SUITE=false
LIST_ONLY=false
KEEP_GOING=false

usage() {
  cat <<'EOF_USAGE'
smoke_cli.sh - Basis-Smoke + optionale Stats-Zusatzsuiten

Usage:
  tests/smoke_cli.sh [-m] [-y] [-a] [-l] [--keep-going] [-h]

Optionen:
  -m    Monthly-Zusatzsuite ausfuehren
  -y    Yearly-Zusatzsuite ausfuehren
  -a    Beide Zusatzsuiten ausfuehren (-m + -y)
  -l, --list
        Nur Testliste ausgeben (Dry-List, keine Ausfuehrung)
  --keep-going
        Nicht fail-fast; alle Fehler sammeln und am Ende zusammenfassen
  -h    Hilfe anzeigen
EOF_USAGE
}

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'
  C_CYAN=$'\033[36m'
  exec > >(
    while IFS= read -r line; do
      case "$line" in
        "[OK]"*)
          printf '%b[OK]%b%s\n' "$C_GREEN" "$C_RESET" "${line#\[OK\]}"
          ;;
        "[FAIL]"*)
          printf '%b[FAIL]%b%s\n' "$C_RED" "$C_RESET" "${line#\[FAIL\]}"
          ;;
        "[INFO]"*)
          printf '%b[INFO]%b%s\n' "$C_YELLOW" "$C_RESET" "${line#\[INFO\]}"
          ;;
        "[LIST]"*)
          printf '%b[LIST]%b%s\n' "$C_CYAN" "$C_RESET" "${line#\[LIST\]}"
          ;;
        *)
          printf '%s\n' "$line"
          ;;
      esac
    done
  )
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m)
      RUN_MONTHLY_SUITE=true
      shift
      ;;
    -y)
      RUN_YEARLY_SUITE=true
      shift
      ;;
    -a)
      RUN_MONTHLY_SUITE=true
      RUN_YEARLY_SUITE=true
      shift
      ;;
    -l|--list)
      LIST_ONLY=true
      shift
      ;;
    --keep-going)
      KEEP_GOING=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Fehler: Unbekannte Option: %s\n' "$1" >&2
      usage
      exit 1
      ;;
  esac
done

add_fail() {
  FAILS=$((FAILS + 1))
  if ! $KEEP_GOING; then
    printf '[INFO] Fail-Fast aktiv: Abbruch nach erstem Fehler.\n'
    printf 'Smoke-Test beendet mit %d Fehler(n).\n' "$FAILS"
    exit 1
  fi
}

print_plan() {
  printf '[INFO] List-Mode aktiv: folgende Checks wuerden laufen.\n'
  printf '[LIST] Pfad vorhanden: docs\n'
  printf '[LIST] Pfad vorhanden: src\n'
  printf '[LIST] Pfad vorhanden: units\n'
  printf '[LIST] Pfad vorhanden: scripts\n'
  printf '[LIST] Pfad vorhanden: knowledge_archive\n'
  printf '[LIST] Pfad vorhanden: .releases\n'
  printf '[LIST] Pfad vorhanden: .backup\n'
  printf '[LIST] kpr dry-run\n'
  printf '[LIST] backup_snapshot dry-run\n'
  printf '[LIST] Betankungen --version\n'
  printf '[LIST] Betankungen --help\n'
  printf '[LIST] --help enthaelt Struktur-Keywords (Commands/Stats options/Examples/--yearly/--dashboard)\n'
  printf '[LIST] --stats stations -> Fehler + Kurz-Usage + Tipp\n'
  printf '[LIST] --stats fuelups --json --csv -> Fehler im 3-Zeilen-Format ohne Voll-Help\n'
  printf '[LIST] First-Run: stiller Bootstrap (config+db)\n'
  printf '[LIST] Config vorhanden, DB fehlt: automatische DB-Anlage ohne Prompt\n'
  printf '[LIST] Default nicht schreibbar: Prompt-Fallback + Retry erfolgreich\n'
  printf '[LIST] --show-config in frischer HOME-Umgebung\n'
  printf '[LIST] --reset-config loescht nur Config, nicht die DB\n'
  printf '[LIST] --reset-config Fehlerpfad: Config nicht loeschbar (falls simulierbar)\n'
  printf '[LIST] --demo ohne Seed: sauberer Fehler ohne Prompt\n'
  printf '[LIST] --db Fehlerpfad bleibt non-interactive (kein Prompt)\n'

  if $RUN_MONTHLY_SUITE; then
    printf '[LIST] (Monthly) --demo --stats fuelups --monthly\n'
    printf '[LIST] (Monthly) --demo --stats fuelups --json --monthly\n'
    printf '[LIST] (Monthly) --demo --stats fuelups --json --pretty --monthly\n'
    printf '[LIST] (Monthly) --demo --stats fuelups --from 2024-01 --to 2025-12 --monthly\n'
    printf '[LIST] (Monthly) --monthly ohne stats -> Fehler\n'
    printf '[LIST] (Monthly) --stats fuelups --pretty --monthly -> Fehler\n'
    printf '[LIST] (Monthly) leere DB + --stats fuelups --monthly\n'
  fi

  if $RUN_YEARLY_SUITE; then
    printf '[LIST] (Yearly) --demo --stats fuelups --yearly\n'
    printf '[LIST] (Yearly) --demo --stats fuelups --json --yearly\n'
    printf '[LIST] (Yearly) --demo --stats fuelups --json --pretty --yearly\n'
    printf '[LIST] (Yearly) --demo --stats fuelups --from 2022-01 --to 2024-01 --yearly\n'
    printf '[LIST] (Yearly) --yearly ohne stats -> Fehler\n'
    printf '[LIST] (Yearly) --stats fuelups --yearly --monthly -> Fehler\n'
    printf '[LIST] (Yearly) --stats fuelups --yearly --csv -> Fehler\n'
    printf '[LIST] (Yearly) --stats fuelups --yearly --dashboard -> Fehler\n'
    printf '[LIST] (Yearly) --stats fuelups --pretty --yearly -> Fehler\n'
    printf '[LIST] (Yearly) leere DB + --stats fuelups --yearly\n'
    printf '[LIST] (Yearly) --demo --stats fuelups --json --pretty --from 2023-01 --yearly\n'
  fi

  printf '[INFO] Ende der Testliste.\n'
}

if $LIST_ONLY; then
  print_plan
  exit 0
fi

run_check() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf '[OK] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    add_fail
  fi
}

test_help_keywords_stable() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --help >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q 'Commands' "$out" &&
     grep -q 'Stats options' "$out" &&
     grep -q 'Examples' "$out" &&
     grep -q -- '--yearly' "$out" &&
     grep -q -- '--dashboard' "$out"; then
    printf '[OK] --help enthaelt Struktur-Keywords\n'
  else
    printf '[FAIL] --help enthaelt Struktur-Keywords\n'
    add_fail
  fi
}

test_stats_stations_fails_short_usage() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats stations >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] &&
     grep -q 'Fehler:' "$err" &&
     grep -q 'Usage:' "$out" &&
     grep -q 'Tipp:' "$err"; then
    printf '[OK] --stats stations: Fehler + Kurz-Usage + Tipp\n'
  else
    printf '[FAIL] --stats stations: Fehler + Kurz-Usage + Tipp\n'
    add_fail
  fi
}

test_stats_json_csv_fails_short_3line_no_full_help() {
  local home out err rc out_lines err_lines

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --json --csv >"$out" 2>"$err"
  rc=$?
  set -e

  out_lines="$(wc -l < "$out" | tr -d ' ')"
  err_lines="$(wc -l < "$err" | tr -d ' ')"

  if [[ $rc -ne 0 ]] &&
     [[ "${out_lines:-0}" -eq 1 ]] &&
     [[ "${err_lines:-0}" -eq 2 ]] &&
     grep -q 'Usage:' "$out" &&
     grep -q 'Fehler:' "$err" &&
     grep -q 'Tipp:' "$err" &&
     ! grep -q 'Commands:' "$out" &&
     ! grep -q 'Examples:' "$out" &&
     ! grep -q 'Commands:' "$err" &&
     ! grep -q 'Examples:' "$err"; then
    printf '[OK] --stats fuelups --json --csv: 3-Zeilen-Fehler ohne Voll-Help\n'
  else
    printf '[FAIL] --stats fuelups --json --csv: 3-Zeilen-Fehler ohne Voll-Help\n'
    add_fail
  fi
}

register_tmp_dir() {
  local d
  d="$(mktemp -d /tmp/betankungen_smoke_XXXXXX)"
  TMP_DIRS+=("$d")
  printf '%s\n' "$d"
}

cleanup_tmp_dirs() {
  local d
  for d in "${TMP_DIRS[@]}"; do
    rm -rf "$d"
  done
}

test_first_run_bootstrap() {
  local home out err cfg db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  db="$home/.local/share/Betankungen/betankungen.db"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 && ! -s "$out" && ! -s "$err" && -f "$cfg" && -f "$db" ]]; then
    printf '[OK] First-Run: stiller Bootstrap (config+db)\n'
  else
    printf '[FAIL] First-Run: stiller Bootstrap (config+db)\n'
    add_fail
  fi
}

test_cfg_present_db_missing() {
  local home out err cfg db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  db="$home/.local/share/Betankungen/betankungen.db"

  mkdir -p "$(dirname "$cfg")"
  printf "[database]\npath=%s\n" "$db" > "$cfg"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 && ! -s "$out" && ! -s "$err" && -f "$db" ]]; then
    printf '[OK] Config vorhanden, DB fehlt: automatische DB-Anlage ohne Prompt\n'
  else
    printf '[FAIL] Config vorhanden, DB fehlt: automatische DB-Anlage ohne Prompt\n'
    add_fail
  fi
}

test_default_unwritable_prompt_retry() {
  local home out err cfg alt_db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  alt_db="$home/custom/betankungen.db"

  # Blockiert den Default-Pfad absichtlich: ".local" als Datei statt Verzeichnis.
  printf "block" > "$home/.local"

  set +e
  printf '\n%s\n' "$alt_db" | HOME="$home" "$ROOT_DIR/bin/Betankungen" >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 && -f "$cfg" && -f "$alt_db" ]] &&
     grep -q 'DB-Pfad>' "$out" &&
     grep -q "path=$alt_db" "$cfg"; then
    printf '[OK] Default nicht schreibbar: Prompt-Fallback + Retry erfolgreich\n'
  else
    printf '[FAIL] Default nicht schreibbar: Prompt-Fallback + Retry erfolgreich\n'
    add_fail
  fi
}

test_show_config_fresh_home() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --show-config >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q 'Config-Datei:' "$out" &&
     grep -q 'Default DB-Pfad:' "$out"; then
    printf '[OK] --show-config in frischer HOME-Umgebung\n'
  else
    printf '[FAIL] --show-config in frischer HOME-Umgebung\n'
    add_fail
  fi
}

test_reset_config_keeps_db() {
  local home out err cfg db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  db="$home/.local/share/Betankungen/betankungen.db"

  HOME="$home" "$ROOT_DIR/bin/Betankungen" >/dev/null 2>&1

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --reset-config >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 && ! -f "$cfg" && -f "$db" ]]; then
    printf '[OK] --reset-config loescht nur Config, nicht die DB\n'
  else
    printf '[FAIL] --reset-config loescht nur Config, nicht die DB\n'
    add_fail
  fi
}

test_reset_config_delete_failure_if_possible() {
  local home out err cfg cfg_dir rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  cfg_dir="$home/.config/Betankungen"

  HOME="$home" "$ROOT_DIR/bin/Betankungen" >/dev/null 2>&1

  if [[ ! -f "$cfg" || ! -d "$cfg_dir" ]]; then
    printf '[FAIL] --reset-config Fehlerpfad: Test-Setup fehlgeschlagen\n'
    add_fail
    return
  fi

  chmod u-w "$cfg_dir"
  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --reset-config >"$out" 2>"$err"
  rc=$?
  set -e
  chmod u+w "$cfg_dir"

  if [[ $rc -eq 0 ]]; then
    printf '[INFO] --reset-config Fehlerpfad: Umgebung erlaubt keine reproduzierbare Delete-Blockade, Check uebersprungen\n'
    return
  fi

  if [[ -f "$cfg" ]] &&
     grep -q 'Konnte Config nicht loeschen:' "$err" &&
     grep -q 'Tipp: Betankungen --help' "$err"; then
    printf '[OK] --reset-config Fehlerpfad: Config-Loeschfehler sauber abgefangen\n'
  else
    printf '[FAIL] --reset-config Fehlerpfad: Config-Loeschfehler sauber abgefangen\n'
    add_fail
  fi
}

test_demo_without_seed_fails_non_interactive() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --list stations >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] &&
     grep -q 'Demo-DB nicht gefunden' "$err" &&
     ! grep -q 'DB-Pfad>' "$out"; then
    printf '[OK] --demo ohne Seed: sauberer Fehler ohne Prompt\n'
  else
    printf '[FAIL] --demo ohne Seed: sauberer Fehler ohne Prompt\n'
    add_fail
  fi
}

test_db_override_error_no_prompt() {
  local home out err bad_db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  printf "block" > "$home/blocker"
  bad_db="$home/blocker/bad.db"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --db "$bad_db" --list stations >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] &&
     grep -q 'Fehler: DB-Pfad nicht nutzbar:' "$err" &&
     ! grep -q 'DB-Pfad>' "$out"; then
    printf '[OK] --db Fehlerpfad bleibt non-interactive (kein Prompt)\n'
  else
    printf '[FAIL] --db Fehlerpfad bleibt non-interactive (kein Prompt)\n'
    add_fail
  fi
}

prepare_seeded_demo_home() {
  local home
  home="$(register_tmp_dir)"

  if ! HOME="$home" "$ROOT_DIR/bin/Betankungen" --seed --force --seed-value 4242 >/dev/null 2>&1; then
    printf '[FAIL] Stats-Setup: --seed --force fehlgeschlagen\n'
    add_fail
  fi

  printf '%s\n' "$home"
}

test_monthly_text_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Monat' "$out"; then
    printf '[OK] Monthly Text: --demo --stats fuelups --monthly\n'
  else
    printf '[FAIL] Monthly Text: --demo --stats fuelups --monthly\n'
    add_fail
  fi
}

test_monthly_json_compact_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '"kind":"fuelups_monthly"' "$out" &&
     grep -q '"fuelups_total"' "$out" &&
     grep -q '"fuelups_full"' "$out" &&
     grep -q '"rows"' "$out"; then
    printf '[OK] Monthly JSON compact: kind + Schluessel vorhanden\n'
  else
    printf '[FAIL] Monthly JSON compact: kind + Schluessel vorhanden\n'
    add_fail
  fi
}

test_monthly_json_pretty_demo_ok() {
  local home out err rc line_count

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --pretty --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  line_count="$(wc -l < "$out" | tr -d ' ')"
  if [[ $rc -eq 0 ]] &&
     grep -q 'fuelups_monthly' "$out" &&
     [[ "$(head -n 1 "$out")" == "{" ]] &&
     [[ "${line_count:-0}" -gt 1 ]]; then
    printf '[OK] Monthly JSON pretty: kind + Pretty-Mehrzeilenformat\n'
  else
    printf '[FAIL] Monthly JSON pretty: kind + Pretty-Mehrzeilenformat\n'
    add_fail
  fi
}

test_monthly_period_text_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --from 2024-01 --to 2025-12 --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Monat' "$out"; then
    printf '[OK] Monthly + Zeitraum: Tabelle mit Monat-Spalte\n'
  else
    printf '[FAIL] Monthly + Zeitraum: Tabelle mit Monat-Spalte\n'
    add_fail
  fi
}

test_monthly_without_stats_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -Eq 'Kein Kommando|--monthly ist nur zusammen' "$err"; then
    printf '[OK] Monthly ohne stats: sauberer Validierungsfehler\n'
  else
    printf '[FAIL] Monthly ohne stats: sauberer Validierungsfehler\n'
    add_fail
  fi
}

test_monthly_pretty_without_json_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --pretty --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nur zusammen mit --json' "$err"; then
    printf '[OK] Monthly + Pretty ohne JSON: Validierungsfehler\n'
  else
    printf '[FAIL] Monthly + Pretty ohne JSON: Validierungsfehler\n'
    add_fail
  fi
}

test_monthly_empty_db_text_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -Eq 'Keine Tankvorgaenge|Keine Tankvorgänge' "$out"; then
    printf '[OK] Leere DB + Monthly: sauberer No-Data-Output\n'
  else
    printf '[FAIL] Leere DB + Monthly: sauberer No-Data-Output\n'
    add_fail
  fi
}

run_monthly_suite() {
  printf '[INFO] Zusatzsuite aktiv: Monthly (-m)\n'
  test_monthly_text_demo_ok
  test_monthly_json_compact_demo_ok
  test_monthly_json_pretty_demo_ok
  test_monthly_period_text_demo_ok
  test_monthly_without_stats_fails
  test_monthly_pretty_without_json_fails
  test_monthly_empty_db_text_ok
}

test_yearly_text_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Jahresuebersicht' "$out"; then
    printf '[OK] Yearly Text: --demo --stats fuelups --yearly\n'
  else
    printf '[FAIL] Yearly Text: --demo --stats fuelups --yearly\n'
    add_fail
  fi
}

test_yearly_json_compact_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '"kind":"fuelups_yearly"' "$out" &&
     grep -q '"fuelups_total"' "$out" &&
     grep -q '"fuelups_full"' "$out" &&
     grep -q '"rows"' "$out"; then
    printf '[OK] Yearly JSON compact: kind + Schluessel vorhanden\n'
  else
    printf '[FAIL] Yearly JSON compact: kind + Schluessel vorhanden\n'
    add_fail
  fi
}

test_yearly_json_pretty_demo_ok() {
  local home out err rc line_count

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --pretty --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  line_count="$(wc -l < "$out" | tr -d ' ')"
  if [[ $rc -eq 0 ]] &&
     grep -q 'fuelups_yearly' "$out" &&
     [[ "$(head -n 1 "$out")" == "{" ]] &&
     [[ "${line_count:-0}" -gt 1 ]]; then
    printf '[OK] Yearly JSON pretty: kind + Pretty-Mehrzeilenformat\n'
  else
    printf '[FAIL] Yearly JSON pretty: kind + Pretty-Mehrzeilenformat\n'
    add_fail
  fi
}

test_yearly_period_text_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --from 2022-01 --to 2024-01 --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Jahr' "$out"; then
    printf '[OK] Yearly + Zeitraum: Tabelle mit Jahr-Spalte\n'
  else
    printf '[FAIL] Yearly + Zeitraum: Tabelle mit Jahr-Spalte\n'
    add_fail
  fi
}

test_yearly_without_stats_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -Eq 'Kein Kommando|--yearly ist nur zusammen' "$err"; then
    printf '[OK] Yearly ohne stats: sauberer Validierungsfehler\n'
  else
    printf '[FAIL] Yearly ohne stats: sauberer Validierungsfehler\n'
    add_fail
  fi
}

test_yearly_monthly_conflict_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --yearly --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nicht zusammen verwendet' "$err"; then
    printf '[OK] Yearly + Monthly: Konflikt wird abgelehnt\n'
  else
    printf '[FAIL] Yearly + Monthly: Konflikt wird abgelehnt\n'
    add_fail
  fi
}

test_yearly_csv_conflict_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --yearly --csv >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -Eq 'nicht als CSV|CSV' "$err"; then
    printf '[OK] Yearly + CSV: Konflikt wird abgelehnt\n'
  else
    printf '[FAIL] Yearly + CSV: Konflikt wird abgelehnt\n'
    add_fail
  fi
}

test_yearly_dashboard_conflict_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --yearly --dashboard >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nicht mit --dashboard kombiniert' "$err"; then
    printf '[OK] Yearly + Dashboard: Konflikt wird abgelehnt\n'
  else
    printf '[FAIL] Yearly + Dashboard: Konflikt wird abgelehnt\n'
    add_fail
  fi
}

test_yearly_pretty_without_json_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --pretty --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nur zusammen mit --json' "$err"; then
    printf '[OK] Yearly + Pretty ohne JSON: Validierungsfehler\n'
  else
    printf '[FAIL] Yearly + Pretty ohne JSON: Validierungsfehler\n'
    add_fail
  fi
}

test_yearly_empty_db_text_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Keine Tankvorgaenge' "$out"; then
    printf '[OK] Leere DB + Yearly: sauberer No-Data-Output\n'
  else
    printf '[FAIL] Leere DB + Yearly: sauberer No-Data-Output\n'
    add_fail
  fi
}

test_yearly_json_pretty_period_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --pretty --from 2023-01 --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'fuelups_yearly' "$out"; then
    printf '[OK] Demo + Yearly + JSON + Pretty + Period\n'
  else
    printf '[FAIL] Demo + Yearly + JSON + Pretty + Period\n'
    add_fail
  fi
}

run_yearly_suite() {
  printf '[INFO] Zusatzsuite aktiv: Yearly (-y)\n'
  test_yearly_text_demo_ok
  test_yearly_json_compact_demo_ok
  test_yearly_json_pretty_demo_ok
  test_yearly_period_text_demo_ok
  test_yearly_without_stats_fails
  test_yearly_monthly_conflict_fails
  test_yearly_csv_conflict_fails
  test_yearly_dashboard_conflict_fails
  test_yearly_pretty_without_json_fails
  test_yearly_empty_db_text_ok
  test_yearly_json_pretty_period_demo_ok
}

trap cleanup_tmp_dirs EXIT

require_path() {
  local p="$1"
  if [[ -e "$p" ]]; then
    printf '[OK] Pfad vorhanden: %s\n' "$p"
  else
    printf '[FAIL] Pfad fehlt: %s\n' "$p"
    add_fail
  fi
}

printf 'Smoke-Test startet in %s\n' "$ROOT_DIR"

require_path "$ROOT_DIR/docs"
require_path "$ROOT_DIR/src"
require_path "$ROOT_DIR/units"
require_path "$ROOT_DIR/scripts"
require_path "$ROOT_DIR/knowledge_archive"
require_path "$ROOT_DIR/.releases"
require_path "$ROOT_DIR/.backup"

run_check "kpr dry-run" "$ROOT_DIR/kpr.sh" --dry-run
run_check "backup_snapshot dry-run" "$ROOT_DIR/scripts/backup_snapshot.sh" --dry-run

if [[ -x "$ROOT_DIR/bin/Betankungen" ]]; then
  run_check "Betankungen --version" "$ROOT_DIR/bin/Betankungen" --version
  run_check "Betankungen --help" "$ROOT_DIR/bin/Betankungen" --help
  test_help_keywords_stable
  test_stats_stations_fails_short_usage
  test_stats_json_csv_fails_short_3line_no_full_help
  test_first_run_bootstrap
  test_cfg_present_db_missing
  test_default_unwritable_prompt_retry
  test_show_config_fresh_home
  test_reset_config_keeps_db
  test_reset_config_delete_failure_if_possible
  test_demo_without_seed_fails_non_interactive
  test_db_override_error_no_prompt
  if $RUN_MONTHLY_SUITE; then
    run_monthly_suite
  fi
  if $RUN_YEARLY_SUITE; then
    run_yearly_suite
  fi
else
  printf '[INFO] Binärdatei fehlt: %s\n' "$ROOT_DIR/bin/Betankungen"
fi

if [[ $FAILS -gt 0 ]]; then
  printf 'Smoke-Test beendet mit %d Fehler(n).\n' "$FAILS"
  exit 1
fi

printf 'Smoke-Test erfolgreich.\n'

````

## Datei: `units/u_cli_help.pas`

````pascal
{
  u_cli_help.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-19
  AUTHOR : Christof Kempinski
  Zentrale Help-/Usage-/About-Ausgabe fuer die CLI.

  Verantwortlichkeiten:
  - Rendert den strukturierten Voll-Help-Text fuer die CLI.
  - Bietet einen Kompatibilitaets-Alias `PrintUsage` auf `PrintHelp`.
  - Rendert eine kurze, kontextsensitive One-Line-Usage fuer Fehlerpfade.
  - Rendert die About-Ausgabe (inkl. Danksagung).
  - Bietet einen einheitlichen FailUsage-Pfad mit Fokus-Mapping.

  Design-Entscheidungen:
  - Nutzt `TErrorFocus` aus `u_cli_types` als Single Source of Truth
    fuer kontextsensitiven Usage-Fokus.
  - Enthaelt nur Ausgabe-/Exit-Logik, keine Parser- oder Fachlogik.
  ---------------------------------------------------------------------------
}

unit u_cli_help;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, u_cli_types;

// Vollstaendige Usage-Ausgabe.
procedure PrintUsage(const FocusFlag: string = '');
// Kurz-Usage fuer Fehlerpfad (1 Zeile, kontextsensitiv).
procedure PrintUsageShort(const Focus: TErrorFocus = efNone);
// Alias fuer PrintUsage (Kompatibilitaet/Lesbarkeit).
procedure PrintHelp;
// About-Ausgabe inkl. Danksagung.
procedure PrintAbout(const AppName, AppVersion, AppAuthor: string);
// Standardisierter Fehlerpfad (Fehler + kontextbezogene Usage + Exit).
procedure FailUsage(const Msg: string; const Focus: TErrorFocus = efNone; ExitCode: Integer = 1);

implementation

procedure PrintUsage(const FocusFlag: string = '');
begin
  // Kompatibilitaets-Alias: Voll-Help sitzt in PrintHelp.
  // FocusFlag wird hier absichtlich ignoriert (Voll-Help ist fix strukturiert).
  PrintHelp;
end;

procedure PrintUsageShort(const Focus: TErrorFocus = efNone);
var
  FocusFlag: string;
begin
  // Genau 1 Zeile im Fehlerpfad (damit FailUsage insgesamt 3 Zeilen bleibt).
  FocusFlag := ErrorFocusToFlag(Focus);

  if FocusFlag = '--seed' then
    Writeln('Usage: Betankungen --seed [--stations N] [--fuelups N] [--seed-value N] [--force]')
  else if FocusFlag = '--db-set' then
    Writeln('Usage: Betankungen --db-set <pfad>')
  else if FocusFlag = '--stats' then
    Writeln('Usage: Betankungen --stats fuelups [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--monthly] [--yearly] [--dashboard] [--json [--pretty]] [--csv]')
  else if (FocusFlag = '--from') then
    Writeln('Usage: Betankungen --stats fuelups [--from YYYY-MM[-DD]] [--to YYYY-MM[-DD]] [--monthly] [--yearly] [--dashboard] [--json [--pretty]] [--csv]')
  else if FocusFlag = '--db' then
    Writeln('Usage: Betankungen [--db <pfad>|--demo] <command> [options]')
  else if FocusFlag = '--demo' then
    Writeln('Usage: Betankungen --demo <command> [options]')
  else if (FocusFlag = '--add') or (FocusFlag = '--list') then
    Writeln('Usage: Betankungen --add|--list stations|fuelups [--db <pfad>|--demo] [--detail] [--debug|--trace|--quiet]')
  else if FocusFlag = '--about' then
    Writeln('Usage: Betankungen --about')
  else
    Writeln('Usage: Betankungen [--db <pfad>|--demo] <command> [options]');
end;

procedure PrintHelp;
  procedure Sec(const Title: string);
  begin
    Writeln;
    Writeln(Title, ':');
  end;

  procedure Line(const S: string);
  begin
    Writeln(S);
  end;

  procedure Item(const Left, Right: string);
  begin
    // Kleine Formatierungshilfe: links Flag, rechts Mini-Halbsatz.
    Writeln('  ', Left:20, ' ', Right);
  end;

begin
  Line('Betankungen – CLI-Tool zur Verwaltung von Tankstellen und Betankungen (SQLite).');

  Sec('Usage');
  Line('  Betankungen [--db <pfad>|--demo] <command> [options]');
  Line('  Betankungen --db-set <pfad>');
  Line('  Betankungen --seed [--stations N] [--fuelups N] [--seed-value N] [--force]');
  Line('  Betankungen --help | --version | --about');

  Sec('Commands');
  Item('--add stations|fuelups',     'Datensatz interaktiv erfassen.');
  Item('--list stations|fuelups',    'Auflisten (optional mit --detail).');
  Item('--edit stations',            'Station bearbeiten (fuelups ist verboten).');
  Item('--delete stations',          'Station loeschen (fuelups ist verboten).');
  Item('--stats fuelups',            'Auswertung der Betankungen (read-only).');
  Item('--seed',                     'Demo-DB erzeugen/auffuellen (exklusiv).');
  Item('--about',                    'Projekt-/Autor-Informationen anzeigen.');
  Item('--help',                     'Voll-Help anzeigen und beenden.');
  Item('--version',                  'Versionsausgabe anzeigen und beenden.');

  Sec('Common options');
  Item('--db <pfad>',                'DB nur fuer diesen Lauf (nicht mit --db-set).');
  Item('--demo',                     'Demo-DB fuer diesen Lauf (nicht mit --seed).');
  Item('--detail',                   'Detailausgabe fuer Listen.');

  Sec('Advanced options');
  Item('--db-set <pfad>',            'DB-Pfad speichern und beenden (nicht mit --db).');
  Item('--show-config',              'Konfiguration anzeigen und beenden.');
  Item('--reset-config',             'Konfiguration zuruecksetzen und beenden.');
  Item('--debug',                    'Debug-Logging aktivieren.');
  Item('--trace',                    'Verbose Trace-Logging aktivieren.');
  Item('--quiet',                    'Ausgaben reduzieren (Fehler bleiben sichtbar).');

  Sec('Stats options (nur bei --stats fuelups)');
  Item('--from <YYYY-MM|YYYY-MM-DD>','Startzeitraum (Formatpflicht).');
  Item('--to <YYYY-MM|YYYY-MM-DD>',  'Endzeitraum (Formatpflicht; exklusive Obergrenze).');
  Item('--monthly',                  'Monatliche Aggregation (nicht mit --yearly).');
  Item('--yearly',                   'Jaehrliche Aggregation (nicht mit --monthly/--csv/--dashboard).');
  Item('--json',                     'JSON-Ausgabe.');
  Item('--pretty',                   'Pretty-JSON (nur zusammen mit --json).');
  Item('--csv',                      'CSV-Ausgabe (nicht mit --json; nicht bei --yearly).');
  Item('--dashboard',                'Kompakt-Dashboard (exklusiv; nicht mit --json/--csv; nicht bei --yearly).');

  Sec('Examples');
  Line('  Betankungen --add stations');
  Line('  Betankungen --add fuelups');
  Line('  Betankungen --list fuelups --detail');
  Line('  Betankungen --stats fuelups');
  Line('  Betankungen --stats fuelups --from 2025-01 --to 2025-03');
  Line('  Betankungen --stats fuelups --monthly');
  Line('  Betankungen --stats fuelups --json --monthly');
  Line('  Betankungen --stats fuelups --yearly');
  Line('  Betankungen --stats fuelups --json --pretty --yearly');
  Line('  Betankungen --seed --fuelups 400 --force');
end;

procedure PrintAbout(const AppName, AppVersion, AppAuthor: string);
begin
  Writeln(AppName, ' ', AppVersion);
  Writeln('Autor: ', AppAuthor);
  Writeln('');
  Writeln('Danksagung:');
  Writeln('  Mein besonderer Dank waehrend der Entwicklungsphase geht an:');
  Writeln('  CFO Cookie - meine 2 Jahre alte Shih-Tzu-Huendin.');
  Writeln('  Mit ihrer Art hat sie mir oft mentale und konstruktive');
  Writeln('  Unterstuetzung gegeben: mal ablenkend, mal erdend, aber');
  Writeln('  vor allem mit viel Zuwendung auch in stressigen Phasen.');
end;

procedure FailUsage(const Msg: string; const Focus: TErrorFocus = efNone; ExitCode: Integer = 1);
var
  Line: string;
begin
  // 3-Zeilen-Standard:
  // 1) Fehler
  // 2) Kontext-Usage (1 Zeile)
  // 3) Tipp
  Line := Trim(Msg);
  if Line = '' then
    Line := 'Unbekannter Fehler.';
  if (Pos('Fehler:', Line) <> 1) and (Pos('Interner Fehler:', Line) <> 1) then
    Line := 'Fehler: ' + Line;

  Writeln(StdErr, Line);
  PrintUsageShort(Focus);
  Writeln(StdErr, 'Tipp: Betankungen --help');
  Halt(ExitCode);
end;

end.

````

## Datei: `units/u_cli_parse.pas`

````pascal
{
  u_cli_parse.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-02-19
  UPDATED: 2026-02-19
  AUTHOR : Christof Kempinski
  Zentrale CLI-Parsing-Unit fuer den Kommandozustand.

  Verantwortlichkeiten:
  - Parst CLI-Argumente in den zentralen Zustand `TCommand`.
  - Fuehrt die regelbasierte Validierung der CLI-Kombinationen aus.
  - Liefert im Fehlerfall konsistente Fehlertexte und Fokus-Markierungen.
  ---------------------------------------------------------------------------
}

unit u_cli_parse;

{$mode objfpc}{$H+}

interface

uses
  u_cli_types;

function ParseCommand: TCommand;

implementation

uses
  SysUtils,
  DateUtils;

// Mapping-Helfer
function CommandKindFromFlag(const S: string; out Kind: TCommandKind): boolean;
begin
  Result := True;
  if S = '--add' then Kind := ckAdd
  else if S = '--list' then Kind := ckList
  else if S = '--edit' then Kind := ckEdit
  else if S = '--delete' then Kind := ckDelete
  else if S = '--stats' then Kind := ckStats
  else Result := False;
end;

// Parst Tabellennamen in Aufzaehlungstyp und erlaubt Singular/Plural.
function ParseTableKind(const S: string; out Kind: TTableKind): boolean;
var
  L: string;
begin
  L := LowerCase(S);
  case L of
    'station', 'stations':
      begin
        Kind := tkStations;
        Exit(True);
      end;
    'fuelup', 'fuelups':
      begin
        Kind := tkFuelups;
        Exit(True);
      end;
  end;
  Result := False;
end;

function TryParseYYYYMM(const S: string; out Y, M: word): boolean;
var
  SY, SM: string;
  iY, iM: integer;
begin
  Result := False;
  if Length(S) <> 7 then Exit;
  if S[5] <> '-' then Exit;

  SY := Copy(S, 1, 4);
  SM := Copy(S, 6, 2);

  if (not TryStrToInt(SY, iY)) or (not TryStrToInt(SM, iM)) then Exit;
  if (iY < 1900) or (iY > 2200) then Exit;
  if (iM < 1) or (iM > 12) then Exit;

  Y := word(iY);
  M := word(iM);
  Result := True;
end;

function TryParseYYYYMMDD(const S: string; out Y, M, D: word): boolean;
var
  SY, SM, SD: string;
  iY, iM, iD: integer;
  Dt: TDateTime;
begin
  Result := False;
  if Length(S) <> 10 then Exit;
  if (S[5] <> '-') or (S[8] <> '-') then Exit;

  SY := Copy(S, 1, 4);
  SM := Copy(S, 6, 2);
  SD := Copy(S, 9, 2);

  if (not TryStrToInt(SY, iY)) or (not TryStrToInt(SM, iM)) or (not TryStrToInt(SD, iD)) then Exit;
  if (iY < 1900) or (iY > 2200) then Exit;

  // echte Kalenderpruefung
  if not TryEncodeDate(iY, iM, iD, Dt) then Exit;

  Y := word(iY);
  M := word(iM);
  D := word(iD);
  Result := True;
end;

// ------------------------------------------------------------
// Zeitraum-Parsing (--from/--to) -> ISO + exklusives Ende
function TryParseFromToValue(const S: string; out FromIso, ToExclIso: string): boolean;
var
  Y, M, D: word;
  DtStart, DtEnd: TDateTime;
begin
  Result := False;
  FromIso := '';
  ToExclIso := '';

  if TryParseYYYYMM(S, Y, M) then
  begin
    DtStart := EncodeDate(Y, M, 1);
    DtEnd := IncMonth(DtStart, 1);
    FromIso := FormatDateTime('yyyy-mm-dd hh:nn:ss', DtStart);
    ToExclIso := FormatDateTime('yyyy-mm-dd hh:nn:ss', DtEnd);
    Exit(True);
  end;

  if TryParseYYYYMMDD(S, Y, M, D) then
  begin
    DtStart := EncodeDate(Y, M, D);
    DtEnd := IncDay(DtStart, 1);
    FromIso := FormatDateTime('yyyy-mm-dd hh:nn:ss', DtStart);
    ToExclIso := FormatDateTime('yyyy-mm-dd hh:nn:ss', DtEnd);
    Exit(True);
  end;
end;

// Zentrale CLI-Parsing- und Regelpruefung; liefert Fehlertext + Fokus-Flag.
function BuildCommand(out Cmd: TCommand): boolean;
var
  i: integer;
  TmpKind: TCommandKind;
  TmpFromIso, TmpToExclIso: string;
begin
  FillChar(Cmd, SizeOf(Cmd), 0);
  Cmd.Kind := ckNone;
  Cmd.HasCommand := False;
  Cmd.Target := tkStations; // Standard egal, wird gesetzt, wenn HasCommand True

  Cmd.SeedStations := 10;
  Cmd.SeedFuelups := 100;
  Cmd.SeedValue := 0;
  Cmd.SeedForce := False;
  Cmd.UseDemoDb := False;

  i := 1;
  while i <= ParamCount do
  begin
    // Meta-Optionen
    if ParamStr(i) = '--help' then begin Cmd.Help := True; Inc(i); Continue; end;
    if ParamStr(i) = '--version' then begin Cmd.Version := True; Inc(i); Continue; end;
    if ParamStr(i) = '--about' then begin Cmd.About := True; Inc(i); Continue; end;

    // Optionen
    if ParamStr(i) = '--debug' then begin Cmd.Debug := True; Inc(i); Continue; end;
    if ParamStr(i) = '--trace' then begin Cmd.Trace := True; Inc(i); Continue; end;
    if ParamStr(i) = '--quiet' then begin Cmd.Quiet := True; Inc(i); Continue; end;
    if ParamStr(i) = '--detail' then begin Cmd.Detail := True; Inc(i); Continue; end;
    if ParamStr(i) = '--json' then begin Cmd.Json := True; Inc(i); Continue; end;
    if ParamStr(i) = '--monthly' then begin Cmd.Monthly := True; Inc(i); Continue; end;
    if ParamStr(i) = '--yearly' then begin Cmd.Yearly := True; Inc(i); Continue; end;
    if ParamStr(i) = '--csv' then begin Cmd.Csv := True; Inc(i); Continue; end;
    if ParamStr(i) = '--dashboard' then begin Cmd.Dashboard := True; Inc(i); Continue; end;
    if ParamStr(i) = '--pretty' then begin Cmd.Pretty := True; Inc(i); Continue; end;

    // ------------------------------------------------------------
    // Zeitraum-Optionen: --from/--to (nur fuer --stats fuelups)
    if ParamStr(i) = '--from' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --from benoetigt einen Wert (YYYY-MM oder YYYY-MM-DD).'; Cmd.ErrorFocus := efStatsPeriod; Exit(False); end;
      Cmd.FromProvided := True;
      Cmd.PeriodEnabled := True;
      if not TryParseFromToValue(ParamStr(i + 1), Cmd.PeriodFromIso, Cmd.PeriodToExclIso) then
      begin
        Cmd.ErrorMsg := 'Fehler: --from hat ein ungueltiges Format. Erwartet: YYYY-MM oder YYYY-MM-DD.';
        Cmd.ErrorFocus := efStatsPeriod;
        Exit(False);
      end;
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--to' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --to benoetigt einen Wert (YYYY-MM oder YYYY-MM-DD).'; Cmd.ErrorFocus := efStatsPeriod; Exit(False); end;
      Cmd.ToProvided := True;
      Cmd.PeriodEnabled := True;

      // Achtung: --to wird als *exklusives Ende* gespeichert:
      // Wir parsen den Wert ebenfalls als Zeitraum und nehmen das ToExclIso.
      // Beispiel: --to 2025-02-28 -> ToExcl = 2025-03-01 00:00:00
      if not TryParseFromToValue(ParamStr(i + 1), TmpFromIso, TmpToExclIso) then
      begin
        Cmd.ErrorMsg := 'Fehler: --to hat ein ungueltiges Format. Erwartet: YYYY-MM oder YYYY-MM-DD.';
        Cmd.ErrorFocus := efStatsPeriod;
        Exit(False);
      end;

      Cmd.PeriodToExclIso := TmpToExclIso;
      Inc(i, 2);
      Continue;
    end;

    // Seed/Demo-Optionen: --seed ist ein exklusives Hauptkommando, die uebrigen sind Zusatzparameter.
    if ParamStr(i) = '--seed' then
    begin
      if Cmd.HasCommand then
      begin
        Cmd.ErrorMsg := 'Fehler: --seed darf nicht mit anderen Kommandos kombiniert werden.';
        Cmd.ErrorFocus := efSeed;
        Exit(False);
      end;
      Cmd.Kind := ckSeed;
      Cmd.HasCommand := True;
      Inc(i);
      Continue;
    end;

    // Laufzeit-Schalter fuer Seed/Demo
    if ParamStr(i) = '--demo' then
    begin
      Cmd.UseDemoDb := True;
      Inc(i);
      Continue;
    end;

    if ParamStr(i) = '--force' then
    begin
      Cmd.SeedForce := True;
      Inc(i);
      Continue;
    end;

    // Seed-Parameter mit Zahlenwert
    if ParamStr(i) = '--stations' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --stations benötigt eine Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      if not TryStrToInt(ParamStr(i + 1), Cmd.SeedStations) then begin Cmd.ErrorMsg := 'Fehler: --stations benötigt eine gültige Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--fuelups' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --fuelups benötigt eine Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      if not TryStrToInt(ParamStr(i + 1), Cmd.SeedFuelups) then begin Cmd.ErrorMsg := 'Fehler: --fuelups benötigt eine gültige Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--seed-value' then
    begin
      if i + 1 > ParamCount then begin Cmd.ErrorMsg := 'Fehler: --seed-value benötigt eine Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      if not TryStrToInt(ParamStr(i + 1), Cmd.SeedValue) then begin Cmd.ErrorMsg := 'Fehler: --seed-value benötigt eine gültige Zahl.'; Cmd.ErrorFocus := efSeed; Exit(False); end;
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--show-config' then begin Cmd.ShowConfig := True; Inc(i); Continue; end;
    if ParamStr(i) = '--reset-config' then begin Cmd.ResetConfig := True; Inc(i); Continue; end;

    // DB-Optionen (2 Parameter)
    if ParamStr(i) = '--db' then
    begin
      if i + 1 > ParamCount then
      begin
        Cmd.ErrorMsg := 'Fehler: --db benötigt einen Pfad.';
        Cmd.ErrorFocus := efDb;
        Exit(False);
      end;
      Cmd.DbOverride := ParamStr(i + 1);
      Inc(i, 2);
      Continue;
    end;

    if ParamStr(i) = '--db-set' then
    begin
      if i + 1 > ParamCount then
      begin
        Cmd.ErrorMsg := 'Fehler: --db-set benötigt einen Pfad.';
        Cmd.ErrorFocus := efDbSet;
        Exit(False);
      end;
      Cmd.DbSet := ParamStr(i + 1);
      Inc(i, 2);
      Continue;
    end;

    // Hauptkommandos: --add/--list/--edit/--delete <stations|fuelups>
    if CommandKindFromFlag(ParamStr(i), TmpKind) then
    begin
      if Cmd.HasCommand then
      begin
        Cmd.ErrorMsg := 'Fehler: Genau EIN Kommando ist erlaubt.';
        Cmd.ErrorFocus := efCommand;
        Exit(False);
      end;

      if i + 1 > ParamCount then
      begin
        Cmd.ErrorMsg := 'Fehler: ' + ParamStr(i) + ' benötigt eine Tabelle.';
        Cmd.ErrorFocus := efCommand;
        Exit(False);
      end;

      // Tabellenart parsen (Singular/Plural)
      if not ParseTableKind(ParamStr(i + 1), Cmd.Target) then
      begin
        Cmd.ErrorMsg := 'Fehler: "' + ParamStr(i + 1) +
          '" ist keine gültige Tabelle (erlaubt: stations|fuelups).';
        Cmd.ErrorFocus := efTarget;
        Exit(False);
      end;

      Cmd.Kind := TmpKind;
      Cmd.HasCommand := True;

      Inc(i, 2);
      Continue;
    end;

    // Unbekannt
    Cmd.ErrorMsg := 'Fehler: Unbekanntes Argument: ' + ParamStr(i);
    Cmd.ErrorFocus := efNone;
    Exit(False);
  end;

  // ----------------
  // Zentrale Validierung (Regeln)

  if (Cmd.DbOverride <> '') and (Cmd.DbSet <> '') then
  begin
    Cmd.ErrorMsg := 'Fehler: --db und --db-set können nicht zusammen verwendet werden.';
    Cmd.ErrorFocus := efDbSet;
    Exit(False);
  end;

  // --seed ist eine isolierte Aktion (Demo-DB)
  // Keine Kombination mit --db / --db-set / --demo oder anderen Commands
  if Cmd.HasCommand and (Cmd.Kind = ckSeed) then
  begin
    if (Cmd.DbOverride <> '') or (Cmd.DbSet <> '') or Cmd.UseDemoDb then
    begin
      Cmd.ErrorMsg :=
        'Fehler: --seed verwendet immer die Demo-DB und darf nicht mit ' +
        '--db, --db-set oder --demo kombiniert werden.';
      Cmd.ErrorFocus := efSeed;
      Exit(False);
    end;
  end;

  if Cmd.HasCommand and (Cmd.Kind = ckSeed) and Cmd.UseDemoDb then
  begin
    Cmd.ErrorMsg := 'Fehler: --demo ist bei --seed nicht erforderlich.';
    Cmd.ErrorFocus := efSeed;
    Exit(False);
  end;

  // Meta darf alleine stehen
  if Cmd.Help or Cmd.Version or Cmd.About then Exit(True);

  // --db-set / show / reset sind Aktionen ohne Hauptkommando
  if Cmd.DbSet <> '' then Exit(True);
  if Cmd.ShowConfig or Cmd.ResetConfig then Exit(True);

  // sonst: Hauptkommando noetig
  if not Cmd.HasCommand then
  begin
    Cmd.ErrorMsg := 'Fehler: Kein Kommando angegeben.';
    Cmd.ErrorFocus := efNone;
    Exit(False);
  end;

  // Fachregel: fuelups nur add/list
  if (Cmd.Target = tkFuelups) and ((Cmd.Kind = ckEdit) or (Cmd.Kind = ckDelete)) then
  begin
    Cmd.ErrorMsg := 'Fehler: fuelups unterstützt nur add/list (append-only).';
    Cmd.ErrorFocus := efTarget;
    Exit(False);
  end;

  if Cmd.HasCommand and (Cmd.Kind = ckStats) and (Cmd.Target <> tkFuelups) then
  begin
    Cmd.ErrorMsg := 'Fehler: --stats ist aktuell nur fuer fuelups verfuegbar.';
    Cmd.ErrorFocus := efStats;
    Exit(False);
  end;

  // --dashboard ist nur fuer "--stats fuelups" erlaubt und exklusiv zu json/csv
  if Cmd.Dashboard then
  begin
    if not (Cmd.HasCommand and (Cmd.Kind = ckStats) and (Cmd.Target = tkFuelups)) then
    begin
      Cmd.ErrorMsg := 'Fehler: --dashboard ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Json or Cmd.Csv then
    begin
      Cmd.ErrorMsg := 'Fehler: --dashboard kann nicht mit --json oder --csv kombiniert werden.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;

  // --json ist nur fuer "--stats fuelups" erlaubt
  if Cmd.Json then
  begin
    if not (Cmd.HasCommand and (Cmd.Kind = ckStats) and (Cmd.Target = tkFuelups)) then
    begin
      Cmd.ErrorMsg := 'Fehler: --json ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;

  // --csv ist nur fuer "--stats fuelups" erlaubt und exklusiv
  if Cmd.Csv then
  begin
    if not (Cmd.HasCommand and (Cmd.Kind = ckStats) and (Cmd.Target = tkFuelups)) then
    begin
      Cmd.ErrorMsg := 'Fehler: --csv ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Json then
    begin
      Cmd.ErrorMsg := 'Fehler: --csv und --json koennen nicht zusammen verwendet werden.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;

  // --pretty ist nur zusammen mit --json erlaubt (und damit nur bei --stats fuelups)
  if Cmd.Pretty then
  begin
    if not Cmd.Json then
    begin
      Cmd.ErrorMsg := 'Fehler: --pretty ist nur zusammen mit --json erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if not (Cmd.HasCommand and (Cmd.Kind = ckStats) and (Cmd.Target = tkFuelups)) then
    begin
      Cmd.ErrorMsg := 'Fehler: --pretty ist nur zusammen mit "--stats fuelups --json" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;

  // --monthly ist nur fuer "--stats fuelups" erlaubt
  if Cmd.Monthly then
  begin
    if not (Cmd.HasCommand and (Cmd.Kind = ckStats) and (Cmd.Target = tkFuelups)) then
    begin
      Cmd.ErrorMsg := 'Fehler: --monthly ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;

  // --yearly ist nur fuer "--stats fuelups" erlaubt
  if Cmd.Yearly then
  begin
    if not (Cmd.HasCommand and (Cmd.Kind = ckStats) and (Cmd.Target = tkFuelups)) then
    begin
      Cmd.ErrorMsg := 'Fehler: --yearly ist nur zusammen mit "--stats fuelups" erlaubt.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Monthly then
    begin
      Cmd.ErrorMsg := 'Fehler: --yearly und --monthly können nicht zusammen verwendet werden.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Dashboard then
    begin
      Cmd.ErrorMsg := 'Fehler: --yearly kann nicht mit --dashboard kombiniert werden.';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;

    if Cmd.Csv then
    begin
      Cmd.ErrorMsg := 'Fehler: --yearly ist aktuell nicht als CSV verfügbar (nur Text/JSON).';
      Cmd.ErrorFocus := efStatsFormat;
      Exit(False);
    end;
  end;

  // Zeitraum-Flags nur fuer --stats fuelups erlaubt
  // ------------------------------------------------------------
  // Zeitraum-Regeln und Open-Ended-Normalisierung
  if Cmd.PeriodEnabled then
  begin
    if not (Cmd.HasCommand and (Cmd.Kind = ckStats) and (Cmd.Target = tkFuelups)) then
    begin
      Cmd.ErrorMsg := 'Fehler: --from/--to sind nur in Kombination mit --stats fuelups erlaubt.';
      Cmd.ErrorFocus := efStatsPeriod;
      Exit(False);
    end;

    // Beide gesetzt: from <= to (exklusiv) pruefen
    if Cmd.FromProvided and Cmd.ToProvided then
    begin
      if Cmd.PeriodFromIso >= Cmd.PeriodToExclIso then
      begin
        Cmd.ErrorMsg := 'Fehler: Ungueltiger Zeitraum: --from muss vor --to liegen.';
        Cmd.ErrorFocus := efStatsRange;
        Exit(False);
      end;
    end;

    // Open-ended: wird datengetrieben in Schritt 2 gefuellt.
    // Hier nur sicherstellen, dass wir *wissen*, was offen ist.
    if Cmd.FromProvided and (not Cmd.ToProvided) then
    begin
      // PeriodToExclIso ist aktuell vom --from gesetzt (naechster Tag/Monat),
      // das ist nur ein Platzhalter und wird in Schritt 2 ersetzt.
      Cmd.PeriodToExclIso := '';
    end;

    if Cmd.ToProvided and (not Cmd.FromProvided) then
    begin
      Cmd.PeriodFromIso := '';
    end;
  end;

  Result := True;
end;

function ParseCommand: TCommand;
begin
  BuildCommand(Result);
end;

end.

````

## Datei: `units/u_cli_types.pas`

````pascal
{
  u_cli_types.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Zentrale CLI-Typdefinitionen fuer Betankungen.

  Verantwortlichkeiten:
  - Definiert die kanonischen Enums fuer Kommando/Target/Fehlerfokus.
  - Definiert den Parser-Zustand (`TCommand`) als einheitliches
    Transportobjekt zwischen CLI-Parser und Orchestrator.
  - Stellt kleine Mapping-Helper bereit, um interne Enum-Werte
    in textuelle CLI-Token zu ueberfuehren.

  Design-Entscheidungen:
  - Single Source of Truth:
    CLI-Typen liegen ausschliesslich in dieser Unit, damit im
    Hauptprogramm keine Typduplikate und keine Drift entstehen.
  - Schlanker Parser-Transport:
    `TCommand` enthaelt nur Laufzeitdaten fuer Parsing/Validierung/
    Dispatch, keine Fach- oder DB-Logik.
  - Deterministischer Fehlerfokus:
    `TErrorFocus` kapselt "wohin die Hilfe zeigen soll", sodass
    Parser und Help-Ausgabe lose gekoppelt bleiben.

  Hinweis:
  - Bei neuen CLI-Flags oder Targets immer zuerst diese Unit erweitern
    und erst danach Parser/Usage/Dispatch anpassen.
  ---------------------------------------------------------------------------
}

unit u_cli_types;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  // Gueltige Datenziele der Hauptkommandos.
  // Wichtig: Kein tkNone, da der Orchestrator nur gueltige Targets
  // nach erfolgreichem Parsing weiterverarbeitet.
  TTableKind = (
    tkStations,
    tkFuelups
  );

  // Hauptkommandos der CLI.
  // Meta-Flags wie --help/--version/--about werden bewusst als
  // eigene Bool-Flags im TCommand gefuehrt (nicht als CommandKind).
  TCommandKind = (
    ckNone,
    ckAdd,
    ckList,
    ckEdit,
    ckDelete,
    ckSeed,
    ckStats
  );

  // Fehlerfokus fuer kontextsensitive Usage-Hinweise.
  // Dieser Enum wird bei Parser-Fehlern gesetzt und spaeter auf ein
  // passendes "Focus-Flag" (z. B. --db, --stats) gemappt.
  TErrorFocus = (
    // Kein spezifischer Fokus.
    efNone,
    // Fehler in der Auswahl des Hauptkommandos.
    efCommand,
    // Fehler bei stations/fuelups-Target.
    efTarget,
    // Fehler bei --db.
    efDb,
    // Fehler bei --db-set.
    efDbSet,
    // Fehler im Demo-Workflow.
    efDemo,
    // Fehler im Seed-Workflow.
    efSeed,
    // Allgemeiner Stats-Kontext.
    efStats,
    // Fehlerhafte Stats-Formatkombinationen (json/csv/dashboard/...).
    efStatsFormat,
    // Fehler in --from/--to Eingaben.
    efStatsPeriod,
    // Fehlerhafte Stats-Bereichslogik (z. B. from >= to).
    efStatsRange,
    // Meta-Kontext (z. B. --about).
    efMeta
  );

  // Zentrales Parser-Ergebnis.
  // Der Record wird in BuildCommand gefuellt und danach im
  // Hauptprogramm fuer Validierung, Meta-Pfade und Dispatch genutzt.
  TCommand = record
    // Hauptkommando + Ziel.
    Kind: TCommandKind;
    Target: TTableKind;
    HasCommand: boolean;

    // Ausgabe-/Stats-Flags.
    Detail: boolean;
    Json: boolean;
    Monthly: boolean;
    Yearly: boolean;
    Csv: boolean;
    Dashboard: boolean;
    Pretty: boolean;

    // Zeitraum-Status und normalisierte ISO-Grenzen.
    // PeriodFromIso: inklusiv, PeriodToExclIso: exklusiv.
    PeriodEnabled: boolean;
    FromProvided: boolean;
    ToProvided: boolean;
    PeriodFromIso: string;
    PeriodToExclIso: string;

    // Seed-/Demo-Parameter.
    SeedStations: integer;
    SeedFuelups: integer;
    SeedValue: integer;
    SeedForce: boolean;
    UseDemoDb: boolean;

    // Meta-Flags.
    Help: boolean;
    Version: boolean;
    About: boolean;
    ShowConfig: boolean;
    ResetConfig: boolean;

    // Laufzeitdiagnose.
    Debug: boolean;
    Trace: boolean;
    Quiet: boolean;

    // Datenbankoptionen.
    DbOverride: string;
    DbSet: string;

    // Fehlertransport aus dem Parser.
    ErrorMsg: string;
    ErrorFocus: TErrorFocus;
  end;

// Enum -> Token Mapping fuer Targets.
// Rueckgabe ist leer fuer unbekannte/undefinierte Werte.
function TableKindToString(K: TTableKind): String;
// Enum -> Token Mapping fuer Hauptkommandos.
// Rueckgabe ist leer fuer ckNone.
function CommandKindToString(K: TCommandKind): String;
// Fehlerfokus -> bevorzugtes Focus-Flag fuer Usage-Ausgabe.
// Mehrere Enum-Werte duerfen auf dasselbe Flag mappen.
function ErrorFocusToFlag(F: TErrorFocus): String;

implementation

function TableKindToString(K: TTableKind): String;
begin
  // Kleines, stabiles Mapping fuer CLI-Token.
  case K of
    tkStations: Result := 'stations';
    tkFuelups : Result := 'fuelups';
  else
    Result := '';
  end;
end;

function CommandKindToString(K: TCommandKind): String;
begin
  // Nur echte Hauptkommandos liefern ein Token.
  case K of
    ckAdd:        Result := 'add';
    ckList:       Result := 'list';
    ckEdit:       Result := 'edit';
    ckDelete:     Result := 'delete';
    ckStats:      Result := 'stats';
    ckSeed:       Result := 'seed';
    ckNone:       Result := '';
  else
    Result := '';
  end;
end;

function ErrorFocusToFlag(F: TErrorFocus): String;
begin
  // Liefert das Flag, das fuer Hilfe/Usage am sinnvollsten ist.
  // Das Mapping ist bewusst pragmatisch und nicht 1:1.
  case F of
    efDb:          Result := '--db';
    efDbSet:       Result := '--db-set';
    efDemo:        Result := '--demo';
    efSeed:        Result := '--seed';
    efStats:       Result := '--stats';
    efStatsFormat: Result := '--stats';
    efStatsPeriod: Result := '--from';
    efStatsRange:  Result := '--from';
    efCommand:     Result := '--add';
    efTarget:      Result := '--list';
    efMeta:        Result := '--about';
  else
    Result := '';
  end;
end;

end.

````

## Datei: `units/u_db_common.pas`

````pascal
{
  u_db_common.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Zentrale Eingabe- und Parse-Utilities fuer den CLI-Dialogfluss.

  Verantwortlichkeiten:
  - Kapselt konsistente Konsolenabfragen (Pflicht/Optional/Keep/YesNo).
  - Liefert robuste Validierung fuer Pflichtfelder vor Persistenz.
  - Implementiert strict Fixed-Point-Parsing fuer Geld-/Mengenwerte.

  Design-Entscheidungen:
  - Fixed-Point-First: Int64 statt Float fuer deterministische Werte.
  - Strict Input: Nachkommastellen werden explizit erzwungen.
  - DB-frei: Keine SQL-Logik, nur UI-nahe Vorvalidierung.

  Hinweis:
  - Parse-Funktionen normalisieren Komma auf Punkt vor der Auswertung.
  ---------------------------------------------------------------------------
}

unit u_db_common;

{$mode objfpc}{$H+}

interface

type
  // Parser-Signatur fuer dialoggefuehrte Zahleneingaben.
  TParseInt64Func = function(const S: string): Int64;
  // Formatter-Signatur fuer Bestaetigungsausgaben.
  TFormatInt64Func = function(const V: Int64): string;

const
  // Rueckgabewert fuer "leer" bei optionalen Zahlenfeldern
  EMPTY_INT64 = Low(Int64);

// ----------------
// Eingabe-Helfer fuer interaktive Dialoge

// Liest ein Pflichtfeld (wiederholt bis nicht-leer).
function AskRequired(const Prompt: string): string;
// Liest ein optionales Feld (trimmed, darf leer sein).
function AskOptional(const Prompt: string): string;

// Eingabetaste = aktuellen Wert behalten (Edit-Flow).
function AskKeep(const Prompt, Current: string): string;

// Validiert, dass ein Wert nicht leer ist.
procedure EnsureNotEmpty(const FieldName, Value: string);

// Standardisierte Ja/Nein-Abfrage mit konfigurierbarem Default.
function AskYesNo(const Prompt: string; DefaultNo: boolean = True): boolean;

// ----------------
// Parsing-Helfer fuer skalierte Int64-Werte

// Erzwingt exakt eines von zwei Dezimalformaten.
function ParseScaledIntExactOneOf(const S: string; const ADecimals1, ADecimals2: Integer; const AName: string): Int64;
// Erzwingt exakt eine feste Anzahl Nachkommastellen.
function ParseScaledIntExact(const S: string; const ADecimals: Integer; const AName: string): Int64;
// Spezialparser: Liter -> Milliliter (Int64).
function ParseLitersToMl(const S: string): int64;
// Spezialparser: Euro -> Cents (Int64).
function ParseEuroToCents(const S: string): int64;
// Spezialparser: EUR/L -> milli-EUR (Int64).
function ParseEurPerLiterToMilli(const S: string): int64;
// Kombinierter Ask+Parse-Loop inkl. Bestaetigung und Retry.
function AskAndParseInt64(
  const Prompt: string;
  ParseFunc: TParseInt64Func;
  FormatFunc: TFormatInt64Func;
  const LabelName: string;
  AllowEmpty: boolean = False // wenn True: Rueckgabe EMPTY_INT64 bei leerer Eingabe
): Int64;

implementation

uses
  SysUtils, Math;

function AskRequired(const Prompt: string): string;
var
  Input: string;
begin
  repeat
    Write(Prompt);
    ReadLn(Input);
    Input := Trim(Input);
    if Input = '' then
      WriteLn('Fehler: Diese Eingabe darf nicht leer sein!');
  until Input <> '';
  Result := Input;
end;

function AskOptional(const Prompt: string): string;
var
  Input: string;
begin
  Write(Prompt);
  ReadLn(Input);
  Result := Trim(Input);
end;

function AskKeep(const Prompt, Current: string): string;
var
  Input: string;
begin
  Write(Prompt, ' [', Current, ']: ');
  ReadLn(Input);
  Input := Trim(Input);
  if Input = '' then
    Result := Current
  else
    Result := Input;
end;

procedure EnsureNotEmpty(const FieldName, Value: string);
begin
  if Trim(Value) = '' then
    raise Exception.Create('Pflichtfeld darf nicht leer sein: ' + FieldName);
end;

function AskYesNo(const Prompt: string; DefaultNo: boolean): boolean;
var
  S: string;
begin
  if DefaultNo then
    Write(Prompt, ' (y/N): ')
  else
    Write(Prompt, ' (Y/n): ');

  ReadLn(S);
  S := LowerCase(Trim(S));

  if S = '' then
    Exit(not DefaultNo);

  Result := (S = 'y') or (S = 'yes') or (S = 'j') or (S = 'ja');
end;

function AskAndParseInt64(
  const Prompt: string;
  ParseFunc: TParseInt64Func;
  FormatFunc: TFormatInt64Func;
  const LabelName: string;
  AllowEmpty: boolean = False
): Int64;
var
  S: string;
begin
  while True do
  begin
    Write(Prompt);
    ReadLn(S);
    S := Trim(S);

    // Abbruch
    if (LowerCase(S) = 'q') or (LowerCase(S) = 'quit') then
      raise Exception.Create(LabelName + ': Abgebrochen durch Benutzer.');

    // Optionales Feld
    if AllowEmpty and (S = '') then
      Exit(EMPTY_INT64); // Konvention: "leer" ist eindeutig von Null unterscheidbar

    if (not AllowEmpty) and (S = '') then
    begin
      WriteLn('Fehler: Eingabe darf nicht leer sein. (oder q zum Abbrechen)');
      Continue;
    end;

    try
      Result := ParseFunc(S);

      // Bestaetigung: zeigt formatierten und rohen Wert
      WriteLn('OK: ', LabelName, ' = ', FormatFunc(Result),
              '  [raw=', Result, ']');

      Exit;
    except
      on E: Exception do
      begin
        WriteLn('Fehler: ', E.Message);
        WriteLn('Bitte erneut eingeben (oder q zum Abbrechen).');
      end;
    end;
  end;
end;

function ParseScaledIntExact(const S: string; const ADecimals: Integer; const AName: string): Int64;
var
  T, IntPart, FracPart: string;
  P, I: Integer;
  Scale: Int64;
begin
  T := Trim(S);
  if T = '' then
    raise Exception.Create(AName + ': Eingabe ist leer');

  if T[1] = '-' then
    raise Exception.Create(AName + ': Wert darf nicht negativ sein');

  // Normalisieren: Komma wird zu Punkt
  T := StringReplace(T, ',', '.', [rfReplaceAll]);

  // Split an Punkt
  P := Pos('.', T);
  if P > 0 then
  begin
    IntPart := Copy(T, 1, P-1);
    FracPart := Copy(T, P+1, Length(T));
  end
  else
  begin
    IntPart := T;
    FracPart := '';
  end;

  if IntPart = '' then IntPart := '0';

  // Nur Ziffern erlauben
  for I := 1 to Length(IntPart) do
    if not (IntPart[I] in ['0'..'9']) then
      raise Exception.Create(AName + ': Ungültige Zahl "' + S + '"');

  for I := 1 to Length(FracPart) do
    if not (FracPart[I] in ['0'..'9']) then
      raise Exception.Create(AName + ': Ungültige Zahl "' + S + '"');

  // Exakt ADecimals Nachkommastellen verlangen
  if Length(FracPart) <> ADecimals then
    raise Exception.Create(AName + ': Erwartet genau ' + IntToStr(ADecimals) +
      ' Nachkommastellen (z.B. 1.' + StringOfChar('0', ADecimals) + ')');

  Scale := Trunc(IntPower(10, ADecimals));
  Result := StrToInt64(IntPart) * Scale;

  if ADecimals > 0 then
    Result := Result + StrToInt64(FracPart);
end;

function ParseScaledIntExactOneOf(const S: string; const ADecimals1, ADecimals2: Integer; const AName: string): Int64;
var
  T: string;
  P: Integer;
  FracLen: Integer;
begin
  T := Trim(S);
  if T = '' then
    raise Exception.Create(AName + ': Eingabe ist leer');

  if T[1] = '-' then
    raise Exception.Create(AName + ': Wert darf nicht negativ sein');

  T := StringReplace(T, ',', '.', [rfReplaceAll]);

  P := Pos('.', T);
  if P > 0 then
    FracLen := Length(T) - P
  else
    FracLen := 0;

  if not ((FracLen = ADecimals1) or (FracLen = ADecimals2)) then
    raise Exception.Create(AName + ': Erwartet genau ' + IntToStr(ADecimals1) +
      ' oder ' + IntToStr(ADecimals2) + ' Nachkommastellen.');

  // Wir speichern auf drei Dezimalstellen skaliert (ml).
  if FracLen = 2 then
    Result := ParseScaledIntExact(T + '0', 3, AName)
  else
    Result := ParseScaledIntExact(T, 3, AName);
end;

// ----------------
// Oeffentliche Wrapper

function ParseEuroToCents(const S: string): Int64;
begin
  // Exakt zwei Nachkommastellen
  Result := ParseScaledIntExact(S, 2, 'EUR');
end;

function ParseEurPerLiterToMilli(const S: string): Int64;
begin
  // Exakt drei Nachkommastellen
  Result := ParseScaledIntExact(S, 3, 'EUR/L');
end;

function ParseLitersToMl(const S: string): Int64;
begin
  // Exakt zwei oder drei Nachkommastellen (bon-abhaengig), gespeichert als ml
  Result := ParseScaledIntExactOneOf(S, 2, 3, 'Liter');
end;
end.

````

## Datei: `units/u_db_init.pas`

````pascal
{
  u_db_init.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Datenbank-Bootstrapper und Schema-Verwaltung fuer SQLite.

  Verantwortlichkeiten:
  - Automatisches Provisioning: Erstellt die SQLite-Datei bei Erststart.
  - Idempotentes Schema-Design: Stellt Tabellen, Indizes und Trigger bereit,
    ohne bestehende Daten zu gefaehrden (IF NOT EXISTS / IF EXISTS).
  - Metadaten-Management: Initialisiert und aktualisiert technische Kennzahlen
    (Schema-Versionen, Start-KM-Stände, Zeitstempel) in der 'meta'-Tabelle.
  - Datenintegritaet: Erzwingt Constraints (FK, CHECK) und nutzt atomare
    Transaktionen für den gesamten Initialisierungsprozess.

  Design-Entscheidungen:
  - Transaktionssicherheit: Alles oder Nichts. Schlaegt ein Teil des Schemas
    fehl, wird die gesamte DB in den Vorzustand versetzt (Rollback).
  - Robustheit: Explizite Trennung von technischem Fehlerhandling (try-except)
    und Ressourcen-Bereinigung (try-finally).
  - Skalierbarkeit: Vorbereitet fuer zukuenftige Migrations-Logik durch
    zentrale Speicherung der 'schema_version'.

  Hinweis: Die Unit nutzt die SQLDB-Komponenten von Free Pascal (TSQLite3Connection).

  Schema-Historie:
  v1: Basis-Metadaten (meta-Tabelle)
  v2: Stammdaten für Tankstellen (stations)
  v3: Transaktionsdaten für Betankungen (fuelups) inkl. Start-KM Logik
  v4: Fuelups erweitert um car_id + missed_previous, neue cars-Tabelle

  Hinweis: Bei Schema-Änderungen bitte die 'schema_version' in der 
  EnsureDatabase-Prozedur UND hier im Header inkrementieren.
  ---------------------------------------------------------------------------
}
unit u_db_init;

{$mode objfpc}{$H+}

interface

// ----------------
// Stellt sicher, dass die DB existiert und das Schema aktuell ist.
// Rueckgabewert: True, wenn die DB-Datei neu angelegt wurde.
function EnsureDatabase(const DbPath: string): boolean;

// Liest einen Wert aus der meta-Tabelle (technische Key-Value Metadaten).
function ReadMetaValue(const DbPath, AKey: string): string;

implementation

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, u_log;

// ----------------
// Stellt sicher, dass die DB existiert und das Schema aktuell ist.
// Rueckgabewert: True, wenn die DB-Datei neu angelegt wurde.
function EnsureDatabase(const DbPath: string): boolean;
var
  CreatedNow: boolean;
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  HasFuelupsTable: boolean;
  HasCarsTable: boolean;
  HasCarPlate: boolean;
  HasCarNote: boolean;
  HasCarOdometerStartKm: boolean;
  HasCarOdometerStartDate: boolean;
  HasCarId: boolean;
  HasMissedPrevious: boolean;
  DefaultCarId: integer;
  MetaOdoStartKm: integer;
  MetaOdoStartDate: string;
  MetaTmp: string;
  CarIdExpr: string;
  MissedPreviousExpr: string;

  function TableExists(const TableName: string): boolean;
  begin
    Q.Close;
    Q.SQL.Text :=
      'SELECT 1 ' +
      'FROM sqlite_master ' +
      'WHERE type = ''table'' AND name = :name ' +
      'LIMIT 1;';
    Q.Params.ParamByName('name').AsString := TableName;
    Q.Open;
    Result := not Q.EOF;
    Q.Close;
  end;

  function ColumnExists(const TableName, ColumnName: string): boolean;
  begin
    Result := False;
    Q.Close;
    Q.SQL.Text := 'PRAGMA table_info(' + TableName + ');';
    Q.Open;
    while not Q.EOF do
    begin
      if SameText(Q.FieldByName('name').AsString, ColumnName) then
      begin
        Result := True;
        Break;
      end;
      Q.Next;
    end;
    Q.Close;
  end;
begin
  // Existiert die Datei bereits? (Conn.Open legt sie an, falls nicht vorhanden)
  CreatedNow := not FileExists(DbPath);

  Dbg('EnsureDatabase: ' + ExpandFileName(DbPath));
  Dbg('CreatedNow=' + BoolToStr(CreatedNow, True));

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);

  try
    try
      // Verbindung und Transaktion verdrahten
      Conn.DatabaseName := DbPath;
      Conn.Transaction := Tran;
      Q.DataBase := Conn;
      Q.Transaction := Tran;

      // Verbindung oeffnen und Transaktion starten
      Dbg('Opening connection...');
      Conn.Open;
      Dbg('Connection open.');

      Dbg('Starting transaction...');
      // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
      if not Tran.Active then
        Tran.StartTransaction;

      // Technische Metadaten-Tabelle
      Dbg('Ensuring meta table...');
      Q.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS meta (' + '  key   TEXT PRIMARY KEY,' +
        '  value TEXT' + ');';
      Q.ExecSQL;

      // Schema-Version setzen (fuer spaetere Migrationen)
      Q.SQL.Text := 'INSERT OR REPLACE INTO meta(key, value) VALUES(:k, :v);';
      Q.Params.ParamByName('k').AsString := 'schema_version';
      Q.Params.ParamByName('v').AsString := '4';
      Q.ExecSQL;

      // App-Name (rein informativ)
      Q.SQL.Text := 'INSERT OR REPLACE INTO meta(key, value) VALUES(:k, :v);';
      Q.Params.ParamByName('k').AsString := 'app_name';
      Q.Params.ParamByName('v').AsString := 'Betankungen';
      Q.ExecSQL;

      // v3-Altlast: Startwerte lagen frueher in meta.
      // Ab v4 werden sie in cars persistiert, meta gilt nur noch als Migrationsquelle.
      // Fuer neue DBs legen wir konservative Defaults an (werden spaeter in cars uebernommen).
      if CreatedNow then
      begin
        Q.SQL.Text := 'INSERT OR IGNORE INTO meta(key, value) VALUES("odometer_start_km", "1");';
        Q.ExecSQL;

        Q.SQL.Text := 'INSERT OR IGNORE INTO meta(key, value) VALUES("odometer_start_date", date("now"));';
        Q.ExecSQL;
      end;

      // Erst-Erstellungsdatum nur beim ersten Anlegen
      if CreatedNow then
      begin
        Q.SQL.Text :=
          'INSERT OR IGNORE INTO meta(key, value) ' +
          'VALUES("db_created_at", date("now"));';
        Q.ExecSQL;
      end;

      // Letzte Ausfuehrung immer aktualisieren
      Q.SQL.Text :=
        'INSERT OR REPLACE INTO meta(key, value) ' +
        'VALUES("db_last_run", datetime("now"));';
      Q.ExecSQL;

      // Fach-Tabelle: stations
      Dbg('Ensuring stations table...');
      Q.SQL.Text :=
        'CREATE TABLE IF NOT EXISTS stations (' +
        '  id         INTEGER PRIMARY KEY,' + 
        '  brand      TEXT NOT NULL,' +
        '  street     TEXT NOT NULL,' + 
        '  house_no   TEXT NOT NULL,' +
        '  zip        TEXT NOT NULL,' + 
        '  city       TEXT NOT NULL,' +
        '  phone      TEXT,' + 
        '  owner      TEXT,' +
        '  created_at TEXT NOT NULL DEFAULT (datetime(''now'')),' +
        '  updated_at TEXT' + 
        ');';
      Q.ExecSQL;

      // Indizes und Unique-Constraint fuer Duplikate (Adresse)
      Dbg('Ensuring stations indexes...');

      Q.SQL.Text :=
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_stations_unique_location ' +
        'ON stations(street, house_no, zip, city);';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_stations_brand ON stations(brand);';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_stations_city ON stations(city);';
      Q.ExecSQL;

      MetaOdoStartKm := 1;
      MetaOdoStartDate := FormatDateTime('yyyy"-"mm"-"dd', Date);

      Q.Close;
      Q.SQL.Text := 'SELECT value FROM meta WHERE key = ''odometer_start_km'' LIMIT 1;';
      Q.Open;
      if not Q.EOF then
      begin
        MetaTmp := Trim(Q.FieldByName('value').AsString);
        if not TryStrToInt(MetaTmp, MetaOdoStartKm) then
          MetaOdoStartKm := 1;
      end;
      Q.Close;

      Q.SQL.Text := 'SELECT value FROM meta WHERE key = ''odometer_start_date'' LIMIT 1;';
      Q.Open;
      if not Q.EOF then
      begin
        MetaTmp := Trim(Q.FieldByName('value').AsString);
        if MetaTmp <> '' then
          MetaOdoStartDate := MetaTmp;
      end;
      Q.Close;

      // Fach-Tabelle: cars (v4 inkl. evtl. Migration von frueherem v4-light)
      HasCarsTable := TableExists('cars');
      HasCarPlate := HasCarsTable and ColumnExists('cars', 'plate');
      HasCarNote := HasCarsTable and ColumnExists('cars', 'note');
      HasCarOdometerStartKm := HasCarsTable and ColumnExists('cars', 'odometer_start_km');
      HasCarOdometerStartDate := HasCarsTable and ColumnExists('cars', 'odometer_start_date');

      if not HasCarsTable then
      begin
        Dbg('Ensuring cars table (v4 fresh create)...');
        Q.SQL.Text :=
          'CREATE TABLE IF NOT EXISTS cars (' +
          '  id                  INTEGER PRIMARY KEY,' +
          '  name                TEXT    NOT NULL,' +
          '  plate               TEXT,' +
          '  note                TEXT,' +
          '  odometer_start_km   INTEGER NOT NULL CHECK (odometer_start_km > 0),' +
          '  odometer_start_date TEXT    NOT NULL,' +
          '  created_at          TEXT    NOT NULL DEFAULT (datetime(''now'')),' +
          '  updated_at          TEXT,' +
          '  UNIQUE(name)' +
          ');';
        Q.ExecSQL;
      end
      else if (not HasCarPlate) or (not HasCarNote) or
              (not HasCarOdometerStartKm) or (not HasCarOdometerStartDate) then
      begin
        Dbg('Migrating cars schema to full v4...');

        Q.SQL.Text := 'DROP TABLE IF EXISTS cars_new;';
        Q.ExecSQL;

        Q.SQL.Text :=
          'CREATE TABLE cars_new (' +
          '  id                  INTEGER PRIMARY KEY,' +
          '  name                TEXT    NOT NULL,' +
          '  plate               TEXT,' +
          '  note                TEXT,' +
          '  odometer_start_km   INTEGER NOT NULL CHECK (odometer_start_km > 0),' +
          '  odometer_start_date TEXT    NOT NULL,' +
          '  created_at          TEXT    NOT NULL DEFAULT (datetime(''now'')),' +
          '  updated_at          TEXT,' +
          '  UNIQUE(name)' +
          ');';
        Q.ExecSQL;

        Q.SQL.Text :=
          'INSERT INTO cars_new (' +
          '  id, name, plate, note, odometer_start_km, odometer_start_date, created_at, updated_at' +
          ') ' +
          'SELECT ' +
          '  id, name, NULL, NULL, :start_km, :start_date, ' +
          '  COALESCE(created_at, datetime(''now'')), updated_at ' +
          'FROM cars;';
        Q.Params.ParamByName('start_km').AsInteger := MetaOdoStartKm;
        Q.Params.ParamByName('start_date').AsString := MetaOdoStartDate;
        Q.ExecSQL;

        Q.SQL.Text := 'DROP TABLE cars;';
        Q.ExecSQL;

        Q.SQL.Text := 'ALTER TABLE cars_new RENAME TO cars;';
        Q.ExecSQL;
      end;

      Q.SQL.Text :=
        'INSERT OR IGNORE INTO cars(' +
        '  id, name, odometer_start_km, odometer_start_date' +
        ') VALUES(' +
        '  1, ''Hauptauto'', :start_km, :start_date' +
        ');';
      Q.Params.ParamByName('start_km').AsInteger := MetaOdoStartKm;
      Q.Params.ParamByName('start_date').AsString := MetaOdoStartDate;
      Q.ExecSQL;

      // Immutability-Trigger fuer Startwerte
      Dbg('Ensuring cars immutability triggers...');
      Q.SQL.Text :=
        'CREATE TRIGGER IF NOT EXISTS trg_cars_immutable_start_km ' +
        'BEFORE UPDATE OF odometer_start_km ON cars ' +
        'FOR EACH ROW ' +
        'WHEN NEW.odometer_start_km <> OLD.odometer_start_km ' +
        'BEGIN ' +
        '  SELECT RAISE(ABORT, ''odometer_start_km is immutable''); ' +
        'END;';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE TRIGGER IF NOT EXISTS trg_cars_immutable_start_date ' +
        'BEFORE UPDATE OF odometer_start_date ON cars ' +
        'FOR EACH ROW ' +
        'WHEN NEW.odometer_start_date <> OLD.odometer_start_date ' +
        'BEGIN ' +
        '  SELECT RAISE(ABORT, ''odometer_start_date is immutable''); ' +
        'END;';
      Q.ExecSQL;

      Q.Close;
      Q.SQL.Text := 'SELECT id FROM cars ORDER BY id LIMIT 1;';
      Q.Open;
      if not Q.EOF then
        DefaultCarId := Q.FieldByName('id').AsInteger
      else
        DefaultCarId := 1;
      Q.Close;

      // Fach-Tabelle: fuelups (v4 inkl. Migration von v3)
      HasFuelupsTable := TableExists('fuelups');
      HasCarId := HasFuelupsTable and ColumnExists('fuelups', 'car_id');
      HasMissedPrevious := HasFuelupsTable and ColumnExists('fuelups', 'missed_previous');

      if not HasFuelupsTable then
      begin
        Dbg('Ensuring fuelups table (v4 fresh create)...');
        Q.SQL.Text :=
          'CREATE TABLE IF NOT EXISTS fuelups (' +
          '  id         INTEGER PRIMARY KEY,' +
          '  station_id                  INTEGER NOT NULL,' +
          '  car_id                      INTEGER NOT NULL,' +
          '  fueled_at                   TEXT    NOT NULL,' +
          '  odometer_km                 INTEGER NOT NULL,' +
          '  liters_ml                   INTEGER NOT NULL,' +
          '  total_cents                 INTEGER NOT NULL,' +
          '  price_per_liter_milli_eur   INTEGER NOT NULL,' +
          '  is_full_tank                INTEGER NOT NULL DEFAULT 0,' +
          '  missed_previous             INTEGER NOT NULL DEFAULT 0,' +
          '  fuel_type                   TEXT,' +
          '  payment_type                TEXT,' +
          '  pump_no                     TEXT,' +
          '  note                        TEXT,' +
          '  created_at                  TEXT NOT NULL DEFAULT (datetime(''now'')),' +
          '  updated_at                  TEXT,' +
          '  FOREIGN KEY(station_id) REFERENCES stations(id) ON DELETE RESTRICT,' +
          '  FOREIGN KEY(car_id)     REFERENCES cars(id)     ON DELETE RESTRICT,' +
          '  CHECK (odometer_km > 0),' +
          '  CHECK (liters_ml > 0),' +
          '  CHECK (total_cents >= 0),' +
          '  CHECK (price_per_liter_milli_eur >= 0),' +
          '  CHECK (is_full_tank IN (0,1)),' +
          '  CHECK (missed_previous IN (0,1))' +
          ');';
        Q.ExecSQL;
      end
      else if (not HasCarId) or (not HasMissedPrevious) then
      begin
        Dbg('Migrating fuelups schema: v3 -> v4');

        Q.SQL.Text := 'DROP TRIGGER IF EXISTS trg_fuelups_set_updated_at;';
        Q.ExecSQL;

        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_station_id;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_fueled_at;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_odometer_km;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_car_fueled_at;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_car_odometer_km;';
        Q.ExecSQL;
        Q.SQL.Text := 'DROP INDEX IF EXISTS idx_fuelups_unique;';
        Q.ExecSQL;

        Q.SQL.Text := 'DROP TABLE IF EXISTS fuelups_new;';
        Q.ExecSQL;

        Q.SQL.Text :=
          'CREATE TABLE fuelups_new (' +
          '  id         INTEGER PRIMARY KEY,' +
          '  station_id                  INTEGER NOT NULL,' +
          '  car_id                      INTEGER NOT NULL,' +
          '  fueled_at                   TEXT    NOT NULL,' +
          '  odometer_km                 INTEGER NOT NULL,' +
          '  liters_ml                   INTEGER NOT NULL,' +
          '  total_cents                 INTEGER NOT NULL,' +
          '  price_per_liter_milli_eur   INTEGER NOT NULL,' +
          '  is_full_tank                INTEGER NOT NULL DEFAULT 0,' +
          '  missed_previous             INTEGER NOT NULL DEFAULT 0,' +
          '  fuel_type                   TEXT,' +
          '  payment_type                TEXT,' +
          '  pump_no                     TEXT,' +
          '  note                        TEXT,' +
          '  created_at                  TEXT NOT NULL DEFAULT (datetime(''now'')),' +
          '  updated_at                  TEXT,' +
          '  FOREIGN KEY(station_id) REFERENCES stations(id) ON DELETE RESTRICT,' +
          '  FOREIGN KEY(car_id)     REFERENCES cars(id)     ON DELETE RESTRICT,' +
          '  CHECK (odometer_km > 0),' +
          '  CHECK (liters_ml > 0),' +
          '  CHECK (total_cents >= 0),' +
          '  CHECK (price_per_liter_milli_eur >= 0),' +
          '  CHECK (is_full_tank IN (0,1)),' +
          '  CHECK (missed_previous IN (0,1))' +
          ');';
        Q.ExecSQL;

        if HasCarId then
          CarIdExpr := 'car_id'
        else
          CarIdExpr := ':car_id';

        if HasMissedPrevious then
          MissedPreviousExpr := 'missed_previous'
        else
          MissedPreviousExpr := '0';

        Q.SQL.Text :=
          'INSERT INTO fuelups_new (' +
          '  id, station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents,' +
          '  price_per_liter_milli_eur, is_full_tank, missed_previous, fuel_type, payment_type,' +
          '  pump_no, note, created_at, updated_at' +
          ') ' +
          'SELECT ' +
          '  id, station_id, ' + CarIdExpr + ', fueled_at, odometer_km, liters_ml, total_cents,' +
          '  price_per_liter_milli_eur, is_full_tank, ' + MissedPreviousExpr + ', fuel_type, payment_type,' +
          '  pump_no, note, created_at, updated_at ' +
          'FROM fuelups;';
        if not HasCarId then
          Q.Params.ParamByName('car_id').AsInteger := DefaultCarId;
        Q.ExecSQL;

        Q.SQL.Text := 'DROP TABLE fuelups;';
        Q.ExecSQL;

        Q.SQL.Text := 'ALTER TABLE fuelups_new RENAME TO fuelups;';
        Q.ExecSQL;
      end;

      // Indizes fuer typische Abfragen
      Dbg('Ensuring fuelups indexes...');
      
      Q.SQL.Text := 
        'CREATE INDEX IF NOT EXISTS idx_fuelups_station_id ON fuelups(station_id);';
      Q.ExecSQL;

      Q.SQL.Text :=
        'CREATE INDEX IF NOT EXISTS idx_fuelups_car_fueled_at ON fuelups(car_id, fueled_at);';
      Q.ExecSQL;

      Q.SQL.Text := 
        'CREATE INDEX IF NOT EXISTS idx_fuelups_car_odometer_km ON fuelups(car_id, odometer_km);';
      Q.ExecSQL;

      // Duplikat-Schutz (pro Auto + Station + Zeit + Kilometerstand)
      Q.SQL.Text := 
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_fuelups_unique ' +
        'ON fuelups(car_id, station_id, fueled_at, odometer_km);';
      Q.ExecSQL;

      // Trigger fuer automatisches updated_at
      Dbg('Ensuring fuelups triggers...');
      Q.SQL.Text := 
        'CREATE TRIGGER IF NOT EXISTS trg_fuelups_set_updated_at ' +
        'AFTER UPDATE ON fuelups ' +
        'FOR EACH ROW ' +
        'WHEN NEW.updated_at IS OLD.updated_at OR NEW.updated_at IS NULL ' +
        'BEGIN ' +
        '  UPDATE fuelups ' +
        '  SET updated_at = datetime(''now'') ' + 
        '  WHERE id = NEW.id; ' +
        'END; ';
      Q.ExecSQL;

      // Schema-Version final absichern (nach evtl. Migration)
      Q.SQL.Text := 'INSERT OR REPLACE INTO meta(key, value) VALUES(:k, :v);';
      Q.Params.ParamByName('k').AsString := 'schema_version';
      Q.Params.ParamByName('v').AsString := '4';
      Q.ExecSQL;

      // Transaktion abschliessen
      Dbg('Commit...');
      Tran.Commit;
      Dbg('Commit: OK');

      Result := CreatedNow;

    except
      on E: Exception do
      begin
        Dbg('Error: ' + E.Message);
        if Assigned(Tran) and Tran.Active then
        begin
          Dbg('Rollback...');
          Tran.Rollback;
        end;
        raise Exception.Create('DB-Init fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

// ----------------
// Liest einen Wert aus der meta-Tabelle (technische Key-Value Metadaten).
function ReadMetaValue(const DbPath, AKey: string): string;
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
begin
  Result := '';

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);

  try
    try
      Conn.DatabaseName := DbPath;
      Conn.Transaction := Tran;
      Q.DataBase := Conn;
      Q.Transaction := Tran;

      Conn.Open;
      // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
      if not Tran.Active then
        Tran.StartTransaction;

      Q.SQL.Text := 'SELECT value FROM meta WHERE key = :k;';
      Q.Params.ParamByName('k').AsString := AKey;
      Q.Open;

      if not Q.EOF then
        Result := Q.Fields[0].AsString;

      Q.Close;
      Tran.Commit;

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;
        raise Exception.Create('ReadMetaValue fehlgeschlagen (' +
          AKey + '): ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

end.

````

## Datei: `units/u_db_seed.pas`

````pascal
{
  u_db_seed.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Demo-Datenbank-Seeding fuer Betankungen.

  Verantwortlichkeiten:
  - Erzeugt reproduzierbare Demo-Daten fuer stations/cars/fuelups.
  - Erstellt Schema bei Bedarf (CREATE TABLE IF NOT EXISTS).
  - Optionales Zuruecksetzen per Force-Option (idempotent).

  Design-Entscheidungen:
  - Daten werden pseudozufaellig erzeugt, aber via SeedValue reproduzierbar.
  - Keine Fachlogik aus den Haupt-Units; reines Test/Seed-Modul.

  Hinweis:
  - Standard-Demo-DB: ~/.local/share/Betankungen/betankungen_demo.db
  ---------------------------------------------------------------------------
}
unit u_db_seed;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

procedure SeedDemoDatabase(
  const DemoDbPath: string;
  StationCount, FuelupCount: integer;
  SeedValue: integer;
  Force: boolean
);

// Liefert den Standardpfad der Demo-Datenbank (XDG-konform).
function GetDefaultDemoDbPath: string;

implementation

uses
  SQLite3Conn, SQLDB, DateUtils, u_log;

const
  // Zielkorridor fuer realistische Demo-Datensatzgroesse.
  DEMO_FUELUPS_MIN = 300;
  DEMO_FUELUPS_MAX = 500;
  // Zielkorridor fuer historische Zeitspanne der Demo-Daten.
  DEMO_YEAR_SPAN_MIN = 3;
  DEMO_YEAR_SPAN_MAX = 5;

function GetDefaultDemoDbPath: string;
var
  BaseDir: string;
begin
  BaseDir := GetUserDir + '.local/share/Betankungen/';
  Result := BaseDir + 'betankungen_demo.db';
end;

// Stellt sicher, dass das Verzeichnis zum Dateipfad existiert.
procedure EnsureDirForFile(const FilePath: string);
var
  DirPath: string;
begin
  DirPath := ExtractFileDir(FilePath);
  if (DirPath <> '') and (not DirectoryExists(DirPath)) then
    if not ForceDirectories(DirPath) then
      raise Exception.Create('Konnte Verzeichnis nicht erstellen: ' + DirPath);
end;

// Fuehrt ein beliebiges SQL-Statement ohne Resultset aus.
procedure ExecSQL(Conn: TSQLite3Connection; Tran: TSQLTransaction; const S: string);
var
  Q: TSQLQuery;
begin
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text := S;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

// Prueft, ob die Tabelle mindestens eine Zeile enthaelt.
function TableHasRows(Conn: TSQLite3Connection; Tran: TSQLTransaction; const TableName: string): boolean;
var
  Q: TSQLQuery;
begin
  Result := False;
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text := 'SELECT 1 FROM ' + TableName + ' LIMIT 1;';
    Q.Open;
    Result := not Q.EOF;
  finally
    Q.Free;
  end;
end;

// Prueft, ob eine Spalte in einer Tabelle vorhanden ist.
function ColumnExists(Conn: TSQLite3Connection; Tran: TSQLTransaction; const TableName, ColumnName: string): boolean;
var
  Q: TSQLQuery;
begin
  Result := False;
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text := 'PRAGMA table_info(' + TableName + ');';
    Q.Open;
    while not Q.EOF do
    begin
      if SameText(Q.FieldByName('name').AsString, ColumnName) then
      begin
        Result := True;
        Break;
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

// Erstellt das benoetigte Schema, falls Tabellen fehlen.
procedure CreateSchemaIfMissing(Conn: TSQLite3Connection; Tran: TSQLTransaction);
begin
  // stations
  ExecSQL(Conn, Tran,
    'CREATE TABLE IF NOT EXISTS stations (' +
    '  id         INTEGER PRIMARY KEY,' +
    '  brand      TEXT NOT NULL,' +
    '  street     TEXT NOT NULL,' +
    '  house_no   TEXT NOT NULL,' +
    '  zip        TEXT NOT NULL,' +
    '  city       TEXT NOT NULL,' +
    '  phone      TEXT,' +
    '  owner      TEXT,' +
    '  created_at TEXT NOT NULL DEFAULT (datetime(''now'')),' +
    '  updated_at TEXT' +
    ');'
  );

  // cars (v4)
  ExecSQL(Conn, Tran,
    'CREATE TABLE IF NOT EXISTS cars (' +
    '  id                  INTEGER PRIMARY KEY,' +
    '  name                TEXT    NOT NULL,' +
    '  plate               TEXT,' +
    '  note                TEXT,' +
    '  odometer_start_km   INTEGER NOT NULL CHECK (odometer_start_km > 0),' +
    '  odometer_start_date TEXT    NOT NULL,' +
    '  created_at          TEXT    NOT NULL DEFAULT (datetime(''now'')),' +
    '  updated_at          TEXT,' +
    '  UNIQUE(name)' +
    ');'
  );

  // Kompatibel fuer bestehende cars-Tabellen (v4-light -> v4-full)
  if not ColumnExists(Conn, Tran, 'cars', 'plate') then
    ExecSQL(Conn, Tran, 'ALTER TABLE cars ADD COLUMN plate TEXT;');
  if not ColumnExists(Conn, Tran, 'cars', 'note') then
    ExecSQL(Conn, Tran, 'ALTER TABLE cars ADD COLUMN note TEXT;');
  if not ColumnExists(Conn, Tran, 'cars', 'odometer_start_km') then
    ExecSQL(Conn, Tran, 'ALTER TABLE cars ADD COLUMN odometer_start_km INTEGER NOT NULL DEFAULT 1;');
  if not ColumnExists(Conn, Tran, 'cars', 'odometer_start_date') then
    ExecSQL(Conn, Tran, 'ALTER TABLE cars ADD COLUMN odometer_start_date TEXT NOT NULL DEFAULT ''1970-01-01'';');

  ExecSQL(Conn, Tran,
    'UPDATE cars SET odometer_start_km = 1 WHERE odometer_start_km IS NULL OR odometer_start_km <= 0;'
  );
  ExecSQL(Conn, Tran,
    'UPDATE cars SET odometer_start_date = date(''now'') WHERE odometer_start_date IS NULL OR odometer_start_date = '''' OR odometer_start_date = ''1970-01-01'';'
  );

  ExecSQL(Conn, Tran,
    'INSERT OR IGNORE INTO cars(id, name, odometer_start_km, odometer_start_date) ' +
    'VALUES(1, ''Hauptauto'', 1, date(''now''));'
  );

  // fuelups
  ExecSQL(Conn, Tran,
    'CREATE TABLE IF NOT EXISTS fuelups (' +
    '  id         INTEGER PRIMARY KEY,' +
    '  station_id                INTEGER NOT NULL,' +
    '  car_id                    INTEGER NOT NULL,' +
    '  fueled_at                 TEXT    NOT NULL,' +
    '  odometer_km               INTEGER NOT NULL,' +
    '  liters_ml                 INTEGER NOT NULL,' +
    '  total_cents               INTEGER NOT NULL,' +
    '  price_per_liter_milli_eur INTEGER NOT NULL,' +
    '  is_full_tank              INTEGER NOT NULL DEFAULT 0,' +
    '  missed_previous           INTEGER NOT NULL DEFAULT 0,' +
    '  fuel_type                 TEXT,' +
    '  payment_type              TEXT,' +
    '  pump_no                   TEXT,' +
    '  note                      TEXT,' +
    '  created_at                TEXT NOT NULL DEFAULT (datetime(''now'')),' +
    '  updated_at                TEXT,' +
    '  FOREIGN KEY(station_id) REFERENCES stations(id) ON DELETE RESTRICT,' +
    '  FOREIGN KEY(car_id)     REFERENCES cars(id)     ON DELETE RESTRICT,' +
    '  CHECK (odometer_km > 0),' +
    '  CHECK (liters_ml > 0),' +
    '  CHECK (total_cents >= 0),' +
    '  CHECK (price_per_liter_milli_eur >= 0),' +
    '  CHECK (is_full_tank IN (0,1)),' +
    '  CHECK (missed_previous IN (0,1))' +
    ');'
  );

  // Kompatibel fuer bestehende Demo-DBs (v3 -> v4 lite per ALTER)
  if not ColumnExists(Conn, Tran, 'fuelups', 'car_id') then
    ExecSQL(Conn, Tran, 'ALTER TABLE fuelups ADD COLUMN car_id INTEGER NOT NULL DEFAULT 1;');
  if not ColumnExists(Conn, Tran, 'fuelups', 'missed_previous') then
    ExecSQL(Conn, Tran, 'ALTER TABLE fuelups ADD COLUMN missed_previous INTEGER NOT NULL DEFAULT 0;');

  ExecSQL(Conn, Tran, 'DROP INDEX IF EXISTS idx_fuelups_fueled_at;');
  ExecSQL(Conn, Tran, 'DROP INDEX IF EXISTS idx_fuelups_odometer_km;');
  ExecSQL(Conn, Tran, 'DROP INDEX IF EXISTS idx_fuelups_unique;');
  ExecSQL(Conn, Tran, 'CREATE INDEX IF NOT EXISTS idx_fuelups_station_id ON fuelups(station_id);');
  ExecSQL(Conn, Tran, 'CREATE INDEX IF NOT EXISTS idx_fuelups_car_fueled_at ON fuelups(car_id, fueled_at);');
  ExecSQL(Conn, Tran, 'CREATE INDEX IF NOT EXISTS idx_fuelups_car_odometer_km ON fuelups(car_id, odometer_km);');
  ExecSQL(Conn, Tran, 'CREATE UNIQUE INDEX IF NOT EXISTS idx_fuelups_unique ON fuelups(car_id, station_id, fueled_at, odometer_km);');
end;

// Formatiert TDateTime im von SQLite akzeptierten ISO-Format.
function ISODateTime(const DT: TDateTime): string;
begin
  // SQLite akzeptiert "YYYY-MM-DD HH:NN:SS"
  Result := FormatDateTime('yyyy"-"mm"-"dd" "hh":"nn":"ss', DT);
end;

// Fuegt eine Anzahl Stations-Datensaetze mit plausiblen Demo-Werten ein.
procedure SeedStations(Conn: TSQLite3Connection; Tran: TSQLTransaction; StationCount: integer);
const
  BRANDS: array[0..9] of string = ('Aral','Shell','TotalEnergies','Esso','Jet','AVIA','HEM','ORLEN','Star','Q1');
  STREETS: array[0..9] of string = ('Hauptstr.','Bahnhofstr.','Dortmunder Str.','Muensterstr.','Bismarckstr.','Ringstr.','Kaiserstr.','Nordstr.','Suedstr.','Hagenstr.');
  CITIES: array[0..9] of string = ('Unna','Dortmund','Hamm','Kamen','Schwerte','Luenen','Bochum','Essen','Wuppertal','Muenster');
  ZIPS: array[0..9] of string = ('59423','44135','59065','59174','58239','44532','44787','45127','42103','48143');
var
  Q: TSQLQuery;
  i, bi: integer;
  brand, street, houseNo, zip, city, phone, owner: string;
begin
  Dbg('SeedStations: count=' + IntToStr(StationCount));
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text :=
      'INSERT INTO stations (brand, street, house_no, zip, city, phone, owner) ' +
      'VALUES (:brand, :street, :house_no, :zip, :city, :phone, :owner);';

    for i := 1 to StationCount do
    begin
      bi := Random(Length(BRANDS));
      brand := BRANDS[bi];
      street := STREETS[Random(Length(STREETS))];
      houseNo := IntToStr(1 + Random(180));
      city := CITIES[Random(Length(CITIES))];
      zip := ZIPS[Random(Length(ZIPS))];

      if Random(100) < 60 then phone := '+49 23' + IntToStr(10 + Random(90)) + ' ' + IntToStr(100000 + Random(900000))
      else phone := '';

      if Random(100) < 40 then owner := 'Inhaber ' + IntToStr(i)
      else owner := '';

      Q.ParamByName('brand').AsString := brand;
      Q.ParamByName('street').AsString := street;
      Q.ParamByName('house_no').AsString := houseNo;
      Q.ParamByName('zip').AsString := zip;
      Q.ParamByName('city').AsString := city;

      if phone = '' then Q.ParamByName('phone').Clear else Q.ParamByName('phone').AsString := phone;
      if owner = '' then Q.ParamByName('owner').Clear else Q.ParamByName('owner').AsString := owner;

      Q.ExecSQL;
    end;
  finally
    Q.Free;
  end;
end;

// Fuegt Fuelups ein, verteilt ueber mehrere Jahre mit plausiblen Werten.
procedure SeedFuelups(
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  StationCount, FuelupCount, YearSpanYears: integer
);
const
  FUEL_TYPES: array[0..3] of string = ('E5','E10','Diesel','Super+');
  PAY_TYPES: array[0..2] of string = ('EC','Kreditkarte','Bar');
var
  Q: TSQLQuery;
  i: integer;
  stationId: integer;
  carId: integer;
  odometer: integer;
  litersMl: int64;
  pplMilli: int64;
  totalCents: int64;
  fullTank: integer;
  missedPrevious: integer;
  fueledAt: TDateTime;
  dtStart: TDateTime;
  spanDays: integer;
  fuelType, payType, pumpNo, note: string;
  kmStep: integer;
begin
  Dbg(
    'SeedFuelups: stations=' + IntToStr(StationCount) +
    ' fuelups=' + IntToStr(FuelupCount) +
    ' years=' + IntToStr(YearSpanYears)
  );
  Q := TSQLQuery.Create(nil);
  try
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    Q.SQL.Text :=
      'INSERT INTO fuelups (' +
      ' station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents, price_per_liter_milli_eur,' +
      ' is_full_tank, missed_previous, fuel_type, payment_type, pump_no, note' +
      ') VALUES (' +
      ' :station_id, :car_id, :fueled_at, :odometer_km, :liters_ml, :total_cents, :ppl_milli,' +
      ' :is_full, :missed_previous, :fuel_type, :payment_type, :pump_no, :note' +
      ');';

    // “Realistisch”: 3-5 Jahre zurück
    dtStart := IncYear(Now, -YearSpanYears);
    spanDays := DaysBetween(DateOf(Now), DateOf(dtStart));
    if spanDays <= 0 then spanDays := 1;
    odometer := 50000 + Random(2000); // Start

    for i := 1 to FuelupCount do
    begin
      // Zeitraum: zufaellig ueber die letzten Jahre verteilt, aber chronologisch steigend
      fueledAt := dtStart + ((i - 1) * (spanDays / FuelupCount)) + (Random * 0.8); // etwas jitter

      // Kilometer: pro Tankung +280..620km
      kmStep := 280 + Random(341);
      odometer := odometer + kmStep;

      stationId := 1 + Random(StationCount);
      carId := 1; // aktueller CLI-Workflow: ein Default-Fahrzeug

      // liters: 30..70L in ml
      litersMl := int64(30000 + Random(40001)); // 30000..70000 ml

      // price per liter in milli-eur: 1.55..2.05 EUR -> 1550..2050 milli-eur
      pplMilli := int64(1550 + Random(501));

      // total cents = liters(L) * eur/L * 100
      // litersMl/1000 = Liter; pplMilli/1000 = EUR/L
      // total EUR = litersMl * pplMilli / 1_000_000
      // total cents = total EUR * 100 = litersMl * pplMilli / 10_000
      totalCents := (litersMl * pplMilli) div 10000;

      // Volltank: 70% true (damit Zyklen entstehen)
      if Random(100) < 70 then fullTank := 1 else fullTank := 0;

      // Golden Information: selten gesetzt
      if Random(100) < 10 then missedPrevious := 1 else missedPrevious := 0;

      fuelType := FUEL_TYPES[Random(Length(FUEL_TYPES))];
      payType := PAY_TYPES[Random(Length(PAY_TYPES))];

      if Random(100) < 60 then pumpNo := IntToStr(1 + Random(12)) else pumpNo := '';
      if Random(100) < 25 then note := 'Demo ' + IntToStr(i) else note := '';

      Q.ParamByName('station_id').AsInteger := stationId;
      Q.ParamByName('car_id').AsInteger := carId;
      Q.ParamByName('fueled_at').AsString := ISODateTime(fueledAt);
      Q.ParamByName('odometer_km').AsInteger := odometer;
      Q.ParamByName('liters_ml').AsLargeInt := litersMl;
      Q.ParamByName('total_cents').AsLargeInt := totalCents;
      Q.ParamByName('ppl_milli').AsLargeInt := pplMilli;
      Q.ParamByName('is_full').AsInteger := fullTank;
      Q.ParamByName('missed_previous').AsInteger := missedPrevious;

      if fuelType = '' then Q.ParamByName('fuel_type').Clear else Q.ParamByName('fuel_type').AsString := fuelType;
      if payType = '' then Q.ParamByName('payment_type').Clear else Q.ParamByName('payment_type').AsString := payType;
      if pumpNo = '' then Q.ParamByName('pump_no').Clear else Q.ParamByName('pump_no').AsString := pumpNo;
      if note = '' then Q.ParamByName('note').Clear else Q.ParamByName('note').AsString := note;

      Q.ExecSQL;
    end;
  finally
    Q.Free;
  end;
end;

// Orchestriert das Befuellen der Demo-DB inkl. Schema und optionalem Zuruecksetzen.
procedure SeedDemoDatabase(
  const DemoDbPath: string;
  StationCount, FuelupCount: integer;
  SeedValue: integer;
  Force: boolean
);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  HasData: boolean;
  EffectiveFuelupCount: integer;
  EffectiveYearSpanYears: integer;
begin
  Dbg('SeedDemo: path=' + DemoDbPath);
  Dbg(
    'SeedDemo: stations=' + IntToStr(StationCount) +
    ' fuelups=' + IntToStr(FuelupCount) +
    ' seed_value=' + IntToStr(SeedValue) +
    ' force=' + BoolToStr(Force, True)
  );
  if StationCount <= 0 then raise Exception.Create('StationCount muss > 0 sein.');
  if FuelupCount <= 0 then raise Exception.Create('FuelupCount muss > 0 sein.');

  EnsureDirForFile(DemoDbPath);

  if SeedValue <> 0 then
    RandSeed := SeedValue
  else
    Randomize;

  if (FuelupCount < DEMO_FUELUPS_MIN) or (FuelupCount > DEMO_FUELUPS_MAX) then
    EffectiveFuelupCount := DEMO_FUELUPS_MIN + Random(DEMO_FUELUPS_MAX - DEMO_FUELUPS_MIN + 1)
  else
    EffectiveFuelupCount := FuelupCount;

  EffectiveYearSpanYears := DEMO_YEAR_SPAN_MIN + Random(DEMO_YEAR_SPAN_MAX - DEMO_YEAR_SPAN_MIN + 1);

  Dbg(
    'SeedDemo: effective_fuelups=' + IntToStr(EffectiveFuelupCount) +
    ' year_span_years=' + IntToStr(EffectiveYearSpanYears)
  );

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  try
    Conn.DatabaseName := DemoDbPath;
    Conn.Transaction := Tran;
    Conn.Open;
    Tran.StartTransaction;

    CreateSchemaIfMissing(Conn, Tran);

    HasData := TableHasRows(Conn, Tran, 'stations') or TableHasRows(Conn, Tran, 'fuelups');
    Dbg('SeedDemo: vorhandene Daten=' + BoolToStr(HasData, True));

    if HasData and (not Force) then
      raise Exception.Create('Demo-DB enthält bereits Daten. Nutze --force zum Überschreiben.');

    if Force then
    begin
      ExecSQL(Conn, Tran, 'DELETE FROM fuelups;');
      ExecSQL(Conn, Tran, 'DELETE FROM stations;');
      ExecSQL(Conn, Tran, 'DELETE FROM cars WHERE id <> 1;');
      // SQLite Autoincrement reset (nur vorhanden, wenn AUTOINCREMENT genutzt wird)
      try
        ExecSQL(Conn, Tran, 'DELETE FROM sqlite_sequence WHERE name IN (''fuelups'',''stations'',''cars'');');
      except
        // sqlite_sequence existiert nicht in jeder DB-Konfiguration -> ignorieren
      end;
    end;

    SeedStations(Conn, Tran, StationCount);
    SeedFuelups(Conn, Tran, StationCount, EffectiveFuelupCount, EffectiveYearSpanYears);

    Tran.Commit;
  except
    on E: Exception do
    begin
      if Tran.Active then Tran.Rollback;
      raise;
    end;
  end;

  Conn.Free;
  Tran.Free;
end;

end.

````

## Datei: `units/u_fmt.pas`

````pascal
{
  u_fmt.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Zentrales Modul fuer CLI-Formatierung, Tabellenlayout und Dashboard-Rendering.

  Verantwortlichkeiten:
  - Fixed-Point-Formatter (Cents/ml/milli-EUR) fuer fachliche Ausgaben.
  - Tabellenrenderer fuer Fuelup-Listen inklusive Detailzeilen.
  - Unicode-Box-Engine fuer Dashboards und kompakte Statusbloecke.
  - Strikte CSV-Helfer fuer maschinenlesbare Zeilen.

  Design-Entscheidungen:
  - Int64-first: keine Float-Abhaengigkeit in den Kernformattern.
  - UTF-8-bewusste Layouthelfer fuer stabile Zeichenbreiten.
  - Trennung von Darstellung und Fachlogik.

  Hinweis:
  - Dezimaltrennzeichen ist bewusst fix ',' (locale-unabhaengig).
  ---------------------------------------------------------------------------
}

unit u_fmt;

{$mode objfpc}{$H+}

interface

uses SysUtils, u_table, StrUtils;

// ----------------
// Oeffentliche Formatter fuer fachliche Basiswerte.

// Wandelt Cents in EUR-Text (z. B. 1234 -> "12,34 EUR").
function FmtEuroFromCents(const V: Int64): string;
// Wandelt Milliliter in Liter-Text (z. B. 12345 -> "12,345 L").
function FmtLiterFromMl(const V: Int64): string;
// Wandelt milli-EUR in EUR/L-Text.
function FmtEurPerLiterFromMilli(const V: Int64): string;
// Wandelt 0/1 in "N"/"Y".
function FmtBoolYN(const V: Integer): string;
// Universeller Scaled-Integer-Formatter.
function FmtScaledInt(const V: Int64; const Decimals: Integer; const Suffix: string): string;


// ----------------
// CSV Helper (maschinenlesbar, strikt & simpel)

// Validiert Token fuer CSV (keine Kommas/Quotes/CRLF), gibt Token unveraendert zurueck
function CsvTokenStrict(const S: string): string;

// Baut eine CSV-Zeile aus Strings (Strings muessen bereits safe sein, z.B. via CsvTokenStrict)
function CsvJoin(const Values: array of string): string;

// Baut eine CSV-Zeile aus Int64 (reines IntToStr + Komma-Separierung)
function CsvJoinInt64(const Values: array of Int64): string;

// ----------------
// Prozeduren fuer die Tabellen-Ausgabe (CLI)

// Zeichnet den oberen Rahmen und die Spaltenueberschriften
procedure PrintFuelupHeader;

// Zeichnet den unteren Rahmen (Simple=True fuer durchgehende Linie ohne Spaltentrenner)
procedure PrintFuelupFooter(Simple: Boolean = False);

// Zeichnet eine einfache Trennlinie innerhalb der Tabelle
procedure PrintFuelupSeparator;

// Zeichnet eine dicke (doppelte) Trennlinie (fuer Standardansicht)
procedure PrintFuelupSeparatorDouble;

// Gibt eine einzelne Datensatz-Zeile formatiert aus
procedure PrintFuelupRow(
  const AId: Integer; 
  const AFueledAt: string; 
  const AOdometerKm: Int64; 
  const ALitersMl: Int64; 
  const APriceMilli: Int64; 
  const ATotalCents: Int64; 
  const AStation: string
);

// Gibt Detail-Informationen (Notizen, Adresse) unter einer Zeile aus
procedure PrintFuelupDetail(
  const AIsFull, AMissedPrevious: Boolean;
  const ACarName, AFuelType, APayment, APump, ANote, AAddress: string
);

// ----------------
// Unicode Box-Engine (Basis fuer Dashboards/kompakte Statusausgaben)

// Schreibt eine Unicode-Box-Kante (Top/Separator/Bottom) ueber die volle Breite.
procedure BoxTop(const Width: Integer);
procedure BoxSep(const Width: Integer);
procedure BoxBottom(const Width: Integer);

// Schreibt eine einzelne Box-Zeile. Text wird bei Bedarf abgeschnitten.
procedure BoxLine(const Width: Integer; const Text: string);

// ANSI-sichere Zeilenfunktion.
procedure BoxLineAnsi(const Width: Integer; const Text: string);

// Key/Value-Zeile ("Label: Value"). Label wird links ausgerichtet.
procedure BoxKV(const Width: Integer; const LabelText, ValueText: string);

// ----------------
// Dashboard-Bar (Kosten, optional farbig)

type
  TDashColorMode = (
    dcmStatic,   // absolute Schwellen in Cent
    dcmRelative  // relative Schwellen in Promille (bezogen auf MaxCents)
  );

// Schwellen und Darstellung (in Cent / Zeichen).
// Global gehalten fuer einfache Justierbarkeit ohne Rebuild der Aufruferlogik.
var
  // Farblogik
  DashColorMode: TDashColorMode = dcmRelative;

  // Statisch (Cent): nur genutzt, wenn DashColorMode = dcmStatic
  DashGreenMaxCents: Int64 = 50 * 100;
  DashYellowMaxCents: Int64 = 100 * 100;

  // Relativ (Promille): nur genutzt, wenn DashColorMode = dcmRelative
  // Default: 33% / 66%
  DashRelGreenMaxPermille: Integer = 333;
  DashRelYellowMaxPermille: Integer = 666;

  DashBarWidth: Integer = 12;
  DashUseColor: Boolean = True;
  DashUseUnicode: Boolean = True;

function ResolveDashColor(const Cents, MaxCents: Int64): string;
function RenderCostBar(const Cents, MaxCents: Int64): string;

// ----------------
// Farbkodierung

const
  // ANSI Escape Codes fuer Farben
  C_RESET  = #27 + '[0m';
  C_RED    = #27 + '[31m';
  C_GREEN  = #27 + '[32m';
  C_YELLOW = #27 + '[33m';
  C_CYAN   = #27 + '[36m';

const
  // Definition der Spaltenbreiten (Zeichenanzahl ohne Padding)
  COL_ID      = 3;
  COL_DATE    = 19;
  COL_KM      = 8;
  COL_LITER   = 10;
  COL_EUR_L   = 12;
  COL_TOTAL   = 10;
  COL_STATION = 26;

  // Anzahl der Daten-Spalten
  FUELUP_COLS = 7;

  // Berechnung der Gesamtbreite anhand Aussenraendern, Spaltenbreiten, Leerzeichen und Trennern
  FUELUP_TABLE_WIDTH = 2 + (COL_ID + 2) + (COL_DATE + 2) + (COL_KM + 2) + 
                       (COL_LITER + 2) + (COL_EUR_L + 2) + (COL_TOTAL + 2) + 
                       (COL_STATION + 2) + (FUELUP_COLS - 1);

  // Nutzbare Breite fuer Text-Details innerhalb der Box
  FUELUP_DETAIL_WIDTH = FUELUP_TABLE_WIDTH - 4;

implementation

const
  // Unicode Box-Zeichen (Mischung aus doppelten und einfachen Linien)
  U_HORIZ = '═'; U_VERT  = '║'; 
  U_TOP_L = '╔'; U_TOP_R = '╗'; U_T_DWN = '╦';
  U_BOT_L = '╚'; U_BOT_R = '╝'; U_B_UP  = '╩'; 
  U_CROSS = '╬'; U_L_T   = '╠'; U_R_T   = '╣';
  U_SEP_L = '╟'; U_SEP_R = '╢'; U_DASH  = '─';

// ----------------
// Farbentscheidung + Balken-Renderer (ohne Float)

function ResolveDashColor(const Cents, MaxCents: Int64): string;
var
  P: Integer;
  Num: Int64;
begin
  if not DashUseColor then
    Exit('');

  // Relative Mode: Farbe anhand Anteil von MaxCents
  if DashColorMode = dcmRelative then
  begin
    if MaxCents <= 0 then
      Exit(C_GREEN); // fallback: wenn kein Max, dann "harmlos"

    // P = round(Cents / MaxCents * 1000) in Promille, ohne Float
    Num := Cents * 1000;
    P := Integer((Num + (MaxCents div 2)) div MaxCents);

    if P <= DashRelGreenMaxPermille then
      Exit(C_GREEN)
    else if P <= DashRelYellowMaxPermille then
      Exit(C_YELLOW)
    else
      Exit(C_RED);
  end;

  // Static Mode: absolute Schwellen
  if Cents <= DashGreenMaxCents then
    Exit(C_GREEN)
  else if Cents <= DashYellowMaxCents then
    Exit(C_YELLOW)
  else
    Exit(C_RED);
end;

function RenderCostBar(const Cents, MaxCents: Int64): string;
var
  BarLen: Integer;
  Color, Ch: string;
  Num: Int64;
begin
  if (DashBarWidth <= 0) or (Cents <= 0) or (MaxCents <= 0) then
    Exit('');

  // Rundung ohne Float:
  // BarLen = round((Cents / MaxCents) * DashBarWidth)
  Num := Cents * Int64(DashBarWidth);
  BarLen := Integer((Num + (MaxCents div 2)) div MaxCents);

  if BarLen < 1 then BarLen := 1;
  if BarLen > DashBarWidth then BarLen := DashBarWidth;

  if DashUseUnicode then
    Ch := '█'
  else
    Ch := '#';

  Color := ResolveDashColor(Cents, MaxCents);
  if Color <> '' then
    Result := Color + DupeString(Ch, BarLen) + C_RESET
  else
    Result := DupeString(Ch, BarLen);
end;

// ----------------
// Unicode Box-Engine (generisch, wiederverwendbar)

function BoxInnerWidth(const Width: Integer): Integer;
begin
  // Layout: LeftBorder + Space + <content> + Space + RightBorder
  // => contentBreite = Width - 4
  Result := Width - 4;
  if Result < 0 then
    Result := 0;
end;

procedure BoxTop(const Width: Integer);
begin
  if Width <= 2 then
    WriteLn(U_TOP_L + U_TOP_R)
  else
    WriteLn(U_TOP_L + DupeString(U_HORIZ, Width - 2) + U_TOP_R);
end;

procedure BoxSep(const Width: Integer);
begin
  if Width <= 2 then
    WriteLn(U_L_T + U_R_T)
  else
    WriteLn(U_L_T + DupeString(U_HORIZ, Width - 2) + U_R_T);
end;

procedure BoxBottom(const Width: Integer);
begin
  if Width <= 2 then
    WriteLn(U_BOT_L + U_BOT_R)
  else
    WriteLn(U_BOT_L + DupeString(U_HORIZ, Width - 2) + U_BOT_R);
end;

procedure BoxLine(const Width: Integer; const Text: string);
var
  Inner: Integer;
  S: string;
begin
  Inner := BoxInnerWidth(Width);
  S := Cut(Text, Inner);
  WriteLn(U_VERT + ' ' + PadR(S, Inner) + ' ' + U_VERT);
end;

procedure BoxKV(const Width: Integer; const LabelText, ValueText: string);
var
  Inner, LabelW: Integer;
  L, V, S: string;
begin
  Inner := BoxInnerWidth(Width);

  // einfache Heuristik: Label links, Value rechts; Label bekommt ca. 40% der Innenbreite
  LabelW := Inner * 4 div 10;
  if LabelW < 8 then LabelW := 8;
  if LabelW > Inner - 3 then LabelW := Inner - 3;

  L := Cut(LabelText, LabelW);
  V := Cut(ValueText, Inner - LabelW - 2);

  // Format: "<label>: <value>"
  S := PadR(L, LabelW) + ': ' + V;
  BoxLine(Width, S);
end;

function StripAnsi(const S: string): string;
var
  I, N: Integer;
  InEsc: Boolean;
begin
  Result := '';
  N := Length(S);
  I := 1;
  InEsc := False;

  while I <= N do
  begin
    if (not InEsc) and (S[I] = #27) and (I < N) and (S[I+1] = '[') then
    begin
      InEsc := True;
      Inc(I, 2); // skip ESC[
      Continue;
    end;

    if InEsc then
    begin
      // ANSI sequence ends at 'm'
      if S[I] = 'm' then
        InEsc := False;
      Inc(I);
      Continue;
    end;

    Result := Result + S[I];
    Inc(I);
  end;
end;

function Utf8CharLen(const B: Byte): Integer;
begin
  if (B and $80) = 0 then Exit(1);         // 0xxxxxxx
  if (B and $E0) = $C0 then Exit(2);       // 110xxxxx
  if (B and $F0) = $E0 then Exit(3);       // 1110xxxx
  if (B and $F8) = $F0 then Exit(4);       // 11110xxx
  Result := 1;                              // fallback
end;

// ----------------
// TO-DO:
// lokal dupliziert, weil u_table helper nicht exportiert; 
// ggf. später nach u_textwidth extrahieren
function Utf8VisibleLen(const S: string): Integer;
var
  I, N, Step: Integer;
begin
  Result := 0;
  I := 1;
  N := Length(S);
  while I <= N do
  begin
    Step := Utf8CharLen(Byte(S[I]));
    Inc(I, Step);
    Inc(Result);
  end;
end;

function AnsiVisibleLen(const S: string): Integer;
begin
  // Wichtig: UTF-8 sichtbar zaehlen (Length() zaehlt Bytes!),
  // sonst verrutscht Padding bei Zeichen wie '█', 'Ø', '–', '…'
  Result := Utf8VisibleLen(StripAnsi(S));
end;

procedure BoxLineAnsi(const Width: Integer; const Text: string);
var
  Inner, Vis, Pad: Integer;
  S: string;
begin
  Inner := BoxInnerWidth(Width);

  // Wenn die sichtbare Laenge zu lang ist, lieber ANSI entfernen,
  // statt Escape-Sequenzen kaputt zu cutten.
  Vis := AnsiVisibleLen(Text);
  if Vis > Inner then
  begin
    BoxLine(Width, StripAnsi(Text));
    Exit;
  end;

  S := Text;
  Pad := Inner - Vis;
  if Pad > 0 then
    S := S + DupeString(' ', Pad);

  WriteLn(U_VERT + ' ' + S + ' ' + U_VERT);
end;

// Integer-basiertes Fixed-Point-Format (ohne Double/Rundung)
function FmtScaledInt(const V: Int64; const Decimals: Integer; const Suffix: string): string;
var
  AbsV, Scale, IntPart, FracPart: Int64;
  FracStr: string;
  Sign: string;

  // Ganzzahl-Potenz fuer Zehnerpotenzen (ohne Float-Konvertierung)
  function Pow10Int64(const N: Integer): Int64;
  var
    I: Integer;
    R: Int64;
  begin
    R := 1;
    for I := 1 to N do
      R := R * 10;
    Result := R;
  end;

begin
  if Decimals < 0 then
    raise Exception.Create('Decimals darf nicht negativ sein');

  AbsV := Abs(V);
  Scale := Pow10Int64(Decimals);

  IntPart := AbsV div Scale;
  FracPart := AbsV mod Scale;

  FracStr := IntToStr(FracPart);
  while Length(FracStr) < Decimals do
    FracStr := '0' + FracStr;

  if V < 0 then
    Sign := '-'
  else
    Sign := '';

  if Decimals = 0 then
    Result := Sign + IntToStr(IntPart) + ' ' + Suffix
  else
    Result := Sign + IntToStr(IntPart) + ',' + FracStr + ' ' + Suffix;
end;

// Formatiert Cents als EUR mit zwei Nachkommastellen
function FmtEuroFromCents(const V: Int64): string;
begin Result := FmtScaledInt(V, 2, 'EUR'); end;

// Formatiert Milliliter als Liter mit drei Nachkommastellen
function FmtLiterFromMl(const V: Int64): string;
begin Result := FmtScaledInt(V, 3, 'L'); end;

// Formatiert milli-EUR pro Liter mit drei Nachkommastellen
function FmtEurPerLiterFromMilli(const V: Int64): string;
begin Result := FmtScaledInt(V, 3, 'EUR/L'); end;

function FmtBoolYN(const V: Integer): string;
begin
  if V <> 0 then Result := 'Y' else Result := 'N';
end;

// ----------------
// CSV Helper (maschinenlesbar, strikt & simpel)

function CsvTokenStrict(const S: string): string;
begin
  // Strikt: Wir erlauben keinerlei CSV-Sonderzeichen, weil wir bewusst ohne Escaping arbeiten.
  if S = '' then
    raise Exception.Create('CsvTokenStrict: Token darf nicht leer sein');

  if (Pos(',', S) > 0) or (Pos('"', S) > 0) or (Pos(#10, S) > 0) or (Pos(#13, S) > 0) then
    raise Exception.Create('CsvTokenStrict: Token enthaelt unzulaessige CSV-Zeichen');

  Result := S;
end;

function CsvJoin(const Values: array of string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(Values) do
  begin
    if I > 0 then
      Result := Result + ',';
    Result := Result + Values[I];
  end;
end;

function CsvJoinInt64(const Values: array of Int64): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(Values) do
  begin
    if I > 0 then
      Result := Result + ',';
    Result := Result + IntToStr(Values[I]);
  end;
end;

{
  Zentrale Zeichenfunktion fuer horizontale Linien.
  IsSimple = True  -> Erzeugt eine durchgehende Linie (z. B. fuer Separatoren)
  IsSimple = False -> Beruecksichtigt die Spaltenbreiten fuer Kreuzungspunkte
}
procedure DrawLine(const Left, Cross, Right, Char: string; IsSimple: Boolean = False);
var
  s: string;
  function Fill(Len: Integer): string;
  begin 
    // DupeString sorgt dafuer, dass UTF-8 Zeichen korrekt wiederholt werden
    Result := DupeString(Char, Len + 2); 
  end;
begin
  if IsSimple then
    // DupeString statt StringOfChar verwenden
    s := Left + DupeString(Char, FUELUP_TABLE_WIDTH - 2) + Right
  else
    s := Left + Fill(COL_ID) + Cross + Fill(COL_DATE) + Cross + Fill(COL_KM) + Cross + 
         Fill(COL_LITER) + Cross + Fill(COL_EUR_L) + Cross + Fill(COL_TOTAL) + Cross + 
         Fill(COL_STATION) + Right;
  WriteLn(s);
end;

procedure PrintFuelupHeader;
begin
  // Obere Kante
  DrawLine(U_TOP_L, U_T_DWN, U_TOP_R, U_HORIZ);
  // Spaltentitel (Format: %-*s sorgt fuer Linksbundigkeit mit fester Breite)
  WriteLn(Format(U_VERT + ' %-*s ' + U_VERT + ' %-*s ' + U_VERT + ' %-*s ' + U_VERT + 
    ' %-*s ' + U_VERT + ' %-*s ' + U_VERT + ' %-*s ' + U_VERT + ' %-*s ' + U_VERT,
    [COL_ID, 'ID', COL_DATE, 'Datum', COL_KM, 'KM', COL_LITER, 'Liter', 
     COL_EUR_L, 'EUR/L', COL_TOTAL, 'Gesamt', COL_STATION, 'Stations']));
  // Trenner nach Header
  DrawLine(U_L_T, U_CROSS, U_R_T, U_HORIZ);
end;

procedure PrintFuelupFooter(Simple: Boolean = False);
begin
  if Simple then 
    DrawLine(U_BOT_L, '', U_BOT_R, U_HORIZ, True)
  else 
    DrawLine(U_BOT_L, U_B_UP, U_BOT_R, U_HORIZ);
end;

procedure PrintFuelupSeparator;
begin
  // Nutzt duenne Linie (DASH) innerhalb der dicken Box
  DrawLine(U_SEP_L, U_DASH, U_SEP_R, U_DASH, True);
end;

procedure PrintFuelupSeparatorDouble;
begin
  // Nutzt dicke Linie (HORIZ) mit dicken Kreuzungen (fuer Standard-Ansicht)
  DrawLine(U_L_T, U_CROSS, U_R_T, U_HORIZ, False);
end;

procedure PrintFuelupRow(const AId: Integer; const AFueledAt: string; const AOdometerKm, ALitersMl, APriceMilli, ATotalCents: Int64; const AStation: string);
begin
  // Zusammensetzen der Zeile mit Padding-Helfern aus u_table
  WriteLn(U_VERT, ' ', PadL(IntToStr(AId), COL_ID), ' ', 
          U_VERT, ' ', PadR(AFueledAt, COL_DATE), ' ', 
          U_VERT, ' ', PadL(IntToStr(AOdometerKm), COL_KM), ' ', 
          U_VERT, ' ', PadL(FmtLiterFromMl(ALitersMl), COL_LITER), ' ', 
          U_VERT, ' ', PadL(FmtEurPerLiterFromMilli(APriceMilli), COL_EUR_L), ' ', 
          U_VERT, ' ', PadL(FmtEuroFromCents(ATotalCents), COL_TOTAL), ' ', 
          U_VERT, ' ', PadR(AStation, COL_STATION), ' ', U_VERT);
end;

procedure PrintFuelupDetail(const AIsFull, AMissedPrevious: Boolean; const ACarName, AFuelType, APayment, APump, ANote, AAddress: string);
  // Lokale Hilfsfunktion zum Zeichnen einer Detail-Zeile
  function DetailLine(const S: string): string;
  begin 
    Result := U_VERT + ' ' + PadR(Cut(S, FUELUP_DETAIL_WIDTH), FUELUP_DETAIL_WIDTH) + ' ' + U_VERT; 
  end;
begin
  // Zusammenfassende Info-Zeile
  WriteLn(DetailLine(
    'Car: ' + ACarName +
    ' | Full: ' + FmtBoolYN(Ord(AIsFull)) +
    ' | MissPrev: ' + FmtBoolYN(Ord(AMissedPrevious)) +
    ' | Fuel: ' + AFuelType +
    ' | Pay: ' + APayment +
    ' | Pump: ' + APump
  ));
  
  // Optional: Notiz nur anzeigen, wenn Text vorhanden
  if Trim(ANote) <> '' then 
    WriteLn(DetailLine('Note: ' + ANote));

  // Adresse
  WriteLn(DetailLine('Addr: ' + AAddress));
end;

end.

````

## Datei: `units/u_fuelups.pas`

````pascal
{
  u_fuelups.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Fachmodul fuer Erfassung und Auflistung von Betankungsvorgaengen.

  Verantwortlichkeiten:
  - Fuehrt den interaktiven Add-Flow fuer fuelups aus.
  - Listet fuelups in Standard- oder Detailansicht.
  - Validiert Odometer-/Lueckenlogik und Pflichtfelder vor Persistenz.

  Design-Prinzipien:
  - Datentransfer: `TFuelupInput` entkoppelt Dialogdaten von SQL-Schreibvorgaengen.
  - Praezision: Werte werden als skalierte Integer verarbeitet.
  - UI-Konsistenz: Ausgabeformat liegt in `u_fmt`.

  Hinweis:
  - Erfordert foreign_keys=ON und eine valide stations/cars-Datenbasis.
  ---------------------------------------------------------------------------
}

unit u_fuelups;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, SQLDB, SQLite3Conn;

// ----------------
// Oeffentliche Schnittstelle

// Startet den interaktiven Dialog zum Hinzufuegen einer Betankung.
procedure AddFuelupInteractive(const DbPath: string);

// Zeigt die Liste aller Betankungen an (Detailed steuert Zusatzinfos).
procedure ListFuelups(const DbPath: string; Detailed: boolean);

implementation

uses
  u_db_common,
  u_fmt,
  u_log;

type
  // ----------------
  // Datenstrukturen

  // Datensatz zur temporaeren Speicherung der Benutzereingaben
  TFuelupInput = record
    StationId: integer;
    CarId: integer;
    FueledAt: string;     // Format: "YYYY-MM-DD HH:MM:SS"
    OdometerKm: integer;
    LitersMl: int64;      // Menge in Millilitern
    TotalCents: int64;    // Gesamtbetrag in Cents
    PricePerLiterMilliEur: int64; // Preis/Liter in Milli-Cents
    IsFullTank: boolean;
    MissedPrevious: boolean;
    FuelType: string;
    PaymentType: string;
    PumpNo: string;
    Note: string;
  end;

const
  // Abstandsschwelle fuer die Rueckfrage "fehlende vorherige Betankung?".
  GAP_THRESHOLD_KM = 1500;
  // Warnschwelle fuer aussergewoehnlich grosse Tankmengen.
  MAX_TANK_ML_WARNING = 150000; // 150 L

// ----------------
// Interne Hilfsfunktion: Listet alle verfuegbaren Tankstellen zur Auswahl auf
procedure PrintStations(Q: TSQLQuery);
begin
  Q.Close;
  Q.SQL.Text :=
    'SELECT id, brand, city, street, house_no ' +
    'FROM stations ' +
    'ORDER BY brand, city, street, house_no;';
  Q.Open;

  if Q.EOF then
  begin
    WriteLn('Keine Tankstellen vorhanden. Bitte zuerst --add stations ausführen.');
    Exit;
  end;

  WriteLn;
  WriteLn('Verfügbare Tankstellen:');
  WriteLn(DupeString('-', 50));

  while not Q.EOF do
  begin
    WriteLn(
      Format('%3s: %s [%s, %s %s]', [
        Q.FieldByName('id').AsString,
        Q.FieldByName('brand').AsString,
        Q.FieldByName('city').AsString,
        Q.FieldByName('street').AsString,
        Q.FieldByName('house_no').AsString
      ])
    );
    Q.Next;
  end;
  WriteLn;
end;

// Interne Hilfsfunktion: Listet alle verfuegbaren Fahrzeuge zur Auswahl auf
procedure PrintCars(Q: TSQLQuery);
begin
  Q.Close;
  Q.SQL.Text :=
    'SELECT id, name ' +
    'FROM cars ' +
    'ORDER BY id;';
  Q.Open;

  if Q.EOF then
  begin
    WriteLn('Keine Fahrzeuge vorhanden. Bitte DB-Migration pruefen.');
    Exit;
  end;

  WriteLn;
  WriteLn('Verfügbare Fahrzeuge:');
  WriteLn(DupeString('-', 50));

  while not Q.EOF do
  begin
    WriteLn(
      Format('%3s: %s', [
        Q.FieldByName('id').AsString,
        Q.FieldByName('name').AsString
      ])
    );
    Q.Next;
  end;
  WriteLn;
end;

// Prüft, ob eine eingegebene Car-ID in der DB existiert
function CarExists(Q: TSQLQuery; const ACarId: Integer): boolean;
begin
  Q.Close;
  Q.SQL.Text := 'SELECT 1 FROM cars WHERE id = :id LIMIT 1;';
  Q.ParamByName('id').AsInteger := ACarId;
  Q.Open;
  Result := not Q.EOF;
end;

function GetCarOdometerStartKm(Q: TSQLQuery; const ACarId: integer): integer;
begin
  Q.Close;
  Q.SQL.Text := 'SELECT odometer_start_km FROM cars WHERE id = :id;';
  Q.ParamByName('id').AsInteger := ACarId;
  Q.Open;
  if Q.EOF then
    raise Exception.Create('Car nicht gefunden (id=' + IntToStr(ACarId) + ').');
  Result := Q.FieldByName('odometer_start_km').AsInteger;
  Q.Close;
end;

function GetLastOdometerKm(Q: TSQLQuery; const ACarId: integer): integer;
begin
  Q.Close;
  Q.SQL.Text :=
    'SELECT odometer_km ' +
    'FROM fuelups ' +
    'WHERE car_id = :car_id ' +
    'ORDER BY odometer_km DESC, fueled_at DESC, id DESC ' +
    'LIMIT 1;';
  Q.ParamByName('car_id').AsInteger := ACarId;
  Q.Open;
  if Q.EOF then Result := -1
  else Result := Q.FieldByName('odometer_km').AsInteger;
  Q.Close;
end;

// Interaktive Auswahl des Fahrzeugs mit Validierungsschleife.
// Bei genau einem vorhandenen Fahrzeug wird dieses automatisch verwendet.
function SelectCarIdInteractive(Q: TSQLQuery): Integer;
var
  S: string;
  Id: Integer;
  Cnt: Integer;
begin
  Q.Close;
  Q.SQL.Text := 'SELECT COUNT(*) AS cnt FROM cars;';
  Q.Open;
  Cnt := Q.FieldByName('cnt').AsInteger;
  Q.Close;

  if Cnt <= 0 then
    raise Exception.Create('Keine Fahrzeuge vorhanden. Migration/Seed prüfen.');

  if Cnt = 1 then
  begin
    Q.SQL.Text := 'SELECT id, name FROM cars ORDER BY id LIMIT 1;';
    Q.Open;
    Result := Q.FieldByName('id').AsInteger;
    WriteLn('Fahrzeug: ', Q.FieldByName('name').AsString, ' (ID ', Result, ')');
    Q.Close;
    Exit;
  end;

  PrintCars(Q);
  while True do
  begin
    Write('Car-ID (oder "l"=Liste, "q"=Abbruch): ');
    ReadLn(S);
    S := Trim(LowerCase(S));

    if (S = 'q') or (S = 'quit') then
      raise Exception.Create('Abbruch durch Benutzer.');

    if (S = 'l') or (S = 'list') then
    begin
      PrintCars(Q);
      Continue;
    end;

    if not TryStrToInt(S, Id) then
    begin
      WriteLn('Fehler: Bitte eine gültige Zahl eingeben.');
      Continue;
    end;

    if (Id <= 0) or not CarExists(Q, Id) then
    begin
      WriteLn('Fehler: Ungueltige Car-ID. ("l" fuer Liste)');
      Continue;
    end;

    Result := Id;
    Exit;
  end;
end;

// Prüft, ob eine eingegebene Station-ID in der DB existiert
function StationExists(Q: TSQLQuery; const AStationId: Integer): boolean;
begin
  Q.Close;
  Q.SQL.Text := 'SELECT 1 FROM stations WHERE id = :id LIMIT 1;';
  Q.ParamByName('id').AsInteger := AStationId;
  Q.Open;
  Result := not Q.EOF;
end;

// Interaktive Auswahl der Tankstelle mit Validierungsschleife
function SelectStationIdInteractive(Q: TSQLQuery): Integer;
var
  S: string;
  Id: Integer;
begin
  PrintStations(Q);

  while True do
  begin
    Write('Stations-ID (oder "l"=Liste, "q"=Abbruch): ');
    ReadLn(S);
    S := Trim(LowerCase(S));

    if (S = 'q') or (S = 'quit') then
      raise Exception.Create('Abbruch durch Benutzer.');

    if (S = 'l') or (S = 'list') then
    begin
      PrintStations(Q);
      Continue;
    end;

    if not TryStrToInt(S, Id) then
    begin
      WriteLn('Fehler: Bitte eine gültige Zahl eingeben.');
      Continue;
    end;

    if (Id <= 0) or not StationExists(Q, Id) then
    begin
      WriteLn('Fehler: Ungueltige Stations-ID. ("l" fuer Liste)');
      Continue;
    end;

    Result := Id;
    Exit;
  end;
end;

// Hauptprozedur zum Erfassen neuer Daten
procedure AddFuelupInteractive(const DbPath: string);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q, QS: TSQLQuery;
  Inp: TFuelupInput;
  S: string;
  StartKm: integer;
  LastKm: integer;
  DiffKm: integer;

  // Setzt optionale String-Parameter (leerer String wird zu NULL)
  procedure SetOptStr(const P, V: string);
  begin
    if V = '' then
      Q.ParamByName(P).Clear
    else
      Q.ParamByName(P).AsString := V;
  end;
  
  // Rollback und Fehler weiterreichen
  procedure Fail(const Prefix: string; E: Exception);
  begin
    if Tran.Active then
      Tran.Rollback;
    raise Exception.Create(Prefix + E.Message);
  end;
begin
  WriteLn('--- Neue Betankung erfassen ---');

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  QS := TSQLQuery.Create(nil);

  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;
    Q.DataBase := Conn;
    Q.Transaction := Tran;
    QS.DataBase := Conn;
    QS.Transaction := Tran;

    Conn.Open;
    Conn.ExecuteDirect('PRAGMA foreign_keys = ON;');
    // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
    if not Tran.Active then
      Tran.StartTransaction;
    
    try
      Inp.CarId := 1; // v4 Minimalumfang: Default-Car (Hauptauto)
      Inp.StationId := SelectStationIdInteractive(QS);
      Inp.FueledAt := AskRequired('Datum+Uhrzeit (YYYY-MM-DD HH:MM:SS): ');

      S := AskRequired('Kilometerstand (km): ');
      if not TryStrToInt(S, Inp.OdometerKm) then
        raise Exception.Create('Ungültiger Kilometerstand.');

      // Domain-Validation: Startpunkt + Monotonie pro Fahrzeug
      StartKm := GetCarOdometerStartKm(QS, Inp.CarId);
      if Inp.OdometerKm < StartKm then
        raise Exception.Create(Format('Odometer unter Start-KM (start=%d, current=%d).', [StartKm, Inp.OdometerKm]));

      LastKm := GetLastOdometerKm(QS, Inp.CarId);
      if (LastKm >= 0) and (Inp.OdometerKm <= LastKm) then
        raise Exception.Create(Format('Odometer mismatch. Current=%d, Last=%d. Cars don''t travel back in time.', [Inp.OdometerKm, LastKm]));

      DiffKm := 0;
      if LastKm >= 0 then
        DiffKm := Inp.OdometerKm - LastKm;

      // Erfassung der skalierten Ganzzahl-Werte
      Inp.TotalCents := AskAndParseInt64(
        'Gesamtpreis (EUR, z.B. 50,01): ',
        @ParseEuroToCents, @FmtEuroFromCents, 'Gesamtpreis', False
      );

      Inp.LitersMl := AskAndParseInt64(
        'Getankte Menge (Liter, z.B. 28,76): ',
        @ParseLitersToMl, @FmtLiterFromMl, 'Liter', False
      );

      // Plausibilitaet: sehr grosse Tankmenge (Warning + Confirm)
      if Inp.LitersMl > MAX_TANK_ML_WARNING then
      begin
        if not AskYesNo(
          Format('Warnung: Sehr grosse Tankmenge (%s L). Tippfehler? Trotzdem speichern?', [FmtLiterFromMl(Inp.LitersMl)]),
          False
        ) then
          raise Exception.Create('Abbruch durch Benutzer (Tankmenge).');
      end;

      Inp.PricePerLiterMilliEur := AskAndParseInt64(
        'Preis pro Liter (EUR/L, z.B. 1,739): ',
        @ParseEurPerLiterToMilli, @FmtEurPerLiterFromMilli, 'Preis/L', False
      );

      Inp.IsFullTank := AskYesNo('Vollgetankt?', True);

      // Golden Information: nur bei grosser Distanz nachfragen
      Inp.MissedPrevious := False;
      if (LastKm >= 0) and (DiffKm > GAP_THRESHOLD_KM) then
      begin
        Inp.MissedPrevious := AskYesNo(
          Format('Warnung: Distanz seit letzter Betankung ist %d km (> %d). Hast du evtl. eine Betankung vergessen?', [DiffKm, GAP_THRESHOLD_KM]),
          False
        );
      end;

      Inp.FuelType    := AskOptional('Spritart (optional, z.B. E10): ');
      Inp.PaymentType := AskOptional('Bezahlart (optional, z.B. EC): ');
      Inp.PumpNo      := AskOptional('Zapfsäule (optional): ');
      Inp.Note        := AskOptional('Notiz (optional): ');

      Q.SQL.Text :=
        'INSERT INTO fuelups(' +
        '  station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents, price_per_liter_milli_eur,' +
        '  is_full_tank, missed_previous, fuel_type, payment_type, pump_no, note' +
        ') VALUES(' +
        '  :station_id, :car_id, :fueled_at, :odometer_km, :liters_ml, :total_cents, :ppl_milli,' +
        '  :is_full_tank, :missed_previous, :fuel_type, :payment_type, :pump_no, :note' +
        ');';

      Q.ParamByName('station_id').AsInteger := Inp.StationId;
      Q.ParamByName('car_id').AsInteger := Inp.CarId;
      Q.ParamByName('fueled_at').AsString   := Inp.FueledAt;
      Q.ParamByName('odometer_km').AsInteger := Inp.OdometerKm;
      Q.ParamByName('liters_ml').AsLargeInt := Inp.LitersMl;
      Q.ParamByName('total_cents').AsLargeInt := Inp.TotalCents;
      Q.ParamByName('ppl_milli').AsLargeInt := Inp.PricePerLiterMilliEur;
      Q.ParamByName('is_full_tank').AsInteger := Ord(Inp.IsFullTank);
      Q.ParamByName('missed_previous').AsInteger := Ord(Inp.MissedPrevious);

      SetOptStr('fuel_type', Inp.FuelType);
      SetOptStr('payment_type', Inp.PaymentType);
      SetOptStr('pump_no', Inp.PumpNo);
      SetOptStr('note', Inp.Note);

      Dbg('AddFuelup: station_id=' + IntToStr(Inp.StationId) +
        ' car_id=' + IntToStr(Inp.CarId) +
        ' full=' + BoolToStr(Inp.IsFullTank, True) +
        ' missed_previous=' + BoolToStr(Inp.MissedPrevious, True));
      Q.ExecSQL;
      Tran.Commit;
      WriteLn('OK: Betankung erfolgreich gespeichert.');

    except
      on E: Exception do
        Fail('AddFuelup fehlgeschlagen: ', E);
    end;
  finally
    QS.Free; Q.Free; Tran.Free; Conn.Free;
  end;
end;

// Listet die Tankhistorie tabellarisch auf
procedure ListFuelups(const DbPath: string; Detailed: boolean);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  IsFirstRow: boolean;
  RowCount: integer;

  // Rollback und Fehler weiterreichen
  procedure Fail(const Prefix: string; E: Exception);
  begin
    if Tran.Active then
      Tran.Rollback;
    raise Exception.Create(Prefix + E.Message);
  end;
begin
  Dbg('ListFuelups: detailed=' + BoolToStr(Detailed, True));
  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;
    Q.DataBase := Conn;
    Q.Transaction := Tran;

    Conn.Open;
    Conn.ExecuteDirect('PRAGMA foreign_keys = ON;');
    if not Tran.Active then
      Tran.StartTransaction;

    try
      Q.SQL.Text :=
        'SELECT f.id, f.fueled_at, f.odometer_km, f.liters_ml, f.total_cents, ' +
        '       f.price_per_liter_milli_eur, f.is_full_tank, f.missed_previous, ' +
        '       COALESCE(f.fuel_type, '''') AS fuel_type, ' +
        '       COALESCE(f.payment_type, '''') AS payment_type, ' +
        '       COALESCE(f.pump_no, '''') AS pump_no, ' +
        '       COALESCE(f.note, '''') AS note, ' +
        '       COALESCE(c.name, ''(unbekannt)'') AS car_name, ' +
        '       s.brand, s.city, s.street, s.house_no ' +
        'FROM fuelups f ' +
        'LEFT JOIN cars c ON c.id = f.car_id ' +
        'JOIN stations s ON s.id = f.station_id ' +
        'ORDER BY f.fueled_at DESC, f.id DESC;';
      Q.Open;

      if Q.EOF then
      begin
        WriteLn('Keine Betankungsdaten gefunden.');
        if Tran.Active then
          Tran.Commit;
        Exit;
      end;

      PrintFuelupHeader;

      IsFirstRow := True;
      RowCount := 0;
      while not Q.EOF do
      begin
        Inc(RowCount);
        if not IsFirstRow then
          if Detailed then
            // Duenne Linie fuer den Detail-Block-Trenner
            PrintFuelupSeparator
          else
            // Dicke Linie fuer den Standard-Zeilentrenner
            PrintFuelupSeparatorDouble;

        PrintFuelupRow(
          Q.FieldByName('id').AsInteger,
          Q.FieldByName('fueled_at').AsString,
          Q.FieldByName('odometer_km').AsLargeInt,
          Q.FieldByName('liters_ml').AsLargeInt,
          Q.FieldByName('price_per_liter_milli_eur').AsLargeInt,
          Q.FieldByName('total_cents').AsLargeInt,
          Q.FieldByName('brand').AsString + ' (' + Q.FieldByName('city').AsString + ') / ' + Q.FieldByName('car_name').AsString
        );
    
        if Detailed then
        begin
          PrintFuelupDetail(
            Q.FieldByName('is_full_tank').AsInteger = 1,
            Q.FieldByName('missed_previous').AsInteger = 1,
            Q.FieldByName('car_name').AsString,
            Q.FieldByName('fuel_type').AsString,
            Q.FieldByName('payment_type').AsString,
            Q.FieldByName('pump_no').AsString,
            Q.FieldByName('note').AsString,
            Q.FieldByName('street').AsString + ' ' + Q.FieldByName('house_no').AsString + ', ' + Q.FieldByName('city').AsString
          );
        end;
        
        IsFirstRow := False;
        Q.Next;
      end;

      PrintFuelupFooter(Detailed);
      Dbg('ListFuelups: rows=' + IntToStr(RowCount));
      Tran.Commit;
    except
      on E: Exception do
        Fail('Fehler beim Laden der Liste: ', E);
    end;
  finally
    Q.Free; Tran.Free; Conn.Free;
  end;
end;

end.

````

## Datei: `units/u_log.pas`

````pascal
{
  u_log.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Zentrale Logging- und Laufzeitdiagnose-Unit fuer die CLI.

  Verantwortlichkeiten:
  - Steuert Status-, Trace- und Debug-Ausgaben ueber globale Flags.
  - Liefert einheitliche Debug-Tabellenzeilen fuer technische Diagnosen.
  - Kapselt die Quiet-Policy als globales Ausgabe-Gate.

  Design-Entscheidungen:
  - Global Flags statt Context-Passing fuer geringe Integrationskosten.
  - Quiet priorisiert: unterdrueckt Status, Trace und Debug konsistent.
  - Schlanke API: bewusst klein, damit Aufrufer einfach bleiben.

  Verwendung:
  - Msg(): Statusmeldungen (respektiert Quiet).
  - Dbg(): Trace-Meldungen mit Prefix [TRC] (nur bei Trace).
  - DbgRow/DbgSep: strukturierte Debug-Tabellen (nur bei Debug).
  ---------------------------------------------------------------------------
}
unit u_log;

{$mode objfpc}{$H+}

interface

// ----------------
// Aktiviert oder deaktiviert Debug-Tabellen global
procedure SetDebug(Value: boolean);

// Aktiviert oder deaktiviert Trace-Ausgaben global
procedure SetTrace(Value: boolean);

// Unterdrueckt alle Ausgaben (Status, Trace, Debug)
procedure SetQuiet(Value: boolean);

// Normale Statusmeldung (respektiert Quiet)
procedure Msg(const S: string);

// Gibt eine einfache Trace-Nachricht aus (Prefix [TRC], respektiert Quiet)
procedure Dbg(const S: string);

// Gibt eine formatierte Tabellenzeile im Debug-Modus aus (respektiert Quiet)
procedure DbgRow(const Key, Value: string);

// Gibt eine Trennlinie fuer Debug-Tabellen aus (respektiert Quiet)
procedure DbgSep;

const
  // Spaltenbreiten fuer Debug-Tabellen
  COL_KEY = 20;
  COL_VAL = 60;

implementation

uses
  SysUtils,
  u_fmt;

var
  // Globaler Debug-Schalter (DbgRow/DbgSep)
  GDebug: boolean = False;

  // Globaler Trace-Schalter (Dbg)
  GTrace: boolean = False;

  // Globaler Quiet-Schalter (unterdrueckt alle Ausgaben)
  GQuiet: boolean = False;

procedure SetDebug(Value: boolean);
begin
  GDebug := Value;
end;

procedure SetQuiet(Value: boolean);
begin
  GQuiet := Value;
end;

procedure SetTrace(Value: boolean);
begin
  GTrace := Value;
end;

procedure Msg(const S: string);
begin
  if not GQuiet then
    WriteLn(S);
end;

procedure Dbg(const S: string);
begin
  if GQuiet then Exit;
  if GTrace then
    WriteLn('[TRC] ', S);
end;

procedure DbgRow(const Key, Value: string);
begin
  if GQuiet then Exit;
  if GDebug then
    WriteLn(Format('| %-*s | %-*s |', [COL_KEY, Key, COL_VAL, Value]));
end;

procedure DbgSep;
begin
  if GQuiet then Exit;
  if GDebug then
    WriteLn(
      C_CYAN + '+' + StringOfChar('-', COL_KEY + 2) + '+' +
      StringOfChar('-', COL_VAL + 2) + '+' + C_RESET
    );
end;

end.

````

## Datei: `units/u_stations.pas`

````pascal
{
  u_stations.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Fachmodul fuer Stammdatenverwaltung von Tankstellen (stations).

  Verantwortlichkeiten:
  - Implementiert Add/List/Edit/Delete fuer stations.
  - Bietet kompakte und detaillierte Listendarstellung.
  - Sichert Adress-Eindeutigkeit ueber DB-Constraints + Fehlermapping.

  Design-Entscheidungen:
  - Atomare Schreiboperationen per Transaktion.
  - Konsistentes CLI-Layout via feste Spaltenbreiten.
  - Defensive Eingabepruefung vor DB-Schreibvorgaengen.

  Hinweis:
  - Jede Betankung referenziert stations; diese Unit ist daher
    zentrale Stammdatenbasis fuer u_fuelups.
  ---------------------------------------------------------------------------
}
unit u_stations;

{$mode objfpc}{$H+}

interface

// ----------------
// Oeffentliche Schnittstelle
// Listet alle Tankstellen (optional als Detail-Tabelle)
procedure ListStations(const DbPath: string; Detailed: boolean);

// Fuegt interaktiv eine neue Tankstelle hinzu
procedure AddStationInteractive(const DbPath: string);

// Loescht eine Tankstelle nach expliziter Bestaetigung
procedure DeleteStationInteractive(const DbPath: string);

// Bearbeitet eine bestehende Tankstelle interaktiv
procedure EditStationInteractive(const DbPath: string);

implementation

uses
  SysUtils, Classes, SQLite3Conn, SQLDB, u_fmt, u_db_common, u_log;

const
  // ----------------
  // Spaltenlayout
  // Spaltenbreiten fuer Detail-Tabelle (anpassbar)
  COL_ID = 4;
  COL_BRAND = 12;
  COL_STREET = 22;
  COL_HNO = 6;
  COL_ZIP = 6;
  COL_CITY = 16;
  COL_PHONE = 14;
  COL_OWNER = 16;

procedure PrintSep;
begin
  // Optik wie Debug-Rahmen (C_CYAN/C_RESET kommen aus u_fmt)
  WriteLn(C_CYAN + '+' + StringOfChar('-', COL_ID + 2) + '+' +
    StringOfChar('-', COL_BRAND + 2) + '+' + StringOfChar('-', COL_STREET + 2) +
    '+' + StringOfChar('-', COL_HNO + 2) + '+' + StringOfChar('-', COL_ZIP + 2) +
    '+' + StringOfChar('-', COL_CITY + 2) + '+' + StringOfChar('-', COL_PHONE + 2) +
    '+' + StringOfChar('-', COL_OWNER + 2) + '+' + C_RESET);
end;

procedure PrintRow(const AId, ABrand, AStreet, AHouseNo, AZip, ACity,
  APhone, AOwner: string);
begin
  WriteLn(Format('| %-*s | %-*s | %-*s | %-*s | %-*s | %-*s | %-*s | %-*s |',
    [COL_ID, AId, COL_BRAND, ABrand, COL_STREET, AStreet, COL_HNO,
    AHouseNo, COL_ZIP, AZip, COL_CITY, ACity, COL_PHONE, APhone, COL_OWNER, AOwner]));
end;

function StationLine(const Brand, Street, HouseNo, Zip, City: string): string;
begin
  Result := Format('%s (%s %s, %s %s)', [Brand, Street, HouseNo, Zip, City]);
end;

procedure ListStations(const DbPath: string; Detailed: boolean);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  SId, SBrand, SStreet, SHouseNo, SZip, SCity, SPhone, SOwner: string;
  RowCount: integer;
begin
  Dbg('ListStations: detailed=' + BoolToStr(Detailed, True));
  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);

  try
    try
      Conn.DatabaseName := DbPath;
      Conn.Transaction := Tran;
      Q.DataBase := Conn;
      Q.Transaction := Tran;

      Conn.Open;
      // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
      if not Tran.Active then
        Tran.StartTransaction;

      Q.SQL.Text :=
        'SELECT id, brand, street, house_no, zip, city, phone, owner ' +
        'FROM stations ' + 'ORDER BY brand, city, street, house_no;';
      Q.Open;

      if Q.EOF then
      begin
        WriteLn('Keine Tankstellen vorhanden.');
        Q.Close;
        Tran.Commit;
        Exit;
      end;

      if Detailed then
      begin
        PrintSep;
        PrintRow('id', 'brand', 'street', 'nr', 'zip', 'city', 'phone', 'owner');
        PrintSep;
      end;

      RowCount := 0;
      while not Q.EOF do
      begin
        Inc(RowCount);
        SId := Q.FieldByName('id').AsString;
        SBrand := Q.FieldByName('brand').AsString;
        SStreet := Q.FieldByName('street').AsString;
        SHouseNo := Q.FieldByName('house_no').AsString;
        SZip := Q.FieldByName('zip').AsString;
        SCity := Q.FieldByName('city').AsString;
        SPhone := Q.FieldByName('phone').AsString;
        SOwner := Q.FieldByName('owner').AsString;

        if Detailed then
          PrintRow(SId, SBrand, SStreet, SHouseNo, SZip, SCity, SPhone, SOwner)
        else
          WriteLn(StationLine(SBrand, SStreet, SHouseNo, SZip, SCity));

        Q.Next;
      end;

      if Detailed then
        PrintSep;

      Dbg('ListStations: rows=' + IntToStr(RowCount));
      Q.Close;
      Tran.Commit;

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;
        raise Exception.Create('ListStations fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

procedure AddStationInteractive(const DbPath: string);
var
  Brand, Street, HouseNo, Zip, City, Phone, Owner: string;
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
begin
  WriteLn('Tankstelle hinzufügen');
  WriteLn('---------------------');

  Brand := AskRequired('Brand: ');
  Street := AskRequired('Street: ');
  HouseNo := AskRequired('HouseNo: ');
  Zip := AskRequired('Plz: ');
  City := AskRequired('City: ');
  Phone := AskOptional('Phone (Optional): ');
  Owner := AskOptional('Owner (Optional): ');

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);

  try
    try
      Conn.DatabaseName := DbPath;
      Conn.Transaction := Tran;
      Q.DataBase := Conn;
      Q.Transaction := Tran;

      Conn.Open;
      // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
      if not Tran.Active then
        Tran.StartTransaction;

      Q.SQL.Text :=
        'INSERT INTO stations(brand, street, house_no, zip, city, phone, owner) ' +
        'VALUES(:brand, :street, :house_no, :zip, :city, :phone, :owner);';

      Q.Params.ParamByName('brand').AsString := Brand;
      Q.Params.ParamByName('street').AsString := Street;
      Q.Params.ParamByName('house_no').AsString := HouseNo;
      Q.Params.ParamByName('zip').AsString := Zip;
      Q.Params.ParamByName('city').AsString := City;
      Q.Params.ParamByName('phone').AsString := Phone;
      Q.Params.ParamByName('owner').AsString := Owner;

      Dbg('AddStation: brand=' + Brand + ' city=' + City);
      Q.ExecSQL;
      Tran.Commit;

      WriteLn('OK: Tankstelle - ' + C_YELLOW + StationLine(Brand,
        Street, HouseNo, Zip, City) + C_RESET + ' - gespeichert.');

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;

        // UNIQUE-Constraint freundlich abfangen (Adresse schon vorhanden)
        if Pos('UNIQUE', UpperCase(E.Message)) > 0 then
          raise Exception.Create(
            'Diese Tankstelle existiert bereits (Adresse ist schon gespeichert).')
        else
          raise Exception.Create('AddStation fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

procedure DeleteStationInteractive(const DbPath: string);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;

  IdStr: string;
  Id: integer;
  Confirm: string;

  Brand, Street, HouseNo, Zip, City: string;
begin
  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);

  try
    try
      Conn.DatabaseName := DbPath;
      Conn.Transaction := Tran;
      Q.DataBase := Conn;
      Q.Transaction := Tran;

      Conn.Open;
      // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
      if not Tran.Active then
        Tran.StartTransaction;

      // Liste anzeigen (nur id und Anzeigezeile)
      Q.SQL.Text :=
        'SELECT id, brand, street, house_no, zip, city ' + 'FROM stations ' +
        'ORDER BY brand, city, street, house_no;';
      Q.Open;

      if Q.EOF then
      begin
        WriteLn('Keine Tankstellen vorhanden.');
        Q.Close;
        Tran.Commit;
        Exit;
      end;

      WriteLn('Tankstellen (ID):');
      while not Q.EOF do
      begin
        Brand := Q.FieldByName('brand').AsString;
        Street := Q.FieldByName('street').AsString;
        HouseNo := Q.FieldByName('house_no').AsString;
        Zip := Q.FieldByName('zip').AsString;
        City := Q.FieldByName('city').AsString;

        WriteLn(Q.FieldByName('id').AsString, ': ',
          StationLine(Brand, Street, HouseNo, Zip, City));
        Q.Next;
      end;
      Q.Close;

      // ID abfragen
      WriteLn;
      Write('ID (oder q): ');
      ReadLn(IdStr);
      IdStr := Trim(LowerCase(IdStr));

      if (IdStr = 'q') then
      begin
        WriteLn('Abgebrochen.');
        Tran.Commit;
        Exit;
      end;

      if not TryStrToInt(IdStr, Id) then
      begin
        Tran.Rollback;
        raise Exception.Create('Ungültige ID. Bitte eine Zahl oder q eingeben.');
      end;

      // Station zur ID laden (damit wir bestaetigen koennen)
      Q.SQL.Text :=
        'SELECT brand, street, house_no, zip, city ' +
        'FROM stations WHERE id = :id;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Q.Open;

      if Q.EOF then
      begin
        Q.Close;
        Tran.Commit;
        WriteLn('Keine Tankstelle mit dieser ID gefunden.');
        Exit;
      end;

      Brand := Q.FieldByName('brand').AsString;
      Street := Q.FieldByName('street').AsString;
      HouseNo := Q.FieldByName('house_no').AsString;
      Zip := Q.FieldByName('zip').AsString;
      City := Q.FieldByName('city').AsString;
      Q.Close;

      WriteLn('Ausgewählt: ', StationLine(Brand, Street, HouseNo, Zip, City));
      Write('Sicher löschen (y/n)? ');
      ReadLn(Confirm);
      Confirm := Trim(LowerCase(Confirm));

      if (Confirm <> 'y') and (Confirm <> 'yes') then
      begin
        WriteLn('Abgebrochen.');
        Tran.Commit;
        Exit;
      end;

      // Loeschen
      Q.SQL.Text := 'DELETE FROM stations WHERE id = :id;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Dbg('DeleteStation: id=' + IntToStr(Id));
      Q.ExecSQL;

      if Q.RowsAffected = 0 then
      begin
        Tran.Rollback;
        raise Exception.Create('Löschen fehlgeschlagen (keine Zeile betroffen).');
      end;

      Tran.Commit;
      WriteLn('OK: Tankstelle gelöscht.');

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;
        raise Exception.Create('DeleteStation fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

// Helfer: Anzeige fuer Aenderungen
function ReplaceLine(const Brand, Street, HouseNo, Zip, City, Phone,
  Owner: string): string;
begin
  Result := Format('%s (%s %s, %s %s %s %s)', [Brand, Street, HouseNo,
    Zip, City, Phone, Owner]);
end;

procedure EditStationInteractive(const DbPath: string);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;

  IdStr: string;
  Id: integer;
  Confirm: string;

  TmpBrand, TmpStreet, TmpHouseNo, TmpZip, TmpCity, TmpPhone, TmpOwner: string;
  OldBrand, OldStreet, OldHouseNo, OldZip, OldCity, OldPhone, OldOwner: string;
  NewBrand, NewStreet, NewHouseNo, NewZip, NewCity, NewPhone, NewOwner: string;
begin
  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);

  try
    try
      Conn.DatabaseName := DbPath;
      Conn.Transaction := Tran;
      Q.DataBase := Conn;
      Q.Transaction := Tran;

      Conn.Open;
      // Startet nur, wenn nicht schon aktiv (SQLDB kann auto-starten)
      if not Tran.Active then
        Tran.StartTransaction;

      // Liste anzeigen (nur id und Anzeigezeile)
      Q.SQL.Text :=
        'SELECT id, brand, street, house_no, zip, city, phone, owner ' +
        'FROM stations ' +
        'ORDER BY brand, city, street, house_no, phone, owner;';
      Q.Open;

      if Q.EOF then
      begin
        WriteLn('Keine Tankstellen vorhanden.');
        Q.Close;
        Tran.Commit;
        Exit;
      end;

      WriteLn('Tankstellen (ID):');
      while not Q.EOF do
      begin
        TmpBrand := Q.FieldByName('brand').AsString;
        TmpStreet := Q.FieldByName('street').AsString;
        TmpHouseNo := Q.FieldByName('house_no').AsString;
        TmpZip := Q.FieldByName('zip').AsString;
        TmpCity := Q.FieldByName('city').AsString;
        TmpPhone := Q.FieldByName('phone').AsString;
        TmpOwner := Q.FieldByName('owner').AsString;

        WriteLn(Q.FieldByName('id').AsString, ': ',
          ReplaceLine(TmpBrand, TmpStreet, TmpHouseNo, TmpZip, TmpCity,
          TmpPhone, TmpOwner));
        Q.Next;
      end;

      Q.Close;

      // ID abfragen
      WriteLn;
      Write('ID (oder q): ');
      ReadLn(IdStr);
      IdStr := Trim(LowerCase(IdStr));

      if (IdStr = 'q') then
      begin
        WriteLn('Abgebrochen.');
        Tran.Commit;
        Exit;
      end;

      if not TryStrToInt(IdStr, Id) then
      begin
        Tran.Rollback;
        raise Exception.Create('Ungültige ID. Bitte eine Zahl oder q eingeben.');
      end;

      // Station zur ID laden
      Q.SQL.Text :=
        'SELECT brand, street, house_no, zip, city, phone, owner ' +
        'FROM stations WHERE id = :id;';
      Q.Params.ParamByName('id').AsInteger := Id;
      Q.Open;

      if Q.EOF then
      begin
        Q.Close;
        Tran.Commit;
        WriteLn('Keine Tankstelle mit dieser ID gefunden.');
        Exit;
      end;

      // Auswahl speichern
      OldBrand := Q.FieldByName('brand').AsString;
      OldStreet := Q.FieldByName('street').AsString;
      OldHouseNo := Q.FieldByName('house_no').AsString;
      OldZip := Q.FieldByName('zip').AsString;
      OldCity := Q.FieldByName('city').AsString;
      OldPhone := Q.FieldByName('phone').AsString;
      OldOwner := Q.FieldByName('owner').AsString;

      // Aenderungen abfragen und eintragen
      NewBrand := AskKeep('Brand*: (ENTER=behalten)', Q.FieldByName('brand').AsString);
      NewStreet := AskKeep('Street*: (ENTER=behalten)',
        Q.FieldByName('street').AsString);
      NewHouseNo := AskKeep('HouseNo*: (ENTER=behalten)',
        Q.FieldByName('house_no').AsString);
      NewZip := AskKeep('Zip*: (ENTER=behalten)', Q.FieldByName('zip').AsString);
      NewCity := AskKeep('City*: (ENTER=behalten)', Q.FieldByName('city').AsString);
      NewPhone := AskKeep('Phone: (ENTER=behalten)', Q.FieldByName('phone').AsString);
      NewOwner := AskKeep('Owner: (ENTER=behalten)', Q.FieldByName('owner').AsString);

      // Sicherheitspruefung: Pflichtfeld leer?
      EnsureNotEmpty('brand', NewBrand);
      EnsureNotEmpty('street', NewStreet);
      EnsureNotEmpty('house_no', NewHouseNo);
      EnsureNotEmpty('zip', NewZip);
      EnsureNotEmpty('city', NewCity);
      Q.Close;

      WriteLn('Ausgewählt: ', ReplaceLine(OldBrand, OldStreet, OldHouseNo,
        OldZip, OldCity, OldPhone, OldOwner));
      Writeln('Ändern in: ', ReplaceLine(NewBrand, NewStreet,
        NewHouseNo, NewZip, NewCity, NewPhone, NewOwner));
      Write('Sicher ändern (y/n)? ');
      ReadLn(Confirm);
      Confirm := Trim(LowerCase(Confirm));

      if (Confirm <> 'y') and (Confirm <> 'yes') then
      begin
        WriteLn('Abgebrochen.');
        Tran.Commit;
        Exit;
      end;

      // Aendern
      Q.SQL.Text :=
        'UPDATE stations ' +
        'SET brand=:brand, street=:street, house_no=:house_no, zip=:zip, city=:city, ' +
        'phone=:phone, owner=:owner ' + 'WHERE id = :id;';

      // Parameter zuweisen
      Q.Params.ParamByName('brand').AsString := NewBrand;
      Q.Params.ParamByName('street').AsString := NewStreet;
      Q.Params.ParamByName('house_no').AsString := NewHouseNo;
      Q.Params.ParamByName('zip').AsString := NewZip;
      Q.Params.ParamByName('city').AsString := NewCity;
      Q.Params.ParamByName('phone').AsString := NewPhone;
      Q.Params.ParamByName('owner').AsString := NewOwner;
      Q.Params.ParamByName('id').AsInteger := Id;
      Dbg('EditStation: id=' + IntToStr(Id));
      Q.ExecSQL;

      if Q.RowsAffected = 0 then
      begin
        Tran.Rollback;
        raise Exception.Create('Änderung fehlgeschlagen (keine Zeile betroffen).');
      end;

      Tran.Commit;
      WriteLn('OK: Änderungen vorgenommen.');

    except
      on E: Exception do
      begin
        if Assigned(Tran) and Tran.Active then
          Tran.Rollback;
        raise Exception.Create('Edit fehlgeschlagen: ' + E.Message);
      end;
    end;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

end.

````

## Datei: `units/u_stats.pas`

````pascal
{
  u_stats.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Statistik-Funktionen fuer Betankungen.

  Verantwortlichkeiten:
  - Auswertung von Tankvorgaengen (fuelups) fuer Volltank-Zyklen.
  - Aggregation von Zeitraum, Zyklen, Strecke, Kraftstoff und Kosten.
  - Tabellenbasierte Ausgabe der Zyklusdaten plus Summenzeile.
  - Dashboard-Ausgabe (Unicode-Boxen) als alternative Textausgabe.
  - JSON-Ausgabe fuer Zyklen/Monate/Jahre (`--json`, optional Pretty).
  - CSV-Ausgabe der Zyklus-/Monatsdaten (maschinenlesbar, strict).
  - Monatsaggregation fuer `--stats fuelups --monthly` (Text + JSON kind "fuelups_monthly").
  - Jahresaggregation fuer `--stats fuelups --yearly` (Text + JSON kind "fuelups_yearly").

  Hinweise:
  - Erwartet die Tabelle fuelups inkl. car_id, is_full_tank, odometer_km, liters_ml, total_cents.
  - Zeitraumgrenzen werden intern als [from inklusiv, to_excl exklusiv] verarbeitet.
  ---------------------------------------------------------------------------
}
unit u_stats;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}

interface

// Liefert die Standard-Zyklusstatistik (Text, ohne Period-Filter).
procedure ShowFuelupStats(const DbPath: string); overload;
// Liefert Zyklus-/Monats-/Jahresstatistik im Textformat mit optionalem Period-Filter.
procedure ShowFuelupStats(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean; const Yearly: boolean = False); overload;

// Liefert CSV-Statistik mit Standardparametern.
procedure ShowFuelupStatsCsv(const DbPath: string); overload;
// Liefert CSV-Statistik (Zyklen oder Monate) mit optionalem Period-Filter.
procedure ShowFuelupStatsCsv(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean); overload;

// Liefert JSON-Statistik (compact) mit Standardparametern.
procedure ShowFuelupStatsJson(const DbPath: string); overload;
// Liefert JSON-Statistik (compact/pretty, monthly/yearly optional).
procedure ShowFuelupStatsJson(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const Yearly: boolean = False;
  const Pretty: boolean = False); overload;

// Liefert Dashboard-Statistik mit Standardparametern.
procedure ShowFuelupDashboard(const DbPath: string); overload;
// Liefert Dashboard-Statistik (Textbox-Renderer) mit optionalem Period-Filter.
procedure ShowFuelupDashboard(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean); overload;

implementation

uses
  SysUtils,
  SQLite3Conn, SQLDB, u_log, u_table, u_fmt;

// ------------------------------------------------------------
// Zeitraum-Helper inkl. Debug des effektiven Zeitraums
procedure ResolvePeriodBounds(
  Q: TSQLQuery;
  const PeriodEnabled: boolean;
  var FromIso, ToExclIso: string;
  const FromProvided, ToProvided: boolean);
begin
  if not PeriodEnabled then Exit;

  // Nur --from: to = MAX(fueled_at) der Daten nach from, dann +1 Sekunde exklusiv
  if FromProvided and (not ToProvided) and (ToExclIso = '') and (FromIso <> '') then
  begin
    Q.Close;
    Q.SQL.Text :=
      'SELECT datetime(MAX(fueled_at), ''+1 second'') AS to_excl ' +
      'FROM fuelups ' +
      'WHERE fueled_at >= :from;';
    Q.Params.ParamByName('from').AsString := FromIso;
    Q.Open;
    ToExclIso := Q.FieldByName('to_excl').AsString; // kann '' sein bei 0 Rows
    Q.Close;
  end;

  // Nur --to: from = MIN(fueled_at) der Daten vor to_excl
  if ToProvided and (not FromProvided) and (FromIso = '') and (ToExclIso <> '') then
  begin
    Q.Close;
    Q.SQL.Text :=
      'SELECT MIN(fueled_at) AS min_dt ' +
      'FROM fuelups ' +
      'WHERE fueled_at < :to_excl;';
    Q.Params.ParamByName('to_excl').AsString := ToExclIso;
    Q.Open;
    FromIso := Q.FieldByName('min_dt').AsString; // kann '' sein bei 0 Rows
    Q.Close;
  end;
end;

procedure ApplyPeriodWhere(
  Q: TSQLQuery;
  const PeriodEnabled: boolean;
  const FromIso, ToExclIso: string);
begin
  if not PeriodEnabled then Exit;

  if FromIso <> '' then
    Q.Params.ParamByName('from').AsString := FromIso;

  if ToExclIso <> '' then
    Q.Params.ParamByName('to_excl').AsString := ToExclIso;
end;

// ------------------------------------------------------------
// Debug: Effektiver Zeitraum nach Kopf-Query
procedure DbgEffectivePeriod(
  const PeriodEnabled: boolean;
  const FromProvided, ToProvided: boolean;
  const EffFromIso, EffToExclIso: string;
  const RowCount: Int64);
var
  Notes: string;
begin
  if not PeriodEnabled then Exit;

  Notes := '';
  if FromProvided and (not ToProvided) then Notes := Notes + ' open-ended-to';
  if ToProvided and (not FromProvided) then Notes := Notes + ' open-ended-from';

  if Notes <> '' then
    Notes := ' (open-ended resolved:' + Notes + ')'
  else
    Notes := ' (closed period)';

  if RowCount = 0 then
    Notes := Notes + ' (no rows after filter)';

  Dbg('Stats period: from=' + EffFromIso + ' to_excl=' + EffToExclIso + Notes);
end;

function FieldInt64OrZero(Q: TSQLQuery; const FieldName: string): Int64;
begin
  if Q.FieldByName(FieldName).IsNull then
    Exit(0);
  Result := Q.FieldByName(FieldName).AsLargeInt;
end;

// ------------------------------------------------------------
// Monats-Aggregator
type
  TMonthAgg = record
    Month: string;        // 'YYYY-MM'
    DistKm: Int64;
    LitersMl: Int64;
    TotalCents: Int64;
  end;
  TMonthAggArray = array of TMonthAgg;

function MonthKeyFromIso(const DtIso: string): string;
begin
  if Length(DtIso) >= 7 then Result := Copy(DtIso, 1, 7) else Result := '????-??';
end;

procedure MonthAggAdd(var A: TMonthAggArray; var N: integer;
  const Key: string; const DistKmA, LitersMlA, CentsA: Int64);
var
  i: integer;
begin
  for i := 0 to N - 1 do
    if A[i].Month = Key then
    begin
      A[i].DistKm += DistKmA;
      A[i].LitersMl += LitersMlA;
      A[i].TotalCents += CentsA;
      Exit;
    end;

  // append
  SetLength(A, N + 1);
  A[N].Month := Key;
  A[N].DistKm := DistKmA;
  A[N].LitersMl := LitersMlA;
  A[N].TotalCents := CentsA;
  Inc(N);
end;

procedure MonthAggSort(var A: TMonthAggArray; const N: integer);
var
  i, j: integer;
  tmp: TMonthAgg;
begin
  for i := 0 to N - 2 do
    for j := i + 1 to N - 1 do
      if A[j].Month < A[i].Month then
      begin
        tmp := A[i]; A[i] := A[j]; A[j] := tmp;
      end;
end;

type
  TYearAgg = record
    Year: string;        // 'YYYY'
    DistKm: Int64;
    LitersMl: Int64;
    TotalCents: Int64;
  end;
  TYearAggArray = array of TYearAgg;

function YearKeyFromMonthKey(const MonthKey: string): string;
begin
  if Length(MonthKey) >= 4 then Result := Copy(MonthKey, 1, 4) else Result := '????';
end;

procedure YearAggAdd(var A: TYearAggArray; var N: integer;
  const Key: string; const DistKmA, LitersMlA, CentsA: Int64);
var
  i: integer;
begin
  for i := 0 to N - 1 do
    if A[i].Year = Key then
    begin
      A[i].DistKm += DistKmA;
      A[i].LitersMl += LitersMlA;
      A[i].TotalCents += CentsA;
      Exit;
    end;

  SetLength(A, N + 1);
  A[N].Year := Key;
  A[N].DistKm := DistKmA;
  A[N].LitersMl := LitersMlA;
  A[N].TotalCents := CentsA;
  Inc(N);
end;

procedure YearAggSort(var A: TYearAggArray; const N: integer);
var
  i, j: integer;
  tmp: TYearAgg;
begin
  for i := 0 to N - 2 do
    for j := i + 1 to N - 1 do
      if A[j].Year < A[i].Year then
      begin
        tmp := A[i]; A[i] := A[j]; A[j] := tmp;
      end;
end;

type
  TStatsHeader = record
    TotalFuelups: Int64;
    FullFuelups: Int64;
    MinDt: string;
    MaxDt: string;
    TotalCentsAll: Int64;
    EffFromIso: string;
    EffToExclIso: string;
  end;

  TCycleRow = record
    Idx: integer;
    DistKm: Int64;
    LitersMl: Int64;
    TotalCents: Int64;
  end;
  TCycleRowArray = array of TCycleRow;

  TStatsCollected = record
    H: TStatsHeader;

    CyclesCount: integer;
    SumDistKm: Int64;
    SumLitersMl: Int64;
    SumTotalCents: Int64;

    Cycles: TCycleRowArray;   // nur befuellt wenn keine Monats/Jahresaggregation aktiv ist
    Months: TMonthAggArray;   // befuellt bei Monthly=True oder Yearly=True
    MonthN: integer;
  end;

function AvgLPer100_x100(const LitersMlA: Int64; const DistKmA: Int64): Int64;
begin
  if DistKmA <= 0 then Exit(0);
  // avg_x100 = (liters_ml * 10) / dist_km  (mit Rundung)
  Result := (LitersMlA * 10 + (DistKmA div 2)) div DistKmA;
end;

procedure CollectFuelupStats(
  const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const Yearly: boolean;
  out R: TStatsCollected);
var
  Conn: TSQLite3Connection;
  Tran: TSQLTransaction;
  Q: TSQLQuery;
  CollectMonths: boolean;

  HaveStartFull: boolean;
  StartOdo: integer;
  AccLitersMl: Int64;
  AccTotalCents: Int64;

  Odo, IsFull: integer;
  CarId, CurrentCarId: integer;
  MissedPrev: integer;
  LitersMl: Int64;
  TotalCents: Int64;
  DistKm: integer;
  CycleLitersMl: Int64;
  CycleTotalCents: Int64;

  EndDtIso: string;
  MKey: string;
begin
  CollectMonths := Monthly or Yearly;

  FillChar(R, SizeOf(R), 0);
  SetLength(R.Cycles, 0);
  SetLength(R.Months, 0);
  R.MonthN := 0;

  Conn := TSQLite3Connection.Create(nil);
  Tran := TSQLTransaction.Create(nil);
  Q := TSQLQuery.Create(nil);
  try
    Conn.DatabaseName := DbPath;
    Conn.Transaction := Tran;

    Q.DataBase := Conn;
    Q.Transaction := Tran;

    Conn.Open;
    Tran.StartTransaction;

    R.H.EffFromIso := PeriodFromIso;
    R.H.EffToExclIso := PeriodToExclIso;

    ResolvePeriodBounds(Q, PeriodEnabled, R.H.EffFromIso, R.H.EffToExclIso, FromProvided, ToProvided);
    Dbg('Stats: period_enabled=' + IntToStr(ord(PeriodEnabled)) +
        ' from=' + R.H.EffFromIso + ' to_excl=' + R.H.EffToExclIso +
        ' monthly=' + IntToStr(ord(Monthly)) +
        ' yearly=' + IntToStr(ord(Yearly)));

    // ------------------------------------------------------------
    // 1) Kopfzeilen-Infos (Anzahl/Zeitraum)
    Q.SQL.Text :=
      'SELECT ' +
      '  COUNT(*) AS cnt, ' +
      '  SUM(CASE WHEN is_full_tank = 1 THEN 1 ELSE 0 END) AS full_cnt, ' +
      '  MIN(fueled_at) AS min_dt, ' +
      '  MAX(fueled_at) AS max_dt, ' +
      '  SUM(total_cents) AS total_cents ' +
      'FROM fuelups ';

    if PeriodEnabled and ((R.H.EffFromIso <> '') or (R.H.EffToExclIso <> '')) then
    begin
      Q.SQL.Text := Q.SQL.Text + 'WHERE 1=1 ';
      if R.H.EffFromIso <> '' then Q.SQL.Text := Q.SQL.Text + 'AND fueled_at >= :from ';
      if R.H.EffToExclIso <> '' then Q.SQL.Text := Q.SQL.Text + 'AND fueled_at < :to_excl ';
    end;

    Q.SQL.Text := Q.SQL.Text + ';';

    ApplyPeriodWhere(Q, PeriodEnabled, R.H.EffFromIso, R.H.EffToExclIso);
    Q.Open;

    R.H.TotalFuelups := FieldInt64OrZero(Q, 'cnt');
    DbgEffectivePeriod(PeriodEnabled, FromProvided, ToProvided, R.H.EffFromIso, R.H.EffToExclIso, R.H.TotalFuelups);
    R.H.FullFuelups := FieldInt64OrZero(Q, 'full_cnt');
    R.H.MinDt := Q.FieldByName('min_dt').AsString;
    R.H.MaxDt := Q.FieldByName('max_dt').AsString;
    R.H.TotalCentsAll := FieldInt64OrZero(Q, 'total_cents');

    Q.Close;

    // ------------------------------------------------------------
    // 2) Zyklus-Iteration
    Q.SQL.Text :=
      'SELECT id, car_id, fueled_at, odometer_km, liters_ml, is_full_tank, total_cents, missed_previous ' +
      'FROM fuelups ';

    if PeriodEnabled and ((R.H.EffFromIso <> '') or (R.H.EffToExclIso <> '')) then
    begin
      Q.SQL.Text := Q.SQL.Text + 'WHERE 1=1 ';
      if R.H.EffFromIso <> '' then Q.SQL.Text := Q.SQL.Text + 'AND fueled_at >= :from ';
      if R.H.EffToExclIso <> '' then Q.SQL.Text := Q.SQL.Text + 'AND fueled_at < :to_excl ';
    end;

    Q.SQL.Text := Q.SQL.Text + 'ORDER BY car_id ASC, odometer_km ASC, fueled_at ASC, id ASC;';
    ApplyPeriodWhere(Q, PeriodEnabled, R.H.EffFromIso, R.H.EffToExclIso);
    Q.Open;

    HaveStartFull := False;
    StartOdo := 0;
    AccLitersMl := 0;
    AccTotalCents := 0;
    CurrentCarId := 0;

    R.CyclesCount := 0;
    R.SumDistKm := 0;
    R.SumLitersMl := 0;
    R.SumTotalCents := 0;

    while not Q.EOF do
    begin
      // v4: pro Car getrennte Zeitachse (Safety, auch wenn aktuell Default-Car=1)
      CarId := Q.FieldByName('car_id').AsInteger;
      MissedPrev := Q.FieldByName('missed_previous').AsInteger;

      // Car-Wechsel: Collector resetten, damit keine Auto-uebergreifenden Zyklen entstehen
      if (CurrentCarId = 0) then
        CurrentCarId := CarId
      else if CarId <> CurrentCarId then
      begin
        CurrentCarId := CarId;
        HaveStartFull := False;
        StartOdo := 0;
        AccLitersMl := 0;
        AccTotalCents := 0;
      end;

      // User-bestaetigte Luecke: reset, bevor der Datensatz verarbeitet wird
      if MissedPrev = 1 then
      begin
        HaveStartFull := False;
        StartOdo := 0;
        AccLitersMl := 0;
        AccTotalCents := 0;
      end;

      Odo := Q.FieldByName('odometer_km').AsInteger;
      LitersMl := Q.FieldByName('liters_ml').AsLargeInt;
      IsFull := Q.FieldByName('is_full_tank').AsInteger;
      TotalCents := Q.FieldByName('total_cents').AsLargeInt;

      if IsFull = 1 then
      begin
        if not HaveStartFull then
        begin
          StartOdo := Odo;
          HaveStartFull := True;
          AccLitersMl := 0;
          AccTotalCents := 0;
        end
        else
        begin
          DistKm := Odo - StartOdo;

          CycleLitersMl := AccLitersMl + LitersMl;
          CycleTotalCents := AccTotalCents + TotalCents;

          if DistKm > 0 then
          begin
            Inc(R.CyclesCount);

            if CollectMonths then
            begin
              EndDtIso := Q.FieldByName('fueled_at').AsString;
              MKey := MonthKeyFromIso(EndDtIso);
              MonthAggAdd(R.Months, R.MonthN, MKey, DistKm, CycleLitersMl, CycleTotalCents);
            end
            else
            begin
              SetLength(R.Cycles, Length(R.Cycles) + 1);
              R.Cycles[High(R.Cycles)].Idx := R.CyclesCount;
              R.Cycles[High(R.Cycles)].DistKm := DistKm;
              R.Cycles[High(R.Cycles)].LitersMl := CycleLitersMl;
              R.Cycles[High(R.Cycles)].TotalCents := CycleTotalCents;
            end;

            R.SumDistKm += DistKm;
            R.SumLitersMl += CycleLitersMl;
            R.SumTotalCents += CycleTotalCents;
          end;

          StartOdo := Odo;
          AccLitersMl := 0;
          AccTotalCents := 0;
        end;
      end
      else
      begin
        if HaveStartFull then
        begin
          AccLitersMl += LitersMl;
          AccTotalCents += TotalCents;
        end;
      end;

      Q.Next;
    end;

    Q.Close;
    Tran.Commit;
  finally
    Q.Free;
    Tran.Free;
    Conn.Free;
  end;
end;

procedure RenderFuelupStatsText(const C: TStatsCollected; const Monthly: boolean; const Yearly: boolean);
var
  i: integer;
  YearN: integer;
  YKey: string;

  LitersTotal: double;
  AvgLPer100: double;
  Fs: TFormatSettings;

  T: TTable;
  TM: TTable;
  TY: TTable;
  MonthsSorted: TMonthAggArray;
  Years: TYearAggArray;

  function SafeStr(const S: string): string;
  begin
    if S = '' then Result := '-' else Result := S;
  end;

  function FormatMlAsLiter(const V: Int64): string;
  begin
    Result := FmtLiterFromMl(V);
  end;

  function FormatCentsAsEuro(const Cents: Int64): string;
  begin
    Result := Format('%d,%.2d', [Cents div 100, Abs(Cents mod 100)]);
  end;

  function FormatConsumption(const LitersMl: Int64; const DistKm: Int64): string;
  var
    L: double;
    V: double;
  begin
    if DistKm <= 0 then
      Exit('0.00');
    L := LitersMl / 1000.0;
    V := (L / DistKm) * 100.0;
    Result := FormatFloat('0.00', V, Fs);
  end;

begin
  if Yearly then
  begin
    WriteLn('Statistik (fuelups) - Jahresuebersicht');
    WriteLn('Zeitraum: ', SafeStr(C.H.MinDt), ' ... ', SafeStr(C.H.MaxDt));
    WriteLn('Tankvorgaenge: ', C.H.TotalFuelups, '  |  Volltank: ', C.H.FullFuelups);

    if C.H.TotalFuelups = 0 then
    begin
      WriteLn('Keine Tankvorgaenge vorhanden.');
      Exit;
    end;

    YearN := 0;
    SetLength(Years, 0);

    for i := 0 to C.MonthN - 1 do
    begin
      YKey := YearKeyFromMonthKey(C.Months[i].Month);
      YearAggAdd(Years, YearN, YKey, C.Months[i].DistKm, C.Months[i].LitersMl, C.Months[i].TotalCents);
    end;

    YearAggSort(Years, YearN);

    if YearN = 0 then
    begin
      WriteLn('Jahre: 0');
      WriteLn('Hinweis: Es wurden keine gueltigen Volltank-Zyklen gefunden.');
      Exit;
    end;

    TY := TTable.Create;
    try
      TY.AddCol('Jahr', taLeft);
      TY.AddCol('km', taRight);
      TY.AddCol('Liter', taRight);
      TY.AddCol('Ø L/100km', taRight);
      TY.AddCol('Kosten (EUR)', taRight);

      for i := 0 to YearN - 1 do
        TY.AddRow([
          Years[i].Year,
          IntToStr(Years[i].DistKm),
          FormatMlAsLiter(Years[i].LitersMl),
          FmtScaledInt(AvgLPer100_x100(Years[i].LitersMl, Years[i].DistKm), 2, ''),
          FormatCentsAsEuro(Years[i].TotalCents)
        ]);

      TY.AddSep;
      TY.AddRow([
        'Σ',
        IntToStr(C.SumDistKm),
        FormatMlAsLiter(C.SumLitersMl),
        FmtScaledInt(AvgLPer100_x100(C.SumLitersMl, C.SumDistKm), 2, ''),
        FormatCentsAsEuro(C.SumTotalCents)
      ]);

      WriteLn('');
      TY.Write;
    finally
      TY.Free;
    end;

    WriteLn('');
    WriteLn('Jahre: ', YearN);
    WriteLn('Strecke: ', C.SumDistKm, ' km');
    WriteLn('Kraftstoff: ', FormatMlAsLiter(C.SumLitersMl));
    WriteLn('Ø Verbrauch: ', FmtScaledInt(AvgLPer100_x100(C.SumLitersMl, C.SumDistKm), 2, ''), ' L/100 km');
    WriteLn('Kosten gesamt (nur gueltige Zyklen): ', FormatCentsAsEuro(C.SumTotalCents), ' EUR');
    Exit;
  end;

  Fs := DefaultFormatSettings;
  Fs.ThousandSeparator := '.';
  Fs.DecimalSeparator := ',';

  WriteLn('Statistik (fuelups) - Volltank-Zyklen');
  WriteLn('Zeitraum: ', SafeStr(C.H.MinDt), ' ... ', SafeStr(C.H.MaxDt));
  WriteLn('Tankvorgänge: ', C.H.TotalFuelups, '  |  Volltank: ', C.H.FullFuelups);

  if C.H.TotalFuelups = 0 then
  begin
    WriteLn('Keine Tankvorgänge vorhanden.');
    Exit;
  end;

  if C.CyclesCount = 0 then
  begin
    WriteLn('Zyklen: 0');
    WriteLn('Hinweis: Es wurden keine gültigen Volltank-Zyklen gefunden.');
    Exit;
  end;

  if (not Monthly) and (Length(C.Cycles) > 0) then
  begin
    T := TTable.Create;
    try
      T.AddCol('Zyklus', taRight);
      T.AddCol('km', taRight);
      T.AddCol('Liter', taRight);
      T.AddCol('Ø L/100km', taRight);
      T.AddCol('Kosten (EUR)', taRight);

      for i := 0 to High(C.Cycles) do
        T.AddRow([
          IntToStr(C.Cycles[i].Idx),
          IntToStr(C.Cycles[i].DistKm),
          FormatMlAsLiter(C.Cycles[i].LitersMl),
          FormatConsumption(C.Cycles[i].LitersMl, C.Cycles[i].DistKm),
          FormatCentsAsEuro(C.Cycles[i].TotalCents)
        ]);

      T.AddSep;
      T.AddRow([
        'Σ',
        IntToStr(C.SumDistKm),
        FormatMlAsLiter(C.SumLitersMl),
        FormatConsumption(C.SumLitersMl, C.SumDistKm),
        FormatCentsAsEuro(C.SumTotalCents)
      ]);

      WriteLn('');
      T.Write;
    finally
      T.Free;
    end;
  end;

  if Monthly and (C.MonthN > 0) then
  begin
    SetLength(MonthsSorted, C.MonthN);
    for i := 0 to C.MonthN - 1 do
      MonthsSorted[i] := C.Months[i];
    MonthAggSort(MonthsSorted, C.MonthN);

    WriteLn('');
    WriteLn('Monatsstatistik (aus gültigen Volltank-Zyklen)');

    TM := TTable.Create;
    try
      TM.AddCol('Monat', taLeft);
      TM.AddCol('km', taRight);
      TM.AddCol('Liter', taRight);
      TM.AddCol('Ø L/100km', taRight);
      TM.AddCol('Kosten (EUR)', taRight);

      for i := 0 to C.MonthN - 1 do
        TM.AddRow([
          MonthsSorted[i].Month,
          IntToStr(MonthsSorted[i].DistKm),
          FormatMlAsLiter(MonthsSorted[i].LitersMl),
          FormatConsumption(MonthsSorted[i].LitersMl, MonthsSorted[i].DistKm),
          FormatCentsAsEuro(MonthsSorted[i].TotalCents)
        ]);

      TM.Write;
    finally
      TM.Free;
    end;
  end;

  LitersTotal := C.SumLitersMl / 1000.0;

  if C.SumDistKm > 0 then
    AvgLPer100 := (LitersTotal / C.SumDistKm) * 100.0
  else
    AvgLPer100 := 0.0;

  WriteLn('Zyklen: ', C.CyclesCount);
  WriteLn('Strecke: ', C.SumDistKm, ' km');
  WriteLn('Kraftstoff: ', FormatMlAsLiter(C.SumLitersMl));
  WriteLn('Ø Verbrauch: ', FormatFloat('0.00', AvgLPer100, Fs), ' L/100 km');

  // Kosten-Klarheit: SQL-Summe (alle Tankungen) vs. Zyklus-Summe (nur gültige Zyklen)
  if C.H.TotalCentsAll = C.SumTotalCents then
    WriteLn('Kosten gesamt: ', FormatCentsAsEuro(C.SumTotalCents), ' EUR')
  else
  begin
    WriteLn('Kosten gesamt (alle Tankungen): ', FormatCentsAsEuro(C.H.TotalCentsAll), ' EUR');
    WriteLn('Kosten gesamt (nur gültige Zyklen): ', FormatCentsAsEuro(C.SumTotalCents), ' EUR');
  end;
end;

procedure RenderFuelupStatsCsv(const R: TStatsCollected; const Monthly: boolean);
var
  i: integer;
  MonthsSorted: TMonthAggArray;
begin
  if Monthly then
  begin
    // Kopfzeile immer
    WriteLn('month,dist_km,liters_ml,avg_l_per_100km_x100,total_cents');

    if R.MonthN <= 0 then Exit;

    // stabile Reihenfolge
    SetLength(MonthsSorted, R.MonthN);
    for i := 0 to R.MonthN - 1 do
      MonthsSorted[i] := R.Months[i];
    MonthAggSort(MonthsSorted, R.MonthN);

    for i := 0 to R.MonthN - 1 do
      WriteLn(CsvJoin([
        CsvTokenStrict(MonthsSorted[i].Month),
        IntToStr(MonthsSorted[i].DistKm),
        IntToStr(MonthsSorted[i].LitersMl),
        IntToStr(AvgLPer100_x100(MonthsSorted[i].LitersMl, MonthsSorted[i].DistKm)),
        IntToStr(MonthsSorted[i].TotalCents)
      ]));
  end
  else
  begin
    WriteLn('idx,dist_km,liters_ml,avg_l_per_100km_x100,total_cents');

    if Length(R.Cycles) = 0 then Exit;

    for i := 0 to High(R.Cycles) do
      WriteLn(CsvJoin([
        IntToStr(R.Cycles[i].Idx),
        IntToStr(R.Cycles[i].DistKm),
        IntToStr(R.Cycles[i].LitersMl),
        IntToStr(AvgLPer100_x100(R.Cycles[i].LitersMl, R.Cycles[i].DistKm)),
        IntToStr(R.Cycles[i].TotalCents)
      ]));
  end;
end;

type
  TJsonWriter = record
    Pretty: boolean;
    Ind: integer;
    procedure W(const S: string);
    procedure NL;
    procedure SP;
    procedure IndentInc;
    procedure IndentDec;
    procedure IndentWrite;
  end;

procedure TJsonWriter.W(const S: string);
begin
  Write(S);
end;

procedure TJsonWriter.NL;
begin
  if Pretty then WriteLn;
end;

procedure TJsonWriter.SP;
begin
  if Pretty then Write(' ');
end;

procedure TJsonWriter.IndentInc;
begin
  Inc(Ind);
end;

procedure TJsonWriter.IndentDec;
begin
  if Ind > 0 then Dec(Ind);
end;

procedure TJsonWriter.IndentWrite;
var
  i: integer;
begin
  if not Pretty then Exit;
  for i := 1 to Ind * 2 do Write(' ');
end;

function JsonEscape(const S: string): string;
var
  k: integer;
  ch: char;
begin
  Result := '';
  for k := 1 to Length(S) do
  begin
    ch := S[k];
    case ch of
      '\': Result += '\\';
      '"': Result += '\"';
      #8: Result += '\b';
      #9: Result += '\t';
      #10: Result += '\n';
      #12: Result += '\f';
      #13: Result += '\r';
    else
      Result += ch;
    end;
  end;
end;

procedure RenderFuelupStatsJson(const R: TStatsCollected; const Monthly: boolean; const Yearly: boolean; const Pretty: boolean);
var
  J: TJsonWriter;
  i: integer;
  YearN: integer;
  YKey: string;
  MonthsSorted: TMonthAggArray;
  Years: TYearAggArray;
begin
  J.Pretty := Pretty;
  J.Ind := 0;

  if Yearly then
  begin
    YearN := 0;
    SetLength(Years, 0);
    for i := 0 to R.MonthN - 1 do
    begin
      YKey := YearKeyFromMonthKey(R.Months[i].Month);
      YearAggAdd(Years, YearN, YKey, R.Months[i].DistKm, R.Months[i].LitersMl, R.Months[i].TotalCents);
    end;
    YearAggSort(Years, YearN);

    J.W('{'); J.NL;
    J.IndentInc;

    J.IndentWrite; J.W('"kind":'); J.SP; J.W('"fuelups_yearly",'); J.NL;

    J.IndentWrite; J.W('"period":'); J.SP; J.W('{"from":'); J.SP;
    J.W('"'); J.W(JsonEscape(R.H.MinDt)); J.W('"'); J.W(',');
    J.SP; J.W('"to":'); J.SP; J.W('"'); J.W(JsonEscape(R.H.MaxDt)); J.W('"');
    J.W('},'); J.NL;

    J.IndentWrite; J.W('"fuelups_total":'); J.SP; J.W(IntToStr(R.H.TotalFuelups)); J.W(','); J.NL;
    J.IndentWrite; J.W('"fuelups_full":'); J.SP; J.W(IntToStr(R.H.FullFuelups)); J.W(','); J.NL;

    J.IndentWrite; J.W('"rows":'); J.SP; J.W('['); J.NL;
    J.IndentInc;
    for i := 0 to YearN - 1 do
    begin
      J.IndentWrite;
      J.W('{"year":"'); J.W(JsonEscape(Years[i].Year));
      J.W('","dist_km":'); J.W(IntToStr(Years[i].DistKm));
      J.W(',"liters_ml":'); J.W(IntToStr(Years[i].LitersMl));
      J.W(',"avg_l_per_100km_x100":'); J.W(IntToStr(AvgLPer100_x100(Years[i].LitersMl, Years[i].DistKm)));
      J.W(',"total_cents":'); J.W(IntToStr(Years[i].TotalCents));
      J.W('}');
      if i < YearN - 1 then J.W(',');
      J.NL;
    end;
    J.IndentDec;
    J.IndentWrite; J.W(']'); J.NL;

    J.IndentDec;
    J.W('}'); J.NL;
    Exit;
  end;

  if Monthly then
  begin
    SetLength(MonthsSorted, R.MonthN);
    for i := 0 to R.MonthN - 1 do
      MonthsSorted[i] := R.Months[i];
    MonthAggSort(MonthsSorted, R.MonthN);

    J.W('{'); J.NL;
    J.IndentInc;

    J.IndentWrite; J.W('"kind":'); J.SP; J.W('"fuelups_monthly",'); J.NL;

    J.IndentWrite; J.W('"period":'); J.SP; J.W('{"from":'); J.SP;
    J.W('"'); J.W(JsonEscape(R.H.MinDt)); J.W('"'); J.W(',');
    J.SP; J.W('"to":'); J.SP; J.W('"'); J.W(JsonEscape(R.H.MaxDt)); J.W('"');
    J.W('},'); J.NL;

    J.IndentWrite; J.W('"fuelups_total":'); J.SP; J.W(IntToStr(R.H.TotalFuelups)); J.W(','); J.NL;
    J.IndentWrite; J.W('"fuelups_full":'); J.SP; J.W(IntToStr(R.H.FullFuelups)); J.W(','); J.NL;

    J.IndentWrite; J.W('"rows":'); J.SP; J.W('['); J.NL;
    J.IndentInc;

    for i := 0 to R.MonthN - 1 do
    begin
      J.IndentWrite;
      J.W('{"month":"'); J.W(JsonEscape(MonthsSorted[i].Month));
      J.W('","dist_km":'); J.W(IntToStr(MonthsSorted[i].DistKm));
      J.W(',"liters_ml":'); J.W(IntToStr(MonthsSorted[i].LitersMl));
      J.W(',"avg_l_per_100km_x100":'); J.W(IntToStr(AvgLPer100_x100(MonthsSorted[i].LitersMl, MonthsSorted[i].DistKm)));
      J.W(',"total_cents":'); J.W(IntToStr(MonthsSorted[i].TotalCents));
      J.W('}');
      if i < R.MonthN - 1 then J.W(',');
      J.NL;
    end;

    J.IndentDec;
    J.IndentWrite; J.W(']'); J.NL;

    J.IndentDec;
    J.W('}'); J.NL;
  end
  else
  begin
    J.W('{'); J.NL;
    J.IndentInc;

    J.IndentWrite; J.W('"kind":'); J.SP; J.W('"fuelups_full_tank_cycles",'); J.NL;

    J.IndentWrite; J.W('"period":'); J.SP; J.W('{"from":'); J.SP;
    J.W('"'); J.W(JsonEscape(R.H.MinDt)); J.W('"'); J.W(',');
    J.SP; J.W('"to":'); J.SP; J.W('"'); J.W(JsonEscape(R.H.MaxDt)); J.W('"');
    J.W('},'); J.NL;

    J.IndentWrite; J.W('"fuelups_total":'); J.SP; J.W(IntToStr(R.H.TotalFuelups)); J.W(','); J.NL;
    J.IndentWrite; J.W('"fuelups_full":'); J.SP; J.W(IntToStr(R.H.FullFuelups)); J.W(','); J.NL;

    J.IndentWrite; J.W('"cycles":'); J.SP; J.W('['); J.NL;
    J.IndentInc;

    for i := 0 to High(R.Cycles) do
    begin
      J.IndentWrite;
      J.W('{"idx":'); J.SP; J.W(IntToStr(R.Cycles[i].Idx));
      J.W(',"dist_km":'); J.SP; J.W(IntToStr(R.Cycles[i].DistKm));
      J.W(',"liters_ml":'); J.SP; J.W(IntToStr(R.Cycles[i].LitersMl));
      J.W(',"avg_l_per_100km_x100":'); J.SP; J.W(IntToStr(AvgLPer100_x100(R.Cycles[i].LitersMl, R.Cycles[i].DistKm)));
      J.W(',"total_cents":'); J.SP; J.W(IntToStr(R.Cycles[i].TotalCents));
      J.W('}');
      if i < High(R.Cycles) then J.W(',');
      J.NL;
    end;

    J.IndentDec;
    J.IndentWrite; J.W('],'); J.NL;

    J.IndentWrite; J.W('"sum":'); J.SP; J.W('{'); J.NL;
    J.IndentInc;

    J.IndentWrite; J.W('"cycles":'); J.SP; J.W(IntToStr(R.CyclesCount)); J.W(','); J.NL;
    J.IndentWrite; J.W('"dist_km":'); J.SP; J.W(IntToStr(R.SumDistKm)); J.W(','); J.NL;
    J.IndentWrite; J.W('"liters_ml":'); J.SP; J.W(IntToStr(R.SumLitersMl)); J.W(','); J.NL;
    J.IndentWrite; J.W('"avg_l_per_100km_x100":'); J.SP; J.W(IntToStr(AvgLPer100_x100(R.SumLitersMl, R.SumDistKm))); J.W(','); J.NL;
    J.IndentWrite; J.W('"total_cents_all":'); J.SP; J.W(IntToStr(R.H.TotalCentsAll)); J.W(','); J.NL;
    J.IndentWrite; J.W('"total_cents_cycles":'); J.SP; J.W(IntToStr(R.SumTotalCents)); J.NL;

    J.IndentDec;
    J.IndentWrite; J.W('}'); J.NL;

    J.IndentDec;
    J.W('}'); J.NL;
  end;
end;

procedure ShowFuelupStats(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const Yearly: boolean); overload;
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, Monthly, Yearly, R);
  RenderFuelupStatsText(R, Monthly, Yearly);
end;

procedure ShowFuelupStats(const DbPath: string); overload;
begin
  ShowFuelupStats(DbPath, False, '', '', False, False, False, False);
end;

procedure ShowFuelupStatsCsv(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean); overload;
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, Monthly, False, R);
  RenderFuelupStatsCsv(R, Monthly);
end;

procedure ShowFuelupStatsCsv(const DbPath: string); overload;
begin
  ShowFuelupStatsCsv(DbPath, False, '', '', False, False, False);
end;

procedure ShowFuelupStatsJson(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean;
  const Yearly: boolean;
  const Pretty: boolean); overload;
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, Monthly, Yearly, R);
  RenderFuelupStatsJson(R, Monthly, Yearly, Pretty);
end;

procedure ShowFuelupStatsJson(const DbPath: string); overload;
begin
  ShowFuelupStatsJson(DbPath, False, '', '', False, False, False, False, False);
end;

procedure RenderFuelupDashboardText(const C: TStatsCollected; const Monthly: boolean);
const
  W = 56;
  MAX_ROWS = 8;
var
  AvgX100: Int64;
  i: Integer;

  MonthsSorted: TMonthAggArray;
  MaxCents: Int64;

  function SafeStr(const S: string): string;
  begin
    if S = '' then Result := '-' else Result := S;
  end;

  function PeriodLine: string;
  begin
    Result := SafeStr(C.H.MinDt) + ' ... ' + SafeStr(C.H.MaxDt);
  end;

begin
  BoxTop(W);
  BoxLine(W, 'BETANKUNGEN – STATUS');
  BoxSep(W);

  BoxKV(W, 'Zeitraum', PeriodLine);
  BoxKV(W, 'Tankvorgaenge', IntToStr(C.H.TotalFuelups) + ' | Volltank: ' + IntToStr(C.H.FullFuelups));

  if C.H.TotalFuelups = 0 then
  begin
    BoxSep(W);
    BoxLine(W, 'Keine Tankvorgaenge vorhanden.');
    BoxBottom(W);
    Exit;
  end;

  BoxKV(W, 'Zyklen', IntToStr(C.CyclesCount));

  if C.CyclesCount = 0 then
  begin
    BoxSep(W);
    BoxLine(W, 'Hinweis: Keine gueltigen Volltank-Zyklen gefunden.');
    BoxBottom(W);
    Exit;
  end;

  AvgX100 := AvgLPer100_x100(C.SumLitersMl, C.SumDistKm);

  BoxKV(W, 'Gesamt-km', IntToStr(C.SumDistKm));
  BoxKV(W, 'Gesamt-Liter', FmtLiterFromMl(C.SumLitersMl));
  BoxKV(W, 'Ø Verbrauch', FmtScaledInt(AvgX100, 2, 'L/100km'));
  BoxKV(W, 'Kosten (Zyklen)', FmtEuroFromCents(C.SumTotalCents));
  BoxKV(W, 'Kosten (alle)', FmtEuroFromCents(C.H.TotalCentsAll));

  // ---------------- Monatsblock (mit farbigen Kosten-Balken)
  if Monthly and (C.MonthN > 0) then
  begin
    BoxSep(W);
    BoxLine(W, 'Monatskosten');

    MonthsSorted := Copy(C.Months, 0, C.MonthN);
    MonthAggSort(MonthsSorted, Length(MonthsSorted));

    MaxCents := 0;
    for i := 0 to High(MonthsSorted) do
      if MonthsSorted[i].TotalCents > MaxCents then
        MaxCents := MonthsSorted[i].TotalCents;

    for i := 0 to High(MonthsSorted) do
    begin
      if i >= MAX_ROWS then
      begin
        BoxLine(W, '... (' + IntToStr(Length(MonthsSorted) - MAX_ROWS) + ' weitere)');
        Break;
      end;

      BoxLineAnsi(W,
        MonthsSorted[i].Month + '  ' +
        RenderCostBar(MonthsSorted[i].TotalCents, MaxCents) + '  ' +
        FmtEuroFromCents(MonthsSorted[i].TotalCents)
      );
    end;
  end;

  BoxBottom(W);
end;

procedure ShowFuelupDashboard(const DbPath: string);
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, False, '', '', False, False, False, False, R);
  RenderFuelupDashboardText(R, False);
end;

procedure ShowFuelupDashboard(const DbPath: string;
  const PeriodEnabled: boolean;
  const PeriodFromIso, PeriodToExclIso: string;
  const FromProvided, ToProvided: boolean;
  const Monthly: boolean);
var
  R: TStatsCollected;
begin
  CollectFuelupStats(DbPath, PeriodEnabled, PeriodFromIso, PeriodToExclIso, FromProvided, ToProvided, Monthly, False, R);
  RenderFuelupDashboardText(R, Monthly);
end;

end.

````

## Datei: `units/u_table.pas`

````pascal
{
  u_table.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-01-17
  UPDATED: 2026-02-17
  AUTHOR : Christof Kempinski
  Leichter Tabellen- und Textlayout-Renderer fuer die CLI.

  Verantwortlichkeiten:
  - Liefert Padding- und Cutting-Helfer fuer Textzellen.
  - Beruecksichtigt UTF-8-Sichtbreite fuer stabiles Layout.
  - Stellt mit TTable einen einfachen Tabellen-Builder bereit.

  Design-Entscheidungen:
  - Unicode-sicheres Cut/Padding anhand sichtbarer Zeichenlaenge.
  - Keine Farblogik: Ausgabe bleibt neutral und wiederverwendbar.
  - Kleine API fuer geringe Kopplung zu Fachmodulen.

  Verwendung:
  - PadR/PadL/Cut fuer Einzelzellen.
  - TTable fuer mehrzeilige, spaltenbasierte Konsolenausgabe.
  ---------------------------------------------------------------------------
}

unit u_table;

{$mode objfpc}{$H+}

interface

uses SysUtils,
     Math;

// Rechts auffuellen (linksbuendig darstellen).
function PadR(const S: string; W: Integer): string;
// Links auffuellen (rechtsbuendig darstellen).
function PadL(const S: string; W: Integer): string;
// Sichtbar auf Breite W kuerzen (mit Ellipse, falls noetig).
function Cut(const S: string; W: Integer): string;

type
  // Horizontale Ausrichtung je Spalte.
  TTextAlign = (taLeft, taRight);

  // Minimaler Tabellenrenderer fuer CLI-Listen/Reports.
  TTable = class
  private
    type
      TCol = record
        Title: string;
        Align: TTextAlign;
        Width: Integer;
      end;
      TRowKind = (rkRow, rkSep);
      TRow = record
        Kind: TRowKind;
        Cells: array of string;
      end;
    var
      FCols: array of TCol;
      FRows: array of TRow;
    procedure EnsureColCount(const Count: Integer);
    procedure UpdateWidths(const Cells: array of string);
    function PadCell(const S: string; W: Integer; Align: TTextAlign): string;
    function BuildLine(const SepChar: Char): string;
  public
    // Fuegt eine Spalte mit Titel und Ausrichtung hinzu.
    procedure AddCol(const Title: string; const Align: TTextAlign);
    // Fuegt eine Datenzeile hinzu (fehlende Zellen werden leer aufgefuellt).
    procedure AddRow(const Cells: array of string);
    // Fuegt eine horizontale Trennzeile ein.
    procedure AddSep;
    // Rendert die Tabelle auf STDOUT.
    procedure Write;
  end;

implementation

// ---------------------------------------------------------------------------
// UTF-8 helpers (sichtbare Laenge / Cut nach Codepoints)
//
// Warum:
// - Length(S) zaehlt Bytes, nicht sichtbare Zeichen.
// - Unicode-Zeichen wie '–', 'Ø', '…' sind mehrbyte -> Layout verrutscht.
// - Wir brauchen fuer Console-Layouts eine "visible width" in Codepoints.
//
// Hinweis:
// - Das ist kein vollstaendiger East-Asian-Width-Algorithmus (CJK double-width),
//   aber fuer unsere Zwecke (deutsch/latin, Boxdrawing, Ellipsis) ausreichend.
// ---------------------------------------------------------------------------

function Utf8CharLen(const B: Byte): Integer;
begin
  if (B and $80) = 0 then Exit(1);         // 0xxxxxxx
  if (B and $E0) = $C0 then Exit(2);       // 110xxxxx
  if (B and $F0) = $E0 then Exit(3);       // 1110xxxx
  if (B and $F8) = $F0 then Exit(4);       // 11110xxx
  Result := 1;                              // fallback
end;

function Utf8VisibleLen(const S: string): Integer;
var
  I, N, Step: Integer;
begin
  Result := 0;
  I := 1;
  N := Length(S);
  while I <= N do
  begin
    Step := Utf8CharLen(Byte(S[I]));
    Inc(I, Step);
    Inc(Result);
  end;
end;

function Utf8Cut(const S: string; W: Integer): string;
var
  I, N, Step, Count, CutPos: Integer;
begin
  if W <= 0 then Exit('');
  N := Length(S);
  I := 1;
  Count := 0;
  CutPos := 1;

  while (I <= N) and (Count < W) do
  begin
    Step := Utf8CharLen(Byte(S[I]));
    Inc(Count);
    Inc(I, Step);
    CutPos := I;
  end;

  // CutPos zeigt auf das Byte direkt nach dem letzten aufgenommenen Codepoint
  Result := Copy(S, 1, CutPos - 1);
end;

function Cut(const S: string; W: Integer): string;
begin
  if W <= 0 then Exit('');
  if Utf8VisibleLen(S) <= W then Exit(S);
  if W <= 1 then Exit(Utf8Cut(S, W));
  Result := Utf8Cut(S, W-1) + '…';
end;

function PadR(const S: string; W: Integer): string;
var T: string;
begin
  T := Cut(S, W);
  Result := T + StringOfChar(' ', Max(0, W - Utf8VisibleLen(T)));
end;

function PadL(const S: string; W: Integer): string;
var T: string;
begin
  T := Cut(S, W);
  Result := StringOfChar(' ', Max(0, W - Utf8VisibleLen(T))) + T;
end;

{ TTable }

procedure TTable.EnsureColCount(const Count: Integer);
var
  I: Integer;
begin
  if Length(FCols) >= Count then Exit;
  SetLength(FCols, Count);
  for I := 0 to High(FCols) do
    if FCols[I].Width = 0 then
      FCols[I].Width := Utf8VisibleLen(FCols[I].Title);
end;

procedure TTable.UpdateWidths(const Cells: array of string);
var
  I: Integer;
  L: Integer;
begin
  for I := 0 to High(Cells) do
  begin
    L := Utf8VisibleLen(Cells[I]);
    if L > FCols[I].Width then
      FCols[I].Width := L;
  end;
end;

function TTable.PadCell(const S: string; W: Integer; Align: TTextAlign): string;
begin
  if Align = taRight then
    Result := PadL(S, W)
  else
    Result := PadR(S, W);
end;

function TTable.BuildLine(const SepChar: Char): string;
var
  I: Integer;
begin
  Result := '+';
  for I := 0 to High(FCols) do
    Result := Result + StringOfChar(SepChar, FCols[I].Width + 2) + '+';
end;

procedure TTable.AddCol(const Title: string; const Align: TTextAlign);
var
  N: Integer;
begin
  N := Length(FCols);
  SetLength(FCols, N + 1);
  FCols[N].Title := Title;
  FCols[N].Align := Align;
  FCols[N].Width := Utf8VisibleLen(Title);
end;

procedure TTable.AddRow(const Cells: array of string);
var
  R: TRow;
  I, ColCount: Integer;
begin
  ColCount := Length(FCols);
  EnsureColCount(ColCount);
  R.Kind := rkRow;
  SetLength(R.Cells, ColCount);
  for I := 0 to ColCount - 1 do
  begin
    if I <= High(Cells) then
      R.Cells[I] := Cells[I]
    else
      R.Cells[I] := '';
  end;
  UpdateWidths(R.Cells);
  SetLength(FRows, Length(FRows) + 1);
  FRows[High(FRows)] := R;
end;

procedure TTable.AddSep;
var
  R: TRow;
begin
  R.Kind := rkSep;
  SetLength(R.Cells, 0);
  SetLength(FRows, Length(FRows) + 1);
  FRows[High(FRows)] := R;
end;

procedure TTable.Write;
var
  I, J: Integer;
  Line: string;
  R: TRow;
begin
  if Length(FCols) = 0 then Exit;

  Line := BuildLine('=');
  WriteLn(Line);

  Line := '|';
  for I := 0 to High(FCols) do
    Line := Line + ' ' + PadCell(FCols[I].Title, FCols[I].Width, FCols[I].Align) + ' |';
  WriteLn(Line);

  Line := BuildLine('-');
  WriteLn(Line);

  for I := 0 to High(FRows) do
  begin
    R := FRows[I];
    if R.Kind = rkSep then
    begin
      Line := BuildLine('=');
      WriteLn(Line);
      Continue;
    end;

    Line := '|';
    for J := 0 to High(FCols) do
      Line := Line + ' ' + PadCell(R.Cells[J], FCols[J].Width, FCols[J].Align) + ' |';
    WriteLn(Line);
  end;

  Line := BuildLine('-');
  WriteLn(Line);
end;

end.

````

