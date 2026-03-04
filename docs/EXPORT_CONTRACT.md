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
- `report` / `data` (projektabhaengige Payload-Bezeichnung)

## CSV Contract

- Erste Spalte: `contract_version`
- Header ist API (stabil)
- Strict CSV: keine Kommentare, keine impliziten Escaping-Annahmen

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
