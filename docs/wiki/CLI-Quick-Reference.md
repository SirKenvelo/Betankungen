# CLI Quick Reference
**Stand:** 2026-03-15

## Core Meta

```bash
Betankungen --help
Betankungen --version
Betankungen --about
```

## Typical Flows

```bash
Betankungen --init
Betankungen --add fuelup --car-id 1 --date 2026-03-15 --odometer 123456 --liters 45.00 --cost 72.40
Betankungen --list fuelups --car-id 1
Betankungen --stats fuelups --car-id 1
Betankungen --stats cost --maintenance-source none --json --pretty
```

## Companion Module

```bash
betankungen-maintenance --module-info --json --pretty
betankungen-maintenance --stats maintenance --car-id 1 --json --pretty
```

## Contract / Behavior Docs

- [User manual (German)](../BENUTZERHANDBUCH.md)
- [Export contract](../EXPORT_CONTRACT.md)
- [Modules architecture](../MODULES_ARCHITECTURE.md)
- [Domain policy tests](../../tests/domain_policy/README.md)
