-- p061_cost_scope_base.sql
-- UPDATED: 2026-03-13
-- Ziel: deterministischer 2-Car-Zustand fuer P-061 (Cost-Scope Car+Period).

PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE TRANSACTION;

DELETE FROM fuelups;
DELETE FROM stations;
DELETE FROM cars;

INSERT INTO cars (id, name, odometer_start_km, odometer_start_date)
VALUES
  (1, 'Scope-Car-1', 10000, '2024-01-01'),
  (2, 'Scope-Car-2', 20000, '2024-01-01');

INSERT INTO stations (id, brand, street, house_no, zip, city, phone, owner)
VALUES (1, 'ScopeStation', 'Policyweg', '61', '10115', 'Berlin', '', '');

INSERT INTO fuelups (
  id,
  station_id,
  car_id,
  fueled_at,
  odometer_km,
  liters_ml,
  total_cents,
  price_per_liter_milli_eur,
  is_full_tank,
  missed_previous
) VALUES
(
  1,
  1,
  1,
  '2024-01-05 08:00:00',
  10000,
  40000,
  8000,
  2000,
  1,
  0
),
(
  2,
  1,
  1,
  '2024-02-05 08:00:00',
  10500,
  41000,
  8200,
  2000,
  1,
  0
),
(
  3,
  1,
  2,
  '2024-01-15 08:00:00',
  20000,
  30000,
  6000,
  2000,
  1,
  0
),
(
  4,
  1,
  2,
  '2024-02-15 08:00:00',
  20500,
  31000,
  6200,
  2000,
  1,
  0
);

COMMIT;
