# CLI Quick Reference
**Stand:** 2026-04-18

Diese Seite ist eine kurze oeffentliche Orientierung, keine vollstaendige CLI-Spezifikation.
Die belastbare Core-Wahrheit ist `make build` plus `./bin/Betankungen --help`.

## Core Entry

```bash
make build
./bin/Betankungen --help
./bin/Betankungen --version
./bin/Betankungen --about
```

## Core Workflows

```bash
./bin/Betankungen
./bin/Betankungen --add stations
./bin/Betankungen --add cars
./bin/Betankungen --add fuelups
./bin/Betankungen --list fuelups --detail
./bin/Betankungen --stats fuelups --json --pretty
./bin/Betankungen --stats cost --maintenance-source none
./bin/Betankungen --stats cost --maintenance-source module
./bin/Betankungen --seed --fuelups 400 --force
```

## Optional Companion Module

Das Companion-Binary ist getrennt vom Core und gehoert nicht zu `make build`.

```bash
./bin/betankungen-maintenance --help
./bin/betankungen-maintenance --version
./bin/betankungen-maintenance --module-info --json --pretty
./bin/betankungen-maintenance --stats maintenance --car-id 1 --json --pretty
```

## Contract / Behavior Docs

- [User manual (German)](https://github.com/SirKenvelo/Betankungen/blob/main/docs/BENUTZERHANDBUCH.md)
- [Export contract](https://github.com/SirKenvelo/Betankungen/blob/main/docs/EXPORT_CONTRACT.md)
- [Modules architecture](https://github.com/SirKenvelo/Betankungen/blob/main/docs/MODULES_ARCHITECTURE.md)
- [Domain policy tests](https://github.com/SirKenvelo/Betankungen/blob/main/tests/domain_policy/README.md)
