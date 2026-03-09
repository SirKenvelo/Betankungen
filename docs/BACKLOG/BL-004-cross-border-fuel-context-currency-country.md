# BL-004 - Cross-Border Fuel Context (Currency / Country)
**Stand:** 2026-03-09
**Status:** icebox
**Typ:** Domain-Erweiterung

## Kontext

Fuelups koennen ausserhalb des Heimatlandes stattfinden
(z. B. Urlaubsfahrten ins Ausland).

Unterschiede:

- andere Waehrung
- andere Preisstruktur
- teilweise andere Kraftstoff-Bezeichnungen

Aktuell werden Preise implizit als EUR behandelt.

## Ziel

Fuelups sollen optional folgende Zusatzinformationen speichern:

fuelups
-------
currency_code   (ISO-4217, z. B. EUR, PLN)
country_code    (ISO-3166-1 alpha-2, z. B. DE, PL)

## Prinzipien

- gespeicherte Werte bleiben in Originalwaehrung
- keine automatische Wechselkurs-Umrechnung
- Auswertung in Fremdwaehrung erfolgt spaeter optional

## Nicht-Ziele

- keine automatische FX-Berechnung
- kein Online-Wechselkurs-Service
