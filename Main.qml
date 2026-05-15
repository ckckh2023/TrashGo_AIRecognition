import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import "components/control"
import "components/pages"
import "components/message"
import "components/theme"

ApplicationWindow {
    id: root
    width: 1280
    minimumWidth: 1080
    height: 810
    minimumHeight: 680
    visible: true
    title: qsTr("TrashGo智识助手")

    property int imageRevisionFaces: 0
    property int imageRevisionTrash: 0
    property int currentTab: 1

    property Theme theme : Theme {}

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.theme.backgroundTop }
            GradientStop { position: 1.0; color: root.theme.backgroundBottom }
        }
    }

    Item {
        anchors.fill: parent

        Row {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                id: sidebar
                width: 240
                height: parent.height
                color: root.theme.bar

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 0

                    Image {
                        id: logo
                        width: 210
                        height: 73
                        fillMode: Image.Pad
                        source: "/icons/assets/images/TrashGo" + ( root.theme.themeSet === "明亮" ? "" : "_dark" ) + ".png"

                        property bool showAbout: false

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                    aboutLoader.active = true
                                    var popup = aboutLoader.item
                                    if (popup) popup.open()
                                }
                        }

                        Loader {
                            id: aboutLoader
                            source: "components/pages/AboutDialog.qml"
                            asynchronous: true
                            active: false
                            onLoaded: {
                                item.open()
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 12
                        color: "transparent"
                    }

                    Rectangle {
                        width: parent.width - 30
                        height: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: root.theme.barBorderColor
                    }

                    Rectangle {
                        width: parent.width
                        height: 12
                        color: "transparent"
                    }
/*
                    SideBarButton {
                        text: "首页"
                        icon.source: "/icons/images/home.png"
                        icon.color: "transparent"
                        highlighted: currentTab === 0
                        onClicked: currentTab = 0
                    }

                    Rectangle {
                        width: parent.width
                        height: 8
                        color: "transparent"
                    }
*/
                    SideBarButton {
                        text: "垃圾分类"
                        icon.source: "/icons/assets/images/classify.png"
                        icon.color: "transparent"
                        highlighted: currentTab === 1
                        onClicked: currentTab = 1
                    }

                    Rectangle {
                        width: parent.width
                        height: 8
                        color: "transparent"
                    }

                    SideBarButton {
                        text: "历史记录"
                        icon.source: "/icons/assets/images/history.png"
                        icon.color: "transparent"
                        highlighted: currentTab === 2
                        onClicked: currentTab = 2
                    }

                    Rectangle {
                        width: parent.width
                        height: 8
                        color: "transparent"
                    }

                    SideBarButton {
                        text: "收藏夹"
                        icon.source: "/icons/assets/images/star.png"
                        icon.color: "transparent"
                        highlighted: currentTab === 3
                        onClicked: currentTab = 3
                    }

                    Rectangle {
                        width: parent.width
                        height: 8
                        color: "transparent"
                    }


                    SideBarButton {
                        text: "更多功能"
                        icon.source: "/icons/assets/images/function.png"
                        icon.color: "transparent"
                        highlighted: currentTab === 4
                        onClicked: currentTab = 4
                    }

                    Rectangle {
                        width: parent.width
                        height: 8
                        color: "transparent"
                    }

                    SideBarButton {
                        text: "设置"
                        icon.source: "/icons/assets/images/settings.png"
                        icon.color: "transparent"
                        highlighted: currentTab === 5
                        onClicked: currentTab = 5
                    }
                }

                Rectangle {
                    width: 1
                    height: parent.height
                    color: root.theme.barBorderColor
                    anchors.right: parent.right
                }
            }

            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"

                Column {
                    anchors.fill: parent

                    Rectangle {
                        id: topbar
                        width: parent.width
                        height: 80
                        color: root.theme.bar

                        Item {
                            width: parent.width - 80
                            height: parent.height - 36
                            anchors.centerIn: parent

                            Text {
                                text: {
                                    /*if (currentTab === 0) return "首页"
                                    else*/ if (currentTab === 1) return "垃圾分类"
                                    else if (currentTab === 2) return "历史记录"
                                    else if (currentTab === 3) return "收藏夹"
                                    else if (currentTab === 4) return "更多功能"
                                    else if (currentTab === 5) return "设置"
                                    else return ""
                                }
                                color: root.theme.text
                                font.family: "Microsoft YaHei"
                                font.pixelSize: 36
                                font.weight: Font.DemiBold
                                font.letterSpacing: 4
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    Loader {
                        id: pageLoader
                        width: parent.width - sidebar.width
                        height: parent.height - topbar.height
                        source: {
                            if (currentTab === 0) return "components/pages/HomePage.qml"
                            else if (currentTab === 1) return "components/pages/GarbagePage.qml"
                            else if (currentTab === 2) return "components/pages/HistoryPage.qml"
                            else if (currentTab === 3) return "components/pages/StarPage.qml"
                            // else if (currentTab === 4) return "components/pages/MorePage.qml"
                            else if (currentTab === 5) return "components/pages/SettingPage.qml"
                            else return ""
                        }
                        asynchronous: true
                    }
                }
            }
        }
    }

    //吐司管理器
    Item {
        id: toastManager
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        width: 300
        height: parent.height

        ListView {
            id: toastListView
            anchors.fill: parent
            spacing: 8
            model: ListModel { id: toastModel }
            interactive: false
            delegate: Toast {
                text: model.text
                type: model.type
                onClosed: toastModel.remove(index)
            }

            onModelChanged: {
                if (toastModel.count > 0)
                    contentY = 0
            }
        }

        function showToast(message, type) {
            toastModel.insert(0, { "text": message, "type": type })
        }
    }

    Component.onCompleted: {
        Qt.application.toastManager = toastManager
    }

    AboutDialog {
        id: aboutDialog
    }
}
