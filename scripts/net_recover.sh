#!/usr/bin/env bash
set -euo pipefail

# net_recover.sh
# UPDATED: 2026-02-17
# Zeigt Netzwerkdiagnose und startet bei Bedarf das aktive Interface neu.

SCRIPT_NAME="$(basename "$0")"
IFACE=""
PING_IP="1.1.1.1"
PING_DNS="example.com"
WAIT_SECONDS=4
ONLY_INFO=false
ONLY_IF_OFFLINE=false
LAST_CONNECTIVITY_OK=false

usage() {
  cat <<EOF_USAGE
$SCRIPT_NAME - Netzwerkdiagnose + Interface-Reset

Usage:
  $SCRIPT_NAME [options]

Options:
  -i, --iface NAME      Interface explizit setzen (z. B. wlan0, enp3s0)
      --ping-ip IP      Ping-Test auf IP (Default: $PING_IP)
      --ping-dns HOST   DNS/Ping-Test auf Host (Default: $PING_DNS)
      --wait SEC        Wartezeit nach Reset (Default: $WAIT_SECONDS)
      --only-if-offline Reset nur dann ausfuehren, wenn Checks fehlschlagen
      --info-only       Nur Infos anzeigen, kein Neustart
  -h, --help            Hilfe anzeigen

Beispiele:
  $SCRIPT_NAME
  $SCRIPT_NAME --iface wlan0
  $SCRIPT_NAME --info-only
EOF_USAGE
}

log() {
  printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

warn() {
  printf '[WARN] %s\n' "$*" >&2
}

die() {
  printf 'Fehler: %s\n' "$*" >&2
  exit 1
}

run_as_root() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
    return
  fi
  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
    return
  fi
  die "Fuer diese Aktion wird root oder sudo benoetigt: $*"
}

require_base_tools() {
  command -v ip >/dev/null 2>&1 || die "'ip' wurde nicht gefunden (iproute2 fehlt)."
}

detect_iface() {
  if [[ -n "$IFACE" ]]; then
    return
  fi

  IFACE="$(ip route show default 2>/dev/null | awk '/default/ {print $5; exit}' || true)"
  if [[ -z "$IFACE" ]]; then
    IFACE="$(ip -o link show 2>/dev/null | awk -F': ' '$2 != "lo" {print $2; exit}' || true)"
  fi
  [[ -n "$IFACE" ]] || die "Kein Netzwerk-Interface gefunden. Nutze --iface NAME."
}

check_connectivity() {
  local phase="$1"
  local failed=0
  printf '\n-- Konnektivitaet (%s) --\n' "$phase"

  if command -v ping >/dev/null 2>&1; then
    if ping -c1 -W2 "$PING_IP" >/dev/null 2>&1; then
      printf '[OK] Ping IP %s\n' "$PING_IP"
    else
      printf '[FAIL] Ping IP %s\n' "$PING_IP"
      failed=$((failed + 1))
    fi
  else
    printf '[WARN] ping nicht installiert, IP-Test uebersprungen\n'
    failed=$((failed + 1))
  fi

  if command -v getent >/dev/null 2>&1; then
    if getent hosts "$PING_DNS" >/dev/null 2>&1; then
      printf '[OK] DNS-Aufloesung %s\n' "$PING_DNS"
    else
      printf '[FAIL] DNS-Aufloesung %s\n' "$PING_DNS"
      failed=$((failed + 1))
    fi
  else
    printf '[WARN] getent nicht installiert, DNS-Aufloesung uebersprungen\n'
    failed=$((failed + 1))
  fi

  if command -v ping >/dev/null 2>&1; then
    if ping -c1 -W2 "$PING_DNS" >/dev/null 2>&1; then
      printf '[OK] Ping Host %s\n' "$PING_DNS"
    else
      printf '[FAIL] Ping Host %s\n' "$PING_DNS"
      failed=$((failed + 1))
    fi
  fi

  if [[ "$failed" -eq 0 ]]; then
    LAST_CONNECTIVITY_OK=true
  else
    LAST_CONNECTIVITY_OK=false
  fi
}

print_diag() {
  local phase="$1"
  printf '\n=== %s (%s) ===\n' "$phase" "$(date '+%Y-%m-%d %H:%M:%S')"
  printf 'Host: %s\n' "$(hostname)"
  printf 'Interface: %s\n' "$IFACE"

  printf '\n-- Link --\n'
  ip -br link show dev "$IFACE" || true

  printf '\n-- Adressen --\n'
  ip -br addr show dev "$IFACE" || true

  printf '\n-- Routing (default) --\n'
  ip route show default || true

  printf '\n-- DNS (/etc/resolv.conf) --\n'
  if [[ -r /etc/resolv.conf ]]; then
    grep -E '^(nameserver|search|options)' /etc/resolv.conf || cat /etc/resolv.conf
  else
    printf 'Nicht lesbar.\n'
  fi

  if command -v nmcli >/dev/null 2>&1; then
    printf '\n-- NetworkManager --\n'
    nmcli -t -f GENERAL.STATE,GENERAL.CONNECTION device show "$IFACE" 2>/dev/null || true
  fi

  check_connectivity "$phase"
}

restart_iface() {
  log "Starte Interface '$IFACE' neu ..."

  if command -v nmcli >/dev/null 2>&1 && command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active --quiet NetworkManager; then
      log "Nutze NetworkManager (disconnect/connect)."
      nmcli device disconnect "$IFACE" >/dev/null 2>&1 || warn "Disconnect meldete Fehler."
      sleep 2
      nmcli device connect "$IFACE" >/dev/null 2>&1 || warn "Connect meldete Fehler."
      sleep "$WAIT_SECONDS"
      return
    fi
  fi

  log "Fallback: ip link down/up (ggf. sudo Passwort)."
  run_as_root ip link set dev "$IFACE" down
  sleep 2
  run_as_root ip link set dev "$IFACE" up
  sleep "$WAIT_SECONDS"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--iface)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument."
      IFACE="$2"
      shift 2
      ;;
    --ping-ip)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument."
      PING_IP="$2"
      shift 2
      ;;
    --ping-dns)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument."
      PING_DNS="$2"
      shift 2
      ;;
    --wait)
      [[ $# -ge 2 ]] || die "Option $1 braucht ein Argument."
      WAIT_SECONDS="$2"
      shift 2
      ;;
    --info-only)
      ONLY_INFO=true
      shift
      ;;
    --only-if-offline)
      ONLY_IF_OFFLINE=true
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

require_base_tools
detect_iface

print_diag "Vorher"

if $ONLY_INFO; then
  log "Info-only aktiv, kein Neustart."
  exit 0
fi

if $ONLY_IF_OFFLINE && $LAST_CONNECTIVITY_OK; then
  log "Konnektivitaet ist bereits OK, kein Neustart."
  exit 0
fi

restart_iface
print_diag "Nachher"

if $ONLY_IF_OFFLINE; then
  if $LAST_CONNECTIVITY_OK; then
    log "Nach Reset ist die Konnektivitaet wieder OK."
  else
    warn "Nach Reset bestehen weiterhin Probleme."
  fi
fi

log "Fertig."
