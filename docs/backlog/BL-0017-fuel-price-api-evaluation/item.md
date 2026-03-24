---
id: BL-0017
title: Evaluation kostenloser Tankstellenpreis-APIs fuer Raspberry-Pi-Betrieb
status: done
priority: P2
type: research
tags: [api, fuel-price, research, raspberry-pi, 'lane:release-blocking']
created: 2026-03-17
updated: 2026-03-24
related:
  - BL-0018
  - POL-003
  - TSK-0018
  - TSK-0019
  - POL-002
---
**Stand:** 2026-03-24

# Goal
Eine tragfaehige, kostenlose API-Quelle fuer regelmaessige Tankstellenpreis-
Abfragen identifizieren.

# Motivation
Bevor Polling-/Historienfunktionen umgesetzt werden, muss klar sein, welche API
lizenz-, rate-limit- und stabilitaetsseitig zum Projekt passt.

# Scope
In Scope:
- Vergleich moeglicher kostenloser APIs (Datenabdeckung, Limits, Verfuegbarkeit).
- Technische und rechtliche Leitplanken fuer einen 15-Minuten-Polling-Rhythmus.
- Empfehlung fuer eine v1-Quelle inklusive Fallback-Option.

Out of Scope:
- Produktive API-Integration in diesem Backlog-Eintrag.
- Bindung an kostenpflichtige Anbieter ohne explizite Freigabe.

# Risks
- API-Limits oder Terms of Use verhindern den vorgesehenen Polling-Rhythmus.
- Uneinheitliche Datenqualitaet zwischen Regionen/Stationen.

# Output
Ein klar dokumentierter API-Entscheidungsvorschlag als Grundlage fuer die
spaetere Implementierung von Preis-Historie und Vergleichen.
Source of truth: `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md`

# Derived Tasks
- `TSK-0018` - API-Evaluationsmatrix und Betriebsgrenzen fuer 1.3.0 definieren. (done)
- `TSK-0019` - Quellenempfehlung inkl. Fallback und Audit-/Doku-Nachweis fuer 1.3.0 ausarbeiten. (done)
