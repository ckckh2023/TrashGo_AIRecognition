import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import "../button"

Item {
    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            id: trashImagePreviewZone
            width: parent.parent.width / 2 - 30
            height: parent.parent.height - 210
            radius: 8
            color: "#a0ffffff"
            border.color: "#d0d0d0"
            border.width: 1
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 20

            Rectangle {
                id: trashImagePreview
                width: parent.width - 60
                height: parent.height - 240
                color: dragHover ? "#f0f8ff" : "#00ffffff"
                radius: 8
                border.color: dragHover ? "#0078d7" : "#d0d0d0"
                border.width: 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 80

                property bool dragHover: false

                DropArea {
                    anchors.fill: parent
                    onEntered: (drag) => {
                                   if (drag.hasUrls) {
                                       drag.accept()
                                       trashImagePreview.dragHover = true
                                   }
                               }
                    onExited: {
                        trashImagePreview.dragHover = false
                    }

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
                        trashImagePreview.dragHover =  false
                    }
                }

                Image {
                    id: trashImage
                    anchors.fill: parent
                    anchors.margins: 10
                    fillMode: Image.PreserveAspectFit
                    source: garbageClassifier.hasImage ? "image://resultimage/trash?" + imageRevisionTrash : ""
                    cache: false
                }

                Text {
                    anchors.centerIn: parent
                    text: trashImagePreview.dragHover ? "松手以选中图片":"请选择图片(拖拽至此或点击下方按钮)"
                    font.pixelSize: trashImagePreview.dragHover ? 20 : 15
                    color: "#090909"
                    visible: trashImage.status !== Image.Ready
                }
            }
        }

        Item {
            id: locater
            width: parent.width - trashImagePreviewZone.width - 60
            height: trashImagePreviewZone.height
            anchors.left: trashImagePreviewZone.right
            anchors.top: trashImagePreviewZone.top
        }

        Row {
            id: buttons
            spacing: 15
            anchors.horizontalCenter: locater.horizontalCenter
            anchors.verticalCenter: locater.verticalCenter
            anchors.verticalCenterOffset: -60

            StandardButton {
                width: 100
                height: 40
                text: "选择图片"
                icon.name: "folder-open"
                onClicked: fileDialogTrash.open()
            }

            StandardButton {
                width: 100
                height: 40
                text: "开始识别"
                highlighted: true
                onClicked: garbageClassifier.classify()
            }

            StandardButton {
                width: 100
                height: 40
                text: "清除图片"
                highlighted: true
                onClicked: garbageClassifier.clearImage()
            }
        }

        Row {
            id: indexOfTrash
            spacing: 10
            anchors.top: buttons.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: locater.horizontalCenter


            Rectangle {
                width: 80
                height: 30
                radius: 0
                color: {
                    if (garbageClassifier.hasImage) {
                        var type = garbageClassifier.garbageType
                        if (type.indexOf("可回收") >= 0) return "#2196F3"
                        else return "#6d8497"
                    }
                    else return "#6d8497"
                }

                Text {
                    anchors.centerIn: parent
                    text: "可回收"
                    color: "white"
                    font.pixelSize: 12
                }
            }

            Rectangle {
                width: 80
                height: 30
                radius: 0
                color: {
                    if (garbageClassifier.hasImage) {
                        var type = garbageClassifier.garbageType
                        if (type.indexOf("有害") >= 0) return "#f44336"
                        else return "#977471"
                    }
                    else return "#977471"
                }

                Text {
                    anchors.centerIn: parent
                    text: "有害"
                    color: "white"
                    font.pixelSize: 12
                }
            }

            Rectangle {
                width: 80
                height: 30
                radius: 0
                color: {
                    if (garbageClassifier.hasImage) {
                        var type = garbageClassifier.garbageType
                        if (type.indexOf("厨余") >= 0) return "#4CAF50"
                        else return "#768976"
                    }
                    else return "#768976"
                }

                Text {
                    anchors.centerIn: parent
                    text: "厨余"
                    color: "white"
                    font.pixelSize: 12
                }
            }

            Rectangle {
                width: 80
                height: 30
                radius: 0
                color: {
                    if (garbageClassifier.hasImage) {
                        var type = garbageClassifier.garbageType
                        if (type.indexOf("其他") >= 0) return "#9e9e9e"
                        else return "#868686"
                    }
                    else return "#868686"
                }

                Text {
                    anchors.centerIn: parent
                    text: "其他"
                    color: "white"
                    font.pixelSize: 12
                }
            }
        }

        Rectangle {
            id: result
            width: 350
            height: 80
            radius: 0
            anchors.top: indexOfTrash.bottom
            anchors.horizontalCenter: locater.horizontalCenter
            color: {
                if (garbageClassifier.hasImage) {
                    var type = garbageClassifier.garbageType
                    if (type.indexOf("可回收") >= 0) return "#2196F3"
                    else if (type.indexOf("有害") >= 0) return "#f44336"
                    else if (type.indexOf("厨余") >= 0) return "#4CAF50"
                    else if (type.indexOf("其他") >= 0) return "#9E9E9E"
                    else return "#E0E0E0"
                }
                else return "#E0E0E0"
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
            }
        }

    }


    FileDialog {
        id: fileDialogTrash
        title: "选择图片"
        nameFilters: ["图片文件 (*.bmp *.jpg *.jpeg *.png *.webp *.tiff *.tif *.jp2 *.ppm *.pgm *.exr *.hdr)","所有文件 (*.*)"]
        onAccepted: {
            var filePath = selectedFile.toString();
            if (filePath.startsWith("file:///")) filePath = filePath.substring(8);
            else if (filePath.startsWith("file://")) filePath = filePath.substring(7);

            console.log("垃圾分类 - 文件路径:", filePath);
            garbageClassifier.loadPath(filePath);
            garbageClassifier.loadImage();
        }
    }

    Connections {
        target: garbageClassifier

        function onMessageSent(msg) { messageDialog.show(msg) }
        function onImageChanged() { imageRevisionTrash++; }
    }
}
