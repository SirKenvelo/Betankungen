-- p060_base.sql
-- UPDATED: 2026-02-22
-- Ziel: deterministischer Basiszustand fuer P-060 (Stats ueberspringt Intervalle an missed_previous=1).

PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE TRANSACTION;

DELETE FROM fuelups;
DELETE FROM stations;
DELETE FROM cars;

INSERT INTO cars (id, name, odometer_start_km, odometer_start_date)
VALUES (1, 'TestCar', 10000, '2025-01-01');

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
  '2025-01-10 08:00:00',
  10100,
  40000,
  6000,
  1500,
  1,
  1
),
(
  3,
  1,
  1,
  '2025-01-20 08:00:00',
  10250,
  40000,
  6000,
  1500,
  1,
  0
);

COMMIT;
