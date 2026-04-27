import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Imagine
import Qt5Compat.GraphicalEffects

import "../animation"
import "../theme"

Button {
    id: root
    clip: true
    width: parent ? parent.width - 20 : 0
    height: parent ? 48 : 0
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined

    property Theme theme : Theme {}

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
            if (root.highlighted) return root.theme.sideBarButton
            return root.theme.defaultTransparentColor
        }

        Rectangle {
            anchors.fill: parent
            color: {
                if (root.pressed) return "#50808080"
                if (root.hovered) return "#30808080"
                return root.theme.defaultTransparentColor
            }
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

    contentItem: Item {
        anchors.fill: parent
        anchors.margins: 8

        Image {
            id: icon
            source: root.icon.source
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            width: 32
            height: 32
        }

        FontLoader {
            id: customFont
            source: "file:///" + appDirPath + "/fonts/FZPinShangHei.ttf"
        }

        Text {
            text: root.text
            color: root.theme.text
            font.pixelSize: 18
            font.family: customFont.name
            font.letterSpacing: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: icon.right
            anchors.leftMargin: 25
        }
    }
}
