import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import "components/button"
import "components/pages"

ApplicationWindow {
    ListModel { id: historyModel }
    width: 1080
    height: 720
    visible: true
    title: qsTr("TrashGo信息识别")

    property int imageRevisionFaces: 0
    property int imageRevisionTrash: 0
    property int currentTab: 0

    Rectangle {
        anchors.fill: parent
        color: "#ececec"
    }

    Item {
        anchors.fill: parent

        Row {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                id: sidebar
                width: 200
                height: parent.height
                color: "#f0f0f5"

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 0

                    Image {
                        id: logo
                        width: 64
                        height: 64
                        fillMode: Image.PreserveAspectFit
                        source: "/icons/images/icon_64.png"
                    }

                    SideBarButton {
                        text: "首页"
                        highlighted: currentTab === 0
                        onClicked: currentTab = 0
                    }

                    Rectangle {
                        width: parent.width
                        height: 12
                        color: "transparent"
                    }

                    SideBarButton {
                        text: "垃圾分类"
                        highlighted: currentTab === 1
                        onClicked: currentTab = 1
                    }

                    SideBarButton {
                        text: "更多功能"
                        highlighted: currentTab === 2
                        onClicked: currentTab = 2
                    }

                    SideBarButton {
                        text: "关于"
                        highlighted: currentTab === 3
                        onClicked: currentTab = 3
                    }
                }
            }

            Loader {
                id: pageLoader
                width: parent.width - sidebar.width   // 填充剩余宽度
                height: parent.height
                source: {
                    if (currentTab === 0) return "components/pages/HomePage.qml"
                    // 后续可添加其他 tab 对应的页面
                    // else if (currentTab === 1) return "components/pages/GarbagePage.qml"
                    // else if (currentTab === 2) return "components/pages/MorePage.qml"
                    // else if (currentTab === 3) return "components/pages/AboutPage.qml"
                    else return ""   // 空字符串表示不加载任何组件
                }

                // 可选：启用异步加载，避免界面卡顿
                asynchronous: true
            }
        }
    }
}
