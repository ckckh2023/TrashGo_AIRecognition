import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

import "../animation"

Button {
    id: root
    clip: true
    width: parent ? parent.width - 20 : 0
    height: parent ? 48 : 0
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined

    background: Rectangle {
        border.width: 0
        implicitWidth: parent ? parent.width : 0
        implicitHeight: parent ? parent.height : 0
        radius: 10
        color: {
            if (root.highlighted) return "#d0e2f6"
            if (root.pressed)     return "#dadada"
            if (root.hovered)     return "#ebebeb"
            return "#00ffffff"
        }

        Behavior on color {
            ColorAnimation {
                duration: 120
            }
        }
    }

    TapHandler {
        onTapped: (eventPoint, button) => {
                      // 获取点击位置相对于 root 的坐标
                      var point = mapToItem(root, eventPoint.position)
                      createRipple(point)
                      // 手动触发 Button 的 clicked 信号，确保页面切换
                      root.clicked()
                  }
    }

    function createRipple(point) {
        // 组件路径：根据实际目录调整，此处假设 CustomizeRipple.qml 位于 ../animation/ 下
        var component = Qt.createComponent("../animation/CustomizeRipple.qml")
        if (component.status === Component.Ready) {
            // 计算合理的最大缩放比例，使涟漪最终能覆盖整个按钮（基于对角线长度）
            var diagonal = Math.sqrt(root.width * root.width + root.height * root.height)
            var maxScale = diagonal / 2  // 初始直径2，缩放后直径 = 2 * scale，需 >= 对角线

            var ripple = component.createObject(root, {
                                                    center: point,
                                                    maxScale: maxScale,
                                                    duration: 400
                                                })
        } else {
            console.error("Failed to load ripple component:", component.errorString())
        }
    }

    contentItem: Text {
        text: root.text
        color: "#030303"
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
