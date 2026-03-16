# 1.0.0 Release-Readiness / Preflight
**Stand:** 2026-03-16

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

## RC-Status-Snapshot (Stand 2026-03-16)

- Gate 1 (S12): abgeschlossen.
- Gate 2 (S13): abgeschlossen.
- Gate 3 (S14): abgeschlossen.
- Gate 4 (S15): in Arbeit (S15C1/4 und S15C2/4 abgeschlossen; RC-Abschlusslauf folgt in S15C3/4).
- Scope-Freeze ist aktiv: nur release-relevante Fixes und Doku-Syncs mit direktem 1.0.0-Bezug.
- Governance-Mindeststand fuer `main`: PR-only, Required-Check `verify`, up-to-date-Pflicht, Conversation-Resolution, Admin-Enforcement.

## Automatischer Preflight

Empfohlen aus dem Projektroot:

```bash
make release-preflight-1-0-0
```

Entspricht:
- Gate-Status-/Doku-Guardrails (`CONTRACT_HARDENING=done`, Gate-2-Abschluss in `ROADMAP_1_0_0.md` und `STATUS.md`)
- `make verify`
- `make smoke-fixtures`
- `./kpr.sh --dry-run --note "<...>"`
- `scripts/backup_snapshot.sh --dry-run --note "<...>"`

Schneller Lauf ohne Vollsuite:

```bash
scripts/release_preflight_1_0_0.sh --skip-verify
```

Optional ohne Doku-Guardrails:

```bash
scripts/release_preflight_1_0_0.sh --skip-doc-gates
```

## Release-Checkliste (1.0.0)

1. Scope-Freeze ist aktiv (nur release-relevante Fixes).
2. Gate-Status ist konsistent dokumentiert (`ROADMAP_1_0_0.md`, `STATUS.md`, `SPRINTS.md`): Gate 1/2/3 abgeschlossen, Gate 4 aktiv.
3. `APP_VERSION` steht vor dem finalen Umschalt-Commit auf `1.0.0-dev`.
4. `make release-preflight-1-0-0` ist lokal gruen.
5. Letzter GitHub-Run `CI / verify` auf `main` ist gruen.
6. `docs/CHANGELOG.md`, `docs/STATUS.md`, `docs/SPRINTS.md`, `docs/README.md` sind auf finalen Stand synchronisiert.
7. Contract-Hardening-Checklist ist vor Freeze explizit geprueft (`docs/CONTRACT_HARDENING_1_0_0.md`) und enthaelt keine offenen 1.0.0-Blocker.
8. Finaler Release-Commit setzt `APP_VERSION` von `1.0.0-dev` auf `1.0.0`.
9. Release-Artefakt erst nach finaler Freigabe erzeugen:
   - `./kpr.sh --note "Release 1.0.0 final"`
10. Optionales Backup direkt nach Release:
   - `scripts/backup_snapshot.sh --note "Backup after release 1.0.0"`

## Hinweis zur Branch-Protection

Vor Release sicherstellen:
- Branch-Protection fuer `main` aktiv
- Required Status Check: `verify`
