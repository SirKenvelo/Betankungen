# ADR-0004: Fleet-Stats-Naming (`--stats fleet`)
**Stand:** 2026-03-09
**Status:** accepted
**Datum:** 2026-03-07

## Kontext

Mit der Einfuehrung von Multi-Car-Unterstuetzung besitzt *Betankungen* die
Faehigkeit, mehrere Fahrzeuge in einer einzelnen Datenbank zu verwalten.

Die bestehenden Statistikfunktionen arbeiten aktuell immer im Kontext eines
einzelnen Fahrzeugs (`car_id`).

Fuer zukuenftige Auswertungen ueber mehrere Fahrzeuge hinweg wird ein klar
definierter CLI-Modus benoetigt.

Beispiele fuer solche aggregierten Statistiken:

- Gesamtverbrauch ueber alle Fahrzeuge
- Gesamtmenge getankter Kraftstoff
- Vergleich von Fahrzeugen innerhalb einer Datenbank
- Kostenanalyse ueber mehrere Fahrzeuge hinweg

Der CLI-Name fuer diesen Aggregatmodus musste festgelegt werden.

Zur Diskussion standen zwei Varianten:

- `--stats cars`
- `--stats fleet`

## Entscheidungsfindung

Die Variante `--stats cars` wurde verworfen, da sie semantisch mehrdeutig ist.

Ein neuer Nutzer koennte dies interpretieren als:

- Statistiken pro Auto
- Statistiken ueber mehrere Autos
- eine Liste von Fahrzeugen

Der Begriff beschreibt also nicht eindeutig einen Aggregatmodus.

Die Variante `--stats fleet` beschreibt dagegen klar:

> Statistiken ueber eine Gruppe von Fahrzeugen.

Dieser Begriff ist unabhaengig von der tatsaechlichen Anzahl der Fahrzeuge und
bleibt semantisch stabil fuer zukuenftige Erweiterungen.

## Entscheidung

Der CLI-Modus fuer aggregierte Fahrzeugstatistiken wird:

`--stats fleet`

## CLI-Semantik

Die Statistikmodi folgen damit einer klaren Trennung:

| Modus | Bedeutung |
|------|-----------|
| `--stats car` | Statistik eines einzelnen Fahrzeugs |
| `--stats fleet` | Aggregierte Statistik ueber alle Fahrzeuge |

Diese Terminologie vermeidet Mehrdeutigkeit und bleibt auch fuer neue Nutzer
ohne Dokumentation intuitiv verstaendlich.

## Zukunftssicherheit

Der Begriff **fleet** bleibt auch fuer zukuenftige Szenarien sinnvoll, z. B.:

- Haushalte mit mehreren Fahrzeugen
- Oldtimer-Sammlungen
- kleine Betriebe
- landwirtschaftliche Maschinenparks

Damit unterstuetzt der Begriff implizit auch moegliche zukuenftige
Erweiterungen in Richtung "Fuhrpark light", ohne dass das Projekt in Richtung
Enterprise-Flottenmanagement verschoben wird.

## Konsequenzen

1. Der offizielle CLI-Begriff fuer aggregierte Fahrzeugstatistiken lautet `fleet`.
2. Alle zukuenftigen Features fuer fahrzeuguebergreifende Statistiken verwenden diesen Begriff konsistent.
3. Backlog-Items mit Bezug auf Multi-Car-Auswertungen referenzieren `fleet` als Terminologie.
4. Die Variante `--stats cars` gilt als verworfen.

## Referenzen

- `docs/VISION.md`
- `docs/STATUS.md`
- `docs/BACKLOG.md`
