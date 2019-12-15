import QtQuick 2.10

MouseArea {
    id:operMouseArea
    anchors.fill: parent
    hoverEnabled: true

    property alias interval: timer.interval
    property bool isFirstClicked: false

    signal tDoubleClicked()

    onDoubleClicked: { mouse.accepted = false;}
    onPositionChanged: { mouse.accepted = false;}
    onPressed:  {
        if (isFirstClicked) {
            tDoubleClicked()
        } else {
            isFirstClicked = true;
            timer.start()
        }
        mouse.accepted = false;
    }
    onPressAndHold: { mouse.accepted = false; }
    onClicked:  {
        mouse.accepted = false;
    }

    onReleased: {
        mouse.accepted = false;
    }
    onWheel: { wheel.accepted = false; }


    Timer {
        id: timer
        interval: 200
        repeat: false
        triggeredOnStart: false
        running: false
        onTriggered: {
            isFirstClicked = false
        }
    }
}
