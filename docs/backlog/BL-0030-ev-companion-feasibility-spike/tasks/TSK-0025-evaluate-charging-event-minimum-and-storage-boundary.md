---
id: TSK-0025
title: Minimales Charging-Event-Modell und Storage-Grenzen evaluieren
status: done
priority: P2
type: task
tags: [module, ev, discovery, schema]
created: 2026-03-31
updated: 2026-04-01
parent: BL-0030
related:
  - ADR-0007
  - ADR-0008
---
**Stand:** 2026-04-01

# Task
Das minimale fachliche Modell fuer EV-Ladevorgaenge evaluieren und die
Storage-Grenzen zwischen Core und moeglichem EV-Modul klar beschreiben.

# Notes
- Discovery soll eine kleine, realistische erste Event-Struktur fuer
  Ladevorgaenge skizzieren (z. B. kWh, Kosten, Datum, Standortbezug).
- Es soll explizit geklaert werden, warum dieser Block nicht als generisches
  Core-`energy_events`-Modell startet.
- Die Entscheidung muss den Core gegen vorschnelle Schema-Aufweichung schuetzen
  und gleichzeitig einen spaeteren Modulpfad praktisch nutzbar machen.

# Decision Summary
- Das minimale Event-Modell fuer einen ersten EV-Block bleibt klein und
  datenbanknah: `car_id`, `event_date`, `energy_wh` und `cost_cents` sind
  Pflichtfelder.
- `odometer_km`, `location_id` und `notes` bleiben im ersten Schritt
  optional. Damit lassen sich sowohl oeffentliche als auch private bzw.
  kostenlose Ladevorgaenge abbilden, ohne die Eingabe schon auf ein grosses
  EV-Fachmodell hochzuziehen.
- Nicht zum Minimal-Pflichtmodell gehoeren fuer den ersten Block:
  `started_at`, `ended_at`, Ladeleistung, SoC-Werte, Tarif-/Session-IDs,
  Connector-Typen oder ein eigener Provider-Identifier pro Event.

# Minimal Cases
- Kostenpflichtiger oeffentlicher Ladevorgang mit Energiemenge, Datum und
  optionalem Ladeortbezug.
- Kostenloser oder pauschaler Ladevorgang (`cost_cents = 0`) ohne
  Tarifmodell.
- Ladevorgang mit optionalem `odometer_km`, damit spaetere
  fahrzeugbezogene Auswertungen moeglich bleiben, ohne den Wert sofort fuer
  jeden Event zu erzwingen.

# Storage Boundary
- Der erste EV-Block bleibt vollstaendig modul-lokal und verwendet nur:
  `module_meta`, `charging_events` und `charging_locations`.
- `charging_events` referenziert den Core ausschliesslich ueber `car_id`.
  Weitere Core-Tabellen werden weder erweitert noch als Pflicht-FKs
  vorausgesetzt.
- `charging_locations` bleibt ein leichter Modul-Speicher fuer
  Ladeort-Kontext (`label` verpflichtend, `provider_name`/`address_text`/
  `notes` optional). Die Core-`stations` werden bewusst nicht als
  kanonischer Ladeort-Speicher wiederverwendet.
- `charging_events.location_id` darf optional auf `charging_locations.id`
  zeigen. Das erlaubt eine spaetere Ortsverdichtung, ohne Home-/Ad-hoc-
  Events im MVP zu blockieren.
- Ein separates Modul-Provider-Register ist fuer diesen ersten Block nicht
  noetig. Provider-/Operator-Kontext bleibt vorerst ein optionales
  Ladeort-Attribut statt einer neuen gemeinsamen Core-Entitaet.

# Why Not `energy_events`
- Ein generisches Core-`energy_events`-Modell wuerde die aktive
  `1.4.x`-Linie zu frueh auf ein neues universelles Schema zwingen.
- Fuelups und Charging unterscheiden sich bereits im Minimalfall in
  Einheitensystem, Ortsmodell, Preislogik und optionalen Zusatzfeldern.
  Eine vorschnelle Generalisierung wuerde entweder viele sparsame
  Sonderfelder erzeugen oder den EV-Fall fachlich zu frueh nivellieren.
- Der Modulpfad schuetzt die stabilen Core-Contracts (`fuelups`,
  `stations`, Core-CLI) und laesst spaetere Vereinheitlichung als bewusste,
  getrennte Architekturentscheidung offen.

# MVP Contract Follow-Up
- Fuer einen ersten `--stats charging --json`-Pfad reicht ein kleiner
  Contract `ev_charging_stats_v1` mit `events_total`, `cars_total`,
  `total_energy_wh`, `total_cost_cents`, `avg_energy_per_event_wh`,
  `period_from` und `period_to`.
- Ein moeglicher EV-MVP kann damit auf einer klaren Event-/Storage-Grenze
  starten, ohne zuerst Tarif-, SoC-, Karten- oder Sync-Fragen loesen zu
  muessen.

# Done When
- [x] Minimales Charging-Event-Modell ist beschrieben
- [x] Storage-/Boundary-Entscheidung ist nachvollziehbar dokumentiert
- [x] Doku aktualisiert
