---
id: TSK-0010
title: Define receipt-link contract and privacy guardrails
status: done
priority: P1
type: task
tags: [receipts, links, contract, privacy]
created: 2026-03-18
updated: 2026-03-18
parent: BL-0021
related:
  - BL-0021
  - POL-002
  - POL-003
---
**Stand:** 2026-03-18

# Task
Definiere den Receipt-Link-Contract (Datenfeld, Validierung,
Ausgabe-/JSON-Sichtbarkeit) inklusive Privacy-Guardrails fuer Pfadangaben.

# Notes
- Keine Speicherung von Bild-Binaries in SQLite.
- Append-only-Regeln fuer Fuelups bleiben unveraendert.
- Contract muss leer/gesetzt/ungueltig klar unterscheiden.

# Done When
- [x] Feld-/Validierungsregeln sind eindeutig dokumentiert.
- [x] Ausgabe- und JSON-Contract sind konsistent spezifiziert.
- [x] Privacy-Regeln fuer Pfad-/URI-Daten sind nachvollziehbar festgehalten.
