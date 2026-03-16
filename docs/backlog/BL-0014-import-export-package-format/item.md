---
id: BL-0014
title: Import-Export-Paketformat mit Manifest und Checksum
status: approved
priority: P2
type: research
tags: [export, portability, integrity]
created: 2026-03-15
updated: 2026-03-16
related:
  - BL-010
  - POL-002
  - POL-003
---
**Stand:** 2026-03-16

# Goal
Bewertung und Entwurf eines portablen Import-/Export-Paketformats mit Manifest
und Integritaetspruefung.

# Motivation
Fuer spaetere Datenaustausch-Szenarien kann ein klarer Paket-Contract
Wiederherstellbarkeit und Nachvollziehbarkeit verbessern.

# Scope
In Scope:
- Konzept fuer Paketstruktur (Payload + Manifest + Checksum).
- Integritaets- und Quellenfelder im Manifest.
- Abgrenzung zu bestehendem Release-/Backup-Flow.

Out of Scope:
- Umsetzung als kurzfristiges Feature in der 0.9.0- oder 1.0.0-Linie.
- Vollstaendige Import-Pipeline mit Migrationsautomatik.
- Vermischung mit unversionierten Ad-hoc-Exports.

# Risks
- Ueberengineering gegenueber aktuellem Projektfokus.
- Zusatzerwartungen an Rueckwaertskompatibilitaet ohne stabilen Use-Case.

# Output
Ein scope-frozen Research-/Contract-Block fuer die 1.1.0-Linie mit klaren
Deliverables (Manifest-v1-Entwurf, Integritaetsregeln, Fixture-/Dry-Run-Plan)
und expliziten Nicht-Zielen.

# Derived Tasks
- `TSK-0006` - Manifest-v1-Contract und Dry-Run-Fixtures fuer Paketpruefungen.
