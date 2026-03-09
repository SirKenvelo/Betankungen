# BL-003 - Household Drivers / Shared Cars
**Stand:** 2026-03-09
**Status:** icebox
**Typ:** Domain-Erweiterung

## Ziel

Abbildung von gemeinsam genutzten Fahrzeugen innerhalb eines Haushalts
(Familie, WG, Partner etc.).

## Kontext

Viele reale Nutzungsszenarien umfassen mehrere Fahrer, die sich ein oder
mehrere Fahrzeuge teilen. Beispiele:

- Familie mit 1-2 Autos
- WG mit gemeinsamem Fahrzeug
- Eltern + erwachsene Kinder im gleichen Haushalt

Aktuell existiert nur die Beziehung:

    fuelup -> car

Geplant ist eine optionale Erweiterung:

    fuelup -> car
    fuelup -> driver (optional)

## Moegliche Struktur

drivers
-------
id
display_name
note
active

fuelups
-------
driver_id (nullable)

## Moegliche spaetere Erweiterungen

- Stats pro Fahrer
- Fahrer-Historie pro Fahrzeug
- Kostenanteile (optional, nicht Teil der ersten Iteration)

## Nicht-Ziele

- kein Login-/User-System
- keine Authentifizierung
- keine Rollenverwaltung
