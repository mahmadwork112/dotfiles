import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

PanelWindow {
    id: window

    required property string activeMode
    required property real volume
    required property bool muted
    required property real brightness
    required property bool capsLockState
    required property bool fnLockState
    required property bool micMuted

    readonly property color colBgMain:       "#162022"
    readonly property color colBorderMain:   "#2d5855"
    readonly property color colIconText:     "#eba37b"
    readonly property color colProgressBg:   "#1b3230"
    readonly property color colProgressFill: "#e56b6f"
    readonly property color colDisabledText: "#8da399"

    anchors.bottom: true
    margins.bottom: screen.height / 5
    exclusiveZone: 0

    implicitWidth: 200
    implicitHeight: 50
    color: "transparent"

    mask: Region {}

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: window.colBgMain
        border.color: window.colBorderMain
        border.width: 1

        RowLayout {
            anchors {
                fill: parent
                leftMargin: 12
                rightMargin: 12
            }
            spacing: 10

            // Dynamic Icon
            Text {
                color: window.colIconText
                font.pixelSize: 20

                text: {
                    if (window.activeMode === "volume") {
                        if (window.muted || window.volume <= 0.0) return "󰝟";
                        if (window.volume < 0.33) return "󰕿";
                        if (window.volume < 0.66) return "󰖀";
                        return "";
                    } else if (window.activeMode === "brightness") {
                        if (window.brightness < 0.33) return "󰃞";
                        if (window.brightness < 0.66) return "󰃟";
                        return "󰃠";
                    } else if (window.activeMode === "capslock") {
                        return window.capsLockState ? "󰘲" : "󰬈";
                    } else if (window.activeMode === "fnlock") {
                        return window.fnLockState ? "󰌆" : "󰌏";
                    } else if (window.activeMode === "micmute") {
                        return window.micMuted ? "󰍭" : "󰍬";
                    }
                    return "";
                }
            }

            // Level Bar / Status Text Container
            Item {
                Layout.fillWidth: true
                implicitHeight: 24

                // Container for Volume & Brightness (Bar + Percentage Text)
                RowLayout {
                    anchors.fill: parent
                    spacing: 8
                    visible: window.activeMode === "volume" || window.activeMode === "brightness"

                    // Progress Bar
                    Rectangle {
                        Layout.fillWidth: true
                        height: 8
                        radius: 4
                        color: window.colProgressBg

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            implicitWidth: {
                                let val = window.activeMode === "volume" ? window.volume : window.brightness;
                                return parent.width * Math.min(1.0, Math.max(0.0, val));
                            }
                            radius: parent.radius
                            color: window.colProgressFill
                        }
                    }

                    // Percentage Text Label
                    Text {
                        color: window.colIconText
                        font.pixelSize: 11
                        font.bold: true
                        Layout.preferredWidth: 32
                        horizontalAlignment: Text.AlignRight

                        text: {
                            let val = window.activeMode === "volume" ? window.volume : window.brightness;
                            return Math.round(Math.min(1.0, Math.max(0.0, val)) * 100) + "%";
                        }
                    }
                }

                // Text Status for Toggles (Caps Lock, Fn Lock, Mic Mute)
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: window.colIconText
                    font.pixelSize: 13
                    font.bold: true
                    visible: window.activeMode === "capslock" || window.activeMode === "fnlock" || window.activeMode === "micmute"

                    text: {
                        if (window.activeMode === "capslock") {
                            return "Caps Lock: " + (window.capsLockState ? "ON" : "OFF");
                        } else if (window.activeMode === "fnlock") {
                            return "Fn Lock: " + (window.fnLockState ? "ON" : "OFF");
                        } else if (window.activeMode === "micmute") {
                            return "Mic: " + (window.micMuted ? "MUTED" : "UNMUTED");
                        }
                        return "";
                    }
                }
            }
        }
    }
}