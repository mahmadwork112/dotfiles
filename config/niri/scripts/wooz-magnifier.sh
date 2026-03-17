#!/usr/bin/env bash
# ~/.config/niri/scripts/wooz-magnifier.sh

# Adjust the zoom percentage to what actually shows zoom on your setup
# (you said 0–99% works — start low, e.g. 20–50%)
trap 'exit 0' TERM INT

ZOOM_PERCENT="30"

wooz --zoom-in "${ZOOM_PERCENT}%" --mouse-track

# Runs in foreground → you get full mouse tracking + scroll zoom
# Quit with right-click or Esc (as per wooz --help)
