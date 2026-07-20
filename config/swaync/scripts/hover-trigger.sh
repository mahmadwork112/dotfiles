#!/bin/zsh
# Hover-to-toggle notification center (swaync)
# Triggers only in the TOP-RIGHT CORNER of the screen.

CORNER_WIDTH=120     # pixels from the right edge
CORNER_HEIGHT=40     # pixels from the top edge

ENTER_THRESHOLD=2
EXIT_THRESHOLD=2

POLL_ACTIVE=0.05
POLL_IDLE=0.2

LOCKFILE="/tmp/hover-notif.pid"

# --- single instance guard ---
if [[ -f "$LOCKFILE" ]]; then
    old_pid=$(cat "$LOCKFILE")
    if kill -0 "$old_pid" 2>/dev/null; then
        echo "Already running (pid $old_pid). Use the restart command instead."
        exit 1
    fi
fi
echo $$ > "$LOCKFILE"
trap 'rm -f "$LOCKFILE"; exit' INT TERM EXIT

# --- get focused monitor's width (so the corner tracks the right monitor) ---
get_screen_width() {
    hyprctl monitors -j | jq '.[] | select(.focused==true) | .width / .scale' | cut -d'.' -f1
}

SCREEN_WIDTH=$(get_screen_width)
ZONE_START_X=$((SCREEN_WIDTH - CORNER_WIDTH))

in_zone() {
    local pos x y
    pos=$(hyprctl cursorpos)
    x=$(echo "$pos" | cut -d',' -f1 | tr -d ' ')
    y=$(echo "$pos" | cut -d',' -f2 | tr -d ' ')
    [[ "$y" -ge 0 && "$y" -le "$CORNER_HEIGHT" && "$x" -ge "$ZONE_START_X" ]]
}

STATE="closed"
ARMED=1
enter_count=0
exit_count=0
refresh_counter=0

while true; do
    # Refresh screen width every ~100 polls in case monitor config changes
    refresh_counter=$((refresh_counter + 1))
    if [[ "$refresh_counter" -ge 100 ]]; then
        SCREEN_WIDTH=$(get_screen_width)
        ZONE_START_X=$((SCREEN_WIDTH - CORNER_WIDTH))
        refresh_counter=0
    fi

    if in_zone; then
        enter_count=$((enter_count + 1))
        exit_count=0

        if [[ "$ARMED" -eq 1 && "$enter_count" -ge "$ENTER_THRESHOLD" ]]; then
            if [[ "$STATE" = "closed" ]]; then
                swaync-client -op
                STATE="open"
            else
                swaync-client -cp
                STATE="closed"
            fi
            ARMED=0
        fi
        sleep "$POLL_ACTIVE"
    else
        exit_count=$((exit_count + 1))
        enter_count=0

        if [[ "$exit_count" -ge "$EXIT_THRESHOLD" ]]; then
            ARMED=1
        fi
        sleep "$POLL_IDLE"
    fi
done
