-- p080_base.sql
-- UPDATED: 2026-03-21
-- Ziel: deterministischer Basiszustand fuer Stations-Plausibilitaet P-080..P-084.

PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE TRANSACTION;

DELETE FROM fuelups;
DELETE FROM stations;
DELETE FROM cars;

COMMIT;
