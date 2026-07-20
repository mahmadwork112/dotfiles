#!/usr/bin/env zsh
# ~/.config/waybar/scripts/workspace-apps.sh
#
# Right-click a workspace number → popup list of apps on it → click to focus
# Works on Hyprland, Niri, and MangoWM
# Requires: jq, and one of: fuzzel (preferred) or rofi

WORKSPACE_ID=$1

# ── Fuzzel or Rofi ────────────────────────────
pick() {
  if command -v fuzzel &>/dev/null; then
    fuzzel --dmenu --prompt="  workspace $WORKSPACE_ID  ➜  " \
      --width=40 --lines=10
  elif command -v rofi &>/dev/null; then
    rofi -dmenu -p "Workspace $WORKSPACE_ID"
  else
    notify-send "workspace-apps" "Install fuzzel or rofi to use this feature"
    exit 1
  fi
}

# ════════════════════════════════════════════════
# HYPRLAND
# ════════════════════════════════════════════════
if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
  # Build list: "ClassName  →  Window Title (truncated)"
  CLIENTS=$(hyprctl clients -j 2>/dev/null |
    jq -r --argjson ws "$WORKSPACE_ID" \
      '.[] | select(.workspace.id == $ws) | "\(.class)\t\(.title | .[0:50])"')

  if [ -z "$CLIENTS" ]; then
    notify-send "Workspace $WORKSPACE_ID" "No apps open here"
    exit 0
  fi

  # Show display list (class  →  title)
  DISPLAY=$(echo "$CLIENTS" | awk -F'\t' '{printf "%-20s  →  %s\n", $1, $2}')
  SELECTED=$(echo "$DISPLAY" | pick)

  if [ -n "$SELECTED" ]; then
    # Extract class from selection and focus
    CLASS=$(echo "$SELECTED" | awk '{print $1}')
    hyprctl dispatch focuswindow "class:^(${CLASS})$" &>/dev/null
    # Also switch to that workspace
    hyprctl dispatch workspace "$WORKSPACE_ID" &>/dev/null
  fi

# ════════════════════════════════════════════════
# NIRI
# ════════════════════════════════════════════════
elif [ -n "$NIRI_SOCKET" ]; then
  CLIENTS=$(niri msg -j windows 2>/dev/null |
    jq -r --argjson ws "$WORKSPACE_ID" \
      '.[] | select(.workspace_id == $ws) | "\(.id)\t\(.app_id // "unknown")\t\(.title | .[0:50])"')

  if [ -z "$CLIENTS" ]; then
    notify-send "Workspace $WORKSPACE_ID" "No apps open here"
    exit 0
  fi

  DISPLAY=$(echo "$CLIENTS" | awk -F'\t' '{printf "%-20s  →  %s\n", $2, $3}')
  SELECTED=$(echo "$DISPLAY" | pick)

  if [ -n "$SELECTED" ]; then
    APP_ID=$(echo "$SELECTED" | awk '{print $1}')
    WIN_ID=$(echo "$CLIENTS" | awk -F'\t' -v app="$APP_ID" '$2 == app {print $1; exit}')
    niri msg action focus-window --id "$WIN_ID" &>/dev/null
  fi

# ════════════════════════════════════════════════
# MANGOWM  (mmsg IPC)
# ════════════════════════════════════════════════
elif command -v mmsg &>/dev/null; then
  # MangoWM doesn't expose per-tag window lists yet via mmsg
  # Show current tag info as a fallback
  INFO=$(mmsg -g -t 2>/dev/null)
  notify-send "Workspace $WORKSPACE_ID" "${INFO:-IPC info unavailable}"

else
  notify-send "workspace-apps" "No supported compositor detected"
fi
