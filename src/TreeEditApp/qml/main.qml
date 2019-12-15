import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import Tools 1.0
import "./BasicComponent"
import "./BizComponent"
import TreeModel 1.0
ApplicationWindow {
    id: rootWindow
    visible: true
    width: 1024
    height: 760
    title: qsTr("TreeEdit")

    TConfig {
        id: config
    }
    TDialog {
        id: fileDialog
    }
    TMessageBox {
        id: messageBox
    }
    Connections {
        target: tModel
        onShowMessage:{
            messageBox.showMessage("提示", message)
        }
    }
    color: config.mainColor
    menuBar: MenuBar {
        Menu {
            title: "&File"
            Action {
                text: "Open"
                onTriggered: {
                    fileDialog.openFile("选择一个Json文件", ["Json files (*.json)"], function (fileUrl) {
                        let path = Tools.toLocalFile(fileUrl);
                        tModel.loadFromJson(path);
                    });
                }
            }
            Action {
                text: "Save"
                onTriggered: {
                    if (tModel.count <= 0) {
                        messageBox.showMessage("提示", "数据为空")
                        return;
                    }
                    fileDialog.createFile("选择一个Json文件", ["Json files (*.json)"], function (fileUrl) {
                        let path = Tools.toLocalFile(fileUrl);
                        tModel.saveToJson(path);
                    });
                }
            }
            Action {
                text: "Clear"
                onTriggered: {
                    tModel.clear();
                }
            }
        }
    }
    TreeModel {
        id: tModel
    }
    TTreeHeader {
        id: treeHeader
        width: 300
        height: 70
        treeModel: tModel
        treeView: tView
    }
    TTreeView {
        id: tView
        width: treeHeader.width
        anchors {
            top: treeHeader.bottom
            bottom: parent.bottom
        }
        sourceModel: tModel
        onExpand: {
            tModel.expand(index)
        }
        onCollapse: {
            tModel.collapse(index)
        }
    }
    TPropHeader {
        id: propHeader
        width: 300
        height: 70
        treeModel: tModel
        propView: propertiesView
        anchors {
            right: parent.right
        }
    }
    TPropView {
        id: propertiesView
        width: propHeader.width
        nameWidth: propHeader.nameWidth
        typeWidth: propHeader.typeWidth
        valueWidth: propHeader.valueWidth
        dataSource: tView.currentData
        anchors {
            right: parent.right
            top: propHeader.bottom
            topMargin: 1
            bottom: parent.bottom
        }
    }
}
