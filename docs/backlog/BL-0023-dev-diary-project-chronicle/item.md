---
id: BL-0023
title: Dev-Diary als kuratierte Projektchronik
status: done
priority: P3
type: improvement
tags: [docs, process, storytelling, community, 'lane:planned']
created: 2026-03-21
updated: 2026-03-24
related:
  - BL-0016
---
**Stand:** 2026-03-24

# Goal
Ein leichtgewichtiges Dev-Diary einfuehren, das wichtige Projektstationen,
Entscheidungen, Sackgassen und Lessons Learned in knapper, bewusst kuratierter
Form festhaelt.

# Motivation
Zwischen `docs/CHANGELOG.md`, `docs/SPRINTS.md` und der operativen
Projektdokumentation bleibt der persoenliche Entwicklungsfaden bislang eher
implizit. Ein kleines Dev-Diary kann den Projektcharakter sichtbarer machen,
Entscheidungen menschlich einordnen und spaeter als Quelle fuer Rueckblicke,
Wiki-Teaser oder Release-Erzaehlungen dienen.

# Scope
In Scope:
- definierter Ort und Rahmen fuer kurze Dev-Diary-Eintraege
- klare Leitplanken fuer Ton, Laenge und Themenwahl
- Fokus auf Projektverlauf, Erkenntnisse, Huerden und kleine Durchbrueche
- mindestens ein initialer Beispiel-Eintrag als Referenz fuer den Stil

Out of Scope:
- taegliche Pflichtpflege oder vollstaendiges Arbeitstagebuch
- Duplikation von `docs/CHANGELOG.md` oder `docs/SPRINTS.md`
- tiefe private Inhalte ohne direkten Projektbezug

# Risks
- Pflegeaufwand waechst schneller als der Nutzen.
- Unklare Trennung zu Changelog, Sprint-Narrative und technischer Doku.
- Ton driftet in zu private oder zu ausschweifende Richtung.

# Output
Ein klar umrissener, leicht wartbarer Doku-Baustein, der das Projekt um eine
kuratierte menschliche Chronik erweitert, ohne bestehende technische
Source-of-Truth-Dokumente zu ersetzen.

# Derived Tasks
- `TSK-0016` - Dev-Diary-Ort, Format und redaktionelle Leitplanken definieren. (done)
- `TSK-0017` - Initialen Dev-Diary-Eintrag und Doku-Navigation verankern. (done)
