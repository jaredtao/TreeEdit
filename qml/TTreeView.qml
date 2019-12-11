import QtQuick 2.12
import QtQuick.Controls 2.12
import "./BasicComponent"
Item {
    id: root
    property alias model: listView.model
    property int basePadding: 4
    property int subPadding: 16
    clip: true

    ListView {
        id: listView
        anchors.fill: parent
        currentIndex: -1
        delegate: Rectangle {
            width: listView.width
            color: (listView.currentIndex === index || hoverHander.hovered) ? config.normalColor : config.darkerColor
            height: model["TModel_expend"] === true ? 30 : 0
            visible: height > 0
            TextInput {
                id: nameEdit
                anchors.verticalCenter: parent.verticalCenter
                x: root.basePadding + model["TModel_depth"] * root.subPadding
                text: model.name
                readOnly: focus

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
            }
            MouseArea {
                id: area
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button === Qt.RightButton) {

                    } else {
                        listView.currentIndex = index;
                        if (model["TModel_hasChildren"]) {
                            if( true === model["TModel_childrenExpend"]) {
                                collapse(index)
                            } else {
                                expand(index)
                            }
                        }
                    }
                }
                onDoubleClicked: {

                    let p = mapToItem(nameEdit, mouseX, mouseY)
                    nameEdit.focus = true
                    nameEdit.moveCursorSelection(nameEdit.positionAt(p.x, p.y))
                }
            }
            HoverHandler {
                id: hoverHander
            }
        }
    }
    TBorder {}
    //展开子级，不递归
    function expand(index) {
        let parentObj = model.get(index)
        let depth = parentObj["TModel_depth"]

        for (let i = index + 1; i < model.count; i++) {
            let obj = model.get(i);
            if (obj["TModel_depth"] <= depth) {
                break;
            } else if (obj["TModel_depth"] > depth + 1) {
                continue;
            }
            model.setProperty(i, "TModel_expend", true)
        }
        model.setProperty(index, "TModel_childrenExpend", true)
    }
    //折叠子级，递归
    function collapse(index) {
        let parentObj = model.get(index)
        let depth = parentObj["TModel_depth"]

        for (let i = index + 1; i < model.count; i++) {
            let obj = model.get(i);
            if (obj["TModel_depth"] <= depth) {
                break;
            }
            model.setProperty(i, "TModel_expend", false)
            model.setProperty(i, "TModel_childrenExpend", false)
        }
        model.setProperty(index, "TModel_childrenExpend", false)
    }
}
