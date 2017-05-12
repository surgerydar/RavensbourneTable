import QtQuick 2.7
import QtQuick.Controls 2.1

StandardButton {
    id: button
    visible: device.length > 0 && barcode.length > 0
    enabled: visible
    icon: "icons/open-black.png"
    //
    //
    //
    /*
    SequentialAnimation {
        running: button.visible
        loops: Animation.Infinite
        NumberAnimation { target: button; property: "radius"; from: 23; to: 32; duration: 750 }
        NumberAnimation { target: button; property: "radius"; from: 32; to: 23; duration: 1000 }
    }
    */
    //
    //
    //
    //
    //
    //
    property string device: "test"
    property string barcode: ""
}

