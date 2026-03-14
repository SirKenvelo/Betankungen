{
  ARCHIVE-SNIPPET
  -----------------------------------------------------------------------
  ORIGIN   : src/Betankungen.lpr
  CHANGED  : 2026-03-14
  REASON   : behavior change (S11C2/4 entfernt Hard-Error-Guard fuer module source)
  CONTEXT  : Vor S11C2 blockierte der Orchestrator den Modulpfad vor der Stats-Logik.
  CONTEXT  : Aktivierung des Integrationspfads wurde in die Cost-Stats-Schicht verlagert.
  BEISPIEL : tkCost-Dispatch mit fruehem FailUsage bei `msModule`.
  BEISPIEL : ShowCostStats/ShowCostStatsJson wurden erst nach Guard aufgerufen.
}

// Vor-S11C2 Stand (Auszug): frueher Orchestrator-Guard fuer module source.

      tkCost:
        case Cmd.Kind of
          ckStats:
            begin
              if Cmd.MaintenanceSource = msModule then
                FailUsage('Fehler: --maintenance-source module ist vorbereitet, aber noch nicht aktiv (S11C2/4).', efMaintenanceSource);

              if Cmd.Json then
                ShowCostStatsJson(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.CarId,
                  Cmd.MaintenanceSource,
                  Cmd.Pretty,
                  APP_VERSION)
              else
                ShowCostStats(DbPath,
                  Cmd.PeriodEnabled,
                  Cmd.PeriodFromIso,
                  Cmd.PeriodToExclIso,
                  Cmd.FromProvided,
                  Cmd.ToProvided,
                  Cmd.CarId,
                  Cmd.MaintenanceSource);
            end;
        else
          FailUsage('Interner Fehler: Ungültiges cost-Kommando.');
        end;
