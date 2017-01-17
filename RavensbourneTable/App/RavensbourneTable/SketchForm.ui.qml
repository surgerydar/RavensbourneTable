import QtQuick 2.4
import QtQuick.Controls 2.0

Item {
    property alias sketch: sketch
    property alias textButton: textButton
    property alias imageButton: imageButton
    property alias drawButton: drawButton
    property alias selectButton: selectButton
    property alias deleteButton: deleteButton

    MouseArea {
        id: sketch
        anchors.fill: parent
        ButtonGroup {
            id: toolbuttons
        }
        ToolBar {
            id: toolbar
            y: 440
            height: 40
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            ToolButton {
                id: textButton
                y: 0
                width: 80
                text: qsTr("Text")
                checked: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 0
                checkable: true
                ButtonGroup.group: toolbuttons
            }
            ToolButton {
                id: imageButton
                y: 0
                width: 80
                text: qsTr("Image")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: textButton.right
                anchors.leftMargin: 4
                checkable: true
                ButtonGroup.group: toolbuttons
            }

            ToolButton {
                id: drawButton
                y: 0
                width: 80
                text: qsTr("Draw")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: imageButton.right
                anchors.leftMargin: 4
                checkable: true
                ButtonGroup.group: toolbuttons
            }

            ToolButton {
                id: selectButton
                x: 254
                y: 0
                width: 80
                text: qsTr("Select")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: drawButton.right
                anchors.leftMargin: 4
                checkable: true
                ButtonGroup.group: toolbuttons
            }

            ToolButton {
                id: deleteButton
                x: 340
                y: 0
                width: 80
                text: qsTr("Delete")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: selectButton.right
                anchors.leftMargin: 4
                checkable: true
                ButtonGroup.group: toolbuttons
            }
        }
    }
}
