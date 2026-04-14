# AGENTS
**Stand:** 2026-04-14

<INSTRUCTIONS>

## Allgemeine Kommunikation
- Kommunikation immer auf Deutsch.
- Kommentare auf GitHub (Issues, PRs, Reviews) immer auf Englisch verfassen.
- Bei der ersten Änderung an einer Datei pro Task: Datum im Header/Metadaten auf das aktuelle Datum setzen.
- Wenn Dateien geändert werden: vorhandene Header/Metadaten an die neue Funktionalität anpassen, falls diese nicht mehr korrekt sind.

## Doku-Sprachstrategie (Public-Readiness)
- Interne und tiefe Projektdokumentation darf standardmaessig auf Deutsch bleiben, solange dies die Arbeitsgeschwindigkeit erhoeht.
- Fuer oeffentliche Sichtbarkeit werden englische Einstiegsdokumente schrittweise gepflegt (inkrementell, kein Big-Bang-Umbau).
- Prioritaet fuer Englisch:
  1. Root-`README.md`
  2. `CONTRIBUTING.md`
  3. kuratierte Entry-Doku unter `docs/` (z. B. `docs/README_EN.md`)
- Vollstaendige Uebersetzung der gesamten Historien-/Detaildoku ist vor `1.0.0` kein Pflichtziel.
- Bei neuen oeffentlich relevanten Doku-Abschnitten ist eine knappe englische Einstiegs- oder Zusammenfassungsvariante aktiv mitzuplanen.

## Tracker-/Policy-Stand (verbindlich)
- Der kanonische Tracker-Standard liegt in `docs/policies/POL-001-tracker-standard.md`.
- Kanonische Tracker-Pfade fuer neue Eintraege:
  - `docs/backlog/` (Backlog + Tasks)
  - `docs/issues/` (Issues)
  - `docs/policies/` (Policies/Standards)
- Legacy-Bestand bleibt waehrend der Migration gueltig und lesbar:
  - `docs/BACKLOG/`
  - `docs/ADR/`
- Neue `ADR`/`BL`/`ISS`/`TSK` werden 4-stellig angelegt; Legacy-IDs mit 3 Stellen bleiben les-/referenzierbar.
- Neue Tracker-Eintraege werden ueber die Vorlagen in `docs/policies/templates/` gestartet.

## Repo-Pflege
- Codex uebernimmt auf Wunsch die laufende Repo-Pflege (z. B. `status`, `fetch`, bewusster `pull --ff-only`, `stash`, `add/commit/push`, Remote-Checks und Branch-Sync).
- Commit + Push werden von Codex auf Wunsch vollstaendig uebernommen (inkl. Branch-Flow), sodass nach fachlicher Freigabe kein separater manueller Push durch den User noetig ist.
- Bei Auth-/Transportproblemen (SSH/Passphrase) darf Codex fuer nicht-interaktive Laeufe den HTTPS-Weg mit vorhandener `gh`-Authentifizierung nutzen, sofern kein Sicherheitsrisiko entsteht.
- Potenziell destruktive Git-Aktionen (z. B. `reset --hard`, History-Rewrite auf geteilten Branches, erzwungene Pushes) erfolgen nur nach expliziter User-Freigabe.
- Sicherheitsfeatures duerfen niemals umgangen oder temporar deaktiviert werden, auch nicht zur Problemlosung oder als vermeintlicher Workaround.
- Das gilt insbesondere fuer Commit-/Tag-Signaturen (z. B. GPG-Signing, SSH-Signing), Branch-Protection, Review-/Policy-Gates und vergleichbare Schutzmechanismen.
- Wenn ein Task an einem aktiven Sicherheitsfeature scheitert, muss Codex stoppen, den Blocker klar benennen und den User nach dem naechsten sicheren Schritt fragen; ein Umgehen per Flag, Config-Override oder alternativer Befehl ist unzulaessig.

### Public-Repo-Governance (verbindlich)
- `main` wird als geschuetzter Release-Branch behandelt; direkte Pushes auf `main` sind nicht der Standardpfad.
- Standardablauf fuer Aenderungen: `main`-Stand beobachtend pruefen, bei Bedarf bewusst fast-forward aktualisieren -> Feature-Branch erstellen -> Aenderungen committen/pushen -> PR gegen `main` -> Merge nach gruenem `verify`/Regelcheck.
- PR-Beschreibungen enthalten mindestens zwei Bloecke: `Summary` (was/warum) und `Validation` (ausgefuehrte Checks).
- PR-Titel fuer Sprint-Arbeit folgen auf GitHub dem Format `[Sxx] type: short description`; Commit-Labels wie `[S24C1/1]` oder generische Titel wie `[Sprint 24]` sind als PR-Titel nicht zulaessig.
- Verbindliche Detailleitplanke fuer Branch-/Commit-/PR-/Merge-Entscheidungen liegt in `docs/GIT_WORKFLOW.md`.
- Standard-Merge-Strategie ist verbindlich `Create a merge commit`.
- Prioritaetsregel: Wenn ein fester Merge-Standard definiert ist, muss dieser immer verwendet werden; heuristische Entscheidungsregeln (z. B. "Squash bei kleinen Aenderungen") gelten nur ohne expliziten Standard.
- `Squash and merge` ist nur erlaubt, wenn der Merge-Standard explizit ueberschrieben wird oder der Task dies eindeutig fordert.
- Ohne explizite Freigabe darf kein `Squash and merge` verwendet werden.
- Begruendung: Merge-Commits erhalten die Branch-Struktur und verbessern die Traceability; konsistente Merge-Strategie hat Vorrang vor kurzfristiger Historienvereinfachung.
- Rebase-Merge wird nicht verwendet.
- Nach Merge wird der Arbeitsbranch aufgeraeumt (remote + lokal), sofern kein expliziter Weiterverwendungsgrund dokumentiert ist.
- Ausnahmefaelle (z. B. dringender Hotfix ausserhalb des Standardpfads) nur mit expliziter User-Freigabe und sichtbarer Dokumentation in `docs/CHANGELOG.md`.
- Bei aktiver Review-Pflicht und Solo-Maintenance gilt: temporaere Regelanpassungen sind erlaubt, muessen aber nach dem Merge wieder auf den Zielzustand zurueckgestellt werden.

### Public-Security-Hygiene
- Keine Secrets/API-Keys/Token in Repository-Dateien, Commit-Messages, PR-Texten oder Wiki-Inhalten.
- Keine produktiven personenbezogenen oder sensiblen Nutzdaten als Testfixtures committen; nur Demo-/synthetische Daten.
- Bei Fehlermeldungen/Logs in oeffentlichen Doku-/PR-Texten keine unnoetigen lokalen Systemdetails offenlegen (nur technisch relevante Ausschnitte).
- Sicherheitsrelevante Schutzmechanismen im Tooling oder Repo duerfen nicht fuer den Arbeitsfortschritt abgeschaltet, umkonfiguriert oder umgangen werden; bei Blockern ist anzuhalten und Rueckfrage zu halten.

### Repo-Pflege-Rhythmus
- Session-Start: einmalige Arbeitskopien-Pruefung mit `git remote -v`, `git fetch --prune origin`, `git status --short --branch` und `git log -1 --oneline`; `git pull --ff-only` nur als bewusste Folgeaktion, wenn der konkrete Task einen Fast-Forward-Sync verlangt.
- Waehrend der Session: Commits und Pushes erfolgen pro fachlich-logischer Einheit (z. B. Feature-Block, Bugfix-Block, Doku-Block).
- Session-Ende: finaler Beobachtungs-/Sync-Check mit `git fetch --prune origin` und `git status --short --branch`; ein zusaetzlicher `git pull --ff-only` bleibt eine bewusste Ausnahme fuer konkrete Abschluss- oder Integrationsschritte.
- Bei laengeren Tasks: mehrere Zwischen-Commits sind gewuenscht; bei kurzen Tasks reicht in der Regel ein Abschluss-Commit.
- Release-Disziplin: Tags/Release-Artefakte erst bei `Done` (nach finaler Freigabe); vorher nur normale Commits/Pushes ohne Release-Schritt.
- Commit-Message-Konvention (verbindlich): `[Scope] type: kurze beschreibung`.
- `Scope` steht in eckigen Klammern (z. B. `[General]`; bei Sprint-Arbeit `[SxCy/z]`).
- `type` ist klein geschrieben (z. B. `docs`, `feat`, `cli`, `release`, `chore`).
- Beschreibung ist kurz, praezise und ohne Fuelltext.
- Keine gemischten Formate (z. B. nicht abwechselnd `chore(...)` und `[General] ...`).
- Neue Commits muessen sich an diese Repo-Konvention anpassen; Abweichungen sind nur bei explizit eingefuehrter neuer Konvention erlaubt.
- Sprint-Tagging: Nach komplett abgeschlossenem und freigegebenem Sprint wird genau ein annotierter Tag im Format `sprint-<nr>-done` erstellt und gepusht; keine Sprint-Tags auf Zwischenstaenden.
- Version-Tagging: Release-/Version-Tags (z. B. `1.2.0`) werden nur nach expliziter User-Freigabe erstellt und gepusht (keine automatische Tag-Erstellung).
- Sprint-Artefakte nach Push: Nach jedem erfolgreichen Push eines Sprint-Commits erstellt Codex selbststaendig lokale Artefakte in `.artifacts/` (`.artifacts/sprint_<nr>_commit_<nr>_von_<nr>.diff` und `.artifacts/sprint_<nr>_commit_<nr>_von_<nr>.md`).
- Reihenfolge fuer Sprint-Artefakte: 1) Commit und Push abschliessen. 2) `.diff` aus dem gepushten Commit erzeugen (z. B. `git show --stat --patch <hash> > .artifacts/sprint_<...>.diff`). 3) Begleit-`.md` mit Ziel, Hash, Message und Artefaktverweisen in `.artifacts/` erstellen.
- Sprint-Artefakte bleiben lokal: `.artifacts/*.md` und `.artifacts/*.diff` werden grundsaetzlich nicht committed oder gepusht (nur bei expliziter User-Freigabe).

### Versionierungs-Policy (verbindlich)
- Codex uebernimmt die Versionierung selbststaendig und haelt `APP_VERSION` in `src/Betankungen.lpr` aktiv synchron.
- `road to X.Y.Z`:
  - nur als Planungs-/Roadmap-Label in Doku (`docs/STATUS.md`, `docs/README.md`, `docs/ARCHITECTURE.md`);
  - niemals als Wert in `APP_VERSION`.
- `X.Y.Z-dev`:
  - Standard fuer aktive Entwicklungsphase vor einem Release;
  - bei neuem Feature-/Scope-Zyklus auf naechste Minor-Basis setzen (typisch `X.(Y+1).0-dev`).
- `X.Y.(Z>0)-dev`:
  - verwenden, wenn gezielt ein Patch-/Hotfix-Zyklus auf bereits freigegebenem Minor gefahren wird (z. B. `0.8.1-dev`).
- `X.Y.Z` (final, ohne Suffix):
  - nur bei expliziter Release-Freigabe des Users;
  - vor finalem Release-Commit/Tag/Artefakt auf final setzen.
- Nach einem finalen Release setzt Codex im naechsten Entwicklungs-Commit wieder auf eine `-dev`-Version der naechsten vereinbarten Linie.
- Bei jeder Versionsaenderung sind mindestens diese Stellen konsistent zu halten:
  - `src/Betankungen.lpr` (`APP_VERSION`) als technische Source of Truth,
  - `docs/STATUS.md` Zielversion/Roadmap-Text,
  - `docs/CHANGELOG.md` mit neutralem Eintrag unter `[Unreleased] -> Changed`.

## Build-Standard
- FPC-Compile immer mit folgendem Befehl aus dem Projektroot ausfuehren:
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`
- Verifikations-Gate lokal:
  - `make verify`
  - enthaelt u. a. `scripts/sprint_docs_lint.sh` und `scripts/projtrack_lint.sh`
- Wenn Tracker-Dateien (`docs/backlog/**`, `docs/issues/**`, `docs/policies/**`) geaendert werden, muss `scripts/projtrack_lint.sh` gruen laufen.

## Dokumentations-Management
- Dokumentation im `docs`-Ordner bei Hoch/Mittel-Priorität selbstständig mitpflegen.
- `docs/CHANGELOG.md` bei JEDER Änderung aktualisieren (inkl. aktuellem Datum).
- `docs/SPRINTS.md` als Sprint-Narrative mitfuehren (Status, Zielbild, Commit-Reihenfolge, relevante Hashes/Artefakte, Abschluss-Tag pro Sprint).
- CHANGELOG-Einträge neutral und feature-zentriert unter `[Unreleased] -> Changed` erfassen (kein personenbezogenes Framing als Abschnittsueberschrift).
- Attribution transparent, aber dezent ueber `[Unreleased] -> Tooling / Assistance` halten (ein kurzer Sammelhinweis reicht).
- Sprint-/Commit-Traceability ist verpflichtend: Bei Sprint-Arbeit muessen Eintraege unter `[Unreleased] -> Changed` mit einem Prefix im Format `[SxCy/z]` beginnen (Beispiel: `[S1C1/4]`).
- `docs/CHANGELOG.md` muss unter `[Unreleased]` zusaetzlich eine Sektion `Sprint / Commit References` enthalten; dort pro Sprint-Commit mindestens Kurzbezeichnung, Bezug zu Artefaktdateien (z. B. `.artifacts/sprint_1_commit_1_von_4.md`, `.diff`) und vorhandener Git-Commit-Hash dokumentieren.
- Hash-Traceability ist fuer sprintgebundene Eintraege (`[SxCy/z]`) verpflichtend.
- Der Hash in `docs/CHANGELOG.md` und `docs/SPRINTS.md` muss der Commit sein, der die jeweilige Sprint-Aenderung tatsaechlich einfuehrt (kein spaeterer Doku-Sync-Commit).
- Der Git-Commit-Hash muss bei Sprint-Arbeit unmittelbar nach dem Commit ermittelt und in `docs/CHANGELOG.md` sowie `docs/SPRINTS.md` eingetragen werden, bevor der Task abgeschlossen wird.
- Der Hash darf bei Sprint-Arbeit nicht erst in einem spaeteren Dokumentations-Commit ergaenzt werden.
- Fuer die Dokumentation wird der Short-Hash mit 7 Zeichen verwendet (z. B. `701b34f`).
- Der Hash muss immer direkt aus dem lokalen Git-Repo stammen (`git rev-parse --short=7 HEAD`) und darf nicht geschaetzt werden.
- Empfohlener Workflow (Sprint-Traceability):
  1. Aenderung implementieren
  2. Commit durchfuehren
  3. Commit-Hash mit `git rev-parse --short=7 HEAD` ermitteln
  4. Hash sofort in `docs/CHANGELOG.md` und `docs/SPRINTS.md` eintragen
  5. Doku-Update committen
- Falls ein Task nicht sprintgebunden ist, den Prefix `[General]` verwenden.
- Beispiel (Format, `[Unreleased] -> Changed`): `- u_fmt: CSV-Helper ergaenzt. (YYYY-MM-DD)`
- Beispiel (Format, `[Unreleased] -> Tooling / Assistance`): `- Implementation und Review erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (YYYY-MM-DD)`

## Wiki-Pflege (Public-Readiness)
- Wiki-Inhalte werden im Repository unter `docs/wiki/` versioniert; diese Dateien sind die redaktionelle Source fuer den Wiki-Einstieg.
- Bei Wiki-relevanten Aenderungen ist `make wiki-link-check` verpflichtend auszufuehren.
- Veroeffentlichungsfluss:
  1. `docs/wiki/*.md` aktualisieren
  2. `make wiki-link-check` ausfuehren
  3. Inhalte in das GitHub-Wiki-Repo `<owner>/<repo>.wiki.git` synchronisieren
  4. bei technischem Wiki-Blocker (Remote nicht verfuegbar) bleibt `docs/wiki/` der verbindliche Zwischenstand; Blocker im `docs/CHANGELOG.md` transparent dokumentieren
- Leitplanke: Wiki bleibt kuratierter Einstieg, tiefe/finale Details verbleiben in `docs/` (Source of Truth).

## Knowledge-Archive-Regeln
- `knowledge_archive/` ist als Legacy-/Read-only-Bestand eingefroren.
- Neue Archiv-Snippets werden repo-seitig nicht mehr verpflichtend erzeugt und sind kein Standardpfad fuer normale Codeaenderungen mehr.
- Fuer fruehere Implementationsstaende ist die Git-Historie der primaere Rueckgriff.
- Der vorhandene Bestand in `knowledge_archive/` bleibt zunaechst lesbar erhalten und wird nicht rueckwirkend umgeschrieben.
- Eine spaetere vollstaendige Herausloesung aus dem Repository bleibt als optionaler Folgeschritt moeglich, ist aber nicht Teil des laufenden Standards.

## Priorisierung von Änderungen & Dokumentations-Pflicht
Nach Änderungen muss die KI die Relevanz für die Dokumentation (insb. im `docs`-Ordner) wie folgt bewerten:

1. **HOHE PRIORITÄT (Update zwingend erforderlich):**
   - Neue Features, Subcommands oder öffentliche API/Units.
   - Änderungen am Datenmodell oder Schema.
   - Anpassung von Ausgabeformaten (Text, JSON, CSV) oder CLI-Flags/Verhalten.
   - Refactors, die eine Funktionsänderung oder neue Logik beinhalten.
   - *Aktion:* Dokumentation sofort und eigenständig aktualisieren.

2. **MITTLERE PRIORITÄT (Update-Prüfung erforderlich):**
   - Optimierung bestehender Funktionen oder signifikante interne Logikänderungen.
   - Neue Fehlermeldungen oder geändertes Validierungsverhalten.
   - *Aktion:* Dokumentation prüfen und proaktiv vorschlagen ("Soll ich die Doku für X anpassen?").

3. **KEINE PRIORITÄT (Kein Update nötig):**
   - Korrektur von Tippfehlern, reine Code-Formatierung (Linting).
   - Refactors ohne jegliche Änderung der externen Funktionsweise.

## Checkliste für Dokumentations-Konsistenz
Bevor ein Task mit **Hoher** oder **Mittlerer** Priorität abgeschlossen wird, muss die KI folgende Punkte in den betroffenen Dokumenten validieren:
- [ ] **Vollständigkeit:** Sind alle neuen Parameter, Flags oder Funktionen beschrieben?
- [ ] **Beispiele:** Sind Code-Beispiele und Beispiel-Outputs (JSON/CSV) noch aktuell?
- [ ] **Referenzen:** Passen alle internen Verweise und Links noch zum neuen Stand?
- [ ] **Sprache:** Bleiben Terminologie und Tonfall konsistent zum Rest der Dokumentation?
</INSTRUCTIONS>
