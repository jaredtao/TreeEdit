import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "./BasicComponent"
import "treeData.js" as TreeData
ApplicationWindow {
    id: rootWindow
    visible: true
    width: 800
    height: 600
    title: qsTr("TreeEdit")

    QtObject {
        id: config
        readonly property color backgroundColor: "#336A80"
        readonly property color mainColor: "#52A9CC"
        readonly property color normalColor: Qt.lighter(mainColor)
        readonly property color darkerColor: Qt.darker(mainColor)
        readonly property color constrastColor: "#51BDE8"
    }
    color: config.mainColor
    menuBar: MenuBar {
        Menu {
            title: "&File"
            Action {
                text: "Open"
            }
            Action {
                text: "Save"
            }
            Action {
                text: "Clear"
            }
        }
    }
    Column {

        x: 400
        y: 30
        TextField {
            id: iii
            selectByMouse: true
        }

        Button {
            onClicked: {
            iii.readOnly = !iii.readOnly
            }
        }
    }
    TTreeModel {
        id: tModel
        dataSource: TreeData.data
    }
    Rectangle {
        id: treeHeader
        width: 300
        height: 70
        color: config.darkerColor
        Item {
            width: parent.width
            height: 35
            Text {
                text: qsTr("树")
                anchors.verticalCenter: parent.verticalCenter
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
                TIconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    imageUrl: "qrc:/img/rename.png"
                    normalColor: treeHeader.color
                    tipText: "重命名"
                    onClicked: {

                    }
                }
            }
        }

        TextField {
            y: 32
            width: parent.width
            height: 34
            placeholderText: qsTr("请输入搜索内容")
        }
    }
    TTreeView {
        id: treeView
        width: treeHeader.width
        anchors {
            top: treeHeader.bottom
            bottom: parent.bottom
        }
        model: tModel.model
    }
    TPropView {
        id: propView
        width: 300
        anchors {
            right: parent.right
            top: treeHeader.bottom
            bottom: parent.bottom
        }
    }
}
