import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Rectangle {
    id: root
    color: config.darkerColor
    property var treeView
    property var treeModel
    Item {
        width: parent.width
        height: 35
        TText {
            text: String("树 (节点总数：%1)").arg(treeModel.count)
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
                    treeView.currentIndex = treeModel.addNode(treeView.currentIndex, {"name": "新建项"})
                    treeView.positionTo(treeView.currentIndex)
                }
            }
            TIconButton {
                anchors.verticalCenter: parent.verticalCenter
                imageUrl: "qrc:/img/delete.png"
                normalColor: treeHeader.color
                tipText: "删除"
                onClicked: {
                    treeModel.remove(treeView.currentIndex)
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
                    treeModel.expandAll()
                }
            }
            TIconButton {
                anchors.verticalCenter: parent.verticalCenter
                imageUrl: "qrc:/img/collapse.png"
                normalColor: treeHeader.color
                tipText: "全部折叠"
                onClicked: {
                    treeModel.collapseAll()
                }
            }
        }
    }

    TSearchInput {
        y: 34
        width: parent.width
        height: 34
        property var searchHitList: []
        count: searchHitList.length
        onTextChanged: {
            if (length > 0) {
                searchHitList = treeModel.search("name", text)
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
                treeModel.expandTo(searchHitList[current])
                treeView.currentIndex = searchHitList[current]
                treeView.positionTo(searchHitList[current])
            }
        }
    }
}
