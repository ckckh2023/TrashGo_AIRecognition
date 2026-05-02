import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../control"
import "../theme"

Rectangle {
    id: root
    width: parent.width - 60
    height: 80
    color: root.theme.card
    border.width: 1
    border.color: root.theme.borderColor
    radius: 8

    property string text1: ""
    property string text2: ""
    property string ctrlType: ""
    property string iconSource: ""

    property var comboboxModel: []
    property string textFieldTips: ""
    property var value
    property bool isEnabled: true

    property Theme theme : Theme {}

    Image {
        id: settingIcon
        width: 48
        height: 48
        anchors.left: root.left
        anchors.leftMargin: 15
        anchors.verticalCenter: root.verticalCenter
        source: root.iconSource
    }

    Text {
        id:settingText
        text: root.text1
        anchors.left: settingIcon.right
        anchors.leftMargin: 15
        anchors.bottom: root.verticalCenter
        anchors.bottomMargin: -2
        font.pixelSize: 18
        color: root.theme.text
    }

    Text {
        id:settingTextInfo
        text: root.text2
        anchors.left: settingIcon.right
        anchors.leftMargin: 15
        anchors.top: root.verticalCenter
        anchors.topMargin: 4
        font.pixelSize: 12
        color: root.theme.secondaryText
    }

    Item {
        width: {
            switch (root.ctrlType) {
            case "combobox": return 120
            case "textField": return 300
            default: return 150
            }
        }
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
                    case "textField": return textFieldComponent
                }
            }
        }
    }

    Component {
        id:comboBoxComponent
        SettingComboBox {
            id: comboBox
            model: root.comboboxModel
            enabled: root.isEnabled
            currentIndex: root.comboboxModel.indexOf(root.value)
            onCurrentValueChanged: {
                if (currentValue !== root.value)
                    root.value = currentValue
            }
        }
    }

    Component {
        id:textFieldComponent
        SettingTextField {
            id: comboBox
            text: root.value
            placeholderText: root.textFieldTips
            enabled: root.isEnabled
            onEditingFinished: {
                if (!activeFocus) {
                    root.value = text
                }
            }
        }
    }
}
