# ADR Index
**Stand:** 2026-03-09

Dieses Verzeichnis enthaelt Architecture Decision Records (ADRs) fuer produkt- und architekturrelevante Entscheidungen.
Backlog-Themen ohne finale Entscheidung stehen im Index `docs/BACKLOG.md`;
die Detaileintraege liegen in `docs/BACKLOG/BL-*.md`.

## Entscheidungen

- `ADR-0001` - CSV-Contract-Versionierung ohne Kommentarzeilen im strict CSV (`accepted`)
- `ADR-0002` - VIN-Validierung als Warning+Confirm statt Hard Error (`accepted`)
- `ADR-0003` - Schema-Bump-Strategie in kleinen, getrennten Migrationen (`accepted`)
- `ADR-0004` - Fleet-Stats-Naming `--stats fleet` (`accepted`)
- `ADR-0005` - Modulstrategie fuer Betankungen (Core + Module, Companion-Binaries statt Runtime-Plugins) (`proposed`)
- `ADR-0006` - Household Drivers (optionales `driver`-Objekt + `fuelups.driver_id`) (`proposed`)

## Ergaenzende Policy-/UX-Notizen

- `docs/VIN_POLICY_UX_PREP.md` - ADR-nahe Fach-/UX-Vorbereitung fuer VIN-Handling (optional, Normalisierung, Policy-light, Dokument-Referenzen), als Begleitdokument zu VIN-bezogenen ADRs.
