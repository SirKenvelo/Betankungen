# Lazarus-Purity-Audit fuer den aktiven Projektbaum
**Stand:** 2026-04-17

## Ziel

Den aktiven Iststand von Betankungen auf eine klare Architekturgrenze
pruefen: reines FPC-/CLI-/Linux-/SQLite-Projekt, keine aktive Lazarus-/LCL-
Abhaengigkeit.

## Scope und Methode

- Aktiver Source-Baum: `src/`, `units/`, `tests/`, `scripts/`
- Aktiver Build-/Workflow-Baum: `Makefile`, `.github/workflows/ci.yml`,
  `.vscode/tasks.json`, `AGENTS.md`, `docs/GIT_WORKFLOW.md`
- Aktive Einstiegs- und Architektur-Doku: `README.md`, `CONTRIBUTING.md`,
  `docs/README.md`, `docs/ARCHITECTURE.md`, `docs/STATUS.md`
- Historischer Kontext getrennt: `docs/CHANGELOG.md`, `knowledge_archive/`,
  aeltere ADR-/Backlog-Texte

Die Suchlaeufe haben zwischen exakten verbotenen Tokens und harmlosen
Teilstrings getrennt. Beispiel: `TFormatSettings` in `units/u_stats.pas` und
`TFormatInt64Func` in `units/u_db_common.pas` sind keine GUI-/Lazarus-Treffer.

## Audit-Fazit

Der aktive Projektkern ist bereits **Lazarus-/LCL-frei**. Es wurden keine
aktiven Source-, Build- oder Testpfad-Abhaengigkeiten auf Lazarus oder LCL
gefunden. Die verbleibenden Befunde liegen in **Doku-/Wording-Drift** und in
einem **fehlenden expliziten Fail-Fast-Purity-Check** fuer CI und lokale
Build-Gates.

## Evidence-Liste

- `src/Betankungen.lpr`
  Hauptbinary mit `SysUtils`, `IniFiles` und repo-eigenen Units; keine
  Lazarus-/LCL-Units, keine GUI-Initialisierung, keine `.lfm`-/`.lrs`-
  Direktiven.
- `src/betankungen-maintenance.lpr`
  Companion-Binary mit `SysUtils`, `u_module_info`, `u_maintenance_db`; kein
  GUI-/LCL-Wiring.
- `Makefile`
  kanonischer Build ueber
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`.
- `.github/workflows/ci.yml`
  installiert `fp-compiler`/`fp-units-*` und baut direkt mit demselben
  FPC-Compile-Pfad; keine Lazarus-IDE-, LCL- oder GUI-Pakete im aktiven
  Buildpfad.
- `.vscode/tasks.json`
  spiegelt den FPC-Compile-Pfad als Komfort-Frontend; kein eigener
  Lazarus-spezifischer Buildpfad.
- `README.md`, `docs/README.md`, `docs/ARCHITECTURE.md`
  waren die sichtbaren aktiven Driftstellen im Wording und sind jetzt auf die
  FPC-/CLI-Wahrheit synchronisiert.
- `docs/CHANGELOG.md`, `knowledge_archive/`, aeltere Tracker-/ADR-Texte
  enthalten historische Lazarus-Kontexte; diese zaehlen nicht als aktive
  Architekturabhaengigkeit.

## Befunde nach Kategorie

### 1. Aktive Source-/Build-Abhaengigkeit

- Befund: **kein aktiver Verstoss**
- Exakte Suchlaeufe in `src/`, `units/`, `tests/`, `scripts/` fanden keine
  Treffer fuer verbotene Units, Direktiven oder GUI-Symbole wie `Forms`,
  `Dialogs`, `Controls`, `Interfaces`, `LResources`, `DefaultTranslator`,
  `LazUTF8`, `LazFileUtils`, `{$R *.lfm}`, `{$I *.lrs}`, `{$IFDEF LCL}`,
  `{$IFDEF LAZARUS}`, `TForm`, `Application.Initialize`,
  `Application.Run` oder `ShowMessage`.
- Die einzige naive Volltext-Falle war ein Teilstring-Treffer auf `Forms`
  innerhalb von `TFormatSettings`/`TFormatInt64Func`; das ist ein
  False-Positive.
- Suchlaeufe nach `.lpi`, `.lfm`, `.lrs`, `.lps` und `.res` im Repo
  lieferten keine aktiven Projektartefakte.

### 2. CI-/Tooling-/Build-Wahrheit

- Befund: **Build-Wahrheit ist FPC-/CLI-basiert, aber Purity-Guard fehlt**
- `make build` ist die faktische Build-Wahrheit.
- Die CI baut direkt mit demselben FPC-Compile-Pfad und installierten
  Free-Pascal-Paketen.
- `.vscode/tasks.json` ist aktuell ein Komfort-Frontend und fuehrt keine
  konkurrierende Build-Logik ein.
- Restluecke: Es gibt noch keinen expliziten Fail-Fast-Check, der
  Lazarus-/LCL-Artefakte oder verbotene Tokens im aktiven Baum frueh blockt.

### 3. Doku-/Wording-Drift

- Befund: **ja, aber redaktionell**
- `README.md` nannte das Projekt noch "Free Pascal/Lazarus".
- `docs/README.md` fuehrte dieselbe gemischte Rahmung.
- `docs/ARCHITECTURE.md` sprach noch von "Synchronisation zwischen
  Lazarus-IDE und VS Code Build-Tasks".
- Diese Drift war sprachlich und organisatorisch, nicht technisch.

### 4. Historische Altlasten vs. aktive Verstoesse

- Befund: **historischer Kontext vorhanden, aber klar trennbar**
- Historische Lazarus-Erwaehnungen in `docs/CHANGELOG.md`,
  `knowledge_archive/` oder aelteren Planungs-/Migrationsnotizen sind keine
  aktive Abhaengigkeit.
- Der aktive Baum ist sauberer als die historische Doku-Landschaft.
- Daraus folgt: Historische Referenzen muessen nicht global entfernt werden,
  sollen aber klar als Legacy/Historie lesbar bleiben.

## Antworten auf die verbindlichen Audit-Fragen

1. Gibt es im aktiven Projektbestand noch echte Lazarus-/LCL-Abhaengigkeiten
   im Code, Build oder Testpfad?
   Nein.
2. Gibt es noch verbotene oder irrefuehrende Projektartefakte im aktiven Baum
   (`.lpi`, `.lfm`, `.lrs`, `.lps`)?
   Nein.
3. Gibt es noch aktive verbotene Units/Direktiven/Symbole?
   Nein; exakte Suchlaeufe blieben im aktiven Baum leer.
4. Ist `make build` die faktische Build-Wahrheit?
   Ja.
5. Ist `.vscode/tasks.json` nur Komfort-Frontend oder enthaelt es abweichende
   Build-Logik?
   Aktuell nur Komfort-Frontend; die Logik spiegelt den FPC-Compile-Pfad.
6. Fuehrt die CI bereits eine glaubhafte FPC-/CLI-Wahrheit oder fehlt noch ein
   expliziter Fail-Fast-Purity-Check?
   Die CI fuehrt eine glaubhafte FPC-/CLI-Wahrheit, aber der explizite
   Fail-Fast-Purity-Check fehlt noch.
7. Wo existiert nur Doku-/Begriffs-Drift mit falschem Lazarus-Wording?
   Vor dem Audit in `README.md`, `docs/README.md`, `docs/ARCHITECTURE.md`.
8. Was ist aktiver Verstoss, was nur historischer Kontext und was nur
   redaktioneller Nachlauf?
   Aktiver Verstoss: keiner. Historischer Kontext: `docs/CHANGELOG.md`,
   `knowledge_archive/`, aeltere Tracker-/ADR-Texte. Redaktioneller Nachlauf:
   aktive Einstiegs-/Architekturdoku.

## ADR-Kandidat

- `ADR-0016`: **FPC-CLI-Purity als aktive Architekturgrenze**
  Kernthese: Der aktive Produktkern von Betankungen ist FPC + CLI + Linux +
  SQLite; Lazarus-/LCL-Abhaengigkeiten und zugehoerige Projektartefakte sind
  im aktiven Baum nicht Teil der Zielarchitektur. Historische Erwaehnungen
  bleiben erlaubt, aber nur als expliziter Legacy-Kontext.

## TSK-Kandidaten

- `TSK-0035`: Fail-Fast-Purity-Check fuer aktiven Baum und CI einfuehren
- `TSK-0036`: VS-Code-Build-Frontend an `make build` binden

## Empfohlener naechster kleiner Umsetzungsblock

`TSK-0035` ist der beste naechste Schritt. Der Block ist klein, technisch
klar abgrenzbar und schliesst die einzige echte operative Luecke des Audits:
ein expliziter Guardrail, der neue Lazarus-/LCL-Drift sofort im aktiven Baum,
im lokalen Verify-Pfad und in der CI sichtbar macht.
