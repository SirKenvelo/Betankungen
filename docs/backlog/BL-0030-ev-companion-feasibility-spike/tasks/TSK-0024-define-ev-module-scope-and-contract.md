---
id: TSK-0024
title: EV-Modul-Scope und Contract-Rahmen definieren
status: done
priority: P2
type: task
tags: [module, ev, discovery]
created: 2026-03-31
updated: 2026-04-01
parent: BL-0030
related:
  - ADR-0005
  - ADR-0007
  - ADR-0008
---
**Stand:** 2026-04-01

# Task
Den minimalen Scope fuer ein moegliches Companion-Modul `betankungen-ev`
festziehen und den notwendigen Contract-Rahmen gegenueber dem Core
dokumentieren.

# Notes
- Fokus auf einen kleinen, implementierbaren Discovery-Rahmen statt auf einen
  kompletten EV-Funktionskatalog.
- Zu klaeren sind insbesondere:
  - minimaler CLI-Zuschnitt
  - erwartete Modul-Metadaten
  - Abgrenzung zwischen Core-Daten und Modul-Daten
  - Nicht-Ziele fuer den ersten EV-Block
- `docs/MODULES_ARCHITECTURE.md` bleibt die technische Leitplanke.

# Decision Summary
- Der minimale fachliche Scope fuer `betankungen-ev` ist auf modulare
  `charging`-Flows begrenzt: Ladevorgaenge, Energiemenge, Kosten,
  car-scoped Listen/Stats und modul-eigene Ladeort-Referenzen.
- Der Core bleibt fuer `cars`, `fuelups`, `stations`, Basis-Stats,
  Konfiguration und Modul-Discovery zustaendig; die einzige harte fachliche
  EV-Kopplung im ersten Block ist `car_id`.
- Der erwartete CLI-/Contract-Rahmen ist bewusst klein:
  `--module-info`, `--migrate`, `--add charging`, `--list charging`,
  `--stats charging`.

# Boundary Guardrails
- Kein generisches `energy_events`-Refactoring im Core.
- Kein neues Core-Target `--add charging` und keine EV-spezifischen Flags im
  Core fuer `1.4.x`.
- Keine implizite Wiederverwendung der Core-`stations` als kanonischer
  Ladeort-Speicher im ersten EV-Block; Standort- und Anbieterlogik bleiben
  modul-eigene Verantwortung.
- Keine Household-Drivers-/Shared-Cars-, GUI-, Karten-, Sync- oder
  Fuelup-UX-Arbeit in diesem Task.
- Keine vorgezogene cross-module-Kostenaggregation; EV-Stats bleiben im
  ersten Schritt modul-lokal.

# Handover to TSK-0025
- Minimales Charging-Event-Payload festziehen
  (`event_date`, Energiemenge, Kosten, optionale vs. verpflichtende
  Zusatzfelder wie `odometer_km`).
- Storage-Grenzen konkretisieren: Tabellenzuschnitt, Modul-Meta-Keyspace,
  Ladeort-/Anbieter-Modell und FK-Nutzung.
- JSON-/Stats-Payload fuer einen moeglichen ersten `charging`-Contract nur so
  weit konkretisieren, wie es fuer ein MVP noetig ist.

# Done When
- [x] Minimaler EV-Modul-Scope ist beschrieben
- [x] Contract- und Boundary-Leitplanken sind dokumentiert
- [x] Doku aktualisiert
