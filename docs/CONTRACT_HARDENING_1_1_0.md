# Contract Hardening 1.1.0
**Stand:** 2026-03-17
**Status:** aktiv (Gate 3)

## Ziel

Diese Checklist operationalisiert Gate 3 fuer die 1.1.0-Linie und macht
Verify-/Contract-DoD fuer den scope-frozen Umfang (`BL-0014`, `BL-0015`)
transparent und pruefbar.

## Scope-Bloecke

- Feature-Block: `BL-0014` + `TSK-0006`
  (Manifest-v1 + Dry-Run-Fixtures fuer Import-/Export-Pakete).
- Hardening-Block: `BL-0015` + `TSK-0007`
  (1.1.0-Preflight-Blueprint + Doku-Gates).

## Checklist-Matrix (Gate 3)

| Bereich | DoD-Anforderung | Nachweisstand |
|---|---|---|
| Paket-Contract | Manifest-v1-Felder inkl. Integritaetsregeln dokumentiert (additiv, versioniert). | done |
| Paket-Fixtures | Reproduzierbare Dry-Run-Fixtures fuer gueltig/ungueltig definiert. | done |
| Verify-Integration | Contract-/Fixture-Checks als optionaler Runner dokumentiert und lokal ausfuehrbar. | done |
| Preflight-Blueprint | 1.1.0-Preflight-Checkpunkte (Version, Doku-Gates, Dry-Runs) konsistent definiert. | open |
| Doku-Governance | Entry-/Status-/Sprint-/Changelog-Verweise auf Scope und Gate-Stand synchron. | done |
| Policy-Fit | Keine stillen Breaks (`POL-002`), keine Privacy-/Retention-Verletzung (`POL-003`). | in_progress |

## Exit-Kriterien Gate 3

- Alle Matrixpunkte stehen auf `done`.
- `make verify` ist gruen.
- Scope-Freeze bleibt unverletzt (`BL-0014`, `BL-0015` als alleiniger 1.1.0-Fokus).
- Offene Punkte fuer Gate 4 sind explizit als RC-Themen dokumentiert.

## Nicht-Ziele in Gate 3

- Keine finale 1.1.0-Release-Umschaltung.
- Keine Vollimplementierung einer produktiven Import-Pipeline.
- Keine Aufweichung der PR-only-Governance auf `main`.
