import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Rectangle {
    id: root
    color: config.darkerColor
    border.width: 1
    border.color: "gray"
    property var propView
    property var treeModel

    property alias nameWidth: nameItem.width
    property alias typeWidth: typeItem.width
    property alias valueWidth: valueItem.width
    Item {
        width: parent.width
        height: parent.height / 2
        TText {
            text: String("节点属性")
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }
        Row {
            height: parent.height
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            spacing: 4
            TIconButton {
                anchors.verticalCenter: parent.verticalCenter
                imageUrl: "qrc:/img/create.png"
                normalColor: treeHeader.color
                tipText: "创建"
                onClicked: {

                }
            }
            TIconButton {
                anchors.verticalCenter: parent.verticalCenter
                imageUrl: "qrc:/img/delete.png"
                normalColor: treeHeader.color
                tipText: "删除"
                onClicked: {
                }
            }
        }
    }
    Row {
        y: parent.height - height
        width: parent.width
        height: parent.height / 2
        Item {
            id: nameItem
            height: parent.height
            width: parent.width * 0.26
            TText {
                text: "名称"
                anchors.centerIn: parent
            }
            TBorder {}
        }
        Item {
            id: typeItem
            height: parent.height
            width: parent.width * 0.26
            TText {
                text: "类型"
                anchors.centerIn: parent
            }
            TBorder {}
        }
        Item {
            id: valueItem
            height: parent.height
            width: parent.width * 0.48
            TText {
                text: "数据"
                anchors.centerIn: parent
            }
            TBorder {}
        }
    }
}
