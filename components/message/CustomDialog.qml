import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine
import QtQuick.Layouts

Dialog {
    id: root
    width: 300
    height: 180

    property string dialogTitle: ""
    property string messageText: ""
    property string acceptButtonText: ""
    property string rejectButtonText: ""
    property bool showRejectButton : true

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    background: Rectangle {
            color: "white"
            radius: 8
            border.color: "#ccc"
            border.width: 1
        }

        header: Rectangle {
            color: "#3c8dbc"
            height: 40
            radius: 8

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 8

                Text {
                    text: dialogTitle
                    font.pixelSize: 14
                    font.bold: true
                    color: "white"
                    Layout.fillWidth: true
                }

                Button {
                    text: "✕"
                    flat: true
                    onClicked: onRejectClick()
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 16
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: parent.hovered ? "#cc0000" : "transparent"
                        radius: 4
                    }
                }
            }
        }

        contentItem: ColumnLayout {
            spacing: 20

            Text {
                text: messageText
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                font.pixelSize: 13
                color: "#333"
            }

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignRight

                Button {
                    text: acceptButtonText
                    onClicked: onAcceptClick()
                    Layout.preferredWidth: 80
                    background: Rectangle {
                        color: "#3c8dbc"
                        radius: 4
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    text: rejectButtonText
                    visible: showRejectButton
                    onClicked: onRejectClick()
                    Layout.preferredWidth: 80
                    background: Rectangle {
                        color: "#f0f0f0"
                        radius: 4
                        border.color: "#ccc"
                    }
                }
            }
        }

        // 内部辅助函数
        function onAcceptClick() {
            if (onAcceptCallback) onAcceptCallback()
            root.close()
        }

        function onRejectClick() {
            if (onRejectCallback) onRejectCallback()
            root.close()
        }
}
