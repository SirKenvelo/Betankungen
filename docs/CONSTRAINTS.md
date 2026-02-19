# WAS WIR NICHT TUN – Projekt „Betankungen“
**Stand:** 2026-02-07

Diese Liste definiert bewusst gesetzte Grenzen.
Alles hier ist **kein Bug**, sondern **Design-Entscheidung**.

---

## Architektur & Struktur

- Keine Fachlogik im `.lpr`
  - `.lpr` ist **reiner Orchestrator**
  - keine SQLs, keine Berechnungen, keine UI-Logik

- Keine „God-Units“
  - Jede Unit hat **eine klar abgegrenzte Verantwortung**
  - keine Sammel-Helper ohne Domainbezug

- Kein vorschnelles „Refactor Everything™“
  - Umbauten nur, wenn sie:
    - Komplexität **reduzieren**
    - oder neue Features **ermöglichen**

---

## CLI & UX

- Keine stillschweigenden Annahmen
  - Jeder Befehl ist explizit
  - Fehler führen zu klarer Fehlermeldung + Usage

- Kein Mischmasch aus Flags & impliziten Zuständen
  - alles geht über `TCommand`
  - keine globalen „Sonderfälle“

- Kein „magisches Verhalten“
  - `--seed` überschreibt **nie** ohne `--force`
  - Demo-DB ist **immer** getrennt von produktiver DB

---

## Domain-Regeln

- Keine Manipulation von `fuelups`
  - kein edit
  - kein delete
  - Tankvorgänge sind **historisch unveränderlich**

- Keine stillen Korrekturen von Benutzerdaten
  - Parsing ist strikt
  - Fehler werden früh abgefangen

- Keine Gleitkomma-Arithmetik für Geld / Volumen
  - ausschließlich Fixed-Point (`Int64`)
  - Cent / ml / milli-EUR

---

## Logging & Debugging

- Kein `WriteLn` in Fachlogik
  - Logging läuft **zentral** über `u_log`

- Kein unkontrolliertes Debug-Spamming
  - `[DBG]` nur bei `--debug`
  - keine Debug-Ausgaben im Normalbetrieb

- `--quiet` bedeutet wirklich **quiet**
  - keine Meta-Tabelle
  - keine Debug-Ausgaben
  - nur fachliches Ergebnis

---

## Feature-Umfang

- Keine GUI
  - bewusstes CLI-Projekt

- Keine Web-API
  - kein HTTP
  - kein REST
  - kein JSON-over-HTTP

- Kein Overengineering
  - keine ORM
  - keine DI-Container
  - keine Pattern nur „weil man sie kennt“

---

## Entwicklung & Prozess

- Keine Features ohne klare Motivation
  - jede neue Funktion beantwortet:
    - *Welches Problem löst sie?*

- Kein Perfektionismus in frühen Phasen
  - Polishing kommt **später**
  - zuerst korrekt, dann schön

- Kein Selbstzweifel-getriebener Umbau
  - funktionierender Code ist **wertvoll**
  - Iteration schlägt Neu-Anfang

---

## Grundhaltung

- Wir bauen kein Spielzeug
- Wir bauen keine Wegwerf-Software
- Wir bauen nichts für „alle“

Wir bauen ein **robustes, lernorientiertes, ehrliches Werkzeug**
