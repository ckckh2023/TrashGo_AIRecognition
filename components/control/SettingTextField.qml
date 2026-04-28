import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../control"
import "../theme"

TextField {
    id: root
    focus: true
    placeholderTextColor: root.theme.secondaryText
    clip: false

    property string savedText: ""
    property bool isTextChanged: root.text !== root.savedText

    property Theme theme : Theme {}

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
        color: root.theme.card

        Behavior on border.color {
            ColorAnimation { duration: 100 }
        }
    }

    font.pixelSize: 15
    color: root.theme.text
    selectionColor: "#3dabff"
    selectedTextColor: root.theme.text
    leftPadding: 8
    rightPadding: 8
    verticalAlignment: Text.AlignVCenter

    StandardButton {
        height: bg.height / 1.5
        width: height
        text: "√"
        anchors.verticalCenter: bg.verticalCenter
        anchors.left: bg.right
        anchors.leftMargin: 10
        focusPolicy: Qt.StrongFocus
        visible: root.isTextChanged
        radius: height / 2
        bgcolor: String(root.theme.sideBarButton).slice(3,10)

        onClicked: {
            root.savedText = root.text
        }
    }

    Keys.onReturnPressed: {
        root.savedText = root.text
        root.focus = false
    }

    Keys.onEnterPressed: {
        root.savedText = root.text
        root.focus = false
    }

    Component.onCompleted: {
        if (!root.activeFocus) {
            root.savedText = root.text
        }
    }
}
