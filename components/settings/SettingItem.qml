import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../control"

Rectangle {
    id: root
    width: parent.width - 60
    height: 80
    color: "#80ffffff"
    border.width: 1
    border.color: "#F2F9FA"
    radius: 8

    property string text1
    property string text2
    property string ctrlType
    property string iconSource

    property var comboboxModel: []
    property var value

    Text {
        id:settingText
        text: root.text1
        anchors.left: root.left
        anchors.leftMargin: 40
        anchors.bottom: root.verticalCenter
        anchors.bottomMargin: -2
        font.pixelSize: 18
        color: "#000000"
    }

    Text {
        id:settingTextInfo
        text: root.text2
        anchors.left: root.left
        anchors.leftMargin: 40
        anchors.top: root.verticalCenter
        anchors.topMargin: 4
        font.pixelSize: 12
        color: "#606060"
    }

    Item {
        width: 150
        height: root.height / 2
        anchors.right: root.right
        anchors.rightMargin: 50
        anchors.verticalCenter: root.verticalCenter
        Loader {
            id: dynamicLoader
            anchors.fill: parent
            sourceComponent: {
                switch (root.ctrlType) {
                    case "combobox": return comboBoxComponent
                }
            }
        }
    }

    Component {
        id:comboBoxComponent
        SettingComboBox {
            id: comboBox
            width: 120
            model: root.comboboxModel
            currentIndex: root.comboboxModel.indexOf(root.value)
            onCurrentValueChanged: {
                if (currentValue !== root.value)
                    root.value = currentValue
            }
        }
    }
}
