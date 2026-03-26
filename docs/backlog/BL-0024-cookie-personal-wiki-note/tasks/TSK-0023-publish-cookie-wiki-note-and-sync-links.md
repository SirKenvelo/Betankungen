---
id: TSK-0023
title: Publish cookie wiki note and sync links
status: todo
priority: P3
type: task
tags: [wiki, docs, links, public-readiness]
created: 2026-03-26
updated: 2026-03-26
parent: BL-0024
related:
  - BL-0024
  - TSK-0022
---
**Stand:** 2026-03-26

# Task
Veroeffentliche die finale Cookie-Wiki-Notiz im versionierten Wiki-Pfad und
synchronisiere Navigation sowie Link-Checks.

# Notes
- Ziel ist ein kleiner, technisch unaufdringlicher Wiki-Baustein.
- Navigation und Verlinkung werden nur dort erweitert, wo die Notiz sinnvoll
  auffindbar bleibt.
- Nach der Aenderung muss `make wiki-link-check` gruen laufen.

# Done When
- [ ] Wiki-Notiz in `docs/wiki/` ist final angelegt oder aktualisiert.
- [ ] Relevante Einstiegslinks sind synchronisiert.
- [ ] `make wiki-link-check` laeuft erfolgreich.
