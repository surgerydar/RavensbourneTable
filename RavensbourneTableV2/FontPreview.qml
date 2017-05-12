import QtQuick 2.7
import QtQuick.Controls 2.1

Rectangle {
    width: 46
    height: 46
    radius: height /2.
    color: "#EEEDEB"
    //
    //
    //
    property alias font: label.font
    property alias colour: label.color
    //
    //
    //
    Label {
        id: label
        anchors.centerIn: parent
        font.pixelSize: 32
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "A"
    }
}
