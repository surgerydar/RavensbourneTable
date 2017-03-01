import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import "GeometryUtils.js" as GU
import "./EditablItem"

EditableItem {
    id: container

    Image {
        id: content
        anchors.fill: parent
        anchors.margins: 8
        fillMode: Image.PreserveAspectFit
        onStatusChanged: {
            busyIndicator.visible = !(status === Image.Ready)
        }
    }

    AnimatedImage {
        id: busyIndicator
        visible: true
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source:"icons/spinner.gif"
    }

    function setContent( source ) {
        content.source = source;
    }

    function save() {
        var object = container.getGeometry();
        object.type = "image";
        object.source = content.source.toString();
        return object;
    }

    function setup(param) {
        container.setGeometry(param);
        var source = param.source.toString().replace('qrc:/','');
        source = source.replace(/%22/g,'');
        content.source = source;
    }

    function hasContent() {
        return content.source.length !== "";
    }

    function showPropertyEditor() {

    }

    property string previousSource: content.source

    function startEditing() {
        previousSource = content.source;
    }

    function commitEditing() {
        fitContent();
    }

    function cancelEditing() {
        content.source = previousSource;
        fitContent();
    }

    function fitContent() {
        var contentBounds = getContentBounds();
        var centerX = container.x + contentBounds.x + contentBounds.width / 2;
        var centerY = container.y + contentBounds.y + contentBounds.height / 2;
        container.width = contentBounds.width + 16;
        container.height = contentBounds.height + 16;
        container.x = centerX - container.width / 2;
        container.y = centerY - container.height / 2;
    }


    function getContentBounds() {
        var offset = Qt.point(
                    content.x+(content.width-content.paintedWidth)/2,
                    content.y+(content.height-content.paintedHeight)/2
                    );
        return Qt.rect(offset.x,offset.y,content.paintedWidth, content.paintedHeight);
    }

    Component.onCompleted: {
        type = "image";
    }
}
