# BL-002 - Developer-Easter-Egg `--ndt`
**Stand:** 2026-03-09
**Status:** icebox
**Typ:** optionales Developer-Feature (humorvoll, intern)

## Ziel

Bei explizitem Aufruf eine zufaellige Entwickler-Nachricht ausgeben.

## Flag

- `--ndt` (Nachricht des Tages)

## Guardrails

- nur bei explizitem Aufruf aktiv
- keine Auswirkung auf normale CLI-Outputs
- kein Einfluss auf Skript-/Maschinen-Ausgaben
- keine unnoetige Kopplung mit i18n oder Domain-Logik

## Moegliche Datenquelle

- `data/dev_messages.b64` (entkoppelt, nur base64-kodierte Zeilen)
- Pflegehelfer: `scripts/dev_messages_encode.sh`

## Startbestand

- ist aus dem frueheren Sammel-Backlog nach `data/dev_messages.b64` ausgelagert (Spoiler-Schutz durch Obfuskation)

## Optionale Maintainer-Variante

- versteckter CLI-Befehl `--cookie`
- feste Ausgabe (kein Zufall):
  - `SEARCHING FOR DOGGO...`
  - `DOGGO FOUND AT: SOFA.LNK`
  - `STATUS: TAIL.PROPELLER = MAX_RPM`
- bleibt klar als Easter-Egg isoliert (kein Einfluss auf normale Flows)
