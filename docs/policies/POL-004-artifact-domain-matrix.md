# POL-004: Artefakt-Domaenenmatrix und Notes-Policy
**Stand:** 2026-04-20
**Status:** active
**Datum:** 2026-04-20

## Ziel

Diese Policy trennt die zentralen Governance-Artefakte des Repositories
domainenscharf, damit Regeln fuer Tracker, PR-Bodies, Merge-Commit-Messages,
Tag-Messages und Prompt-/Template-Quellen nicht ineinander driften.

## Geltungsbereich

- `AGENTS.md`
- `docs/GIT_WORKFLOW.md`
- `docs/policies/POL-001-tracker-standard.md`
- `.github/pull_request_template.md`
- `scripts/projtrack_lint.sh`
- repo-seitige und externe Prompt-/Template-Quellen, soweit sie diese
  Artefakte vorbereiten oder spiegeln

## Kanonische Matrix

| Domaene | Zweck | Erlaubte Struktur | Unzulaessige Struktur | Pruefpfad / Eintrittsstelle |
| --- | --- | --- | --- | --- |
| Tracker-Dokumente | Repo-seitige Arbeits-, Entscheidungs- und Policy-Artefakte | Tracker-Strukturen gemaess `POL-001`; `# Notes` bleibt tracker-spezifisch erlaubt | PR-, Merge- oder Tag-Schemata als impliziter Standard; `## Note`/`## Notes` in Tracker-Dateien | `POL-001`, `scripts/projtrack_lint.sh` |
| PR-Bodies | GitHub-Review-Artefakt fuer Scope und Validierung | Exklusive H2-Allowlist mit genau `## Summary` und `## Validation` | Jede zusaetzliche H2, z. B. `## Note`, `## Notes`, `## Scope Notes`, `## Follow-Ups`, `## Impact` | `AGENTS.md`, `docs/GIT_WORKFLOW.md`, `.github/pull_request_template.md`, PR-Review |
| Merge-Commit-Messages | Kompakte Integrationshistorie nach PR-Merge | Kurzer Betreff, optional kurzer Plain-Body | Uebernommene PR-/Tag-H2-Schemata oder ungekuerzter PR-Body | GitHub-Merge-Dialog, redaktionelle Pruefung vor Merge |
| Tag-Messages | Signierte Sprint-/Release-Artefakte mit Handoff-Charakter | `## Summary`, `## Validation`, `## Impact` | Angleichung an PR- oder Merge-Schema; fehlendes `--cleanup=verbatim` bei Markdown-H2 | `git tag -s/-a --cleanup=verbatim`, `git cat-file -p refs/tags/<tag>` |
| Prompt-/Template-Quellen | Regel-Propagation in PR-Templates, Prompts und Folgeschichten | Domainenscharfe Weitergabe der jeweils passenden Struktur | Artefaktuebergreifende Vermischung, z. B. Tracker-`# Notes` oder Tag-H2s als PR-Schema | `.github/pull_request_template.md`, Audit-/Template-Reviews |

## Notes-Policy pro Domaene

### Tracker-Dokumente

- `# Notes` ist weiterhin die kanonische Notes-Form innerhalb der
  Tracker-Domaene.
- Diese Erlaubnis ist tracker-spezifisch und darf nicht auf PR-Bodies,
  Merge-Commit-Messages oder Tag-Messages uebertragen werden.
- `## Note` und `## Notes` bleiben in Tracker-Dateien unzulaessig.

### PR-Bodies

- `Notes` ist keine erlaubte eigene PR-Domaene und keine erlaubte H2.
- Hinweise, Risiken, Nicht-Ziele oder Follow-ups werden in `## Summary`
  integriert oder ausserhalb freier H2 in normaler Prosa/Bullet-Form erfasst.

### Merge-Commit-Messages

- `Notes` ist kein Merge-Commit-Schema.
- Merge-Commits bleiben kompakt und verzichten auf PR- oder Tag-H2-Struktur.

### Tag-Messages

- `Notes` ist nicht Teil des kanonischen Tag-Schemas.
- Fuer Tag-Artefakte bleibt `## Impact` die dritte und letzte vorgesehene H2.

### Prompt-/Template-Quellen

- Quellen duerfen `Notes` nur dann propagieren, wenn sie explizit die
  Tracker-Domaene bedienen.
- PR-nahe Quellen duerfen keine `Notes`-H2 vorgeben.

## Domaenenvertraege im Detail

### Tracker-Dokumente

#### Zweck

- nachvollziehbare Repo-Artefakte fuer Backlog, Issues, Policies und Tasks

#### Erlaubte Struktur

- Frontmatter, Tracker-Sections und tracker-spezifische Heading-Formen gemaess
  `POL-001`
- `# Notes` als kanonische Notes-Form, wenn fachlich noetig

#### Unzulaessige Struktur

- PR-Body-Allowlist als Holzhammer-Regel gegen Tracker-Dateien
- `## Note` oder `## Notes`

#### Pruefpfad

- `scripts/projtrack_lint.sh`

### PR-Bodies

#### Zweck

- Review-Artefakt fuer Scope, Begruendung und Validierung eines Branches

#### Erlaubte Struktur

- `## Summary`
- `## Validation`

#### Unzulaessige Struktur

- jede weitere H2
- insbesondere `## Note`, `## Notes`, `## Scope Notes`, `## Follow-Ups`,
  `## Impact`

#### Pruefpfad

- `.github/pull_request_template.md`
- redaktionelle Kontrolle bei PR-Erstellung

### Merge-Commit-Messages

#### Zweck

- kompakte, dauerhafte Integrationsnachricht in der Git-Historie

#### Erlaubte Struktur

- kurzer Betreff
- optional kurzer Plain-Body

#### Unzulaessige Struktur

- ungekuerzter PR-Body
- PR- oder Tag-H2-Schemata

#### Pruefpfad

- redaktionelle Pruefung des GitHub-Merge-Vorschlags

### Tag-Messages

#### Zweck

- signierte Sprint-/Release-Handoffs mit expliziter Zusammenfassung,
  Validierung und Impact

#### Erlaubte Struktur

- `## Summary`
- `## Validation`
- `## Impact`

#### Unzulaessige Struktur

- PR-H2-Reduktion auf `Summary`/`Validation` als globale Regel
- fehlendes `--cleanup=verbatim` bei Markdown-H2

#### Pruefpfad

- `git tag -s --cleanup=verbatim ...` oder
  `git tag -a --cleanup=verbatim ...`
- `git cat-file -p refs/tags/<tag>`

### Prompt-/Template-Quellen

#### Zweck

- saubere Regelweitergabe an PR-Vorlagen, Prompt-Master und spaetere
  Automationspfade

#### Erlaubte Struktur

- domainenscharfe Propagation der passenden Artefaktregeln

#### Unzulaessige Struktur

- Verallgemeinerung einer Domaene auf alle anderen
- Reaktivierung freier PR-H2 trotz exklusiver PR-Allowlist

#### Pruefpfad

- repo-seitiges PR-Template
- gezielte Governance-Reviews externer Prompt-/Template-Quellen

## Referenzen

- `AGENTS.md`
- `docs/GIT_WORKFLOW.md`
- `docs/policies/POL-001-tracker-standard.md`
- `.github/pull_request_template.md`
- `scripts/projtrack_lint.sh`
