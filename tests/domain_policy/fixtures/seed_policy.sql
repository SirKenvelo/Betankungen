-- seed_policy.sql
-- UPDATED: 2026-02-20
-- Ziel: DB_POLICY fuer kleine, deterministische Domain-Policy-Cases.

PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE TRANSACTION;

DELETE FROM fuelups;
DELETE FROM stations;
DELETE FROM cars;

INSERT INTO cars(id, name, plate, note, odometer_start_km, odometer_start_date) VALUES
  (1, 'Hauptauto', 'B-POL-1', 'Default-Car fuer Policy-Cases', 99000, '2024-12-01'),
  (2, 'Testwagen-2', 'B-POL-2', 'Optionales Isolationsfahrzeug', 50000, '2025-01-01');

INSERT INTO stations(id, brand, street, house_no, zip, city, phone, owner) VALUES
  (1, 'Aral',  'Policystrasse', '1', '10115', 'Berlin',  '+49-30-1000', 'Aral'),
  (2, 'Shell', 'Policyallee',   '2', '20095', 'Hamburg', '+49-40-2000', 'Shell');

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
) VALUES
  (1, 1, 1, '2025-01-10 08:30:00', 100000, 42000, 73500, 1750, 1, 0, 'Super',  'Card', 'P1', 'policy-baseline-1'),
  (2, 2, 1, '2025-01-24 07:50:00', 100640, 39500, 67150, 1700, 1, 0, 'Super',  'Card', 'P3', 'policy-baseline-2'),
  (3, 1, 1, '2025-02-18 09:15:00', 101620, 151000, 249150, 1650, 1, 1, 'Diesel', 'Cash', 'P2', 'p012-gap-and-p022-consumption-warning');

COMMIT;
