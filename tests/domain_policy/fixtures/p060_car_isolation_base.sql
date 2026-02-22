-- p060_car_isolation_base.sql
-- UPDATED: 2026-02-22
-- Ziel: deterministischer 2-Car-Zustand fuer P-060-02 (Car-Isolation in Stats).

PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE TRANSACTION;

DELETE FROM fuelups;
DELETE FROM stations;
DELETE FROM cars;

INSERT INTO cars (id, name, odometer_start_km, odometer_start_date)
VALUES
  (1, 'Car-1', 10000, '2025-01-01'),
  (2, 'Car-2', 50000, '2025-01-01');

INSERT INTO stations (id, brand, street, house_no, zip, city, phone, owner)
VALUES (1, 'TestStation', 'Policyweg', '1', '10115', 'Berlin', '', '');

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
  '2025-01-01 08:00:00',
  10000,
  40000,
  6000,
  1500,
  1,
  0
),
(
  2,
  1,
  1,
  '2025-01-05 08:00:00',
  10050,
  10000,
  1500,
  1500,
  0,
  0
),
(
  3,
  1,
  1,
  '2025-01-10 08:00:00',
  10100,
  45000,
  7000,
  1550,
  1,
  1
),
(
  4,
  1,
  2,
  '2025-01-03 08:00:00',
  50000,
  30000,
  4500,
  1500,
  1,
  0
),
(
  5,
  1,
  2,
  '2025-01-12 08:00:00',
  50120,
  42000,
  6300,
  1500,
  1,
  0
);

COMMIT;
