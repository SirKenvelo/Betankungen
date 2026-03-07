# Migrations (Historisch)
**Stand:** 2026-03-07

Dieser Ordner wird als **geschichtliches Artefakt** gepflegt.

## Zweck

- Enthält manuelle SQL-Migrationsskripte aus frueheren Entwicklungsphasen.
- Dient der Nachvollziehbarkeit von historischen Schema-Umbauten ohne Git-Dive.

## Aktueller Status

- Vorhanden: `v3_to_v4.sql` (historischer, manueller Rebuild-Pfad fuer `fuelups`).
- Aktuelle Produktiv-Migrationen laufen nicht primär ueber diesen Ordner, sondern ueber die Runtime-Migrationslogik in `units/u_db_init.pas` (idempotente ALTER-/Ensure-Strategie).

## Verbindlicher Referenzpfad fuer aktuelle Migrationen

- Runtime: `units/u_db_init.pas` (Schema-Ensure + Migration)
- Validierung: `tests/smoke/smoke_migrations.sh` (u. a. `v4 -> v5`)
- Change-Historie: `docs/CHANGELOG.md`

## Hinweis

Neue SQL-Dateien in diesem Ordner sind optional und nur dann sinnvoll, wenn ein manueller/offline SQL-Pfad explizit benoetigt wird.
