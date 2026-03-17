---
id: TSK-0006
title: Define package manifest v1 and dry-run fixtures for import/export bundles
status: done
priority: P2
type: task
tags: [export, contract, integrity, qa]
created: 2026-03-16
updated: 2026-03-17
parent: BL-0014
related:
  - BL-0014
  - POL-002
  - POL-003
---
**Stand:** 2026-03-17

# Task
Definiere einen manifestbasierten Paket-Contract v1 (Payload + Manifest +
Checksum) und liefere reproduzierbare Dry-Run-Fixtures fuer die spaetere
Runtime-Validierung.

# Notes
- Fokus auf Contract-Design, nicht auf vollstaendige Import-Pipeline.
- Manifest muss Herkunft, Version, Integritaet und Zeitstempel abdecken.
- Pruefregeln muessen ohne produktive Nutzdaten mit synthetischen Fixtures testbar sein.

# Done When
- [x] Manifest-v1-Felder und Checksum-Regeln sind eindeutig dokumentiert.
- [x] Fixture-Satz fuer gueltig/ungueltig ist reproduzierbar beschrieben.
- [x] Dry-Run-Pruefablauf ist als Gate-/CI-kompatibler Entwurf festgehalten.
