---
id: BL-0013
title: Performance-Benchmark-Harness fuer Stats-Collector
status: done
priority: P3
type: research
tags: [performance, stats, qa]
created: 2026-03-15
updated: 2026-03-15
related:
  - BL-010
  - POL-002
---
**Stand:** 2026-03-15

# Goal
Ein reproduzierbarer Benchmark-Harness soll Performance-Aussagen fuer
Stats-Collector-Pfade messbar machen.

# Motivation
Performance-Arbeit soll trigger-basiert und datenbasiert erfolgen, nicht als
Selbstzweck.

# Scope
In Scope:
- Definierte Benchmark-Datensaetze/Fixtures.
- Reproduzierbarer Runner mit klaren Messpunkten (z. B. Laufzeit pro Stats-Mode).
- Dokumentierte Baseline + Messprotokoll.

Out of Scope:
- Dauerhaftes Pflicht-Gate in `make verify` fuer jede Aenderung.
- Vorzeitige Micro-Optimierung ohne messbaren Schmerz.
- Ergebnisgetriebene Architektur-Umbauten ohne ADR/Policy-Abgleich.

# Risks
- Benchmarks werden instabil, wenn Testdaten nicht kontrolliert sind.
- Falsche Priorisierung gegenueber funktionalen Release-Zielen.

# Output
Ein optional ausfuehrbarer Benchmark-Workflow inkl. Doku, der bei
Performance-Triggern reproduzierbar genutzt werden kann.

# Derived Tasks
- `TSK-0004` - Reproduzierbare Benchmark-Fixtures + optionaler Runner. (done)

# Initial Benchmark Baseline (2026-03-15)

Konfiguration:
- DB: `tests/domain_policy/fixtures/Betankungen_Big.db`
- Command: `tests/benchmark/run_stats_benchmark.sh --iterations 5 --warmup 1`

Messwerte (ms):
- `fuelups_text`: avg 18, min 17, max 19
- `fuelups_json`: avg 16, min 15, max 16
- `fleet_json`: avg 13, min 12, max 14
- `cost_json_none`: avg 29, min 19, max 35
- `cost_json_scoped`: avg 22, min 17, max 30
