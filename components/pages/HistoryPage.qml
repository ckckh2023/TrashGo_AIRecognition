import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Imagine
import Qt5Compat.GraphicalEffects

Item {
    id: root

    property bool timeSortAO: true

    Rectangle {
        id: titleBar
        width: parent.width - 40
        height: 30
        color: "#c0ffffff"
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 4

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
            font.pixelSize: 16
        }

        Text {
            id: timeAO
            text: "▲"
            anchors.left: sortText.right
            anchors.leftMargin: 5
            anchors.bottom: sortText.verticalCenter
            anchors.bottomMargin: -1
            font.pixelSize: 10
            font.bold: true
            color: root.timeSortAO ? "#1e90ff" : "#333333"
        }

        Text {
            id: timeDO
            text: "▼"
            anchors.left: sortText.right
            anchors.leftMargin: 5
            anchors.top: sortText.verticalCenter
            anchors.topMargin: -2
            font.pixelSize: 10
            font.bold: true
            color: root.timeSortAO ? "#333333" : "#1e90ff"
        }

        Rectangle {
            id: changeTimeSort
            anchors.top: timeAO.top
            anchors.bottom: timeDO.bottom
            anchors.left: sortText.left
            anchors.right: timeDO.right
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.timeSortAO = !root.timeSortAO
                    loadHistory(root.timeSortAO)
                }
            }
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

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            historyRecord.openOriginFile(model.path)
                        }
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
                    source: "qrc:/icons/images/bookmark" + ( model.star ? "ed" : "" ) + "History.png"

                    property bool isHovered: false
                    property bool isFirstHovered: true

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: starImage.isHovered = true
                        onExited: starImage.isHovered = false
                        onClicked:
                        {
                            var newstar = model.star ? 0 : 1
                            setStar(model.currentTime, newstar)
                            historyListModel.setProperty(index, "star", !model.star)
                        }
                    }

                    onSourceChanged: {
                        isFirstHovered = true
                    }

                    onIsHoveredChanged: {
                        if (isHovered === false && isFirstHovered === true) isFirstHovered = false
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
                            historyListModel.remove(index)
                        }
                    }
                }

                ColorOverlay {
                    anchors.fill: starImage
                    source: starImage
                    color: {
                        if (model.star && starImage.isHovered && !starImage.isFirstHovered) return "#aaaaaa"
                        if (starImage.isHovered === true) return "#ffe141"
                        else return "#00aaaaaa"
                    }

                    Behavior on color { ColorAnimation { duration: 60 } }
                }

                ColorOverlay {
                    anchors.fill: deleteImage
                    source: deleteImage
                    color: {
                        if (deleteImage.isHovered === true) return "#ff3800"
                        else return "#00aaaaaa"
                    }
                }
            }
        }

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            width: 8
            policy: ScrollBar.AsNeeded
            anchors.right: parent.right
            anchors.rightMargin: 2

            contentItem: Rectangle {
                width: 8
                color: parent.pressed ? "#b2b2b2" : "#d4d4d4"
                radius: width / 2

                Behavior on color {
                    ColorAnimation {
                        duration: 50
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        loadHistory(root.timeSortAO)
    }

    function loadHistory(timeSortAO) {
        historyListModel.clear();
        var records = historyRecord.getRecords("all");
        if (timeSortAO) {
            for (var i1 = 0; i1 < records.length; i1++) {
                var row1 = records[i1];
                historyListModel.append({
                                            currentTime: row1[0],
                                            path: row1[1],
                                            result: row1[2],
                                            label: row1[3],
                                            star: row1[4] === "1"
                                        });
            }
        }
        else {
            for (var i2 = records.length - 1; i2 != -1; i2--) {
                var row2 = records[i2];
                historyListModel.append({
                                            currentTime: row2[0],
                                            path: row2[1],
                                            result: row2[2],
                                            label: row2[3],
                                            star: row2[4] === "1"
                                        });
            }
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
