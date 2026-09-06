import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    signal changed()

    property real level: 0.0
    property bool initialized: false

    Timer {
        interval: 150
        running: true
        repeat: true
        onTriggered: {
            if (!fetch.running) fetch.running = true;
        }
    }

    Process {
        id: fetch
        command: ["brightnessctl", "i", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text) return;
                let parts = text.trim().split(",");
                if (parts.length >= 4) {
                    let val = (parseFloat(parts[3].replace("%", "")) || 0) / 100.0;
                    if (root.initialized && Math.abs(root.level - val) > 0.005) {
                        root.level = val;
                        root.changed();
                    } else {
                        root.level = val;
                    }
                    root.initialized = true;
                }
            }
        }
    }
}