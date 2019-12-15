import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Dialog {
    id: root

    property string msg: ""
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    modal: true
    focus: true
    width: 400
    height: 300
    standardButtons: Dialog.Ok
    title: "提示"

    function showMessage(title, msg) {
        root.visible = true
        root.title = title
        root.msg = msg;
    }
    TText {
        anchors.centerIn: parent
        text: root.msg
        width: parent.width
    }
    onAccepted: {
        root.close()
    }
}
