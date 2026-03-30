---
id: BL-0011
title: Projekt-Scaffolder (Repo Bootstrap)
status: done
priority: P3
type: research
tags: [tooling, docs, bootstrap, externalization, 'lane:exploratory']
created: 2026-03-13
updated: 2026-03-30
related:
  - BL-011
  - BL-0016
  - POL-001
---
**Stand:** 2026-03-30

# Goal
Den repo-seitigen Externalisierungs- und Handover-Stand fuer einen
generischen Projekt-Scaffolder final abschliessen und fuer eine spaetere
Weiterarbeit ausserhalb von `Betankungen` belastbar festhalten.

# Motivation
Neues Projekt-Setup kostet wiederholt Zeit und fuehrt ohne Standard leicht zu
abweichenden Strukturen und unvollstaendigen Basiskonfigurationen. Gleichzeitig
ist ein generischer Repo-Bootstrap kein fachlicher Ausbau von `Betankungen`
selbst und wuerde den Produkt-Scope mit Meta-Tooling vermischen.

# Scope
In Scope:
- Repo-seitige Scope-Entscheidung, Referenzpflege und finaler Closeout fuer
  `Betankungen`.
- MVP-/Nicht-Ziel-Snapshot fuer ein separates Scaffolder-Repository.
- Referenzpflege zu `BL-011`, `BL-0016` und `POL-001`.
- Klarer Handover-Hinweis, dass weitere fachliche Umsetzung ausserhalb dieses
  Repositories liegt.

Out of Scope:
- Umsetzung des Scaffolder-CLI innerhalb von `Betankungen`.
- Aufnahme des Themas in den `1.4.0`-Implementierungsscope dieses Repositories.
- Vollstaendiger CI/CD-Stack-Generator.
- Framework-spezifisches Dependency-Bootstrapping.
- Tiefgreifende Projekt-Spezialisierungen jenseits des Basisprofils.

# External MVP Snapshot
- Basisgeruest fuer neue Repositories (`src`, `docs`, `tests`, `scripts`,
  `.artifacts`).
- Standarddateien (z. B. `README.md`, `docs/CHANGELOG.md`, `docs/STATUS.md`,
  `AGENTS.md`, `.gitignore`).
- Optionale Initialisierung mit `--git-init`.

# Risks
- Scope-Drift zwischen `Betankungen` und einem generischen Tooling-Projekt.
- Inkonsistente Handover-Erwartungen ohne klaren MVP-/Nicht-Ziel-Snapshot.
- Spaetere Rueckkopplung in den Repo-Scope ohne explizite Maintainer-Entscheidung.

# Output
Ein abgeschlossener repo-seitiger Externalisierungs- und Handover-Stand fuer
`BL-0011`, inklusive MVP-Snapshot, Nicht-Zielen, klarer Repo-Scope-Grenze
fuer `Betankungen` und explizitem Verweis auf die externe Weiterarbeit.

# Repo Scope Decision
- `BL-0011` gehoert nicht zum Implementierungsscope des `Betankungen`-
  Repositories fuer die geplante `1.4.0`-Linie.
- Der repo-seitige Research-/Handover-Stand ist fuer `Betankungen`
  abgeschlossen.
- Eventuelle Folgearbeit findet ausschliesslich in einem separaten
  Zielprojekt/Repository statt, sofern keine neue Re-Entry-Entscheidung
  getroffen wird.
- Details der Entscheidung liegen in `docs/BL-0011_SCOPE_DECISION_1_4_0.md`.

# Derived Tasks
- Keine Betankungen-internen Tasks.
- Neue Task-Ableitungen werden nicht mehr in diesem Repository angelegt,
  sondern erst bei einer expliziten Aktivierung im Zielprojekt oder nach
  einer ausdruecklichen Rueckholung in den Repo-Scope.

# Legacy Reference
- Inhaltliche Legacy-Beschreibung: `docs/BACKLOG/BL-011-projekt-scaffolder-repo-bootstrap.md`
