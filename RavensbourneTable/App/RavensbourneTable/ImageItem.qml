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
            radius: 8
            border.color: 'black'
            border.width: 4
        }

        Image {
            id: editorImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            onStatusChanged: {
                console.log( 'image item status changed : ' + status );
                busyIndicator.visible = !(status === Image.Ready)
            }
        }
    }
    Image {
        id: content
        anchors.fill: parent
        anchors.margins: 46
        source: editorImage.source
        fillMode: Image.PreserveAspectFit
        MouseArea {
            id: activateEditor
            anchors.fill: parent
            onClicked: {
                if ( container.state !== "locked" ) {
                    setActiveEditor(container,"image", { no_options: true } );
                }
            }
        }
    }

    AnimatedImage {
        id: busyIndicator
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        source:"icons/spinner.gif"
    }

    function setContent( source ) {
        editorImage.source = source;
    }

    function save() {
        var object = container.getGeometry();
        object.type = "image";
        object.source = editorImage.source.toString();
        return object;
    }

    function setup(param) {
        container.setGeometry(param);
        var source = param.source.toString().replace('qrc:/','');
        source = source.replace(/%22/g,'');
        console.log( source );
        editorImage.source = source;
    }

    function hasContent() {
        console.log( 'image source : ' + editorImage.source );
        return editorImage.source.length !== "";
    }

    function showPropertyEditor() {
        imageBrowser.show();
    }

    function enableEditing() {
        activateEditor.enabled = true;
    }

    function diableEditing() {
        activateEditor.enabled = false;
    }
}
