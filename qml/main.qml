import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
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
    TTreeModel {
        id: tModel
        dataSource: TreeData.data
    }
    Rectangle {
        id: treeHeader
        width: 400
        height: 35
        color: config.darkerColor
    }
    TTreeView {
        id: tView
        width: 400
        anchors {
            top: treeHeader.bottom
            bottom: parent.bottom
        }
        model: tModel.model
    }
}
