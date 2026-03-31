import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../settings"

Item {
    SettingItem {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        text: "主题"
        ctrlType: "combobox"
        model: ["默认","清新"]
    }
}
