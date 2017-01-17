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

        Rectangle {
            anchors.fill: parent
            border.color: 'black'
        }

        TextEdit {
            id: editorText
            anchors.fill: parent

            padding: 8
            text: qsTr( "hello")
            textFormat: TextEdit.RichText
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
    Component.onCompleted: {
        if ( parent.parent.textFont ) {
            console.log( "setting font");
            editorText.font = parent.parent.textFont;
            editorText.color = parent.parent.textColour;
            content.font = parent.parent.textFont;
            content.color = parent.parent.textColour;
        }
    }
}
