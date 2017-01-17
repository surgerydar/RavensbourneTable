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
                id: selectImage
                height: parent.height
                anchors.left: parent.left
                text: qsTr("Local Image")
                onClicked: {
                    selectImageDialog.visible = true;
                }
            }
            ToolButton {
                id: enterUrl
                height: parent.height
                anchors.left: selectImage.right
                text: qsTr("Online Image")
                onClicked: {
                    selectImageDialog.visible = true;
                }
            }
        }
        Rectangle {
            anchors.fill: parent
            border.color: "black"
        }

        Image {
            id: editorImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }
    }
    Image {
        id: content
        anchors.fill: parent
        anchors.margins: 46
        source: editorImage.source
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.state = "edit";
            }
        }
    }

    FileDialog {
        id: selectImageDialog
        title: "Choose an image"
        folder: shortcuts.pictures
        nameFilters: [ "Image files (*.jpg *.jpeg *.png *.gif)" ]
        onAccepted: {
            //
            // TODO: need to import image, this would mean uploading to assets on server
            //
            editorImage.source = fileUrl
        }
    }
}
