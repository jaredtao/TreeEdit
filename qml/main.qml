import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import Tools 1.0
import "./BasicComponent"
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
    TDialog {
        id: fileDialog
    }
    TMessageBox {
        id: messageBox
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
                        let data = Tools.readFile(path)
                        if (data.length <= 0) {
                            messageBox.showMessage("提示", "文件为空")
                        }
                        try {
                            let arr = JSON.parse(data)
                            tModel.dataSource = arr;
                        } catch(e) {
                            messageBox.showMessage("错误", "解析出错:" + e,)
                        }
                    });
                }
            }
            Action {
                text: "Save"
            }
            Action {
                text: "Clear"
                onTriggered: {
                    tModel.dataSource = []
                }
            }
        }
    }
    TTreeModel {
        id: tModel
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
                        treeView.currentIndex = tModel.add(treeView.currentIndex, {"name": "新建项"})
                        treeView.positionTo(treeView.currentIndex)
                    }
                }
                TIconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    imageUrl: "qrc:/img/delete.png"
                    normalColor: treeHeader.color
                    tipText: "删除"
                    onClicked: {
                        tModel.remove(treeView.currentIndex)
                        treeView.currentIndex = -1
                    }
                }
                TIconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    imageUrl: "qrc:/img/rename.png"
                    normalColor: treeHeader.color
                    tipText: "重命名"
                    onClicked: {
                        treeView.rename(treeView.currentIndex)
                    }
                }
                TIconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    imageUrl: "qrc:/img/expand.png"
                    normalColor: treeHeader.color
                    tipText: "全部展开"
                    onClicked: {
                        tModel.expandAll()
                    }
                }
                TIconButton {
                    anchors.verticalCenter: parent.verticalCenter
                    imageUrl: "qrc:/img/collapse.png"
                    normalColor: treeHeader.color
                    tipText: "全部折叠"
                    onClicked: {
                        tModel.collapseAll()
                    }
                }
            }
        }

        TSearchInput {
            y: 32
            width: parent.width
            height: 34
            property var searchHitList: []
            count: searchHitList.length
            onTextChanged: {
                if (length > 0) {
                    searchHitList = tModel.search("name", text)
                    count = searchHitList.length
                    current = 0
                    updatePos()
                } else {
                    searchHitList = []
                    count = 0
                    current = 0
                }
            }
            onLastClicked: {
                if (count > 0) {
                    current = (count + current - 1) % count
                    updatePos()
                }
            }
            onNextClicked: {
                if (count > 0) {
                    current = (current + 1) % count
                    updatePos()
                }
            }
            function updatePos() {
                if (current >= 0 && current < count) {
                    tModel.expandTo(searchHitList[current])
                    treeView.currentIndex = searchHitList[current]
                    treeView.positionTo(searchHitList[current])
                }
            }
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
        onExpand: {
            tModel.expand(index)
        }
        onCollapse: {
            tModel.collapse(index)
        }
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
