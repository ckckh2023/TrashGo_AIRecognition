import QtQuick 2.15
import QtQuick.Controls

import "../button"

Item {
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        StandardButton {
            width: parent.width / 2 - 45
            height: parent.height / 2 - 45
            text: "暂时不知道放什么内容，放个按钮占位"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 30
            anchors.topMargin: 30
        }

        StandardButton {
            width: parent.width / 2 - 45
            height: parent.height / 2 - 45
            text: "暂时不知道放什么内容，放个按钮占位"
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 30
            anchors.bottomMargin: 30
        }

        StandardButton {
            width: parent.width / 2 - 45
            height: parent.height - 60
            text: "暂时不知道放什么内容，放个按钮占位"
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 30
            anchors.bottomMargin: 30
        }
    }
}
