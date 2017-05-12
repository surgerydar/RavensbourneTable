import QtQuick 2.7
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

Rectangle {
    id: container
    height: 58
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 16
    radius: height / 2
    color: colourGreen
    clip: true
    //
    //
    //
    property alias username: userName.text
    property alias prompt: prompt.text
    //
    //
    //
    signal logout
    signal search( string term )
    //
    // TODO: move the next two items into UserTool
    //
    //
    //
    //
    StandardButton {
        id: closeButton
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        icon: "icons/back_arrow-black.png"
        onClicked: {
            logout();
        }
    }
    StandardButton {
        id: userIcon
        anchors.left: closeButton.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        icon: "icons/user-black.png"
    }
    //
    //
    //
    Label {
        id: userName
        anchors.left: userIcon.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        color: "black"
        font.family: ravensbourneRegular.name
        font.pixelSize: 18
        horizontalAlignment: Label.AlignLeft
        verticalAlignment: Label.AlignVCenter
        text: "jonsrightmiddle"
    }
    //
    // Scrolling prompt
    //
    ListView {
        id: options
        anchors.left: userName.right
        anchors.leftMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        //
        //
        //
        clip: true
        orientation: ListView.Horizontal
        spacing: 4
        //
        //
        //
        model: VisualItemModel {
            OptionSpacer {
            }
            TextField {
                width: options.width / 4
                height: 48
                background: Rectangle {
                    radius: height / 2
                    color: "#EEEDEB"
                    border.color: "transparent"
                }
                font.family: ravensbourneRegular.name
                font.pixelSize: 18
                placeholderText: "search ..."
                onAccepted: {
                    container.search(text);
                }
            }
            OptionSpacer {
            }
            Label {
                id: prompt
                width: contentWidth
                height: 46
                color: "black"
                font.family: ravensbourneBold.name
                font.pixelSize: 24
                verticalAlignment: Label.AlignVCenter
                /*
                Component.onCompleted: {
                    text = container.prompt
                    container.promptChanged.connect( function() {
                        text = container.prompt
                    });
                }
                */
            }
        }
    }
    //
    //
    //
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
}
