# AGENTS
**Stand:** 2026-03-07

<INSTRUCTIONS>

## Allgemeine Kommunikation
- Kommunikation immer auf Deutsch.
- Kommentare auf GitHub (Issues, PRs, Reviews) immer auf Englisch verfassen.
- Bei der ersten Änderung an einer Datei pro Task: Datum im Header/Metadaten auf das aktuelle Datum setzen.
- Wenn Dateien geändert werden: vorhandene Header/Metadaten an die neue Funktionalität anpassen, falls diese nicht mehr korrekt sind.

## Repo-Pflege
- Codex uebernimmt auf Wunsch die laufende Repo-Pflege (z. B. `status`, `fetch/pull --rebase`, `stash`, `add/commit/push`, Remote-Checks und Branch-Sync).
- Bei Auth-/Transportproblemen (SSH/Passphrase) darf Codex fuer nicht-interaktive Laeufe den HTTPS-Weg mit vorhandener `gh`-Authentifizierung nutzen, sofern kein Sicherheitsrisiko entsteht.
- Potenziell destruktive Git-Aktionen (z. B. `reset --hard`, History-Rewrite auf geteilten Branches, erzwungene Pushes) erfolgen nur nach expliziter User-Freigabe.

### Repo-Pflege-Rhythmus
- Session-Start: einmaliger Sync mit `fetch` und `pull --rebase`, damit lokal auf aktuellem Remote-Stand gearbeitet wird.
- Waehrend der Session: Commits und Pushes erfolgen pro fachlich-logischer Einheit (z. B. Feature-Block, Bugfix-Block, Doku-Block).
- Session-Ende: finaler Sync-Check (`fetch`/ggf. `pull --rebase`), danach Abschluss-Commit(s) und Push.
- Bei laengeren Tasks: mehrere Zwischen-Commits sind gewuenscht; bei kurzen Tasks reicht in der Regel ein Abschluss-Commit.
- Release-Disziplin: Tags/Release-Artefakte erst bei `Done` (nach finaler Freigabe); vorher nur normale Commits/Pushes ohne Release-Schritt.
- Commit-Message-Konvention fuer Sprint-Arbeit: Betreff beginnt mit Prefix `[SxCy/z]` (Beispiel: `[S1C2/4] tests: cars_crud csv scope field-based`).
- Sprint-Tagging: Nach komplett abgeschlossenem und freigegebenem Sprint wird genau ein annotierter Tag im Format `sprint-<nr>-done` erstellt und gepusht; keine Sprint-Tags auf Zwischenstaenden.
- Sprint-Artefakte nach Push: Nach jedem erfolgreichen Push eines Sprint-Commits erstellt Codex selbststaendig lokale Artefakte in `.artifacts/` (`.artifacts/sprint_<nr>_commit_<nr>_von_<nr>.diff` und `.artifacts/sprint_<nr>_commit_<nr>_von_<nr>.md`).
- Reihenfolge fuer Sprint-Artefakte: 1) Commit und Push abschliessen. 2) `.diff` aus dem gepushten Commit erzeugen (z. B. `git show --stat --patch <hash> > .artifacts/sprint_<...>.diff`). 3) Begleit-`.md` mit Ziel, Hash, Message und Artefaktverweisen in `.artifacts/` erstellen.
- Sprint-Artefakte bleiben lokal: `.artifacts/*.md` und `.artifacts/*.diff` werden grundsaetzlich nicht committed oder gepusht (nur bei expliziter User-Freigabe).

## Build-Standard
- FPC-Compile immer mit folgendem Befehl aus dem Projektroot ausfuehren:
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`

## Dokumentations-Management
- Dokumentation im `docs`-Ordner bei Hoch/Mittel-Priorität selbstständig mitpflegen.
- `docs/CHANGELOG.md` bei JEDER Änderung aktualisieren (inkl. aktuellem Datum).
- `docs/SPRINTS.md` als Sprint-Narrative mitfuehren (Status, Zielbild, Commit-Reihenfolge, relevante Hashes/Artefakte, Abschluss-Tag pro Sprint).
- CHANGELOG-Einträge neutral und feature-zentriert unter `[Unreleased] -> Changed` erfassen (kein personenbezogenes Framing als Abschnittsueberschrift).
- Attribution transparent, aber dezent ueber `[Unreleased] -> Tooling / Assistance` halten (ein kurzer Sammelhinweis reicht).
- Sprint-/Commit-Traceability ist verpflichtend: Bei Sprint-Arbeit muessen Eintraege unter `[Unreleased] -> Changed` mit einem Prefix im Format `[SxCy/z]` beginnen (Beispiel: `[S1C1/4]`).
- `docs/CHANGELOG.md` muss unter `[Unreleased]` zusaetzlich eine Sektion `Sprint / Commit References` enthalten; dort pro Sprint-Commit mindestens Kurzbezeichnung, Bezug zu Artefaktdateien (z. B. `.artifacts/sprint_1_commit_1_von_4.md`, `.diff`) und vorhandener Git-Commit-Hash dokumentieren.
- Der Hash in `docs/CHANGELOG.md` und `docs/SPRINTS.md` muss immer der Commit sein, der die jeweilige Aenderung tatsaechlich einfuehrt (kein spaeterer Doku-Sync-Commit).
- Der Git-Commit-Hash muss unmittelbar nach dem Commit ermittelt und in `docs/CHANGELOG.md` sowie `docs/SPRINTS.md` eingetragen werden, bevor der Task abgeschlossen wird.
- Der Hash darf nicht erst in einem spaeteren Dokumentations-Commit ergaenzt werden.
- Fuer die Dokumentation wird der Short-Hash mit 7 Zeichen verwendet (z. B. `701b34f`).
- Der Hash muss immer direkt aus dem lokalen Git-Repo stammen (`git rev-parse --short=7 HEAD`) und darf nicht geschaetzt werden.
- Empfohlener Workflow:
  1. Aenderung implementieren
  2. Commit durchfuehren
  3. Commit-Hash mit `git rev-parse --short=7 HEAD` ermitteln
  4. Hash sofort in `docs/CHANGELOG.md` und `docs/SPRINTS.md` eintragen
  5. Doku-Update committen
- Falls ein Task nicht sprintgebunden ist, den Prefix `[General]` verwenden.
- Beispiel (Format, `[Unreleased] -> Changed`): `- u_fmt: CSV-Helper ergaenzt. (YYYY-MM-DD)`
- Beispiel (Format, `[Unreleased] -> Tooling / Assistance`): `- Implementation und Review erfolgten mit Unterstuetzung durch AI-Tools als Sparringspartner. (YYYY-MM-DD)`

## Knowledge-Archive-Regeln
- Bei Loeschung von Prozeduren/Funktionen muss die urspruengliche Version vor dem Entfernen in `knowledge_archive/` gesichert werden.
- Bei funktionalen Verhaltensaenderungen (nicht nur Refactoring/Formatierung) soll die urspruengliche Version ebenfalls in `knowledge_archive/` gesichert werden, damit die Historie ohne Git-Dive nachvollziehbar bleibt.
- Jede neue Archivdatei wird in `knowledge_archive/README.md` dokumentiert (Quelle/Datei, Symbolname, Anlass, Datum, zugehoeriger Commit-Hash falls vorhanden).
- Dateinamenskonvention fuer neue Archive: `archive_<symbol_or_topic>_<YYYY-MM-DD>.<ext>`.
- Archiv-Snippets verwenden einen standardisierten Header im Stil `ARCHIVE-SNIPPET` gemaess Template in `knowledge_archive/README.md`.

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
