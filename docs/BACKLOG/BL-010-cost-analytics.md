# BL-010 - Cost Analytics
**Stand:** 2026-03-15
**Status:** next
**Typ:** Stats-/Domain-Erweiterung (cross-module)

## Motivation

Ein zentraler Wunsch vieler Nutzer:

Was kostet mein Fahrzeug pro Kilometer?

## Feature

Neuer Statistikmodus:

`--stats cost`

## Beispieloutput

- Fuel cost/km
- Maintenance cost/km
- Total cost/km

## Berechnung

`total_cost = fuel_cost + maintenance_cost`

`cost_per_km = total_cost / gefahrene_km`

## Voraussetzung

Integration von:

- fuel
- maintenance

## Hinweis zum aktuellen Stand

- Sprint 8 ist gestartet.
- S8C1/4 liefert eine Cost-MVP-Basis (`--stats cost`) als Textausgabe:
  - fuel-basierte Kosten ueber gueltige Volltank-Zyklen
  - maintenance aktuell als Placeholder (`0`), bis Modul-Integration verfuegbar ist
- S8C2/4 erweitert den MVP um JSON (`--stats cost --json [--pretty]`) mit Export-Meta und `kind: "cost_mvp"`.
- S8C3/4 haertet Guardrails regressionssicher (`--csv`, `--monthly`, `--yearly`, `--dashboard` bleiben fuer Cost-MVP ungueltig).
- S9C1/4 schaltet den Cost-CLI-Scope frei: `--stats cost` akzeptiert jetzt `--from/--to` und `--car-id`.
- S9C2/4 aktiviert die Scope-Auswertung im Collector/Textpfad: Zeitraum- und Fahrzeugfilter wirken jetzt auf die Cost-Aggregation.
- S9C3/4 erweitert den Cost-JSON-Contract um Scope-/Period-Felder (`scope_*`, `period_*`) und synchronisiert den Export-Contract-Check.
- S9C4/4 haertet Guardrails regressionssicher fuer Cost-Scope (Domain-Policy `P-061`: Car-/Period-Isolation) und finalisiert den Sprint-9-Nachweis.
- S11C1/4 fuehrt den expliziten Integrationsmodus fuer Cost ein: `--maintenance-source none|module`.
- S11C2/4 aktiviert den Modulpfad: bei `--maintenance-source module` werden Maintenance-Kosten aus dem Companion-Contract (`maintenance_stats_v1`) integriert; bei nicht verfuegbarer Quelle greift ein expliziter, robuster Fallback (`maintenance_source_active=false`, `maintenance_source_note`).
- S11C3/4 haertet die Verify-/CI-Kette fuer beide Integrationsmodi: neuer Regression-Check `tests/regression/run_cost_integration_modes_check.sh` prueft `none`, aktives `module` sowie Fallback-Szenarien als Pflicht-Gate.
- S11C4/4 finalisiert den 0.9.0-Readiness-Pfad: Scope-Freeze + standardisierter Release-Preflight (`scripts/release_preflight.sh`, `make release-preflight`, `docs/RELEASE_0_9_0_PREFLIGHT.md`).

## Vorschlagsabgleich (2026-03-15)

- Vorschlag "ADR Core-zu-Modul-Integrationscontract" ist bereits umgesetzt
  (S11C1/4 + S11C2/4) und benoetigt kein weiteres separates Backlog-Item.
- Vorschlag "BL Cost-Scope-UX" ist bereits umgesetzt
  (S9C2/4 Text-Scope + S9C3/4 JSON-Scope/Period + P-061-Guardrails).
- Offene Folgearbeiten fuer Cost bleiben separat und werden nicht als Duplikat
  dieser bereits abgeschlossenen Punkte gefuehrt.
