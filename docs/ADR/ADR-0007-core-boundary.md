# ADR-0007: Core Boundary - Core vs Module
**Stand:** 2026-03-09
**Status:** accepted
**Datum:** 2026-03-09

## Kontext

Mit wachsender Funktionalitaet besteht die Gefahr, dass neue Features direkt im
Core implementiert werden.

Dies wuerde langfristig zu:

- steigender Komplexitaet
- schwer wartbarer Architektur
- unklaren Verantwortlichkeiten

fuehren.

Das Projekt benoetigt daher eine klare Grenze zwischen Core-Funktionalitaet und
optionalen Erweiterungen.

## Entscheidung

Das Projekt folgt der Regel:

Core = universelle Mobilitaetsdaten
Module = domaenenspezifische Erweiterungen

## Core-Verantwortung

Der Core enthaelt ausschliesslich Funktionen, die fuer jede Mobilitaetsform
sinnvoll sind.

Beispiele:

- cars
- fuelups
- stations
- stats
- usage tracking
- Kostenberechnung

Core-Code muss:

- generisch sein
- minimal bleiben
- ohne Speziallogik auskommen

## Module

Domaenenspezifische Funktionen werden als Module umgesetzt.

Beispiele:

- ev_charging
- maintenance
- inspections
- tires
- agriculture

Module duerfen:

- eigene Tabellen
- eigene CLI-Kommandos
- eigene Stats

einfuehren.

Der Core bleibt davon unberuehrt.

## Konsequenzen

Neue Features muessen zuerst pruefen:

1. Gehoert das zur universellen Mobilitaetslogik?
2. Oder ist es ein Spezialfall?

Wenn Spezialfall -> Modul.

## Ziel

Schutz der Core-Architektur und langfristige Wartbarkeit.
