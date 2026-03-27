---
id: TSK-0023
title: Publish cookie wiki note and sync links
status: done
priority: P3
type: task
tags: [wiki, docs, links, public-readiness]
created: 2026-03-26
updated: 2026-03-27
parent: BL-0024
related:
  - BL-0024
  - TSK-0022
---
**Stand:** 2026-03-27

# Task
Veroeffentliche die finale Cookie-Wiki-Notiz im versionierten Wiki-Pfad und
synchronisiere Navigation sowie Link-Checks.

# Notes
- Ziel ist ein kleiner, technisch unaufdringlicher Wiki-Baustein.
- Navigation und Verlinkung werden nur dort erweitert, wo die Notiz sinnvoll
  auffindbar bleibt.
- Nach der Aenderung muss `make wiki-link-check` gruen laufen.
- Finale Wiki-Notiz liegt in `docs/wiki/Cookie-Note.md`.
- Navigation ist ueber `docs/wiki/Home.md` und den Wiki-Source-Index
  `docs/wiki/README.md` synchronisiert.

# Done When
- [x] Wiki-Notiz in `docs/wiki/` ist final angelegt oder aktualisiert.
- [x] Relevante Einstiegslinks sind synchronisiert.
- [x] `make wiki-link-check` laeuft erfolgreich.
