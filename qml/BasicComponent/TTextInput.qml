import QtQuick 2.12
import QtQuick.Controls 2.12

TextInput {

    signal tEditFinished()
    property bool editable: true
    onEditableChanged: {
        if (editable) {
            forceActiveFocus()
            ensureVisible(0)
        } else {
            deselect()
        }
    }
    readOnly: !editable
    selectByMouse: editable
    verticalAlignment: Text.AlignVCenter

    onFocusChanged: {
        if (!focus) {
            tEditFinished()
            editable = false
            deselect()
        }
    }
    Keys.enabled: editable
    Keys.onReturnPressed: {
        tEditFinished()
        editable = false
        deselect()
    }
    Keys.onEnterPressed: {
        tEditFinished()
        editable = false
        deselect()
    }
}
