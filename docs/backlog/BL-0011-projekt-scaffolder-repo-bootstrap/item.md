---
id: BL-0011
title: Projekt-Scaffolder (Repo Bootstrap)
status: proposed
priority: P2
type: feature
tags: [tooling, docs, bootstrap]
created: 2026-03-13
updated: 2026-03-28
related:
  - BL-011
  - POL-001
---
**Stand:** 2026-03-28

# Goal
Ein reproduzierbarer Projekt-Scaffold soll neue Repositories mit minimalen
Eingaben auf einen sofort nutzbaren Startzustand bringen.

# Motivation
Neues Projekt-Setup kostet wiederholt Zeit und fuehrt ohne Standard leicht zu
abweichenden Strukturen und unvollstaendigen Basiskonfigurationen.

# Scope
In Scope:
- Basisgeruest fuer neue Repositories (`src`, `docs`, `tests`, `scripts`).
- Standarddateien (z. B. `README.md`, `docs/CHANGELOG.md`, `docs/STATUS.md`,
  `AGENTS.md`, `.gitignore`).
- Optionale Initialisierung mit `--git-init`.

Out of Scope:
- Vollstaendiger CI/CD-Stack-Generator.
- Framework-spezifisches Dependency-Bootstrapping.
- Tiefgreifende Projekt-Spezialisierungen jenseits des Basisprofils.

# Risks
- Scope-Drift durch zu viele optionale Profile.
- Inkonsistente Templates ohne klaren Contract.
- Zu enge Kopplung an ein einzelnes Ausgangsprojekt.

# Output
Ein kleines CLI-Tool mit klaren Templates, das reproduzierbar ein
commit-bereites Grundgeruest erzeugt.

# Derived Tasks
- Keine aktiven Tasks.
- Neue Task-Ableitungen werden erst bei einer expliziten Scope-Aktivierung von
  `BL-0011` angelegt.

# Legacy Reference
- Inhaltliche Legacy-Beschreibung: `docs/BACKLOG/BL-011-projekt-scaffolder-repo-bootstrap.md`
