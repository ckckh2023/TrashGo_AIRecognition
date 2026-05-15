import QtQuick
import QtQuick.Controls

import "../control"
import "../theme"

Popup {
    id: root
    width: 400
    height: 340
    modal: true
    dim: true
    parent: Overlay.overlay
    anchors.centerIn: parent
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property Theme theme: Theme {}

    background: Rectangle {
        anchors.fill: parent
        radius: 10
        color: root.theme.opaqueCard
        border.width: 1
        border.color: root.theme.barBorderColor

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: root.theme.backgroundTop }
                GradientStop { position: 1.0; color: root.theme.backgroundBottom }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root.theme.card
        }

        Rectangle {
            id: titleBar
            width: parent.width
            height: 44
            radius: 10
            color: "transparent"
        }

        Column {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            spacing: 12

            Image {
                source: "/icons/assets/images/TrashGo" + (root.theme.themeSet === "明亮" ? "" : "_dark") + ".png"
                width: 170
                height: 60
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "版本 " + gitHubOnline.getCurrentVersion()
                font.pixelSize: 14
                color: root.theme.text
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "基于 Qt 6.10 / OpenCV / ONNX 构建"
                font.pixelSize: 12
                color: root.theme.secondaryText
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 240
                height: 1
                color: root.theme.barBorderColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                StandardButton {
                    width: 120
                    height: 42
                    text: "检查更新"
                    radius: 12
                    bgcolor: String(root.theme.card).slice(3,10)
                    onClicked: gitHubOnline.checkNewVersion()
                }

                StandardButton {
                    width: 120
                    height: 42
                    text: "下载安装包"
                    radius: 12
                    bgcolor: String(root.theme.card).slice(3,10)
                    onClicked: gitHubOnline.openReleasePage()
                }
            }
        }


        Connections {
            target: gitHubOnline
            function onReleaseChecked(hasNew) {
                if (hasNew) Qt.application.toastManager.showToast("发现新版本: " + gitHubOnline.getLastestVersion(), "info")
                else Qt.application.toastManager.showToast("已是最新版本！", "info")
            }
            function onMessageSentInfo(msg) {
                Qt.application.toastManager.showToast(msg, "info")
            }
            function onMessageSentError(msg) {
                Qt.application.toastManager.showToast(msg, "error")
            }
        }
    }
}


