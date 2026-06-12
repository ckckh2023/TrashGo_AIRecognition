import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../settings"
import "../control"

Item {
    ListView {
        clip: true
        anchors.fill: parent
        spacing: 20
        model: settingsModel

        header: Item { height: 20 }

        delegate: Item {
            width: parent.width
            height: settingDelegate.height

            SettingItem {
                id: settingDelegate
                width: parent.width - 40
                anchors.horizontalCenter: parent.horizontalCenter
                text1: model.text1
                text2: model.text2
                ctrlType: model.ctrlType
                iconSource: model.iconSource
                comboboxModel: model.modelValues.split(',')
                textFieldTips: model.textFieldTips
                onValueChanged: iniFileHandler[model.configKey] = value
                value: iniFileHandler[model.configKey]
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

            StandardButton {
                visible: initialLocalModel !== iniFileHandler.localProvider && model.configKey === "localProvider"
                height: parent.height / 3
                width: height
                text: "R"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 34
                focusPolicy: Qt.StrongFocus
                radius: height / 2
                bgcolor: String(root.theme.sideBarButton).slice(3,10)

                onClicked: {
                    iniFileHandler.restartApp()
                }
            }

            //变更渲染器后的重启按钮
            StandardButton {
                visible: initialRenderer !== iniFileHandler.renderer && model.configKey === "renderer"
                height: parent.height / 3
                width: height
                text: "R"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 34
                focusPolicy: Qt.StrongFocus
                radius: height / 2
                bgcolor: String(root.theme.sideBarButton).slice(3,10)

                onClicked: {
                    iniFileHandler.restartApp()
                }
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
            iconSource: "qrc:/icons/assets/images/themeSetting.png"
            enabled: true
        }

        ListElement {
            text1: "主题颜色"
            text2: "更改应用主题颜色，颜色会根据主题自动调整"
            ctrlType: "combobox"
            modelValues: "蓝色,绿色,黄色"
            configKey: "color"
            iconSource: "qrc:/icons/assets/images/colorSetting.png"
            enabled: true
        }

        ListElement {
            text1: "模型提供商"
            text2: "更改模型提供商，支持本地模型和在线模型"
            ctrlType: "combobox"
            modelValues: "本地模型,百度云"
            configKey: "provider"
            iconSource: "qrc:/icons/assets/images/apiProviderSetting.png"
            enabled: true
        }

        ListElement {
            text1: "API key"
            text2: "用于调用在线模型"
            ctrlType: "textField"
            textFieldTips: "请在此粘贴/输入您的API key"
            configKey: "currentApiKey"
            iconSource: "qrc:/icons/assets/images/apiKeySetting.png"
            enabled: true
        }

        ListElement {
            text1: "本地模型"
            text2: "选择更适合的本地模型以提高精确度"
            ctrlType: "combobox"
            modelValues: "ResNet,MobileNet"
            configKey: "localProvider"
            iconSource: "qrc:/icons/assets/images/localModel.png"
            enabled: true
        }

        ListElement {
            text1: "程序渲染器"
            text2: "选择更好的渲染器以支持更优性能"
            ctrlType: "combobox"
            modelValues: "自动选择,Direct3D,OpenGL,Vulkan"
            configKey: "renderer"
            iconSource: "qrc:/icons/assets/images/rendererSetting.png"
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
