import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Item {
    id: root
    readonly property string __depthKey: "TModel_depth"
    readonly property string __expendKey: "TModel_expend"
    readonly property string __childrenExpendKey: "TModel_childrenExpend"
    readonly property string __hasChildendKey: "TModel_hasChildren"

    readonly property string __parentKey: "TModel_parent"
    readonly property string __childrenKey: "TModel_children"

    property alias sourceModel: listView.model
    property int basePadding: 4
    property int subPadding: 16
    property alias currentIndex: listView.currentIndex
    property alias header: listView.header
    property alias treeListView: listView
    property var currentData

    onCurrentIndexChanged: {
        if (currentIndex < 0) {
            currentData = null;
        }
    }
    clip: true

    signal collapse(int index);
    signal expand(int index);
    ListView {
        id: listView
        anchors.fill: parent
        currentIndex: -1
        delegate: Rectangle {
            id: delegateRect
            width: listView.width
            color: (listView.currentIndex === index || area.hovered) ? config.normalColor : config.darkerColor
            height: model.display[__expendKey] === true ? 30 : 0
            visible: height > 0
            property alias editable: nameEdit.editable
            property alias editItem: nameEdit
            TTextInput {
                id: nameEdit
                anchors.verticalCenter: parent.verticalCenter
                x: root.basePadding + model.display[__depthKey] * root.subPadding
                text: model.display["name"]
                height: parent.height
                width: parent.width * 0.8 - x
                editable: false
                onTEditFinished: {
                    console.log("onTEditFinished", displayText)
                    sourceModel.setNodeValue(index, "name", displayText)
                }
            }
            TTransArea {
                id: area
                height: parent.height
                width: parent.width - controlIcon.x
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onPressed: {
//                    if (listView.currentIndex === index) {
//                        listView.currentIndex = -1;
//                    } else {
                        listView.currentIndex = index;
                        currentData = model.display
//                    }
                }
                onTDoubleClicked: {
                    delegateRect.editable = true;
                    nameEdit.forceActiveFocus()
                    nameEdit.ensureVisible(0)
                }
            }
            Image {
                id: controlIcon
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 20
                }
                visible: model.display[__hasChildendKey]
                source: model.display[__childrenExpendKey] ? "qrc:/img/collapse.png" : "qrc:/img/expand.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (model.display[__hasChildendKey]) {
                            if( true === model.display[__childrenExpendKey]) {
                                collapse(index)
                            } else {
                                expand(index)
                            }
                        }
                    }
                }
            }
        }
        add: Transition {
            NumberAnimation  { from: -root.width; to: 0; properties: "x"; duration: 300; easing.type: Easing.OutQuad }
        }
        remove: Transition {
            NumberAnimation { to: -root.width; property: "x"; duration: 300; easing.type: Easing.OutQuad }
        }
        displaced : Transition {
            NumberAnimation  { properties: "x,y"; duration: 300; easing.type: Easing.OutQuad }
        }
    }
    TBorder {}

    function rename(index) {
        if (listView.currentItem) {
            listView.currentItem.editable = !listView.currentItem.editable
        }
    }
    function positionTo(index) {
        listView.positionViewAtIndex(index, ListView.Center)
    }
}
