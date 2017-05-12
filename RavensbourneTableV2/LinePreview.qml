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
    property alias lineWidth: line.width
    property alias colour: line.color
    //
    //
    //
    Rectangle {
        id: line
        width: 4
        height: width
        radius: width / 2.
        anchors.centerIn: parent
        color: "black"
    }
}
