import QtQuick 2.0
import QtQuick.Controls 2.12
TextField {
    id: t
    property color backgroundColor: "white"
    property int borderWidth: 0
    property color borderColor: "transparent"
    selectByMouse: true
    background: Rectangle {
        implicitWidth: t.width
        implicitHeight: t.height
        color: t.backgroundColor
        border.color: t.borderColor
        border.width: t.borderWidth
    }
}
