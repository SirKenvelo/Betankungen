# ADR-0006: Household Drivers
**Stand:** 2026-03-09
**Status:** proposed
**Datum:** 2026-03-09

## Kontext

Viele reale Nutzungsszenarien umfassen mehrere Fahrer,
die sich ein Fahrzeug teilen:

- Familie mit gemeinsam genutzten Autos
- WG mit gemeinsamem Fahrzeug
- Partnerhaushalte

Aktuell kennt das Datenmodell nur Fahrzeuge.

## Entscheidung (Vorschlag)

Ein optionales Domain-Objekt **driver** wird eingefuehrt.

Struktur:

drivers
-------
id
display_name
note
active

Fuelups koennen optional einen Fahrer referenzieren:

fuelups
-------
driver_id (nullable)

## Ziele

- Nutzungsauswertung pro Fahrer
- bessere Abbildung realer Haushaltsstrukturen

## Nicht-Ziele

- kein User-/Login-System
- keine Authentifizierung
- keine Rollenverwaltung

Drivers sind rein **fachliche Entitaeten**.

## Referenzen

- `docs/BACKLOG/BL-003-household-drivers-shared-cars.md`
- `docs/ARCHITECTURE.md`
