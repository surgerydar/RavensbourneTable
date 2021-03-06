import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import "GeometryUtils.js" as GU
import "./EditablItem"
import SodaControls 1.0

EditableItem {
    id: container
    property string type: "text"
    Item {
        id: editor
        anchors.fill: parent
        anchors.margins: 46

        Rectangle {
            anchors.fill: parent
            radius: 8
            border.color: 'black'
            border.width: 4
        }

        TextEdit {
            id: editorText
            anchors.fill: parent
            padding: 8
            textFormat: TextEdit.PlainText
            wrapMode: TextEdit.Wrap
            clip: true
            /*
            onFocusChanged: {
                //
                // TODO: shift this to global focus hook
                //
                if( editorText.focus ) {
                    if ( container.rotation > 90 && container.rotation < 270 ) {
                        inputPanel.y        = inputPanel.parent.y;
                        inputPanel.rotation = 180;
                    } else {
                        inputPanel.y        = inputPanel.parent.height - inputPanel.height;
                        inputPanel.rotation = 0;
                    }
                } else {
                    inputPanel.y = inputPanel.parent.height;
                    inputPanel.rotation = 0;
                }
            }
            */
        }
        /*
        FontChooser {
            id: propertyEditor
            width: 240
            height: 240
            anchors.left: parent.right
            anchors.bottom: parent.top
            anchors.margins: 8

            enabled: true
            visible: false
            onFontChanged: {
                editorText.font = font;
                editorText.color = colour;
            }

        }
        */
        onVisibleChanged: {
            editorText.focus = visible;
        }
    }
    TextEdit {
        id: content
        anchors.fill: parent
        anchors.margins: 46
        color: editorText.color;
        padding: 8
        text: editorText.text
        font: editorText.font
        textFormat: TextEdit.PlainText
        wrapMode: TextEdit.Wrap
        readOnly: true
        clip: true
        MouseArea {
            id: activateEditor
            anchors.fill: parent
            onClicked: {
                setActiveEditor(container,"text");
            }
        }
    }
    Text {
        visible: editorText.text.length <= 0
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        color: "#EEEDEB"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 32
        text: "Enter Text"
        clip: true
    }

    function setContent( text ) {
        editorText.text = text;
    }
    function save() {
        var object = container.getGeometry()
        object.type = "text";
        object.text = editorText.text;
        object.colour = editorText.color;
        object.font = editorText.font;
        return object;
    }
    function setup(param) {
        container.setGeometry(param);
        editorText.text = param.text;
        editorText.color = param.colour;
        editorText.font = param.font;
    }
    function hasContent() {
        return editorText.text.length > 0;
    }
    function showPropertyEditor() {
        /*
        propertyEditor.visible = !propertyEditor.visible
        propertyToggle.source = !propertyEditor.visible ? "../icons/puck-black.png" : "../icons/hide-puck-black.png"
        */
    }

    Component.onCompleted: {
        if ( parent.parent.textFont ) {
            console.log( "setting font");
            /*
            editorText.font = parent.parent.textFont;
            editorText.color = parent.parent.textColour;
            content.font = parent.parent.textFont;
            content.color = parent.parent.textColour;
            */
        }
    }
    function enableEditing() {
        activateEditor.enabled = true;
    }

    function diableEditing() {
        activateEditor.enabled = false;
    }

    function setFontStyle( font, colour ) {
        editorText.font = font;
        editorText.color = colour;
    }
}
