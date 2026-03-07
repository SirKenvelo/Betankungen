# ADR-0002: VIN-Validierung als Warning+Confirm
**Stand:** 2026-03-07
**Status:** accepted
**Datum:** 2026-03-07

## Kontext

VIN ist in der aktuellen Produktphase optional vorbereitet.
Ein sofortiger Hard Error bei VIN-Laenge ungleich 17 waere fuer den aktuellen Scope zu strikt.

## Entscheidung

VIN-Laenge ungleich 17 wird als Warning+Confirm behandelt.
Ein Hard Error wird erst aktiviert, wenn echte VIN-Workflows spaeter verbindlich erzwungen werden.

## Konsequenzen

- Nutzerfluss bleibt flexibel waehrend der Vorbereitungsphase.
- Die Regel ist klar vorhaeufig und kann spaeter gehaertet werden.
- Migrations-/UX-Aufwand fuer ein spaeteres Hardening bleibt planbar.

## Referenzen

- `docs/VIN_POLICY_UX_PREP.md`
- `docs/ARCHITECTURE.md`
