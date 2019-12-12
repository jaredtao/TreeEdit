import QtQuick 2.12
import QtQuick.Controls 2.12
import "./BasicComponent"
Item {
    id: root
    property alias model: listView.model
    property int basePadding: 4
    property int subPadding: 16
    property alias currentIndex: listView.currentIndex
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
            height: model["TModel_expend"] === true ? 30 : 0
            visible: height > 0

            property alias editable: nameEdit.editable
            property alias editItem: nameEdit
            TTextInput {
                id: nameEdit
                anchors.verticalCenter: parent.verticalCenter
                x: root.basePadding + model["TModel_depth"] * root.subPadding
                text: model.name
                height: parent.height
                width: parent.width * 0.8 - x
                editable: false
                onTEditFinished: {
                    console.log("onTEditFinished", displayText)
                    model.name = displayText
                }
            }
            TTransArea {
                id: area
                height: parent.height
                width: parent.width - controlIcon.x
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onPressed: {
                    listView.currentIndex = index;
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
                visible: model["TModel_hasChildren"]
                source: model["TModel_childrenExpend"] ? "qrc:/img/collapse.png" : "qrc:/img/expand.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (mouse.button === Qt.RightButton) {

                        } else {

                            if (model["TModel_hasChildren"]) {
                                if( true === model["TModel_childrenExpend"]) {
                                    collapse(index)
                                } else {
                                    expand(index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    TBorder {}

    function rename(index) {
        if (listView.currentItem) {
            listView.currentItem.editable = !listView.currentItem.editable
        }
    }
}
