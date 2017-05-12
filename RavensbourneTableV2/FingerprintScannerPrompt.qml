import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Rectangle {
    height: 58
    radius: height / 2
    width: text.contentWidth + ( radius * 2 )
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.margins: 32
    color:"white"
    //
    //
    //
    property alias prompt: text.text
    //
    //
    //
    Rectangle {
        id: arrow
        width: 48
        height: 48
        radius: width /2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: -24
        color:"white"
        Image {
            width:38
            height:38
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.bottom: parent.bottom
            source:"icons/down_arrow-black.png"
        }
        SequentialAnimation {
            running: container.visible
            loops: Animation.Infinite
            NumberAnimation { target: arrow; property: "height"; from: 48; to: 64; duration: 500 }
            NumberAnimation { target: arrow; property: "height"; from: 64; to: 48; duration: 1000 }
        }
    }
    Text {
        id: text
        anchors.fill: parent
        anchors.margins: 8
        font.family:ravensbourneBold.name
        font.pixelSize: 32
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
