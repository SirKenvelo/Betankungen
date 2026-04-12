---
id: TSK-0030
title: Agenten-Prompt und Audit-Raster fuer den Public-Repo-Einstieg definieren
status: done
priority: P2
type: task
tags: [github, audit, public-readiness, prompts, docs]
created: 2026-04-11
updated: 2026-04-12
parent: BL-0035
related:
  - ADR-0012
---
**Stand:** 2026-04-12

# Task
Einen wiederverwendbaren Prompt fuer einen tiefen GitHub-Entry-Audit anlegen,
der bewusst zwischen Cold-Start-Pass und spaeterem Kontext-Pass trennt.

# Notes
- Der Audit muss zuerst wie ein externer Besucher arbeiten und darf nicht
  sofort durch interne Doku vorgepraegt werden.
- Der Prompt soll repo-spezifische Evidenz, klare Bewertungskriterien und
  eine belastbare Output-Struktur erzwingen.
- Die wiederverwendbare Audit-Vorlage liegt in der externen Audit-Ablage
  unter
  `/home/christof/Projekte/Audit/Betankungen/prompts/templates/TEMPLATE_public-repo-entry-audit_prompt.md`.

# Done When
- [x] Ein wiederverwendbarer Audit-Prompt ist in der externen Audit-Ablage
  abgelegt.
- [x] Cold-Start-Pass und Kontext-Pass sind als getrennte Phasen beschrieben.
- [x] Gewuenschter Output und Tracker-Schnitt (`quick win`/`ISS`/`BL`/`ADR`)
  sind explizit definiert.
