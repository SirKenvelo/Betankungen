# Benutzerhandbuch Betankungen
**Stand:** 2026-02-28

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
- `Betankungen --list fuelups --car-id <id>`
- `Betankungen --list fuelups --detail`

Eingabe bei `--add fuelups`:
- Fahrzeugauswahl (`cars`) via Resolver:
  - mit `--car-id <id>`: diese ID wird auf Existenz validiert
  - ohne `--car-id`: bei genau einem Fahrzeug automatische Auswahl
  - ohne `--car-id` und 0 oder >1 Fahrzeuge: Hard Error mit Hinweis
- Auswahl der Tankstelle (Liste mit IDs)
- Datum+Uhrzeit: `YYYY-MM-DD HH:MM:SS`
- Kilometerstand (km)
- Odometer-Checks pro Fahrzeug:
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

Policy-Hinweis (Matrix v1):
- Hard Error ohne Write: `P-001`, `P-002`, `P-010`, `P-011`, `P-013`, `P-020`, `P-030`, `P-040`, `P-051`.
- Warning+Confirm (nur speichern bei `y`): `P-012`, `P-021`, `P-022`, `P-031`, `P-032`, `P-041`, `P-050`.
- `--list fuelups` nutzt dasselbe Car-Resolver-Regelwerk wie Add:
  - bei 0 Fahrzeugen: Hard Error
  - bei genau 1 Fahrzeug: automatische Aufloesung
  - bei mehreren Fahrzeugen: `--car-id` erforderlich

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
