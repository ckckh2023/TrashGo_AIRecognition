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
    title: qsTr("智能识别系统")

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

            // ==================== 侧边栏 ====================
            Rectangle {
                id: sidebar
                width: 200
                height: parent.height
                color: "#2c3e50"

                Column {
                    anchors.fill: parent
                    spacing: 0

                    // Logo 区域
                    Rectangle {
                        width: parent.width
                        height: 80
                        color: "#1a252f"

                        Text {
                            anchors.centerIn: parent
                            text: "智能识别系统"
                            font.pixelSize: 18
                            font.bold: true
                            color: "white"
                        }
                    }

                    // 人脸检测按钮
                    Rectangle {
                        width: parent.width
                        height: 50
                        color: currentTab === 0 ? "#3498db" : "transparent"

                        Row {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "👤"
                                font.pixelSize: 20
                            }
                            Text {
                                text: "人脸检测"
                                font.pixelSize: 14
                                color: "white"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: currentTab = 0
                        }
                    }

                    // 垃圾分类按钮
                    Rectangle {
                        width: parent.width
                        height: 50
                        color: currentTab === 1 ? "#3498db" : "transparent"

                        Row {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "🗑️"
                                font.pixelSize: 20
                            }
                            Text {
                                text: "垃圾分类"
                                font.pixelSize: 14
                                color: "white"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: currentTab = 1
                        }
                    }

                    // 历史记录按钮
                    Rectangle {
                        width: parent.width
                        height: 50
                        color: currentTab === 2 ? "#3498db" : "transparent"

                        Row {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "📋"
                                font.pixelSize: 20
                            }
                            Text {
                                text: "历史记录"
                                font.pixelSize: 14
                                color: "white"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: currentTab = 2
                        }
                    }
                }
            }

            // ==================== 主内容区 ====================
            StackLayout {
                width: parent.width - sidebar.width
                height: parent.height
                currentIndex: currentTab

                // ========== 页面0: 人脸检测 ==========
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

                            // 按钮区域
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

                            // 结果显示
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

                // ========== 页面1: 垃圾分类 ==========
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
                                              ? "置信度: " + (garbageClassifier.confidence * 100).toFixed(1) + "%"
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

                // ========== 页面2: 历史记录 ==========
                Item {
                    Rectangle {
                        anchors.fill: parent
                        color: "#f5f5f5"

                        Column {
                            anchors.centerIn: parent
                            spacing: 20

                            Text {
                                text: "历史记录"
                                font.pixelSize: 24
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "功能开发中..."
                                font.pixelSize: 16
                                color: "#666"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
        }
    }

    // ==================== 文件对话框 ====================
    FileDialog {
        id: fileDialogFaces
        title: "选择图片"
        nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.bmp)"]
        onAccepted: {
            var filePath = selectedFile.toString();
            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);
            console.log("人脸检测 - 文件路径:", filePath);
            imageProcessor.loadImage(filePath);
        }
    }

    FileDialog {
        id: fileDialogTrash
        title: "选择垃圾图片"
        nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.bmp)"]
        onAccepted: {
            var filePath = selectedFile.toString();
            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);
            console.log("垃圾分类 - 文件路径:", filePath);
            garbageClassifier.loadImage(filePath);
        }
    }

    // ==================== 消息对话框 ====================
    Dialog {
        id: messageDialog
        parent: Overlay.overlay
        modal: true
        title: "系统消息"
        standardButtons: Dialog.Ok
        anchors.centerIn: parent

        function show(msg) {
            messageLabel.text = msg
            open()
        }

        contentItem: Label {
            id: messageLabel
            text: ""
            wrapMode: Text.WordWrap
        }
    }

    // ==================== 信号连接 ====================
    Connections {
        target: imageProcessor
        function onImageChanged() { imageRevisionFaces++ }
        function onMessageSent(msg) { messageDialog.show(msg) }
    }

    Connections {
        target: garbageClassifier
        function onImageChanged() { imageRevisionTrash++ }
        function onMessageSent(msg) { messageDialog.show(msg) }
    }
}
