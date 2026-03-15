# 1.0.0 Release-Readiness / Preflight
**Stand:** 2026-03-15

Dieses Dokument definiert den Scope-Freeze und den standardisierten Preflight
fuer den Weg zu `1.0.0`.

## Scope-Freeze (S15)

### In Scope fuer 1.0.0
- Contract-Stabilitaet fuer bestehende JSON/CSV/CLI-Pfade gemaess `POL-002`
- Verifizierte Core-zu-Modul-Faehigkeitsintegration (`BL-0012`)
- Public-Readiness-Mindestpaket mit aktivem Wiki-v1 (`BL-012`)
- Reproduzierbarer lokaler Verify-/Preflight-Lauf ohne offene Blocker

### Out of Scope fuer 1.0.0
- Neue Runtime-Config-Profile im Core (`ADR-0009` rejected)
- Neue breite Domains ohne direkten Release-Bezug
- Grossoffensive Uebersetzungs-/Redesign-Arbeiten ohne Gate-Relevanz
- Forschungsthemen ohne unmittelbaren 1.0.0-Nutzen (z. B. `BL-0014`)

## Automatischer Preflight

Empfohlen aus dem Projektroot:

```bash
make release-preflight-1-0-0
```

Entspricht:
- `make verify`
- `make smoke-fixtures`
- `./kpr.sh --dry-run --note "<...>"`
- `scripts/backup_snapshot.sh --dry-run --note "<...>"`

Schneller Lauf ohne Vollsuite:

```bash
scripts/release_preflight_1_0_0.sh --skip-verify
```

## Release-Checkliste (1.0.0)

1. Scope-Freeze ist aktiv (nur release-relevante Fixes).
2. `APP_VERSION` steht vor dem finalen Umschalt-Commit auf `1.0.0-dev`.
3. `make release-preflight-1-0-0` ist lokal gruen.
4. Letzter GitHub-Run `CI / verify` auf `main` ist gruen.
5. `docs/CHANGELOG.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md` sind auf finalen Stand synchronisiert.
6. Finaler Release-Commit setzt `APP_VERSION` von `1.0.0-dev` auf `1.0.0`.
7. Release-Artefakt erst nach finaler Freigabe erzeugen:
   - `./kpr.sh --note "Release 1.0.0 final"`
8. Optionales Backup direkt nach Release:
   - `scripts/backup_snapshot.sh --note "Backup after release 1.0.0"`

## Hinweis zur Branch-Protection

Vor Release sicherstellen:
- Branch-Protection fuer `main` aktiv
- Required Status Check: `verify`
