import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

ApplicationWindow {
    width: 1080
    height: 720
    visible: true
    title: qsTr("人脸检测程序")

    Material.theme: Material.Light
    Material.accent: Material.Indigo

    property int imageRevision: 0
    property int currentTab: 0

    Rectangle {
        anchors.fill: parent
        color: "#e0e0e0"
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
                color: "#f0f0f0"

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 0

                    Button {
                        width: parent.width - 20
                        height: 60
                        text: "首页"
                        highlighted: currentTab === 0
                        onClicked: currentTab = 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        background: Rectangle {
                            radius: 5
                            color: {
                                if (parent.highlighted) return "#d0e0fa"
                                if (parent.pressed)     return "#c0d0ea"
                                if (parent.hovered)     return "#e0e0e0"
                                return "#00ffffff"
                            }
                            Behavior on color { ColorAnimation { duration: 120 } }
                            Ripple {
                                clip: true
                                clipRadius: parent.radius
                                anchors.fill: parent
                                pressed: parent.parent.pressed
                                x: parent.parent.mouseX - width / 2
                                y: parent.parent.mouseY - height / 2
                                active: parent.parent.pressed
                                color: "#10000000"
                            }
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "#030303"
                            font.pixelSize: 18
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Button {
                        width: parent.width -20
                        height: 60
                        text: "人脸检测"
                        highlighted: currentTab === 1
                        onClicked: currentTab = 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        background: Rectangle {
                            radius: 5
                            color: {
                                if (parent.highlighted) return "#d0e0fa"
                                if (parent.pressed)     return "#c0d0ea"
                                if (parent.hovered)     return "#e0e0e0"
                                return "#00ffffff"
                            }
                            Behavior on color { ColorAnimation { duration: 120 } }
                            Ripple {
                                clip: true
                                clipRadius: parent.radius
                                anchors.fill: parent
                                pressed: parent.parent.pressed
                                active: parent.parent.pressed
                                color: "#10000000"
                            }
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "#030303"
                            font.pixelSize: 18
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Button {
                        width: parent.width - 20
                        height: 60
                        text: "更多功能"
                        highlighted: currentTab === 2
                        onClicked: currentTab = 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        background: Rectangle {
                            radius: 5
                            color: {
                                if (parent.highlighted) return "#d0e0fa"
                                if (parent.pressed)     return "#c0d0ea"
                                if (parent.hovered)     return "#e0e0e0"
                                return "#00ffffff"
                            }
                            Behavior on color { ColorAnimation { duration: 120 } }
                            Ripple {
                                clip: true
                                clipRadius: parent.radius
                                anchors.fill: parent
                                pressed: parent.parent.pressed
                                x: parent.parent.mouseX - width / 2
                                y: parent.parent.mouseY - height / 2
                                active: parent.parent.pressed
                                color: "#10000000"
                            }
                        }
                        contentItem: Text {
                            text: parent.text
                            color: "#030303"
                            font.pixelSize: 18
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }

            Rectangle {
                    width: 2
                    height: parent.height
                    color: "#ececec"
            }

            StackLayout {
                width: parent.width - sidebar.width
                height: parent.height
                currentIndex: currentTab

                Item {
                    Rectangle {
                        anchors.fill: parent
                        color: "#f0f0f0"
                        Text {
                            anchors.centerIn: parent
                            text: "当个首页看看得了"
                            font.pixelSize: 20
                            color: "#030303"
                        }
                    }
                }

                Item {
                    Rectangle{
                        anchors.fill: parent
                        color: "#f0f0f0"
                    }

                    ColumnLayout{
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 16

                        Text {
                            text: "👤人脸检测系统"
                            font.bold: true
                            font.pixelSize: 27
                            color: "#030303"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Row {
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter

                            Button {
                                text: "📁选择图片"
                                onClicked: fileDialog.open()
                                background: Rectangle {
                                    color: "#4CAF50"
                                    radius: 5
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 15
                                }
                            }

                            Button {
                                text: "🔍检测人脸"
                                onClicked: imageProcessor.detectFaces()
                                background: Rectangle {
                                    color: "#2196F3"
                                    radius: 5
                                }
                                contentItem: Text {
                                    text: parent.text
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 15
                                }
                            }
                        }

                        Rectangle {
                            width: parent.width
                            height: 40
                            color: "white"
                            radius: 5
                            border.color: "#ddd"

                            Text {
                                anchors.centerIn: parent
                                text: "检测到 " + imageProcessor.faceCount + " 张人脸"
                                font.pixelSize: 16
                                color: "#E91E63"
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "white"
                            radius: 5
                            border.color: "#ddd"

                            Image {
                                id: displayImage
                                anchors.fill: parent
                                anchors.margins: 10
                                source: "image://result/current?rev=" + imageRevision
                                fillMode: Image.PreserveAspectFit
                                cache : false

                                Text {
                                    visible: displayImage.status === Image.Null
                                    anchors.centerIn: parent
                                    text: "请先选择一张图片"
                                    color: "#999"
                                    font.pixelSize: 18
                                }
                            }
                        }
                    }
                }

                Item {
                    Rectangle{
                        anchors.fill: parent
                        color: "#f0f0f0"

                        Text{
                            anchors.centerIn: parent
                            text: "您看看这个侧边栏做的彳亍不彳亍"
                            font.pixelSize: 20
                            color: "#030303"
                        }
                    }
                }
            }
        }
    }
    FileDialog {
        id: fileDialog
        title: "选择图片"
        nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.bmp)"]
        onAccepted: {
            var filePath = fileDialog.selectedFile.toString();

            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);

            console.log("文件路径:", filePath);
            imageProcessor.loadImage(filePath);
        }
    }

    Dialog {
        id: messageDialog
        parent: Overlay.overlay
        modal: true
        title: "📬系统消息"
        standardButtons: Dialog.Ok

        anchors.centerIn: parent

        function show(msg) {
            contentItem.text = msg
            open()
        }

        contentItem: Label {
            id: messageLabel
            text: ""
            wrapMode: Text.WordWrap
        }

        enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 150 } }
        exit: Transition { NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150 } }
    }

    Connections {
        target: imageProcessor

        function onMessageSent(msg) {
            messageDialog.show(msg)
        }

        function onImageChanged() {
            imageRevision++;
        }
    }
}
