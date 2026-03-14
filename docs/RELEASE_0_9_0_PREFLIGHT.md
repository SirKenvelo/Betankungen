# 0.9.0 Release-Readiness / Preflight
**Stand:** 2026-03-14

Dieses Dokument definiert den Scope-Freeze und den standardisierten Preflight fuer den Weg zu `0.9.0`.

## Scope-Freeze (S11C4)

### In Scope fuer 0.9.0
- Cost-Gesamtsicht mit explizitem Integrationsmodus `--maintenance-source none|module`
- Stabiler Fallback-Contract im Modulmodus (`maintenance_source_active`, `maintenance_source_note`)
- Regressions- und CI-Haertung fuer beide Integrationsmodi
- Konsistente Doku/Contract-Abbildung fuer den Cost-/Module-Pfad

### Out of Scope fuer 0.9.0
- Neue fachliche Domains ausserhalb Fuel/Maintenance-Cost-Integration
- GUI/Web/API-Einfuehrung
- Grossoffensive Uebersetzungs- oder Redesign-Arbeiten ohne direkten 0.9.0-Bezug
- Nicht-regressionsgetriebene Refactorings mit hohem Risiko kurz vor Release

## Automatischer Preflight

Empfohlen aus dem Projektroot:

```bash
make release-preflight
```

Entspricht:
- `make verify`
- `make smoke-fixtures`
- `./kpr.sh --dry-run --note "<...>"`
- `scripts/backup_snapshot.sh --dry-run --note "<...>"`

Schneller Lauf ohne Vollsuite:

```bash
scripts/release_preflight.sh --skip-verify
```

## Release-Checkliste (0.9.0)

1. Scope-Freeze ist aktiv (keine neuen Features, nur Release-kritische Fixes).
2. `make release-preflight` ist lokal gruen.
3. Letzter GitHub-Run `CI / verify` auf `main` ist gruen.
4. `docs/CHANGELOG.md` und `docs/STATUS.md` sind auf finalen 0.9.0-Stand synchronisiert.
5. `APP_VERSION` wird erst mit expliziter Release-Freigabe auf `0.9.0` gesetzt.
6. Release-Archiv wird erst nach finaler Freigabe erzeugt:
   - `./kpr.sh --note "Release 0.9.0 final"`
7. Optionales Backup direkt nach Release:
   - `scripts/backup_snapshot.sh --note "Backup after release 0.9.0"`

## Hinweis zur Branch-Protection

Vor Release sicherstellen:
- Branch-Protection fuer `main` aktiv
- Required Status Check: `CI / verify`
