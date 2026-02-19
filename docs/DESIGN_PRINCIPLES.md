# DESIGN-PRINZIPIEN – Projekt „Betankungen“
**Stand:** 2026-02-13

Diese Prinzipien beschreiben die bewusst gewählten Leitlinien
für Architektur, Code und Weiterentwicklung.

---

## 1. CLI-zuerst & Fokus
- Betankungen ist eine **Terminal-Anwendung**, kein GUI- oder Web-Projekt.
- Alle Funktionen sind über explizite CLI-Kommandos erreichbar.
- Jede CLI-Ausführung hat **genau eine Hauptaktion**.

---

## 2. Orchestrator statt God-Objekt
- Das Hauptprogramm (`.lpr`) koordiniert ausschließlich:
  - Parsing
  - Dispatch
  - Policy
- Fachlogik lebt ausschließlich in dedizierten Units.

---

## 3. Klare Verantwortlichkeiten
- Jede Unit hat **eine klar umrissene Aufgabe**.
- Anzeige, Eingabe und Geschäftslogik sind strikt getrennt (SoC).
- Keine Unit kennt CLI-Parsing oder globale Zustände außerhalb ihres Zwecks.

---

## 4. Daten sind historisch korrekt
- Tankvorgänge (`fuelups`) sind **append-only**.
- Einmal gespeicherte Daten werden nicht stillschweigend verändert.
- Statistiken basieren auf nachvollziehbaren, reproduzierbaren Regeln.

---

## 5. Präzision vor Bequemlichkeit
- Geld, Volumen und Preise werden ausschließlich als **Fixed-Point Integer**
  (Cent, ml, milli-EUR) verarbeitet.
- Keine Gleitkomma-Arithmetik in der Fachlogik.

---

## 6. Defensive Systemgrenzen
- Ungültige Eingaben werden **früh abgefangen**.
- Fehler werden klar benannt, nicht „korrigiert“.
- Transaktionen folgen strikt dem All-or-Nothing-Prinzip.

---

## 7. Transparente Debugbarkeit
- Fehlersuche ist **explizit aktivierbar**.
- Logging-Ebenen sind klar getrennt:
  - Debug (Meta)
  - Trace (Ablauf)
  - Detail (fachliche Ausgabe)
  - Quiet (nur Ergebnis)
- Kein verstecktes Logging.

---

## 8. Ausgabe- & Logging-Regel (Command-Result vs. Meta)
- Domain-Units dürfen **Command-Ergebnisse** direkt ausgeben
  (z. B. Listen, Statistiken, Exporte).
- Diese Ausgaben stellen das **primäre Ergebnis** eines explizit
  aufgerufenen CLI-Kommandos dar.
- Logging, Debug-, Trace- und Meta-Ausgaben sind **keine**
  Command-Ergebnisse und dürfen **nicht** per `WriteLn` in Domain-Units
  erfolgen.
- Solche Ausgaben laufen ausschließlich über die zentrale Logging-Schicht
  (`u_log`) oder werden im Orchestrator (`.lpr`) erzeugt.
- Faustregel:
  > Wenn ein Nutzer bei `--quiet` diese Ausgabe trotzdem erwartet,
  > ist `WriteLn` zulässig.
  > Andernfalls handelt es sich um Logging oder Meta-Information.
- Diese Regel erlaubt klare, lesbare Fachausgaben
  und stellt gleichzeitig sicher, dass `--debug`, `--detail`
  und `--quiet` konsistent funktionieren.

---

## 9. Output-Formate (Policy)
- CSV ist exklusiv: `--csv` nur bei `--stats fuelups` und ohne `--json`.
- Pretty ist JSON-only: `--pretty` nur zusammen mit `--json`.

---

## 10. Quiet Output Policy (`--quiet`)
Der Schalter `--quiet` reduziert die Ausgabe auf das **fachliche Ergebnis**
eines Kommandos, ohne dessen inhaltliche Aussage zu verfälschen.

### Grundsatz
- `--quiet` unterdrückt **Meta-, Debug-, Trace- und Begleittexte**.
- Das **Command-Ergebnis selbst** bleibt sichtbar.

### Erlaubt bei `--quiet` (Result-Output)
- Tabellen, Listen und Statistiken
- Aussagen über das Ergebnis, z. B.:
  - „Keine Daten gefunden.“
  - „0 Einträge.“
  - „Zyklen: 0 (keine gültigen Volltank-Zyklen)“
- Fehler, die die Ausführung verhindern (über `FailUsage`)

Diese Ausgaben sind Teil der fachlichen Aussage und werden vom Nutzer
auch bei `--quiet` erwartet.

### Nicht erlaubt bei `--quiet` (Meta/Noise)
- Erfolgsmeldungen wie „OK: …“
- Hinweise, Tipps oder Beispiele
- Debug- oder Trace-Ausgaben (`[DBG] …`, `[TRC] …`)
- Meta-Tabellen oder Konfigurationsübersichten

### Ziel
`--quiet` liefert eine **knappe, skriptfreundliche und dennoch
inhaltlich vollständige Ausgabe**, ohne zusätzliche Erläuterungen.

---

## 11. Reproduzierbarkeit
- Demo-Datenbank ist strikt getrennt von produktiven Daten.
- `--seed` erzeugt reproduzierbare Testzustände.
- Tests und Vorführungen sind jederzeit wiederholbar.

---

## 12. Evolution statt Big Bang
- Features wachsen inkrementell.
- Umbauten erfolgen nur, wenn sie:
  - Komplexität reduzieren oder
  - neue Funktionen ermöglichen.
- Polishing ist bewusst nachgelagert.

---

## 13. Dokumentation ist Teil des Systems
- Architektur- und Changelog-Dokumente sind **first-class artifacts**.
- Entscheidungen werden nachvollziehbar festgehalten (ADR-Gedanke).
- Dokumentation folgt der Realität – nicht umgekehrt.

---

## 14. Release-Transparenz
- Releases/Backups werden reproduzierbar archiviert.
- `scripts/kpr.sh` (kompatibel via Root-Wrapper `kpr.sh`) erzeugt `.releases/Betankungen_<version>.tar` (Punkte -> `_`) aus `docs`, `src`, `units`.
- Hash + Metadaten werden in `.releases/release_log.json` geführt.
- Snapshot-Backups werden in `.backup/YYYY-MM-DD_HHMM` mit zentralem Register `.backup/index.json` geführt.
