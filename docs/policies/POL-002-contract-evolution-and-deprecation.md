# POL-002: Contract Evolution and Deprecation Policy
**Stand:** 2026-03-15
**Status:** active
**Datum:** 2026-03-15

## Ziel

Diese Policy definiert den verbindlichen Ablauf fuer Weiterentwicklung und
Abkuendigung von maschinenlesbaren Contracts:

- JSON-Outputs
- CSV-Outputs
- CLI-Flags/-Semantik

## Geltungsbereich

Verbindlich fuer:

- Core-CLI (`src/Betankungen.lpr`, `units/*`)
- Companion-Module mit eigenem Contract (z. B. `maintenance_stats_v1`)
- zugehoerige Doku und Regressionstests

## Regeln

1. Additiv ist der Standard
- Bestehende Felder/Spalten/Flags bleiben stabil.
- Erweiterungen erfolgen bevorzugt additiv.

2. Breaking Changes sind explizit und selten
- JSON/CSV-Breaking-Changes erfordern einen Contract-Bump
  (`contract_version++`).
- Bei Breaking-Changes sind verpflichtend:
  - Changelog-Eintrag unter `[Unreleased] -> Changed`
  - Doku-Update (`docs/EXPORT_CONTRACT.md` und betroffene Entry-Doku)
  - Regressionstest-Update im selben Change-Set

3. CLI-Deprecation-Lifecycle
- Phase A (`announced`): Nachfolger ist verfuegbar, alter Pfad bleibt nutzbar.
- Phase B (`deprecated`): alter Pfad ist als abgekuendigt dokumentiert
  (Help/Doku/Changelog), Verhalten bleibt kompatibel.
- Phase C (`removed`): Entfernung fruehestens nach mindestens einem
  dokumentierten Minor-Zyklus seit Ankuendigung.

4. Keine stillen Semantik-Wechsel
- Bedeutungswechsel bestehender Flags ohne dokumentierte Migration sind nicht
  erlaubt.
- Falls ein Wechsel zwingend ist, muss er als Breaking Change behandelt werden.

5. Maschinenfreundliche Ausgabe bleibt stabil
- Keine unkontrollierten Zusatztexte in JSON/CSV.
- Deprecation-Hinweise fuer Maschinenpfade werden ueber Doku/Help/Changelog
  kommuniziert, nicht durch instabile Payload-Aenderungen.

## Mindest-Artefakte pro Contract-Aenderung

- aktualisierte Doku (`EXPORT_CONTRACT`, ggf. `MODULES_ARCHITECTURE`)
- aktualisierte Tests (Domain-Policy/Regression/Smoke)
- Changelog-Eintrag mit Datum

## Referenzen

- `docs/EXPORT_CONTRACT.md`
- `docs/MODULES_ARCHITECTURE.md`
- `docs/DESIGN_PRINCIPLES.md`
- `docs/CHANGELOG.md`
