# ADR-0016: FPC-CLI-Purity als aktive Architekturgrenze
**Stand:** 2026-04-17
**Status:** proposed
**Datum:** 2026-04-17

## Kontext

Betankungen ist historisch aus frueheren Lazarus-/IDE-nahen Denkspuren
hervorgegangen, wird aber im aktiven Repository bereits als FPC-/CLI-Projekt
gebaut, getestet und betrieben.

Der Audit `docs/LAZARUS_PURITY_AUDIT_2026-04-17.md` bestaetigt:

- keine aktiven Lazarus-/LCL-Abhaengigkeiten in `src/`, `units/`, `tests/`
  und `scripts/`
- keine verbotenen aktiven Projektartefakte (`.lpi`, `.lfm`, `.lrs`,
  `.lps`)
- `make build` als kanonische Build-Wahrheit
- CI mit glaubhaftem FPC-/CLI-Buildpfad
- verbleibende Drift vor allem in Wording und fehlender Purity-Governance

Offen ist damit nicht mehr die technische Istlage, sondern ihre verbindliche
Formulierung als Architekturgrenze.

## Entscheidung

Betankungen behandelt den aktiven Produktkern kuenftig explizit als
**FPC-/CLI-/Linux-/SQLite-Architektur ohne aktive Lazarus-/LCL-Abhaengigkeit**.

Daraus folgen diese Leitplanken:

- `make build` ist die kanonische Build-Wahrheit.
- CI, Editor-Tasks und sonstige Komfort-Frontends duerfen diese Build-Wahrheit
  nur abbilden oder ueber eine duenne Huelle aufrufen, aber keine
  konkurrierende Build-Logik etablieren.
- Im aktiven Baum (`src/`, `units/`, `tests/`, `scripts/`, aktive Build- und
  Workflow-Dateien) sind Lazarus-/LCL-Units, GUI-Symbole und die zugehoerigen
  Projektartefakte (`.lpi`, `.lfm`, `.lrs`, `.lps`) nicht Teil der
  Zielarchitektur.
- Historische Erwaehnungen von Lazarus bleiben nur in expliziten
  Legacy-Kontexten wie Changelog, Archiv oder alter Planungsdoku zulaessig.
- Der aktive Verify-/CI-Pfad soll einen expliziten Purity-Guard erhalten, der
  neue Drift frueh blockt.

## Nicht-Ziele

- keine Rueckschreibung oder Massenbereinigung der gesamten Historie
- kein Big-Bang-Umbau historischer Doku oder des `knowledge_archive/`
- kein Verbot harmloser FPC-Texte oder unpraeziser Teilstring-Treffer
- keine implizite TUI- oder Modulstrategie-Aenderung ausserhalb dieses
  Architekturthemas

## Konsequenzen

- Aktive Einstiegs- und Architekturdoku muss die FPC-/CLI-Wahrheit klar
  tragen.
- Neue Tooling-Schichten muessen `make build` als kanonischen Pfad respektieren.
- Ein kuenftiger Purity-Check wird eine bewusst enge aktive Suchflaeche und
  klare historische Ausnahmen brauchen, damit keine False Positives entstehen.
- Folgearbeit wird in `BL-0037`, `TSK-0035` und `TSK-0036` geschnitten.

## Referenzen

- `docs/LAZARUS_PURITY_AUDIT_2026-04-17.md`
- `docs/backlog/BL-0037-fpc-cli-purity-and-lazarus-boundary-hardening/item.md`
- `Makefile`
- `.github/workflows/ci.yml`
- `.vscode/tasks.json`
