---
id: TSK-0027
title: Car-Kontext und Receipt-Link-Timing im Fuelup-Add-Flow sichtbar machen
status: done
priority: P2
type: task
tags: [fuelups, cars, receipts, ux]
created: 2026-04-02
updated: 2026-04-03
parent: BL-0031
related:
  - ISS-0009
  - BL-0021
---
**Stand:** 2026-04-03

# Task
Den Fuelup-Add-Flow so fuehren, dass Nutzer den aktiven Fahrzeugkontext und
den Vorab-Charakter von `--receipt-link` sehen, bevor ein neuer Fuelup
gespeichert wird. Lokale Receipt-Pfade sollen dabei auf einen kanonischen
`file://`-Wert normalisiert und bei fehlender lokaler Datei nicht still
akzeptiert werden.

# Notes
- Kein neuer Fuelup-Edit-Path.
- Kein zweiter Resolver-Modus; vorhandene 0/1/>1-Car-Regeln bleiben bestehen.
- Voraussichtlich betroffen: `units/u_fuelups.pas`, `units/u_car_context.pas`,
  `units/u_cli_help.pas` und die Benutzerdoku.
- Lokale Receipt-Pfade (absolute Pfade, Drag-and-Drop aus dem Dateimanager)
  bleiben zulaessig, sollen aber vor dem Write-Path in einen kanonischen
  `file://`-Speicherwert ueberfuehrt werden.
- Fuer lokale Pfade/`file://`-URIs ist eine Existenzpruefung mit
  Warning+Confirm sinnvoller als ein pauschaler Hard-Error.
- Nicht Teil dieses Tasks: ein app-verwalteter XDG-Belegordner oder eine
  automatische Belegkopie; das bleibt einem moeglichen Folge-BL ueberlassen.
- Nicht Teil dieses Tasks: OSC8-/Label-Ausgabe wie `[Tankbeleg]` als
  separate spaetere Komfortschicht.

# Done When
- [x] Der aktive Car-Kontext ist im Add-Flow sichtbar genug.
- [x] `--receipt-link` wird als Vorab-Flag klar kommuniziert.
- [x] Lokale absolute Receipt-Pfade werden auf einen kanonischen
      `file://`-Wert normalisiert.
- [x] Lokale Receipt-Pfade oder `file://`-URIs mit fehlender Datei liefern
      eine explizite Warning+Confirm-Guidance statt stiller Annahme.
- [x] Help/Doku und Regressionen decken den Guidance-Contract ab.
