---
id: BL-0031
title: Fuelup Input Semantics and Guidance Hardening
status: in_progress
priority: P2
type: improvement
tags: [fuelups, ux, semantics, guidance, 'lane:planned']
created: 2026-04-02
updated: 2026-04-03
related:
  - ADR-0014
  - ISS-0008
  - ISS-0009
  - ISS-0010
  - BL-0021
  - BL-0029
  - BL-0032
---
**Stand:** 2026-04-03

# Goal
Die Fuelup-Eingabe fuer neue und gelegentliche Nutzer semantisch klarer und
dialogseitig fuehrender machen, ohne die bestehende Core-Persistenz oder
Odometer-Policy zu verbiegen.

# Motivation
Reale Nutzung des Add-Flows hat vier zusammenhaengende Schwachstellen
sichtbar gemacht:

- `Kilometerstand (km)` ist als Prompt zu offen und verschweigt die
  kanonische Gesamt-Odometer-Semantik
- die aktuelle Car-Zuordnung ist im Add-Flow nicht sichtbar genug
- der Vorab-Contract fuer `--receipt-link` ist im interaktiven Lauf zu leicht
  zu uebersehen, obwohl Fuelups append-only sind
- lokale Receipt-Pfade aus Drag-and-Drop oder Shell-History sind fuer Nutzer
  plausibel, werden aber noch nicht auf einen kanonischen `file://`-Write-Path
  normalisiert
- lokale Vertipper in Receipt-Links bleiben heute vor dem append-only-Insert
  unbemerkt, obwohl der Nachbearbeitungspfad bewusst gesperrt ist
- die `P-050`-Rueckfrage fuer einen bewussten Zyklus-Reset bei kleiner
  Distanz wirkt in realer Nutzung zu nah am normalen Fuelup-Flow und klingt
  zu leicht wie eine Standard-Nachfrage nach einer vergessenen Betankung

Die technische Basis ist bereits korrekt. Was fehlt, ist eine bewusst
geschnittene Guidance-/Semantik-Haertung fuer die naechste Core-UX-Stufe.
Der juengste Delta-Audit fuer P1/P2 blieb zwar gruen, der spaetere reale
Nutzungsnachlauf brachte aber zusaetzlich einen orange markierten
`P-050`-Folgebefund hervor, der jetzt getrennt nachgezogen wird.

# Scope
In Scope:
- Guidance fuer den kanonischen Fuelup-Kilometerstandsbegriff auf
  Gesamt-Odometer-Basis
- sichtbare Car-Kontext-Fuehrung im Add-Flow und in zugehoeriger Help/Doku
- klare Vorab-Hinweise fuer `--receipt-link` im Zusammenhang mit append-only
  Fuelups
- kanonische Normalisierung lokaler Receipt-Pfade auf einen stabilen
  `file://`-Speicherwert
- Guidance fuer lokale Receipt-Links mit fehlender Datei, ohne sofort einen
  unbarmherzigen Hard-Error zu erzwingen
- klare Trennung zwischen `P-012` fuer grosse Distanzluecken und einer
  moeglichen spaeteren Ausnahmefuehrung fuer bewusste Reset-Faelle bei
  kleiner Distanz
- saubere Verknuepfung zwischen Issue-, ADR-, Backlog- und Folge-Task-Ebene

Out of Scope:
- Runtime-Implementierung in diesem Rahmungsblock
- neuer Trip-/Delta-Input als alternative Erfassungslogik
- neue Fuelup-Editierbarkeit oder nachtraeglicher Receipt-Link-Write-Path
- verpflichtende XDG-Belegablage oder sofortige app-verwaltete Receipt-Kopie
- OSC8-/Label-Rendering wie `[Tankbeleg]` als erste Loesungsstufe
- Vermischung mit EV-Discovery, Household Drivers oder groesseren CLI-Umbauten

# Risks
- Guidance-Arbeit driftet in einen groesseren UI-Umbau statt bei klaren
  Dialog- und Hilfetext-Grenzen zu bleiben.
- Die Kilometerstandsfrage wird fachlich erneut aufgeweicht, obwohl
  `ADR-0014` den kanonischen Gesamt-Odometer festzieht.
- Receipt-Link- und Car-Resolver-Themen werden als Architekturproblem
  missverstanden, obwohl es primaer UX-/Dialogfragen sind.
- Die `P-050`-Rueckfrage bleibt semantisch an normalen kurzen Fuelups
  kleben und verwaessert damit die klare Rolle von `P-012` fuer grosse
  Distanzluecken.
- Eine zu harte Existenzpruefung fuer lokale Receipt-Dateien blockiert
  legitime Faelle wie spaet gemountete Ordner oder bewusst vorgezogene
  Eintraege ohne Belegdatei vor Ort.
- Die spaetere Hybrid-Idee fuer app-verwaltete Belegspeicherung wird zu frueh
  in den aktuellen Guidance-Block hineingezogen statt als eigener Folge-BL
  sauber abgetrennt.

# Output
Ein umsetzungsreifer Hardening-Block fuer den laufenden Fuelup-UX-Sprint:
`TSK-0026` ist umgesetzt und zieht Prompting, Help und Benutzerdoku auf die
akzeptierte Gesamt-Odometer-Semantik aus `ADR-0014`. Offen bleiben der zweite
Problemfall (`ISS-0009`), Receipt-Link-Normalisierung/Existenz-Guidance und
die dazu sauber abgegrenzte Folgeaufgabe `TSK-0027`. Zusaetzlich haelt
`ISS-0010` den spaeteren Realnutzungsbefund fest, dass `P-050` im normalen
Flow fuer kurze Distanzen irrefuehrend wirkt; `TSK-0028` schneidet daraus
einen separaten Folgeauftrag, der `P-050` spaeter vom normalen Fuelup-Flow
entkoppeln soll, ohne `P-012` fuer grosse Distanzluecken anzutasten. Eine
moegliche spaetere Hybrid-Strategie fuer verwaltete XDG-Belegspeicherung
bleibt als separater Folge-BL (`BL-0032`) vorgemerkt.

# Derived Tasks
- `TSK-0026` - Fuelup-Kilometerstands-Wording und Guidance auf den
  Gesamt-Odometer ausrichten. (done)
- `TSK-0027` - Car-Kontext und Receipt-Link-Timing im Fuelup-Add-Flow
  sichtbar machen, lokale Receipt-Pfade normalisieren und lokale
  Existenz-Guidance ergaenzen. (todo)
- `TSK-0028` - `P-050`-Reset-Guidance vom normalen Fuelup-Flow entkoppeln,
  waehrend `P-012` fuer grosse Distanzluecken unveraendert bleibt. (todo)
