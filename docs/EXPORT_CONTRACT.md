# EXPORT CONTRACT
**Stand:** 2026-03-04

Zweck: Stabiler Export-Vertrag fuer maschinenlesbare Ausgabeformate (JSON/CSV).

## Contract Versioning

- `contract_version: 1` (Start)
- Breaking Change => `contract_version` erhoehen (`contract_version++`)

## JSON Contract

Pflichtfelder:
- `contract_version`
- `generated_at`
- `app_version`

Payload (v1, aktueller Stand):
- Report-Kennung: Feld `kind` (z. B. `fuelups_monthly`, `fuelups_yearly`, `fuelups_full_tank_cycles`)
- Nutzdaten: vorhandene Payload-Felder (`rows` bei monthly/yearly, `cycles`/`sum` bei full_tank_cycles)

## CSV Contract

- Erste Spalte: `contract_version`
- Header ist API (stabil)
- Strict CSV: keine Kommentare, keine impliziten Escaping-Annahmen
- `--yearly` hat keinen CSV-Export (Kombination `--yearly --csv` ist ungueltig).

## Scope-Regeln

- 1 Car: `--car-id` optional
- >1 Cars: `--car-id` verpflichtend

## Period-Regeln

- `from` inklusiv
- `to` exklusiv

## Stability Rules

- Keine Feldentfernung
- Nur additive Erweiterungen
- CSV-Spaltenreihenfolge bleibt stabil
