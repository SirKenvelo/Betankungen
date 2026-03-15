---
id: TSK-0002
title: Define module capabilities contract v1 for --module-info
status: todo
priority: P1
type: task
tags: [module, contract, cli, docs]
created: 2026-03-15
updated: 2026-03-15
parent: BL-0012
related:
  - BL-0012
  - ADR-0005
  - ADR-0007
  - POL-002
---
**Stand:** 2026-03-15

# Task
Definiere die verbindliche Feldsemantik fuer `capabilities` im
`--module-info`-Contract (stabile Keys, boolesche Werte, additive Erweiterung,
keine Breaking-Changes).

# Notes
- Semantik muss fuer Core und Companion-Module identisch lesbar sein.
- Contract-Text in `docs/MODULES_ARCHITECTURE.md` und
  `docs/EXPORT_CONTRACT.md` synchron halten.
- Keine impliziten Feature-Annahmen im Core.

# Done When
- [ ] Capabilities-Schema v1 schriftlich definiert.
- [ ] Additionsregeln gemaess `POL-002` dokumentiert.
- [ ] Doku-Referenzen auf einen konsistenten Contract-Stand gebracht.
