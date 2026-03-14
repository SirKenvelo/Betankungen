# BL-007 - Maintenance System
**Stand:** 2026-03-14
**Status:** icebox
**Prioritaet:** mittel
**Typ:** Domain-Erweiterung (Companion-Modul)

## Motivation

Kraftstoffkosten allein geben kein vollstaendiges Bild der Fahrzeugkosten.

Viele Nutzer moechten wissen:

Was kostet mein Auto wirklich?

Dafuer muessen Wartung und Reparaturen erfasst werden.

## Feature

`maintenance`

Moegliche Kategorien:

- `oil_change`
- `service`
- `repair`
- `inspection`
- `other`

## Beispielschema

`maintenance_events`

- `id`
- `car_id`
- `date`
- `type`
- `cost_cents`
- `notes`

## Statistiken

Integration in Kostenanalyse:

`cost_per_km = fuel + maintenance`

## Scope

Optionales Modul:

`betankungen-maintenance`

## Hinweis zum aktuellen Stand

- Sprint 10 ist gestartet.
- S10C1/4 liefert die technische Modul-Basis fuer eigene Fachdaten:
  - Modul-Schema `maintenance_events` + `module_meta(schema_version)`
  - idempotente Migration via `betankungen-maintenance --migrate [--db <path>]`
