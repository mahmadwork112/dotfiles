#!/usr/bin/env bash
# ~/.config/niri/scripts/niri-colorpicker.sh

# Path to the magnifier script (relative to this file's location)
MAGNIFIER_SCRIPT="$(dirname "$0")/wooz-magnifier.sh"

# Launch magnifier in background
# We use & so the script can continue immediately
"$MAGNIFIER_SCRIPT" &
WOOZ_PID=$!

# Wait briefly for wooz to initialize the window and start tracking
# 0.3–0.6 seconds is usually enough; increase if needed
sleep 2

# Run niri color picker (this blocks until you click or cancel/Esc)
raw_color=$(niri msg pick-color)

# Stronger cleanup: SIGTERM first, then SIGKILL if stubborn
kill "$WOOZ_PID" 2>/dev/null
sleep 0.1 # tiny grace period
pkill -9 -f "wooz --zoom-in" 2>/dev/null

# If user cancelled the picker → raw_color is empty → just exit
if [ -z "$raw_color" ]; then
  exit 0
fi

# Extract the hex color
color=$(echo "$raw_color" | grep -oP 'Hex: \K#[0-9A-Fa-f]{6}')

# Copy to clipboard (no newline)
echo -n "$color" | wl-copy

# Show notification
notify-send "Color picked" "$color" \
  -i color-management \
  -h string:x-dunst-stack-tag:colorpick
