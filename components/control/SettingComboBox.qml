import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

ComboBox {
    id: root
    anchors.fill: parent


    background: Rectangle {
        border.width: 1
        border.color: "#d0d0d5"
        implicitWidth: parent.width
        implicitHeight: parent.height
        radius: 6
        color: "#b0ffffff"
    }

    contentItem: Text {
        text: root.displayText
        font.pixelSize: 15
        color: "#030303"
        verticalAlignment: Text.AlignVCenter
        leftPadding: 8
        rightPadding: root.indicator.width + 8
        elide: Text.ElideRight
    }

    indicator: Image {
        source: "qrc:/icons/images/comboBoxArrow.png"
        rotation: root.popup.visible ? 180 : 0
        Behavior on rotation { NumberAnimation { duration: 120 } }
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
    }

    delegate: ItemDelegate {

        property bool isCurrent: index === root.currentIndex

        height: 32
        width: root.width
        contentItem: Text {
            font.pixelSize: 14
            text: modelData
            horizontalAlignment: Text.AlignLeft
            leftPadding: 15
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {

            //选中时的蓝条，模仿windows
            Rectangle {
                width: 4
                height: parent.height - 8
                color: "#3dabff"
                radius: 2
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                visible: isCurrent
            }

            border.width: 1
            border.color: parent.hovered ? "#d0dae5" : "transparent"
            anchors.fill: parent
            radius: 4
            color: (parent.hovered || isCurrent) ? "#eaecf1" : "transparent"
        }
    }

    popup: Popup {
        id: popupList
        y: root.height
        width: root.width
        height: Math.min(200, contentItem.contentHeight + 8)
        padding: 4
        contentItem: ListView {
            id: popupListView
            clip: true
            implicitHeight: contentHeight
            model: root.delegateModel
            currentIndex: root.highlightedIndex
            ScrollBar.vertical: ScrollBar { }
        }

        background: Rectangle {
            color: "white"
            border.color: "#d0d0d0"
            border.width: 1
            radius: 4
            layer.enabled: true
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 120 }
            NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: 120 }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 100 }
        }
    }
}
