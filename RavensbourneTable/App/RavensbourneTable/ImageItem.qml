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
        var visibleWidth = content.paintedWidth;
        var visibleHeight = content.paintedHeight;
        var centerX = container.x + container.width / 2;
        var centerY = container.y + container.height / 2;
        container.width = visibleWidth + 16;
        container.height = visibleWidth + 16;
        container.x = centerX - container.width / 2;
        container.y = centerY - container.width / 2;
    }


    Component.onCompleted: {
        type = "image";
    }
}
