import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    Rectangle {
        id: titleBar
        width: parent.width - 40
        height: 30
        color: "#c0ffffff"
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 0

        Rectangle {
            id: thumbnailPreviewTitleZone
            color: "transparent"
            height: parent.height
            width: parent.width / 8
            anchors.left: parent.left

            Text {
                text: "缩略图"
                font.pixelSize: 14
                anchors.centerIn: parent
            }
        }

        Text {
            id: sortText
            text: "时间排序"
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 14
        }

        Text {
            text: "▲"
            anchors.left: sortText.right
            anchors.leftMargin: 5
            anchors.bottom: sortText.verticalCenter
            font.pixelSize: 8
        }

        Text {
            text: "▼"
            anchors.left: sortText.right
            anchors.leftMargin: 5
            anchors.top: sortText.verticalCenter
            font.pixelSize: 8
        }
    }

    ListModel {
        id: historyListModel
    }

    ListView {
        id: historyView
        model: historyListModel
        width: parent.width - 40
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 20
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true

        delegate: Item {
            id: listViewRoot
            width: historyView.width
            height: 100

            Rectangle {
                width: listViewRoot.width
                height: 100
                border.width: 1
                border.color: "#d4d4d4"
                color: "#c0ffffff"
                radius: 5
                anchors.horizontalCenter: listViewRoot.horizontalCenter

                Image {
                    id: thumbnailPreview
                    width: 80
                    height: 80
                    source: "file:///" + appDirPath + "/data/thumbnails/" + model.currentTime + "_thumb.jpg"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    asynchronous: true
                    fillMode: Image.PreserveAspectFit

                    onStatusChanged: {
                        if (status === Image.Error) source = "qrc:/fallback-thumbnail.png"
                    }
                }

                Text {
                    width: parent.width / 2.2
                    text: formatTime(model.currentTime)
                    font.pixelSize: 16
                    color: "#030303"
                    anchors.bottom: parent.verticalCenter
                    anchors.bottomMargin: 0
                    anchors.left: thumbnailPreview.right
                    anchors.leftMargin: 20
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideMiddle
                    wrapMode: Text.NoWrap
                }

                Text {
                    id: pathText
                    width: parent.width / 2.2
                    text: model.path
                    font.pixelSize: 12
                    color: "#757575"
                    anchors.top: parent.verticalCenter
                    anchors.topMargin: 0
                    anchors.left: thumbnailPreview.right
                    anchors.leftMargin: 20
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideMiddle
                    wrapMode: Text.NoWrap
                }

                Text {
                    width: parent.width / 2.2
                    text: model.result
                    font.pixelSize: 22
                    color: {
                        if (/^可/.test(text)) return "#2196F3";
                        if (/^厨/.test(text)) return "#4CAF50";
                        if (/^有/.test(text)) return "#f44336";
                        if (/^其/.test(text)) return "#9E9E9E";
                        return "#eeeeee";
                    }

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: pathText.right
                    anchors.leftMargin: 20
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideMiddle
                    wrapMode: Text.NoWrap
                }

                Image {
                    id: starImage
                    anchors.right: parent.right
                    anchors.rightMargin: 80
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/icons/images/bookmarkHistory.png"

                    property bool isHovered : false

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: starImage.isHovered = true
                        onExited: starImage.isHovered = false
                        onClicked:
                        {
                            setStar(model.currentTime, (model.star? 0 : 1))
                            loadHistory()
                        }
                    }
                }

                Image {
                    id: deleteImage
                    anchors.right: parent.right
                    anchors.rightMargin: 40
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/icons/images/deleteHistory.png"

                    property bool isHovered : false

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: deleteImage.isHovered = true
                        onExited: deleteImage.isHovered = false
                        onClicked:
                        {
                            deleteHistory(model.currentTime)
                            loadHistory()
                        }
                    }
                }

                ColorOverlay {
                    anchors.fill: starImage
                    source: starImage
                    color: {
                        if (model.star) return "#ffe141"
                        if (starImage.isHovered === true) return "#ffe141"
                        else return "#aaaaaa"
                    }
                }

                ColorOverlay {
                    anchors.fill: deleteImage
                    source: deleteImage
                    color: {
                        if (deleteImage.isHovered === true) return "#ff3800"
                        else return "#aaaaaa"
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        loadHistory()
    }

    function loadHistory() {
        historyListModel.clear();
        var records = historyRecord.getRecords("all");
        for (var i = 0; i < records.length; i++) {
            var row = records[i];
            historyListModel.append({
                                        currentTime: row[0],
                                        path: row[1],
                                        result: row[2],
                                        label: row[3],
                                        star: row[4] === "1"
                                    });
        }
    }

    function setStar(timeStr,isStar) {
        historyRecord.setStar(timeStr,isStar);
    }

    function deleteHistory(timeStr) {
        historyRecord.deleteRecord(timeStr);
    }

    function formatTime(timeStr) {
        return timeStr.replace(/(\d{4})_(\d{2})_(\d{2})_(\d{2})_(\d{2})_(\d{2})_(\d{3})/, '$1/$2/$3 $4:$5:$6');
    }

    Connections {
        target: historyRecord

        function onMessageSentInfo(msg) {
            Qt.application.toastManager.showToast(msg, "info")
        }
        function onMessageSentError(error) {
            Qt.application.toastManager.showToast(error, "error")
        }
        function onMessageSentWarn(warn) {
            Qt.application.toastManager.showToast(warn, "warn")
        }
    }
}
