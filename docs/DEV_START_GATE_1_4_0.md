# Startgate fuer `1.4.0-dev`
**Stand:** 2026-04-14
**Status:** historischer Gate-Nachweis; durch separaten Aktivierungs-Commit in Sprint 30 eingeloest

## Zweck

Dieses Dokument definiert den historischen Go-/No-Go-Stand vor dem
eigentlichen Dev-Start von `1.4.0-dev`.

Sprint 29 liefert damit bewusst **nicht** den Dev-Start selbst, sondern die
saubere, dokumentierte Freigabebasis davor.

Der aktive Freeze-/Readiness-Rahmen fuer die laufende Linie wird nach dem
eingeloesten Startgate jetzt separat in `docs/ROADMAP_1_4_0.md` und
`docs/RELEASE_1_4_0_PREFLIGHT.md` weitergefuehrt.
Dieser Folge-Rahmen fuehrt den Scope-Freeze bewusst ohne Rueckgriff auf
Sicherheits-Bypaesse im Smoke-/Fixture-Pfad fort.

## Abgrenzung

- **Abgeschlossener Vorbereitungsblock:** Sprint 23 bis Sprint 28 haben Scope,
  Tracker, Entry-Doku, Wiki/Public-Readiness-Layer und `btkgit` auf einen
  belastbaren Vor-`1.4.0-dev`-Stand gebracht.
- **Startfreigabe:** Sprint 29 bewertet diese Vorarbeiten als formales Gate
  und dokumentiert, ob ein separater Aktivierungs-Commit zulaessig ist.
- **Eigentlicher Dev-Start:** Ein spaeterer, eigener Commit setzt
  `APP_VERSION` auf `1.4.0-dev` und synchronisiert die aktive Roadmap-/Status-
  und Entry-Doku. Dieser Schritt ist ausdruecklich **nicht** Teil von Sprint
  29.

## Preconditions und Evidenz

1. **Scope vor dem Dev-Start ist bereinigt.**
   `BL-0016` bleibt der vorbereitete In-Repo-Scope fuer die naechste Linie;
   `BL-0011` ist fuer dieses Repository externalisiert und kein
   Implementierungsblock fuer `1.4.0`.
   Evidenz: `docs/BL-0011_SCOPE_DECISION_1_4_0.md`, `docs/STATUS.md`.

2. **Tracker-Endzustand fuer neue Arbeit ist explizit.**
   Neue `BL`/`TSK` laufen unter `docs/backlog/`, neue `ISS` unter
   `docs/issues/`, neue `POL` unter `docs/policies/`; `docs/ADR/` bleibt bis
   zu einer separaten Migrationsentscheidung der aktive ADR-Pfad.
   Evidenz: `docs/policies/POL-001-tracker-standard.md`, `docs/STATUS.md`.

3. **Transition-Hold ist in den Einstiegsdokumenten konsistent.**
   Root-README, deutsche/englische Einstiegsdoku und Status fuehren denselben
   Zustand: `1.3.0` ist final, `APP_VERSION=1.3.0` bleibt stehen,
   `1.4.0-dev` ist noch nicht gestartet.
   Evidenz: `README.md`, `docs/README.md`, `docs/README_EN.md`,
   `docs/STATUS.md`.

4. **Wiki-/Public-Readiness-Layer ist beruhigt.**
   Wiki und Einstiegsdoku verweisen nachvollziehbar aufeinander, ohne die
   Source-of-Truth-Rolle von `docs/` zu verwischen.
   Evidenz: `docs/wiki/Home.md`, `docs/wiki/README.md`, `README.md`,
   `docs/README_EN.md`.

5. **Repo-Werkzeuge sind vor dem Dev-Start ausreichend gehaertet.**
   `btkgit` ist fuer Solo-Maintenance dokumentiert, konservativer bei
   Cleanup/Remote-Fehlern und regressionsgesichert genug, um den naechsten
   Zyklus nicht auf unscharfer Tooling-Basis zu starten.
   Evidenz: `docs/ADR/ADR-0010-repo-local-workflow-wrapper-cli.md`,
   `docs/README.md`, Sprint 28.

6. **Die technische Release-Basis bleibt unveraendert stabil.**
   `1.3.0` ist final freigegeben; `APP_VERSION` bleibt bis zum separaten
   Aktivierungs-Commit unveraendert auf `1.3.0`.
   Evidenz: `src/Betankungen.lpr`, `docs/RELEASE_1_3_0_PREFLIGHT.md`,
   `docs/STATUS.md`.

## Go-/No-Go-Entscheidung

### Go

`1.4.0-dev` darf gestartet werden, **wenn** der naechste Schritt als eigener,
klar erkennbarer Aktivierungs-Commit erfolgt und dabei mindestens diese Regeln
eingehalten werden:

- Der Commit aendert gezielt `APP_VERSION` auf `1.4.0-dev` und synchronisiert
  nur die unmittelbar davon betroffene aktive Roadmap-/Status-/Entry-Doku.
- Der Aktivierungs-Commit wird nicht mit `BL-0016`, spaeteren Sprint-Themen
  oder sonstigen Feature-/Tooling-Arbeiten vermischt.
- `BL-0011` bleibt ausserhalb des Betankungen-Implementierungsscope, solange
  keine neue explizite Scope-Entscheidung getroffen und dokumentiert wird.
- Der PR-only-Workflow auf `main` sowie ein gruener Verify-Stand bleiben auch
  fuer den Aktivierungs-Branch verbindlich.

### No-Go

`1.4.0-dev` darf **nicht** gestartet werden, wenn einer der folgenden Faelle
eintritt:

- Der Versionswechsel wird implizit zusammen mit fachlicher Arbeit
  hineingezogen.
- `BL-0016` oder spaetere Themen werden vor dem separaten Start-Commit
  bereits in denselben Sprint/PR gemischt.
- `BL-0011` wird ohne neue dokumentierte Entscheidung wieder in den
  Repo-Implementierungsscope gezogen.
- Status-, README- und Gate-Dokumente laufen wieder auseinander.

## Historischer Gate-Stand am 2026-04-14

- **Vorbereitungsblock:** abgeschlossen.
- **Startfreigabe:** in Sprint 29 als `GO` dokumentiert.
- **Eigentlicher Dev-Start (`APP_VERSION -> 1.4.0-dev`):** in Sprint 30 per
  separatem Aktivierungs-Commit eingeloest.
- **Aktiver Folge-Rahmen:** `docs/ROADMAP_1_4_0.md`,
  `docs/RELEASE_1_4_0_PREFLIGHT.md`.

## Naechster Schritt nach Sprint 29

1. Separaten Aktivierungs-Commit fuer `1.4.0-dev` anlegen.
2. Erst danach die inhaltliche Arbeit der Folge-Linie starten.

Geplanter erster Inhaltsblock danach:

- `BL-0016` als Community-Standards-Baseline fuer den naechsten Sprint.

Diese beiden Schritte sind historisch abgeschlossen. Der laufende Fokus liegt
jetzt auf Scope-Freeze und Release-Readiness der aktiven Linie.

## Explizit nicht Teil dieses Gates

- keine Aktivierung von `1.4.0-dev`
- kein Versionswechsel in `APP_VERSION`
- keine Umsetzung von `BL-0016`
- keine Rueckkehr von `BL-0011` in den Betankungen-Repo-Scope
- keine erneute Tooling-Haertung aus Sprint 28
