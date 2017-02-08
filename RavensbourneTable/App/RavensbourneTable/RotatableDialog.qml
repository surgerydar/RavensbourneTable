import QtQuick 2.0

Item {
    Rectangle {
        id: background
        anchors.fill: parent
        radius: width / 2
        color: colourTurquoise
    }
    Rectangle {
        width: 48
        height: 48
        radius: width / 2
        color: colourTurquoise
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.top
        Image {
            anchors.fill: parent
            source: "icons/rotate-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.parent.rotation = parent.parent.rotation === 0 ? 180 : 0
            }
        }
    }
    Rectangle {
        width: 48
        height: 48
        radius: width / 2
        color: colourTurquoise
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.bottom
        Image {
            anchors.fill: parent
            source: "icons/rotate-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.parent.rotation = parent.parent.rotation === 0 ? 180 : 0
            }
        }
    }

    Behavior on rotation {
        NumberAnimation {
            duration: 250
        }
    }
}
