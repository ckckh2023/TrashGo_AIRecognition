import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

Button {
    id: root
    clip: true

    background: Rectangle {
        border.width: 0
        implicitWidth: parent ? parent.width : 0
        implicitHeight: parent ? parent.height : 0
        radius: 12
        color: {
            if (root.hovered) return "#e5e5e5"
            return "#ffffff"
        }

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    contentItem: Text {
        text: root.text
        color: "#030303"
        font.pixelSize: 18
        font.letterSpacing: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
