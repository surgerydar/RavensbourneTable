import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

Editor {
    id: container
    //
    //
    //
    property alias content: editor.text
    property alias font: editor.font
    property alias colour: editor.color
    property alias alignment: editor.horizontalAlignment
    //
    //
    //
    Rectangle {
        anchors.left: editor.left
        anchors.right: editor.right
        anchors.top: editor.top
        anchors.bottom: editor.bottom
        color: "white"
    }

    TextEdit {
        id: editor
        anchors.left: parent.left
        anchors.leftMargin: 64
        anchors.right: parent.right
        anchors.rightMargin: 64
        anchors.top: parent.top
        anchors.topMargin: 64
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 64
        padding: 16
        font.pixelSize: 32
        onTextChanged: {
            contentChanged();
        }
    }
    //
    //
    //
    onAlignmentChanged: {
        editor.update();
    }

    //
    //
    //
    function show( item ) {
        state = "open"
        if ( item ) {
            editor.text = item.content;
            editor.font = item.font;
            editor.horizontalAlignment = item.alignment;
            editor.color = item.colour;
        }
    }
    function hide() {
        state = "closed"
        editor.focus = false;
        editor.text = "";
    }
    function hasContent() {
        return editor.text.length > 0;
    }
    function getContent() {
        return { type: "text", content: editor.text, font: editor.font, colour: editor.color, alignment: editor.horizontalAlignment };
    }
    function save() {
        confirm();
    }
}
