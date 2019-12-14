import QtQuick 2.0

QtObject {
    id: config
    readonly property color backgroundColor: "#336A80"
    readonly property color mainColor: "#52A9CC"
    readonly property color normalColor: Qt.lighter(mainColor)
    readonly property color darkerColor: Qt.darker(mainColor)
    readonly property color constrastColor: "#51BDE8"
}
