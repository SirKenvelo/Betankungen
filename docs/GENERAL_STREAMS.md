# GENERAL_STREAMS
**Stand:** 2026-04-25

Dieses Dokument sammelt nicht-sprintgebundene Steuerungs-, Governance-, Audit- und Pflegebloecke.

Es ist die Zielablage fuer General-Streams, die frueher in `docs/SPRINTS.md` standen. `docs/SPRINTS.md` bleibt ab diesem Stand auf echte Sprint-Narrative begrenzt.

## Rolle

- General-Streams dokumentieren zusammenhaengende Pflege- oder Governance-Arbeit ohne Sprint-Commit-Folge.
- Sie ersetzen keine Tracker-Dateien, keine Release-Fakten im Changelog und keine Sprint-Traceability.
- Neue Sprint-Arbeit gehoert weiterhin nach `docs/SPRINTS.md`; neue nicht-sprintgebundene Steuerungsbloecke gehoeren hierher.

## General-Stream nach Sprint 40 - Governance-Kernleitplanken an Artefaktmatrix angleichen

- Status: done
- Ziel: `AGENTS.md` und `docs/GIT_WORKFLOW.md` auf denselben operativen
  `POL-004`-Stand ziehen, ohne die Artefaktmatrix erneut auszuwalzen.

### Stand (2026-04-20)

- `AGENTS.md` stellt jetzt explizit klar, dass Hinweise, Risiken, Nicht-Ziele
  und Follow-ups im PR nur innerhalb von `## Summary` stehen und keine freie
  Zusatz-H2 legitimieren.
- `docs/GIT_WORKFLOW.md` fuehrt denselben Punkt deckungsgleich aus, rahmt den
  PR-Inhalt allgemeiner als Branch-/Arbeitsblock-Artefakt statt nur als
  Sprint-Beschreibung und haertet `Squash` auf explizite Override-/Task-
  Freigabe.
- Die Trennung der Domaenen bleibt dabei konsistent: PR-Bodies nutzen nur
  `## Summary` und `## Validation`, Merge-Commit-Messages bleiben kompakte
  Historien-Artefakte ohne PR-/Tag-H2-Schema, und Tag-Messages bleiben die
  eigene `## Summary`/`## Validation`/`## Impact`-Domaene mit
  `--cleanup=verbatim`.
- `docs/CHANGELOG.md` und `docs/STATUS.md` fuehren denselben Governance-
  Sync; es wurden bewusst keine Runtime-, Build-, Datenmodell- oder
  Produktfeature-Aenderungen eingefuehrt.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - Governance-Artefaktmatrix und Notes-Policy schaerfen

- Status: done
- Ziel: die Governance-Regeln nicht nur als Mindeststandard, sondern als
  domainenscharfen Vertrag fuer Tracker-, PR-, Merge-, Tag- und Prompt-
  Artefakte festziehen.

### Stand (2026-04-20)

- `docs/policies/POL-004-artifact-domain-matrix.md` verankert jetzt die
  kanonische Artefaktmatrix mit Zweck, erlaubter Struktur, unzulaessiger
  Struktur und jeweiligem Pruefpfad pro Domaene.
- `AGENTS.md` und `docs/GIT_WORKFLOW.md` fuehren denselben Vertrag:
  PR-Bodies verwenden exklusiv `## Summary` und `## Validation`, waehrend
  Merge-Commit-Messages kompakt bleiben und Tag-Messages ihre eigene
  `## Summary`/`## Validation`/`## Impact`-Struktur behalten.
- `POL-001`, `scripts/projtrack_lint.sh`, `docs/BACKLOG.md` und
  `docs/backlog/README.md` stellen klar, dass `# Notes` tracker-spezifisch
  erlaubt bleibt und nicht als globales PR-/Merge-/Tag-Schema missverstanden
  wird.
- `.github/pull_request_template.md` spiegelt die exklusive PR-Allowlist jetzt
  direkt an der repo-seitigen Eintrittsstelle; freie Zusatz-H2s wie
  `## Notes`, `## Scope Notes` oder `## Follow-Ups` sind dort nicht mehr
  vorgegeben.
- Dieser Block fuehrt bewusst keine Runtime-, Build-, Datenmodell- oder
  Produktfeature-Aenderungen ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - Selektive English-Public-Readiness-Folgepfade schneiden

- Status: done
- Ziel: kleine englische Brueckenschichten fuer Public Entry, Orientierung
  und Policy sauber von tieferer deutsch/intern gehaltener Repo-Doku trennen, ohne
  einen Volluebersetzungsauftrag zu erzeugen.

### Stand (2026-04-19)

- `TSK-0040` ist abgeschlossen: Die priorisierte englische Schicht bleibt auf
  `README.md`, `docs/README_EN.md`, `CONTRIBUTING.md`, `SECURITY.md` und den
  Wiki-Entry-/Quick-Reference-Pfad begrenzt.
- `CONTRIBUTING.md` und `SECURITY.md` fuehren jetzt denselben stabilen
  `1.4.0`-Hold wie die bereits aktualisierten Entry-Seiten.
- `docs/README_EN.md` und `docs/wiki/Home.md` benennen jetzt explizit, dass
  tiefe Status-, Roadmap-, Release- und Tracker-Doku bewusst deutsch/intern
  bleibt.
- `docs/backlog/BL-0038-documentation-wiki-and-evidence-alignment-hardening/item.md`,
  die Task-Datei sowie `docs/CHANGELOG.md` und `docs/STATUS.md` fuehren
  denselben Abschlussstand.
- Dieser Block fuehrt bewusst keine Runtime-, Build-, Parser-, Evidence-
  Index- oder Wiki-Quick-Reference-Aenderungen ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make wiki-link-check`
- `make verify`


## General-Stream nach Sprint 40 - Dev-Diary-Sichtbarkeit und Rollenrahmung schaerfen

- Status: done
- Ziel: `docs/DEV_DIARY.md` im Entry-/Wiki-Handoff sichtbarer machen und
  seine Rolle klarer von `docs/CHANGELOG.md` und `docs/SPRINTS.md`
  abgrenzen, ohne einen neuen Doku-Hauptpfad zu erfinden.

### Stand (2026-04-19)

- `README.md`, `docs/README.md`, `docs/README_EN.md`,
  `docs/wiki/Home.md` und `docs/wiki/README.md` rahmen das Dev Diary jetzt
  sichtbarer als kuratierte Projektchronik.
- `docs/DEV_DIARY.md` selbst betont jetzt deutlicher, dass es sichtbarer Teil
  des Handoffs ist, aber weder Release-Fakten noch Sprint-Traceability
  ersetzt.
- `docs/CHANGELOG.md` und `docs/STATUS.md` sind im selben Doku-Sync auf
  denselben Rollenrahmen gezogen; `docs/BACKLOG.md` und die TSK-Datei
  spiegeln den Abschlussstand.
- `TSK-0039` ist damit abgeschlossen.
- Dieser Block fuehrt bewusst keine Runtime-, Build-, Parser- oder Wiki-
  Quick-Reference-Aenderungen ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make wiki-link-check`
- `make verify`


## General-Stream nach Sprint 40 - Externe Evidence-Indexschicht und Nutzertest-Bruecke schneiden

- Status: done
- Ziel: die externe Audit-Ablage fuer Evidence-Nutzung lesbarer machen, ohne
  Historie umzuziehen, und die separate Nutzertest-Ablage als eigene Quelle
  sichtbar an den Audit-Einstieg anbinden.

### Stand (2026-04-19)

- `/home/christof/Projekte/Audit/Betankungen/README.md` rahmt den Einstieg
  jetzt klarer zwischen aktuellem Evidence-Zugriff, historischen Root-
  Artefakten und nicht-evidenten Hilfsordnern.
- `EVIDENCE_INDEX.md` im externen Audit-Root trennt konkrete Audit-Runs,
  ausgelagerte Follow-up-Befunde, Planungsnotizen und die separate
  Nutzertest-Ablage als eigenstaendige externe Evidence-Quelle.
- Neue Rollen-READMEs in `runs/`, `plans/` und `issues/` machen die
  Unterordner semantisch ruhiger, ohne einen Big-Bang-Umzug bestehender
  Dateien zu erzwingen.
- `TSK-0038` ist damit abgeschlossen; repo-seitig wurde nur der knappe
  Traceability-Sync in `docs/CHANGELOG.md`, `docs/STATUS.md` und dieser
  Sprint-Narrative nachgezogen.
- Dieser Block fuehrt bewusst keine Runtime-, Build-, Parser- oder Wiki-
  Quick-Reference-Aenderungen ein.

### Validierung

- `scripts/projtrack_lint.sh`


## General-Stream nach Sprint 40 - Fail-fast-Purity-Guard fuer aktiven Baum schneiden

- Status: done
- Ziel: den im Audit bestaetigten FPC-/CLI-Iststand als operativen
  Guardrail festziehen, damit neue Lazarus-/LCL-Drift im aktiven Baum lokal
  und in der CI frueh und nachvollziehbar blockiert wird.

### Stand (2026-04-17)

- `scripts/lazarus_purity_check.sh` fuehrt jetzt den dedizierten Purity-Check
  fuer `src/`, `units/`, `tests/`, `scripts/`, `Makefile`,
  `.github/workflows/` und `.vscode/tasks.json` aus.
- Der Guardrail trennt bewusst aktive Suchflaeche von historischem Kontext,
  prueft verbotene Projektartefakte (`.lpi`, `.lfm`, `.lrs`, `.lps`),
  Lazarus-Build-Commands (`lazbuild`) sowie aktive GUI-/LCL-Tokens und
  vermeidet naive Teilstring-Falschalarme wie `TFormatSettings`.
- `make verify` fuehrt den Check jetzt vor dem Build aus; die CI zieht
  denselben Schritt vor Dependency-Installation und FPC-Compile.
- `TSK-0035` ist damit auf `done`; `TSK-0036` bindet das VS-Code-Build-
  Frontend jetzt an `make build`.
- Dieser Block fuehrt bewusst keine Runtime-, CLI-, TUI- oder
  Produktfeature-Aenderungen ein.

### Validierung

- `make verify`


## General-Stream nach Sprint 40 - Wiki-Quick-Reference an aktuellen CLI-/Build-Stand anpassen

- Status: done
- Ziel: die oeffentliche Wiki-Quick-Reference auf die aktuelle Core-CLI-
  Wahrheit ziehen, veraltete Beispielpfade entfernen und den optionalen
  Companion sauber vom Core abgrenzen.

### Stand (2026-04-18)

- `docs/wiki/CLI-Quick-Reference.md` rahmt jetzt `make build` und
  `./bin/Betankungen --help` als belastbare Eintrittspunkte.
- Das ungueltige Core-Beispiel `Betankungen --init` wurde entfernt.
- Die Core-Beispiele wurden auf aktuelle Flows wie `--add stations`,
  `--add cars`, `--add fuelups`, `--list fuelups --detail`,
  `--stats fuelups` und `--stats cost --maintenance-source none|module`
  reduziert.
- Der Companion-Pfad `betankungen-maintenance` ist jetzt klar als
  optionales, getrenntes Binary beschrieben.
- Dieser Block fuehrt bewusst keine Runtime- oder Parser-Aenderungen ein.

### Validierung

- `make wiki-link-check`
- `make verify`


## General-Stream nach Sprint 40 - VS-Code-Build-Frontend an make build binden

- Status: done
- Ziel: `.vscode/tasks.json` als Komfort-Frontend ohne konkurrierenden
  Build-String an die kanonische Build-Wahrheit `make build` binden.

### Stand (2026-04-17)

- Der VS-Code-Buildtask ruft jetzt `make build` direkt auf.
- Der separate FPC-Compile-String ist aus dem Editor-Buildpfad entfernt.
- Der Clean-Task bleibt als getrennte Komfortfunktion erhalten und baut
  keine zweite Build-Wahrheit auf.
- `TSK-0036` ist damit abgeschlossen; die aktive Dokumentation verweist
  weiterhin auf `make build` als kanonischen Build-Pfad.
- Zugehoeriger Commit: `32c7a68`.
- Dieser Block fuehrt bewusst keine Runtime-, CLI- oder Produktfeature-
  Aenderungen ein.

### Validierung

- `make verify`


## General-Stream nach Sprint 40 - Lazarus-Purity-Baseline auditieren

- Status: done
- Ziel: den aktiven Repo-Zustand technisch auf FPC-/CLI-/SQLite-Wahrheit
  pruefen, aktive Verstoesse sauber von historischer Legacy und Doku-Drift
  trennen und daraus belastbare ADR-/TSK-Folgeschnitte ableiten.

### Stand (2026-04-17)

- `docs/LAZARUS_PURITY_AUDIT_2026-04-17.md` dokumentiert den Audit mit
  Evidence-Liste, Befundklassifikation und expliziten Antworten auf die
  Audit-Fragen.
- Im aktiven Source-, Build- und Testpfad wurden keine Lazarus-/LCL-
  Abhaengigkeiten und keine verbotenen Projektartefakte (`.lpi`, `.lfm`,
  `.lrs`, `.lps`) gefunden.
- `make build` ist als kanonische Build-Wahrheit bestaetigt; die CI fuehrt
  denselben FPC-Build aus, `.vscode/tasks.json` ist aktuell nur ein
  Komfort-Frontend ohne konkurrierende Build-Logik.
- Aktive Drift lag im Wording von `README.md`, `docs/README.md` und
  `docs/ARCHITECTURE.md`; diese Dokumente fuehren jetzt dieselbe FPC-/CLI-
  Rahmung.
- `ADR-0016` ist als vorgeschlagene Architekturentscheidung angelegt;
  `BL-0037` schneidet daraus zwei kleine Folge-Tasks. Der empfohlene
  naechste Umsetzungsblock ist `TSK-0035`.

### Validierung

- `scripts/projtrack_lint.sh`
- `make wiki-link-check`
- `make verify`


## General-Stream nach Sprint 40 - Sichtbaren Public-Release-Handoff fuer 1.4.0 publizieren

- Status: done
- Ziel: den lokal bereits abgeschlossenen `1.4.0`-Closeout mit einem
  tatsaechlich sichtbaren GitHub-Release fuer Tag `1.4.0` abschliessen und
  die Entry-/Status-Doku auf denselben Public-Handoff ziehen.

### Stand (2026-04-15)

- Der GitHub-Release-Handoff fuer `1.4.0` ist jetzt unter
  `https://github.com/SirKenvelo/Betankungen/releases/tag/1.4.0`
  publiziert.
- `README.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`,
  `docs/ROADMAP_1_4_0.md`, `docs/RELEASE_1_4_0_PREFLIGHT.md` und
  `docs/CHANGELOG.md` fuehren denselben sichtbaren Public-Handoff.
- `APP_VERSION=1.4.0`, das Release-Artefakt
  `.releases/Betankungen_1_4_0.tar` und der Snapshot `.backup/2026-04-15_1822`
  bleiben unveraendert.
- Der Post-Release-Zustand bleibt bewusst auf `1.4.0`; eine automatische
  `1.5.0-dev`-Fortschreibung wurde weiterhin nicht gestartet.
- Dieser Block fuehrt bewusst keine Runtime-, CLI-, TUI-, Receipt- oder EV-
  Features ein.

### Validierung

- `gh release create 1.4.0 --verify-tag --title "Betankungen 1.4.0" --notes-file /tmp/betankungen_release_1_4_0.md`
- `gh release view 1.4.0`
- `make wiki-link-check`
- `make verify`


## General-Stream nach Sprint 40 - 1.4.0 final freigeben und auf 1.4.0 halten

- Status: done
- Ziel: Gate 5 fuer die `1.4.0`-Linie nach dokumentiertem Gate-4-Snapshot
  sauber abschliessen, die Version final auf `1.4.0` setzen und den
  Post-Release-Stand bewusst ohne `1.5.0-dev` halten.

### Stand (2026-04-15)

- `src/Betankungen.lpr` fuehrt jetzt `APP_VERSION=1.4.0`.
- `docs/ROADMAP_1_4_0.md`, `docs/RELEASE_1_4_0_PREFLIGHT.md`,
  `docs/STATUS.md`, `docs/CHANGELOG.md`, `README.md`, `docs/README.md` und
  `docs/README_EN.md` fuehren denselben Finalstand: Gate 4 und Gate 5
  abgeschlossen, `1.4.0` ist die stabile Linie.
- Die finale Release-/Backup-Ausfuehrung ist lokal erfolgt:
  `.releases/Betankungen_1_4_0.tar`
  (SHA-256 `79dcf14b23ea51fb723662eb2ec496919c27fe8ca8f2598ce4363b265b6d898e`)
  und `.backup/2026-04-15_1822`.
- Der sichtbare GitHub-Release-Handoff fuer Tag `1.4.0` ist publiziert:
  `https://github.com/SirKenvelo/Betankungen/releases/tag/1.4.0`.
- Der Post-Release-Zustand bleibt bewusst auf `1.4.0`; eine automatische
  `1.5.0-dev`-Fortschreibung wurde nicht gestartet.
- Dieser Block fuehrt bewusst keine Runtime-, CLI-, TUI-, Receipt- oder EV-
  Features ein.

### Validierung

- `make wiki-link-check`
- `make verify`
- `make release-preflight-1-4-0`
- `./kpr.sh --note "Release 1.4.0 final"`
- `scripts/backup_snapshot.sh --note "Backup after release 1.4.0"`


## General-Stream nach Sprint 40 - 1.4.0 Gate-4-RC-Snapshot finalisieren

- Status: done
- Ziel: den Release-Candidate-/Freeze-Snapshot fuer die `1.4.0`-Linie auf
  dem dev-Stand formal abschliessen, ohne den finalen Gate-5-Umschaltblock
  vorwegzunehmen.

### Stand (2026-04-15)

- `docs/ROADMAP_1_4_0.md`, `docs/RELEASE_1_4_0_PREFLIGHT.md`,
  `docs/STATUS.md` und `docs/CHANGELOG.md` fuehren jetzt denselben
  Gate-Stand: Gate 4 abgeschlossen, Gate 5 aktiv, `APP_VERSION=1.4.0-dev`.
- Der RC-Kandidat bleibt fachlich eingefroren; `BL-0032` und `BL-0034`
  bleiben weiterhin ausserhalb der `1.4.0`-Release-Linie.
- Der lokale Abschlusslauf fuer Gate 4 ist dokumentiert und gruensicher.
- Gate 5 bleibt bewusst getrennt: finaler Versionswechsel, Release-/
  Backup-Ausfuehrung und der Post-Release-Hold auf `1.4.0`.
- Dieser Block fuehrt bewusst keine Runtime-, CLI-, TUI-, Receipt- oder EV-
  Features ein.

### Validierung

- `make wiki-link-check`
- `make verify`
- `make release-preflight-1-4-0`


## General-Stream nach Sprint 40 - 1.4.0 Release-Readiness und Scope-Freeze festziehen

- Status: done
- Ziel: fuer die aktive `1.4.0-dev`-Linie einen belastbaren
  Release-Readiness- und Scope-Freeze-Rahmen schaffen, ohne neue
  Produktfeatures in die Linie zu ziehen.

### Stand (2026-04-14)

- `docs/ROADMAP_1_4_0.md` und `docs/RELEASE_1_4_0_PREFLIGHT.md` liefern jetzt
  den formalen Gate-/Freeze-/Preflight-Rahmen fuer die aktive Linie.
- `docs/STATUS.md`, `docs/CHANGELOG.md`, `docs/README.md`,
  `docs/README_EN.md`, `README.md`, `docs/DEV_START_GATE_1_4_0.md` und
  `docs/BL-0011_SCOPE_DECISION_1_4_0.md` fuehren denselben Stand: aktive
  Linie `1.4.0-dev`, Scope-Freeze aktiv, finale Release-Freigabe noch offen.
- `tests/smoke/smoke_cli.sh` erzeugt `btkgit`-Fixtures jetzt ueber einen
  Clone-only-Pfad mit lokalem Bare-Remote und echter `main`-Ref.
- Der Fixture-Pfad braucht damit keinen lokalen Signing-Override und prueft
  `sync`/`cleanup` gegen einen echten Upstream statt gegen kuenstliche
  Tracking-Referenzen.
- `Makefile`, `scripts/release_preflight_1_4_0.sh` und `btkgit preflight 1.4.0`
  bilden den operativen lokalen Readiness-Pfad.
- `BL-0032` und `BL-0034` bleiben bewusst ausserhalb der `1.4.0`-Release-
  Linie.
- Fuer Gate 4 und Gate 5 verbleiben nur RC-/Freigabethemen.
- Dieser Block fuehrt bewusst keine Runtime-, CLI-, TUI-, Receipt- oder EV-
  Features ein.

### Validierung

- `make wiki-link-check`
- `make verify`
- `make release-preflight-1-4-0`


## General-Stream nach Sprint 40 - Englische Entry-Signale fuer Erstbesucher staerken

- Status: done
- Ziel: die englische Einstiegsschicht fuer internationale Erstbesucher
  sichtbarer und ruhiger machen, ohne die deutsche Tiefendoku vollstaendig
  zu uebersetzen oder den spaeteren README-/Wiki-/`CONTRIBUTING.md`-
  Handoff vorwegzunehmen.

### Stand (2026-04-14)

- `docs/README_EN.md`, `README.md` und die Wiki-Startseiten benennen jetzt
  den englischen Einstieg sichtbarer und ordnen die deutsche Tiefendoku als
  bewusst German-first ein.
- `TSK-0033` ist damit `done`; `TSK-0034` hat den ruhigeren Handoff
  zwischen README, Wiki und `CONTRIBUTING.md` inzwischen ebenfalls
  abgeschlossen.
- `BL-0036` ist damit `done`.
- Der zugehoerige Inhalts-Commit ist `8e64391`.
- Dieser Block fuehrt bewusst keine Volluebersetzung und keinen groesseren
  Handoff-Umbau ein.

### Validierung

- `make wiki-link-check`
- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - README/Wiki/Contributing-Handoff beruhigen

- Status: done
- Ziel: den letzten offenen Handoff-Pfad zwischen README, GitHub Wiki und
  `CONTRIBUTING.md` glatten, ohne neue Einstiegsebene, neue Quickstart-
  Substanz oder neue englische Signalpflege einzufuehren.

### Stand (2026-04-14)

- `README.md`, `docs/README_EN.md`, `docs/wiki/Home.md`,
  `docs/wiki/README.md` und `CONTRIBUTING.md` trennen die Rollen der
  Einstiegspfade jetzt klarer: der README- und English-Entry-Pfad fuehrt in
  die Public-Entry-Schicht, die Wiki-Seiten bleiben kuratiert und
  link-orientiert, und `CONTRIBUTING.md` setzt erst am Beitragspunkt an.
- `TSK-0034` ist damit `done`; `BL-0036` ist ebenfalls `done`.
- Es wurden keine Runtime-, CLI- oder Build-Aenderungen eingefuehrt.

### Validierung

- `make wiki-link-check`
- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - Kompakten Contributor-Quickstart liefern

- Status: done
- Ziel: in `CONTRIBUTING.md` einen sichtbaren ersten Beitragspfad fuer
  gelegentliche Contributors liefern, ohne englische Entry-Signale oder den
  README-/Wiki-/`CONTRIBUTING.md`-Handoff vorwegzunehmen.

### Stand (2026-04-12)

- `CONTRIBUTING.md` fuehrt jetzt frueh einen kompakten Quickstart fuer den
  ersten kleinen Beitrag.
- Der sichtbare Mindestpfad nennt `make build` und `make verify` und ergaenzt
  gezielte Zusatzchecks fuer Tracker-Dateien (`scripts/projtrack_lint.sh`) und
  Wiki-/wiki-nahe Link-Aenderungen (`make wiki-link-check`).
- Die GitHub-Sprachregel und der minimale PR-Rahmen `Summary`/`Validation`
  sind jetzt ohne tiefe Vorablektuere erkennbar.
- `TSK-0032` ist damit `done`; `BL-0036` ist auf `in_progress` gezogen.
- Die verbleibende Folgearbeit bleibt getrennt: `TSK-0033` fuer englische
  Entry-Signale, `TSK-0034` fuer den ruhigeren Handoff zwischen README, Wiki
  und `CONTRIBUTING.md`.
- Dieser Block fuehrt bewusst keine Runtime-, CLI-, Release- oder groessere
  Entry-Layer-Aenderung ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - Merge-Commit- und Notes-Guardrails nachschaerfen

- Status: done
- Ziel: den Repo-Workflow so nachschaerfen, dass laengere PR-Textbloecke nicht
  ungeprueft in Merge-Commit-Messages landen und trackerseitig keine
  versehentlichen `## Note`-/`## Notes`-Ueberschriften mehr durchrutschen.

### Stand (2026-04-12)

- `docs/GIT_WORKFLOW.md` trennt jetzt explizit zwischen PR-Beschreibung und
  Merge-Commit und verlangt vor `Create a merge commit` eine bewusste
  redaktionelle Pruefung des vorgeschlagenen Commit-Texts.
- Die neue Leitplanke nennt `## Summary`, `## Validation`, `## Scope Notes`,
  `## Note` und `## Notes` explizit als PR-Bloecke, die nicht ungeprueft in
  den Merge-Commit-Body uebernommen werden sollen.
- `scripts/projtrack_lint.sh` meldet in Tracker-Dateien jetzt
  `## Note` und `## Notes` als harte Fehler und verweist auf die kanonische
  Form `# Notes`.
- Dieser Block fuehrt bewusst keine Produkt-, CLI- oder Build-Aenderung ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - BL-0036 in konkrete Task-Slices schneiden

- Status: done
- Ziel: den verbleibenden Contributor-/English-Entry-Folgeblock `BL-0036`
  von einem Sammelthema in 2-3 kleine, nicht ueberlappende Umsetzungs-
  `TSK` ueberfuehren, ohne schon README-, Wiki- oder `CONTRIBUTING.md`-
  Inhalte direkt umzubauen.

### Stand (2026-04-12)

- `BL-0036` ist jetzt `approved` und damit als belastbarer Folgeblock fuer
  die aktive `1.4.0-dev`-Linie priorisierbar.
- Unter `docs/backlog/BL-0036-contributor-onboarding-and-english-entry-layer-hardening/tasks/`
  liegen jetzt drei neue, sauber getrennte Tasks:
  `TSK-0032` fuer den kompakten Contributor-Quickstart,
  `TSK-0033` fuer klarere englische Entry-Signale und `TSK-0034` fuer den
  ruhigeren README-/Wiki-/`CONTRIBUTING.md`-Handoff.
- Der empfohlene naechste kleinste Umsetzungsblock ist `TSK-0032`, weil der
  erste Beitragspfad fuer gelegentliche Contributors am direktesten von der
  verbleibenden Reibung betroffen ist.
- `docs/BACKLOG.md`, `docs/STATUS.md` und `docs/CHANGELOG.md` fuehren
  denselben Planungsstand.
- Dieser Block fuehrt bewusst keine Produkt-, CLI- oder direkte Entry-Layer-
  Implementierung ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - Sichtbaren Public-Release-Handoff fuer 1.3.0 liefern

- Status: done
- Ziel: die bereits kommunizierte stabile Linie `1.3.0` auch auf der
  GitHub-`Releases`-Oberflaeche als klaren oeffentlichen Handoff nutzbar
  machen, ohne neue Version, neuen Tag oder Runtime-Aenderung.

### Stand (2026-04-12)

- Fuer den bestehenden Tag `1.3.0` ist jetzt ein sichtbarer GitHub-Release
  mit englischen Release-Notes und klarer Nutzungs-Guidance veroeffentlicht.
- Der Handoff bleibt bewusst bei der vorhandenen stabilen Linie:
  keine neue Version, kein neuer Tag und kein neuer Release-Build.
- `README.md` und `docs/README_EN.md` verlinken den stabilen Release jetzt
  frueh im Entry-Layer und benennen explizit, dass `1.3.0` aktuell ueber
  Source-Build (`make build`) konsumiert wird, solange keine Release-
  Binarys explizit mitgeliefert werden.
- `ISS-0012` ist damit auf `resolved` gezogen; `docs/STATUS.md` und
  `docs/CHANGELOG.md` fuehren denselben Closeout ohne widerspruechliche
  Restformulierungen.
- Dieser Block fuehrt keine Produkt-, CLI- oder Runtime-Aenderung ein.

### Validierung

- `gh release view 1.3.0`
- `make wiki-link-check`
- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - Prompt-Ablage auf Audit-Repo konsolidieren

- Status: done
- Ziel: die Prompt-Ablage fuer Leitstand-, Audit- und Folge-Prompts sauber
  im externen Audit-Repo konzentrieren, repo-lokale Restordner entfernen und
  den neuen `[General]`-Folge-Prompt fuer den sichtbaren Public-Release-
  Handoff an der richtigen Stelle ablegen.

### Stand (2026-04-12)

- Der repo-lokale Restordner `prompts/` wird aus Betankungen entfernt; die
  externe Ablage unter `/home/christof/Projekte/Audit/Betankungen/prompts/`
  bleibt der alleinige Ort fuer Leitstand-, Audit- und Folge-Prompts.
- `TSK-0030` verweist fuer den Public-Repo-Entry-Audit jetzt auf die
  wiederverwendbare Vorlage
  `/home/christof/Projekte/Audit/Betankungen/prompts/templates/TEMPLATE_public-repo-entry-audit_prompt.md`.
- Unter `general/offen/` liegt der neue Folge-Prompt
  `2026-04-12_general_public-release-handoff_prompt.md`; die externe
  `prompts/README.md` fuehrt Template-Bestand und offenen General-Prompt
  konsistent.
- Dieser Block fuehrt keine Produkt- oder Runtime-Aenderung ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - README entry flow und quick start haerten

- Status: done
- Ziel: den oeffentlichen Repo-Einstieg ueber `README.md` auf Produktwert,
  Hauptanwendungsfaelle, fruehen Quick Start und sichtbaren Wiki-Pfad
  umstellen, ohne Runtime-Aenderung und ohne den groesseren Contributor-/
  English-Entry-Folgeblock `BL-0036` vorwegzunehmen.

### Stand (2026-04-11)

- `README.md` fuehrt jetzt mit knapper Produktbeschreibung, typischen
  Anwendungsfaellen, einem belastbaren Quick-Start-Pfad
  (`make build` -> `./bin/Betankungen` -> `--add stations` ->
  `--add fuelups`) und einem fruehen Verweis auf den publizierten
  GitHub-Wiki-Einstieg.
- `docs/README_EN.md` fuehrt denselben Entry-Layer-Stand fuer
  englischsprachige Erstbesucher weiter und haelt Status-/Planungsdetails
  bewusst unterhalb der ersten Einstiegsebene.
- `ISS-0011` ist auf `resolved` gezogen; der spaetere Folgeblock `BL-0036`
  bleibt bewusst ausserhalb dieses kleinen `[General]`-Slices.
- Status-, Roadmap- und Traceability-Details bleiben ueber
  `docs/STATUS.md`, `docs/CHANGELOG.md` und `docs/SPRINTS.md` verfuegbar,
  dominieren aber nicht mehr die erste Repo-Leseebene.
- Dieser Block fuehrt keine Produkt- oder Runtime-Aenderung ein.

### Validierung

- `make wiki-link-check`
- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - Audit-Funde in Tracker schneiden

- Status: done
- Ziel: den abgeschlossenen Public-Repo-Entry-Audit in konkrete
  Repo-Folgen uebersetzen, ohne schon README-, Release- oder
  Onboarding-Aenderungen vorwegzunehmen.

### Stand (2026-04-11)

- `TSK-0031` ist abgeschlossen und schneidet die belastbaren Audit-Funde in
  konkrete Tracker-Folgen.
- `ISS-0011` adressiert die README-/Quick-Start-Friktion im oeffentlichen
  Repo-Einstieg.
- `ISS-0012` adressiert die Luecke zwischen oeffentlichem Release-Signal und
  sichtbarer GitHub-Release-Oberflaeche.
- `BL-0036` buendelt den spaeteren Contributor-Onboarding- und
  English-Entry-Layer-Folgeblock.
- `BL-0035` ist damit `done`; ein neuer `ADR` war fuer die Audit-Funde nicht
  erforderlich.
- Dieser Block fuehrt bewusst keine Produkt- oder Runtime-Aenderung ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 40 - Public-entry-Audit vorbereiten

- Status: done
- Ziel: einen wiederverwendbaren Agentenpfad fuer einen kalten Audit des
  oeffentlichen GitHub-Einstiegs vorbereiten, ohne schon voreilig Runtime-,
  Doku- oder Governance-Aenderungen zu erzwingen.

### Stand (2026-04-11)

- `BL-0035` ist als Public-Readiness-Discovery-Block angelegt und trennt
  bewusst zwischen Audit-Vorbereitung und spaeterer Umsetzung.
- `TSK-0030` ist `done` und liefert die wiederverwendbare Audit-Vorlage
  unter
  `/home/christof/Projekte/Audit/Betankungen/prompts/templates/TEMPLATE_public-repo-entry-audit_prompt.md`.
- Der nachgelagerte Tracker-Uebersetzungsblock hat die Audit-Funde inzwischen
  in `ISS-0011`, `ISS-0012` und `BL-0036` geschnitten; ein neuer `ADR` war
  dabei nicht noetig.
- `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/README.md`,
  `docs/CHANGELOG.md` und die externe Audit-Ablage fuehren denselben
  Planungsstand.
- Dieser Block fuehrt bewusst keine Produkt- oder Runtime-Aenderung ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream vor Sprint 40 - Sync-Regel fuer Arbeitskopien nachziehen

- Status: done
- Ziel: den kanonischen Repo- und Prompt-Workflow vor Sprint 40 von einem
  automatischen Pull-Reflex auf eine beobachtende Standardregel
  umstellen, ohne Produkt-Runtime zu veraendern.

### Stand (2026-04-08)

- `docs/GIT_WORKFLOW.md` trennt jetzt explizit zwischen beobachtender
  Arbeitskopien-Pruefung und bewusst ausgeloesten Git-Aenderungen.
- `AGENTS.md` fuehrt denselben Regelstand fuer Repo-Pflege,
  Session-Start/-Ende und den Standardablauf ueber `main`.
- `docs/README.md` und `ADR-0010` rahmen `btkgit sync` bzw. den
  Post-Merge-Sync jetzt als explizite Operator-Aktion statt als
  automatischen Startreflex.
- Master-Template, Leitstand und Prompt-README in der Audit-Ablage werden
  auf denselben beobachtenden Startablauf gezogen.
- Dieser Block fuehrt bewusst keine Runtime-Aenderungen im Produkt ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream vor Sprint 40 - Steuerungs-Sync und TUI-Slice zuschneiden

- Status: done
- Ziel: den Audit-/Tracker-/Prompt-Rahmen vor Sprint 40 auf den aktuellen
  `1.4.0-dev`-Stand ziehen und `BL-0033` als naechsten belastbaren
  Runtime-Slice vorbereiten, ohne schon eine TUI-Implementierung zu starten.

### Stand (2026-04-08)

- `/home/christof/Projekte/Audit/Betankungen/AUDIT_STATUS_BOARD.md`
  markiert die fruehen `1.2.0`-Einordnungen jetzt explizit als historische
  Basis und beschreibt die aktuelle triggerbasierte Audit-Realitaet fuer
  `1.4.0-dev`.
- `BL-0033` ist von `proposed` auf `approved` gezogen und legt genau einen
  Referenzscreen fest: `Betankungen --list fuelups --detail`.
- Unter `BL-0033` ist `TSK-0029` neu angelegt; der Task schneidet den
  ersten kleinen Runtime-Slice fuer eine read-only View-/Painter-Basis,
  explizit ohne Form-System und ohne neue Fachlogik.
- `docs/BACKLOG.md`, `docs/STATUS.md` und `docs/CHANGELOG.md` fuehren
  denselben Steuerungsstand; `BL-0034` bleibt bewusst nachgeordnet und
  `exploratory`.
- Im Audit-Repo liegt jetzt genau ein offener Sprint-Prompt:
  `/home/christof/Projekte/Audit/Betankungen/prompts/sprints/offen/2026-04-08_S40_TSK-0029_prompt.md`.
- Dieser Block fuehrt bewusst keine Runtime-Aenderungen ein.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 38 - CLI-first TUI-Strang rahmen

- Status: done
- Ziel: einen spaeteren UI-/TUI-Refresh bewusst als optionalen
  CLI-first-Folgepfad rahmen, ohne laufende Fuelup- oder EV-Arbeit mit
  einem grossen UI-Refactor zu vermischen.

### Stand (2026-04-07)

- `ADR-0015` ist `accepted` und zieht die Leitplanke klar:
  klassische CLI- und non-interactive-Pfade bleiben voll erhalten; eine TUI
  ist nur Komfort- und Interaktionsschicht, nicht neue Fachlogik.
- `BL-0033` ist als spaeterer read-only-View-Refresh fuer einen einzelnen
  Referenzscreen vorgeschlagen, z. B. `fuelups --list --detail`.
- `BL-0034` ist als spaeterer Formular-/Input-Block vorgeschlagen, aber
  bewusst nachgeordnet: zuerst muss sich die View-/Painter-Basis bewaehren.
- Ein Big-Bang-Refactor aller Screens ist ausgeschlossen; neue UI-Bausteine
  muessen Domainlogik, Persistenzregeln und CLI-Semantik unveraendert
  lassen.
- Es wurden keine Runtime-Aenderungen eingefuehrt; der Block bleibt bewusst
  auf ADR-/Backlog-/Status-Rahmung begrenzt.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 37 - P-050 reset guidance follow-up

- Status: done
- Ziel: den zusaetzlichen Realnutzungsbefund rund um `P-050` als getrennten
  Tracker-Folgeblock verankern, ohne `TSK-0027` umzuschneiden oder
  Runtime-Aenderungen an `--add fuelups` vorzuziehen.

### Stand (2026-04-03)

- Der vorherige P1/P2-Delta-Audit blieb gruen; `ISS-0010` haelt den
  spaeteren orange markierten Realnutzungsbefund jetzt bewusst getrennt
  fest.
- `ISS-0010` dokumentiert, dass die aktuelle `P-050`-Rueckfrage bei
  normalen kurzen Distanzen im Add-Flow irrefuehrend wirkt.
- `TSK-0028` liegt neu unter `BL-0031` und schneidet die spaetere
  Runtime-Folgearbeit so, dass `P-050` vom normalen Fuelup-Flow entkoppelt
  wird.
- `P-012` fuer grosse Distanzluecken bleibt ausdruecklich unberuehrt; ein
  moeglicher manueller Reset bei kleiner Distanz bleibt hoechstens eine
  explizite Ausnahmefuehrung.
- `TSK-0027` bleibt als offener Guidance-Block fuer Car-Kontext,
  `--receipt-link`, lokale Receipt-Pfadnormalisierung und lokale
  Existenz-Guidance bestehen.
- `docs/BACKLOG.md`, `docs/STATUS.md`, `docs/README.md` und
  `docs/CHANGELOG.md` fuehren denselben Planungsstand; der Block bleibt
  bewusst tracker-seitig und zieht keine Runtime-Aenderung an
  `--add fuelups` vor.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 22 (Gate 5, non-blocking)

- Status: abgeschlossen
- Ziel: Gate-5-Finalisierung der 1.2.0-Linie begleiten, ohne den
  release-blocking Scope zu aendern; gezielte QA-/User-Flow-/Doku-
  Nachschaerfungen aus `BL-0022`/`BL-0023` auf `main` integrieren und den
  finalen 1.2.0-Release-Closeout durchfuehren.

### Bisheriger Fortschritt (2026-03-20 bis 2026-03-24)

- `189e159`: Teststrategie und Nutzerfund-Tracker als kanonischer Rahmen
  eingefuehrt (`docs/TEST_MATRIX.md`, `BL-0022`, `ISS-0002..ISS-0006`).
- `7d43034`: Repo-Hygiene fuer lokale Codex-Konfigurationen nachgezogen
  (`.codex/` in `.gitignore`).
- `eebac9a`: EOF-sicheren Fuelup-Dialog und Seed-/Demo-Smoke-Hardening
  umgesetzt.
- `10d6361`: Cross-Field-Guardrail `P-033` fuer Fuelups geliefert.
- `26e1499`: Stations-Masterdata-Plausibilitaet (`P-080..P-084`) gehaertet.
- `50b7600`: Resolver-Matrix-Smoke fuer den zusaetzlichen `P-050`-Prompt
  stabilisiert.
- `f590bcb`: First-Run- und Multi-Car-Guidance in CLI/Help sichtbar
  geschaerft (`TSK-0015`).
- Gate-5-Closeout 1.2.0 finalisiert:
  - `APP_VERSION=1.2.0` gesetzt.
  - finaler Doku-Sync fuer Roadmap/Status/Entry/Preflight/Changelog
    abgeschlossen.
  - lokaler Vollnachweis `make verify` ist gruen.
  - finale Release-/Backup-Ausfuehrung dokumentiert
    (`.releases/Betankungen_1_2_0.tar`, Snapshot `.backup/2026-03-24_1809`).


## General-Stream nach 1.2.0 - Kickoff 1.3.0

- Status: done
- Ziel: die neue Entwicklungsbasis `1.3.0-dev` technisch und dokumentarisch
  sauber verankern, basierend auf der verbindlichen Reihenfolge aus dem
  Entscheidungsentwurf vom 2026-03-18.

### Fortschritt (2026-03-26)

- `APP_VERSION=1.3.0-dev` gesetzt und damit die neue Entwicklungsbasis aktiv
  gemacht.
- Neue Roadmap `docs/ROADMAP_1_3_0.md` als aktiven Gate-Rahmen angelegt.
- Entry-/Status-Doku fuer den aktiven 1.3.0-Zyklus synchronisiert
  (`README.md`, `docs/README.md`, `docs/README_EN.md`, `docs/STATUS.md`,
  `docs/CHANGELOG.md`).
- Verbindliche Reihenfolge fuer die naechsten Versionen explizit verankert:
  `1.3.0` = Option B (`BL-0017` + `BL-0018`), `1.4.0` = Option C
  (`BL-0016` + `BL-0011`).
- Triggerbasierte Audit-Leitplanke fuer die 1.3.0-Linie in der Roadmap
  verankert (kein pauschales Vollaudit; Release-Audit erst an Gate 4/5
  verbindlich entscheiden).
- Gate 2 fuer die 1.3.0-Linie als Scope-Freeze nachgezogen:
  `BL-0017`/`BL-0018` auf `approved` + `lane:release-blocking`,
  Downstream-Tasks `TSK-0018` bis `TSK-0021` angelegt.
- `BL-0017` fachlich abgeschlossen: Research-Ausarbeitung in die kanonische
  Repo-Doku `docs/FUEL_PRICE_API_EVALUATION_1_3_0.md` ueberfuehrt,
  Primaerquelle `Tankerkoenig` festgelegt, Fallback `Benzinpreis-Aktuell.de`
  dokumentiert und Audit-/Betriebsgrenzen fuer `BL-0018` benannt.
- `TSK-0020` fuer `BL-0018` abgeschlossen: Kanon-Doku
  `docs/FUEL_PRICE_POLLING_HISTORY_CONTRACT_1_3_0.md` definiert jetzt
  Datenpfad-Trennung, Raw-Snapshot-Format, minimale Historienpersistenz und
  Integrationsgrenzen zur Core-Datenbank.
- `TSK-0021` fuer `BL-0018` abgeschlossen: neuer separater Runner
  `scripts/fuel_price_polling_run.sh` persistiert `tankerkoenig`-Snapshots in
  den getrennten Historienpfad (`raw/`, `db/`, `state/`); Runtime-Doku in
  `docs/FUEL_PRICE_POLLING_RUNTIME_1_3_0.md`, Regression in
  `tests/regression/run_fuel_price_history_check.sh`, Verify-Einbindung ueber
  `make fuel-price-history-check`.
- Gate 3 der 1.3.0-Linie ist damit formal abgeschlossen; lokaler
  Abschlusslauf `make verify` ist auf diesem Stand gruen, Gate 4 ist aktiv.
- Gate 4 fuer die 1.3.0-Linie ist operationalisiert: neuer Preflight-Blueprint
  `docs/RELEASE_1_3_0_PREFLIGHT.md` und operativer Entrypoint
  `scripts/release_preflight_1_3_0.sh` / `make release-preflight-1-3-0`
  verdichten RC-Haertung, Doku-Gates und Dry-Run-Nachweise.
- Der erste lokale Gate-4-Kickoff-Lauf ist gruen:
  `make release-preflight-1-3-0` lief erfolgreich inklusive `make verify`,
  `kpr.sh --dry-run` und `scripts/backup_snapshot.sh --dry-run`.
- Der RC-Checklisten-/Freeze-Snapshot fuer Gate 4 ist jetzt dokumentiert,
  inklusive aktueller CI-Referenz auf `main`
  (`CI` Run `23514165068`, Commit `ce5a574`).
- Der finale RC-Abschlusslauf fuer Gate 4 ist dokumentiert:
  `make release-preflight-1-3-0` lief gruen (inkl. `make verify`,
  Doku-Gates sowie Release-/Backup-Dry-Runs).
- Gate 4 der 1.3.0-Linie ist formal abgeschlossen; Gate 5 ist aktiv.
- Aktuelle CI-Referenz auf `main` fuer den Gate-4-Closeout ist dokumentiert
  (`CI` Run `23515516312`, Commit `027e963`, Status `success`).
- Gate-5-Kickoff-Snapshot ist dokumentiert (Scope/Version/Audit/Exit-Checks)
  in `docs/RELEASE_1_3_0_PREFLIGHT.md`.
- Finales Gate-5-Release-Umschaltpaket ist vorbereitet
  (Ziel-Dateien + Ausfuehrungsreihenfolge, ohne vorgezogenen
  `APP_VERSION`-Wechsel).
- Gate-5-Closeout fuer 1.3.0 ist abgeschlossen:
  - `APP_VERSION=1.3.0` gesetzt.
  - finaler Doku-Sync fuer Roadmap/Status/Entry/Preflight/Sprints/Changelog
    abgeschlossen.
  - lokaler Vollnachweis `make verify` ist gruen.
  - finale Release-/Backup-Ausfuehrung dokumentiert
    (`.releases/Betankungen_1_3_0.tar`, Snapshot `.backup/2026-03-26_1918`).


## General-Stream nach 1.3.0 - ADR/Backlog-Refinement

- Status: done
- Ziel: Entscheidungs- und Tracker-Basis fuer den naechsten Arbeitsabschnitt
  nach der abgeschlossenen `1.3.0`-Linie konsistent finalisieren.

### Fortschritt (2026-03-26)

- `ADR-0010` auf `accepted` finalisiert und den verbindlichen MVP-Rahmen fuer
  das repo-lokale Workflow-Wrapper-CLI `btkgit` festgezogen.
- `BL-0024` von `proposed` auf `approved` gehoben und von einem reinen
  Vorschlag auf einen umsetzbaren Arbeitsblock ausgebaut.
- Downstream-Tasks fuer `BL-0024` angelegt:
  - `TSK-0022` (Platzierung/Ton/Guardrails der Cookie-Wiki-Notiz)
  - `TSK-0023` (Veroeffentlichung, Navigation und Wiki-Link-Check)
- ADR-/Backlog-Index sowie Changelog auf den neuen Entscheidungs- und
  Tracker-Stand synchronisiert.


## General-Stream nach 1.3.0 - ADR-0010 + BL-0024 Umsetzung

- Status: done
- Ziel: den akzeptierten `ADR-0010` als operatives MVP liefern und den
  freigegebenen Backlog-Block `BL-0024` inklusive Wiki-Navigation und
  Tracker-Status vollstaendig abschliessen.

### Fortschritt (2026-03-27)

- `ADR-0010` ist jetzt technisch umgesetzt:
  - neues Wrapper-CLI `scripts/btkgit.sh` plus Root-Entrypoint `./btkgit`.
  - MVP-Kommandos aktiv: `sync`, `preflight <version>`, `ready`, `cleanup`.
  - bestehende Projektbefehle bleiben sichtbar und kanonisch (`git`, `make`,
    `scripts/release_preflight_*`).
- `BL-0024` ist umgesetzt und auf `done` gesetzt:
  - `TSK-0022` (Platzierung/Ton/Guardrails) auf `done`.
  - `TSK-0023` (Veroeffentlichung/Navigation/Link-Check) auf `done`.
  - finale Wiki-Seite `docs/wiki/Cookie-Note.md` angelegt und in
    `docs/wiki/Home.md` / `docs/wiki/README.md` verlinkt.
- Wiki-Guardrails fuer die neue Seite erweitert
  (`scripts/wiki_link_check.sh`) und per `make wiki-link-check` abgesichert.


## General-Stream nach Sprint 24 - PR-Titel-Konvention

- Status: done
- Ziel: PR-Titel fuer Sprint-Arbeit explizit von Commit-Labels und generischen
  Platzhaltern abgrenzen, damit Sprint-Branches und PRs konsistent benannt
  bleiben.

### Fortschritt (2026-03-28)

- Kurzregel in `AGENTS.md` verankert: Sprint-PR-Titel folgen auf GitHub dem
  Format `[Sxx] type: short description`.
- Commit-Labels wie `[S24C1/1]` und generische Platzhalter wie `[Sprint 24]`
  sind fuer PR-Titel jetzt explizit ausgeschlossen.
- Detailregel in `docs/GIT_WORKFLOW.md` unter `Pull Requests` ergaenzt,
  inklusive fachlicher Scope-Anforderung und Englisch-Leitplanke fuer
  GitHub-PR-Titel.


## General-Stream nach Sprint 34 - Stations-Short-Codes und Geodata-Contract

- Status: done
- Ziel: den Stations-Geodata-Flow fuer realistische Plus-Code-Eingaben aus
  mobilen Karten-UIs oeffnen, ohne den kanonischen Speichervertrag fuer
  `plus_code` aufzugeben.

### Stand (2026-04-01)

- `u_stations` akzeptiert jetzt sowohl volle/globalen Open Location Codes als
  auch lokale/short Plus Codes, wenn `latitude` und `longitude` gesetzt sind.
- Ortszusaetze aus gaengigen Karten-UIs (z. B. `GC2M+H4 Dortmund`) werden
  bei der Normalisierung auf den eigentlichen Plus-Code-Token reduziert.
- Short Codes ohne Koordinaten liefern weiter einen Hard Error, aber jetzt mit
  expliziter Guidance auf `latitude`/`longitude` oder einen vollen Code.
- Persistiert wird weiterhin ein kanonischer Vollcode; die Detailausgabe
  `--list stations --detail` zeigt ihn wie vorgesehen in der `geodata:`-Zeile.
- `ISS-0007`, `BL-0019`, `tests/domain_policy/p080.md`, die neuen
  `P-088/02`- und `P-088/03`-Cases sowie
  `tests/regression/run_station_geodata_contract_check.sh` sichern den neuen
  Contract ab.

### Validierung

- `bash tests/domain_policy/cases/t_p088__01__station_plus_code_invalid_rejected.sh`
- `bash tests/domain_policy/cases/t_p088__02__station_short_plus_code_without_coordinates_rejected.sh`
- `bash tests/domain_policy/cases/t_p088__03__station_short_plus_code_with_coordinates_accepts.sh`
- `tests/regression/run_station_geodata_contract_check.sh`
- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 34 - EV module scope baseline

- Status: done
- Ziel: `TSK-0024` als klaren Discovery-/Contract-Block abschliessen und den
  minimalen Scope fuer `betankungen-ev` so schneiden, dass `TSK-0025`
  unmittelbar mit Event-/Storage-Fragen weiterarbeiten kann, ohne schon eine
  produktive EV-Implementierung oder ein generisches Core-Refactoring
  vorzuziehen.

### Stand (2026-04-01)

- `BL-0030` wurde auf `in_progress` gezogen und `TSK-0024` auf `done`
  gestellt.
- `docs/MODULES_ARCHITECTURE.md` definiert jetzt den minimalen
  `charging`-Scope, die Core-vs-Modul-Grenzen, die erwarteten
  `capabilities` und die expliziten Nicht-Ziele fuer `betankungen-ev`.
- `docs/BACKLOG.md` und `docs/STATUS.md` fuehren denselben Discovery-
  Zuschnitt; `TSK-0025` bleibt auf das minimale Event-/Storage-Modell
  begrenzt.
- `docs/CHANGELOG.md` und `docs/SPRINTS.md` fuehren diesen Block bewusst als
  General-Stream ohne neuen Sprint-Prefix.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 36 - Fuelup-Listen bleiben stationsfokussiert

- Status: done
- Ziel: die `fuelups`-Listenzeile so schaerfen, dass der Stationsname nicht
  durch einen abgeschnittenen ` / <car>`-Suffix entwertet wird und der
  Fahrzeugkontext weiter nur dort sichtbar bleibt, wo er wirklich Platz hat.

### Stand (2026-04-02)

- Die Hauptzeile von `--list fuelups` und `--list fuelups --detail` zeigt
  jetzt nur noch `brand (city)` als Stationslabel.
- Der Fahrzeugkontext bleibt in `--detail` separat ueber `Car: ...`
  sichtbar, statt die Stationsspalte zu ueberladen.
- `tests/regression/run_receipt_link_contract_check.sh` sichert jetzt
  explizit ab, dass die kompakte Liste den Stationsnamen ohne
  abgeschnittenen Car-Suffix zeigt und die Detailansicht den Fahrzeugkontext
  separat beibehaltet.
- `docs/BENUTZERHANDBUCH.md` beschreibt die neue Rollenverteilung zwischen
  stationsfokussierter Hauptzeile und separatem Fahrzeugkontext in `--detail`.

### Validierung

- `tests/regression/run_receipt_link_contract_check.sh`
- `make verify`


## General-Stream nach Sprint 36 - Receipt-Link-Normalisierung und Hybrid-Folgepfad schaerfen

- Status: done
- Ziel: den bereits vorbereiteten Fuelup-Guidance-Block so praezisieren, dass
  Receipt-Link-Normalisierung, lokale Existenz-Guidance und ein spaeterer
  Hybrid-Folgepfad fuer Belegspeicherung sauber voneinander getrennt bleiben.

### Stand (2026-04-02)

- `BL-0031` fuehrt Receipt-Link-Normalisierung und lokale
  Existenz-Guidance jetzt explizit im Scope.
- `TSK-0027` benennt den erwarteten Guidance-Contract genauer:
  lokale absolute Pfade bleiben zulaessig, sollen spaeter aber auf einen
  kanonischen `file://`-Wert normalisiert werden; fehlende lokale Dateien
  sollen nicht still akzeptiert werden.
- Ein neuer optionaler Folge-Backlog `BL-0032` beschreibt die spaetere
  Hybrid-Idee fuer Receipt-Speicherung:
  externe Nutzerordner bleiben erlaubt, ein app-verwalteter
  XDG-Belegordner waere hoechstens ein spaeterer Komfortmodus.
- `docs/BACKLOG.md`, `docs/STATUS.md` und `docs/README.md` fuehren denselben
  Planungsstand.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`


## General-Stream nach Sprint 33 - Car-Startwerte vor erstem Fuelup korrigieren

- Status: done
- Ziel: den Cars-Edit-Flow so oeffnen, dass Start-KM/-Datum eines Fahrzeugs
  vor dem ersten Fuelup korrigiert werden koennen, ohne die spaetere
  Odometer-Historie zu destabilisieren.

### Stand (2026-03-31)

- `--edit cars` fragt Start-KM und Start-Datum jetzt mit ab, solange fuer das
  Fahrzeug noch keine `fuelups` existieren.
- Sobald bereits `fuelups` vorhanden sind, zeigt der Edit-Flow die Startwerte
  nur noch als gesperrt an; Name/Plate/Note bleiben weiterhin editierbar.
- `u_db_init` ersetzt die fruehere globale Immutability durch DB-Trigger, die
  Startwert-Aenderungen erst **nach** dem ersten Fuelup blockieren.
- `tests/smoke/smoke_cars_crud.sh` deckt jetzt sowohl die erfolgreiche
  Korrektur vor dem ersten Fuelup als auch den CLI-/DB-Guard danach ab.
- `docs/README.md` und `docs/BENUTZERHANDBUCH.md` dokumentieren die neue
  Produktregel fuer Fahrzeug-Startwerte.

### Validierung

- `tests/smoke/smoke_cars_crud.sh`
- `make verify`


## General-Stream nach Sprint 31 - Knowledge-Archive stilllegen

- Status: done
- Ziel: `knowledge_archive/` repo-seitig ruhig stilllegen, den Bestand als
  Legacy-/Read-only-Ordner behalten und die Pflicht fuer neue
  Archiv-Snippets aufheben.

### Stand (2026-03-31)

- `AGENTS.md` und `knowledge_archive/README.md` markieren
  `knowledge_archive/` jetzt explizit als deprecated/read-only.
- Neue Archiv-Snippets sind nicht mehr verpflichtender Repo-Standard; fuer
  fruehere Implementationsstaende ist die Git-Historie der primaere
  Rueckgriff.
- `docs/STATUS.md`, `docs/README.md` und `docs/ARCHITECTURE.md` ordnen den
  Ordner nur noch als Legacy-Bestand ein.
- Historische Referenzen in `docs/CHANGELOG.md` und `docs/SPRINTS.md`
  bleiben bewusst unveraendert; der neue Status wird nur transparent
  dokumentiert.

### Validierung

- `make verify`


## Traceability-Backfill fuer Sprint 25 bis 28

- Status: done
- Ziel: die fehlenden kanonischen BL-/ADR-Referenzen fuer den bereits
  abgeschlossenen Vorbereitungsblock nachziehen, ohne Sprint 25 bis 28
  inhaltlich neu zu oeffnen.

### Stand (2026-03-30)

- `BL-0025` bis `BL-0028` dokumentieren Sprint 25 bis 28 jetzt auch im
  kanonischen Backlog.
- `ADR-0011` bis `ADR-0013` halten den bereits entschiedenen Tracker-,
  Entry-Layer- und `btkgit`-Vertrag explizit fest.
- `docs/BACKLOG.md`, `docs/ADR/README.md` und `docs/STATUS.md` sind auf diese
  Backfills synchronisiert; bestehende Sprint-Ziele, Commit-Folgen und
  Gate-Aussagen bleiben unveraendert.
- Kein Start von `1.4.0-dev`, keine Aktivierung von `BL-0016`, keine neue
  `btkgit`-Umsetzung.

### Validierung

- `scripts/projtrack_lint.sh`
- `make verify`
