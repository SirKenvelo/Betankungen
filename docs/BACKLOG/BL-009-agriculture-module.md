# BL-009 - Agriculture Module
**Stand:** 2026-03-09
**Status:** icebox
**Typ:** Domain-Erweiterung (Companion-Modul)

## Motivation

Viele landwirtschaftliche Maschinen verbrauchen Kraftstoff:

- Traktoren
- Maehdrescher
- Generatoren
- Motorsaegen

Der Verbrauch wird selten sauber dokumentiert.

## Modul

`betankungen-agriculture`

Assets:

- `tractor`
- `combine`
- `chainsaw`
- `generator`

Energie:

- `diesel`
- `gasoline`

## Besonderheiten

Einige Maschinen nutzen:

- Betriebsstunden statt Kilometer

Dies koennte spaeter ueber eine generische `usage_unit` umgesetzt werden.

## Zielgruppe

- Landwirte
- Hofbetriebe
- Maschinenparks
