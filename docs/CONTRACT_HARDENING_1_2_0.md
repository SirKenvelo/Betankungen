# Contract Hardening 1.2.0
**Stand:** 2026-03-18
**Status:** aktiv (Gate 3, DoD konkretisiert in S20C3)

## Ziel

Diese Checklist operationalisiert Gate 3 fuer die 1.2.0-Linie und macht den
Verify-/Contract-DoD fuer den scope-frozen Umfang (`BL-0020`, `BL-0021`)
transparent und pruefbar.

## Scope-Bloecke

- Ops-/Feature-Block: `BL-0020` + `TSK-0008`, `TSK-0009`
  (Multi-DB-Backup-Operations inkl. Dry-Run-, Fehler- und Integritaetspfad).
- Feature-Block: `BL-0021` + `TSK-0010`, `TSK-0011`
  (Receipt-Link-Contract, optionaler Write-Path, Output-/Privacy-Guardrails).

## Checklist-Matrix (Gate 3)

| Bereich | DoD-Anforderung | Nachweisstand |
|---|---|---|
| Backup-Contract | Single-/All-Backup-Contract inkl. Dry-Run, Exit-/Fehlerregeln und Integritaetsindex dokumentiert. | done |
| Backup-Regression | Erfolgs- und Fehlerpfade (fehlende DB, Rechteproblem, Teilfehler) sind per Regression/Smoke abgedeckt. | done |
| Receipt-Link-Contract | Feld-/Validierungsregeln fuer Beleglinks sind additiv und eindeutig dokumentiert. | done |
| Receipt-Write-Path | Optionaler Link-Pfad fuer neue Fuelups ist append-only-kompatibel umgesetzt und getestet. | done |
| Output-/JSON-Contract | Text-/JSON-Ausgabe fuer Link gesetzt/leer/ungueltig ist stabil und nachvollziehbar. | done |
| Doku-Governance | Entry-/Status-/Sprint-/Changelog-/Roadmap-Verweise sind auf Scope und Gate-Stand synchron. | done |
| Policy-Fit | Keine stillen Breaks (`POL-002`), Privacy-/Retention-Leitplanken (`POL-003`) bleiben eingehalten. | done |

## Exit-Kriterien Gate 3

- Alle release-blocking Matrixpunkte stehen auf `done`.
- `make verify` ist gruen.
- Scope-Freeze bleibt unverletzt (`BL-0020`, `BL-0021` als alleiniger
  1.2.0-Release-Kern).
- Offene Punkte fuer Gate 4 sind explizit als RC-Themen dokumentiert.

## Nicht-Ziele in Gate 3

- Keine finale 1.2.0-Release-Umschaltung.
- Keine produktive API-Polling-Integration (`BL-0017`, `BL-0018`).
- Kein Community-/Scaffolder-Block als 1.2.0-Release-Blocker
  (`BL-0016`, `BL-0011`).

## Fortschritt (S20C4, Stand 2026-03-18)

- `BL-0020` ist auf `done` umgesetzt:
  - Runner: `scripts/db_backup_ops.sh`
  - Regression: `tests/regression/run_db_backup_ops_check.sh`
  - Verify-Verdrahtung: `make db-backup-ops-check` und Aufnahme in `make verify`
- `BL-0021` ist auf `done` umgesetzt:
  - CLI: `--receipt-link` (nur `--add fuelups`) inkl. Guardrails fuer Scope/Wert.
  - Write-Path: persistentes Feld `fuelups.receipt_link` (additive Migration).
  - Output/Contract: Detailausgabe mit `Receipt link: ...` sowie JSON-Contract-Felder
    `receipt_links_set`/`receipt_links_missing` fuer fuelups full/monthly/yearly.
  - Regression: `tests/regression/run_receipt_link_contract_check.sh`
  - Verify-Verdrahtung: `make receipt-link-check` und Aufnahme in `make verify`
