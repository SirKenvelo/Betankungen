# BL-008 - Tire Management
**Stand:** 2026-03-09
**Status:** icebox
**Typ:** Domain-Erweiterung (Companion-Modul)

## Motivation

Reifen sind ein relevanter Kostenfaktor.

Viele Fahrzeuge haben:

- Sommerreifen
- Winterreifen
- Allwetterreifen

Zusaetzlich entstehen:

- Lagerkosten
- Wechselkosten
- Felgenkosten

## Datenmodell

`tiresets`

- `id`
- `car_id`
- `name`
- `type`
- `purchase_cost`
- `purchase_date`
- `notes`

Installation:

`tire_installations`

- `tireset_id`
- `installed_from`
- `installed_to`
- `odometer_from`
- `odometer_to`

## Statistiken

- `km_per_tireset`
- `cost_per_km`
