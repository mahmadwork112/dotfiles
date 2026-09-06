import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Scope {
    id: root

    Process {
        id: muteProcess
        command: [
            "fish", "-c",
            "set -l win (hyprctl activewindow -j); " +
            "set -l pid (echo $win | jq -r '.pid'); " +
            "set -l title (echo $win | jq -r '.title'); " +
            "if test -n \"$pid\" -a \"$pid\" != \"null\"; " +
            "  set -l pids (pstree -p $pid | grep -oP '\\(\\K[0-9]+(?=\\))'); " +
            "  set -l streams; " +
            "  for p in $pids; " +
            "    set -l found (pactl list sink-inputs | awk -v p=\"$p\" '/^Sink Input #/ {id=substr($3, 2)} /application.process.id =/ {if ($3 == \"\\\"\"p\"\\\"\") print id}'); " +
            "    set streams $streams $found; " +
            "  end; " +
            "  for s in $streams; pactl set-sink-input-mute $s toggle; end; " +
            "  set -l first_stream (echo $streams | awk '{print $1}'); " +
            "  set -l muted (pactl list sink-inputs | awk -v target=\"$first_stream\" '/^Sink Input #/ {id=substr($3, 2); active=(id==target)} active && /Mute:/ {print $2}'); " +
            "  if test \"$muted\" = \"yes\"; " +
            "    notify-send -a 'MuteWindow' -i audio-volume-muted 'Muted' \"$title\"; " +
            "  else; " +
            "    notify-send -a 'MuteWindow' -i audio-volume-high 'Unmuted' \"$title\"; " +
            "  end; " +
            "end"
        ]
    }

    function toggleActiveMute() {
        console.log("[MuteWindow Service] Toggling mute for active window")
        muteProcess.running = true
    }

    IpcHandler {
        target: "muteWindow"

        function toggle(): void {
            root.toggleActiveMute()
        }
    }

    GlobalShortcut {
        name: "mute_active_window"
        description: "Toggles mute for active window"
        onPressed: root.toggleActiveMute()
    }
}
