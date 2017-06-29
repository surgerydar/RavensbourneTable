import QtQuick 2.7

Rectangle {
    id: container
    //
    // geometry
    //
    radius: 29
    clip: true
    //color: colourGreen
    color: colourTurquoise
    //
    //
    //
    signal contentChanged
    signal confirm
    signal close
    //
    // TODO: universal show/hide etc
    //
    function isOpen() {
        return state === "open";
    }
    //
    //
    //
    state: "closed"
    states: [
        State {
            name: "open"
            AnchorChanges { target: container; anchors.top: parent.top; }
            PropertyChanges { target: container; anchors.topMargin: 16; }
        },
        State {
            name: "closed"
        }
    ]
    transitions: Transition {
        AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad; }
    }
}
