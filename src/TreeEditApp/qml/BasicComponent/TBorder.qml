import QtQuick 2.0
//边框。不用透明色。
Item {
    anchors.fill: parent
    property int borderWidth: 1
    property color borderColor: "gray"
    Rectangle {
        x: -borderWidth
        width: borderWidth
        height: parent.height
    }
    Rectangle {
        x: parent.width
        width: borderWidth
        height: parent.height
        color: borderColor
    }
    Rectangle {
        y: - borderWidth
        width: parent.width
        height:  borderWidth
        color: borderColor
    }
    Rectangle {
        y: parent.height
        width: parent.width
        height:  borderWidth
        color: borderColor
    }
}
