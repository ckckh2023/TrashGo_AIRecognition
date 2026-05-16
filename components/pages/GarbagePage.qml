import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects

import "../control"
import "../theme"
import "../settings"

Item {
    id: root

    property Theme theme : Theme {}

    property bool canClassify: true

    Timer {
        id: classifyCooldown
        interval: iniFileHandler.timeLimit
        repeat: false
        onTriggered: canClassify = true
    }

    Rectangle {
        anchors.fill: parent
        color: root.theme.defaultTransparentColor

        Rectangle {
            id: trashImagePreviewZone
            width: parent.width / 2 - 30
            height: parent.height - 210
            radius: 8
            color: root.theme.card
            border.color: root.theme.borderColor
            border.width: 1
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 20

            Image {
                id: trashImagePreviewIcon
                source: "qrc:/icons/assets/images/imageImport.png"
                width: 40
                height: 40
                anchors.left: trashImagePreviewZone.left
                anchors.top: parent.top
                anchors.leftMargin: 20
                anchors.topMargin: 20
            }

            Text {
                id: trashImagePreviewTitle
                text: "上传图片"
                color: root.theme.text
                font.pixelSize: 24
                font.bold: true
                anchors.left: trashImagePreviewIcon.right
                anchors.leftMargin: 20
                anchors.verticalCenter: trashImagePreviewIcon.verticalCenter
            }

            Item {
                id: fastProviderSetting
                width: 120
                height: 40
                anchors.right: trashImagePreviewZone.right
                anchors.rightMargin: 30
                anchors.verticalCenter: trashImagePreviewIcon.verticalCenter
                SettingComboBox {
                    model: ["本地模型","百度云"]
                    currentIndex: model.indexOf(iniFileHandler["provider"])
                    onCurrentValueChanged: {
                        if (currentValue !== iniFileHandler["provider"])
                            iniFileHandler["provider"] = currentValue
                    }
                }
            }

            Rectangle {
                id: trashImagePreview
                width: parent.width - 60
                height: parent.height - 180
                color: dragHover ? "#80c0c8ef" : root.theme.defaultTransparentColor
                radius: 8
                border.color: dragHover ? "#0078d7" : root.theme.barBorderColor
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
                                       var cutLength = 8;

                                       if (Qt.platform.os === "windows") cutLength = 8
                                       else if (Qt.platform.os === "linux") cutLength = 7

                                       if (filePath.startsWith("file:///")) filePath = filePath.substring(cutLength);
                                       else if (filePath.startsWith("file://")) filePath = filePath.substring(cutLength - 1);

                                       garbageClassifier.loadPath(filePath);
                                       garbageClassifier.loadImage();
                                   }
                                   drop.accept();
                                   trashImagePreview.dragHover = false
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

                Image {
                    id: trashImageIcon
                    anchors.bottom: trashImageTips.top
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: trashImagePreview.horizontalCenter
                    source: "qrc:/icons/assets/images/" + ( trashImagePreview.dragHover ? "dragImage.png" : "addImage.png")
                    visible: trashImage.status !== Image.Ready
                }

                Text {
                    id: trashImageTips
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenterOffset: trashImagePreview.dragHover ? 0 : -30
                    text: trashImagePreview.dragHover ? "松手以选中图片":"请选择图片(拖拽至此或点击下方按钮)"
                    font.pixelSize: trashImagePreview.dragHover ? 22 : 18
                    color: root.theme.text
                    visible: trashImage.status !== Image.Ready
                }

                Text {
                    id: trashImageTips2
                    anchors.top: trashImageTips.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 10
                    text:"支持.jpg/.jpeg/.png/.bmp/.webp等格式图片"
                    font.pixelSize: 14
                    color: "#808080"
                    visible: trashImage.status !== Image.Ready
                }

                Text {
                    id: trashImageTips3
                    anchors.top: trashImageTips2.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: 10
                    text: "建议选择清晰无遮挡图片，识别更准确"
                    font.pixelSize: 14
                    color: "#808080"
                    visible: ( trashImage.status !== Image.Ready ) && !trashImagePreview.dragHover
                }

                StandardButton {
                    id: trashImagePickButton
                    width: 120
                    height: 40
                    text: "选择图片"
                    anchors.horizontalCenter: trashImageTips.horizontalCenter
                    anchors.top: trashImageTips3.bottom
                    anchors.topMargin: 10
                    onClicked: fileDialogTrash.open()

                    background: Rectangle {
                        border.width: 1
                        implicitWidth: parent.width
                        implicitHeight: parent.height
                        radius: 12
                        border.color: root.theme.borderColor

                        color: {
                            if (trashImagePickButton.hovered) return "#e0e5e5e5"
                            return "#67ade3"
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }
                    }

                    contentItem: Text {
                        text: trashImagePickButton.text
                        color: "#fafafa"
                        font.pixelSize: 18
                        font.letterSpacing: 1
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    visible: trashImage.status !== Image.Ready && !trashImagePreview.dragHover
                }

            }

            StandardButton {
                id: trashImageRecognizeButton
                width: 100
                height: 40
                anchors.top: trashImagePreview.bottom
                anchors.right: trashImagePreviewZone.horizontalCenter
                anchors.topMargin: 20
                anchors.rightMargin: 20
                text: "开始识别"
                highlighted: true

                background: Rectangle {
                    border.width: 1
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    radius: 12
                    border.color: "#a0a0a0"

                    color: {
                        if (trashImageRecognizeButton.hovered) return "#e0e5e5e5"
                        return root.theme.highOpacityCard
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }

                onClicked: {
                    if (canClassify) {
                        canClassify = false
                        garbageClassifier.classify()
                        classifyCooldown.restart()
                    }
                }
            }

            StandardButton {
                id: trashImageClearButton
                width: 100
                height: 40
                anchors.top: trashImagePreview.bottom
                anchors.left: trashImagePreviewZone.horizontalCenter
                anchors.topMargin: 20
                anchors.leftMargin: 20
                text: "清除图片"
                highlighted: true

                background: Rectangle {
                    border.width: 1
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    radius: 12
                    border.color: "#a0a0a0"

                    color: {
                        if (trashImageClearButton.hovered) return "#e0e5e5e5"
                        return root.theme.highOpacityCard
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                }

                onClicked: garbageClassifier.clearImage()
            }
        }

        Rectangle {
            id: resultZone
            width: parent.width / 2 - 30
            height: trashImagePreviewZone.height
            radius: 8
            color: root.theme.card
            border.color: root.theme.borderColor
            border.width: 1
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 20
            anchors.topMargin: 20

            Image {
                id: resultIcon
                source: "qrc:/icons/assets/images/recognizeResult.png"
                width: 40
                height: 40
                anchors.left: resultZone.left
                anchors.top: parent.top
                anchors.leftMargin: 20
                anchors.topMargin: 20
            }

            Text {
                id: resultTitle
                text: "识别结果"
                color: root.theme.text
                font.pixelSize: 24
                font.bold: true
                anchors.left: resultIcon.right
                anchors.leftMargin: 20
                anchors.verticalCenter: resultIcon.verticalCenter
            }

            Image {
                id: indexIcon

                source: {
                    if (garbageClassifier.hasImage) {
                        var type = garbageClassifier.garbageType
                        if (type.indexOf("可回收") >= 0) return "qrc:/icons/assets/images/classified_RecyclableWaste.png"
                        else if (type.indexOf("厨余") >= 0) return "qrc:/icons/assets/images/classified_FoodWaste.png"
                        else if (type.indexOf("有害") >= 0) return "qrc:/icons/assets/images/classified_HazardousWaste.png"
                        else if (type.indexOf("其他") >= 0) return "qrc:/icons/assets/images/classified_OtherWaste.png"
                        else return "qrc:/icons/assets/images/unclassified" + ( root.theme.themeSet === "明亮" ? "" : "_dark" ) + ".png"
                    }
                    else return "qrc:/icons/assets/images/unclassified" + ( root.theme.themeSet === "明亮" ? "" : "_dark" ) + ".png"
                }

                width: 64
                height: 64
                anchors.left: resultZone.left
                anchors.top: resultIcon.bottom
                anchors.leftMargin: 30
                anchors.topMargin: 15
            }

            Text {
                id: resultText
                text: {
                    if (garbageClassifier.hasImage) {
                        if (garbageClassifier.garbageType) return garbageClassifier.garbageType
                        else return "等待识别..."
                    }
                    else return "等待添加图片..."
                }
                anchors.left: indexIcon.right
                anchors.verticalCenter: indexIcon.verticalCenter
                anchors.leftMargin: 40
                font.pixelSize: 30
                color: {
                    if (garbageClassifier.hasImage) {
                        var type = garbageClassifier.garbageType
                        if (type.indexOf("可回收") >= 0) return "#2196F3"
                        else if (type.indexOf("有害") >= 0) return "#f44336"
                        else if (type.indexOf("厨余") >= 0) return "#4CAF50"
                        else if (type.indexOf("其他") >= 0) return "#9E9E9E"
                        else return root.theme.text
                    }
                    else return root.theme.text
                }
            }

            Text {
                id: resultTips
                text: "投放建议：" + garbageClassifier.getTips
                anchors.left: resultZone.left
                anchors.top: indexIcon.bottom
                anchors.leftMargin: 60
                anchors.topMargin: 30
                font.pixelSize: 18
                visible: garbageClassifier.hasImage && garbageClassifier.getTips !== ""
                color: {
                    if (garbageClassifier.hasImage) {
                        var type = garbageClassifier.garbageType
                        if (type.indexOf("可回收") >= 0) return "#6d8497"
                        else if (type.indexOf("有害") >= 0) return "#977471"
                        else if (type.indexOf("厨余") >= 0) return "#768976"
                        else if (type.indexOf("其他") >= 0) return "#868686"
                        else return root.theme.text
                    }
                    else return root.theme.text
                }
                width: resultZone.width - 120
                wrapMode: Text.WordWrap
            }
        }

        Rectangle {
            id: dailyTipsZone
            width: parent.parent.width - 40
            height: parent.parent.height - trashImagePreviewZone.height - 60
            radius: 8
            color: root.theme.card
            border.color: root.theme.borderColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: trashImagePreviewZone.bottom
            anchors.topMargin: 20

            //遮罩防一手下面的四个卡片溢出显示
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: dailyTipsZone.width
                    height: dailyTipsZone.height
                    radius: dailyTipsZone.radius
                }
            }

            FontLoader {
                id: customFont
                source: "file:///" + appDirPath + "/assets/fonts/DingTalkJinBuTi.ttf"
            }

            Text {
                id: dayTips
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.right: parent.right
                anchors.rightMargin: 30
                color: root.theme.text
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                font.pixelSize: 18
                font.family: customFont.name
                text: "垃圾分类小贴士：" + gitHubOnline.getDayTips()
                horizontalAlignment: Text.AlignLeft
            }

            //垃圾分类示例，现在先写死通过初赛再说,以后再搞动态的

            Row {
                id: exampleZone
                anchors.top: dayTips.bottom
                anchors.topMargin: 20
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                Repeater {
                    model: ListModel {
                        ListElement {color1: "#10e84040"; color2: "#e84040"; imageSource: "qrc:/icons/assets/images/img_yh.jpg"; text1:"有害垃圾"}
                        ListElement {color1: "#10b0e840"; color2: "#b0e840"; imageSource: "qrc:/icons/assets/images/img_cy.jpg"; text1:"厨余垃圾"}
                        ListElement {color1: "#1040b0e8"; color2: "#40b0e8"; imageSource: "qrc:/icons/assets/images/img_khs.jpg"; text1:"可回收物"}
                        ListElement {color1: "#10b0b0b0"; color2: "#b0b0b0"; imageSource: "qrc:/icons/assets/images/img_qt.jpg"; text1:"其他垃圾"}
                    }

                    delegate: Rectangle {
                        width: parent.width / 4
                        height: parent.height
                        color: model.color1

                        Image {
                            id: exampleImage
                            source: model.imageSource
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            width: 64
                            height: 64
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            id: exampleText
                            text: model.text1
                            color: model.color2
                            anchors.right: parent.right
                            anchors.rightMargin: ( parent.width - exampleImage.width - exampleImage.anchors.leftMargin * 2 ) / 6
                            anchors.verticalCenter: parent.verticalCenter
                            font.bold: false
                            font.pixelSize: 24
                            font.family: customFont.name
                        }
                    }
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
            var cutLength = 8

            if (Qt.platform.os === "windows") cutLength = 8
            else if (Qt.platform.os === "linux") cutLength = 7

            if (filePath.startsWith("file:///")) filePath = filePath.substring(cutLength);
            else if (filePath.startsWith("file://")) filePath = filePath.substring(cutLength - 1);

            console.log("垃圾分类 - 文件路径:", filePath);
            garbageClassifier.loadPath(filePath);
            garbageClassifier.loadImage();
        }
    }

    Connections {
        target: garbageClassifier

        function onMessageSentInfo(msg) {
            Qt.application.toastManager.showToast(msg, "info")
        }
        function onMessageSentError(error) {
            Qt.application.toastManager.showToast(error, "error")
        }
        function onMessageSentWarn(warn) {
            Qt.application.toastManager.showToast(warn, "warn")
        }
        function onImageChanged() {
            imageRevisionTrash++
        }
    }

    Connections {
        target: iniFileHandler

        function onMessageSentInfo(msg) {
            Qt.application.toastManager.showToast(msg, "info")
        }
    }
}
