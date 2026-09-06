import QtQuick
import Quickshell

Scope {
    id: root

    property string activeMode: "volume"
    property bool shouldShowOsd: false

    // System Feature Modules
    Volume {
        id: volumeService
        onChanged: triggerOsd("volume")
    }

    Brightness {
        id: brightnessService
        onChanged: triggerOsd("brightness")
    }

    CapsLock {
        id: capsLockService
        onChanged: triggerOsd("capslock")
    }

    FnLock {
        id: fnLockService
        onChanged: triggerOsd("fnlock")
    }

    MicMute {
        id: micMuteService
        onChanged: triggerOsd("micmute")
    }

    function triggerOsd(mode) {
        root.activeMode = mode;
        root.shouldShowOsd = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 1000
        onTriggered: root.shouldShowOsd = false
    }

    // Lazy load the OSD Window only when visible
    LazyLoader {
        active: root.shouldShowOsd

        Osd {
            activeMode: root.activeMode
            volume: volumeService.level
            muted: volumeService.muted
            brightness: brightnessService.level
            capsLockState: capsLockService.state
            fnLockState: fnLockService.state
            micMuted: micMuteService.muted
        }
    }
}