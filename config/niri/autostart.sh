#!/usr/bin/env bash

# ensuring zero duplicates
killall -9 waybar awww-daemon swww-daemon swaync mako dunst swayosd 2>/dev/null
(
  systemctl --user stop awww-daemon.service
  systemctl --user stop vicinae.service
  systemctl --user stop polkit-kde-agent.service
  systemctl --user stop vibepanel.service
) &

# Starting all the systemctl services
systemctl --user start awww-daemon.service
systemctl --user start vicinae.service
systemctl --user start polkit-kde-agent.service

# starting everything
swayosd-server --config=~/.config/swayosd/style.css >/dev/null 2>&1 &
swaync >/dev/null 2>&1 &
swayidle -w timeout 150 hyprlock -f -c 000000 timeout 600 niri msg action power-off-monitors resume niri msg action power-on-monitors before-sleep hyprlock -f -c 000000 >/dev/null 2>&1 &

# Default Wallpaper
sleep 1 # wait one second before putting the default wallpaper
awww img ~/Pictures/Wallpapers/0anime4.jpg
