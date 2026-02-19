# Tests
**Stand:** 2026-02-18

## Smoke-Test
- Script: `tests/smoke_cli.sh`
- Zweck: schneller Plausibilitaetscheck fuer Ordnerstruktur, Release-/Backup-Skripte und CLI-Binary.
- Default-Lauf ohne Zusatzflags bleibt kurz (Basis-Smoke + Core-Guardrails).
- Enthaltene First-Run-Faelle:
  - Frischer Start ohne Config/DB -> stille Anlage von Config + DB.
  - Config vorhanden, DB fehlt -> stille Neuanlage der DB am konfigurierten Pfad.
  - Nicht schreibbarer Default-Pfad -> Prompt-Fallback mit Retry.
- Weitere CLI-Guardrails:
  - `--help` wird als Struktur-Stabilitaet geprueft (Keywords: `Commands`, `Stats options`, `Examples`, `--yearly`, `--dashboard`).
  - `--stats stations` muss im Fehlerfall `Fehler` + `Usage` + `Tipp` liefern.
  - `--stats fuelups --json --csv` muss als Kurzfehler im 3-Zeilen-Format laufen (kein Voll-Help).
  - `--show-config` funktioniert auch in frischer HOME-Umgebung.
  - `--reset-config` loescht nur die Config, nicht die DB-Datei.
  - `--reset-config` prueft optional den Fehlerpfad bei nicht loeschbarer Config (Skip, falls im System nicht reproduzierbar).
  - `--demo` ohne Seed liefert einen sauberen Fehler ohne interaktiven Prompt.
  - Fehlerhafter `--db`-Pfad bleibt non-interactive (kein Prompt-Fallback).
- Zusatzsuiten (optional):
  - `-m`: Monthly-Regression-Suite (Text/JSON compact+pretty, Zeitraum, Validierung, No-Data-Fall).
  - `-y`: Yearly-Regression-Suite (Text/JSON compact+pretty, Zeitraum, Validierungskonflikte, JSON-Struktur, No-Data-Fall).
  - `-a`: beide Zusatzsuiten (`-m` + `-y`).
- Steuerung:
  - Default ist **fail-fast** (Abbruch beim ersten Fehler).
  - `--keep-going` sammelt Fehler und liefert am Ende eine Gesamtsumme.
  - `-l` bzw. `--list` zeigt nur die geplanten Checks (keine Ausfuehrung).
- Ausgabe:
  - Prefixe sind farblich markiert (`[INFO]` gelb, `[OK]` gruen, `[FAIL]` rot; `[LIST]` cyan in `smoke_cli.sh`).

Ausfuehrung im Projektroot:
- `tests/smoke_cli.sh`
- `tests/smoke_cli.sh -m`
- `tests/smoke_cli.sh -y`
- `tests/smoke_cli.sh -a`
- `tests/smoke_cli.sh -a --keep-going`
- `tests/smoke_cli.sh -a -l`

## Finaler Smoke in sauberer HOME-Sandbox
- Script: `tests/smoke_clean_home.sh`
- Zweck: reproduzierbarer End-to-End-Lauf in isolierter HOME/XDG-Umgebung.
- Ausfuehrung:
  - `tests/smoke_clean_home.sh`
  - `tests/smoke_clean_home.sh -m|-y|-a`
  - `tests/smoke_clean_home.sh -a --keep-going`
  - `tests/smoke_clean_home.sh -a -l`
  - optional: `tests/smoke_clean_home.sh --keep-home` (Sandbox bleibt zur Analyse erhalten)
