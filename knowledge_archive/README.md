# knowledge_archive
**Stand:** 2026-03-31

Ziel: Historischen Archiv-Bestand lesbar erhalten, ohne den Mechanismus im
Repository weiter aktiv zu nutzen.

## Status
- `knowledge_archive/` ist deprecated und bleibt vorerst als Legacy-/
  Read-only-Bestand im Repository.
- Neue Archiv-Snippets werden repo-seitig nicht mehr verpflichtend erzeugt.
- Fuer fruehere Implementationsstaende ist die Git-Historie der primaere
  Rueckgriff.
- Keine produktive Nutzung direkt aus diesem Ordner.
- Historische Eintraege und Dateinamen bleiben unveraendert.

## Pflegeleitplanke
- Bestehendes Inventar bleibt read-only, sofern kein separater
  Aufraeum-/Migrationsentscheid getroffen wird.
- Eine spaetere vollstaendige Herausloesung aus dem Repository ist als
  optionaler Folgeschritt moeglich, aber nicht Teil dieser Stilllegung.
- Falls kuenftig ein lokaler Ersatzpfad noetig wird, sollte er bewusst
  ausserhalb des getrackten Repo-Bestands eingefuehrt werden.

## Historischer Mechanismus (nicht mehr aktiv)
### Pflicht-Doku pro Archiv-Datei
- Quelle (Dateipfad)
- Symbol/Topic
- Anlass (`loeschung` oder `behavior change`)
- Datum
- Commit (Hash; falls historisch nicht bekannt: `n/a (historisch)`)

### Namenskonvention
- Neu: `archive_<symbol_or_topic>_<YYYY-MM-DD>.<ext>`
- Bestand: Historische Dateien ohne Datum im Namen bleiben gueltig, werden nicht rueckwirkend umbenannt.

### Header-Template fuer Archiv-Dateien
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
- Commit: `25b6080`

11. `archive_cost_stats_pre_maintenance_source_2026-03-14.pas`
- Quelle: `units/u_stats.pas`
- Symbol/Topic: `CollectCostStats`, `RenderCostStatsJson`, `ShowCostStats`, `ShowCostStatsJson` (Vor-S11C1/4 Stand)
- Anlass: behavior change (expliziter Integrationspfad `--maintenance-source` im Cost-Flow)
- Datum: `2026-03-14`
- Commit: `47dcee8`

12. `archive_cli_validate_pre_maintenance_source_policy_2026-03-14.pas`
- Quelle: `units/u_cli_validate.pas`
- Symbol/Topic: `ValidateCommand` (Vor-S11C1/4 Stand ohne `ValidateMaintenanceSourcePolicy`)
- Anlass: behavior change (neue Kontext-Policy fuer `--maintenance-source`)
- Datum: `2026-03-14`
- Commit: `47dcee8`

13. `archive_cost_stats_pre_module_activation_2026-03-14.pas`
- Quelle: `units/u_stats.pas`
- Symbol/Topic: `CollectCostStats`, `ShowCostStats` (Vor-S11C2/4 Stand mit module Hard-Error)
- Anlass: behavior change (Aktivierung der Cost-Integration fuer `--maintenance-source module` inkl. Fallback-Metadaten)
- Datum: `2026-03-14`
- Commit: `274111c`

14. `archive_core_cost_dispatch_pre_module_activation_2026-03-14.pas`
- Quelle: `src/Betankungen.lpr`
- Symbol/Topic: Cost-Dispatch-Guard im Orchestrator (Vor-S11C2/4)
- Anlass: behavior change (Entfernung des fruehen Hard-Error-Guards; Integrationsentscheidung in Stats-Schicht verlagert)
- Datum: `2026-03-14`
- Commit: `274111c`
