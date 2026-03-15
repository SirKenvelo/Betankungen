# BL-012 - GitHub Wiki Enablement
**Stand:** 2026-03-15
**Status:** geplant
**Typ:** Dokumentations-/Community-Enablement (Public-Readiness)

## Motivation

Mit oeffentlicher Sichtbarkeit steigt der Bedarf nach einem kuratierten Einstieg:

- schnellere Orientierung fuer neue Leser
- weniger wiederholte Fragen in Issues/Discussions
- klarerer Einstieg fuer potenzielle Contributions

Ein GitHub-Wiki bietet dafuer eine leichtgewichtige, gut auffindbare Schicht
oberhalb der Detaildokumentation im Repository.

## Zielbild (v1)

Das Wiki dient als kuratierter Einstieg, waehrend die Repository-Doku die
technische Source of Truth bleibt.

## Scope v1

- Wiki aktivieren und Basisseiten strukturieren:
  - Home / Project Overview
  - Getting Started (Build, Verify, Smoke)
  - CLI Quick Reference
  - Architecture Short Guide
  - FAQ / Troubleshooting
  - Troubleshooting-Playbooks fuer wiederkehrende Fehlerbilder
- Klare Abgrenzung dokumentieren:
  - Wiki = Einstieg / Navigation
  - Repo-Doku (`docs/`) = verbindliche Details
- Verlinkung in beide Richtungen:
  - Root-`README.md` -> Wiki
  - Wiki-Seiten -> relevante `docs/*.md`
- Link-Qualitaet absichern:
  - regelmaessiger Link-Check fuer Wiki-Einstiegsseiten und zentrale Repo-Links
- Pflegeprozess definieren:
  - wann Wiki-Updates Pflicht sind
  - welche Inhalte nur im Repo gepflegt werden

## Nicht-Ziele v1

- Keine vollstaendige Spiegelung der gesamten `docs/`-Historie im Wiki
- Keine Redundanz bei tiefen technischen Contracts
- Keine Ersatzstruktur fuer ADR/Changelog/Sprint-Traceability

## Akzeptanzkriterien

- Wiki ist aktiviert und hat mindestens die v1-Basisseiten.
- Jede Wiki-Seite verlinkt auf konkrete Source-of-Truth-Dokumente im Repo.
- Einstieg fuer externe Leser ist in <= 3 Klicks von Repo-Startseite erreichbar.
- Pflegehinweis ist in `README.md` oder `CONTRIBUTING.md` dokumentiert.

## Abhaengigkeiten / Hinweise

- Sinnvoll vor oder waehrend der Public-Schaltung des Repositories.
- Sprachstrategie bleibt inkrementell: Wiki kann mit EN-Entry starten und
  auf DE-Details verweisen, bis weitere Inhalte schrittweise uebersetzt sind.

## Vorschlagsabgleich (2026-03-15)

Der Vorschlag "Public-Readiness-Doku-Paket (Wiki + FAQ + Troubleshooting +
Link-Checks)" wird in diesem Backlog-Eintrag konsolidiert und nicht als
separates neues Legacy-BL dupliziert.

## Derived Task (Tracker)

- `TSK-0005` (`docs/tasks/TSK-0005-public-readiness-wiki-v1-bootstrap.md`)
  operationalisiert die v1-Umsetzung fuer Gate-Plan 1.0.0.
