import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

ApplicationWindow {

    ListModel {id: historyModel}

    width: 1080
    height: 720
    visible: true
    title: qsTr("TrashGo信息识别")

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
                        text: "历史记录"
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

                    Button {
                        width: parent.width - 20
                        height: 60
                        text: "更多功能"
                        highlighted: currentTab === 4
                        onClicked: currentTab = 4
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
                                width: parent.parent.width - 200
                                height: parent.parent.height - 300
                                color: "white"
                                radius: 8
                                border.color: "#d0d0d0"
                                border.width: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                DropArea {
                                    anchors.fill: parent
                                    onEntered: (drag) => { if (drag.hasUrls) drag.accept() }
                                    onExited: {}
                                    onDropped: (drop) => {
                                        if (drop.hasUrls && drop.urls.length > 0) {
                                            var url = drop.urls[0];
                                            var filePath = url.toString();

                                            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
                                            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);

                                            console.log("拖拽文件路径:", filePath);
                                            imageProcessor.loadPath(filePath);
                                            imageProcessor.loadImage();
                                        }
                                        drop.accept();
                                    }
                                }

                                Image {
                                    id: faceImage
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    fillMode: Image.PreserveAspectFit
                                    source: imageProcessor.hasImage ? "image://result/face?" + imageRevisionFaces : ""
                                    cache: false
                                    visible: status === Image.Ready
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "请选择图片(拖拽至此或点击下方按钮)"
                                    font.pixelSize: 15
                                    color: "#090909"
                                    visible: !faceImage.visible
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
                                    highlighted: true
                                    onClicked: imageProcessor.detectFaces()
                                }

                                Button {
                                    text: "清除图片"
                                    highlighted: true
                                    onClicked: imageProcessor.clearImage()
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
                                    text: imageProcessor.hasImage ? "检测到人脸数量: " + imageProcessor.faceCount : "等待添加图片..."
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

                            Rectangle {
                                width: parent.parent.width - 200
                                height: parent.parent.height - 300
                                color: "white"
                                radius: 8
                                border.color: "#d0d0d0"
                                border.width: 1
                                anchors.horizontalCenter: parent.horizontalCenter

                                DropArea {
                                    anchors.fill: parent
                                    onEntered: (drag) => { if (drag.hasUrls) drag.accept() }
                                    onExited: {}
                                    onDropped: (drop) => {
                                        if (drop.hasUrls && drop.urls.length > 0) {
                                            var url = drop.urls[0];
                                            var filePath = url.toString();

                                            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
                                            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);

                                            console.log("拖拽文件路径:", filePath);
                                            garbageClassifier.loadPath(filePath);
                                            garbageClassifier.loadImage();
                                        }
                                        drop.accept();
                                    }
                                }

                                Image {
                                    id: trashImage
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    fillMode: Image.PreserveAspectFit
                                    source: garbageClassifier.hasImage ? "image://result/trash?" + imageRevisionTrash : ""
                                    cache: false
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: "请选择图片(拖拽至此或点击下方按钮)"
                                    font.pixelSize: 15
                                    color: "#090909"
                                    visible: trashImage.status !== Image.Ready
                                }
                            }

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

                                Button {
                                    text: "清除图片"
                                    highlighted: true
                                    onClicked: garbageClassifier.clearImage()
                                }
                            }

                            Rectangle {
                                width: 350
                                height: 80
                                radius: 8
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: {
                                    if (garbageClassifier.hasImage) {
                                        var type = garbageClassifier.garbageType
                                        if (type && typeof type === "string") {
                                            if (type.indexOf("可回收") >= 0) return "#2196F3"
                                            if (type.indexOf("有害") >= 0) return "#f44336"
                                            if (type.indexOf("厨余") >= 0) return "#4CAF50"
                                            if (type.indexOf("其他") >= 0) return "#9E9E9E"
                                        }
                                        return "#E0E0E0"
                                    }
                                    return "#E0E0E0"
                                }

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 5

                                    Text {
                                        text: {
                                            if (garbageClassifier.hasImage) {
                                                if (garbageClassifier.garbageType) return garbageClassifier.garbageType
                                                else return "等待识别..."
                                            }
                                            else return "等待添加图片..."
                                        }
                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "white"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    /*Text {
                                        text: garbageClassifier.hasImage ? "置信度: " + (garbageClassifier.confidence * 10).toFixed(2) + "%" : ""
                                        font.pixelSize: 14
                                        color: "white"
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }*/
                                }
                            }

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
                    Rectangle {
                        anchors.fill: parent
                        color: "#f0f0f0"
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 20


                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 16

                            Text {
                                text: "历史记录"
                                font.pixelSize: 24
                                font.bold: true
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            }

                            Item { Layout.fillWidth: true }

                            Button {
                                text: "刷新"
                                icon.name: "view-refresh"
                                onClicked: loadHistory()
                            }
                        }

                        ListView {
                            id: historyListView
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: historyModel

                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 100
                                color: "#ffffff"
                                border.color: "#e0e0e0"
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 16

                                    Image {
                                        source: "file:///" + appDirPath + "/data/thumbnails/" + model.currentTime + "_thumb.jpg"
                                        Layout.preferredWidth: 64
                                        Layout.preferredHeight: 64
                                        fillMode: Image.PreserveAspectCrop
                                        asynchronous: true

                                        onStatusChanged: {
                                            if (status === Image.Error)
                                                source = "qrc:/fallback-thumbnail.png"
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 6

                                        Text {
                                            text: formatTime(model.currentTime)
                                            font.pixelSize: 16
                                            font.bold: true
                                            color: "#030303"
                                        }

                                        Text {
                                            text: model.label === "TrashClassify" ? "垃圾分类: " + model.result : "人脸检测: " + model.result
                                            font.pixelSize: 14
                                            color: model.label === "TrashClassify" ? "#4CAF50" : "#2196F3"
                                        }

                                        Text {
                                            text: "路径: " + model.path
                                            font.pixelSize: 12
                                            color: "#757575"
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "暂无历史记录"
                        font.pixelSize: 18
                        color: "#757575"
                        visible: historyListView.count === 0
                        z: 1
                    }
                }

                Item {
                    Rectangle{
                        anchors.fill: parent
                        color: "#f0f0f0"

                        Text{
                            anchors.centerIn: parent
                            text: "正在开发中..."
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
        nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.bmp *.webp)"]
        onAccepted: {
            var filePath = selectedFile.toString();
            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);

            console.log("人脸识别 - 文件路径:", filePath);
            imageProcessor.loadPath(filePath);
            imageProcessor.loadImage();
        }
    }

    FileDialog {
        id: fileDialogTrash
        title: "选择图片"
        nameFilters: ["图片文件 (*.png *.jpg *.jpeg *.bmp *.webp)"]
        onAccepted: {
            var filePath = selectedFile.toString();
            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);

            console.log("垃圾分类 - 文件路径:", filePath);
            garbageClassifier.loadPath(filePath);
            garbageClassifier.loadImage();
        }
    }

    Dialog {
        id: messageDialog
        width: 300
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

    function loadHistory() {
        historyModel.clear();
        var records = historyRecord.getAllRecords();
        for (var i = 0; i < records.length; i++) {
            var row = records[i]; // row 是 QStringList
            historyModel.append({
                currentTime: row[0],
                path: row[1],
                result: row[2],
                label: row[3]
            });
        }
    }

    function formatTime(timeStr) {
        return timeStr.replace(/_/g, ' ');
    }

    Connections {
        target: imageProcessor

        function onMessageSent(msg) { messageDialog.show(msg) }
        function onImageChanged() { imageRevisionFaces++; }
    }

    Connections {
        target: garbageClassifier

        function onMessageSent(msg) { messageDialog.show(msg) }
        function onImageChanged() { imageRevisionTrash++; }
    }
}
