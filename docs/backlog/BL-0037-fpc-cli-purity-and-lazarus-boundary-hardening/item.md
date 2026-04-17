---
id: BL-0037
title: FPC-CLI-Purity und Lazarus-Grenzen absichern
status: done
priority: P2
type: improvement
tags: [architecture, audit, build, docs, cli, 'lane:planned']
created: 2026-04-17
updated: 2026-04-17
related:
  - ADR-0016
  - BL-0035
---
**Stand:** 2026-04-17

# Goal
Den im Audit bestaetigten FPC-/CLI-Istzustand in explizite Guardrails fuer
Build, CI, Tooling und aktive Doku uebersetzen.

# Motivation
Der Audit vom 2026-04-17 zeigt ein klares Bild: Der aktive Projektbaum ist
technisch bereits Lazarus-/LCL-frei, aber diese Grenze ist noch nicht ueberall
hart operationalisiert. Ohne kleine Hardening-Schritte drohen erneute
Wording-Drift, spaeterer Tooling-Drift oder false-positive Diskussionen ueber
historische Alttexte.

# Scope
In Scope:
- expliziten Purity-Guard fuer aktiven Baum, `make` und CI schneiden
- VS-Code-Build-Frontend klar an die kanonische Build-Wahrheit binden
- aktive Architektur-/Entry-Doku konsistent auf die FPC-/CLI-Grenze halten

Out of Scope:
- Runtime-Refactoring oder Produktfeature-Arbeit
- Big-Bang-Uebersetzung oder globale Historienbereinigung
- Entfernung des `knowledge_archive/`
- pauschales Verbot historischer Lazarus-Erwaehnungen ohne Kontext

# Risks
- Editor- oder Komfort-Frontends driften spaeter vom kanonischen Build ab.
- Historische Doku wird ohne klare Guardrails erneut als aktive Abhaengigkeit
  missverstanden.
- Ohne Fail-Fast-Check werden neue Purity-Verstoesse erst spaet entdeckt.

# Output
Der Audit ist jetzt in belastbare Folgearbeit uebersetzt: `ADR-0016` rahmt die
Architekturgrenze, `TSK-0035` schneidet den Purity-Guard, und `TSK-0036`
bindet das VS-Code-Build-Frontend an `make build`. Der Block ist damit
abgeschlossen.

# Derived Tasks
- `TSK-0035` - Fail-Fast-Purity-Check fuer aktiven Baum und CI einfuehren.
- `TSK-0036` - VS-Code-Build-Frontend an `make build` binden. (`done`)
