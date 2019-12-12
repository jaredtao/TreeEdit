import QtQuick 2.0
//边框。不用透明色。
Item {
    anchors.fill: parent
    property int borderWidth: 1
    property color borderColor: "gray"
    Rectangle {
        width: borderWidth
        height: parent.height
    }
    Rectangle {
        x: parent.width - borderWidth
        width: borderWidth
        height: parent.height
        color: borderColor
    }
    Rectangle {
        width: parent.width
        height:  borderWidth
        color: borderColor
    }
    Rectangle {
        y: parent.height - borderWidth
        width: parent.width
        height:  borderWidth
        color: borderColor
    }
}
