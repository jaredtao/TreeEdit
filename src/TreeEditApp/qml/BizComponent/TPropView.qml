import QtQuick 2.12
import QtQuick.Controls 2.12
import "../BasicComponent"
Rectangle {
    id: root
    color: config.darkerColor
    property var dataSource: null
    property int nameWidth
    property int typeWidth
    property int valueWidth
    onDataSourceChanged: {
        if (dataSource) {
            propList = []
            propList = Object.keys(dataSource).filter(k=>!k.startsWith("TModel_"))
        } else {
            propList = []
        }
    }
    property var propList
    ListModel {
        id: propModel
    }
    ListView {
        id: listView
        model: propList
        anchors.fill: parent
        highlight: Rectangle {
            width: listView.width
            height: 35
            color: "transparent"
            border.width: 1
            border.color: "red"
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
        delegate: Item {
            width: listView.width
            height: 35
            Row {
                anchors.fill: parent
                Item {
                    height: parent.height
                    width: nameWidth
                    TTextField {
                        id: nameText
                        anchors.centerIn: parent
                        text: modelData
                        color: config.constrastColor
                        width: parent.width
                    }
                    TBorder {}
                }
                Item {
                    height: parent.height
                    width: typeWidth
                    TTextField {
                        anchors.centerIn: parent
                        text: typeof dataSource[modelData]
                        color: config.constrastColor
                        width: parent.width
                    }
                    TBorder {}
                }
                Item {
                    height: parent.height
                    width: valueWidth
                    Loader {
                        anchors.fill: parent
                        sourceComponent: {
                            switch (typeof dataSource[modelData]) {
                            case "number":
                                return numberComp
                            case "string":
                                return stringComp
                            case "boolean":
                                return boolComp
                            case "object":
                            default:
                                return jsComp
                            }
                        }
                        onLoaded: {
                            item.compData = dataSource[modelData]
                        }
                    }
                    TBorder{}
                }
            }
        }
        ScrollIndicator.vertical: ScrollIndicator { }
    }
    Component {
        id: stringComp
        TTextField {
            property string compData
            text: compData
            height: parent.height
            width: parent.width

        }
    }
    Component {
        id: numberComp
        TTextField {
            property double compData
            text: compData
            validator: DoubleValidator {}
        }
    }
    Component {
        id: boolComp
        CheckBox {
            id: checkBox
            property bool compData
            checked: compData
            text: checkBox.checked ? "true" : "false"
        }
    }
    Component {
        id: jsComp
        TTextField {
            id: field
            property var compData
            text: JSON.stringify(compData)
            height: parent.height
            width: parent.width
            selectByMouse: true
        }
    }
}
