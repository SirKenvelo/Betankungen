# Fuel Price History Fixtures
**Stand:** 2026-03-24

Diese Fixtures liefern reproduzierbare Snapshot-Beispiele fuer den getrennten
Preis-Historienpfad aus `BL-0018`.

- `tankerkoenig_valid_nearby_stations.json`
  - minimales gueltiges Fixture mit zwei Stationen und drei Kraftstoffpreisen
    pro Station.
- `tankerkoenig_invalid_missing_station_id.json`
  - bewusst ungueltiges Fixture; eine Station enthaelt keine `id` und muss vom
    Runner sauber abgewiesen werden.
