# knowledge_archive
**Stand:** 2026-03-14

Ziel: Archiviert entfernte/ersetzte Implementationen zur Nachvollziehbarkeit.

## Regeln
- Bei Loeschung von Prozeduren/Funktionen: Original verpflichtend archivieren.
- Bei funktionalen Verhaltensaenderungen: Original ebenfalls archivieren.
- Keine produktive Nutzung direkt aus diesem Ordner.

## Pflicht-Doku pro Archiv-Datei
- Quelle (Dateipfad)
- Symbol/Topic
- Anlass (`loeschung` oder `behavior change`)
- Datum
- Commit (Hash; falls historisch nicht bekannt: `n/a (historisch)`)

## Namenskonvention
- Neu: `archive_<symbol_or_topic>_<YYYY-MM-DD>.<ext>`
- Bestand: Historische Dateien ohne Datum im Namen bleiben gueltig, werden nicht rueckwirkend umbenannt.

## Header-Template fuer Archiv-Dateien
```pascal
{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : <source-file>
  REMOVED  : <YYYY-MM-DD>               // oder CHANGED: <YYYY-MM-DD>
  REASON   : <kurzer Anlass>
  CONTEXT  : <fachlicher Kontext 1>
  CONTEXT  : <fachlicher Kontext 2>
  BEISPIEL : <kurzer Code-Ausschnitt 1>
  BEISPIEL : <kurzer Code-Ausschnitt 2>
}
```

## Inventar (Bestand)

1. `archive_ExactlyOne.pas`
- Quelle: `Betankungen.lpr`
- Symbol/Topic: `ExactlyOne`
- Anlass: loeschung (Umstellung auf internes Command-Modell)
- Datum: `2026-01-31`
- Commit: `n/a (historisch)`

2. `archive_ParseFlagWithArg.pas`
- Quelle: `Betankungen.lpr`
- Symbol/Topic: `ParseFlagWithArg`
- Anlass: loeschung (Umstellung auf internes Command-Modell / `BuildCommand`)
- Datum: `2026-01-31`
- Commit: `n/a (historisch)`

3. `archive_ParseRequiredValueFlag.pas`
- Quelle: `Betankungen.lpr`
- Symbol/Topic: `ParseRequiredValueFlag`
- Anlass: loeschung (Umstellung auf internes Command-Modell / `BuildCommand`)
- Datum: `2026-01-31`
- Commit: `n/a (historisch)`

4. `archive_TryParseFlag.pas`
- Quelle: `Betankungen.lpr`
- Symbol/Topic: `TryParseFlag`
- Anlass: loeschung (Umstellung auf internes Command-Modell / `BuildCommand`)
- Datum: `2026-01-31`
- Commit: `n/a (historisch)`

5. `archive_ParseEuroToCents.pas`
- Quelle: `u_db_common.pas`
- Symbol/Topic: `ParseEuroToCents`
- Anlass: loeschung (ersetzt durch stringbasiertes Parsing, bon-exakt)
- Datum: `2026-01-21`
- Commit: `n/a (historisch)`

6. `archive_ParseEurPerLiterToMilli.pas`
- Quelle: `u_db_common.pas`
- Symbol/Topic: `ParseEurPerLiterToMilli`
- Anlass: loeschung (ersetzt durch stringbasiertes Parsing, bon-exakt)
- Datum: `2026-01-21`
- Commit: `n/a (historisch)`

7. `archive_ParseLitersToMl.pas`
- Quelle: `u_db_common.pas`
- Symbol/Topic: `ParseLitersToMl`
- Anlass: loeschung (ersetzt durch stringbasiertes Parsing, bon-exakt)
- Datum: `2026-01-21`
- Commit: `n/a (historisch)`

8. `archive_ParseToMinorUnit.pas`
- Quelle: `u_db_common.pas`
- Symbol/Topic: `ParseToMinorUnit`
- Anlass: loeschung (ersetzt durch spezialisierte Parser)
- Datum: `2026-01-21`
- Commit: `n/a (historisch)`

9. `archive_maintenance_cli_parse_helpers_2026-03-14.pas`
- Quelle: `src/betankungen-maintenance.lpr`
- Symbol/Topic: `HasFlag`, `HasUnknownFlags`, `TryReadDbArg`
- Anlass: loeschung (ersetzt durch zentrales `ParseArgs`-Modell fuer S10C2/4)
- Datum: `2026-03-14`
- Commit: `aad05f8`

10. `archive_maintenance_pre_stats_cli_flow_2026-03-14.pas`
- Quelle: `src/betankungen-maintenance.lpr`
- Symbol/Topic: `RunListMaintenance`, `ParseArgs` (Vor-S10C3/4 Stand)
- Anlass: behavior change (Erweiterung um `--stats maintenance` inkl. JSON-/Pretty-Kontexten)
- Datum: `2026-03-14`
- Commit: `n/a (S10C3/4, Hash folgt via Traceability-Commit)`
