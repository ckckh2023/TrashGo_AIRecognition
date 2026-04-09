import QtQuick

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

        Row {
            spacing: 0
            anchors.fill: parent

            Rectangle {
                color: "transparent"
                height: parent.height
                width: parent.width / 6

                Text {
                    text: "缩略图"
                    font.pixelSize: 14
                    anchors.centerIn: parent
                }
            }

            Rectangle {
                color: "transparent"
                height: parent.height
                width: parent.width / 3

                Text {
                    text: "识别时间"
                    font.pixelSize: 14
                    anchors.centerIn: parent
                }
            }

            Rectangle {
                color: "transparent"
                height: parent.height
                width: parent.width / 3

                Text {
                    text: "原图片路径"
                    font.pixelSize: 14
                    anchors.centerIn: parent
                }
            }

            Rectangle {
                color: "transparent"
                height: parent.height
                width: parent.width / 6

                Text {
                    text: "识别结果"
                    font.pixelSize: 14
                    anchors.centerIn: parent
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

                Row {
                    anchors.fill: parent

                    Rectangle {
                        color: "transparent"
                        height: parent.height
                        width: parent.width / 6


                        Image {
                            width: 80
                            height: 80
                            source: "file:///" + appDirPath + "/data/thumbnails/" + model.currentTime + "_thumb.jpg"
                            anchors.centerIn: parent
                            asynchronous: true
                            fillMode: Image.PreserveAspectFit

                            onStatusChanged: {
                                if (status === Image.Error) source = "qrc:/fallback-thumbnail.png"
                            }
                        }
                    }

                    Rectangle {
                        color: "transparent"
                        height: parent.height
                        width: parent.width / 3

                        Text {
                            width: parent.width
                            text: formatTime(model.currentTime)
                            font.pixelSize: 18
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideMiddle
                            wrapMode: Text.NoWrap
                        }
                    }

                    Rectangle {
                        color: "transparent"
                        height: parent.height
                        width: parent.width / 3

                        Text {
                            width: parent.width
                            text: model.path
                            font.pixelSize: 18
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideMiddle
                            wrapMode: Text.NoWrap
                        }
                    }

                    Rectangle {
                        color: "transparent"
                        height: parent.height
                        width: parent.width / 6

                        Text {
                            width: parent.width
                            text: model.result
                            font.pixelSize: 18
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideMiddle
                            wrapMode: Text.NoWrap
                        }
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
                                        label: row[3]
                                    });
        }
    }

    function formatTime(timeStr) {
        return timeStr.replace(/(\d{4})_(\d{2})_(\d{2})_(\d{2})_(\d{2})_(\d{2})_(\d{3})/, '$1/$2/$3 $4:$5:$6');
    }
}
