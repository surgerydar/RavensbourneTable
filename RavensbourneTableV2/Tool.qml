import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: container
    height: 58
    width: 58
    radius: height / 2.
    color: "#6EDD17" // TODO: colours.green in constants
    clip: true
    //
    //
    //
    //property string toolIcon: ""
    property alias toolIcon: toolButton.icon
    property string toolName: ""
    property Editor editor: null
    property alias options: options.model
    //
    //
    //
    signal selected
    signal confirmed
    signal closed
    //
    // tool button
    //
    Rectangle { // hide misplaced icons
        x: 0
        y: 0
        z: 1
        width: 58
        height: 58
        radius: height / 2
        color: container.color
    }

    StandardButton {
        id: toolButton
        anchors.left: container.left
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        z: 1
        //icon: toolIcon
        onClicked : {
            if ( container.state !== "open" ) {
                selected();
            }
        }
    }
    //
    //
    //
    ListView {
        id: options
        anchors.left: toolButton.right
        anchors.leftMargin: 16
        anchors.right: closeButton.left
        anchors.rightMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        //
        //
        //
        clip: true
        visible: container.state === "open"
        orientation: ListView.Horizontal
        spacing: 4
        //
        //
        //
        section.property: "group"
        section.criteria: ViewSection.FullString
        section.delegate: Rectangle {
            width: 46
            height: 46
            color: "transparent"
        }
    }
    LinearGradient {
        anchors.left: options.left
        anchors.top: options.top
        anchors.bottom: options.bottom
        width: options.height
        //source: options
        start: Qt.point(0,0)
        end: Qt.point(width,0)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(110./255.,221./255.,23./255,1.) }
            GradientStop { position: 1.0; color: Qt.rgba(110./255.,221./255.,23./255,0.) }
        }
    }
    LinearGradient {
        anchors.right: options.right
        anchors.top: options.top
        anchors.bottom: options.bottom
        width: options.height
        //source: options
        start: Qt.point(0,0)
        end: Qt.point(width,0)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(110./255.,221./255.,23./255,0.) }
            GradientStop { position: 1.0; color: Qt.rgba(110./255.,221./255.,23./255,1.) }
        }
    }
    //
    //
    //
    StandardButton {
        id: closeButton
        anchors.right: confirmButton.visible ? confirmButton.left : container.right
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        visible: container.state === "open"
        icon: "icons/close-black.png"
        onClicked : {
            if ( editor ) editor.hide();
            container.state = "closed";
            closed();
        }
    }
    StandardButton {
        id: confirmButton
        anchors.right: container.right
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        visible: container.state === "open"
        icon: "icons/done-black.png"
        onClicked : {
            if ( editor ) {
                if ( editor.isOpen() && editor.hasContent() ) editor.save();
                editor.hide();
            }
            container.state = "closed";
            confirmed();
        }
    }
    //
    //
    //
    state: "closed"
    states: [
        State {
            name: "open"
            AnchorChanges { target: container; anchors.left: parent.left; anchors.right: parent.right; }
            PropertyChanges { target: container; z: 1; anchors.leftMargin: 0; }
        },
        State {
            name: "closed"
            PropertyChanges { target: container; z: 0; }
        }
    ]
    transitions: Transition {
        // smoothly reanchor myRect and move into new position
        AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad; }
    }
    //
    //
    //
    onEditorChanged: {
        if ( editor ) {
            confirmButton.visible = !editor.isOpen() || editor.hasContent();
            editor.contentChanged.connect( function() {
                confirmButton.visible = !editor.isOpen() || editor.hasContent();
            });
            editor.stateChanged.connect( function() {
                confirmButton.visible = !editor.isOpen() || editor.hasContent();
            });
        } else {
            confirmButton.visible = true;
        }
    }

}
