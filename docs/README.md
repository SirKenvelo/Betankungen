# Betankungen
**Stand:** 2026-03-15
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

- `0.9.0` wurde am `2026-03-15` final freigegeben.
- Verbindlicher Fahrplan bis `1.0.0` ist aktiv: `docs/ROADMAP_1_0_0.md`.
- Gate-Stand: Gate 1 abgeschlossen, Gate 2 abgeschlossen, Gate 3 abgeschlossen.
- Prioritaet bis 1.0.0:
  - `BL-0012` Module Capability Discovery (`--module-info` mit stabilen `capabilities`) ist umgesetzt.
  - Contract-Haertung gemaess `POL-002` (JSON/CSV/CLI, additiv, keine stillen Breaks).
  - Deprecation-Status ist explizit sichtbar (aktuell: keine aktiven Deprecations; siehe `docs/EXPORT_CONTRACT.md`).
  - Public-Readiness-Mindestpaket gemaess `BL-012` (Wiki/FAQ/Troubleshooting/Link-Checks).
- Trigger-basierte Performance-Arbeit (`BL-0013`) bleibt optional und datengetrieben.
- Nicht Teil von 1.0.0:
  - Runtime-Config-Profile im Core (`ADR-0009` abgelehnt).
  - Import-/Export-Paketformat (`BL-0014`) als spaeterer Forschungsblock.

Details und Fortschritt: `docs/STATUS.md` und `docs/ARCHITECTURE.md`.

## Doku-Navigation

- `docs/README_EN.md`: englischer Einstieg in die Projektdokumentation (inkrementell gepflegt).
- `docs/ARCHITECTURE_EN.md`: kompakte englische Architektur-Zusammenfassung.
- `docs/MODULES_ARCHITECTURE.md`: technischer Contract fuer Module (Build, CLI, DB, Stats).
- `docs/BACKLOG.md`: zentrale Uebersicht fuer bewusst verschobene, spaeter umzusetzende Themen.
- `docs/BACKLOG/`: einzelne Backlog-Items als eigene Dateien (`BL-xxx`).
- `docs/ADR/README.md`: Entscheidungen und offene Entscheidungsfragen (ADR-Index).
- `docs/policies/`: formale Regeln/Standards/Vertraege (`POL-xxx`), inkl. Tracker-Standard.
- `docs/policies/templates/`: Vorlagen fuer neue `ISS`/`BL`/`TSK`-Eintraege gemaess `POL-001`.
- `docs/tasks/`: globale `TSK-xxxx`-Eintraege (z. B. fuer Legacy-Backlog-Parents).
- `docs/CHANGELOG.md`: laufende, datierte Aenderungen.
- `docs/SPRINTS.md`: Sprint-Narrative und Commit-Folgen.
- `docs/ROADMAP_1_0_0.md`: verbindlicher Gate-Plan bis zur Finalisierung 1.0.0.
- `docs/RELEASE_0_9_0_PREFLIGHT.md`: Scope-Freeze + Release-Preflight fuer die 0.9.0-Linie.
- `docs/RELEASE_1_0_0_PREFLIGHT.md`: Scope-Freeze + Release-Preflight fuer die 1.0.0-Linie.
- `docs/CONTRACT_HARDENING_1_0_0.md`: Policy-abgeleitete Contract-Hardening-Checklist (Gate 2 / Sprint 13).
- `docs/wiki/README.md`: versionierte Wiki-v1-Quellseiten (Public-Readiness-Einstieg).

## Open-Source-Hinweis

- Lizenzziel fuer die oeffentliche V1-Schiene ist Apache-2.0 (`LICENSE` im Projektroot).
- Contribution-Leitplanken fuer oeffentliche Zusammenarbeit stehen in `CONTRIBUTING.md`.
- Detaillierte Projektdoku ist derzeit primaer auf Deutsch; GitHub-Issue/PR/Review-Kommunikation erfolgt auf Englisch.

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
- `data/`: entkoppelte Daten-Assets (u. a. `dev_messages.b64` fuer optionale Easter-Egg-Messages)
- `migrations/`: historisches SQL-Archiv fuer fruehere manuelle Migrationen
- `knowledge_archive/`: Wissens-Archiv fuer verworfene oder spaeter nutzbare Snippets
- `docs/ADR/`: Entscheidungen im ADR-Format (accepted/proposed)
- `docs/BACKLOG.md`: zentrale Backlog-Uebersicht
- `docs/BACKLOG/`: einzelne Backlog-Eintraege `BL-xxx` als Detaildokumente
- `docs/policies/`: Policies/Contracts/Standards als `POL-xxx`
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
Statistik-Modul für Betankungen (`fuelups` + Fleet-MVP).

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
- Fleet-MVP-Basis (`--stats fleet`) mit aggregierten Kernwerten ueber alle Fahrzeuge (Text + JSON)
- Fleet-JSON (`--stats fleet --json`, optional `--pretty`) inkl. Export-Meta und `kind: "fleet_mvp"`
- Fleet-Guardrails bleiben strikt: keine Fleet-Unterstuetzung fuer `--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from`, `--to`
- Cost-MVP-Basis (`--stats cost`) als fuel-basierte Kosten-Sicht (Text + JSON)
- Cost-MVP enthaelt Maintenance aktuell als Placeholder (`0`) fuer spaetere Modul-Integration
- Cost-JSON (`--stats cost --json`, optional `--pretty`) inkl. Export-Meta und `kind: "cost_mvp"`
- Cost-JSON enthaelt Scope-/Period-Felder im `cost`-Payload (`scope_mode`, `scope_car_id`, `period_*`) als maschinenlesbare Contract-Basis
- Cost-Integrationscontract (S11C1/S11C2): `--maintenance-source none|module` ist explizit; `module` integriert Maintenance-Kosten ueber das Companion-Modul, bei Quellproblemen mit transparentem Fallback statt stiller Annahmen.
- Cost-JSON enthaelt zusaetzlich Integrationsfelder (`maintenance_source_mode`, `maintenance_source_active`, `maintenance_source_note`).
- Optionale Integrations-Overrides per Environment: `BETANKUNGEN_MAINTENANCE_BIN`, `BETANKUNGEN_MAINTENANCE_DB`.
- Cost-Guardrails bleiben strikt fuer `--csv`, `--monthly`, `--yearly`, `--dashboard`
- Cost-CLI-Scope ist ab Sprint 9 freigeschaltet: `--from/--to` und `--car-id` sind fuer `--stats cost` zulaessig und wirken auf die Aggregation.
- Die Guardrails fuer Cost-Scope sind ueber Domain-Policy `P-061` regressionsgesichert (strikte Car-/Period-Isolation fuer `--stats cost`).
- Cost-Textausgabe zeigt Scope/Zeitraum explizit (`Scope: ...`, `Period filter: ...`).

Beispiele (Dashboard):
- `Betankungen --stats fuelups --dashboard`
- `Betankungen --stats fuelups --dashboard --from 2025-01 --to 2025-03`
- `Betankungen --stats fuelups --dashboard --monthly`

Beispiele (Yearly):
- `Betankungen --stats fuelups --yearly`
- `Betankungen --stats fuelups --json --yearly`

Beispiel (Fleet MVP):
- `Betankungen --stats fleet`
- `Betankungen --stats fleet --json --pretty`

Beispiel (Cost MVP):
- `Betankungen --stats cost`
- `Betankungen --stats cost --from 2025-01 --to 2025-03`
- `Betankungen --stats cost --car-id 1 --from 2025-01`
- `Betankungen --stats cost --json --pretty`

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

### `scripts/repo_sync.sh`
Repo-Pflege-Helfer fuer einen stabilen, sequentiellen Branch-Sync.

**Funktionen**
- Fuehrt `fetch` und `rebase` bewusst sequentiell aus (kein Parallel-Race auf `FETCH_HEAD`)
- Nutzt standardmaessig `origin` und den aktuell ausgecheckten Branch
- Unterstuetzt expliziten Ziel-Remote/-Branch via `--remote` und `--branch`
- Liefert `--status-only` fuer einen schnellen Sync-Preflight ohne Netzoperationen

Beispiel:
- `scripts/repo_sync.sh`
- `scripts/repo_sync.sh --status-only`
- `scripts/repo_sync.sh --remote origin --branch main`

### `scripts/release_preflight.sh`
Readiness-Preflight fuer den 0.9.0-Releasepfad.

**Funktionen**
- Fuehrt den lokalen Voll-Gate-Lauf via `make verify` aus (optional via `--skip-verify` ueberspringbar)
- prueft, dass die aktive Versionierung noch auf einer `-dev`-Linie liegt
- fuehrt `kpr.sh` und `scripts/backup_snapshot.sh` im Dry-Run aus
- standardisiert die lokale Freigabepruefung vor dem finalen Release-Schritt

Beispiel:
- `scripts/release_preflight.sh`
- `scripts/release_preflight.sh --skip-verify`
- `scripts/release_preflight.sh --note "Preflight vor 0.9.0 Freigabe"`

### `scripts/release_preflight_1_0_0.sh`
Readiness-Preflight fuer den 1.0.0-Releasepfad.

**Funktionen**
- Fuehrt den lokalen Voll-Gate-Lauf via `make verify` aus (optional via `--skip-verify` ueberspringbar)
- prueft strikt auf `APP_VERSION=1.0.0-dev`
- fuehrt `kpr.sh` und `scripts/backup_snapshot.sh` im Dry-Run aus
- standardisiert die lokale Freigabepruefung fuer die 1.0.0-Finalisierung

Beispiel:
- `scripts/release_preflight_1_0_0.sh`
- `scripts/release_preflight_1_0_0.sh --skip-verify`
- `scripts/release_preflight_1_0_0.sh --note "Preflight vor 1.0.0 Freigabe"`

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

### `scripts/dev_messages_encode.sh`
Hilfsskript zum Erzeugen von `data/dev_messages.b64` aus einer getrennten Input-Datei.

**Funktionen**
- Trennt Messages per Delimiter-Zeile `---`
- Unterstuetzt Multi-Line-Messages
- Schreibt pro Message eine base64-Zeile (entkoppelte Ablage, leichter Spoiler-Schutz)

Beispiel:
- `scripts/dev_messages_encode.sh --in /tmp/dev_messages_input.txt --out data/dev_messages.b64 --force`

### `scripts/sprint_docs_lint.sh`
Lint fuer Sprint-/Doku-Qualitaet.

**Checks**
- `**Stand:** YYYY-MM-DD` vorhanden/gueltig in `docs/**/*.md` und `tests/**/*.md`
- keine `TBD`-Marker
- Sprint-Tags in `docs/CHANGELOG.md` unter `[Unreleased] -> Changed` nur als `[General]` oder `[SxCy/z]`
- Hash-Referenzen formatgueltig (7-stellig, hex) in `docs/CHANGELOG.md` (`Basis-Commit`) und `docs/SPRINTS.md` (`Git-Commit`)

Beispiel:
- `scripts/sprint_docs_lint.sh`

### `scripts/projtrack_lint.sh`
Lint fuer den Tracker-Bereich gemaess `docs/policies/POL-001-tracker-standard.md`.

**Checks (v1-Scope)**
- Frontmatter-Pflichtfelder in `docs/issues/**/issue.md`, `docs/backlog/**/item.md`, `docs/backlog/**/tasks/TSK-*.md`
- ID-/Status-/Prioritaet-/Type-Validierung je Artefaktart
- Referenzpruefung fuer `related` und `parent`
- Duplicate-ID-Check innerhalb des neuen Tracker-Bereichs
- Code-Referenzen `TODO(...)`, `FIXME(...)`, `NOTE(...)`, `REF(...)` auf vorhandene IDs

Beispiel:
- `scripts/projtrack_lint.sh`

### `scripts/artifacts_retention.sh`
Retention-Skript fuer `.artifacts/` mit Schutz der Sprint-Historie.

**Funktionen**
- Bereinigt alte Nicht-Sprint-Artefakte (`*.md`, `*.diff`) in `.artifacts/`
- Behaelt Sprint-Artefakte (`sprint_<nr>_commit_<nr>_von_<nr>.md|.diff`) immer vollstaendig
- Gruppiert nach Dateistamm (z. B. `general_commit_abcd123`) und wendet Retention auf Gruppen an
- Unterstuetzt Dry-Run fuer sichere Vorschau

Beispiel:
- `scripts/artifacts_retention.sh --dry-run`
- `scripts/artifacts_retention.sh --keep 20`

## Task-Entrypoints (make)

- `make verify`
  - Lokales CI-Gate: `sprint_docs_lint` + `projtrack_lint` + FPC-Build + Export-Contract-Check + Cost-Integrations-Regression + Domain-Policy + Smoke + Clean-Home-Smoke
- `make cost-integration-check`
  - Fuehrt die dedizierte Cost-Integrations-Regression aus (`tests/regression/run_cost_integration_modes_check.sh`)
- `make smoke`
  - Fuehrt `tests/smoke/smoke_cli.sh --modules` aus
- `make stats-benchmark`
  - Optionaler Benchmark-Runner fuer Stats-Pfade (`tests/benchmark/run_stats_benchmark.sh`)
- `make release-preflight`
  - Fuehrt den 0.9.0-Readiness-Preflight aus (`scripts/release_preflight.sh`)
- `make release-preflight-1-0-0`
  - Fuehrt den 1.0.0-Readiness-Preflight aus (`scripts/release_preflight_1_0_0.sh`)
- `make release-dry`
  - Fuehrt `kpr.sh --dry-run` aus
- optional:
  - `make build`
  - `make smoke-clean`

## CI / Quality Gate

- GitHub Actions Workflow: `.github/workflows/ci.yml`
- Trigger:
  - `push` auf `main`
  - `pull_request` gegen `main`
  - `push` von Tags
- Gate-Schritte:
  - Sprint-/Doku-Lint (`scripts/sprint_docs_lint.sh`)
  - Tracker-Lint (`scripts/projtrack_lint.sh`)
  - FPC-Build (Projekt-Standard)
  - Export-Contract JSON-Check (`tests/regression/run_export_contract_json_check.sh`)
  - Cost-Integrations-Regression (`tests/regression/run_cost_integration_modes_check.sh`)
  - Domain-Policy-Suite (`tests/domain_policy/run_domain_policy_tests.sh`)
  - Smoke-Suite (`tests/smoke/smoke_cli.sh --modules`)
  - Clean-Home-Smoke (`tests/smoke/smoke_clean_home.sh --modules`)
- Hinweis: Als verpflichtender Merge-Gate auf GitHub muss der Status-Check `CI / verify` in den Branch-Protection-Regeln von `main` als Required Check gesetzt sein.

### Restore
- Wiederherstellungsschritte sind in `docs/RESTORE.md` dokumentiert.

---

## Danksagung

Mein besonderer Dank waehrend der Entwicklungsphase geht an CFO Cookie,
meine 2 Jahre alte Shih-Tzu-Huendin. Mit ihrer Art hat sie mir oft mentale
und konstruktive Unterstuetzung gegeben: mal ablenkend, mal erdend, aber vor
allem mit viel Zuwendung auch in stressigen Phasen.
