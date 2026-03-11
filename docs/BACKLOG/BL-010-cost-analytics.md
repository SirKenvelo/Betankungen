# BL-010 - Cost Analytics
**Stand:** 2026-03-11
**Status:** next
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

## Hinweis zum aktuellen Stand

- Sprint 8 ist gestartet.
- S8C1/4 liefert eine Cost-MVP-Basis (`--stats cost`) als Textausgabe:
  - fuel-basierte Kosten ueber gueltige Volltank-Zyklen
  - maintenance aktuell als Placeholder (`0`), bis Modul-Integration verfuegbar ist
- S8C2/4 erweitert den MVP um JSON (`--stats cost --json [--pretty]`) mit Export-Meta und `kind: "cost_mvp"`.
- S8C3/4 haertet Guardrails regressionssicher (`--csv`, `--monthly`, `--yearly`, `--dashboard`, `--from/--to`, `--car-id` bleiben fuer Cost-MVP ungueltig).
