# Verbindlicher Fahrplan bis Version 1.1.0
**Stand:** 2026-03-16
**Status:** aktiv (`APP_VERSION=1.1.0-dev`)

## Ausgangslage

- `1.0.0` wurde am 2026-03-16 final freigegeben.
- Die aktive Entwicklungsbasis ist auf `1.1.0-dev` umgestellt.
- Dieser Fahrplan ist gate-basiert (Qualitaetskriterien vor Kalenderdatum).

## Verbindliche Leitplanken

- CLI-first bleibt unveraendert (kein GUI-/Web-API-Shift).
- Kein Overengineering: zuerst korrekt, dann schnell, dann schoen.
- Keine Runtime-Config-Profile im Core (`ADR-0009` ist `rejected`).
- Contract-Evolution strikt nach `POL-002` (additiv bevorzugt, Breaking nur explizit).
- Backup-/Restore-/Privacy-Regeln strikt nach `POL-003`.
- `main` bleibt geschuetzter PR-Branch mit gruenem `verify` als Mindestgate.

## Scope fuer 1.1.0

### Muss (release-blockierend)

1. Scope-Commit fuer 1.1.0 ist im Tracker festgezogen:
- priorisierter Feature-Block: `BL-0014` (status `approved`) mit Task `TSK-0006`;
- priorisierter Hardening-Block: `BL-0015` (status `approved`) mit Task `TSK-0007`;
- explizite Out-of-Scope-Liste gegen Scope-Drift.

2. Contract-sichere Umsetzung:
- keine stillen Breaking-Changes in JSON/CSV/CLI;
- neue/erweiterte Ausgabe nur mit Doku + Regression.

3. Release-Pfad fuer 1.1.0 vorbereiten:
- eigener 1.1.0-Preflight mit klaren Gate-Checks;
- nachvollziehbare Doku-Synchronisierung (`STATUS`, `SPRINTS`, `CHANGELOG`).

4. Public-Readiness stabil halten:
- Wiki-/Entry-Links und Build-/Verify-Einstieg bleiben konsistent.

### Soll (nicht release-blockierend)

- Zusaeztliche Trackerthemen bleiben ausserhalb des 1.1.0-Scope-Freeze,
  solange sie nicht als Blocker fuer `BL-0014`/`BL-0015` nachgewiesen sind.

### Nicht Teil von 1.1.0

- Runtime-Config-Profile im Programm (`ADR-0009`, abgelehnt).
- Vollstaendige Import-Pipeline mit Migrationsautomatik in 1.1.0.
- Big-Bang-Uebersetzung der gesamten Detaildoku vor Release.
- Architekturwechsel weg vom CLI-Kern.

## Gate-Plan bis 1.1.0

### Gate 1: Zyklusstart (S16C1/4)

- Entwicklungsbasis auf `1.1.0-dev` aktiv.
- Verbindlicher 1.1.0-Fahrplan dokumentiert.
- Entry-Doku auf aktiven 1.1-Zyklus synchronisiert.

Exit-Kriterium:
- Der 1.1.0-Zyklus ist mit klaren Leitplanken gestartet.

Status:
- abgeschlossen am 2026-03-16.

### Gate 2: Scope-Freeze 1.1.0

- Priorisierte Bloecke sind final festgelegt:
  - Feature-Block `BL-0014` + `TSK-0006`
  - Hardening-Block `BL-0015` + `TSK-0007`
- Out-of-Scope-Liste ist explizit dokumentiert (kein Profilmodus, keine volle
  Import-Pipeline in 1.1.0, kein Architekturwechsel).
- Tracker-Downstream und DoD/Grenzen sind dokumentiert.

Exit-Kriterium:
- Kein fachlicher Scope-Drift fuer den laufenden 1.1.0-Zyklus.

Status:
- abgeschlossen am 2026-03-16.

### Gate 3: Umsetzung + Contract-Haertung

- Umsetzungsblock abgeschlossen.
- Contract-Doku und Regressionen fuer neue/erweiterte Pfade gruen.

Exit-Kriterium:
- Zyklusumfang fachlich fertig und regressionssicher.

Status:
- aktiv.

### Gate 4: Release-Candidate-Haertung

- Feature-Freeze aktiv.
- Vollstaendiger Verify-/Preflight-Lauf ohne offene Blocker.

Exit-Kriterium:
- RC-Kandidat ist releasefaehig und reproduzierbar.

Status:
- pending.

### Gate 5: Finalisierung 1.1.0

- `APP_VERSION` von `1.1.0-dev` auf `1.1.0`.
- Finaler Doku-Sync und Release-/Backup-Ausfuehrung nach Freigabe.

Exit-Kriterium:
- 1.1.0 ist final freigegeben und nachvollziehbar dokumentiert.

Status:
- pending.

## Verbindliche Abweichungsregel

Abweichungen von diesem Fahrplan sind nur gueltig, wenn sie im gleichen Change
explizit dokumentiert werden in:

- `docs/ROADMAP_1_1_0.md`
- `docs/STATUS.md`
- `docs/CHANGELOG.md` (unter `[Unreleased] -> Changed`)
