#!/usr/bin/env bash
set -euo pipefail

# fuel_price_polling_run.sh
# CREATED: 2026-03-24
# UPDATED: 2026-03-24
# Minimaler Polling-Runner fuer externe Tankstellenpreis-Snapshots.

SCRIPT_NAME="$(basename "$0")"

PROVIDER=""
SNAPSHOT_FILE=""
REQUEST_SCOPE=""
FETCHED_AT_UTC=""
DATA_ROOT=""
SOURCE_URL=""
DRY_RUN=false

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Polling-/Historien-Baseline fuer externe Preis-Snapshots

Usage:
  $SCRIPT_NAME --provider tankerkoenig --snapshot-file FILE --scope NAME --fetched-at UTC [options]

Pflichtoptionen:
  --provider NAME       Providerkennung (aktuell: tankerkoenig)
  --snapshot-file FILE  Lokaler JSON-Snapshot eines Polling-Laufs
  --scope NAME          Scopekennung fuer Dateiname/DB (z. B. nearby-stations)
  --fetched-at UTC      UTC-Zeitpunkt im Format YYYY-MM-DDTHH:MM:SSZ

Optionen:
  --data-root DIR       Zielwurzel fuer Preis-Historie
                        (Default: XDG_DATA_HOME/Betankungen/fuel_price_history)
  --source-url TEXT     Ursprungsreferenz fuer den Snapshot
                        (Default: file://<snapshot-file>)
  -n, --dry-run         nur Zielpfade anzeigen, nichts schreiben
  -h, --help            Hilfe anzeigen

Beispiel:
  $SCRIPT_NAME \\
    --provider tankerkoenig \\
    --snapshot-file snapshot.json \\
    --scope nearby-stations \\
    --fetched-at 2026-03-24T18:30:00Z
EOF_USAGE
}

die() {
  printf '[FAIL] %s\n' "$*" >&2
  exit 1
}

info() {
  printf '[INFO] %s\n' "$*"
}

ok() {
  printf '[OK] %s\n' "$*"
}

default_data_root() {
  if [[ -n "${XDG_DATA_HOME:-}" ]]; then
    printf '%s/Betankungen/fuel_price_history\n' "$XDG_DATA_HOME"
  else
    printf '%s/.local/share/Betankungen/fuel_price_history\n' "$HOME"
  fi
}

canonical_file() {
  local raw="$1"
  local d b
  d="$(cd "$(dirname "$raw")" && pwd -P)" || return 1
  b="$(basename "$raw")"
  printf '%s/%s\n' "$d" "$b"
}

sanitize_scope() {
  local scope="$1"
  local sanitized
  sanitized="$(printf '%s' "$scope" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9._-' '-')"
  sanitized="${sanitized#-}"
  sanitized="${sanitized%-}"
  [[ -n "$sanitized" ]] || die "Scope laesst sich nicht in einen sicheren Dateinamen ueberfuehren: $scope"
  printf '%s\n' "$sanitized"
}

validate_timestamp() {
  python3 - <<'PY' "$1"
from datetime import datetime
import sys

datetime.strptime(sys.argv[1], "%Y-%m-%dT%H:%M:%SZ")
PY
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --provider)
      [[ $# -ge 2 ]] || die "Option --provider braucht einen Wert."
      PROVIDER="$2"
      shift 2
      ;;
    --snapshot-file)
      [[ $# -ge 2 ]] || die "Option --snapshot-file braucht eine Datei."
      SNAPSHOT_FILE="$2"
      shift 2
      ;;
    --scope)
      [[ $# -ge 2 ]] || die "Option --scope braucht einen Wert."
      REQUEST_SCOPE="$2"
      shift 2
      ;;
    --fetched-at)
      [[ $# -ge 2 ]] || die "Option --fetched-at braucht einen UTC-Zeitstempel."
      FETCHED_AT_UTC="$2"
      shift 2
      ;;
    --data-root)
      [[ $# -ge 2 ]] || die "Option --data-root braucht einen Pfad."
      DATA_ROOT="$2"
      shift 2
      ;;
    --source-url)
      [[ $# -ge 2 ]] || die "Option --source-url braucht einen Wert."
      SOURCE_URL="$2"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unbekannte Option: $1 (nutze --help)"
      ;;
  esac
done

[[ -n "$PROVIDER" ]] || die "--provider ist erforderlich."
[[ -n "$SNAPSHOT_FILE" ]] || die "--snapshot-file ist erforderlich."
[[ -n "$REQUEST_SCOPE" ]] || die "--scope ist erforderlich."
[[ -n "$FETCHED_AT_UTC" ]] || die "--fetched-at ist erforderlich."
[[ "$PROVIDER" == "tankerkoenig" ]] || die "Aktuell unterstuetzter Provider fuer 1.3.0: tankerkoenig"
[[ -f "$SNAPSHOT_FILE" ]] || die "Snapshot-Datei nicht gefunden: $SNAPSHOT_FILE"

validate_timestamp "$FETCHED_AT_UTC" || die "Ungueltiges Format fuer --fetched-at: $FETCHED_AT_UTC"

SNAPSHOT_FILE="$(canonical_file "$SNAPSHOT_FILE")"
DATA_ROOT="${DATA_ROOT:-$(default_data_root)}"
SAFE_SCOPE="$(sanitize_scope "$REQUEST_SCOPE")"
YEAR="${FETCHED_AT_UTC:0:4}"
MONTH="${FETCHED_AT_UTC:5:2}"
DAY="${FETCHED_AT_UTC:8:2}"
FILE_TS="${FETCHED_AT_UTC//:/-}"
RAW_DIR="$DATA_ROOT/raw/$PROVIDER/$YEAR/$MONTH/$DAY"
DB_DIR="$DATA_ROOT/db"
STATE_DIR="$DATA_ROOT/state"
RAW_PATH="$RAW_DIR/${PROVIDER}_${FILE_TS}_${SAFE_SCOPE}.json"
DB_PATH="$DB_DIR/fuel_price_history.db"
STATE_PATH="$STATE_DIR/${PROVIDER}_last_run.json"
SOURCE_URL="${SOURCE_URL:-file://$SNAPSHOT_FILE}"

if [[ -e "$RAW_PATH" ]]; then
  die "Raw-Snapshot existiert bereits: $RAW_PATH"
fi

if [[ "$DRY_RUN" == true ]]; then
  info "Dry-Run: keine Dateien werden geschrieben."
  info "provider=$PROVIDER"
  info "raw=$RAW_PATH"
  info "db=$DB_PATH"
  info "state=$STATE_PATH"
  exit 0
fi

mkdir -p "$RAW_DIR" "$DB_DIR" "$STATE_DIR"
cp "$SNAPSHOT_FILE" "$RAW_PATH"

if ! python3 - <<'PY' "$PROVIDER" "$RAW_PATH" "$DB_PATH" "$FETCHED_AT_UTC" "$REQUEST_SCOPE" "$SOURCE_URL" "$STATE_PATH"
import json
import pathlib
import sqlite3
import sys

provider, raw_path_s, db_path_s, fetched_at_utc, request_scope, source_url, state_path_s = sys.argv[1:8]
raw_path = pathlib.Path(raw_path_s)
db_path = pathlib.Path(db_path_s)
state_path = pathlib.Path(state_path_s)

payload = json.loads(raw_path.read_text(encoding="utf-8"))
if not isinstance(payload, dict):
    raise SystemExit("Snapshot muss ein JSON-Objekt sein")

stations = payload.get("stations")
if not isinstance(stations, list):
    raise SystemExit("Snapshot enthaelt kein gueltiges stations-Array")

rows = []
station_count = len(stations)
for idx, station in enumerate(stations):
    if not isinstance(station, dict):
        raise SystemExit(f"station[{idx}] ist kein Objekt")

    station_id = str(station.get("id", "")).strip()
    if not station_id:
        raise SystemExit(f"station[{idx}].id fehlt")

    station_name = station.get("name")
    station_brand = station.get("brand")
    street = station.get("street")
    house_no = station.get("houseNumber")
    postal_code = station.get("postCode")
    city = station.get("place")
    lat = station.get("lat")
    lon = station.get("lng")
    is_open = station.get("isOpen")

    for fuel_type in ("diesel", "e5", "e10"):
        price = station.get(fuel_type)
        if price is None:
            continue
        if not isinstance(price, (int, float)):
            raise SystemExit(f"station[{idx}].{fuel_type} ist nicht numerisch")
        if float(price) <= 0:
            continue

        rows.append(
            (
                provider,
                station_id,
                fetched_at_utc,
                fuel_type,
                int(round(float(price) * 1000)),
                "EUR",
                station_name,
                station_brand,
                street,
                house_no,
                str(postal_code) if postal_code is not None else None,
                city,
                lat,
                lon,
                1 if bool(is_open) else 0,
            )
        )

conn = sqlite3.connect(str(db_path))
try:
    conn.execute("PRAGMA foreign_keys = ON")
    conn.executescript(
        """
        CREATE TABLE IF NOT EXISTS provider_snapshots (
          id INTEGER PRIMARY KEY,
          provider TEXT NOT NULL,
          fetched_at_utc TEXT NOT NULL,
          request_scope TEXT NOT NULL,
          raw_path TEXT NOT NULL UNIQUE,
          source_url TEXT NOT NULL,
          http_status INTEGER,
          station_count INTEGER NOT NULL,
          ingest_status TEXT NOT NULL
        );

        CREATE UNIQUE INDEX IF NOT EXISTS uq_provider_snapshots_provider_run
          ON provider_snapshots(provider, fetched_at_utc, request_scope);

        CREATE TABLE IF NOT EXISTS station_price_history (
          id INTEGER PRIMARY KEY,
          provider_snapshot_id INTEGER NOT NULL,
          provider TEXT NOT NULL,
          provider_station_id TEXT NOT NULL,
          recorded_at_utc TEXT NOT NULL,
          fuel_type TEXT NOT NULL,
          price_eur_x1000 INTEGER NOT NULL,
          currency_code TEXT NOT NULL,
          station_name TEXT,
          station_brand TEXT,
          street TEXT,
          house_no TEXT,
          postal_code TEXT,
          city TEXT,
          lat REAL,
          lon REAL,
          is_open INTEGER,
          FOREIGN KEY(provider_snapshot_id) REFERENCES provider_snapshots(id)
        );

        CREATE INDEX IF NOT EXISTS idx_station_price_history_station_time
          ON station_price_history(provider, provider_station_id, recorded_at_utc);

        CREATE TABLE IF NOT EXISTS provider_state (
          provider TEXT PRIMARY KEY,
          last_success_at_utc TEXT,
          last_attempt_at_utc TEXT,
          last_error_code TEXT,
          last_error_summary TEXT,
          backoff_until_utc TEXT
        );
        """
    )

    with conn:
        cur = conn.execute(
            """
            INSERT INTO provider_snapshots (
              provider, fetched_at_utc, request_scope, raw_path, source_url,
              http_status, station_count, ingest_status
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                provider,
                fetched_at_utc,
                request_scope,
                str(raw_path),
                source_url,
                None,
                station_count,
                "ok",
            ),
        )
        snapshot_id = cur.lastrowid

        conn.executemany(
            """
            INSERT INTO station_price_history (
              provider_snapshot_id, provider, provider_station_id,
              recorded_at_utc, fuel_type, price_eur_x1000, currency_code,
              station_name, station_brand, street, house_no, postal_code,
              city, lat, lon, is_open
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            [
                (snapshot_id,) + row
                for row in rows
            ],
        )

        conn.execute(
            """
            INSERT INTO provider_state (
              provider, last_success_at_utc, last_attempt_at_utc,
              last_error_code, last_error_summary, backoff_until_utc
            )
            VALUES (?, ?, ?, NULL, NULL, NULL)
            ON CONFLICT(provider) DO UPDATE SET
              last_success_at_utc = excluded.last_success_at_utc,
              last_attempt_at_utc = excluded.last_attempt_at_utc,
              last_error_code = NULL,
              last_error_summary = NULL,
              backoff_until_utc = NULL
            """,
            (provider, fetched_at_utc, fetched_at_utc),
        )
finally:
    conn.close()

state_path.write_text(
    json.dumps(
        {
            "schema": "fuel_price_history_state_v1",
            "provider": provider,
            "last_success_at_utc": fetched_at_utc,
            "last_attempt_at_utc": fetched_at_utc,
            "request_scope": request_scope,
            "raw_path": str(raw_path),
            "db_path": str(db_path),
            "source_url": source_url,
            "station_count": station_count,
            "price_points_count": len(rows),
        },
        ensure_ascii=False,
        indent=2,
    )
    + "\n",
    encoding="utf-8",
)
PY
then
  rm -f "$RAW_PATH" "$STATE_PATH"
  die "Polling-Ingest fehlgeschlagen; keine unvollstaendige Historie behalten."
fi

ok "Fuel-price Polling-Run erfolgreich persistiert."
info "provider=$PROVIDER"
info "raw=$RAW_PATH"
info "db=$DB_PATH"
info "state=$STATE_PATH"
