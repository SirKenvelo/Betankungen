#!/usr/bin/env bash
set -euo pipefail

# smoke_cli.sh
# UPDATED: 2026-04-08
# Leichtgewichtiger Smoke-Test fuer Struktur + Kernkommandos.
# Erweitert um First-Run-/Bootstrap-Faelle und robuste CLI-Guardrails (0.5.4).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
FAILS=0
TMP_DIRS=()
RUN_MONTHLY_SUITE=false
RUN_YEARLY_SUITE=false
RUN_CARS_SUITE=false
RUN_MIGRATIONS_SUITE=false
RUN_MODULES_SUITE=false
LIST_ONLY=false
KEEP_GOING=false

usage() {
  cat <<'EOF_USAGE'
smoke_cli.sh - Basis-Smoke + optionale Stats-Zusatzsuiten

Usage:
  tests/smoke/smoke_cli.sh [-m] [-y] [-c] [--migrations] [--modules] [-a] [-l] [--keep-going] [-h]

Optionen:
  -m    Monthly-Zusatzsuite ausfuehren
  -y    Yearly-Zusatzsuite ausfuehren
  -c    Cars-Zusatzsuite ausfuehren
  --migrations
        Migrations-Zusatzsuite ausfuehren
  --modules
        Modul-Contract-Smoke fuer Companion-Binaries ausfuehren
  -a    Beide Zusatzsuiten ausfuehren (-m + -y)
  -l, --list
        Nur Testliste ausgeben (Dry-List, keine Ausfuehrung)
  --keep-going
        Nicht fail-fast; alle Fehler sammeln und am Ende zusammenfassen
  -h    Hilfe anzeigen
EOF_USAGE
}

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_YELLOW=$'\033[33m'
  C_CYAN=$'\033[36m'
  exec > >(
    while IFS= read -r line; do
      case "$line" in
        "[OK]"*)
          printf '%b[OK]%b%s\n' "$C_GREEN" "$C_RESET" "${line#\[OK\]}"
          ;;
        "[FAIL]"*)
          printf '%b[FAIL]%b%s\n' "$C_RED" "$C_RESET" "${line#\[FAIL\]}"
          ;;
        "[INFO]"*)
          printf '%b[INFO]%b%s\n' "$C_YELLOW" "$C_RESET" "${line#\[INFO\]}"
          ;;
        "[LIST]"*)
          printf '%b[LIST]%b%s\n' "$C_CYAN" "$C_RESET" "${line#\[LIST\]}"
          ;;
        *)
          printf '%s\n' "$line"
          ;;
      esac
    done
  )
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m)
      RUN_MONTHLY_SUITE=true
      shift
      ;;
    -y)
      RUN_YEARLY_SUITE=true
      shift
      ;;
    -a)
      RUN_MONTHLY_SUITE=true
      RUN_YEARLY_SUITE=true
      shift
      ;;
    -c|--cars)
      RUN_CARS_SUITE=true
      shift
      ;;
    --migrations)
      RUN_MIGRATIONS_SUITE=true
      shift
      ;;
    --modules)
      RUN_MODULES_SUITE=true
      shift
      ;;
    -l|--list)
      LIST_ONLY=true
      shift
      ;;
    --keep-going)
      KEEP_GOING=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Fehler: Unbekannte Option: %s\n' "$1" >&2
      usage
      exit 1
      ;;
  esac
done

add_fail() {
  FAILS=$((FAILS + 1))
  if ! $KEEP_GOING; then
    printf '[INFO] Fail-Fast aktiv: Abbruch nach erstem Fehler.\n'
    printf 'Smoke-Test beendet mit %d Fehler(n).\n' "$FAILS"
    exit 1
  fi
}

json_has_export_meta_v1() {
  local file="$1"
  grep -Eq '"contract_version"[[:space:]]*:[[:space:]]*1([[:space:]]*[,}])' "$file" &&
  grep -Eq '"generated_at"[[:space:]]*:[[:space:]]*"' "$file" &&
  grep -Eq '"app_version"[[:space:]]*:[[:space:]]*"' "$file"
}

print_plan() {
  printf '[INFO] List-Mode aktiv: folgende Checks wuerden laufen.\n'
  printf '[LIST] Pfad vorhanden: docs\n'
  printf '[LIST] Pfad vorhanden: src\n'
  printf '[LIST] Pfad vorhanden: units\n'
  printf '[LIST] Pfad vorhanden: scripts\n'
  printf '[LIST] Pfad vorhanden: tests/domain_policy\n'
  printf '[LIST] Pfad vorhanden: tests/regression\n'
  printf '[LIST] Pfad vorhanden: tests/smoke\n'
  printf '[LIST] Pfad vorhanden: knowledge_archive\n'
  printf '[LIST] Pfad vorhanden: .releases\n'
  printf '[LIST] Pfad vorhanden: .backup\n'
  printf '[LIST] kpr dry-run\n'
  printf '[LIST] backup_snapshot dry-run\n'
  printf '[LIST] btkgit --help\n'
  printf '[LIST] btkgit ready --skip-verify\n'
  printf '[LIST] btkgit preflight default -- --help\n'
  printf '[LIST] btkgit sync ohne origin -> klarer Fehlerpfad\n'
  printf '[LIST] btkgit sync ohne Upstream -> Branch-Hinweis\n'
  printf '[LIST] btkgit cleanup behaelt Branch standardmaessig\n'
  printf '[LIST] btkgit cleanup --delete-local loescht Branch nur explizit\n'
  printf '[LIST] Test-DB Build: Betankungen_Big.db + Betankungen_Policy.db\n'
  printf '[LIST] Betankungen --version\n'
  printf '[LIST] Betankungen --help\n'
  printf '[LIST] --help enthaelt Struktur-Keywords (Commands/Stats options/Examples/--yearly/--dashboard)\n'
  printf '[LIST] --help enthaelt Odometer-Guidance fuer --add fuelups\n'
  printf '[LIST] --help enthaelt Receipt-Link-Guidance (Option, append-only, file://-Normalisierung)\n'
  printf '[LIST] --list fuelups --detail nutzt den Referenzscreen fuer Fuelup-Details\n'
  printf '[LIST] --receipt-link ausserhalb --add fuelups -> Validierungsfehler\n'
  printf '[LIST] --stats stations -> Fehler + Kurz-Usage + Tipp\n'
  printf '[LIST] --stats fuelups --json --csv -> Fehler im 3-Zeilen-Format ohne Voll-Help\n'
  printf '[LIST] --stats fleet -> MVP-Textausgabe\n'
  printf '[LIST] --stats fleet --json -> JSON compact + Export-Meta\n'
  printf '[LIST] --stats fleet --json --pretty -> JSON pretty + Export-Meta\n'
  printf '[LIST] --stats cost -> MVP-Textausgabe (fuel-basiert)\n'
  printf '[LIST] --stats cost --json -> JSON compact + Export-Meta\n'
  printf '[LIST] --stats cost --json --pretty -> JSON pretty + Export-Meta\n'
  printf '[LIST] --stats cost --json scope -> Contract-Felder + Werte\n'
  printf '[LIST] --stats cost --maintenance-source none -> expliziter Integrationsmodus\n'
  printf '[LIST] --maintenance-source ausserhalb cost -> Validierungsfehler\n'
  printf '[LIST] --stats cost --maintenance-source module -> robuster Fallback ohne Companion-Binary\n'
  printf '[LIST] --stats cost --csv -> Validierungsfehler\n'
  printf '[LIST] --stats cost --monthly/--yearly/--dashboard -> Validierungsfehler\n'
  printf '[LIST] --stats cost --from ... -> Period-Scope wirkt auf Aggregation\n'
  printf '[LIST] --stats cost --car-id ... -> Car-Scope wirkt auf Aggregation\n'
  printf '[LIST] --stats fleet --csv -> Validierungsfehler\n'
  printf '[LIST] --stats fleet --monthly/--yearly/--dashboard -> Validierungsfehler\n'
  printf '[LIST] --stats fleet --from ... -> Validierungsfehler\n'
  printf '[LIST] First-Run: sichtbare Guidance (config+db+next-step)\n'
  printf '[LIST] Config vorhanden, DB fehlt: DB-Anlage + Guidance ohne Prompt\n'
  printf '[LIST] Default nicht schreibbar: Prompt-Fallback + Retry erfolgreich\n'
  printf '[LIST] --show-config in frischer HOME-Umgebung\n'
  printf '[LIST] --reset-config loescht nur Config, nicht die DB\n'
  printf '[LIST] --reset-config Fehlerpfad: Config nicht loeschbar (falls simulierbar)\n'
  printf '[LIST] --demo ohne Seed: sauberer Fehler ohne Prompt\n'
  printf '[LIST] --seed -> --demo --list stations: Demo-DB konsistent nutzbar\n'
  printf '[LIST] --add fuelups bei leerer DB + EOF: sauberer Fehler ohne Prompt-Schleife\n'
  printf '[LIST] --db Fehlerpfad bleibt non-interactive (kein Prompt)\n'
  printf '[LIST] Unit-Tests: tests/domain_policy/run_domain_policy_tests.sh\n'

  if $RUN_MONTHLY_SUITE; then
    printf '[LIST] (Monthly) --demo --stats fuelups --monthly\n'
    printf '[LIST] (Monthly) --demo --stats fuelups --json --monthly\n'
    printf '[LIST] (Monthly) JSON Export-Meta vorhanden (contract_version/generated_at/app_version)\n'
    printf '[LIST] (Monthly) --demo --stats fuelups --json --pretty --monthly\n'
    printf '[LIST] (Monthly) --demo --stats fuelups --from 2024-01 --to 2025-12 --monthly\n'
    printf '[LIST] (Monthly) --monthly ohne stats -> Fehler\n'
    printf '[LIST] (Monthly) --stats fuelups --pretty --monthly -> Fehler\n'
    printf '[LIST] (Monthly) leere DB + --stats fuelups --monthly\n'
  fi

  if $RUN_YEARLY_SUITE; then
    printf '[LIST] (Yearly) --demo --stats fuelups --yearly\n'
    printf '[LIST] (Yearly) --demo --stats fuelups --json --yearly\n'
    printf '[LIST] (Yearly) JSON Export-Meta vorhanden (contract_version/generated_at/app_version)\n'
    printf '[LIST] (Yearly) --demo --stats fuelups --json --pretty --yearly\n'
    printf '[LIST] (Yearly) --demo --stats fuelups --from 2022-01 --to 2024-01 --yearly\n'
    printf '[LIST] (Yearly) --yearly ohne stats -> Fehler\n'
    printf '[LIST] (Yearly) --stats fuelups --yearly --monthly -> Fehler\n'
    printf '[LIST] (Yearly) --stats fuelups --yearly --csv -> Fehler\n'
    printf '[LIST] (Yearly) --stats fuelups --yearly --dashboard -> Fehler\n'
    printf '[LIST] (Yearly) --stats fuelups --pretty --yearly -> Fehler\n'
    printf '[LIST] (Yearly) leere DB + --stats fuelups --yearly\n'
    printf '[LIST] (Yearly) --demo --stats fuelups --json --pretty --from 2023-01 --yearly\n'
  fi

  if $RUN_CARS_SUITE; then
    printf '[LIST] (Cars) tests/smoke_cars_crud.sh (Wrapper)\n'
    printf '[LIST] (Cars) tests/smoke_multi_car_context.sh (Wrapper)\n'
    printf '[LIST] (Cars) --add cars + --list cars\n'
    printf '[LIST] (Cars) Resolver-Matrix 0/1/>1 Cars fuer add/list/stats\n'
    printf '[LIST] (Cars) Cross-Car-Isolation fuer stats --car-id\n'
    printf '[LIST] (Cars) Guards fuer --edit/--delete cars (required/unknown/valid)\n'
    printf '[LIST] (Cars) --add fuelups ohne --car-id bei 1 Car -> OK\n'
    printf '[LIST] (Cars) --add fuelups ohne --car-id bei 2 Cars -> Hard Error\n'
    printf '[LIST] (Cars) --list fuelups ohne --car-id bei 1 Car -> OK\n'
    printf '[LIST] (Cars) --list fuelups ohne --car-id bei 2 Cars -> Hard Error\n'
    printf '[LIST] (Cars) --list fuelups --car-id <id> ist strikt car-scoped\n'
    printf '[LIST] (Cars) --stats fuelups ohne --car-id bei 1 Car -> OK\n'
    printf '[LIST] (Cars) --stats fuelups ohne --car-id bei 2 Cars -> Hard Error\n'
    printf '[LIST] (Cars) --stats fuelups --car-id <id> ist strikt car-scoped\n'
    printf '[LIST] (Cars) --edit cars ohne --car-id -> Fehler\n'
    printf '[LIST] (Cars) --delete cars ohne --car-id -> Fehler\n'
    printf '[LIST] (Cars) --edit cars --car-id 999 -> Fehler (unknown car)\n'
    printf '[LIST] (Cars) --delete cars --car-id 999 -> Fehler (unknown car)\n'
    printf '[LIST] (Cars) --delete cars mit fuelups -> geblockt\n'
  fi

  if $RUN_MIGRATIONS_SUITE; then
    printf '[LIST] (Migrations) tests/smoke_migrations.sh (Wrapper)\n'
    printf '[LIST] (Migrations) v4 -> v6 und v5 -> v6 per Flag (--all)\n'
    printf '[LIST] (Migrations) schema_version wird auf 6 angehoben\n'
    printf '[LIST] (Migrations) cars(vin/reg_doc_*) und stations(latitude_e6/longitude_e6/plus_code) vorhanden\n'
    printf '[LIST] (Migrations) Re-Run ist idempotent\n'
  fi

  if $RUN_MODULES_SUITE; then
    printf '[LIST] (Modules) tests/smoke_modules.sh (Wrapper)\n'
    printf '[LIST] (Modules) Companion-Binary Build: src/betankungen-maintenance.lpr\n'
    printf '[LIST] (Modules) --module-info compact liefert Pflichtfelder inkl. capabilities\n'
    printf '[LIST] (Modules) --module-info --pretty liefert Mehrzeilen-JSON\n'
    printf '[LIST] (Modules) --migrate initialisiert Modul-Schema (module_meta + maintenance_events)\n'
    printf '[LIST] (Modules) --migrate Re-Run bleibt idempotent (schema_version stabil)\n'
    printf '[LIST] (Modules) --add maintenance speichert Event-Datensaetze\n'
    printf '[LIST] (Modules) --list maintenance liefert all/scoped Ausgabe stabil\n'
    printf '[LIST] (Modules) --stats maintenance liefert Text + JSON(+pretty) + Scope-Contract\n'
    printf '[LIST] (Modules) Stats-Guardrails: --pretty ohne --json, --date/--cost-cents bei stats, --module-info --json\n'
    printf '[LIST] (Modules) unknown flag -> sauberer CLI-Fehlerpfad\n'
  fi

  printf '[INFO] Ende der Testliste.\n'
}

if $LIST_ONLY; then
  print_plan
  exit 0
fi

run_check() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf '[OK] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    add_fail
  fi
}

test_help_keywords_stable() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --help >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q 'Commands' "$out" &&
     grep -q 'Stats options' "$out" &&
     grep -q 'Examples' "$out" &&
     grep -q -- '--yearly' "$out" &&
     grep -q -- '--dashboard' "$out"; then
    printf '[OK] --help enthaelt Struktur-Keywords\n'
  else
    printf '[FAIL] --help enthaelt Struktur-Keywords\n'
    add_fail
  fi
}

test_help_mentions_receipt_link() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --help >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q -- '--receipt-link <path|uri>' "$out" &&
     grep -q 'fuelups bleiben append-only' "$out" &&
     grep -q 'Lokale absolute Receipt-Pfade werden vor dem Speichern auf einen kanonischen' "$out" &&
     grep -q 'file://-Wert normalisiert; fehlt die lokale Datei, folgt eine Warnung mit Confirm.' "$out"; then
    printf '[OK] --help enthaelt Receipt-Link-Guidance\n'
  else
    printf '[FAIL] --help enthaelt Receipt-Link-Guidance\n'
    add_fail
  fi
}

test_help_mentions_odometer_guidance() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --help >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q 'Bei --add fuelups ist der Kilometerstand immer der aktuelle Gesamt-Kilometerstand' "$out" &&
     grep -q 'nicht die Strecke seit der letzten Tankung' "$out"; then
    printf '[OK] --help enthaelt Odometer-Guidance fuer --add fuelups\n'
  else
    printf '[FAIL] --help enthaelt Odometer-Guidance fuer --add fuelups\n'
    add_fail
  fi
}

test_receipt_link_scope_guardrail_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --list fuelups --receipt-link file:///tmp/r.jpg >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q -- '--receipt-link ist nur zusammen mit "--add fuelups" erlaubt' "$err"; then
    printf '[OK] --receipt-link ausserhalb --add fuelups: Validierungsfehler\n'
  else
    printf '[FAIL] --receipt-link ausserhalb --add fuelups: Validierungsfehler\n'
    add_fail
  fi
}

test_fuelups_detail_reference_screen_ok() {
  local home db out err receipt_file rc

  home="$(register_tmp_dir)"
  db="$home/detail_reference.db"
  out="$home/out.txt"
  err="$home/err.txt"
  receipt_file="$home/detail-receipt.jpg"

  printf 'receipt fixture\n' >"$receipt_file"

  "$ROOT_DIR/bin/Betankungen" --db "$db" --list cars >/dev/null 2>&1 || {
    printf '[FAIL] --list fuelups --detail: Referenzscreen-Setup (Bootstrap)\n'
    add_fail
    return
  }

  printf 'DetailBrand\nDetailStreet\n1\n12345\nDetailCity\n\n\n\n\n\n' \
    | "$ROOT_DIR/bin/Betankungen" --db "$db" --add stations >/dev/null 2>&1 || {
      printf '[FAIL] --list fuelups --detail: Referenzscreen-Setup (Station)\n'
      add_fail
      return
    }

  printf '1\n2026-04-08 09:15:00\n1500\n55,00\n32,00\n1,718\ny\nDiesel\nCard\n7\nReference screen row\n' \
    | "$ROOT_DIR/bin/Betankungen" --db "$db" --add fuelups --receipt-link "$receipt_file" >/dev/null 2>&1 || {
      printf '[FAIL] --list fuelups --detail: Referenzscreen-Setup (Fuelup)\n'
      add_fail
      return
    }

  set +e
  "$ROOT_DIR/bin/Betankungen" --db "$db" --list fuelups --detail >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q 'Fuelups detail reference screen' "$out" &&
     grep -q 'Mode: --list fuelups --detail' "$out" &&
     grep -q 'Station: DetailBrand (DetailCity)' "$out" &&
     grep -q 'Car: Hauptauto' "$out" &&
     grep -q 'Receipt link: file://' "$out"; then
    printf '[OK] --list fuelups --detail nutzt den Referenzscreen\n'
  else
    printf '[FAIL] --list fuelups --detail nutzt den Referenzscreen\n'
    add_fail
  fi
}

test_stats_stations_fails_short_usage() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats stations >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] &&
     grep -q 'Fehler:' "$err" &&
     grep -q 'Usage:' "$out" &&
     grep -q 'Tipp:' "$err"; then
    printf '[OK] --stats stations: Fehler + Kurz-Usage + Tipp\n'
  else
    printf '[FAIL] --stats stations: Fehler + Kurz-Usage + Tipp\n'
    add_fail
  fi
}

test_stats_json_csv_fails_short_3line_no_full_help() {
  local home out err rc out_lines err_lines

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --json --csv >"$out" 2>"$err"
  rc=$?
  set -e

  out_lines="$(wc -l < "$out" | tr -d ' ')"
  err_lines="$(wc -l < "$err" | tr -d ' ')"

  if [[ $rc -ne 0 ]] &&
     [[ "${out_lines:-0}" -eq 1 ]] &&
     [[ "${err_lines:-0}" -eq 2 ]] &&
     grep -q 'Usage:' "$out" &&
     grep -q 'Fehler:' "$err" &&
     grep -q 'Tipp:' "$err" &&
     ! grep -q 'Commands:' "$out" &&
     ! grep -q 'Examples:' "$out" &&
     ! grep -q 'Commands:' "$err" &&
     ! grep -q 'Examples:' "$err"; then
    printf '[OK] --stats fuelups --json --csv: 3-Zeilen-Fehler ohne Voll-Help\n'
  else
    printf '[FAIL] --stats fuelups --json --csv: 3-Zeilen-Fehler ohne Voll-Help\n'
    add_fail
  fi
}

# Fleet-/Cost-Checks sind in dedizierte Helper ausgelagert.
SMOKE_HELPER_DIR="$ROOT_DIR/tests/smoke/helpers"
for helper in \
  "$SMOKE_HELPER_DIR/smoke_fleet_helpers.sh" \
  "$SMOKE_HELPER_DIR/smoke_cost_helpers.sh" \
  "$SMOKE_HELPER_DIR/smoke_bootstrap_helpers.sh"; do
  if [[ ! -f "$helper" ]]; then
    printf '[FAIL] Smoke-Helper fehlt: %s\n' "$helper"
    exit 1
  fi
  # shellcheck source=/dev/null
  source "$helper"
done

register_tmp_dir() {
  local d
  d="$(mktemp -d /tmp/betankungen_smoke_XXXXXX)"
  TMP_DIRS+=("$d")
  printf '%s\n' "$d"
}

setup_btkgit_fixture_repo() {
  local sandbox remote repo

  sandbox="$(register_tmp_dir)"
  remote="$sandbox/remote.git"
  repo="$sandbox/repo"

  git init --bare "$remote" >/dev/null 2>&1 || return 1
  git clone "$remote" "$repo" >/dev/null 2>&1 || return 1
  mkdir -p "$repo/scripts" || return 1
  cp "$ROOT_DIR/btkgit" "$repo/btkgit" || return 1
  cp "$ROOT_DIR/scripts/btkgit.sh" "$repo/scripts/btkgit.sh" || return 1
  chmod +x "$repo/btkgit" "$repo/scripts/btkgit.sh" || return 1

  git -C "$repo" config user.name 'Smoke Bot' || return 1
  git -C "$repo" config user.email 'smoke@example.invalid' || return 1

  printf 'fixture\n' >"$repo/README.md" || return 1
  git -C "$repo" add README.md btkgit scripts/btkgit.sh || return 1
  git -C "$repo" commit -m 'fixture init' >/dev/null 2>&1 || return 1
  git -C "$repo" branch -M main >/dev/null 2>&1 || return 1
  git -C "$repo" push -u origin main >/dev/null 2>&1 || return 1

  printf '%s\n' "$repo"
}

cleanup_tmp_dirs() {
  local d
  for d in "${TMP_DIRS[@]}"; do
    rm -rf "$d"
  done
}

# Bootstrap-/First-Run-Checks sind in smoke_bootstrap_helpers.sh ausgelagert.

test_btkgit_ready_skip_verify_ok() {
  local tmp out err rc

  tmp="$(register_tmp_dir)"
  out="$tmp/out.txt"
  err="$tmp/err.txt"

  set +e
  "$ROOT_DIR/btkgit" ready --skip-verify >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q 'make verify wurde via --skip-verify uebersprungen\.' "$out" &&
     grep -q '\[OK\] Readiness-Check abgeschlossen\.' "$out"; then
    printf '[OK] btkgit ready --skip-verify\n'
  else
    printf '[FAIL] btkgit ready --skip-verify\n'
    add_fail
  fi
}

test_btkgit_preflight_default_help_ok() {
  local tmp out err rc

  tmp="$(register_tmp_dir)"
  out="$tmp/out.txt"
  err="$tmp/err.txt"

  set +e
  "$ROOT_DIR/btkgit" preflight default -- --help >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q 'release_preflight.sh - 0.9.0 Readiness-Preflight ausfuehren' "$out" &&
     grep -q -- '--skip-verify' "$out"; then
    printf '[OK] btkgit preflight default -- --help\n'
  else
    printf '[FAIL] btkgit preflight default -- --help\n'
    add_fail
  fi
}

test_btkgit_sync_missing_origin_fails_cleanly() {
  local repo out err rc

  repo="$(setup_btkgit_fixture_repo)" || {
    printf '[FAIL] btkgit sync ohne origin: Fixture-Repo konnte nicht vorbereitet werden\n'
    add_fail
    return
  }

  git -C "$repo" remote remove origin >/dev/null 2>&1 || {
    printf '[FAIL] btkgit sync ohne origin: origin konnte nicht entfernt werden\n'
    add_fail
    return
  }
  git -C "$repo" checkout -b feature/no-origin >/dev/null 2>&1 || {
    printf '[FAIL] btkgit sync ohne origin: Feature-Branch konnte nicht erstellt werden\n'
    add_fail
    return
  }

  out="$repo/out.txt"
  err="$repo/err.txt"

  set +e
  (
    cd "$repo"
    ./btkgit sync
  ) >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q "Remote 'origin' fehlt" "$err"; then
    printf '[OK] btkgit sync ohne origin: klarer Fehlerpfad\n'
  else
    printf '[FAIL] btkgit sync ohne origin: klarer Fehlerpfad\n'
    add_fail
  fi
}

test_btkgit_sync_without_upstream_fails_cleanly() {
  local repo out err rc

  repo="$(setup_btkgit_fixture_repo)" || {
    printf '[FAIL] btkgit sync ohne Upstream: Fixture-Repo konnte nicht vorbereitet werden\n'
    add_fail
    return
  }

  git -C "$repo" checkout -b feature/no-upstream >/dev/null 2>&1 || {
    printf '[FAIL] btkgit sync ohne Upstream: Feature-Branch konnte nicht erstellt werden\n'
    add_fail
    return
  }

  out="$repo/out.txt"
  err="$repo/err.txt"

  set +e
  (
    cd "$repo"
    ./btkgit sync
  ) >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] &&
     grep -q "hat noch kein Upstream" "$err" &&
     grep -q "Session-Sync konnte nicht abgeschlossen werden" "$err"; then
    printf '[OK] btkgit sync ohne Upstream: Branch-Hinweis\n'
  else
    printf '[FAIL] btkgit sync ohne Upstream: Branch-Hinweis\n'
    add_fail
  fi
}

test_btkgit_cleanup_keeps_branch_by_default() {
  local repo out err rc current_branch branch_listing

  repo="$(setup_btkgit_fixture_repo)" || {
    printf '[FAIL] btkgit cleanup Default: Fixture-Repo konnte nicht vorbereitet werden\n'
    add_fail
    return
  }

  git -C "$repo" checkout -b feature/cleanup-keep >/dev/null 2>&1 || {
    printf '[FAIL] btkgit cleanup Default: Feature-Branch konnte nicht erstellt werden\n'
    add_fail
    return
  }

  out="$repo/out.txt"
  err="$repo/err.txt"

  set +e
  (
    cd "$repo"
    ./btkgit cleanup
  ) >"$out" 2>"$err"
  rc=$?
  set -e

  current_branch="$(git -C "$repo" branch --show-current)"
  branch_listing="$(git -C "$repo" branch --list 'feature/cleanup-keep')"

  if [[ $rc -eq 0 ]] &&
     [[ "$current_branch" == "main" ]] &&
     [[ -n "$branch_listing" ]] &&
     grep -q 'Kein lokales Branch-Delete angefordert' "$out"; then
    printf '[OK] btkgit cleanup behaelt Branch standardmaessig\n'
  else
    printf '[FAIL] btkgit cleanup behaelt Branch standardmaessig\n'
    add_fail
  fi
}

test_btkgit_cleanup_delete_local_ok() {
  local repo out err rc current_branch branch_listing

  repo="$(setup_btkgit_fixture_repo)" || {
    printf '[FAIL] btkgit cleanup --delete-local: Fixture-Repo konnte nicht vorbereitet werden\n'
    add_fail
    return
  }

  git -C "$repo" checkout -b feature/cleanup-delete >/dev/null 2>&1 || {
    printf '[FAIL] btkgit cleanup --delete-local: Feature-Branch konnte nicht erstellt werden\n'
    add_fail
    return
  }

  out="$repo/out.txt"
  err="$repo/err.txt"

  set +e
  (
    cd "$repo"
    ./btkgit cleanup --delete-local
  ) >"$out" 2>"$err"
  rc=$?
  set -e

  current_branch="$(git -C "$repo" branch --show-current)"
  branch_listing="$(git -C "$repo" branch --list 'feature/cleanup-delete')"

  if [[ $rc -eq 0 ]] &&
     [[ "$current_branch" == "main" ]] &&
     [[ -z "$branch_listing" ]] &&
     grep -q 'Cleanup abgeschlossen (lokaler Branch geloescht: feature/cleanup-delete)\.' "$out"; then
    printf '[OK] btkgit cleanup --delete-local loescht Branch explizit\n'
  else
    printf '[FAIL] btkgit cleanup --delete-local loescht Branch explizit\n'
    add_fail
  fi
}

prepare_seeded_demo_home() {
  local home
  home="$(register_tmp_dir)"

  if ! HOME="$home" "$ROOT_DIR/bin/Betankungen" --seed --force --seed-value 4242 >/dev/null 2>&1; then
    printf '[FAIL] Stats-Setup: --seed --force fehlgeschlagen\n'
    add_fail
  fi

  printf '%s\n' "$home"
}

test_monthly_text_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Monat' "$out"; then
    printf '[OK] Monthly Text: --demo --stats fuelups --monthly\n'
  else
    printf '[FAIL] Monthly Text: --demo --stats fuelups --monthly\n'
    add_fail
  fi
}

test_monthly_json_compact_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '"kind":"fuelups_monthly"' "$out" &&
     grep -q '"fuelups_total"' "$out" &&
     grep -q '"fuelups_full"' "$out" &&
     grep -q '"rows"' "$out" &&
     json_has_export_meta_v1 "$out"; then
    printf '[OK] Monthly JSON compact: Schluessel + Export-Meta vorhanden\n'
  else
    printf '[FAIL] Monthly JSON compact: Schluessel + Export-Meta vorhanden\n'
    add_fail
  fi
}

test_monthly_json_pretty_demo_ok() {
  local home out err rc line_count

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --pretty --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  line_count="$(wc -l < "$out" | tr -d ' ')"
  if [[ $rc -eq 0 ]] &&
     grep -q 'fuelups_monthly' "$out" &&
     json_has_export_meta_v1 "$out" &&
     [[ "$(head -n 1 "$out")" == "{" ]] &&
     [[ "${line_count:-0}" -gt 1 ]]; then
    printf '[OK] Monthly JSON pretty: Export-Meta + Pretty-Mehrzeilenformat\n'
  else
    printf '[FAIL] Monthly JSON pretty: Export-Meta + Pretty-Mehrzeilenformat\n'
    add_fail
  fi
}

test_monthly_period_text_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --from 2024-01 --to 2025-12 --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Monat' "$out"; then
    printf '[OK] Monthly + Zeitraum: Tabelle mit Monat-Spalte\n'
  else
    printf '[FAIL] Monthly + Zeitraum: Tabelle mit Monat-Spalte\n'
    add_fail
  fi
}

test_monthly_without_stats_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -Eq 'Kein Kommando|--monthly ist nur zusammen' "$err"; then
    printf '[OK] Monthly ohne stats: sauberer Validierungsfehler\n'
  else
    printf '[FAIL] Monthly ohne stats: sauberer Validierungsfehler\n'
    add_fail
  fi
}

test_monthly_pretty_without_json_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --pretty --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nur zusammen mit --json' "$err"; then
    printf '[OK] Monthly + Pretty ohne JSON: Validierungsfehler\n'
  else
    printf '[FAIL] Monthly + Pretty ohne JSON: Validierungsfehler\n'
    add_fail
  fi
}

test_monthly_empty_db_text_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -Eq 'Keine Tankvorgaenge|Keine Tankvorgänge' "$out"; then
    printf '[OK] Leere DB + Monthly: sauberer No-Data-Output\n'
  else
    printf '[FAIL] Leere DB + Monthly: sauberer No-Data-Output\n'
    add_fail
  fi
}

run_monthly_suite() {
  printf '[INFO] Zusatzsuite aktiv: Monthly (-m)\n'
  test_monthly_text_demo_ok
  test_monthly_json_compact_demo_ok
  test_monthly_json_pretty_demo_ok
  test_monthly_period_text_demo_ok
  test_monthly_without_stats_fails
  test_monthly_pretty_without_json_fails
  test_monthly_empty_db_text_ok
}

test_yearly_text_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Jahresuebersicht' "$out"; then
    printf '[OK] Yearly Text: --demo --stats fuelups --yearly\n'
  else
    printf '[FAIL] Yearly Text: --demo --stats fuelups --yearly\n'
    add_fail
  fi
}

test_yearly_json_compact_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q '"kind":"fuelups_yearly"' "$out" &&
     grep -q '"fuelups_total"' "$out" &&
     grep -q '"fuelups_full"' "$out" &&
     grep -q '"rows"' "$out" &&
     json_has_export_meta_v1 "$out"; then
    printf '[OK] Yearly JSON compact: Schluessel + Export-Meta vorhanden\n'
  else
    printf '[FAIL] Yearly JSON compact: Schluessel + Export-Meta vorhanden\n'
    add_fail
  fi
}

test_yearly_json_pretty_demo_ok() {
  local home out err rc line_count

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --pretty --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  line_count="$(wc -l < "$out" | tr -d ' ')"
  if [[ $rc -eq 0 ]] &&
     grep -q 'fuelups_yearly' "$out" &&
     json_has_export_meta_v1 "$out" &&
     [[ "$(head -n 1 "$out")" == "{" ]] &&
     [[ "${line_count:-0}" -gt 1 ]]; then
    printf '[OK] Yearly JSON pretty: Export-Meta + Pretty-Mehrzeilenformat\n'
  else
    printf '[FAIL] Yearly JSON pretty: Export-Meta + Pretty-Mehrzeilenformat\n'
    add_fail
  fi
}

test_yearly_period_text_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --from 2022-01 --to 2024-01 --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Jahr' "$out"; then
    printf '[OK] Yearly + Zeitraum: Tabelle mit Jahr-Spalte\n'
  else
    printf '[FAIL] Yearly + Zeitraum: Tabelle mit Jahr-Spalte\n'
    add_fail
  fi
}

test_yearly_without_stats_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -Eq 'Kein Kommando|--yearly ist nur zusammen' "$err"; then
    printf '[OK] Yearly ohne stats: sauberer Validierungsfehler\n'
  else
    printf '[FAIL] Yearly ohne stats: sauberer Validierungsfehler\n'
    add_fail
  fi
}

test_yearly_monthly_conflict_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --yearly --monthly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nicht zusammen verwendet' "$err"; then
    printf '[OK] Yearly + Monthly: Konflikt wird abgelehnt\n'
  else
    printf '[FAIL] Yearly + Monthly: Konflikt wird abgelehnt\n'
    add_fail
  fi
}

test_yearly_csv_conflict_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --yearly --csv >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -Eq 'nicht als CSV|CSV' "$err"; then
    printf '[OK] Yearly + CSV: Konflikt wird abgelehnt\n'
  else
    printf '[FAIL] Yearly + CSV: Konflikt wird abgelehnt\n'
    add_fail
  fi
}

test_yearly_dashboard_conflict_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --yearly --dashboard >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nicht mit --dashboard kombiniert' "$err"; then
    printf '[OK] Yearly + Dashboard: Konflikt wird abgelehnt\n'
  else
    printf '[FAIL] Yearly + Dashboard: Konflikt wird abgelehnt\n'
    add_fail
  fi
}

test_yearly_pretty_without_json_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --pretty --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'nur zusammen mit --json' "$err"; then
    printf '[OK] Yearly + Pretty ohne JSON: Validierungsfehler\n'
  else
    printf '[FAIL] Yearly + Pretty ohne JSON: Validierungsfehler\n'
    add_fail
  fi
}

test_yearly_empty_db_text_ok() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --stats fuelups --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'Keine Tankvorgaenge' "$out"; then
    printf '[OK] Leere DB + Yearly: sauberer No-Data-Output\n'
  else
    printf '[FAIL] Leere DB + Yearly: sauberer No-Data-Output\n'
    add_fail
  fi
}

test_yearly_json_pretty_period_demo_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --stats fuelups --json --pretty --from 2023-01 --yearly >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] && grep -q 'fuelups_yearly' "$out"; then
    printf '[OK] Demo + Yearly + JSON + Pretty + Period\n'
  else
    printf '[FAIL] Demo + Yearly + JSON + Pretty + Period\n'
    add_fail
  fi
}

run_yearly_suite() {
  printf '[INFO] Zusatzsuite aktiv: Yearly (-y)\n'
  test_yearly_text_demo_ok
  test_yearly_json_compact_demo_ok
  test_yearly_json_pretty_demo_ok
  test_yearly_period_text_demo_ok
  test_yearly_without_stats_fails
  test_yearly_monthly_conflict_fails
  test_yearly_csv_conflict_fails
  test_yearly_dashboard_conflict_fails
  test_yearly_pretty_without_json_fails
  test_yearly_empty_db_text_ok
  test_yearly_json_pretty_period_demo_ok
}

test_cars_add_and_list_ok() {
  local home add_out add_err list_out list_err rc_add rc_list car_name

  home="$(register_tmp_dir)"
  add_out="$home/add_out.txt"
  add_err="$home/add_err.txt"
  list_out="$home/list_out.txt"
  list_err="$home/list_err.txt"
  car_name="SmokeCar_${RANDOM}"

  set +e
  printf '%s\n%s\n%s\n%s\n%s\n' \
    "$car_name" \
    "" \
    "" \
    "1234" \
    "2026-02-24" \
    | HOME="$home" "$ROOT_DIR/bin/Betankungen" --add cars >"$add_out" 2>"$add_err"
  rc_add=$?
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --list cars >"$list_out" 2>"$list_err"
  rc_list=$?
  set -e

  if [[ $rc_add -eq 0 ]] && [[ $rc_list -eq 0 ]] && grep -q "$car_name" "$list_out"; then
    printf '[OK] Cars: --add cars + --list cars\n'
  else
    printf '[FAIL] Cars: --add cars + --list cars\n'
    add_fail
  fi
}

test_cars_edit_requires_id_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --edit cars >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q -- '--car-id ist fuer "--edit cars" und "--delete cars" erforderlich' "$err"; then
    printf '[OK] Cars: --edit cars ohne --car-id -> Fehler\n'
  else
    printf '[FAIL] Cars: --edit cars ohne --car-id -> Fehler\n'
    add_fail
  fi
}

test_cars_delete_requires_id_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --delete cars >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q -- '--car-id ist fuer "--edit cars" und "--delete cars" erforderlich' "$err"; then
    printf '[OK] Cars: --delete cars ohne --car-id -> Fehler\n'
  else
    printf '[FAIL] Cars: --delete cars ohne --car-id -> Fehler\n'
    add_fail
  fi
}

test_cars_edit_missing_id_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --edit cars --car-id 999 >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'car_id' "$err" && grep -q 'existiert nicht' "$err"; then
    printf '[OK] Cars: --edit cars --car-id 999 -> Fehler (unknown car)\n'
  else
    printf '[FAIL] Cars: --edit cars --car-id 999 -> Fehler (unknown car)\n'
    add_fail
  fi
}

test_cars_delete_missing_id_fails() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --delete cars --car-id 999 >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'car_id' "$err" && grep -q 'existiert nicht' "$err"; then
    printf '[OK] Cars: --delete cars --car-id 999 -> Fehler (unknown car)\n'
  else
    printf '[FAIL] Cars: --delete cars --car-id 999 -> Fehler (unknown car)\n'
    add_fail
  fi
}

test_cars_delete_blocked_when_fuelups_exist() {
  local home out err rc db

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  db="$home/.local/share/Betankungen/betankungen.db"

  HOME="$home" "$ROOT_DIR/bin/Betankungen" >/dev/null 2>&1
  sqlite3 "$db" <<'SQL'
INSERT OR IGNORE INTO stations(
  id, brand, street, house_no, zip, city, phone, owner, created_at
) VALUES (
  1, 'Smoke', 'Road', '1', '12345', 'City', '', '', datetime('now')
);
INSERT OR IGNORE INTO fuelups(
  id, station_id, car_id, fueled_at, odometer_km, liters_ml, total_cents,
  price_per_liter_milli_eur, is_full_tank, missed_previous, created_at
) VALUES (
  1, 1, 1, datetime('now'), 1000, 10000, 1500, 1500, 1, 0, datetime('now')
);
SQL

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --delete cars --car-id 1 >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] && grep -q 'geloescht' "$err" && grep -q 'fuelups vorhanden' "$err"; then
    printf '[OK] Cars: --delete cars mit fuelups -> geblockt\n'
  else
    printf '[FAIL] Cars: --delete cars mit fuelups -> geblockt\n'
    add_fail
  fi
}

test_cars_crud_script_ok() {
  if "$ROOT_DIR/tests/smoke_cars_crud.sh" >/dev/null 2>&1; then
    printf '[OK] Cars: dedizierter CRUD-Smoke (%s)\n' 'tests/smoke_cars_crud.sh'
  else
    printf '[FAIL] Cars: dedizierter CRUD-Smoke (%s)\n' 'tests/smoke_cars_crud.sh'
    add_fail
  fi
}

test_multi_car_context_script_ok() {
  if "$ROOT_DIR/tests/smoke_multi_car_context.sh" >/dev/null 2>&1; then
    printf '[OK] Cars: Resolver-Matrix-Smoke (%s)\n' 'tests/smoke_multi_car_context.sh'
  else
    printf '[FAIL] Cars: Resolver-Matrix-Smoke (%s)\n' 'tests/smoke_multi_car_context.sh'
    add_fail
  fi
}

run_cars_suite() {
  printf '[INFO] Zusatzsuite aktiv: Cars (-c)\n'
  test_cars_crud_script_ok
  test_multi_car_context_script_ok
  test_cars_add_and_list_ok
  test_cars_edit_requires_id_fails
  test_cars_delete_requires_id_fails
  test_cars_edit_missing_id_fails
  test_cars_delete_missing_id_fails
  test_cars_delete_blocked_when_fuelups_exist
}

test_migrations_script_ok() {
  if "$ROOT_DIR/tests/smoke_migrations.sh" --all >/dev/null 2>&1; then
    printf '[OK] Migrations: dedizierter Migration-Smoke (%s)\n' 'tests/smoke_migrations.sh --all'
  else
    printf '[FAIL] Migrations: dedizierter Migration-Smoke (%s)\n' 'tests/smoke_migrations.sh --all'
    add_fail
  fi
}

run_migrations_suite() {
  printf '[INFO] Zusatzsuite aktiv: Migrations (--migrations)\n'
  test_migrations_script_ok
}

test_modules_script_ok() {
  if "$ROOT_DIR/tests/smoke_modules.sh" >/dev/null 2>&1; then
    printf '[OK] Modules: dedizierter Contract-Smoke (%s)\n' 'tests/smoke_modules.sh'
  else
    printf '[FAIL] Modules: dedizierter Contract-Smoke (%s)\n' 'tests/smoke_modules.sh'
    add_fail
  fi
}

run_modules_suite() {
  printf '[INFO] Zusatzsuite aktiv: Modules (--modules)\n'
  test_modules_script_ok
}

trap cleanup_tmp_dirs EXIT

require_path() {
  local p="$1"
  if [[ -e "$p" ]]; then
    printf '[OK] Pfad vorhanden: %s\n' "$p"
  else
    printf '[FAIL] Pfad fehlt: %s\n' "$p"
    add_fail
  fi
}

printf 'Smoke-Test startet in %s\n' "$ROOT_DIR"

require_path "$ROOT_DIR/docs"
require_path "$ROOT_DIR/src"
require_path "$ROOT_DIR/units"
require_path "$ROOT_DIR/scripts"
require_path "$ROOT_DIR/tests/domain_policy"
require_path "$ROOT_DIR/tests/regression"
require_path "$ROOT_DIR/tests/smoke"
require_path "$ROOT_DIR/knowledge_archive"
require_path "$ROOT_DIR/.releases"
require_path "$ROOT_DIR/.backup"

run_check "kpr dry-run" "$ROOT_DIR/kpr.sh" --dry-run
run_check "backup_snapshot dry-run" "$ROOT_DIR/scripts/backup_snapshot.sh" --dry-run
run_check "btkgit --help" "$ROOT_DIR/btkgit" --help
test_btkgit_ready_skip_verify_ok
test_btkgit_preflight_default_help_ok
test_btkgit_sync_missing_origin_fails_cleanly
test_btkgit_sync_without_upstream_fails_cleanly
test_btkgit_cleanup_keeps_branch_by_default
test_btkgit_cleanup_delete_local_ok
run_check "Test-DB Build: Betankungen_Big.db + Betankungen_Policy.db" "$ROOT_DIR/tests/domain_policy/helpers/build_test_dbs.sh"

if [[ -x "$ROOT_DIR/bin/Betankungen" ]]; then
  run_check "Betankungen --version" "$ROOT_DIR/bin/Betankungen" --version
  run_check "Betankungen --help" "$ROOT_DIR/bin/Betankungen" --help
  test_help_keywords_stable
  test_help_mentions_odometer_guidance
  test_help_mentions_receipt_link
  test_fuelups_detail_reference_screen_ok
  test_receipt_link_scope_guardrail_fails
  test_stats_stations_fails_short_usage
  test_stats_json_csv_fails_short_3line_no_full_help
  test_stats_fleet_mvp_ok
  test_stats_fleet_json_compact_ok
  test_stats_fleet_json_pretty_ok
  test_stats_cost_mvp_ok
  test_stats_cost_json_compact_ok
  test_stats_cost_json_pretty_ok
  test_stats_cost_json_scope_fields_ok
  test_stats_cost_maintenance_source_none_ok
  test_stats_cost_maintenance_source_context_fails
  test_stats_cost_maintenance_source_module_fallback_ok
  test_stats_cost_csv_fails
  test_stats_cost_monthly_yearly_dashboard_fails
  test_stats_cost_period_ok
  test_stats_cost_car_id_ok
  test_stats_fleet_csv_fails
  test_stats_fleet_monthly_yearly_dashboard_fails
  test_stats_fleet_period_fails
  test_first_run_bootstrap
  test_cfg_present_db_missing
  test_default_unwritable_prompt_retry
  test_show_config_fresh_home
  test_reset_config_keeps_db
  test_reset_config_delete_failure_if_possible
  test_demo_without_seed_fails_non_interactive
  test_seed_then_demo_list_stations_ok
  test_add_fuelups_empty_state_eof_fails_cleanly
  test_db_override_error_no_prompt
  run_check "Unit-Tests: CLI-Validate" "$ROOT_DIR/tests/domain_policy/run_domain_policy_tests.sh"
  if $RUN_MONTHLY_SUITE; then
    run_monthly_suite
  fi
  if $RUN_YEARLY_SUITE; then
    run_yearly_suite
  fi
  if $RUN_CARS_SUITE; then
    run_cars_suite
  fi
  if $RUN_MIGRATIONS_SUITE; then
    run_migrations_suite
  fi
  if $RUN_MODULES_SUITE; then
    run_modules_suite
  fi
else
  printf '[INFO] Binärdatei fehlt: %s\n' "$ROOT_DIR/bin/Betankungen"
fi

if [[ $FAILS -gt 0 ]]; then
  printf 'Smoke-Test beendet mit %d Fehler(n).\n' "$FAILS"
  exit 1
fi

printf 'Smoke-Test erfolgreich.\n'
