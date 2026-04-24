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
            id: settingDelegate
            width: parent.width - 40
            anchors.horizontalCenter: parent.horizontalCenter
            text1: model.text1
            text2: model.text2
            ctrlType: model.ctrlType
            iconSource: model.iconSource
            comboboxModel: model.modelValues.split(',')
            textFieldTips: model.textFieldTips
            value: iniFileHandler[model.configKey]
            onValueChanged: iniFileHandler[model.configKey] = value
            isEnabled: model.enabled

            //针对本地模型时的特殊处理
            Binding {
                target: settingDelegate
                property: "textFieldTips"
                value: "模型提供商为本地模型时该项不可用"
                when: model.configKey === "currentApiKey" && iniFileHandler.provider === "本地模型"
            }

            Binding {
                target: settingDelegate
                property: "isEnabled"
                value: false
                when: model.configKey === "currentApiKey" && iniFileHandler.provider === "本地模型"
            }

            Binding {
                target: settingDelegate
                property: "value"
                value: ""
                when: model.configKey === "currentApiKey" && iniFileHandler.provider === "本地模型"
            }
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
            iconSource: "qrc:/icons/images/themeSetting.png"
            enabled: true
        }

        ListElement {
            text1: "主题颜色"
            text2: "更改应用主题颜色，颜色会根据主题自动调整"
            ctrlType: "combobox"
            modelValues: "蓝色,绿色,黄色"
            configKey: "color"
            iconSource: "qrc:/icons/images/colorSetting.png"
            enabled: true
        }

        ListElement {
            text1: "模型提供商"
            text2: "更改模型提供商，支持本地模型和在线模型"
            ctrlType: "combobox"
            modelValues: "本地模型,百度云"
            configKey: "provider"
            iconSource: "qrc:/icons/images/apiProviderSetting.png"
            enabled: true
        }

        ListElement {
            text1: "API key"
            text2: "用于调用在线模型"
            ctrlType: "textField"
            textFieldTips: "请在此粘贴/输入您的API key"
            configKey: "currentApiKey"
            iconSource: "qrc:/icons/images/apiKeySetting.png"
            enabled: true
        }

        ListElement {
            text1: "程序渲染器"
            text2: "选择更好的渲染器以支持更优性能"
            ctrlType: "combobox"
            modelValues: "Direct3D,OpenGL"
            configKey: "renderer"
            iconSource: "qrc:/icons/images/rendererSetting.png"
            enabled: true
        }
    }


    Connections {
        target: iniFileHandler

        function onMessageSentInfo(msg) {
            Qt.application.toastManager.showToast(msg, "info")
        }
    }


}
