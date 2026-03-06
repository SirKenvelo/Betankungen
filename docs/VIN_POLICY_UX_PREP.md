# VIN Policy & UX-Prep
**Stand:** 2026-03-06

## 1) Grundsatz

VIN ist empfohlen, aber nicht verpflichtend.

Fahrzeuge werden intern bereits eindeutig ueber `cars.id` unterschieden.

VIN ist ein zusaetzlicher Qualitaetsbaustein fuer Dokumentation, Verwechslungsschutz und spaetere Auswertungen/Integrationen.

Eine Pflicht wuerde bestehende Datensaetze, Erstanlage direkt nach Kauf und einfache CLI-Flows unnoetig verkomplizieren.

## 2) Warum optional fachlich korrekt ist

Zwei Fahrzeuge koennen in seltenen Faellen aehnliche Stammdaten haben (Marke/Modell/Start-km), bleiben in Betankungen aber trotzdem verschiedene Cars, solange sie verschiedene `cars.id` besitzen.

Die VIN verbessert die fachliche Eindeutigkeit, ersetzt aber nicht die interne Objektidentitaet.

Damit ist VIN ein starkes Attribut, aber kein Primaerschluessel-Ersatz.

## 3) Normalisierung (spaetere Runtime-Regel)

- `trim`
- `uppercase`
- keine fuehrenden/trailing Leerzeichen
- Speicherung immer in normalisierter Form

Beispiel:

- Input: `wdb12345678901234`
- Stored: `WDB12345678901234`

## 4) Validierung (Policy light)

Zielbild: 17 Zeichen.

Wenn VIN gesetzt ist und Laenge `!= 17`:

- Warning + Confirm
- kein Hard Error in `0.8.x`

Begruendung: Legacy-Faelle, unvollstaendige Eingabe bei Erstanlage, bewusste spaetere Nachpflege.

## 5) Registrierungsdokumente

Es werden keine Dokumente gespeichert, nur Referenzen:

- `reg_doc_path`
- `reg_doc_sha256`

`reg_doc_path` verweist auf einen lokal verwalteten Scan/Pfad.

`reg_doc_sha256` ist optionaler Integritaets-/Referenzwert.

Fahrzeugbrief wird bewusst nicht unterstuetzt.

## 6) CLI-UX (noch nicht verdrahtet)

Zukuenftige Richtung, z. B. in `--edit cars`:

```text
VIN:             WDB12345678901234
Registration:    ~/docs/car1_fahrzeugschein.pdf
Doc SHA256:      7d9f...
```

Aktuell gilt bewusst:

- Schema + Migration vorhanden
- Policy + UX vorbereitet
- Runtime-Wiring folgt spaeter

## 7) Test-Ideen fuer spaeter

Wenn VIN spaeter aktiv verdrahtet wird, pruefen Tests:

- Normalisierung (`trim` + `uppercase`)
- Warning bei Laenge `!= 17`
- Speicherung optionaler Dokument-Referenzen
- kein Zwang fuer bestehende Cars ohne VIN
