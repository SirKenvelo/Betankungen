# ADR-0001: CSV-Contract-Versionierung ohne Kommentarzeilen
**Stand:** 2026-03-07
**Status:** accepted
**Datum:** 2026-03-07

## Kontext

Stats-CSV wird als strict, maschinenlesbarer Output genutzt.
Kommentarzeilen im CSV wuerden Parser-Komplexitaet und Ambiguitaeten erhoehen.

## Entscheidung

Wir nutzen eine explizite Spalte `contract_version` fuer den CSV-Contract.
Im strict CSV werden keine Kommentarzeilen eingefuehrt.

## Konsequenzen

- CSV bleibt robust maschinenlesbar und parserfreundlich.
- Contract-Evolution laeuft ueber versionsgebundene Spalten-/Header-Regeln.
- Human-readable Kontext bleibt in Doku/README, nicht im CSV selbst.

## Referenzen

- `docs/EXPORT_CONTRACT.md`
- `tests/domain_policy/README.md`
