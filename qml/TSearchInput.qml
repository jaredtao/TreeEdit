import QtQuick 2.12
import QtQuick.Controls 2.12
import "./BasicComponent"

Item {
    id: root
    property alias text: input.text
    property alias length: input.length
    property alias placeholderText: input.placeholderText
    property int current: 0
    property int count: 0
    property int displayCurrent: count === 0 ? current : current + 1
    signal lastClicked()
    signal nextClicked()
    Row {
        id: toolRow
        spacing: 4
        height: parent.height
        anchors.right: parent.right
        Rectangle {
            height: parent.height * 0.8
            anchors.verticalCenter: parent.verticalCenter
            color: "gray"
        }
        Text {
            text: displayCurrent + " / " + count
            visible: length > 0
            anchors.verticalCenter: parent.verticalCenter
        }
        TIconButton {
            id: lastBtn
            anchors.verticalCenter: parent.verticalCenter
            imageUrl: "qrc:/img/up.png"
            normalColor: treeHeader.color
            tipText: "上一个"
            onClicked: {
                input.focus = true
                lastClicked()
            }
        }
        TIconButton {
            id: nextBtn
            anchors.verticalCenter: parent.verticalCenter
            imageUrl: "qrc:/img/down.png"
            normalColor: treeHeader.color
            tipText: "下一个"
            onClicked: {
                input.focus = true
                nextClicked()
            }
        }
    }
    TextField {
        id: input
        height: parent.height
        width: toolRow.x
        placeholderText: qsTr("请输入搜索内容")
        selectByMouse: true
        color: "white"
        background: Item {
            width: root.width
            height: root.height
            TBorder {
                borderColor: (hoverHandler.hovered || input.focus || lastBtn.containsMouse || nextBtn.containsMouse) ? "#0099cc" : "#b8b9ba"
            }
        }
        HoverHandler {
            id: hoverHandler
        }
    }
}
