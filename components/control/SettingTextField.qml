import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../control"

TextField {
    id: root
    focus: true
    placeholderTextColor: "#aaaaaa"

    property string savedText: ""
    property bool isTextChanged: root.text !== root.savedText

    onTextChanged: {
        if (!activeFocus) {
            root.savedText = root.text
        }
    }

    background: Rectangle {
        id: bg
        border.width: 1
        border.color: root.activeFocus ? "#3dabff" : (root.hovered ? "#d0dae5" : "#d0d0d5")
        implicitWidth: root.width
        implicitHeight: root.height
        radius: 6
        color: "#d0ffffff"

        Behavior on border.color {
            ColorAnimation { duration: 100 }
        }
    }

    font.pixelSize: 15
    color: "#030303"
    selectionColor: "#3dabff"
    selectedTextColor: "white"
    leftPadding: 8
    rightPadding: 8
    verticalAlignment: Text.AlignVCenter

    Button {
        height: bg.height / 2
        width: 30
        text: "保存"
        anchors.verticalCenter: bg.verticalCenter
        anchors.right: bg.right
        anchors.rightMargin: 20
        focusPolicy: Qt.StrongFocus
        visible: root.isTextChanged
        onClicked: {
            root.savedText = root.text
        }
    }

    Component.onCompleted: {
        if (!root.activeFocus) {
            root.savedText = root.text
        }
    }
}
