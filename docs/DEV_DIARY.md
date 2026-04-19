# Dev Diary
**Stand:** 2026-04-19

Kuratiertes Entwicklungsjournal mit bewusst knappen, projektbezogenen
Notizen zu Entscheidungen, Huerden und Learnings.

Diese Seite ist absichtlich sichtbar eingebunden, wenn ein Leser nach dem
Warum hinter einem Schritt sucht. Sie bleibt aber eine Chronik und ersetzt
weder Release-Fakten noch Sprint-Traceability.

## Zielbild

Das Dev-Diary macht den persoenlichen Projektfaden sichtbar, ohne die
technischen Source-of-Truth-Dokumente zu ersetzen.

Es beantwortet vor allem:
- Was war im Verlauf bemerkenswert?
- Welche Entscheidung hat sich warum geaendert?
- Welche kleine Erkenntnis war rueckblickend wichtig?

## Abgrenzung

- `docs/CHANGELOG.md`:
  - Was wurde geaendert (fakten-/contract-zentriert, release-nah).
- `docs/SPRINTS.md`:
  - Wie lief die Sprintfolge (Ziel, Commit-Folge, Traceability).
- `docs/DEV_DIARY.md` + `docs/dev_diary/*.md`:
  - Warum sich ein Schritt menschlich/konzeptionell relevant angefuehlt hat.
- Entry-/Wiki-Handoff:
  - `README.md`, `docs/README.md`, `docs/README_EN.md` und `docs/wiki/*`
    verlinken diese Chronik bewusst sichtbar, halten sie aber ausserhalb des
    technischen Hauptpfads.

## Leitplanken

- kurz halten (pro Eintrag in der Regel 5-20 Zeilen)
- projektbezogen bleiben (kein privates Tagebuch)
- keine Duplikation kompletter Changelog-Abschnitte
- keine vertraulichen Informationen oder Secrets
- Ton: ruhig, praezise, reflektiert

## Struktur

- Index/Regeln: `docs/DEV_DIARY.md` (diese Datei)
- Eintraege: `docs/dev_diary/YYYY-MM-DD-<slug>.md`
- Empfohlener Aufbau pro Eintrag:
  - Kontext
  - Entscheidung / Beobachtung
  - Learning / naechster Fokus

## Eintraege

- [2026-03-24: BL-0023 kick-off and framing](dev_diary/2026-03-24-bl0023-kickoff-and-framing.md)
