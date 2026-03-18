---
id: TSK-0011
title: Implement receipt-link write path and output contract checks
status: done
priority: P1
type: task
tags: [receipts, links, implementation, qa]
created: 2026-03-18
updated: 2026-03-18
parent: BL-0021
related:
  - BL-0021
  - TSK-0010
  - POL-002
  - POL-003
---
**Stand:** 2026-03-18

# Task
Implementiere den optionalen Receipt-Link-Write-Path fuer neue Fuelups und
liefere Contract-/Policy-Nachweise fuer Text/JSON-Ausgabe.

# Notes
- Append-only-Verhalten fuer Fuelups darf nicht aufgeweicht werden.
- Ungueltige Links muessen klar und stabil abgefangen werden.
- Testabdeckung fuer gesetzt/leer/ungueltig ist verpflichtend.

# Done When
- [x] Write-Path fuer optionalen Receipt-Link ist implementiert.
- [x] Domain-/Smoke-/Contract-Checks decken Kernfaelle und Guardrails ab.
- [x] Doku fuer CLI/Contract/Policy ist auf den Runtime-Stand synchronisiert.
