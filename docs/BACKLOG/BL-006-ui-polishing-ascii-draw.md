# BL-006 - UI Polishing & ASCII-Draw
**Stand:** 2026-03-09
**Status:** icebox
**Typ:** UX-/Renderer-Erweiterung (CLI)

## Ziel

Konsistente, robuste und visuell klare CLI-Ausgaben ueber eine kleine
Renderer-Bibliothek (ASCII/Unicode-Fallback) vorbereiten.

## Kontext

Mit wachsendem Output-Umfang (Stats, Warnungen, Kontextbloecke) steigt die
Anforderung an einheitliche Darstellung, Lesbarkeit und Testbarkeit.

Ein loses Wachstum von Tabellen-/Box-Ausgaben ohne gemeinsame Primitive
erhoeht langfristig Wartungsaufwand und Inkonsistenz.

## Scope (Skizze)

- Renderer-Primitive fuer Box/Key-Value/Table
- Unicode-Box-Drawing mit ASCII-Fallback
- deterministische Ausgabe (gleicher Input -> gleicher Output)
- Prototyping ueber feste Layout-Templates (80 / 100-120 / 160+)

## Nicht-Ziele

- keine GUI-Framework-Einfuehrung
- kein Web-Frontend
- keine Vermischung von Renderer und Business-Logik

## Detailnotiz

- Ausfuehrliche Vorarbeiten/Skizzen: `docs/UI_ASCII_DRAW.md`
