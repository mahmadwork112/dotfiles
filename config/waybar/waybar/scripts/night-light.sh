#!/usr/bin/env bash
# ~/.config/waybar/scripts/night-light.sh
# Usage: night-light.sh [toggle|warmer]
#   toggle  -> right-click: on/off (default 4500K)
#   warmer  -> middle-click: cycle 4000K → 3000K → 2500K → off → 4000K

STATE_FILE="/tmp/waybar_nightlight_temp"
DEFAULT_TEMP=1000
TEMPS=(4000 3000 2500) # Cycling list for warmer clicks

cmd=${1:-toggle}

# Ensure wlsunset exists
if ! command -v wlsunset >/dev/null 2>&1; then
  notify-send -u critical "wlsunset not found" "Install wlsunset to use night light"
  exit 1
fi

pid=$(pgrep -x wlsunset)
current_temp=$(cat "$STATE_FILE" 2>/dev/null || echo $DEFAULT_TEMP)

# ── TOGGLE (right-click) ────────────────────
if [[ "$cmd" == "toggle" ]]; then
  if [[ -n "$pid" ]]; then
    kill "$pid"
    notify-send -t 1500 "Night Light" "Off"
  else
    wlsunset -T "$current_temp" -t $((current_temp - 100)) >/dev/null 2>&1 &
    notify-send -t 1500 "Night Light" "On ($current_temp K)"
    echo "$current_temp" >"$STATE_FILE"
  fi
  exit 0
fi

# ── WARMER cycle (middle-click) ─────────────
if [[ "$cmd" == "warmer" ]]; then
  if [[ -n "$pid" ]]; then
    # Already running → move to next warmer setting
    current_index=-1
    for i in "${!TEMPS[@]}"; do
      [[ "${TEMPS[$i]}" -eq "$current_temp" ]] && current_index=$i && break
    done
    next_index=$(((current_index + 1) % (${#TEMPS[@]} + 1))) # +1 counts the "off" state
    kill "$pid"
    if [[ $next_index -lt ${#TEMPS[@]} ]]; then
      new_temp=${TEMPS[$next_index]}
      wlsunset -T "$new_temp" -t $((new_temp - 100)) >/dev/null 2>&1 &
      echo "$new_temp" >"$STATE_FILE"
      notify-send -t 1500 "Night Light" "Warmer ($new_temp K)"
    else
      # End of list → turn off
      : >"$STATE_FILE" # clear file
      notify-send -t 1500 "Night Light" "Off"
    fi
  else
    # Not running → start at warmest of the cycle (first in array)
    new_temp=${TEMPS[0]}
    wlsunset -T "$new_temp" -t $((new_temp - 100)) >/dev/null 2>&1 &
    echo "$new_temp" >"$STATE_FILE"
    notify-send -t 1500 "Night Light" "On – Warmer ($new_temp K)"
  fi
  exit 0
fi

echo "Usage: $0 [toggle|warmer]"
exit 1
