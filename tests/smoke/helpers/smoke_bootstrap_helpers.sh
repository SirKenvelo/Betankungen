#!/usr/bin/env bash

# smoke_bootstrap_helpers.sh
# CREATED: 2026-03-12
# UPDATED: 2026-03-21
# Bootstrap-/First-Run-Checks fuer tests/smoke/smoke_cli.sh

test_first_run_bootstrap() {
  local home out err cfg db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  db="$home/.local/share/Betankungen/betankungen.db"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 && ! -s "$out" && ! -s "$err" && -f "$cfg" && -f "$db" ]]; then
    printf '[OK] First-Run: stiller Bootstrap (config+db)\n'
  else
    printf '[FAIL] First-Run: stiller Bootstrap (config+db)\n'
    add_fail
  fi
}

test_cfg_present_db_missing() {
  local home out err cfg db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  db="$home/.local/share/Betankungen/betankungen.db"

  mkdir -p "$(dirname "$cfg")"
  printf "[database]\npath=%s\n" "$db" > "$cfg"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 && ! -s "$out" && ! -s "$err" && -f "$db" ]]; then
    printf '[OK] Config vorhanden, DB fehlt: automatische DB-Anlage ohne Prompt\n'
  else
    printf '[FAIL] Config vorhanden, DB fehlt: automatische DB-Anlage ohne Prompt\n'
    add_fail
  fi
}

test_default_unwritable_prompt_retry() {
  local home out err cfg alt_db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  alt_db="$home/custom/betankungen.db"

  # Blockiert den Default-Pfad absichtlich: ".local" als Datei statt Verzeichnis.
  printf "block" > "$home/.local"

  set +e
  printf '\n%s\n' "$alt_db" | HOME="$home" "$ROOT_DIR/bin/Betankungen" >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 && -f "$cfg" && -f "$alt_db" ]] &&
     grep -q 'DB-Pfad>' "$out" &&
     grep -q "path=$alt_db" "$cfg"; then
    printf '[OK] Default nicht schreibbar: Prompt-Fallback + Retry erfolgreich\n'
  else
    printf '[FAIL] Default nicht schreibbar: Prompt-Fallback + Retry erfolgreich\n'
    add_fail
  fi
}

test_show_config_fresh_home() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --show-config >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]] &&
     grep -q 'Config-Datei:' "$out" &&
     grep -q 'Default DB-Pfad:' "$out"; then
    printf '[OK] --show-config in frischer HOME-Umgebung\n'
  else
    printf '[FAIL] --show-config in frischer HOME-Umgebung\n'
    add_fail
  fi
}

test_reset_config_keeps_db() {
  local home out err cfg db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  db="$home/.local/share/Betankungen/betankungen.db"

  HOME="$home" "$ROOT_DIR/bin/Betankungen" >/dev/null 2>&1

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --reset-config >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 && ! -f "$cfg" && -f "$db" ]]; then
    printf '[OK] --reset-config loescht nur Config, nicht die DB\n'
  else
    printf '[FAIL] --reset-config loescht nur Config, nicht die DB\n'
    add_fail
  fi
}

test_reset_config_delete_failure_if_possible() {
  local home out err cfg cfg_dir rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  cfg="$home/.config/Betankungen/config.ini"
  cfg_dir="$home/.config/Betankungen"

  HOME="$home" "$ROOT_DIR/bin/Betankungen" >/dev/null 2>&1

  if [[ ! -f "$cfg" || ! -d "$cfg_dir" ]]; then
    printf '[FAIL] --reset-config Fehlerpfad: Test-Setup fehlgeschlagen\n'
    add_fail
    return
  fi

  chmod u-w "$cfg_dir"
  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --reset-config >"$out" 2>"$err"
  rc=$?
  set -e
  chmod u+w "$cfg_dir"

  if [[ $rc -eq 0 ]]; then
    printf '[INFO] --reset-config Fehlerpfad: Umgebung erlaubt keine reproduzierbare Delete-Blockade, Check uebersprungen\n'
    return
  fi

  if [[ -f "$cfg" ]] &&
     grep -q 'Konnte Config nicht loeschen:' "$err" &&
     grep -q 'Tipp: Betankungen --help' "$err"; then
    printf '[OK] --reset-config Fehlerpfad: Config-Loeschfehler sauber abgefangen\n'
  else
    printf '[FAIL] --reset-config Fehlerpfad: Config-Loeschfehler sauber abgefangen\n'
    add_fail
  fi
}

test_demo_without_seed_fails_non_interactive() {
  local home out err rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --list stations >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] &&
     grep -q 'Demo-DB nicht gefunden' "$err" &&
     ! grep -q 'DB-Pfad>' "$out"; then
    printf '[OK] --demo ohne Seed: sauberer Fehler ohne Prompt\n'
  else
    printf '[FAIL] --demo ohne Seed: sauberer Fehler ohne Prompt\n'
    add_fail
  fi
}

test_seed_then_demo_list_stations_ok() {
  local home out err rc

  home="$(prepare_seeded_demo_home)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --demo --list stations >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -eq 0 && -s "$out" ]] &&
     ! grep -q 'Demo-DB nicht gefunden' "$err"; then
    printf '[OK] --seed -> --demo --list stations: Demo-DB konsistent nutzbar\n'
  else
    printf '[FAIL] --seed -> --demo --list stations: Demo-DB konsistent nutzbar\n'
    add_fail
  fi
}

test_add_fuelups_empty_state_eof_fails_cleanly() {
  local home out err rc pid loops=0 finished=false

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --add fuelups >"$out" 2>"$err" </dev/null &
  pid=$!
  while [[ $loops -lt 5 ]]; do
    if ! kill -0 "$pid" 2>/dev/null; then
      finished=true
      break
    fi
    sleep 1
    loops=$((loops + 1))
  done

  if $finished; then
    wait "$pid"
    rc=$?
  else
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    rc=124
  fi
  set -e

  if [[ $rc -ne 0 && $rc -ne 124 ]] &&
     grep -q 'Keine Tankstellen vorhanden' "$err" &&
     ! grep -q 'Stations-ID (oder "l"=Liste, "q"=Abbruch):' "$out"; then
    printf '[OK] --add fuelups bei leerer DB + EOF: sauberer Fehler ohne Prompt-Schleife\n'
  else
    printf '[FAIL] --add fuelups bei leerer DB + EOF: sauberer Fehler ohne Prompt-Schleife\n'
    add_fail
  fi
}

test_db_override_error_no_prompt() {
  local home out err bad_db rc

  home="$(register_tmp_dir)"
  out="$home/out.txt"
  err="$home/err.txt"
  printf "block" > "$home/blocker"
  bad_db="$home/blocker/bad.db"

  set +e
  HOME="$home" "$ROOT_DIR/bin/Betankungen" --db "$bad_db" --list stations >"$out" 2>"$err"
  rc=$?
  set -e

  if [[ $rc -ne 0 ]] &&
     grep -q 'Fehler: DB-Pfad nicht nutzbar:' "$err" &&
     ! grep -q 'DB-Pfad>' "$out"; then
    printf '[OK] --db Fehlerpfad bleibt non-interactive (kein Prompt)\n'
  else
    printf '[FAIL] --db Fehlerpfad bleibt non-interactive (kein Prompt)\n'
    add_fail
  fi
}
