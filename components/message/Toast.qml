import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 300
    height: Math.max(50, textContent.implicitHeight + 20)
    radius: 5
    scale: 0

    color: {
        switch(type) {
            case "info":  return "#c02196F3"
            case "error": return "#c0F44336"
            case "warn":  return "#c0FF9800"
            default:      return "#c0333333"
        }
    }

    property string text
    property string type

    property bool ifHovered : false

    signal closed

    Text {
        id: textContent
        text: root.text
        anchors.left: root.left
        anchors.right: root.right
        anchors.verticalCenter: root.verticalCenter
        anchors.margins: 20
        wrapMode: Text.WordWrap
        color: "white"
        font.pixelSize: 16
    }

    //代码顺序排列：进入动画-悬停-退出动画
    Component.onCompleted: {
        enterAnim.start()
    }

    ScaleAnimator {
        id: enterAnim
        target: root
        from: 0
        to: 1
        duration: 200
        easing.type: Easing.OutBack
        onStopped: autoCloseTimer.start()
    }

    Timer {
        id: autoCloseTimer
        interval: 3000
        onTriggered: {
            exitAnim.start()
        }
        running: !root.ifHovered
    }

    ScaleAnimator {
        id: exitAnim
        target: root
        from: root.ifHovered ? 1.05 : 1
        to: 0
        duration: root.ifHovered ? 150 : 200
        easing.type: Easing.InOutQuad
        onStopped: root.closed()
    }

    //鼠标悬停时保持显示，点击时提前退出
    MouseArea {
        anchors.fill: root
        hoverEnabled: true

        onEntered: root.ifHovered = true
        onExited: root.ifHovered = false

        onClicked: exitAnim.start()
    }

    //悬停时略微放大，退出时恢复原状
    ScaleAnimator {
        id: zoomInAnim
        target: root
        from: 1
        to: 1.05
        duration: 200
        easing.type: Easing.OutBack
        running: root.ifHovered
    }

    ScaleAnimator {
        id: zoomOutAnim
        target: root
        from: 1.05
        to: 1
        duration: 200
        easing.type: Easing.OutBack
        running: !root.ifHovered
    }
}
