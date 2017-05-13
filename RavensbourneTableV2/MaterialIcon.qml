import QtQuick 2.7
import QtQuick.Controls 2.1

Rectangle {
    id: container
    width: 58
    height: 58
    radius: height / 2.
    //
    //
    //
    StandardButton {
        id: scanner0
        anchors.centerIn: container
        icon: "icons/open-black.png"
        onClicked: {
            container.showMaterial(barcode)
        }
        //
        // TODO: AnimatedImage
        //
        AnimatedImage {
            id: animatedImage
            anchors.fill: parent
            anchors.margins: 4
            fillMode: Image.PreserveAspectFit
        }
    }
    //
    //
    //
    signal showMaterial(string barcode)
    //
    //
    //
    property string device: "test"
    property string barcode: ""
}

