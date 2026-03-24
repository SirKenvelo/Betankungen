# Test Matrix
**Stand:** 2026-03-24

## Ziel

Diese Matrix dient als zentrale Uebersicht, um die fachliche, technische und
nutzerseitige Testabdeckung von Betankungen systematisch zu planen, zu
bewerten und pro Release nachvollziehbar abzuarbeiten.

Sie ist bewusst keine weitere Runner-Dokumentation. Dafuer bleiben die
konkreten Suiten in `tests/README.md` die operative Source of Truth.

## Abgrenzung / Source of Truth

- `docs/TEST_MATRIX.md`:
  - Teststrategie
  - Testebenen
  - Coverage-Matrix
  - Release-Gates
  - offene Leitfragen
- `tests/README.md`:
  - heute vorhandene Runner, Suiten, Fixtures und Aufrufbefehle
- `docs/issues/`:
  - konkrete reproduzierbare Produktprobleme
- `docs/backlog/`:
  - gebuendelte Hardening-/Umsetzungsarbeit

## Testprinzipien

1. Keine Monster-Tests
- Testen in Schichten: Unit, Integration, Smoke, User-Flow, Negativ/Robustheit,
  Backup/Restore.

2. Definierte Testdaten statt Bauchgefuehl
- Wo moeglich mit bekannten Seeds, Datensatzanzahlen, erwarteten JSON-Feldern,
  Exit-Codes und Fehlermeldungen arbeiten.

3. Backup gilt erst mit Restore als belastbar
- Ein Backup ist erst dann fachlich abgesichert, wenn ein Restore-Roundtrip den
  Ursprungszustand reproduzierbar wiederherstellt.

4. Nutzerverhalten ist Teil der Produktqualitaet
- Neben technischer Korrektheit muessen auch Verstaendlichkeit,
  Fehlertoleranz, Plausibilitaet und saubere Abbruchpfade geprueft werden.

## Aktuelle Einordnung der vorhandenen Tests

- Domain-Policy-Suite:
  - starke Abdeckung fuer CLI-/Domain-Guards und deterministische Kernregeln
- Regression-Skripte:
  - gezielte Contract-/Feature-Regressionen fuer JSON/CSV/Cost/Backup/
    Fuel-Price-History/Receipt
  - priorisierte User-Flow-/Break-Pfade aus der Matrix jetzt als eigener
    Regression-Runner codifiziert (`tests/regression/run_user_flow_break_matrix_check.sh`)
- Smoke-Suiten:
  - schneller End-to-End-Sanity-Check fuer CLI, Multi-Car, Migrationen,
    Module und Clean-Home
- Benchmark:
  - bewusst optional, kein Pflicht-Gate

Noch unterreprasentiert sind aktuell:
- breitere User-Flow-Abdeckung jenseits der priorisierten Phase-1-Pfade
- tiefe Fehlerumgebungsfaelle (read-only/corrupt DB) als reproduzierbare
  Standardsuite
- systematische Restore-Roundtrips als Release-Standard

## Testebenen

### 1. Unit-Tests

Ziel: kleine, klar isolierte Logik pruefen.

Abdeckung:
- CLI-Parsing
- Feldvalidierung
- Verbrauchsberechnung
- Kostenberechnung
- Monatsaggregation
- JSON-Erzeugung
- Tabellen-/Formatierungslogik
- Sonderfaelle mit Nullwerten oder leeren Daten

Erfolgskriterium:
- Bei Fehlern ist sofort erkennbar, welche Logikkomponente betroffen ist.

### 2. Integrations-Tests

Ziel: Zusammenspiel mehrerer Module pruefen.

Abdeckung:
- DB-Initialisierung + Config
- DB-Initialisierung + Seed
- Add + List + Stats
- Demo-Modus + separate DB
- Multi-Car-Kontext + Filter + Stats
- Config + Standardpfade

Erfolgskriterium:
- Die Kernmodule arbeiten gemeinsam stabil und liefern konsistente Ergebnisse.

### 3. Smoke-Tests

Ziel: schneller Grundcheck vor Commits, PR-Merges, Tags und Releases.

Abdeckung:
- `--help`
- `--version`
- `--show-config`
- `--list cars`
- `--list stations`
- `--list fuelups`
- `--stats fuelups`
- `--stats fleet`
- `--stats cost`

Erfolgskriterium:
- Keine Crashes, sinnvolle Exit-Codes, plausible Grundausgaben.

### 4. User-Flow-Tests

Ziel: reale Nutzungsablaeufe aus Sicht normaler Nutzer pruefen.

Abdeckung:
- Erststart in leerer Umgebung
- Auto-Init von Config und DB
- interaktiv Tankstelle anlegen
- interaktiv Betankung anlegen
- Listen und Stats danach pruefen
- Seed- und Demo-Ablauf
- Listen-/Detail-/Stats-Pfade nach Datenerfassung

Erfolgskriterium:
- Die Anwendung fuehlt sich schluessig, nachvollziehbar und benutzbar an.

### 5. Negativ- und Robustheitstests

Ziel: Verhalten bei falschen Eingaben, unlogischen Zustaenden und Fehlern
pruefen.

Abdeckung:
- ungueltige Zahlenwerte
- negative Preise oder Liter
- ungueltige Datumsangaben
- Kilometerstand kleiner als vorheriger Stand
- leere Pflichtfelder
- unbekannte Flags
- defekte Config
- fehlende DB
- beschaedigte DB
- schreibgeschuetzte Verzeichnisse
- unvollstaendige Nutzerangaben
- EOF-/Nicht-Interaktiv-Faelle

Erfolgskriterium:
- Die Anwendung bleibt kontrolliert, erklaert Fehler sauber und geraet nicht in
  kaputte Zustaende.

### 6. Backup- und Restore-Tests

Ziel: Verlaesslichkeit von Sicherung und Wiederherstellung pruefen.

Abdeckung:
- Backup-Datei wird erzeugt
- Backup-Datei ist lesbar
- Tabellen und Datensaetze sind vorhanden
- Restore bringt Ursprungszustand korrekt zurueck
- Fehlerfaelle bei Backup/Restore

Erfolgskriterium:
- Backup und Restore funktionieren reproduzierbar und
  datenintegritaetswahrend.

## Abdeckungsmatrix nach Funktionsbereichen

### 1. Initialisierung / Erststart

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| INIT-001 | Start in leerem Verzeichnis | `config.ini` und DB werden automatisch erzeugt | Hoch | Automatisiert |
| INIT-002 | Erststart legt Standardauto an | Hauptauto oder definierter Default ist vorhanden | Hoch | Automatisiert |
| INIT-003 | `--show-config` nach Erststart | Pfade und Werte werden plausibel angezeigt | Hoch | Automatisiert |
| INIT-004 | `--list cars` direkt nach Erststart | Standardauto sichtbar, kein Fehler | Mittel | Automatisiert |
| INIT-005 | `--list stations` leer | Verstaendliche Rueckmeldung, kein Crash | Hoch | Automatisiert |
| INIT-006 | `--list fuelups` leer | Verstaendliche Rueckmeldung, kein Crash | Hoch | Automatisiert |

### 2. Config

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| CFG-001 | fehlende Config | Auto-Erzeugung oder verstaendliche Standardbehandlung | Hoch | Offen |
| CFG-002 | defekte Config-Datei | Saubere Fehlermeldung, kein unkontrollierter Absturz | Hoch | Offen |
| CFG-003 | benutzerdefinierter Pfad | Anwendung nutzt korrekten Zielpfad | Mittel | Offen |
| CFG-004 | ungueltige Werte in Config | Fehler klar benannt | Mittel | Offen |

### 3. Cars

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| CAR-001 | `--list cars` leer/erstinitialisiert | Plausible Ausgabe | Hoch | Offen |
| CAR-002 | Auto hinzufuegen | Datensatz wird korrekt angelegt | Hoch | Offen |
| CAR-003 | Auto bearbeiten | Aenderungen werden korrekt gespeichert | Mittel | Offen |
| CAR-004 | Auto loeschen | Datensatz wird korrekt entfernt oder Schutz greift | Mittel | Offen |
| CAR-005 | Default-Car setzen | Nachfolgende Operationen nutzen korrektes Default-Car | Hoch | Offen |
| CAR-006 | ungueltige Auto-ID | Saubere Fehlermeldung | Mittel | Offen |

### 4. Stations

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| ST-001 | `--list stations` leer | Verstaendliche Rueckmeldung | Hoch | Offen |
| ST-002 | Tankstelle interaktiv anlegen | Datensatz wird korrekt gespeichert | Hoch | Offen |
| ST-003 | Tankstelle mit vollstaendiger Adresse | Alle Felder korrekt persistiert | Hoch | Offen |
| ST-004 | Strasse mit Hausnummer in einem Feld | Plausibilitaetspruefung oder klarer UX-Hinweis | Mittel | Offen |
| ST-005 | leere Pflichtfelder | Validierung greift sauber | Hoch | Offen |
| ST-006 | ungueltige Eingaben | Fehlertext verstaendlich | Mittel | Offen |
| ST-007 | Bearbeiten | Aenderungen korrekt sichtbar | Mittel | Offen |
| ST-008 | Loeschen | Schutz gegen inkonsistente Referenzen oder saubere Loeschung | Mittel | Offen |

### 5. Fuelups

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| FU-001 | `--list fuelups` leer | Verstaendliche Rueckmeldung | Hoch | Offen |
| FU-002 | Betankung interaktiv anlegen | Datensatz wird korrekt gespeichert | Hoch | Offen |
| FU-003 | `--list fuelups --detail` | Datensatz vollstaendig und korrekt sichtbar | Hoch | Offen |
| FU-004 | numerische Eingaben validieren | Fehler oder Rueckfrage bei ungueltigen Zahlen | Hoch | Offen |
| FU-005 | negativer Preis / negative Liter | Validierung blockiert Eingabe | Hoch | Offen |
| FU-006 | Datum ungueltig | Validierung blockiert Eingabe | Hoch | Offen |
| FU-007 | Kilometerstand kleiner als vorher | Plausibilitaetspruefung greift | Hoch | Offen |
| FU-008 | Volltankung = nein | Datensatz gespeichert, Statistik passend angepasst | Mittel | Offen |
| FU-009 | Bearbeiten | Aenderungen werden korrekt uebernommen | Mittel | Offen |
| FU-010 | Loeschen | Datensatz korrekt entfernt | Mittel | Offen |
| FU-011 | `gap` / `missed_previous` gesetzt | Statistik beruecksichtigt Luecke fachlich korrekt | Hoch | Offen |

### 6. Stats

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| STATS-001 | Fuelup-Stats mit leerer DB | Nullwerte oder verstaendliche Leerzustaende | Hoch | Offen |
| STATS-002 | genau 1 Volltankung | Kein auswertbarer Zyklus, verstaendliche Erklaerung | Hoch | Offen |
| STATS-003 | 2 Volltankungen | Verbrauch wird korrekt berechnet | Hoch | Offen |
| STATS-004 | mehrere Betankungen ueber Monate | Monatsaggregation korrekt | Mittel | Offen |
| STATS-005 | Cost-Stats mit leerer DB | Nullwerte oder verstaendliche Leerzustaende | Hoch | Offen |
| STATS-006 | definierte Testdaten | Kosten pro km / 100 km korrekt | Hoch | Offen |
| STATS-007 | Fleet-Stats mit mehreren Fahrzeugen | Aggregation korrekt | Mittel | Offen |
| STATS-008 | Stats JSON `--json --pretty` | JSON syntaktisch korrekt und fachlich vollstaendig | Hoch | Offen |
| STATS-009 | Stats mit Car-Filter | Nur passende Datensaetze fliessen ein | Hoch | Offen |
| STATS-010 | Stats mit `missed_previous` | betroffene Intervalle werden korrekt ausgeschlossen/markiert | Hoch | Offen |

### 7. Seed / Demo

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| DEMO-001 | `--seed` auf leerer Umgebung | Seed laeuft erfolgreich | Hoch | Automatisiert |
| DEMO-002 | Seed erzeugt Demo-DB | Demo-DB wird getrennt von Haupt-DB angelegt | Hoch | Automatisiert |
| DEMO-003 | `--demo --list stations` | Seed-Daten sichtbar | Hoch | Automatisiert |
| DEMO-004 | `--demo --stats fuelups --monthly` | Plausible Statistik auf Demo-Daten | Mittel | Automatisiert |
| DEMO-005 | Missverstaendnis Haupt-DB vs. Demo-DB | Ausgabe/Hinweis macht Trennung verstaendlich | Hoch | Automatisiert |
| DEMO-006 | `--force`-Verhalten | Vorhandene Demo-Daten werden definiert ueberschrieben | Mittel | Offen |

### 8. JSON / Export / Schnittstellen

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| JSON-001 | leere Datenbasis | Valides JSON mit leerem Inhalt | Hoch | Offen |
| JSON-002 | normale Datenbasis | Erwartete Felder vollstaendig vorhanden | Hoch | Offen |
| JSON-003 | Pretty-Ausgabe | Syntax korrekt, lesbar formatiert | Mittel | Offen |
| JSON-004 | Sonderzeichen | Kodierung bleibt stabil | Mittel | Offen |

### 9. CLI / Fehlerverhalten

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| CLI-001 | unbekanntes Flag | sauberer Fehlertext, sinnvoller Exit-Code | Hoch | Automatisiert |
| CLI-002 | unvollstaendiger Befehl | Hilfe oder klare Fehlermeldung | Hoch | Offen |
| CLI-003 | widerspruechliche Flags | Klare Ablehnung oder definierte Prioritaet | Mittel | Offen |
| CLI-004 | `--help` | Hilfetext vollstaendig und verstaendlich | Hoch | Offen |
| CLI-005 | `--version` | Version korrekt ausgegeben | Mittel | Offen |

### 10. Backup / Restore

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| BAK-001 | Backup-Datei wird erstellt | Datei existiert und ist nicht leer | Hoch | Offen |
| BAK-002 | Backup-Datei ist gueltige SQLite-DB | Datei laesst sich oeffnen | Hoch | Offen |
| BAK-003 | Tabellen vorhanden | erwartete Tabellenstruktur vorhanden | Hoch | Offen |
| BAK-004 | Datensatzanzahlen stimmen | Counts entsprechen Original-DB | Hoch | Offen |
| BAK-005 | Restore stellt Originalzustand wieder her | definierter Roundtrip erfolgreich | Sehr hoch | Offen |
| BAK-006 | Restore nach absichtlicher Aenderung | Ursprungszustand kommt korrekt zurueck | Sehr hoch | Offen |
| BAK-007 | Zielpfad nicht beschreibbar | sauberer Fehler, kein halber Zustand | Hoch | Offen |
| BAK-008 | defekte Backup-Datei | sauberer Fehler, keine korrupte Ziel-DB | Hoch | Offen |
| BAK-009 | bestehende DB ueberschreiben | nur kontrolliert und nachvollziehbar | Mittel | Offen |

### 11. Read-only / Fehlerumgebung

| ID | Testfall | Erwartung | Prioritaet | Status |
| --- | --- | --- | --- | --- |
| ERR-001 | DB-Verzeichnis read-only | verstaendlicher Fehler | Hoch | Offen |
| ERR-002 | Config-Verzeichnis read-only | verstaendlicher Fehler | Hoch | Offen |
| ERR-003 | beschaedigte SQLite-Datei | sauber abgefangener Fehler | Hoch | Offen |
| ERR-004 | DB fehlt waehrend Operation | sauberer Fehler oder Re-Init, je nach Design | Mittel | Offen |

## Empfohlene Testlaeufe pro Entwicklungsphase

### Bei jedem kleinen Commit

- relevante Unit-Tests
- schnelle Smoke-Tests

### Vor jedem Merge oder Tag

- Smoke-Tests komplett
- Integrations-Tests
- definierte User-Flows

### Vor jedem Release

- kompletter User-Testlauf in isolierter Umgebung
- Negativtestlauf
- Backup-/Restore-Roundtrip
- JSON-/Export-Pruefung

## Priorisierung

### Sehr hoch

- Initialisierung
- leere Zustaende
- Betankung anlegen
- Statistik-Kernlogik
- Backup-/Restore-Roundtrip
- Fehler bei kaputter DB oder Config

### Hoch

- Stations-UX
- Demo-/Seed-Verstaendlichkeit
- JSON-Konsistenz
- Car-Filter
- Gap-/`missed_previous`-Verhalten

### Mittel

- Komfortfunktionen
- Sonderfaelle bei Bearbeiten/Loeschen
- Ausgabe- und Formatierungsdetails

## Aktuelle Nutzerfundlage (2026-03-20)

Die manuell dokumentierten Nutzertests haben fuenf reproduzierbare
Problemcluster sichtbar gemacht. Diese Cluster sind inzwischen als Tracker-
Artefakte erfasst und technisch nachgezogen:

- `ISS-0002`: resolved (`--seed`/`--demo` Anschlussfluss gehaertet).
- `ISS-0003`: resolved (EOF-/Leerzustandsabbruch fuer Fuelup-Dialoge gehaertet).
- `ISS-0004`: resolved (`P-033` Cross-Field-Validierung aktiv).
- `ISS-0005`: resolved (`P-080..P-084` Stations-Plausibilitaet aktiv).
- `ISS-0006`: resolved (First-Run-/Multi-Car-Guidance geschaerft).

Der uebergeordnete Hardening-Block dafuer ist `BL-0022`.

## Offene Leitfragen

- Soll `--seed` bewusst nur Demo-Daten befuellen oder optional auch die
  Haupt-DB?
- Soll bei Strasse + Hausnummer in einem Feld aktiv geholfen oder nur gewarnt
  werden?
- Wie explizit soll erklaert werden, dass eine einzelne Volltankung noch keinen
  auswertbaren Verbrauchszyklus ergibt?
- Wie soll Restore mit vorhandener Ziel-DB umgehen: blockieren, ueberschreiben,
  bestaetigen?
- Welche Tests sind verpflichtendes Release-Gate?

## Praktischer naechster Schritt

Phase 2:
- verbleibende offene Matrix-Faelle priorisieren (Config-Defekte,
  Read-only-/Corrupt-DB, Restore-Roundtrip)
- User-Flow-/Break-Checks schrittweise aus dem dedizierten Runner in weitere
  Release-Gates ueberfuehren
- definierte Integrationsdaten fuer Stats weiter ausbauen

## Statuslegende

- Offen = noch nicht umgesetzt
- Geplant = Testfall definiert, aber noch nicht gebaut
- In Arbeit = Test wird gerade implementiert
- Automatisiert = automatisiert ausfuehrbar
- Manuell = bewusst manuell geprueft
- Bestanden = aktuell erfolgreich
- Fehlgeschlagen = aktuell reproduzierbar defekt
