import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    signal changed()

    property bool state: false
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
        command: ["sh", "-c", "cat /sys/class/leds/*capslock*/brightness /sys/class/leds/*caps_lock*/brightness 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                if (text === undefined || text === null) return;
                let active = text.includes("1");

                if (root.initialized) {
                    if (root.state !== active) {
                        root.state = active;
                        root.changed();
                    }
                } else {
                    root.state = active;
                    root.initialized = true;
                }
            }
        }
    }
}