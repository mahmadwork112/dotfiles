#!/bin/bash
# 自启动脚本 仅作参考

set +e

# Start the browser
/home/ahmad/.tarball-installations/zen/zen

# some env can't auto run the portal, so need this
/usr/lib/xdg-desktop-portal-wlr >/dev/null 2>&1 &

# notify
swaync -c ~/.config/swaync/config.jsonc -s ~/.config/swaync/style.css >/dev/null 2>&1 &

# night light
# wlsunset -T 3501 -t 3500 >/dev/null 2>&1 &

# wallpaper
swaybg -i ~/Pictures/Wallpapers/basement.jpg >/dev/null 2>&1 &

# top bar
systemctl --user stop vibepanel.service
# waybar -c ~/.config/mango/waybar-simple/config.jsonc -s ~/.config/mango/waybar-simple/style.css >/dev/null 2>&1 &
waybar >/dev/null 2>&1 &

# xwayland dpi scale
echo "Xft.dpi: 140" | xrdb -merge #dpi缩放
# xrdb merge ~/.Xresources >/dev/null 2>&1

# ime input
fcitx5 --replace -d >/dev/null 2>&1 &

# keep clipboard content
wl-clip-persist --clipboard regular --reconnect-tries 0 >/dev/null 2>&1 &

# clipboard content manager
wl-paste --type text --watch cliphist store >/dev/null 2>&1 &

# bluetooth
blueman-applet >/dev/null 2>&1 &

# network
nm-applet >/dev/null 2>&1 &

# Permission authentication
systemctl --user start polkit-kde-agent.service

# inhibit by audio
sway-audio-idle-inhibit >/dev/null 2>&1 &

# change light value and volume value by swayosd-client in keybind
swayosd-server >/dev/null 2>&1 &
