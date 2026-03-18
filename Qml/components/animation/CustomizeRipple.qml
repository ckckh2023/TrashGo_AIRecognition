import QtQuick 2.15

Item {
    id: root

    property point center: Qt.point(0, 0)
    property color color: "#80555555"
    property real maxScale: 2.0
    property int duration: 500

    Rectangle {
        id: ripple
        width: 4
        height: 4
        radius: width / 2
        color: root.color
        opacity: 0.8
        x: root.center.x - width / 2
        y: root.center.y - height / 2
        scale: 0

        NumberAnimation on scale {
            from: 0
            to: root.maxScale
            duration: root.duration
            easing.type: Easing.OutQuad
        }

        NumberAnimation on opacity {
            from: 0.8
            to: 0
            duration: root.duration
            easing.type: Easing.OutQuad
        }

        onOpacityChanged: if (opacity === 0) root.destroy()
    }
}
