import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../theme"

ComboBox {
    id: root
    anchors.fill: parent

    property Theme theme : Theme {}

    background: Rectangle {
        border.width: 1
        border.color: "#d0d0d5"
        anchors.fill: parent
        radius: 6
        color: root.theme.card

        HoverHandler {
            cursorShape: Qt.PointingHandCursor
        }
    }

    contentItem: Text {
        text: root.displayText
        font.pixelSize: 15
        color: root.theme.text
        verticalAlignment: Text.AlignVCenter
        leftPadding: 8
        rightPadding: root.indicator.width + 8
        elide: Text.ElideRight
    }

    indicator: Image {
        source: "qrc:/icons/assets/images/comboBoxArrow.png"
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
            color: root.theme.text
            horizontalAlignment: Text.AlignLeft
            leftPadding: 15
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {

            //选中时的蓝/绿/黄条，模仿windows 11
            Rectangle {
                width: 4
                height: parent.height - 8
                color: root.theme.highlightedRectangle
                radius: 2
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                visible: isCurrent
            }

            border.width: 1
            border.color: parent.hovered ? "#d0dae5" : root.theme.defaultTransparentColor
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: popupList.padding * 2
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            radius: 4
            color: (parent.hovered || isCurrent) ? root.theme.comboBoxHighlighted : root.theme.defaultTransparentColor

            Behavior on color {
                ColorAnimation {
                    duration: 80
                }
            }

            Behavior on border.color {
                ColorAnimation {
                    duration: 80
                }
            }

            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
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
            color: root.theme.opaqueCard
            border.color: "#d0d0d0"
            border.width: 1
            radius: 6
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
