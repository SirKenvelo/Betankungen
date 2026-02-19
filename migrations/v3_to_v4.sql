-- ============================================================
-- v3 -> v4: Rebuild fuelups (car_id + missed_previous)
--           + recreate indices + recreate trg_fuelups_set_updated_at
-- UPDATED: 2026-02-13
-- ============================================================

-- Safety: disable FK checks during table rebuild (SQLite canonical approach)
PRAGMA foreign_keys = OFF;

BEGIN IMMEDIATE TRANSACTION;

-- 1) Create new table (target schema)
CREATE TABLE IF NOT EXISTS fuelups_new (
  id                       INTEGER PRIMARY KEY,
  station_id               INTEGER NOT NULL,
  car_id                   INTEGER NOT NULL,

  fueled_at                TEXT    NOT NULL,
  odometer_km              INTEGER NOT NULL,
  liters_ml                INTEGER NOT NULL,
  total_cents              INTEGER NOT NULL,
  price_per_liter_milli_eur INTEGER NOT NULL,
  is_full_tank             INTEGER NOT NULL DEFAULT 0,

  -- Golden Information: user confirmed a missing previous fuel-up
  missed_previous          INTEGER NOT NULL DEFAULT 0,

  fuel_type                TEXT,
  payment_type             TEXT,
  pump_no                  TEXT,
  note                     TEXT,

  created_at               TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at               TEXT,

  FOREIGN KEY(station_id) REFERENCES stations(id) ON DELETE RESTRICT,
  FOREIGN KEY(car_id)     REFERENCES cars(id)     ON DELETE RESTRICT,

  CHECK (odometer_km > 0),
  CHECK (liters_ml > 0),
  CHECK (total_cents >= 0),
  CHECK (price_per_liter_milli_eur >= 0),
  CHECK (is_full_tank IN (0,1)),
  CHECK (missed_previous IN (0,1))
);

-- 2) Copy old data (default car_id=1, missed_previous=0)
INSERT INTO fuelups_new (
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
  note,
  created_at,
  updated_at
)
SELECT
  id,
  station_id,
  1 AS car_id,
  fueled_at,
  odometer_km,
  liters_ml,
  total_cents,
  price_per_liter_milli_eur,
  is_full_tank,
  0 AS missed_previous,
  fuel_type,
  payment_type,
  pump_no,
  note,
  created_at,
  updated_at
FROM fuelups;

-- 3) Drop old table (also drops its old indices + trigger bindings)
DROP TABLE fuelups;

-- 4) Rename new table into place
ALTER TABLE fuelups_new RENAME TO fuelups;

-- 5) Recreate indices (v4)
-- Old indices were:
--   idx_fuelups_fueled_at, idx_fuelups_odometer_km, idx_fuelups_station_id, idx_fuelups_unique
-- New indices should be car-scoped for stats + uniqueness.

CREATE INDEX IF NOT EXISTS idx_fuelups_station_id
ON fuelups(station_id);

CREATE INDEX IF NOT EXISTS idx_fuelups_car_fueled_at
ON fuelups(car_id, fueled_at);

CREATE INDEX IF NOT EXISTS idx_fuelups_car_odometer_km
ON fuelups(car_id, odometer_km);

CREATE UNIQUE INDEX IF NOT EXISTS idx_fuelups_unique
ON fuelups(car_id, station_id, fueled_at, odometer_km);

-- 6) Recreate trigger trg_fuelups_set_updated_at (v4)
CREATE TRIGGER IF NOT EXISTS trg_fuelups_set_updated_at
AFTER UPDATE ON fuelups
FOR EACH ROW
WHEN NEW.updated_at IS OLD.updated_at OR NEW.updated_at IS NULL
BEGIN
  UPDATE fuelups
  SET updated_at = datetime('now')
  WHERE id = NEW.id;
END;

COMMIT;

-- 7) Re-enable FK checks and validate
PRAGMA foreign_keys = ON;
PRAGMA foreign_key_check;
