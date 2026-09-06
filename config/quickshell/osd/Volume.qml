import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: root

    signal changed()

    readonly property real level: Pipewire.defaultAudioSink?.audio.volume ?? 0.0
    readonly property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? false

    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() { root.changed(); }
        function onMutedChanged() { root.changed(); }
    }
}