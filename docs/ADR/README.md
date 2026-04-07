# ADR Index
**Stand:** 2026-04-07

Dieses Verzeichnis enthaelt Architecture Decision Records (ADRs) fuer
produkt- und architekturrelevante Entscheidungen und ist der aktuell
verwendete ADR-Ablagepfad dieses Repositories.
Backlog-Themen ohne finale Entscheidung stehen im Index `docs/BACKLOG.md`;
neue BL-/TSK-Eintraege liegen im kanonischen Tracker unter `docs/backlog/`,
historische BL-0xx weiterhin unter `docs/BACKLOG/`.

Die in aelteren Planungsnotizen auftauchende Kleinschreibung `docs/adr/` ist
hier noch nicht aktiviert; eine solche Umstellung waere ein separater
Migrationsschritt und wird nicht implizit parallel gestartet.

## Entscheidungen

- `ADR-0001` - CSV-Contract-Versionierung ohne Kommentarzeilen im strict CSV (`accepted`)
- `ADR-0002` - VIN-Validierung als Warning+Confirm statt Hard Error (`accepted`)
- `ADR-0003` - Schema-Bump-Strategie in kleinen, getrennten Migrationen (`accepted`)
- `ADR-0004` - Fleet-Stats-Naming `--stats fleet` (`accepted`)
- `ADR-0005` - Modulstrategie fuer Betankungen (Core + Module, Companion-Binaries statt Runtime-Plugins) (`accepted`)
- `ADR-0006` - Household Drivers (optionales `driver`-Objekt + `fuelups.driver_id`) (`proposed`)
- `ADR-0007` - Core Boundary: Core vs Module (`accepted`)
- `ADR-0008` - Elektrofahrzeuge-Strategie (EV als Modul `betankungen-ev`) (`accepted`)
- `ADR-0009` - Runtime-Config-Profile im Core abgelehnt (`rejected`)
- `ADR-0010` - Repo-lokales Workflow-Wrapper-CLI (`btkgit`) (`accepted`)
- `ADR-0011` - Tracker-Endzustand und Legacy-Read-Policy (`accepted`)
- `ADR-0012` - Documentation Entry Layer und Source-of-Truth-Vertrag (`accepted`)
- `ADR-0013` - `btkgit` Safety- und Betriebsvertrag (`accepted`)
- `ADR-0014` - Fuelup-Kilometerstands-Semantik (`accepted`)
- `ADR-0015` - CLI-first TUI Evolution Strategy (`accepted`)

## Ergaenzende Policy-/UX-Notizen

- `docs/VIN_POLICY_UX_PREP.md` - ADR-nahe Fach-/UX-Vorbereitung fuer VIN-Handling (optional, Normalisierung, Policy-light, Dokument-Referenzen), als Begleitdokument zu VIN-bezogenen ADRs.
