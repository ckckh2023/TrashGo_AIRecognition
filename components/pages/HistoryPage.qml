import QtQuick

Item {
    ListModel {
        id: historyListModel
    }

    ListView {
        id: historyView
        model: historyListModel
        anchors.fill: parent
        clip: true

        delegate: Item {
            id: listViewRoot
            width: historyView.width
            height: 100

            Rectangle {
                width: listViewRoot.width - 40
                height: 100
                border.width: 1
                border.color: "#d4d4d4"
                color: "#c0ffffff"
                radius: 5
                anchors.horizontalCenter: listViewRoot.horizontalCenter

                Image {
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
                    text: formatTime(model.currentTime)
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
