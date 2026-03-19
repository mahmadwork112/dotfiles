#!/bin/bash

# --- 1. Environment & Cleanup ---
# Ensure the script knows where binaries are
export PATH=$PATH:/usr/local/bin:/usr/bin

# Kill any existing instances to prevent duplicates on niri reload
pkill waybar
pkill swaync
pkill swayosd-server
pkill wl-paste

# --- 2. The Portal "Dance" (Non-blocking) ---
# We background these (&) so they don't delay the rest of your desktop
systemctl --user stop xdg-desktop-portal-hyprland &
sleep 1
systemctl --user restart xdg-desktop-portal &

# --- 3. Background Services ---
systemctl --user start awww-daemon.service &
swaync &
swayosd-server &

# --- 4. Clipboard History ---
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# --- 5. UI Elements (Delayed) ---
# Giving Niri 1 second to fully initialize the Wayland socket
sleep 1

# IMPORTANT: Use the FULL PATH to your wallpaper, avoid using ~
awww img "/home/ahmad/Pictures/Wallpapers/0anime4.jpg" &
waybar &
