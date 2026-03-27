---
id: BL-0024
title: Cookie als persoenliche Wiki-Notiz mit optionalem Bild
status: done
priority: P4
type: improvement
tags: [wiki, community, docs, personal, 'lane:planned']
created: 2026-03-21
updated: 2026-03-27
related:
  - BL-002
  - BL-012
  - ADR-0010
  - TSK-0022
  - TSK-0023
---
**Stand:** 2026-03-27

# Goal
Eine kleine, bewusst ruhige Wiki-Notiz zu Cookie als persoenlichem
Projektkontext veroeffentlichen, optional mit einem passend eingebundenen
Bild.

# Motivation
Das Projekt enthaelt bereits kleine persoenliche Spuren in Messages und
Easter-Eggs. Eine knappe, sauber gerahmte Notiz zu Cookie kann diese Linie
konsistent fortsetzen und dem Repository etwas menschlichen Charakter geben,
ohne den technischen Schwerpunkt zu verwischen.

# Scope
In Scope:
- kurzer, stilistisch ruhiger Wiki-Abschnitt zu Cookie
- Einordnung als persoenliche Randnotiz statt technischer Kerninhalt
- optionale Bild-Einbindung mit bewusster Auswahl und passender Einbettung
- klare Abgrenzung zu technischer Produkt- und Nutzerdokumentation

Out of Scope:
- prominente Platzierung im technischen Einstieg
- intime oder stark private Details ohne Mehrwert fuer den Repo-Charakter
- humoristische Ueberzeichnung, die die fachliche Doku entwertet

# Risks
- Ton oder Platzierung wirken deplatziert im technischen Kontext.
- Bildnutzung fuehlt sich spaeter nicht mehr stimmig oder gewuenscht an.
- Persoenlicher Kontext wird missverstanden oder ueberfrachtet.

# Output
Ein kuratierter Public-Readiness-Baustein im Wiki-Quellpfad `docs/wiki/`, der
persoenlichen Hintergrund sichtbar macht und dabei bewusst klein, respektvoll
und technisch unaufdringlich bleibt.

# Derived Tasks
- `TSK-0022` - Platzierung, Ton und Guardrails fuer die Cookie-Wiki-Notiz festziehen. (done)
- `TSK-0023` - Cookie-Wiki-Notiz veroeffentlichen und Navigation/Link-Checks synchronisieren. (done)
