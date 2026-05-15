import QtQuick
import QtQuick.Controls
import "../control"
import "../theme"

Window {
    id: aboutWindow
    width: 400
    height: 340
    visible: false
    color: "transparent"
    title: qsTr("关于我们")

    property Theme theme: Theme {}

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: aboutWindow.theme.opaqueCard
        border.width: 1
        border.color: aboutWindow.theme.barBorderColor

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
                source: "/icons/assets/images/TrashGo" + (aboutWindow.theme.themeSet === "明亮" ? "" : "_dark") + ".png"
                width: 170
                height: 60
                fillMode: Image.PreserveAspectFit
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "版本 " + gitHubOnline.getCurrentVersion()
                font.pixelSize: 14
                color: aboutWindow.theme.text
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "基于 Qt 6.10 / OpenCV / ONNX 构建"
                font.pixelSize: 12
                color: aboutWindow.theme.secondaryText
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                width: 240
                height: 1
                color: aboutWindow.theme.barBorderColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 16

                StandardButton {
                    width: 120
                    height: 36
                    text: "检查更新"
                    radius: 18
                    bgcolor: aboutWindow.theme.card
                    onClicked: gitHubOnline.checkNewVersion()
                }

                StandardButton {
                    width: 120
                    height: 36
                    text: "下载安装包"
                    radius: 18
                    bgcolor: aboutWindow.theme.card
                    onClicked: gitHubOnline.openReleasePage()
                }
            }
        }
    }

    // ── 更新检查结果 ──
    Connections {
        target: gitHubOnline
        function onReleaseChecked(hasNew) {
            if (hasNew) Qt.application.toastManager.showToast("发现新版本: " + gitHubOnline.getLastestVersion(), "info")
            else Qt.application.toastManager.showToast("已是最新版本", "info")
        }
        function onMessageSentInfo(msg) {
            Qt.application.toastManager.showToast(msg, "info")
        }
        function onMessageSentError(msg) {
            Qt.application.toastManager.showToast(msg, "error")
        }
    }
}
