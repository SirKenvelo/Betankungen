---
id: BL-0030
title: EV Companion Feasibility Spike
status: done
priority: P2
type: research
tags: [module, ev, discovery, 'lane:exploratory']
created: 2026-03-31
updated: 2026-04-01
related:
  - ADR-0005
  - ADR-0007
  - ADR-0008
---
**Stand:** 2026-04-01

# Goal
Den naechsten grossen Domaenenpfad fuer Betankungen als begrenzten
Discovery-/Feasibility-Block vorbereiten und dabei EV-Unterstuetzung bewusst
als Modulpfad schaerfen.

# Motivation
Nach der Stabilisierung der aktiven `1.4.0-dev`-Linie (`BL-0029`) und der
kontrollierten Stationsanreicherung (`BL-0019`) ist die naechste offene Frage
nicht ein weiteres kleines Core-Feature, sondern die Richtung der naechsten
groesseren Domaenenerweiterung.

Mit `ADR-0005` und `ADR-0007` ist der Modulpfad fuer optionale,
domaenenspezifische Erweiterungen bereits architektonisch vorbereitet. EV als
Companion-Modul ist damit die risikoaermere erste Discovery-Richtung gegenueber
einem Core-Ausbau wie Household Drivers.

# Scope
In Scope:
- Discovery fuer ein moegliches Modul `betankungen-ev`.
- Minimalen fachlichen Umfang fuer Ladevorgaenge, kWh, Kosten und Ladeorte
  definieren.
- Grenzen zwischen Core, Modul-DB und Modul-CLI explizit machen.
- Feasibility-Kriterien und einen klaren Nicht-Ziel-Rahmen fuer einen
  spaeteren Implementierungsblock formulieren.

Out of Scope:
- Produktive EV-Implementierung in diesem Block.
- Generisches `energy_events`-Refactoring im Core.
- Household-Drivers-/Shared-Cars-Ausbau.
- GUI-, Karten- oder Sync-Arbeit.

# Risks
- Discovery driftet in ein zu grosses generisches Energiemodell ab.
- EV-spezifische Sonderlogik laeuft in den Core, statt die Modulgrenzen zu
  respektieren.
- Ohne klare Minimaldefinition wird aus dem Spike ein unendlicher
  Forschungsblock.

# Output
Ein klarer, referenzierbarer Discovery-Backlog fuer EV als naechste
strategische Domaenenerweiterung, inklusive priorisierter Folge-Tasks und
abgegrenzter Nicht-Ziele. `TSK-0024` liefert die Scope-/Boundary-Baseline;
`TSK-0025` schliesst den Block jetzt mit einem minimalen Charging-Event-
Modell und expliziten Storage-Grenzen ab.

# Discovery Result
- Ein erster EV-MVP kann auf einem kleinen modul-lokalen Modell aufsetzen:
  `charging_events`, optionale `charging_locations` und `module_meta`.
- Das minimale Event bleibt bewusst klein: `car_id`, `event_date`,
  `energy_wh` und `cost_cents` sind verpflichtend; `odometer_km`,
  `location_id` und `notes` bleiben optional.
- Der Core wird fuer `1.4.x` nicht auf ein generisches `energy_events`-
  Modell umgebaut; `stations` bleiben kein kanonischer Ladeort-Speicher.
- Damit ist ein separater EV-MVP-Folgeblock fachlich vorbereitet, ohne den
  aktiven Core-Scope aufzuweichen.

# Derived Tasks
- `TSK-0024` - EV-Modul-Scope und Contract-Rahmen definieren. (done)
- `TSK-0025` - Minimales Charging-Event-Modell und Storage-Grenzen evaluieren. (done)
