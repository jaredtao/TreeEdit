import QtQuick 2.0
import QtQuick.Controls 2.12
Rectangle {
    id: root
    color: config.darkerColor
    property var dataSource: null
    onDataSourceChanged: {
        if (dataSource) {
            propList = Object.keys(dataSource).filter(k=>!k.startsWith("TModel_"))
            console.log(propList)
        } else {
            propList = []
        }
    }
    property var propList
    ListView {
        id: listView
        model: propList
        anchors.fill: parent

        delegate: Column {
            width: listView.width
            height: 70
            Rectangle {
                height: 35
                width: parent.width
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: modelData
                    color: config.constrastColor
                }
            }
            Loader {
                height: 35
                width: parent.width
                sourceComponent: {
                    console.log(typeof dataSource[modelData])
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
        }
        ScrollIndicator.vertical: ScrollIndicator { }
    }
    Component {
        id: stringComp
        TextField {
            property string compData
            text: compData
            height: parent.height
            width: parent.width * 0.8
            selectByMouse: true
            background: Rectangle {
                width: listView.width
                height: 35
                color: config.normalColor
            }
        }
    }
    Component {
        id: numberComp
        SpinBox {
            property double compData
            value: compData
        }
    }
    Component {
        id: boolComp
        CheckBox {
            property bool compData
            checked: compData
        }
    }
    Component {
        id: jsComp
        TextField {
            property var compData
            text: JSON.stringify(compData)

            height: parent.height
            width: parent.width * 0.8
            selectByMouse: true
            background: Rectangle {
                width: listView.width
                height: 35
                color: config.normalColor
            }
        }
    }
}
