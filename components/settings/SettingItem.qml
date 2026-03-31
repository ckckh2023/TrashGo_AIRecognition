import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

Rectangle {
    id: root
    width: parent.width - 40
    height: 80
    color: "#80ffffff"
    border.width: 1
    border.color: "#d0d0d0"

    property string text
    property string ctrlType
    property var model: []
    property var value: null

    Text {
        id:settingText
        text: root.text
        anchors.left: root.left
        anchors.leftMargin: 40
        anchors.verticalCenter: root.verticalCenter
        font.pixelSize: 16
    }

    Item {
        width: 120
        height: root.height / 2
        anchors.right: root.right
        anchors.rightMargin: 40
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
        ComboBox {
            id: comboBox
            width: 120
            model: root.model
            currentIndex: 0
            onCurrentValueChanged: root.value = currentValue
        }
    }

    Component.onCompleted: {
        switch (root.ctrlType) {
        case "combobox": value = model && model.length > 0 ? model[0] : ""
            break
        }
    }
}
