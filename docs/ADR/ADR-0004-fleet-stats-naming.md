# ADR-0004: Fleet-Stats-Naming (`--stats fleet` vs. `--stats cars`)
**Stand:** 2026-03-07
**Status:** proposed
**Datum:** 2026-03-07

## Kontext

Fuer kuenftige aggregierte Auswertungen ueber mehrere Fahrzeuge wird ein klarer CLI-Name benoetigt.
Zur Wahl stehen `--stats fleet` und `--stats cars`.

## Entscheidungsstand

Aktuell offen.
Tendenz: `--stats fleet` wirkt semantisch sauberer fuer Aggregat-/Sammelmodus als `--stats cars`.

## Offene Pruefpunkte

- Versteht ein neuer Nutzer ohne Doku sofort den Unterschied zu car-spezifischen Stats?
- Passt das Naming konsistent zu bestehender CLI-Terminologie?
- Ist der Begriff zukunftssicher fuer moegliche Flotten-Subfeatures?

## Vorlaeufige Konsequenzen

- Bis zur finalen Entscheidung kein oeffentlicher CLI-Contract fuer diesen Stats-Modus.
- Backlog-Items mit Bezug auf Aggregat-Stats referenzieren vorlaeufig dieses ADR.

## Referenzen

- `docs/BACKLOG.md`
- `docs/STATUS.md`
