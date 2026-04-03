import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../settings"

Item {
    ListView {
        clip: true
        anchors.fill: parent
        spacing: 20
        model: settingsModel

        header: Item { height: 20 }

        delegate: SettingItem {
            width: parent.width - 40
            anchors.horizontalCenter: parent.horizontalCenter
            text1: model.text1
            text2: model.text2
            ctrlType: model.ctrlType
            comboboxModel: model.modelValues.split(',')
            value: iniFileHandler[model.configKey]
            onValueChanged: iniFileHandler[model.configKey] = value
        }
    }

    ListModel {
        id: settingsModel

        ListElement {
            text1: "界面主题"
            text2: "更改应用程序主题"
            ctrlType: "combobox"
            modelValues: "跟随系统,明亮,黑暗"
            configKey: "theme"
        }

        ListElement {
            text1: "主题颜色"
            text2: "更改应用主题颜色，颜色会根据主题自动调整"
            ctrlType: "combobox"
            modelValues: "蓝色,绿色,黄色"
            configKey: "color"
        }
    }


    Connections {
        target: iniFileHandler

        function onMessageSentInfo(msg) {
            Qt.application.toastManager.showToast(msg, "info")
        }
    }
}
