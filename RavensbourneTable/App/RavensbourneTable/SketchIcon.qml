import QtQuick 2.0

Blob {
    //
    //
    //
    color: "#00D2C2"
    //
    //
    //
    property var user: null
    property var sketch: null
    property Image icon: icon
    property Text name: name
    property var app: null
    property var home: null
    //
    //
    //
    Image {
        id: icon
        width: Math.sqrt( (parent.width*parent.width) / 2. )
        height: Math.sqrt( (parent.width*parent.width) / 2. )
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        onStatusChanged: {
            busyIndicator.visible = !(status === Image.Ready)
        }
    }
    AnimatedImage {
        id: busyIndicator
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        source:"icons/spinner.gif"
    }
    Rectangle {
        id: popup
        height: 128
        width: Math.min( name.implicitWidth, 128 - 32 ) + 32 + deleteSketch.width + editSketch.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 32
        visible: false
        color: "#00D2C2"
        Text {
            id: name
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 16
            color: "white"
            font.pixelSize: 18
            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignTop
            clip:true
        }
        Rectangle {
            id: deleteSketch
            width: 48
            height: 48
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 16
            color: "transparent"
            Image {
                anchors.fill: parent
                source: "icons/delete-white.png"
            }
            MouseArea {
                anchors.fill: parent
                //
                //
                //
                onClicked: {
                    if ( home && sketch ) {
                        home.deleteSketch( sketch.id );
                    }
                }
            }
        }
        Rectangle {
            id: editSketch
            width: 48
            height: 48
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            color: "transparent"
            Image {
                anchors.fill: parent
                source: "icons/forward_arrow-white.png"
            }
            MouseArea {
                anchors.fill: parent
                //
                //
                //
                onClicked: {
                    var param = {
                        user: user,
                        sketch: sketch
                    }
                    if ( app ) {
                        app.go('Sketch',param);
                    } else {
                        appWindow.go('Sketch',param);
                    }
                }
            }
        }
    }
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onClicked: {
            /*
            var param = {
                user: user,
                sketch: sketch
            }
            if ( app ) {
                app.go('Sketch',param);
            } else {
                appWindow.go('Sketch',param);
            }
            */
            popup.visible = !popup.visible;
        }
    }
    onWidthChanged: {
        icon.width = Math.sqrt( (width*width) / 2. )
        icon.height = Math.sqrt( (width*width) / 2. )
    }
}
