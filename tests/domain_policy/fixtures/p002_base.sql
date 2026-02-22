-- p002_base.sql
-- UPDATED: 2026-02-22
-- Ziel: deterministischer Basiszustand fuer P-002 (car_id existiert nicht / FK).

PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE TRANSACTION;

DELETE FROM fuelups;
DELETE FROM stations;
DELETE FROM cars;

INSERT INTO cars (id, name, odometer_start_km, odometer_start_date)
VALUES (1, 'TestCar', 10000, '2025-01-01');

INSERT INTO stations (id, brand, street, house_no, zip, city, phone, owner)
VALUES (1, 'TestStation', 'Policyweg', '1', '10115', 'Berlin', '', '');

COMMIT;
