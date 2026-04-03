# Benutzerhandbuch Betankungen
**Stand:** 2026-04-03

CLI-Anwendung zum Erfassen und Auswerten von Tankvorgaengen (SQLite, lokal).

---

**Kurzueberblick**
- Erfassen von Tankstellen und Betankungen (interaktiv).
- Listen mit Standard- und Detailansicht.
- Volltank-Zyklus-Statistiken (Text und JSON).
- Mehrere Fahrzeuge pro Datenbank mit strikter Isolation (Resolver-Regelwerk).
- XDG-konforme Speicherung von Konfiguration und Datenbank.

**Fahrzeug-Kontext (Resolver-Regelwerk)**
Alle car-sensitiven Kommandos (`--add fuelups`, `--list fuelups`, `--stats fuelups`) folgen derselben Logik:
- 0 Fahrzeuge: Hard Error.
- 1 Fahrzeug: automatische Auswahl.
- >1 Fahrzeuge: `--car-id <id>` verpflichtend.
- Mit `--car-id <id>`: ID wird auf Existenz validiert, ungueltige/fehlende IDs sind Hard Errors.
- Fahrzeug-Start-KM und Start-Datum koennen ueber `--edit cars --car-id <id>`
  korrigiert werden, solange fuer dieses Fahrzeug noch keine Betankung
  gespeichert ist. Nach dem ersten Fuelup bleiben diese Startwerte gesperrt.

**Start und Hilfe**
- Hilfe: `Betankungen --help`
- Version: `Betankungen --version`
- About inkl. Danksagung: `Betankungen --about`

**Datenbank und Konfiguration**
- Standard-DB: `~/.local/share/Betankungen/betankungen.db`
- Demo-DB: `~/.local/share/Betankungen/betankungen_demo.db`
- Config-Datei: `~/.config/Betankungen/config.ini`
- Config-Sprache: `language=de|en|pl` unter Sektion `[ui]` (Default `de`).
- Fehlende/ungueltige Config-Sprache wird auf `de` normalisiert; i18n ist aktuell als Skeleton vorbereitet (noch keine breite Lauftext-Migration).
- Erststart ohne vorhandene Config: Standard-DB wird automatisch genutzt und in der Config gespeichert.
- Frischer Start ohne Argumente: Config + DB werden automatisch angelegt und der naechste sinnvolle Schritt sichtbar ausgegeben (`Betankungen --list cars`).
- Config vorhanden, DB fehlt: Die DB wird automatisch am konfigurierten Pfad neu angelegt (ohne Prompt) und mit kurzer Guidance bestaetigt.
- Wenn die DB neu angelegt wird, ist das Standardfahrzeug `Hauptauto` aktiv (`car_id=1`).
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
- Optional: Phone, Owner, Latitude, Longitude, Plus Code
- Geodaten-Regeln:
  - `Latitude` und `Longitude` nur gemeinsam oder beide leer
  - Format: Dezimalgrad mit max. 6 Nachkommastellen
  - Bereiche: `latitude` `[-90, 90]`, `longitude` `[-180, 180]`
  - `Plus code` wird normalisiert und als voller Open Location Code
    gespeichert
  - Akzeptiert werden entweder ein voller/globaler Open Location Code oder ein
    lokaler/short Code (z. B. aus Google Maps), sofern `Latitude` und
    `Longitude` gesetzt sind
  - Short Codes ohne Koordinaten werden mit einem klaren Hinweis geblockt
- Ausgabe-Regeln:
  - `Betankungen --list stations` bleibt kompakt ohne Geodaten-Zusatz
  - `Betankungen --list stations --detail` zeigt vorhandene Geodaten als
    zusaetzliche `geodata:`-Zeile je Station

**Betankungen erfassen**
Kommandos:
- `Betankungen --add fuelups`
- `Betankungen --add fuelups --receipt-link <path|uri>`
- `Betankungen --list fuelups`
- `Betankungen --list fuelups --car-id <id>`
- `Betankungen --list fuelups --detail`
- Die Hauptzeile der Fuelup-Liste bleibt stationsfokussiert; der
  Fahrzeugkontext wird in `--detail` separat ueber `Car: ...` gezeigt.

Eingabe bei `--add fuelups`:
- Fahrzeugauswahl (`cars`) via Resolver:
  - mit `--car-id <id>`: diese ID wird auf Existenz validiert
  - ohne `--car-id`: bei genau einem Fahrzeug automatische Auswahl
  - ohne `--car-id` und 0 oder >1 Fahrzeuge: Hard Error mit Hinweis
  - bei genau einem Fahrzeug bleibt dieses Fahrzeug fuer den gesamten
    Add-Flow aktiv; wer den Kontext vorab explizit sehen will, kann
    `Betankungen --list cars` nutzen oder `--car-id <id>` bewusst setzen
- Auswahl der Tankstelle (Liste mit IDs)
- Datum+Uhrzeit: `YYYY-MM-DD HH:MM:SS`
- Aktueller Gesamt-Kilometerstand des Fahrzeugs (km)
  - dies ist der kanonische `odometer_km`-Wert im Fuelup-Dialog
  - gemeint ist nicht die Strecke seit der letzten Tankung
- Odometer-Checks fuer diesen Gesamtstand pro Fahrzeug:
  - `odometer_km` muss eine Ganzzahl `>= 0` sein
  - muss >= Fahrzeug-Start-KM sein
  - muss strikt groesser als der letzte Odometer des Fahrzeugs sein
- Bei grosser Distanzluecke (> 1500 km) wird gezielt nach "fehlender vorheriger Betankung" gefragt (`missed_previous`)
- Wird diese Rueckfrage mit `n` beantwortet, wird der Add-Flow abgebrochen (kein Insert).
- Gesamtpreis (EUR, z.B. `50,01`)
- Getankte Menge (Liter, z.B. `28,76`)
- Preis pro Liter (EUR/L, z.B. `1,739`)
- Vollgetankt? (y/n)
- Bei sehr grosser Tankmenge (> 150 L) kommt eine Warnung mit Bestaetigungsabfrage
- Optional: Spritart, Bezahlart, Zapfsaeule, Notiz
- Optional: externer Beleg-Link via `--receipt-link <path|uri>` (nur Referenz, keine Bilddaten in SQLite).
- Wenn ein Beleg-Link gespeichert werden soll, muss `--receipt-link` bereits
  **vor** dem Start von `--add fuelups` gesetzt werden; der interaktive Dialog
  fragt diesen Wert aktuell nicht noch einmal separat ab.
- Wichtig: `fuelups` bleiben append-only und koennen spaeter nicht per
  `--edit fuelups` nachbearbeitet werden.
- Guardrails fuer `--receipt-link`: nur bei `--add fuelups`, nicht leer, keine Steuerzeichen.

Policy-Hinweis (Matrix v1):
- Hard Error ohne Write: `P-001`, `P-002`, `P-010`, `P-011`, `P-013`, `P-020`, `P-030`, `P-040`, `P-051`.
- Warning+Confirm (nur speichern bei `y`): `P-012`, `P-021`, `P-022`, `P-031`, `P-032`, `P-041`, `P-050`.
- `--list fuelups` nutzt dasselbe Car-Resolver-Regelwerk wie Add:
  - bei 0 Fahrzeugen: Hard Error
  - bei genau 1 Fahrzeug: automatische Aufloesung
  - bei mehreren Fahrzeugen: `--car-id` erforderlich
- In `--list fuelups --detail` wird ein gesetzter Beleg-Link als `Receipt link: ...` angezeigt.

**Statistiken: Volltank-Zyklen, Monate und Jahre**
- Textausgabe: `Betankungen --stats fuelups`
- Textausgabe (gezielt fuer ein Fahrzeug): `Betankungen --stats fuelups --car-id <id>`
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
- Fahrzeugauswahl (`cars`) via Resolver:
  - mit `--car-id <id>`: diese ID wird auf Existenz validiert
  - ohne `--car-id`: bei genau einem Fahrzeug automatische Auswahl
  - ohne `--car-id` und 0 oder >1 Fahrzeuge: Hard Error mit Hinweis
- Falls `missed_previous=1` gesetzt wurde, wird der laufende Zyklus bewusst resettet.
- Yearly-Regeln: `--yearly` und `--monthly` sind exklusiv; `--yearly` ist nicht mit `--csv` oder `--dashboard` kombinierbar.

**Statistiken: Fleet (MVP-Basis)**
- Fleet-MVP Textausgabe: `Betankungen --stats fleet`
- Fleet-MVP JSON compact: `Betankungen --stats fleet --json`
- Fleet-MVP JSON pretty: `Betankungen --stats fleet --json --pretty`
- Textausgabe enthaelt aggregierte Basiswerte ueber alle Fahrzeuge (`Cars`, `Fuelups`, `Total liters (ml)`, `Total cost (cents)`).
- JSON enthaelt Export-Meta (`contract_version`, `generated_at`, `app_version`, `kind: "fleet_mvp"`) und den Payload `fleet` mit `cars_total`, `fuelups_total`, `liters_ml_total`, `total_cents_all`.
- Weiterhin nicht verfuegbar fuer Fleet-MVP: `--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from`, `--to`.

**Statistiken: Cost (MVP-Basis)**
- Cost-MVP Textausgabe: `Betankungen --stats cost`
- Cost-MVP JSON compact: `Betankungen --stats cost --json`
- Cost-MVP JSON pretty: `Betankungen --stats cost --json --pretty`
- Expliziter Integrationsmodus: `Betankungen --stats cost --maintenance-source none|module`
- Ausgabe enthaelt aktuell: `Cars total`, `Cars with valid full-tank cycles`, `Distance (km)`, `Fuel cost (cents)`, `Maintenance cost (cents)` (MVP-Placeholder), `Total cost (cents)`, `Total cost per km (EUR)`.
- Cost-MVP basiert auf Fuel-Kosten aus gueltigen Volltank-Zyklen; ohne aktivierte Modulquelle (`--maintenance-source none`) bleibt Maintenance auf `0` (Core-Placeholder).
- `--maintenance-source none` ist aktuell der aktive Modus.
- `--maintenance-source module` ist ab S11C2/4 aktiv: der Core liest Maintenance-Kosten ueber das Companion-Binary `betankungen-maintenance` ein.
- Falls das Companion-Binary oder dessen Datenquelle nicht nutzbar ist, bleibt der Cost-Lauf robust (kein Abbruch); stattdessen wird ein expliziter Fallback mit `maintenance_source_active=false` und Hinweistext ausgegeben.
- JSON enthaelt Export-Meta (`contract_version`, `generated_at`, `app_version`, `kind: "cost_mvp"`) und den Payload `cost` mit Aggregaten sowie skalierten per-km-Werten (`*_eur_x1000`).
- Cost-JSON fuehrt zusaetzlich Scope-/Period-Felder als Contract (`scope_mode`, `scope_car_id`, `period_enabled`, `period_from`, `period_to_exclusive`, `period_from_provided`, `period_to_provided`) sowie Integrationsfelder (`maintenance_source_mode`, `maintenance_source_active`, `maintenance_source_note`).
- Optionale Environment-Overrides fuer die Modulquelle:
  - `BETANKUNGEN_MAINTENANCE_BIN` (Pfad/Name des Companion-Binaries)
  - `BETANKUNGEN_MAINTENANCE_DB` (expliziter Modul-DB-Pfad fuer den Companion-Aufruf)
- Weiterhin nicht verfuegbar fuer Cost-MVP: `--csv`, `--monthly`, `--yearly`, `--dashboard`.
- Cost-CLI-Scope ist aktiviert: `--from/--to` und `--car-id` sind fuer `--stats cost` zulaessig.
- Cost-Scope wirkt direkt auf die Aggregation (Collector): Zeitraum- und Fahrzeugfilter werden in Text- und JSON-Ausgabe angewendet.
- Textausgabe zeigt den aktiven Scope explizit (`Scope: ...`, `Period filter: ...`).

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
