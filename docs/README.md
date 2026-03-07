# Betankungen
**Stand:** 2026-03-07
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

## Multi-Car-Strategie (ab 0.7.x)

- Mehrere Fahrzeuge in einer Datenbank.
- Strikte Isolation pro `car_id`.
- Kein implizites Default `car_id=1`.
- Resolver-Regelwerk:
  - 0 Cars: Hard Error.
  - 1 Car: automatische Auswahl.
  - >1 Cars: `--car-id` verpflichtend.

---

## Roadmap – Kurzstand

- `0.5.3`: Reifegrad & Vervollstaendigung (Struktur-Release, kein massiver Feature-Zuwachs)
- `0.5.4`: First-Run UX & Initialisierung (Default-DB ohne Konfig-Wissen, Prompt nur als Fallback)
- `0.5.5`: Jahres-Summary fuer Stats (`--yearly`) auf Basis der Monatsaggregation
- `0.5.6`: Help/Usage Rework (abgeschlossen)
- `0.5.6-0`: Zwischenversion fuer die Einfuehrung einer zusaetzlichen Unit (abgeschlossen)
- `0.6.0`: Fahrzeug-Domain konsolidieren (abgeschlossen)
- `0.7.0`: Multi-Car-CLI (Cars-CRUD + Resolver + strict car scoping) freigegeben
- `0.8.0`: Export-/Output-Contracts (CSV/JSON) und Konsistenz-Haertung abgeschlossen
- `0.9.x`: naechster Fokus (priorisiert nach Scope-Freeze)
- Wichtig: Jahres-Summary ist bewusst nicht Teil von `0.5.3`, sondern auf `0.5.5` verschoben.

Details und Fortschritt: `docs/STATUS.md` und `docs/ARCHITECTURE.md`.

## i18n-Hinweis (Sprint 4)

Internationalisierung wird in Sprint 4 bewusst in zwei Schritten umgesetzt:
1. erst Policy/Architektur-Doku,
2. danach technisches Wiring.

Sprachscope in Sprint 4: `language=de|en|pl`.

Aktueller Stand:
- `S4C1/3` abgeschlossen (Policy-/Architektur-Basis).
- `S4C2/3` abgeschlossen (technisches Skeleton mit `u_i18n`, `TMsgId`, `Tr()`, Config-Flow fuer `language`).
- `S4C3/3` abgeschlossen (erste risikoarme Runtime-Meta-Texte ueber `Tr()`, ohne breite Help-/Fehlertextmigration).

Details zur Regelbasis:
- Architektur: `docs/ARCHITECTURE.md` (Abschnitt "I18n Policy (Sprint 4)")
- Umsetzungsstatus: `docs/STATUS.md` (Abschnitt "Roadmap Sprint 4 - i18n First")

## Domain-Policy-Matrix v1 (Kurzueberblick)

- Matrix v1 ist fachlich umgesetzt und in `tests/domain_policy/` regressionsgesichert.
- Abgedeckte Policy-Bloecke:
  - `P-001..P-002` (Car-ID Hard Errors)
  - `P-010..P-013` (Odometer + Gap Confirm)
  - `P-020..P-022` (Fuel/Plausibility)
  - `P-030..P-032` (Cost/Price)
  - `P-040..P-041` (Date)
  - `P-050..P-051` (Gap-Flag Design Guards)
  - `P-060` inkl. Car-Isolation (`P-060/02`)
  - `P-070` (Cars-Delete-Guard bei vorhandenen fuelup-Referenzen)

---

## Projektstruktur

### Root-Ordner (Workflow ohne Git)
- `scripts/`: Wartungsskripte (Release/Backup/Netzwerkdiagnose)
- `migrations/`: historisches SQL-Archiv fuer fruehere manuelle Migrationen
- `knowledge_archive/`: Wissens-Archiv fuer verworfene oder spaeter nutzbare Snippets
- `.releases/`: finale Release-Artefakte (`.tar`) + `release_log.json`
- `.backup/`: zeitgestempelte Snapshot-Backups + `index.json`
- `tests/`: Smoke-/Plausibilitaetstests fuer den lokalen Workflow (inkl. dediziertem Cars-CRUD-Smoke)

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
- Schema-Versionierung (aktuell v5 inkl. `cars.vin`, `cars.reg_doc_path`, `cars.reg_doc_sha256`)
- Migriert v3-Startwerte aus `meta` nach `cars.odometer_start_km` / `cars.odometer_start_date`
- Produktive Upgrade-Pfade laufen runtime-idempotent in `u_db_init` (nicht primaer ueber `migrations/`)

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
- Zuordnung zu Fahrzeugen via Resolver (kein implizites `car_id=1`; bei >1 Cars ist `--car-id` Pflicht)
- Golden-Info-Flag `missed_previous` (vorheriger Tankstopp fehlt) wird bei grosser KM-Luecke gezielt abgefragt
- Bei Ablehnung der Gap-Rueckfrage (`n`) wird der Add-Flow abgebrochen (kein Fuelup-Insert)
- Plausibilitaetsregeln: `odometer_km >= car.odometer_start_km`, streng monoton pro Fahrzeug, Warnung bei sehr grosser Tankmenge
- Policy-Haertegrade (Matrix v1): Hard Errors (`P-001`, `P-002`, `P-010`, `P-011`, `P-013`, `P-020`, `P-030`, `P-040`, `P-051`) brechen ohne Write ab.
- Warning+Confirm (`P-012`, `P-021`, `P-022`, `P-031`, `P-032`, `P-041`, `P-050`) speichern nur bei expliziter Bestaetigung.
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
- Wendet automatische Retention an (`--keep N`, Default `10`) und bereinigt alte Snapshot-Ordner + Index-Eintraege

Beispiel:
- `scripts/backup_snapshot.sh`
- `scripts/backup_snapshot.sh --keep 10`
- `scripts/backup_snapshot.sh --archive .releases/Betankungen_0_8_0.tar --note "Vor Hotfix" --keep 15`

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
- Fuegt den aktuellen Arbeitsstand inkl. Branch/Ahead/Behind als `git status --short --branch` ein
- Fuegt eine Kurzsicht der lokalen Diffs hinzu (`git diff --stat` und `git diff --cached --stat`)
- Exportiert relevante Quellen in eine Markdown-Datei: `.pas`, `.lpr`, `.md`, `.sh`
- Schreibt standardmaessig nach `projekt_kontext.md` (optional eigener Ausgabepfad)
- Liefert zusaetzlich Repo-Metadaten (Root, Branch, Commit)

Beispiel:
- `scripts/projekt_kontext.sh`
- `scripts/projekt_kontext.sh /tmp/projekt_kontext.md`

### `scripts/sprint_artifact.sh`
Hilfsskript fuer lokale Sprint-Artefakte aus einem bestehenden Commit.

**Funktionen**
- Erzeugt `.diff` + `.md` fuer einen Sprint-Commit in `.artifacts/`
- Nutzt standardmaessig `HEAD` oder optional `--commit <hash>`
- Schuetzt vor unbeabsichtigtem Ueberschreiben (nur mit `--force`)
- Erstellt eine kompakte Markdown-Zusammenfassung inkl. geaenderter Dateien

Beispiel:
- `scripts/sprint_artifact.sh 4 2 3`
- `scripts/sprint_artifact.sh 4 2 3 --commit c1a6348`
- `scripts/sprint_artifact.sh 4 2 3 --force`

Details:
- `scripts/README_sprint_artifact.md`

### Restore
- Wiederherstellungsschritte sind in `docs/RESTORE.md` dokumentiert.

---

## Danksagung

Mein besonderer Dank waehrend der Entwicklungsphase geht an CFO Cookie,
meine 2 Jahre alte Shih-Tzu-Huendin. Mit ihrer Art hat sie mir oft mentale
und konstruktive Unterstuetzung gegeben: mal ablenkend, mal erdend, aber vor
allem mit viel Zuwendung auch in stressigen Phasen.
