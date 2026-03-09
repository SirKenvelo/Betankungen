# BL-010 - Cost Analytics
**Stand:** 2026-03-09
**Status:** geplant
**Typ:** Stats-/Domain-Erweiterung (cross-module)

## Motivation

Ein zentraler Wunsch vieler Nutzer:

Was kostet mein Fahrzeug pro Kilometer?

## Feature

Neuer Statistikmodus:

`--stats cost`

## Beispieloutput

- Fuel cost/km
- Maintenance cost/km
- Total cost/km

## Berechnung

`total_cost = fuel_cost + maintenance_cost`

`cost_per_km = total_cost / gefahrene_km`

## Voraussetzung

Integration von:

- fuel
- maintenance
