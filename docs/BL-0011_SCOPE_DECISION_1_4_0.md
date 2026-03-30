# BL-0011 Scope Decision fuer 1.4.0
**Stand:** 2026-03-30
**Status:** closed for Betankungen

## Entscheidung

`BL-0011` gehoert nicht zum Implementierungsscope des `Betankungen`-
Repositories fuer die geplante `1.4.0`-Linie.

`Betankungen` fuehrt dazu nur den Research-/Handover-Stand und die
Repo-seitige Referenzpflege. Die eigentliche Umsetzung bleibt ein separates
Repository-Thema. Dieser repo-seitige Closeout ist fuer `Betankungen`
abgeschlossen.

## Begruendung

- Das Legacy-Backlog `BL-011` positioniert den Projekt-Scaffolder explizit als
  separates Repository.
- Das Zielobjekt ist ein generischer Repo-Bootstrap fuer neue Projekte und
  kein fachlicher Ausbau von `Betankungen`.
- Eine Umsetzung im `Betankungen`-Repo wuerde Public-Readiness/Governance-
  Arbeit (`BL-0016`) mit generischem Meta-Tooling vermischen.

## In Scope fuer Betankungen 1.4.0

- Repo-seitige Scope-Bereinigung, Referenzpflege und finaler Closeout fuer
  `BL-0011`.
- Dokumentierter Handover-/Research-Stand fuer ein spaeteres separates
  Repository.
- Public-Repository-Baseline aus `BL-0016` als verbleibender In-Repo-Scope.

## Out of Scope fuer Betankungen 1.4.0

- Implementierung eines Scaffolder-CLI oder Template-Generators in diesem
  Repository.
- Aufbau eines generischen Bootstrap-Template-Sets unter `Betankungen`.
- Release-, Versionierungs- oder Packaging-Arbeit fuer ein separates
  Scaffolder-Projekt.

## External Handover Snapshot

### Zielbild fuer das externe Thema

- Reproduzierbares Grundgeruest fuer neue Repositories mit minimalen Eingaben.
- Basisverzeichnisse `src/`, `docs/`, `tests/`, `scripts/`, `.artifacts/`.
- Basisdateien wie `README.md`, `docs/CHANGELOG.md`, `docs/STATUS.md`,
  `AGENTS.md` und `.gitignore`.
- Optionaler Schalter `--git-init`.

### Nicht-Ziele fuer das externe Thema

- Kein vollstaendiger CI/CD-Stack-Generator.
- Kein framework-spezifisches Dependency-Bootstrapping.
- Keine tiefgreifende Projekt-Spezialisierung jenseits eines Basisprofils.

## Repo-seitiger Abschlussstand

- `BL-0011` ist im kanonischen Tracker fuer `Betankungen` auf `done`
  gesetzt.
- `docs/BACKLOG.md` und `docs/STATUS.md` behandeln das Thema nicht mehr als
  offenen In-Repo-Block der `1.4.0`-Linie.
- Weitere Umsetzung, Release- oder Packaging-Arbeit fuer einen Projekt-
  Scaffolder findet nur ausserhalb dieses Repositories statt.

## Re-Entry-Kriterien

`BL-0011` wird nur dann wieder in den Betankungen-Repo-Scope gezogen, wenn
mindestens eine der folgenden Bedingungen explizit beschlossen wird:

- der Maintainer will den Scaffolder bewusst in diesem Repository hosten;
- ein separates Ziel-Repository existiert nicht mehr als gewuenschter
  Arbeitsmodus;
- es gibt eine dokumentierte Abhaengigkeit, die eine enge Kopplung an
  `Betankungen` fachlich zwingend macht.
