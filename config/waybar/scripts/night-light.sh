#!/usr/bin/env bash

if ! command -v wlsunset >/dev/null 2>&1; then
  notify-send -u critical "wlsunset not found" "Please install wlsunset"
  exit 1
fi

pid=$(pgrep -x wlsunset)

if [ -z "$pid" ]; then
  wlsunset -T 3501 -t 3500 >/dev/null 2>&1 &
  notify-send "Night Light" "wlsunset started (auto-mode)"
else
  kill "$pid"
  notify-send -t 1500 "Night Light" "Toggled"
fi
