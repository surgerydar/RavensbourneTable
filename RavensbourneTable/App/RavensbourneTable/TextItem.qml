import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import "GeometryUtils.js" as GU
import "./EditablItem"
import SodaControls 1.0
import QtQuick.VirtualKeyboard 2.1

EditableItem {
    id: container

    TextEdit {
        id: content
        anchors.fill: parent
        anchors.margins: 8
        padding: 8
        textFormat: TextEdit.PlainText
        //wrapMode: TextEdit.Wrap
        readOnly: true
        enabled: false
        clip: true
        font.family: "Helvetica"
        font.pixelSize: 32
        onEnabledChanged: {
            focus = enabled;
        }
        //
        //
        //
        onTextChanged: {
            if ( enabled && focus && previousText.length > 0 ) { // editing and not new
                fitContent();
            }
        }
    }

    Rectangle {
        id: textBounds
        color: "transparent"
        border.width: 1
        border.color: "black"
        radius: 4
        visible: false
        opacity: 0.5
    }

    //
    // placeholder text
    //
    Text {
        visible: content.text.length <= 0
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
    //
    //
    //
    function setContent( text ) {
        content.text = text;
        commitEditing();
    }

    function save() {
        var object = container.getGeometry()
        object.type = "text";
        object.text = content.text;
        object.colour = content.color;
        object.font = content.font;
        return object;
    }

    function setup(param) {
        container.setGeometry(param);
        content.text = param.text;
        try { // JONS: to get over the JSON re-encoding problem from update item
            content.color = param.colour;
        } catch( err ) {
            content.color = Qt.rgba( param.colour.r, param.colour.g, param.colour.b, 1. );
        }
        try {
            content.font = param.font;
        } catch( err ) {
            content.font.family = param.font.family;
            content.font.pixelSize = param.font.pixelSize;
            content.font.bold = param.font.bold;
            content.font.italic = param.font.italic;
            content.font.underline = param.font.underline;
        }
    }

    function hasContent() {
        return content.text.length > 0;
    }

    function showPropertyEditor() {
    }

    function setFont( font, colour ) {
        content.font = font
        content.color = colour;
        fitContent();
    }
    function getFont() {
        return content.font;
    }

    function getColour() {
        return content.color;
    }

    property string previousText: content.text
    property var previousFont: content.font
    property color previousColour: content.color

    function startEditing() {
        previousText = content.text;
        previousFont = content.font;
        previousColour = content.color;
        content.enabled = true;
        content.readOnly = false;
        content.clip = false;
        //textBounds.visible = true;
    }

    function commitEditing() {
        console.log('TextItem.commitEditing')
        content.focus = false;
        content.enabled = false;
        content.readOnly = true;
        content.clip = true;
        //textBounds.visible = true;
        fitContent();
    }

    function cancelEditing() {
        console.log('TextItem.cancelEditing')
        content.text = previousText;
        content.font = previousFont;
        content.color = previousColour;
        content.focus = false;
        content.enabled = false;
        content.readOnly = true;
        content.clip = true;
    }

    function fitContent() {
        //
        // adjust text bounds
        //
        var contentBounds = getContentBounds();
        textBounds.x = contentBounds.x;
        textBounds.y = contentBounds.y;
        textBounds.width = contentBounds.width;
        textBounds.height = contentBounds.height;
        //
        // calculate global center
        //
        var centerX = container.x + contentBounds.x + contentBounds.width / 2;
        var centerY = container.y + contentBounds.y + contentBounds.height / 2;
        //
        // fit container
        //
        container.width = contentBounds.width + 16;
        container.height = contentBounds.height + 16;
        container.x = centerX - container.width / 2;
        container.y = centerY - container.height / 2;
    }

    function getContentBounds() {
        var contentBounds = Qt.rect(content.x,content.y,content.contentWidth + content.padding * 2, content.contentHeight + content.padding * 2)
        //textBounds.visible = true;
        textBounds.x = contentBounds.x;
        textBounds.y = contentBounds.y;
        textBounds.width = contentBounds.width;
        textBounds.height = contentBounds.height;
        return contentBounds;
        //return Qt.rect(content.x,content.y,content.contentWidth + content.padding * 2, content.contentHeight + content.padding * 2)
    }

    Component.onCompleted: {
        type = "text";
        scaleable = false; // bounds always fits to text
    }

}
