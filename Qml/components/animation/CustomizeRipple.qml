import QtQuick 2.15

Item {
    id: root

    // 涟漪中心点（相对于父项）
    property point center: Qt.point(0, 0)
    // 涟漪颜色
    property color color: "#80555555"
    // 最大缩放比例（决定最终半径）
    property real maxScale: 2.0
    // 动画持续时间（毫秒）
    property int duration: 500

    // 内部圆形
    Rectangle {
        id: ripple
        width: 2   // 初始直径，会被scale放大
        height: 2
        radius: width / 2
        color: root.color
        opacity: 0.8

        // 将矩形中心对齐到指定的 center 点
        x: root.center.x - width / 2
        y: root.center.y - height / 2

        // 缩放动画
        scale: 0
        NumberAnimation on scale {
            from: 0
            to: root.maxScale
            duration: root.duration
            easing.type: Easing.OutQuad
        }

        // 透明度动画
        NumberAnimation on opacity {
            from: 0.8
            to: 0
            duration: root.duration
            easing.type: Easing.OutQuad
        }

        // 动画结束后销毁自身
        onOpacityChanged: if (opacity === 0) root.destroy()
    }
}
