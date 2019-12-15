import QtQuick 2.12
import QtQuick.Controls 2.12
Rectangle {
    id: root
    property alias imageItem: img
    property alias imageUrl: img.source
    property alias imageWidth: img.width
    property alias imageHeight: img.height

    property alias containsMouse: area.containsMouse
    property alias containsPress: area.containsPress

    property alias toopTipItem: tip
    property string tipText

    property color normalColor
    property color hoveredColor: Qt.lighter(normalColor)
    property color pressedColor: Qt.darker(normalColor)

    color: containsPress ? pressedColor : (containsMouse ? hoveredColor : normalColor)
    signal clicked();
    signal doubleClicked()

    implicitWidth: img.width
    implicitHeight: img.height
    Image {
        id: img
        anchors.centerIn: parent
    }
    TToolTip {
        id: tip
        delay: 300
        text: root.tipText
    }
    MouseArea {
        id: area
        anchors.fill: parent;
        hoverEnabled: true;
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
        onDoubleClicked: root.doubleClicked()

        onContainsMouseChanged: {
            if (tip.text) {
                if (containsMouse)
                {
                    tip.open()
                }
                else
                {
                    tip.close()
                }
            }
        }
    }
}
