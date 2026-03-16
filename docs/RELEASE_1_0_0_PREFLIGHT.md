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
- Gate 4 (S15): abgeschlossen am 2026-03-16 (S15C1/4 bis S15C4/4 dokumentiert).
- Scope-Freeze ist aktiv: nur release-relevante Fixes und Doku-Syncs mit direktem 1.0.0-Bezug.
- Governance-Mindeststand fuer `main`: PR-only, Required-Check `verify`, up-to-date-Pflicht, Conversation-Resolution, Admin-Enforcement.

## RC-Abschlusslauf-Nachweis (S15C3)

### Lokal (2026-03-16)
- Befehl: `make release-preflight-1-0-0`
- Ergebnis: erfolgreich (inkl. `make verify`, Doku-Gate-Checks und Dry-Runs fuer Release-/Backup-Werkzeuge).

### CI-Referenz auf `main`
- Workflow: `CI` (`verify`)
- Run-ID: `23153384396`
- Commit: `a59cb6e` (`[S15C2/4] ... (#12)`)
- Ergebnis: `success`
- URL: `https://github.com/SirKenvelo/Betankungen/actions/runs/23153384396`

## Gate-4-Abschlussnarrativ (S15C4)

- Das Gate-4-Exit-Kriterium ("RC-Kandidat ist releasefaehig und reproduzierbar")
  ist auf Dokumentenebene als erreicht bewertet.
- Die Preflight-/Verify-Kette ist operationalisiert und nachweislich gruen
  (lokal + CI-Referenz auf `main`).
- Scope-Freeze und Governance-Leitplanken fuer den finalen Abschnitt bleiben aktiv.
- Der naechste Schritt ist Gate 5: finaler Release-Umschalt-Commit, finaler
  Doku-Sync und anschliessende Ausfuehrung von Release-/Backup-Schritten
  nach expliziter Freigabe.

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
2. Gate-Status ist konsistent dokumentiert (`ROADMAP_1_0_0.md`, `STATUS.md`, `SPRINTS.md`): Gate 1/2/3/4 abgeschlossen.
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
