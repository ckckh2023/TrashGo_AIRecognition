import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Imagine

Dialog {
    id: root

    property string dialogTitle: ""
    property string messageText: ""
    property string acceptText: ""
    property string rejectText: ""
    property bool showRejectButton : true

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
}
