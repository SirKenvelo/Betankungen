# AGENTS
**Stand:** 2026-02-22

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

## Build-Standard
- FPC-Compile immer mit folgendem Befehl aus dem Projektroot ausfuehren:
  `fpc -Mobjfpc -Sh -gl -gw -FEbin -FUbuild -Fuunits src/Betankungen.lpr`

## Dokumentations-Management
- Dokumentation im `docs`-Ordner bei Hoch/Mittel-Priorität selbstständig mitpflegen.
- `docs/CHANGELOG.md` bei JEDER Änderung aktualisieren (inkl. aktuellem Datum).
- CHANGELOG-Einträge im bestehenden Stil der Datei pflegen (gleiches Format/Abschnitt wie bisherige Codex-Einträge).
- CHANGELOG-Kennzeichnung: Änderungen von Usern unter „Changed (User-Edits)“, Änderungen von Codex unter „Changed (Codex)“.
- CHANGELOG-Ort: Einträge immer unter `[Unreleased]` und in den bestehenden Unterabschnitten erfassen.
- Beispiel (Format, `[Unreleased] -> Changed (Codex)`): `- u_fmt: CSV-Helper ergaenzt. (YYYY-MM-DD)`
- Beispiel (Format, `[Unreleased] -> Changed (User-Edits)`): `- README: Abschnitt zu u_stats aktualisiert. (YYYY-MM-DD)`

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
