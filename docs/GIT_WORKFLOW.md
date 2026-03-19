# Git- und PR-Workflow fuer Betankungen
**Stand:** 2026-03-19

## Ziel

Dieser Workflow stellt sicher:

- klare Sprint-Struktur
- nachvollziehbare Commit-Historie
- stabile Commit-Hashes
- konsistente Artefakte pro Commit
- saubere Integration nach `main`

## Verbindlichkeit

- Diese Datei ist die kanonische Arbeitsanleitung fuer Branch-/Commit-/PR-/Merge-Entscheidungen.
- `AGENTS.md` verweist auf diese Leitplanke und bleibt dazu konsistent.
- Bei Widerspruch gilt: erst `docs/GIT_WORKFLOW.md` aktualisieren, dann Ableitungen in `AGENTS.md`/`docs/README.md` nachziehen.

## Grundprinzip

Fuer das Projekt Betankungen gilt:

- **1 Sprint = 1 Branch**
- **1 Sprint = 1 Pull Request**
- **mehrere Commits pro Sprint sind erlaubt und gewuenscht**
- **Artefakte pro Commit sind erlaubt und gewuenscht**
- **Standard-Merge: Create a merge commit**
- **Squash nur in Ausnahmefaellen**
- **Rebase-Merge wird nicht verwendet**

## Branch-Strategie

### Hauptbranch

- `main` = stabiler Integrationsbranch

### Arbeitsbranches

Fuer jeden Sprint wird ein eigener Branch erstellt.

Beispiele:

- `feat/1-2-0-gate4-hardening`
- `chore/1-2-0-gate3-closeout-gate4-kickoff`

### Regel

Ein Branch enthaelt genau ein zusammenhaengendes Thema (z. B. ein Sprint).

## Commit-Regeln

### Anforderungen

Jeder Commit soll:

- einen klaren fachlichen Zweck haben
- einzeln verstaendlich sein
- sinnvoll abgegrenzt sein

### Beispielstruktur

- `S22C1/4 ...`
- `S22C2/4 ...`
- `S22C3/4 ...`
- `S22C4/4 ...`

### Nicht erlaubt

- unsaubere WIP-Commits
- grosse Sammelcommits ohne Struktur
- nachtraegliches Zusammenquetschen sauberer Sprint-Commits

## Artefakte pro Commit

### Arten

- `.diff`
- `.md`
- Screenshots / Nachweise

### Hash-Regel

Der Commit-Hash muss:

- direkt aus Git stammen
- technisch korrekt sein
- **niemals geschaetzt oder erfunden werden**

### Short-Hash

Verwendet wird ein echter 7-stelliger Hash:

Beispiel:

- `abc1234`

### Wichtig

Artefakte beziehen sich immer auf den **originalen Commit**, nicht auf den spaeteren Merge-Commit.

## Push-Strategie

Waehrend eines Sprints:

- mehrere Commits erlaubt
- mehrere Pushes erlaubt

Es ist **nicht erforderlich**, alles erst am Ende zu pushen.

## Pull Requests

### Standard

- genau **ein PR pro Sprint**

### Inhalt

Der PR beschreibt:

- Ziel des Sprints
- durchgefuehrte Aenderungen
- relevante Dokumentationsanpassungen
- ggf. offene Punkte

### Zeitpunkt

Die Beschreibung wird **beim Erstellen des PR** gepflegt, nicht erst beim Merge.

## Merge-Regeln

### Standard

- **Create a merge commit**

### Warum?

- alle Commit-Hashes bleiben erhalten
- Sprint-Struktur bleibt sichtbar
- Artefakte bleiben korrekt zugeordnet
- vollstaendige Nachvollziehbarkeit

### Ausnahme: Squash

Erlaubt bei:

- kleinen Doku-Aenderungen
- einem einzelnen Commit
- irrelevanten Mini-Aenderungen

### Nicht verwenden: Rebase-Merge

Begruendung:

- erzeugt neue Commit-Hashes
- gefaehrdet Referenzen in Artefakten
- gefaehrdet Traceability

## Rebase-Regel

Sobald ein Commit ein offizielles Artefakt hat:

- **kein Rebase mehr**

Reihenfolge:

1. Commit-Struktur festlegen
2. Commit erstellen
3. Artefakt erzeugen
4. Hash bleibt unveraendert

## Sync-Regel fuer Arbeitskopien

- Session-Start: `git fetch` + `git pull --ff-only`
- Session-Ende: `git fetch` + `git pull --ff-only`
- Kein lokales Rebase von bereits artefakt-/traceability-relevanten Commits.

## Tagging-Regeln

- Sprint-Tagging (`sprint-<nr>-done`) nur nach komplett abgeschlossenem und freigegebenem Sprint.
- Release-/Version-Tags (z. B. `1.2.0`) nur nach expliziter User-Freigabe.

## Repository-Einstellungen

### Pull Requests

- Allow merge commits = **AN**
- Allow squash merging = **AN**
- Allow rebase merging = **AUS**

### Branch-Regeln (`main`)

- Require linear history = **AUS**

### Begruendung

Lineare Historie verhindert Merge Commits und widerspricht der gewuenschten Traceability.

## Standard-Ablauf

1. Branch erstellen
2. Sprint in mehreren Commits umsetzen
3. Artefakte pro Commit erzeugen
4. Hash per Git abfragen
5. regelmaessig pushen
6. PR erstellen (einmal pro Sprint)
7. PR sauber dokumentieren
8. Merge via **Create a merge commit**
9. Branch loeschen

## Entscheidungsregeln

Wenn unklar ist:

- Gibt es Artefakte mit Commit-Hash?
  - Ja -> Merge Commit
- Mehrere sinnvolle Commits?
  - Ja -> Merge Commit
- Nur ein kleiner Commit ohne Relevanz?
  - Ja -> Squash moeglich

## Kurzfassung

- 1 Sprint = 1 Branch
- 1 Sprint = 1 PR
- mehrere Commits erlaubt
- Artefakte pro Commit erwuenscht
- Hash immer echt
- kein Rebase nach Artefakt-Erstellung
- Standard: **Create a merge commit**
