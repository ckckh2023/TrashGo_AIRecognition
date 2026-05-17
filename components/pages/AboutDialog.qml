import QtQuick
import QtQuick.Controls

import "../control"
import "../theme"

Popup {
    id: root
    width: 510
    height: 340
    modal: true
    dim: true
    parent: Overlay.overlay
    anchors.centerIn: parent
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 220; easing.type: Easing.OutCubic }
        NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: 220; easing.type: Easing.OutCubic }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; to: 0; duration: 150; easing.type: Easing.InCubic }
        NumberAnimation { property: "scale"; to: 0.95; duration: 150; easing.type: Easing.InCubic }
    }

    property Theme theme: Theme {}
    property bool hasNewVersion: false

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
            spacing: 20

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20

                Image {
                    source: "/icons/assets/images/TrashGo" + (root.theme.themeSet === "明亮" ? "" : "_dark") + ".png"
                    width: 170
                    height: 60
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: {
                        if (Qt.platform.os === "windows") return "版本 " + gitHubOnline.getCurrentVersion() + " for Windows"
                        else if (Qt.platform.os === "linux") return "版本 " + gitHubOnline.getCurrentVersion() + " for Linux"
                    }
                    font.pixelSize: 14
                    color: root.theme.text
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6

                Text {
                    text: "Powered by"
                    font.pixelSize: 12
                    color: root.theme.secondaryText
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    source: "/about/assets/images/Qticon.png"
                    width: 16
                    height: 16
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "6.10.3"
                    font.pixelSize: 12
                    color: root.theme.secondaryText
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "&"
                    font.pixelSize: 12
                    color: root.theme.secondaryText
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    source: "/about/assets/images/OpenCVicon.png"
                    width: 16
                    height: 16
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "4.12.0"
                    font.pixelSize: 12
                    color: root.theme.secondaryText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                Image {
                    source: "/about/assets/images/GitHubicon.svg"
                    width: 20
                    height: 20
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: gitHubOnline.openOfficalPage("GitHub")
                    }
                }

                Text {
                    text: "GitHub"
                    font.pixelSize: 12
                    color: root.theme.secondaryText
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: gitHubOnline.openOfficalPage("GitHub")
                    }
                }

                Text {
                    text: "|"
                    font.pixelSize: 12
                    color: root.theme.barBorderColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                Image {
                    source: "/about/assets/images/Giteeicon.svg"
                    width: 20
                    height: 20
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: gitHubOnline.openOfficalPage("Gitee")
                    }
                }

                Text {
                    text: "Gitee"
                    font.pixelSize: 12
                    color: root.theme.secondaryText
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: gitHubOnline.openOfficalPage("Gitee")
                    }
                }
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
                    text: root.hasNewVersion ? "下载安装包" : "检查更新"
                    radius: 12
                    bgcolor: String(root.theme.card).slice(3,10)
                    onClicked: {
                        if (root.hasNewVersion) gitHubOnline.openReleasePage()
                        else gitHubOnline.checkNewVersion()
                    }
                }
            }

            Text {
                visible: root.hasNewVersion
                text: "新版本 " + gitHubOnline.getLastestVersion() + " 等待下载"
                font.pixelSize: 12
                color: root.theme.secondaryText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Connections {
        target: gitHubOnline
        function onReleaseChecked(hasNew) {
            if (hasNew) {
                root.hasNewVersion = true
                Qt.application.toastManager.showToast("发现新版本: " + gitHubOnline.getLastestVersion(), "info")
            }
            else {
                Qt.application.toastManager.showToast("已是最新版本！", "info")
            }
        }
        function onMessageSentInfo(msg) {
            Qt.application.toastManager.showToast(msg, "info")
        }
        function onMessageSentError(msg) {
            Qt.application.toastManager.showToast(msg, "error")
        }
    }
}