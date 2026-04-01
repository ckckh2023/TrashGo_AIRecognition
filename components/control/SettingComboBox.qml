import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

ComboBox {
    id: root
    anchors.fill: parent


    background: Rectangle {
        border.width: 0
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 12
        color: "#b0ffffff"
    }

    contentItem: Text {
        text: root.displayText
        font: root.font
        color: "#030303"
        verticalAlignment: Text.AlignVCenter
        leftPadding: 8
        rightPadding: root.indicator.width + 8
        elide: Text.ElideRight
    }

    indicator: Image {
        source: "qrc:/icons/images/comboBoxArrow.png"
        rotation: root.popup.visible ? 180 : 0
        Behavior on rotation { NumberAnimation { duration: 200 } }
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
    }

    popup: Popup {
            y: root.height
            width: Math.max(root.width, 200)
            height: Math.min(200, contentItem.contentHeight + 8)
            padding: 4
            contentItem: ListView {
                clip: true
                implicitHeight: contentHeight
                model: root.delegateModel
                currentIndex: root.highlightedIndex
                ScrollBar.vertical: ScrollBar { }
            }
            background: Rectangle {
                color: "white"
                border.color: "#ddd"
                border.width: 1
                radius: 4
                layer.enabled: true
            }
            enter: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 150 }
                NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: 150 }
            }
            exit: Transition {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 100 }
            }
        }
}

