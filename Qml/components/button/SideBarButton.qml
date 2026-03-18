import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Imagine
import Qt5Compat.GraphicalEffects

import "../animation"

Button {
    id: root
    clip: true
    width: parent ? parent.width - 20 : 0
    height: parent ? 48 : 0
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: 12
        }
    }

    background: Rectangle {
        border.width: 0
        implicitWidth: parent ? parent.width : 0
        implicitHeight: parent ? parent.height : 0
        radius: 12
        color: {
            if (root.highlighted) return "#d0e2f6"
            if (root.pressed)     return "#dadada"
            if (root.hovered)     return "#ebebeb"
            return "#00ffffff"
        }

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    TapHandler {
        onPressedChanged: {
            if (pressed) {
                var pointInRoot = mapToItem(root, point.position)
                createRipple(pointInRoot)
                root.clicked()
            }
        }
    }

    function createRipple(point) {
        var component = Qt.createComponent("../animation/CustomizeRipple.qml")
        var diagonal = Math.sqrt(root.width * root.width + root.height * root.height)
        var maxScale = diagonal / 2
        var ripple = component.createObject(root, {
                                                center: point,
                                                maxScale: maxScale,
                                                duration: 400
                                            })
    }

    contentItem: RowLayout {
        spacing: 12
        anchors.fill: parent
        anchors.margins: 8

        Image {
            source: root.icon.source
            width: 32
            height: 32
        }
        FontLoader {
            id: customFont
            source: "file:///" + appDirPath + "/fonts/FZPinShangHei.ttf"
        }

        Text {
            text: root.text
            color: "#030303"
            font.pixelSize: 18
            font.family: customFont.name
            font.letterSpacing: 1
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
