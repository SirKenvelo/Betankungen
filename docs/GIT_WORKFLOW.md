# Git- und PR-Workflow fuer Betankungen
**Stand:** 2026-04-20

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
- **Squash nur mit expliziter Override-/Task-Freigabe**
- **Rebase-Merge wird nicht verwendet**

## Artefakt-Domaenen (verbindlich)

Die kanonische Artefaktmatrix liegt in
`docs/policies/POL-004-artifact-domain-matrix.md`.

### Tracker-Dokumente

- Zweck: repo-seitige Arbeits-, Entscheidungs- und Policy-Artefakte unter
  `docs/backlog/`, `docs/issues/`, `docs/policies/` sowie dem lesbaren
  Legacy-Bestand.
- Erlaubte Struktur: tracker-spezifische Dokumentstruktur gemaess `POL-001`;
  `# Notes` bleibt dort die kanonische Notes-Form.
- Unzulaessige Struktur: PR-H2-Schemata als impliziter Standard fuer Tracker;
  `## Note` und `## Notes` bleiben in Tracker-Dateien unzulaessig.
- Pruefpfad: `docs/policies/POL-001-tracker-standard.md`,
  `scripts/projtrack_lint.sh`.

### PR-Bodies

- Zweck: GitHub-Review-Artefakt fuer Scope, Begruendung und lokale Validierung.
- Erlaubte Struktur: exklusive H2-Allowlist mit genau `## Summary` und
  `## Validation`.
- Unzulaessige Struktur: freie Zusatz-H2s wie `## Note`, `## Notes`,
  `## Scope Notes`, `## Follow-Ups` oder andere PR-nahe Neben-Schemata.
- Pruefpfad: `AGENTS.md`, dieses Dokument,
  `.github/pull_request_template.md`, Review bei PR-Erstellung.

### Merge-Commit-Messages

- Zweck: kompakte, historientaugliche Integrationsnachricht nach dem PR.
- Erlaubte Struktur: kurzer Betreff plus optional kurzer Plain-Body ohne
  uebernommene Template-H2s.
- Unzulaessige Struktur: ungekuerzte PR-Bodies oder Tag-Schemata mit
  `## Summary`, `## Validation`, `## Notes` oder `## Impact`.
- Pruefpfad: redaktionelle Pruefung direkt im GitHub-Merge-Dialog.

### Tag-Messages

- Zweck: signierte Sprint-/Release-Artefakte mit eigener Handoff-Struktur.
- Erlaubte Struktur: `## Summary`, `## Validation`, `## Impact`.
- Unzulaessige Struktur: stillschweigende Angleichung an PR- oder
  Merge-Commit-Strukturen.
- Pruefpfad: Tag-Erstellung mit `--cleanup=verbatim` und Rohpruefung per
  `git cat-file -p refs/tags/<tag>`.

### Prompt-/Template-Quellen

- Zweck: Quellen, die die obigen Artefaktregeln in Prompts, PR-Templates oder
  spaetere Automationspfade propagieren.
- Erlaubte Struktur: domainenscharfe Weitergabe der jeweils passenden Regeln.
- Unzulaessige Struktur: Vermischung der Domaenen, etwa wenn Tracker-`# Notes`
  oder Tag-H2s als PR-Schema weitergereicht werden.
- Pruefpfad: `.github/pull_request_template.md`, externe Prompt-/Template-
  Quellen in der Audit-Ablage, manuelle Governance-Reviews.

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

### Branch-Naming-Disziplin (verbindlich)

- Branch-Namen duerfen nicht frei erfunden, generisch oder platzhalterhaft
  sein.
- Unzulaessige Beispiele:
  `future-branch`, `future-sprint`, `test-branch`, `tmp`, `misc`, `update`,
  `changes`.
- Branch-Namen muessen dem hier beschriebenen Muster und dem fachlichen
  Sprint-/Themenzuschnitt entsprechen (z. B. `feat/...`, `fix/...`,
  `chore/...` mit klarer Scope-Aussage).
- Wenn kein regelkonformer Branch-Name sicher ableitbar ist, wird vor
  Commit/Push ein konkreter Namensvorschlag zur Freigabe eingeholt.

## Commit-Regeln

### Anforderungen

Jeder Commit soll:

- einen klaren fachlichen Zweck haben
- einzeln verstaendlich sein
- sinnvoll abgegrenzt sein

### Commit-Message-Konvention (verbindlich)

- Schema: `[Scope] type: kurze beschreibung`
- Beispiele:
  - `[General] docs: add transition hold before 1.4.0-dev`
  - `[General] release: finalize 1.3.0 gate5 closeout`
  - `[General] cli: improve first-run guidance`
- `Scope` steht immer in eckigen Klammern (z. B. `[General]`; fuer Sprint-Arbeit `[SxCy/z]`).
- `type` ist klein geschrieben (z. B. `docs`, `feat`, `cli`, `release`, `chore`).
- Beschreibung ist kurz, praezise und ohne Fuelltext.
- Keine gemischten Formate (z. B. nicht abwechselnd `chore(...)` und `[General] ...`).
- Neue Commits muessen diese Repo-Konvention verwenden; Abweichungen sind nur bei explizit eingefuehrter neuer Konvention zulaessig.

### Nicht erlaubt

- unsaubere WIP-Commits
- grosse Sammelcommits ohne Struktur
- nachtraegliches Zusammenquetschen sauberer Sprint-Commits
- Commit-Betreff im Format `chore(...)` oder anderen Mischformaten ausserhalb der Konvention `[Scope] type: ...`

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

### Titel-Konvention

- PR-Titel fuer Sprint-Arbeit folgen dem Format `[Sxx] type: short description`.
- `Sxx` bezeichnet den Sprint, nicht den einzelnen Commit.
- Commit-Labels wie `[S24C1/1]` gehoeren nicht in PR-Titel.
- Generische Titel wie `Sprint 24`, `[Sprint 24]`, `update` oder `docs: ...`
  ohne Sprint-Prefix sind fuer Sprint-PRs nicht zulaessig.
- PR-Titel muessen den fachlichen Scope klar benennen und werden auf GitHub
  in Englisch verfasst.

### Inhalt

Der PR beschreibt:

- Ziel des Branches bzw. Arbeitsblocks
- durchgefuehrte Aenderungen
- relevante Dokumentationsanpassungen
- offene Punkte nur innerhalb von `## Summary`, nicht als eigene H2

### Zeitpunkt

Die Beschreibung wird **beim Erstellen des PR** gepflegt, nicht erst beim Merge.
Sie wird auf GitHub in Englisch verfasst und verwendet ausschliesslich die
H2-Bloecke `## Summary` und `## Validation`.

### Strukturregel (verbindlich)

- `## Summary` beschreibt Scope, Begruendung und bei Bedarf bewusst
  offengelassene Folgearbeit als normale Listenpunkte oder Prosa innerhalb
  dieses Blocks.
- Hinweise, Risiken, Nicht-Ziele und Follow-ups bleiben dabei ebenfalls
  innerhalb von `## Summary`; freie Neben-H2 legitimieren diese Inhalte
  nicht.
- `## Validation` listet ausgefuehrte Checks und benennt offen, was nicht
  gelaufen ist.
- Weitere H2-Ueberschriften sind im PR-Body unzulaessig.
- Das gilt insbesondere fuer `## Note`, `## Notes`, `## Scope Notes`,
  `## Follow-Ups`, `## Impact` oder freie Zusatzsektionen.
- Die repo-seitige technische Eintrittsstelle dafuer ist
  `.github/pull_request_template.md`.

### Trennung von PR-Text und Merge-Commit

- PR-Beschreibung und Merge-Commit sind unterschiedliche Artefakte und duerfen
  nicht gedanklich gleichgesetzt werden.
- Beim finalen Merge via **Create a merge commit** ist der vorgeschlagene
  Merge-Commit-Text bewusst zu pruefen und bei Bedarf manuell zu kuerzen.
- Der Merge-Commit soll nur den kompakten fachlichen Betreff und hoechstens
  einen kurzen, historientauglichen Body tragen.
- Weder PR-H2s (`## Summary`, `## Validation`) noch verbotene Drift-H2s
  (`## Note`, `## Notes`, `## Scope Notes`, `## Follow-Ups`) noch
  Tag-H2s (`## Impact`) gehoeren ungeprueft in den Merge-Commit-Body.
- Wenn GitHub beim Merge den PR-Body in die Commit-Message uebernimmt, ist
  dieser Vorschlag vor dem finalen Merge aktiv zu bereinigen.

## Merge-Regeln

### Standard

- **Create a merge commit** ist die verbindliche Standard-Merge-Strategie.
- Die Commit-Message dieses Merge-Commits wird vor dem Abschluss aktiv
  redaktionell geprueft; ein ungekuerztes Uebernehmen laengerer PR-Bloecke ist
  nicht der Standardpfad.

### Prioritaetsregel

- Wenn ein fester Merge-Standard definiert ist, muss dieser immer verwendet werden.
- Entscheidungsregeln wie "Squash bei kleinen Aenderungen" gelten nur dann, wenn kein expliziter Standard festgelegt ist.

### Warum?

- alle Commit-Hashes bleiben erhalten
- Sprint-Struktur bleibt sichtbar
- Artefakte bleiben korrekt zugeordnet
- vollstaendige Nachvollziehbarkeit

### Ausnahme: Squash

`Squash and merge` ist nur erlaubt, wenn:

- der Merge-Standard explizit ueberschrieben wird, oder
- dies im Task eindeutig gefordert ist.

Ohne diese explizite Freigabe darf kein `Squash and merge` verwendet werden.

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

- Standardregel: zuerst den Zustand der Arbeitskopie beobachtend einordnen,
  dann erst bewusst veraendernde Git-Schritte ausloesen.
- Session-Start: `git remote -v`, `git fetch --prune origin`,
  `git status --short --branch`, `git log -1 --oneline`
- `git pull --ff-only` ist kein automatischer Startschritt mehr, sondern
  eine explizite Folgeaktion, wenn ein Task bewusst einen Fast-Forward-Sync
  auf den aktuellen Remote-Stand verlangt.
- Session-Ende: finaler Beobachtungs-/Sync-Check mit
  `git fetch --prune origin` und `git status --short --branch`; ein
  zusaetzlicher `git pull --ff-only` erfolgt nur bewusst und nur dann,
  wenn der konkrete Abschlussfluss ihn wirklich braucht.
- Kein lokales Rebase von bereits artefakt-/traceability-relevanten Commits.

## Tagging-Regeln

- Sprint-Tagging (`sprint-<nr>-done`) nur nach komplett abgeschlossenem und freigegebenem Sprint.
- Release-/Version-Tags (z. B. `1.2.0`) nur nach expliziter User-Freigabe.
- Tag-Messages bilden eine eigene Domaene mit genau `## Summary`,
  `## Validation` und `## Impact`; diese Struktur wird nicht auf PR-Bodies
  oder Merge-Commit-Messages uebertragen.
- Wenn annotierte Tag-Nachrichten Markdown-Ueberschriften mit fuehrendem `#` enthalten
  sollen (z. B. `## Summary`, `## Validation`, `## Impact`), muss der Tag mit
  `--cleanup=verbatim` erstellt werden.
- Verbindliches Muster fuer signierte Tags:
  `git tag -s --cleanup=verbatim <tag> -F <nachrichtendatei>`
- Ohne `--cleanup=verbatim` entfernt Git diese Ueberschriften bei der Standard-
  Bereinigung als Kommentarzeilen aus dem Tag-Objekt.
- Vor dem Push ist der Rohinhalt des Tags lokal mit
  `git cat-file -p refs/tags/<tag>` zu pruefen.
- Erst wenn die erwarteten `##`-Ueberschriften im Rohobjekt sichtbar sind, darf
  der Tag gepusht werden.
- Ein bereits veroeffentlichter Tag wird nur nach expliziter User-Freigabe
  geloescht und neu gesetzt.

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
  - Der feste Merge-Standard bleibt dennoch `Create a merge commit`.

## Kurzfassung

- 1 Sprint = 1 Branch
- 1 Sprint = 1 PR
- mehrere Commits erlaubt
- Artefakte pro Commit erwuenscht
- Hash immer echt
- kein Rebase nach Artefakt-Erstellung
- Standard: **Create a merge commit**
