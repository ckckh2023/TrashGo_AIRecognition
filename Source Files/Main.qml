import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl 2.15

ApplicationWindow {
    width: 1080
    height: 720
    visible: true
    title: qsTr("人脸检测程序")

    Material.theme: Material.Light
    Material.accent: Material.Indigo

    property int imageRevisionFaces: 0
    property int imageRevisionTrash: 0
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
                        text: "垃圾分类"
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

                    Button {
                        width: parent.width - 20
                        height: 60
                        text: "更多功能"
                        highlighted: currentTab === 3
                        onClicked: currentTab = 3
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
                    Rectangle {
                    anchors.fill: parent
                    color: "#f5f5f5"

                        Column {
                            anchors.centerIn: parent
                            spacing: 20

                            Text {
                                text: "人脸检测"
                                font.pixelSize: 24
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Rectangle {
                                width: 500
                                height: 400
                                color: "white"
                                radius: 8
                                border.color: "#ddd"
                                border.width: 1
                                anchors.horizontalCenter: parent.horizontalCenter

                                Image {
                                    id: faceImage
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    fillMode: Image.PreserveAspectFit
                                    source: "image://result/face?" + imageRevisionFaces
                                    cache: false
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "请选择图片"
                                    color: "#999"
                                    visible: faceImage.status !== Image.Ready
                                }
                            }

                            Row {
                                spacing: 15
                                anchors.horizontalCenter: parent.horizontalCenter

                                Button {
                                    text: "选择图片"
                                    icon.name: "folder-open"
                                    onClicked: fileDialogFaces.open()
                                }

                                Button {
                                    text: "开始检测"
                                    icon.name: "search"
                                    highlighted: true
                                    onClicked: imageProcessor.detectFaces()
                                }
                            }

                            Rectangle {
                                width: 300
                                height: 50
                                radius: 8
                                color: "#e8f5e9"
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    anchors.centerIn: parent
                                    text: "检测到人脸数量: " + imageProcessor.faceCount
                                    font.pixelSize: 16
                                    color: "#2e7d32"
                                }
                            }
                        }
                    }
                }

                Item {
                    Rectangle {
                        anchors.fill: parent
                        color: "#f5f5f5"

                        Column {
                            anchors.centerIn: parent
                            spacing: 20

                            Text {
                                text: "垃圾分类识别"
                                font.pixelSize: 24
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            // 图片显示区域
                            Rectangle {
                                width: 500
                                height: 400
                                color: "white"
                                radius: 8
                                border.color: "#ddd"
                                border.width: 1
                                anchors.horizontalCenter: parent.horizontalCenter

                                Image {
                                    id: trashImage
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    fillMode: Image.PreserveAspectFit
                                    source: "image://result/trash?" + imageRevisionTrash
                                    cache: false
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "请选择垃圾图片"
                                    color: "#999"
                                    visible: trashImage.status !== Image.Ready
                                }
                            }

                            // 按钮区域
                            Row {
                                spacing: 15
                                anchors.horizontalCenter: parent.horizontalCenter

                                Button {
                                    text: "选择图片"
                                    icon.name: "folder-open"
                                    onClicked: fileDialogTrash.open()
                                }

                                Button {
                                    text: "开始识别"
                                    highlighted: true
                                    onClicked: garbageClassifier.classify()
                                }
                            }

                            // 分类结果显示
                            Rectangle {
                                width: 350
                                height: 80
                                radius: 8
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: {
                                    var type = garbageClassifier.garbageType
                                    if (type.indexOf("可回收") >= 0) return "#2196F3"
                                    else if (type.indexOf("有害") >= 0) return "#f44336"
                                    else if (type.indexOf("厨余") >= 0) return "#4CAF50"
                                    else if (type.indexOf("其他") >= 0) return "#9E9E9E"
                                    else return "#E0E0E0"
                                }

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 5

                                    Text {
                                        text: garbageClassifier.garbageType || "等待识别..."
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "white"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Text {
                                        text: garbageClassifier.confidence > 0
                                              ? "置信度: " + (garbageClassifier.confidence * 10).toFixed(2) + "%"
                                              : ""
                                        font.pixelSize: 14
                                        color: "white"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }

                            // 分类说明
                            Row {
                                spacing: 10
                                anchors.horizontalCenter: parent.horizontalCenter

                                Repeater {
                                    model: [
                                        {color: "#2196F3", text: "可回收"},
                                        {color: "#f44336", text: "有害"},
                                        {color: "#4CAF50", text: "厨余"},
                                        {color: "#9E9E9E", text: "其他"}
                                    ]

                                    Rectangle {
                                        width: 80
                                        height: 30
                                        radius: 4
                                        color: modelData.color

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.text
                                            color: "white"
                                            font.pixelSize: 12
                                        }
                                    }
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
        id: fileDialogFaces
        title: "选择图片"
        nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.bmp)"]
        onAccepted: {
            var filePath = selectedFile.toString();

            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);

            console.log("人脸识别 - 文件路径:", filePath);
            imageProcessor.loadImage(filePath);
        }
    }

    FileDialog {
        id: fileDialogTrash
        title: "选择图片"
        nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.bmp)"]
        onAccepted: {
            var filePath = selectedFile.toString();
            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);
            console.log("垃圾分类 - 文件路径:", filePath);
            garbageClassifier.loadImage(filePath);
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
            imageRevisionFaces++;
        }
    }

    Connections {
        target: garbageClassifier

        function onMessageSent(msg) {
            messageDialog.show(msg)
        }

        function onImageChanged(){
            imageRevisionTrash++
        }
    }
}
