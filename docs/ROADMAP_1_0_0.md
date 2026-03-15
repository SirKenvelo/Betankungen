# Verbindlicher Fahrplan bis Version 1.0.0
**Stand:** 2026-03-15
**Status:** verbindlich

## Umsetzungsstand (2026-03-15)

- Gate 1 (S12): abgeschlossen.
- Gate 2 (S13): in Arbeit (`BL-0012` fachlich abgeschlossen; Contract-Haertung laeuft weiter).
- Gate 3-5: offen.

## Ausgangslage

- Version `0.9.0` ist seit `2026-03-15` final freigegeben.
- Der naechste Entwicklungszyklus laeuft auf die `1.0.0`-Finalisierung.
- Dieser Fahrplan ist gate-basiert (verbindliche Qualitaetskriterien statt Kalenderzwang).

## Verbindliche Leitplanken

- CLI-first bleibt unveraendert (kein GUI-/Web-API-Shift).
- Kein Overengineering: zuerst korrekt, dann schnell, dann schoen.
- Keine Runtime-Config-Profile im Core (`ADR-0009` ist `rejected`).
- Contract-Evolution strikt nach `POL-002` (additiv bevorzugt, Breaking nur explizit).
- Backup-/Restore-/Privacy-Regeln strikt nach `POL-003`.
- Core-vs-Module-Grenzen bleiben verbindlich (`ADR-0005` / `ADR-0007`).

## Scope fuer 1.0.0

### Muss (Release-blockierend)

1. Capability-Discovery fuer Module (`BL-0012`) produktiv machen:
- `--module-info` liefert stabile `capabilities`-Felder.
- Doku + Smoke-/Regression-Absicherung sind Bestandteil desselben Changesets.

2. Contract-Haertung finalisieren:
- JSON/CSV/CLI-Vertraege fuer bestehende Pfade sind dokumentiert und regressionssicher.
- Deprecation-/Breaking-Regeln aus `POL-002` sind in Doku und Prozess sichtbar angewendet.

3. Release-Gates fuer 1.0.0 scharf ziehen:
- `make verify` gruener Pflichtlauf.
- standardisierter Release-Preflight fuer 1.0.0 dokumentiert und genutzt.
- Changelog/Status/Sprints konsistent auf Final-Stand.

4. Public-Readiness-Mindestpaket liefern (`BL-012`):
- kuratierter Einstieg (Wiki/FAQ/Troubleshooting/Link-Check-Flow) steht.
- klare Trennung: Wiki = Einstieg, `docs/` = Source of Truth.

### Soll (nicht release-blockierend)

- Trigger-basierter Performance-Benchmark-Harness (`BL-0013`) als optionales Werkzeug fertigstellen.

### Nicht Teil von 1.0.0

- Runtime-Config-Profile im Programm (`ADR-0009`, abgelehnt).
- Import-/Export-Paketformat mit Manifest/Checksum (`BL-0014`, spaeterer Zyklus).
- Architekturwechsel weg vom CLI-Kern.

## Gate-Plan bis 1.0.0

### Gate 1: Zyklusstart (S12)

- Entwicklungsbasis auf `1.0.0-dev` gesetzt.
- Fahrplan + Scope in Entry-Doku (`README`, `STATUS`, `SPRINTS`) verankert.
- Backlog-Items `BL-0012`, `BL-012`, `BL-0013` in konkrete Tasks heruntergebrochen.

Exit-Kriterium:
- Keine offenen Scope-Unklarheiten mehr fuer den 1.0.0-Zyklus.

Status:
- abgeschlossen am 2026-03-15 (Version `1.0.0-dev`, Entry-Doku-Sync,
  Task-Downstream fuer `BL-0012`, `BL-0013`, `BL-012` via
  `TSK-0002..TSK-0005`).

### Gate 2: Contract + Modulfaehigkeiten (S13)

- `BL-0012` umgesetzt (Capabilities im Modul-Contract).
- `EXPORT_CONTRACT`/`MODULES_ARCHITECTURE` aktualisiert.
- Domain-/Smoke-/Regressionstests fuer Capability-Pfade gruen.

Exit-Kriterium:
- Core kann modulare Features explizit ueber Contract erkennen (keine impliziten Annahmen).

Status:
- in Arbeit seit 2026-03-15.
- Fortschritt am 2026-03-15:
  - `BL-0012` abgeschlossen (`capabilities`-Contract v1 dokumentiert + Runtime + Smoke).
  - Restscope fuer Gate 2 bleibt aktiv (weitere Contract-Haertung / Integrationsnutzung).

### Gate 3: Public-Readiness (S14)

- `BL-012` v1 umgesetzt (Wiki-Struktur, FAQ, Troubleshooting-Basis, Link-Checks).
- EN-Einstiegspunkte fuer externe Leser konsistent erreichbar.

Exit-Kriterium:
- Ein externer Leser kommt in <= 3 Klicks von Repo-Start zu Build/Verify/CLI-Einstieg.

### Gate 4: Release-Candidate-Haertung (S15)

- Feature-Freeze fuer 1.0.0.
- Vollstaendiger Verify-/Preflight-Lauf ohne offene Blocker.
- Nur noch Fixes mit direktem Release-Bezug.

Exit-Kriterium:
- RC-Kandidat ist releasefaehig und reproduzierbar.

### Gate 5: Finalisierung 1.0.0

- `APP_VERSION` von `1.0.0-dev` auf `1.0.0`.
- Finaler Doku-Sync (`CHANGELOG`, `STATUS`, `README`, `SPRINTS`).
- Release-Artefakt erzeugen (`./kpr.sh --note "Release 1.0.0 final"`).
- Optionaler Direkt-Backup nach Release (`scripts/backup_snapshot.sh --note "Backup after release 1.0.0"`).

Exit-Kriterium:
- 1.0.0 ist final freigegeben und vollstaendig nachvollziehbar dokumentiert.

## Verbindliche Abweichungsregel

Abweichungen von diesem Fahrplan sind nur gueltig, wenn sie im gleichen Change
explizit dokumentiert werden in:

- `docs/ROADMAP_1_0_0.md`
- `docs/STATUS.md`
- `docs/CHANGELOG.md` (unter `[Unreleased] -> Changed`)
