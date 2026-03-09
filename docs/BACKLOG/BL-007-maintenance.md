# BL-007 - Maintenance System
**Stand:** 2026-03-09
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
