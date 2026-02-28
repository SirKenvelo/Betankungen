# Brainstorming - Betankungen
> Repository-Dokument - Strategische Vision

---

**Dokumenttyp:** Strategisches Brainstorming  
**Projekt:** Betankungen  
**Status:** Intern - Konzeptphase  
**Stand:** 2026-02-28  
**Version:** 0.2 (Vision + Contribution Draft)  
**Kompatibel mit:** >= 0.7.x Architekturvision

---

## Einordnung im Repository

Dieses Dokument dient als langfristige Architektur- und Vision-Skizze.  
Es ergaenzt:

- [ARCHITECTURE.md](./ARCHITECTURE.md)
- [DESIGN_PRINCIPLES.md](./DESIGN_PRINCIPLES.md)
- [STATUS.md](./STATUS.md)

Es definiert keine unmittelbare Roadmap-Verpflichtung.

---

## Kontext

Dieses Dokument beschreibt moegliche Erweiterungen und strategische Richtungen fuer die Weiterentwicklung von *Betankungen*.  
Es handelt sich ausdruecklich **nicht** um eine Feature-Zusage, sondern um eine strukturierte Ideensammlung zur langfristigen Architekturplanung.

Rahmenbedingungen:

- CLI-first
- Privatnutzer im Fokus
- Kein GUI-Zwang
- Kein Enterprise-Flottenmanagement

---

## Reality Check (Ist-Stand, 0.7.x)

- Multi-Car im Produktivsinn ist umgesetzt: mehrere Fahrzeuge in einer DB mit strikter Isolation pro `car_id`.
- Car-Kontext wird zentral ueber den Resolver `ResolveCarIdOrFail` aufgeloest (0/1/>1 Cars, unknown/invalid konsistent behandelt).
- Es gibt kein implizites `car_id=1` mehr; bei mehreren Fahrzeugen ist `--car-id` verpflichtend.
- Multi-User bleibt weiterhin bewusst out of scope fuer die aktuelle Produktphase (siehe Abschnitt 2.2).

---

## 1. Erweiterte Fahrzeugtypen und Maschinen

### 1.1 Kategorien-System (Typen statt nur "Car")

Einfuehrung einer uebergeordneten Entitaet: **Asset**.

Ziel: Abstraktion vom reinen "Auto"-Begriff.

Moegliche Asset-Typen:

- Car (Kilometer-basiert)
- Boat (Betriebsstunden-basiert)
- Machine (Stunden oder manuelle Intervalle)
- Device (z. B. Generator, Rasenmaeher)

#### 1.1.1 Nutzungseinheit (`usage_unit`)

Technisch sauberer Ansatz:

- Jedes Asset besitzt ein Feld: `usage_unit`
- Moegliche Werte: `km` | `h` | `mi` (erweiterbar)

Logik:

`Verbrauch = diff(usage_value) / fuel_amount`  
Die Einheit des Ergebnisses ergibt sich aus `usage_unit`.

Vorteile:

- Keine Speziallogik pro Fahrzeugtyp
- Einheit vollstaendig abstrahiert
- Zukunftssicher

---

### 1.2 Kleingeraete und Kanister-Logik

Problem:

- Kein kontinuierlicher Kilometerstand
- Betankung erfolgt aus Kanister

Moegliche Loesung:

- Asset-Typ "Device"
- Optionaler Modus "Kanisterverbrauch"
- Manuelle Verbrauchserfassung moeglich

Langfristig denkbar:

- Minimalistische Kraftstoff-Bestandsverwaltung

---

### 1.3 Generisches Tagging-System

Entscheidung: **Generische String-Tags statt fest definierter Kategorien.**

Beispiel:

```bash
betankung add --tags "urlaub,anhaenger,dachbox"
```

Eigenschaften:

- Freie Tags
- Filterbar in Statistiken
- Keine Core-Aufblaehung durch Sonderfaelle

Optional spaeter:

- Key-Value-Tags (z. B. `weather=rain`)

---

## 2. Multi-User und Multi-Car Szenarien

### 2.1 Fuhrpark light

Zielgruppe:

- Haushalte mit mehreren Fahrzeugen
- Oldtimer-Sammler
- Kleinbetriebe (1-5 Fahrzeuge)

Erweiterbar um:

- Standzeiten
- Jahreskilometer
- Wartungsintervalle pro Asset

---

### 2.2 Multi-User (Light-Modell)

Szenario:

Ein Fahrzeug, mehrere Fahrer.

Moegliche Umsetzung:

- Entitaet "Driver"
- Optionales Feld pro Eintrag
- Kosten-Auswertung pro Fahrer

Kein komplexes User-Management vorgesehen.

---

## 3. Erweiterte Analyse-Features

### 3.1 Wartungslog

Separate Tabelle fuer:

- Oelwechsel
- TUEV
- Reifenwechsel
- Freie Wartungstypen

Optional:

- Faelligkeitspruefung beim Programmstart

---

### 3.2 Total Cost of Ownership (TCO)

Integration von:

- Versicherung
- Steuer
- Wartung
- Reparaturen

Formel:

`(Kraftstoff + Fixkosten + Wartung) / Nutzungseinheit`

Ziel:

Realistische Kosten pro km bzw. pro Stunde.

---

### 3.3 Export-Strategie

Bereits vorhanden:

- CSV
- JSON

Ausbaubar zu:

- Jahresreports
- Steuerexport
- Asset-Vergleiche

Grundsatz:

Export bleibt rein funktional - keine visuelle GUI-Komponente.

---

### 3.4 Beleg-Management (Light)

Nur:

- Pfadangabe zur Quittung
- Optional: Hash speichern

Kein integrierter Viewer.

---

## 4. SQLite-Strategie

Entscheidung: **Single-File-Datenbank.**

Begruendung:

- Geringe Datenmenge
- Maximale Portabilitaet
- Einfache Backups
- Kein unnoetiger Migrationsaufwand

Philosophie:

> Eine Datei. Deine Daten. Volle Kontrolle.

---

## 5. Architektur-Vision

| Schicht | Aufgabe |
| --- | --- |
| Core Library | CRUD, Verbrauchsmathematik, Statistik-Engine |
| CLI Frontend | Argument-Parsing, Tabellen-Output |
| Storage | SQLite mit `vehicles`, `entries`, `tags` |

Prinzip:

- Business-Logik lebt in der Core-Library
- CLI ist nur Interface
- GUI/Web spaeter moeglich ohne Rewrite

---

## 6. Strategische Leitlinie

Gradwanderung aus:

- Expansion
- Bewusster Perfektionierung

Regel:

Neue Features nur nach sauberer Vorab-Definition.  
Keine Feature-Flut im Core.

---

## 7. Seelen-Prinzipien

### Transparenz

- Offene Exportformate
- Keine versteckten Algorithmen
- Nutzer besitzt seine Daten

### Ehrlichkeit

- Historische Luecken werden kommuniziert
- Keine geschoenten Durchschnittswerte
- Datenqualitaet wird beruecksichtigt

---

## 8. Nicht-Ziele (Explicit Non-Goals)

Um die Identitaet des Projekts zu schuetzen, werden folgende Punkte bewusst ausgeschlossen:

- Kein Enterprise-Flottenmanagement
- Keine komplexe Rollen- und Rechteverwaltung
- Keine Cloud-Zwangsanbindung
- Keine proprietaeren Datenformate
- Keine visuelle GUI-Pflicht

Diese Nicht-Ziele dienen als architektonische Schutzplanke.

---

## 9. Qualitaetskriterien fuer neue Features

Ein Feature darf nur in den Core aufgenommen werden, wenn:

1. Es architektonisch sauber modellierbar ist.
2. Es keine implizite Komplexitaet in anderen Modulen erzeugt.
3. Es mit den Seelen-Prinzipien (Transparenz und Ehrlichkeit) vereinbar ist.
4. Es klar dokumentiert und testbar ist.
5. Es langfristig wartbar bleibt.

Optional umsetzbar als Prozess:

- Mini-Design-Dokument vor Implementierung
- Definition von Datenmodell-Aenderungen
- CLI-Validierungsstrategie vorab festgelegt

---

## 10. Why This Project Exists

Betankungen entstand aus einem persoenlichen Beduerfnis:

- Eigene Tankvorgaenge erfassen
- Verbrauch transparent berechnen
- Unabhaengig von proprietaeren Apps bleiben
- Programmieren lernen durch ein echtes Projekt

Dieses Projekt existiert, weil jemand ein Werkzeug wollte - nicht ein Produkt.

Es steht fuer:

- Selbstbestimmung
- Lernbereitschaft
- Technische Klarheit
- Digitale Eigenverantwortung

---

## 11. Contribution-Philosophie (fuer zukuenftige Offenlegung)

### Architektur vor Feature-Wunsch

Pull Requests werden bewertet anhand von:

- Architektur-Kohaerenz
- Wartbarkeit
- Dokumentation
- Testbarkeit

### Keine Schnellschuesse

Features benoetigen:

- Problemdefinition
- Datenmodell-Auswirkungen
- CLI-Validierungsstrategie
- Rueckwaertskompatibilitaets-Betrachtung

### Schutz der Identitaet

Nicht akzeptiert werden Beitraege, die:

- Das Projekt in Richtung ERP verschieben
- Cloud-Zwang einfuehren
- GUI-Abhaengigkeiten erzwingen

---

## 12. Aenderungsverlauf

| Version | Datum | Aenderung |
| --- | --- | --- |
| 0.1 | 2026-02-23 | Erstfassung Vision-Dokument |
| 0.2 | 2026-02-23 | Contribution + Why ergaenzt |

---

## Fazit

Betankungen ist mehr als eine Tank-App. Es ist ein strukturiertes, ehrliches CLI-Werkzeug fuer Menschen, die Kontrolle ueber ihre Daten und Mobilitaetskosten wollen - ohne Tracking, ohne Werbung, ohne Abhaengigkeiten.

Die Vision waechst. Die Seele bleibt.
