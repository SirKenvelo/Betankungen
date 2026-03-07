# ADR-0003: Schema-Bump in kleinen, getrennten Schritten
**Stand:** 2026-03-07
**Status:** accepted
**Datum:** 2026-03-07

## Kontext

Es stehen mehrere moegliche Weiterentwicklungen im Raum (VIN, Indexing, Export-Meta).
Ein grosser Sammel-Bump erschwert Tests, Rollback-Analyse und Fehlereingrenzung.

## Entscheidung

Schema-Aenderungen werden bewusst getrennt umgesetzt:
VIN, Indexing und eventuelle Export-Meta werden als kleinere, klar testbare Migrationen geplant.

## Konsequenzen

- Kleinere Migrationspakete mit besserer Traceability.
- Niedrigeres Risiko bei Regressionen und klarere Verantwortlichkeit pro Schritt.
- Einfachere Smoke-/Policy-Absicherung je Migration.

## Referenzen

- `docs/ARCHITECTURE.md`
- `docs/STATUS.md`
