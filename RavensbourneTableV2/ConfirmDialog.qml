import QtQuick 2.7
import QtQuick.Controls 2.1

Item {
    id: container
    height: 56
    width: prompt.contentWidth + noButton.width + yesButton.width + ( 8 * 4 ) + container.height / 2
    anchors.bottom: parent.bottom
    anchors.bottomMargin: -height
    anchors.horizontalCenter: parent.horizontalCenter
    opacity: 0.
    //
    //
    //
    property alias backgroundColour: background.color
    //
    //
    //
    Rectangle {
        id: cover
        anchors.top: parent.top
        anchors.topMargin: -parent.y
        anchors.left: parent.left
        anchors.leftMargin: -parent.x
        anchors.bottom: parent.bottom
        anchors.bottomMargin: ( parent.y + parent.height ) - parent.parent.height
        anchors.right: parent.right
        anchors.rightMargin: ( parent.x + parent.width ) - parent.parent.width
        color: Qt.rgba(1.,1.,1.,0.75)
        MouseArea {
            anchors.fill: parent
            enabled: container.state === "open"
            onClicked: {
                console.log('modal');
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: background
        anchors.fill: parent
        radius: height / 2

    }
    //
    //
    //
    Label {
        id: prompt
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: noButton.left
        anchors.leftMargin: container.height / 2
        anchors.rightMargin: 16
        verticalAlignment: Label.AlignVCenter
        font.family: ravensbourneRegular.name
        font.pixelSize: 18
    }
    //
    //
    //
    TextButton {
        id: noButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: yesButton.left
        anchors.margins: 8
        text: "no"
        onClicked: {
            hide();
        }
    }
    TextButton {
        id: yesButton
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.margins: 4
        text: "yes"
        onClicked: {
            if ( action ) {
                action();
            }
            hide();
        }
    }
    state: "closed"
    states: [
        State {
            name: "open"
            //AnchorChanges { target: container; anchors.top: parent.top; }
            PropertyChanges { target: container; anchors.bottomMargin: 148; opacity: 1. }
        },
        State {
            name: "closed"
        }
    ]
    transitions: Transition {
        AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad; }
    }
    property var action: null
    function show( text, callback ) {
        prompt.text = text;
        action = callback;
        state = "open"
    }
    function hide() {
        state = "closed";
        action = null;
    }

}
