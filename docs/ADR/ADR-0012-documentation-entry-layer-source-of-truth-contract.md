# ADR-0012: Documentation Entry Layer und Source-of-Truth-Vertrag
**Stand:** 2026-03-30
**Status:** accepted
**Datum:** 2026-03-29

## Kontext

Sprint 26 und Sprint 27 haben die Einstiegsdokumente, den Transition-Hold nach
`1.3.0` und die Wiki-Schicht auf einen ruhigeren, konsistenten Zustand
gebracht. Vorher waren Rollen und Erwartungshaltung zwischen Root-README,
deutscher/englischer Doku, Wiki und `docs/STATUS.md` nicht scharf genug
voneinander getrennt.

Fuer ein oeffentlich lesbares Repository braucht Betankungen eine einfache,
stabile Regel: **wo beginnt man, und wo liegen die bindenden technischen
Details?**

## Entscheidung

Betankungen fuehrt einen klar getrennten Documentation-Entry-Layer ein:

- `README.md` ist der kurze oeffentliche Repo-Einstieg in Englisch
- `docs/README_EN.md` ist der englische Einstieg in die detailliertere
  Repository-Doku
- `docs/README.md` ist der ausfuehrlichere deutsche Haupt-Einstieg
- das GitHub-Wiki bzw. `docs/wiki/` ist eine kuratierte, leichtere
  Public-Entry-Layer
- `docs/STATUS.md` haelt den bindenden aktuellen Projekt-, Gate- und
  Roadmap-Stand
- `docs/CHANGELOG.md` und `docs/SPRINTS.md` dienen der Traceability, nicht als
  primaere Startseiten

Die technische Source of Truth bleibt im Repository unter `docs/`.

## Leitplanken

- Einstiegsschichten duplizieren keine tiefe technische Detaildoku.
- Der aktuelle Hold-/Roadmap-Status muss ueber README, Doku-Einstiege, Wiki
  und `docs/STATUS.md` semantisch konsistent bleiben.
- Publizierter Wiki-Einstieg und versionierte Wiki-Quelle duerfen parallel
  verlinkt werden, aber die bindende Detailbasis verbleibt in `docs/`.
- Redaktionelle oder persoenliche Nebeninhalte bleiben sichtbar, aber
  ausserhalb des technischen Kernstartpfads.

## Nicht-Ziele

- keine Volluebersetzung der gesamten Repo-Doku vor `1.0.0` oder danach
- keine Verlagerung der technischen Source of Truth aus dem Repository
- keine grosse Design- oder Content-Neuordnung ausserhalb der klaren
  Rollenabgrenzung

## Konsequenzen

- Externe Leser finden schneller einen passenden Einstieg.
- Maintainer koennen Hold-, Release- und Scope-Aussagen konsistent pflegen.
- Das Wiki bleibt bewusst Einstiegsschicht und wird nicht zur konkurrierenden
  technischen Hauptdokumentation.

## Referenzen

- `README.md`
- `docs/README_EN.md`
- `docs/README.md`
- `docs/wiki/Home.md`
- `docs/STATUS.md`
- `docs/backlog/BL-0026-transition-hold-entry-doc-sync/item.md`
- `docs/backlog/BL-0027-wiki-entry-layer-public-alignment/item.md`
