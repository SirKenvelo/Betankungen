---
id: BL-0012
title: Module Capability Discovery erweitern
status: approved
priority: P2
type: feature
tags: [module, contract, cli]
created: 2026-03-15
updated: 2026-03-15
related:
  - ADR-0005
  - ADR-0007
  - BL-010
  - POL-002
---
**Stand:** 2026-03-15

# Goal
`--module-info` soll neben Basisfeldern auch maschinenlesbare Capabilities
liefern (Feature-Flags/Unterstuetzungsumfang je Modul).

# Motivation
Der Core kann Integrationspfade robuster steuern, wenn die verfuegbaren
Modulfunktionen explizit sichtbar sind, statt auf implizite Annahmen zu bauen.

# Scope
In Scope:
- Additive Erweiterung des `--module-info`-Contracts um `capabilities`.
- Dokumentierte Feldsemantik fuer Capabilities (stabile Keys, boolesche Werte).
- Guardrails und Regressionstests fuer Presence/Schema.

Out of Scope:
- Dynamische Plugin-Loader oder Runtime-Reflection.
- Breaking Change bestehender `--module-info`-Felder.
- Umsetzung vor finaler 0.9.0-Freigabe.

# Risks
- Inkonsistente Capability-Namen zwischen Modulen.
- Scope-Drift durch zu detailreiche Feature-Matrix.

# Output
Versionierter, additiver Capability-Contract fuer Companion-Module mit
robuster Testabdeckung und Doku-Sync.

# Derived Tasks
- `TSK-0002` - Contract v1 fuer `capabilities` in `--module-info` definieren.
- `TSK-0003` - Runtime-Umsetzung + Regression/Smoke fuer `capabilities`.
