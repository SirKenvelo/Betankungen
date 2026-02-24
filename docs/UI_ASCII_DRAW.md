# UI-Polishing & ASCII-Draw - Notizen fuer spaetere Releases

**Projekt:** Betankungen  
**Status:** Idee/Notiz (kein unmittelbares Roadmap-Commitment)  
**Stand:** 2026-02-24

Diese Datei haelt den Gedanken fest, wie wir die CLI-UI in einer spaeteren Version gezielt "auf ein Level" bringen - **ohne** GUI-Framework, **ohne** Web-Frontend, aber mit einer konsistenten, schoenen Terminal-Ausgabe.

---

## Warum das kein Overengineering ist

Betankungen ist CLI-first, aber CLI heisst nicht "haesslich".  
Eine saubere UI-Schicht ist eine **Evolution**, weil sie:

- Output vereinheitlicht (Tabellen, Stats, Warnungen, Kopfzeilen)
- zukuenftige Module beschleunigt ("UI-Huelle" ist sofort da)
- Testbarkeit verbessert (deterministische Renderer-Ausgaben)
- langfristig **Asset-/Module-Erweiterungen** abfedert

Wenn Statistiken wachsen, koennen ASCII/Unicode-Visuals richtig stark aussehen - aber nur, wenn wir dafuer eine stabile Renderer-Bibliothek haben.

---

## ASCII-Draw als Prototyping-Tool

**ASCII-Draw** nutzen wir als "UI-Sketchpad":

- Boxen/Frames schnell zeichnen
- Spaltenbreiten und Padding ausprobieren
- Verhalten bei langen Texten testen (Wrap/Truncate)
- Terminal-Breiten simulieren (80 / 100-120 / 160+)

ASCII-Draw ist **kein** fester Bestandteil des Projekts, sondern ein Werkzeug "on demand".

---

## Zielbild: eine kleine Renderer-Bibliothek

### Prinzipien

- **Single Source of Truth** fuer Layout/Box-Styles
- **Unicode Box Drawing** wenn moeglich (UTF-8-Terminals), sonst **ASCII-Fallback**
- Deterministisch: gleicher Input -> gleicher Output
- Keine Business-Logik im Renderer (SoC bleibt hart)

### Kern-APIs (Skizze)

- `DrawBox(Title, Lines[], Width, Style)`
- `DrawKeyValueBox(Pairs[], Width, Style)`
- `DrawTable(Headers[], Rows[][], Options)`
- `DrawStatusLine(Context...)`
- `TruncateOrWrap(Text, Width, Mode)`

Optional spaeter:

- "Input-Masks" (Prompt + Validierungsfeedback)
- Mini-Charts (ASCII Bars, Sparklines, Histos) - **nur** wenn klar definiert

---

## Styles und Fallbacks

### 1. Unicode (preferred)

- Box Drawing: `┌─┬┐`, `│`, `└─┴┘`
- Bessere Lesbarkeit, wirkt "modern"

### 2. ASCII (fallback)

- `+---+`
- `|   |`
- kompatibel mit "dummen" Terminals

Entscheidungskriterium (spaeter):

- `LANG/LC_ALL` + UTF-8
- optional `--ascii` / `--unicode` override

---

## Templates zum Prototypen (ASCII-Draw)

Wir pflegen 3 "UI-Layouts", um frueh Probleme zu sehen:

1. **Compact 80**  
   Minimal-Terminals, alles muss noch passen.
2. **Standard 100/120**  
   "Happy Path" (Standard-Dev/Alltag).
3. **Wide 160+**  
   Fuer sehr breite Layouts (z. B. Stats-Dashboards).

Jedes Template testet:

- kurze vs. lange Zeilen
- Zahlenkolonnen (Alignment)
- Warn-/Hinweisbloecke
- Kontext-Kopfzeile (Car/Zeitraum/DB)

---

## Moegliche "UI-Release"-Schiene (x.x.0-x.x.? spaeter)

Das ist eine grobe Skizze, keine Zusage:

### UI-0 (Foundation)

- Renderer-Unit/Library extrahieren
- Box/Line/Table-Primitives
- ASCII/Unicode-Fallback + Tests

### UI-1 (Unification)

- alle bestehenden Tabellen/Stats-Ausgaben auf neue Primitives umstellen
- Output-Formate (Text) konsistent machen (Headers, Footer, Spacing)

### UI-2 (Polish)

- optionale Mini-Charts
- klar definierte Warnboxen ("Honesty"-Prinzip sichtbar)
- "Context Banner" (z. B. `Car: X`, `Range: ...`)

---

## Schnittstellen zu bestehenden Prinzipien

- CLI bleibt Interface (Parsing/Validierung)
- Core bleibt Business-Logik
- Renderer bleibt rein "Darstellung"

Damit bleibt spaeter auch eine GUI/Web-Option offen, ohne Rewrite der Core-Logik.

---

## Notiz von CFO Cookie

"Wenn's huebsch aussieht, guck ich laenger hin. Dann krieg ich auch mehr Leckerlies."  
(...sie ist nicht falsch.)
