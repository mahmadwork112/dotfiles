import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: root

    signal changed()

    readonly property bool muted: Pipewire.defaultAudioSource?.audio.muted ?? false
    property bool initialized: false

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSource ]
    }

    Connections {
        target: Pipewire.defaultAudioSource?.audio

        function onMutedChanged() {
            if (!root.initialized) return;
            root.changed();
        }
    }

    Component.onCompleted: {
        root.initialized = true;
    }
}