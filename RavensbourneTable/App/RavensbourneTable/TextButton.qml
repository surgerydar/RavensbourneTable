import QtQuick 2.7

Rectangle {
    property alias text: label.text
    signal clicked()
    width: 96
    height: 48
    radius: height / 2
    color: "transparent"
    border.width: 4
    border.color: "black"
    Text {
        id: label
        anchors.fill: parent
        font.family: ravensbourneBold.name
        font.pixelSize: 24
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: "black"
        onLineLaidOut: {
            parent.width = line.width + 32;
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            parent.clicked();
        }
    }
}
