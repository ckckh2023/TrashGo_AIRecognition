import QtQuick

QtObject {

    readonly property string themeSet: iniFileHandler.theme
    readonly property string colorSet: iniFileHandler.color

    readonly property color backgroundTop: {
        if (themeSet === "明亮") {
            if (colorSet === "蓝色") return "#f1f9fc"
            if (colorSet === "绿色") return "#f1fbf6"
            if (colorSet === "黄色") return "#fdfceb"
        } else if (themeSet === "黑暗") {
            if (colorSet === "蓝色") return "#3f4243"
            if (colorSet === "绿色") return "#3f4341"
            if (colorSet === "黄色") return "#44433d"
        }
        else return "#def0f7"
    }

    readonly property color backgroundBottom: {
        if (themeSet === "明亮") {
            if (colorSet === "蓝色") return "#def0f7"
            if (colorSet === "绿色") return "#def5ea"
            if (colorSet === "黄色") return "#faf8d0"
        } else if (themeSet === "黑暗") {
            if (colorSet === "蓝色") return "#383a3b"
            if (colorSet === "绿色") return "#383b39"
            if (colorSet === "黄色") return "#3c3b36"
        }
        else return "#def0f7"
    }

    readonly property color sideBarButton: {
        if (themeSet === "明亮") {
            if (colorSet === "蓝色") return "#c0d0e2f6"
            if (colorSet === "绿色") return "#c0d0f6e2"
            if (colorSet === "黄色") return "#c0e6e6d0"
        } else if (themeSet === "黑暗") {
            if (colorSet === "蓝色") return "#c03d4043"
            if (colorSet === "绿色") return "#c03d4340"
            if (colorSet === "黄色") return "#c041413d"
        }
        else return "#def0f7"
    }

    readonly property color comboBoxHighlighted: {
        if (themeSet === "明亮") {
            if (colorSet === "蓝色") return "#eaecf1"
            if (colorSet === "绿色") return "#eaf1eb"
            if (colorSet === "黄色") return "#f1efea"
        } else if (themeSet === "黑暗") {
            if (colorSet === "蓝色") return "#707d9f"
            if (colorSet === "绿色") return "#709f7a"
            if (colorSet === "黄色") return "#9f9270"
        }
        else return "#def0f7"
    }

    readonly property color bar: {
        if (themeSet === "明亮") return "#80ffffff"
        else if (themeSet === "黑暗") return "#80000000"
    }

    readonly property color text: {
        if (themeSet === "明亮") return "#030303"
        else if (themeSet === "黑暗") return "#fcfcfc"
    }

    readonly property color secondaryText: {
        if (themeSet === "明亮") return "#606060"
        else if (themeSet === "黑暗") return "#a0a0a0"
    }

    readonly property color card: {
        if (themeSet === "明亮") return "#80ffffff"
        else if (themeSet === "黑暗") return "#80000000"
    }

    readonly property color highOpacityCard: {
        if (themeSet === "明亮") return "#c0ffffff"
        else if (themeSet === "黑暗") return "#c0000000"
    }

    readonly property color opaqueCard: {
        if (themeSet === "明亮") return "#f3f3f3"
        else if (themeSet === "黑暗") return "#0c0c0c"
    }

    readonly property color defaultTransparentColor: {
        if (themeSet === "明亮") return "#00ffffff"
        else if (themeSet === "黑暗") return "#00000000"
    }

    readonly property color highlightedRectangle: {
        if (colorSet === "蓝色") return "#3dabff"
        if (colorSet === "绿色") return "#abff3d"
        if (colorSet === "黄色") return "#ff913d"
    }
}
