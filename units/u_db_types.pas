{
  u_db_types.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-02-27
  UPDATED: 2026-02-27
  AUTHOR : Christof Kempinski
  Zentrale DB-Kontext-Typen fuer Domain-Units.

  Verantwortlichkeiten:
  - Definiert den kanonischen DB-Kontext-Typ `TDB`.
  - Ermoeglicht schrittweise Entkopplung von rohen string-Pfaden in APIs.

  Hinweis:
  - Aktuell ist `TDB` ein Alias auf den SQLite-Dateipfad (`string`).
  ---------------------------------------------------------------------------
}
unit u_db_types;

{$mode objfpc}{$H+}

interface

type
  TDB = string;

implementation

end.
