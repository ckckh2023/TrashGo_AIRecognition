import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../theme"

Button {
    id: root
    clip: true

    property double radius: 12
    property string bgcolor: root.theme.opaqueCard

    property Theme theme : Theme {}

    background: Rectangle {
        border.width: 0
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: root.radius
        color: "#c0" + root.bgcolor

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: {
                if (root.hovered) return "#80808080"
                else return "#00" + root.bgcolor
            }

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    contentItem: Text {
        text: root.text
        color: root.theme.text
        font.pixelSize: 18
        font.letterSpacing: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
