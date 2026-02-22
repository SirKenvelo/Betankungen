-- seed_big.sql
-- UPDATED: 2026-02-22
-- Ziel: DB_BIG fuer Output-/Performance-/Dashboard-Tests (~500 Fuelups).

PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE TRANSACTION;

DELETE FROM fuelups;
DELETE FROM stations;
DELETE FROM cars;

INSERT INTO cars(id, name, plate, note, odometer_start_km, odometer_start_date) VALUES
  (1, 'Hauptauto', 'B-HAUPT-1', 'Default-Car fuer BIG-DB', 120000, '2020-01-01'),
  (2, 'Zweitwagen', 'B-ZWEI-2', 'Optionales Isolationsfahrzeug', 80000, '2021-01-01');

INSERT INTO stations(id, brand, street, house_no, zip, city, phone, owner) VALUES
  (1, 'Aral',   'Hauptstrasse',   '1',  '10115', 'Berlin',    '+49-30-0001', 'Aral'),
  (2, 'Shell',  'Industrieweg',   '7',  '20095', 'Hamburg',   '+49-40-0002', 'Shell'),
  (3, 'Total',  'Ringallee',      '12', '50667', 'Koeln',     '+49-221-0003', 'Total'),
  (4, 'Esso',   'Bahnstrasse',    '4',  '60311', 'Frankfurt', '+49-69-0004', 'Esso'),
  (5, 'Jet',    'Nordring',       '88', '70173', 'Stuttgart', '+49-711-0005', 'Jet'),
  (6, 'OMV',    'Suedufer',       '5',  '01067', 'Dresden',   '+49-351-0006', 'OMV'),
  (7, 'Q1',     'Wiesenweg',      '19', '28195', 'Bremen',    '+49-421-0007', 'Q1'),
  (8, 'HEM',    'Hafenstrasse',   '31', '24103', 'Kiel',      '+49-431-0008', 'HEM');

WITH RECURSIVE seq(n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < 500
),
rows AS (
  SELECT
    n,
    ((n - 1) % 8) + 1 AS station_id,
    CASE WHEN (n % 17) = 0 THEN 2 ELSE 1 END AS car_id,
    datetime(
      '2021-01-01 06:00:00',
      printf('+%d days', (n - 1) * 3),
      printf('+%d minutes', (n * 11) % 240)
    ) AS fueled_at,
    CASE
      WHEN (n % 17) = 0 THEN 80000 + (n * 47)
      ELSE 120000 + (n * 53)
    END AS odometer_km,
    32000 + ((n % 23) * 900) AS liters_ml,
    1589 + ((n % 11) * 17) AS price_milli,
    CASE WHEN (n % 3) = 0 THEN 1 ELSE 0 END AS is_full_tank,
    CASE WHEN (n % 97) = 0 THEN 1 ELSE 0 END AS missed_previous
  FROM seq
)
INSERT INTO fuelups(
  id,
  station_id,
  car_id,
  fueled_at,
  odometer_km,
  liters_ml,
  total_cents,
  price_per_liter_milli_eur,
  is_full_tank,
  missed_previous,
  fuel_type,
  payment_type,
  pump_no,
  note
)
SELECT
  n AS id,
  station_id,
  car_id,
  fueled_at,
  odometer_km,
  liters_ml,
  CAST((liters_ml * price_milli) / 1000 AS INTEGER) AS total_cents,
  price_milli,
  is_full_tank,
  missed_previous,
  CASE WHEN (n % 2) = 0 THEN 'Diesel' ELSE 'Super' END AS fuel_type,
  CASE WHEN (n % 5) = 0 THEN 'Card' ELSE 'Cash' END AS payment_type,
  printf('P%d', ((n - 1) % 6) + 1) AS pump_no,
  printf('big-seed-%03d', n) AS note
FROM rows
ORDER BY n;

COMMIT;
