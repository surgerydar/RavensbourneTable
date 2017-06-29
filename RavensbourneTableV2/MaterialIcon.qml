import QtQuick 2.7
import QtQuick.Controls 2.1

Image {
    id: container
    width: 150 / 2
    height: 200 / 2
    fillMode: Image.PreserveAspectFit
    source: alignment === "left" ? "icons/add-material-left-black.png" : "icons/add-material-right-black.png"
    //
    //
    //
    //property alias selected: scanner.checked
    //
    //
    //
    /*
    StandardButton {
        id: scanner
        anchors.centerIn: container
        icon: container.left < 64 ? "icons/add-material-left.png" :  "icons/add-material-right.png"
        checkable: true
        onClicked: {
            selected = true;
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
    */
    Rectangle {
        width: 24
        height: 24
        anchors.verticalCenter: container.top
        anchors.horizontalCenter: container.alignment === "left" ? parent.right : parent.left
        anchors.verticalCenterOffset: ( height / 2 );
        anchors.horizontalCenterOffset: container.alignment === "left" ? -( width / 2 ) : ( width / 2 );
        radius: 12
        color: colourRed
        visible: container.selected
    }
    //
    //
    //
    Rectangle {
        width: 24
        height: 24
        anchors.verticalCenter: container.bottom
        anchors.horizontalCenter: container.alignment === "left" ? parent.right : parent.left
        anchors.verticalCenterOffset: -( height / 2 );
        anchors.horizontalCenterOffset: container.alignment === "left" ? -( width / 2 ) : ( width / 2 );
        radius: 12
        color: colourYellow
        visible: container.newBarcode
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            container.newBarcode = false;
            container.showMaterial(container.barcode);
        }
    }
    //
    //
    //
    signal showMaterial(string barcode)
    //
    //
    //
    function setBarcode( code ) {
        if ( container.barcode !== code ) {
            container.barcode = code;
            container.newBarcode = true;
        }
    }

    //
    //
    //
    property bool newBarcode: false
    property bool selected: false
    property string device: "test"
    property string barcode: ""
    property string alignment: "left"
}

