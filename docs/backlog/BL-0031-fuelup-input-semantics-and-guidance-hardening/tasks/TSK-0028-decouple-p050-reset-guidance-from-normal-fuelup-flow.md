---
id: TSK-0028
title: P-050-Reset-Guidance vom normalen Fuelup-Flow entkoppeln
status: todo
priority: P2
type: task
tags: [fuelups, guidance, ux, policy]
created: 2026-04-03
updated: 2026-04-03
parent: BL-0031
related:
  - ISS-0010
  - ADR-0014
---
**Stand:** 2026-04-03

# Task
Den spaeteren Runtime-Folgeblock so umsetzen, dass `P-050` nicht mehr als
irrefuehrende Standard-Rueckfrage im normalen Fuelup-Add-Flow erscheint, wenn
Nutzer eine uebliche kurze Distanz seit der letzten Betankung erfassen.

# Notes
- `P-012` fuer grosse Distanzluecken bleibt fachlich und dialogseitig
  unberuehrt.
- Ein moeglicher manueller Reset bei kleiner Distanz bleibt, wenn ueberhaupt,
  eine explizite Ausnahmefuehrung und kein Default-Dialogpfad.
- Nicht Teil dieses Tasks: Car-Kontext-/Receipt-Link-Guidance aus `TSK-0027`.
- Nicht Teil dieses Tasks: Aenderungen an der kanonischen
  Gesamt-Odometer-Semantik aus `ADR-0014`.
- Nicht Teil dieses Tasks: neue Editierbarkeit fuer Fuelups oder ein
  alternativer Trip-/Delta-Write-Path.
- Voraussichtlich betroffen sind spaeter `units/u_fuelups.pas`, die
  zugehoerige Help/Doku und die P-050-/P-012-Regressionsabdeckung.

# Done When
- [ ] Der normale Fuelup-Flow fuer kleine Distanzen fuehrt nicht mehr ueber
      eine irrefuehrende `P-050`-Standard-Rueckfrage.
- [ ] `P-012` bleibt fuer grosse Distanzluecken unveraendert und klar
      abgegrenzt.
- [ ] Ein etwaiger manueller Reset bei kleiner Distanz ist als explizite
      Ausnahmefuehrung statt als Default-Dialog gestaltet.
- [ ] Help/Doku und gezielte Regressionen decken den neuen Guidance-Contract
      ab.
