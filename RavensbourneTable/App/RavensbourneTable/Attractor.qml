import QtQuick 2.0

Item {
    //
    // layout
    //
    Rectangle {
        anchors.fill: parent
        color: colourYellow
    }
    //
    // blob animation
    //
    Item {
        id: blobs
        anchors.fill: parent
        Blob {

        }
        Blob {

        }
        Blob {

        }
        Blob {

        }
        Blob {

        }
        Blob {

        }
        Blob {

        }
        Blob {

        }
        Blob {

        }
        Blob {

        }
        Blob {

        }
        Blob {

        }
    }
    Image {
        anchors.fill: parent
        anchors.margins: 0
        source: "icons/rectangular-frame.svg"
    }
    //
    // TODO: move these into external qml
    //
    Rectangle {
        height: parent.height / 6
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 32
        color:colourTurquoise
        opacity: .75
        rotation: 180
        Text {
            anchors.fill: parent
            anchors.margins: 8
            font.family:ravensbourneBold.name
            font.pixelSize: parent.height / 4
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Place your middle finger on the scanner to begin"
        }
        Rectangle {
            width: 48
            height: 48
            radius: width /2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.bottom
            color:colourTurquoise
            opacity: .75
            Image {
                anchors.fill: parent
                source:"icons/down_arrow-black.png"
            }
        }
    }

    Rectangle {
        height: parent.height / 6
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 32
        color:colourTurquoise
        opacity: .75
        Text {
            anchors.fill: parent
            anchors.margins: 8
            font.family:ravensbourneBold.name
            font.pixelSize: parent.height / 4
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Place your middle finger on the scanner to begin"
        }
        Rectangle {
            width: 48
            height: 48
            radius: width /2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.bottom
            color:colourTurquoise
            opacity: .75
            Image {
                anchors.fill: parent
                source:"icons/down_arrow-black.png"
            }
        }
    }

    Timer {
        id: blobAnimation
        interval: 16
        repeat: true
        running: false
        property real previousTime: 0
        property real frameTime: 25.0
        onTriggered: {
            var currentTime = new Date().getTime()
            var elapsed = previousTime > 0 ? currentTime - previousTime : frameTime;
            previousTime = currentTime;
            var factor = elapsed / frameTime;
            var count = blobs.children.length;
            var energy = 0;
            for ( var i = 0; i < count; i++ ) {
                if ( blobs.children[i].type && blobs.children[i].type === 'blob' ) {
                    //
                    // apply forces
                    //
                    for ( var j = 0; j < count; j++ ) {
                        if ( i !== j && blobs.children[j].type && blobs.children[j].type === 'blob' ) {
                            blobs.children[i].applyForces( blobs.children[j], factor );
                        }
                    }
                    //
                    // update
                    //
                    energy += blobs.children[i].update(factor);
                }
            }
            if ( energy < count * 0.5 ) {
                for ( i = 0; i < count; i++ ) {
                    if ( blobs.children[i].type && blobs.children[i].type === 'blob' ) {
                        blobs.children[i].nudge();
                    }
                }

            }
        }
    }
    //
    //
    //
    function start() {
        blobAnimation.start();
    }
    function stop() {
        blobAnimation.stop();
    }
    //
    // fingerprint handling
    //
    function fingerPrintEnrollmentStage(device,stage) {
        if ( enrollFingerprint.visible ) enrollFingerprint.fingerPrintEnrollmentStage( device, stage );
    }
    function fingerPrintEnrolled(device,id) {
        if ( enrollFingerprint.visible ) enrollFingerprint.fingerPrintEnrolled( device, id );
    }
    function fingerPrintEnrollmentFailed(device) {
        if ( enrollFingerprint.visible ) enrollFingerprint.fingerPrintEnrollmentFailed( device );
    }
    function fingerPrintValidated(device,id) {
        console.log( 'Valid finger : ' + id );
        //
        // go to user home
        //
        if ( !enrollFingerprint.visible ) { // no enrollment in progress
            var user = Database.getUser(id);
            console.log( 'Validated user : ' + JSON.stringify(user) );
            var param = {
                user: user
            };
            appWindow.go("Home", param);
        }
    }
    function fingerPrintValidationFailed(device,error) {
        //
        // show enrollment dialog
        //
        console.log( 'validation failed : ' + error );
        if ( !enrollFingerprint.visible ) { // no enrollment in progress
            var param = {
                device: device
            }
            enrollFingerprint.setup(param);
            enrollFingerprint.visible = true;
        }
    }
    //
    //
    //
    function setup( param ) {
        var count = blobs.children.length;
        for ( var i = 0; i < count; i++ ) {
            if ( blobs.children[i].type && blobs.children[i].type === 'blob' ) {
                blobs.children[i].setup(param);
            }
        }
        start();
    }

    function close() {
        stop();
    }
}
