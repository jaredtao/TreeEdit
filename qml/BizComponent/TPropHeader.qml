import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Rectangle {
    id: root
    color: config.darkerColor
    border.width: 1
    border.color: "gray"
    Text {
        text: String("节点属性")
        anchors.centerIn: parent
    }
}
