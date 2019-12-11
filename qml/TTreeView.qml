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
            color: (listView.currentIndex === index || area.hovered) ? config.normalColor : config.darkerColor
            height: model["TModel_expend"] === true ? 30 : 0
            visible: height > 0
            TextInput {
                id: nameEdit
                anchors.verticalCenter: parent.verticalCenter
                x: root.basePadding + model["TModel_depth"] * root.subPadding
                text: model.name
                height: parent.height
                width: parent.width * 0.8 - x
                readOnly: true
                selectByMouse: !readOnly
                verticalAlignment: Text.AlignVCenter
                onFocusChanged: {
                    if (!focus) {
                        readOnly = true
                        deselect()
                    }
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
                    nameEdit.forceActiveFocus()
                    nameEdit.readOnly = false;
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
