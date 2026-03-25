import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import "components/button"
import "components/pages"

ApplicationWindow {
    ListModel { id: historyModel }
    width: 1280
    height: 810
    visible: true
    title: qsTr("TrashGo信息识别")

    property int imageRevisionFaces: 0
    property int imageRevisionTrash: 0
    property int currentTab: 0

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f0f4fe" }
            GradientStop { position: 1.0; color: "#def0f7" }
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
                color: "#80ffffff"

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 0

                    Image {
                        id: logo
                        width: 210
                        height: 73
                        fillMode: Image.PreserveAspectFit
                        source: "/icons/images/TrashGo.png"
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
                        color: "#cecece"
                    }

                    Rectangle {
                        width: parent.width
                        height: 12
                        color: "transparent"
                    }

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

                    SideBarButton {
                        text: "垃圾分类"
                        icon.source: "/icons/images/classify.png"
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
                        icon.source: "/icons/images/history.png"
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
                        icon.source: "/icons/images/star.png"
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
                        icon.source: "/icons/images/function.png"
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
                        icon.source: "/icons/images/settings.png"
                        icon.color: "transparent"
                        highlighted: currentTab === 5
                        onClicked: currentTab = 5
                    }
                }

                Rectangle {
                    width: 1
                    height: parent.height
                    color: "#ececec"
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
                        color: "#80ffffff"

                        Item {
                            width: parent.width - 80
                            height: parent.height - 36
                            anchors.centerIn: parent

                            Text {
                                text: {
                                    if (currentTab === 0) return "首页"
                                    else if (currentTab === 1) return "垃圾分类"
                                    else if (currentTab === 2) return "历史记录"
                                    else if (currentTab === 3) return "收藏夹"
                                    else if (currentTab === 4) return "更多功能"
                                    else if (currentTab === 5) return "设置"
                                    else return ""
                                }
                                color: "#030303"
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
                            // else if (currentTab === 2) return "components/pages/HistoryPage.qml"
                            // else if (currentTab === 3) return "components/pages/StarPage.qml"
                            // else if (currentTab === 4) return "components/pages/MorePage.qml"
                            else if (currentTab === 5) return "components/pages/SettingPage.qml"
                            else return ""   // 空字符串表示不加载任何组件
                        }

                        // 可选：启用异步加载，避免界面卡顿
                        asynchronous: true
                    }
                }
            }
        }
    }
}
