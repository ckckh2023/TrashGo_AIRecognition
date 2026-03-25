import QtQuick 2.15
import QtQuick.Controls

import "../button"

Item {
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        StandardButton {
            width: parent.width / 2 - 30
            height: parent.height / 2 - 30
            text: "暂时不知道放什么内容，放个按钮占位"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 20
            anchors.topMargin: 20
        }

        StandardButton {
            width: parent.width / 2 - 30
            height: parent.height / 2 - 30
            text: "暂时不知道放什么内容，放个按钮占位"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            anchors.bottomMargin: 20
        }

        StandardButton {
            width: parent.width / 2 - 30
            height: parent.height - 40
            text: "暂时不知道放什么内容，放个按钮占位"
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
        }
    }
}
