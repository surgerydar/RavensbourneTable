import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import "GeometryUtils.js" as GU
import "./EditablItem"

EditableItem {
    id: container
    Item {
        id: editor
        anchors.fill: parent
        anchors.margins: 46
        ToolBar {
            id: toolbar
            height: 46
            anchors.bottom: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            background : Rectangle {
                anchors.fill: parent;
                color: "#800000FF"
            }
            ToolButton {
                id: bold
                height: parent.height
                anchors.left: parent.left
                text: qsTr("Font")
                onClicked: {
                    chooseFont.visible = true
                }
            }
        }
        TextEdit {
            id: editorText
            anchors.fill: parent

            padding: 8
            text: qsTr( "hello")
            textFormat: TextEdit.RichText
            font.italic: italic.checked
            font.bold: bold.checked
        }
    }
    TextEdit {
        id: content
        anchors.fill: parent
        anchors.margins: 46
        padding: 8
        text: editorText.text
        textFormat: TextEdit.RichText
        readOnly: false
        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.state = "edit"
            }
        }
    }
    FontDialog {
        id: chooseFont
        modality: Qt.NonModal
        onCurrentFontChanged: {
            editorText.font = font
            content.font = font
        }
    }
}
