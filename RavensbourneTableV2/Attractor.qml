import QtQuick 2.7
import QtQuick.Controls 2.1

Item {
    id: container
    //
    // layout
    //
    Rectangle {
        anchors.fill: parent
        color: colourYellow
    }
    //
    // blobs
    //
    Blobs {
        id: blobs
        anchors.fill: parent
        count: 12
    }
    //
    // frame
    //
    Image {
        anchors.fill: parent
        source: "icons/rectangular-frame.svg"
        fillMode: Image.PreserveAspectFit
    }
    //
    // prompts
    //
    Rectangle {
        height: ( topPromptText.contentHeight + 64 ) * 2
        anchors.left: parent.left
        anchors.leftMargin: 138
        anchors.right: parent.right
        anchors.rightMargin: 138
        anchors.verticalCenter: parent.verticalCenter
        color: colourTurquoise
        opacity: .8
        Text {
            id: topPromptText
            anchors.bottom: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 32
            font.family:ravensbourneBold.name
            font.pixelSize: 64
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            text: "Welcome to Ravensbourne Collaborative Sketch"
            color: "black"
        }
        Text {
            id: bottomPromptText
            anchors.top: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 32
            font.family:ravensbourneBold.name
            font.pixelSize: 64
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            rotation: 180
            text: "Welcome to Ravensbourne Collaborative Sketch"
            color: "black"
        }

    }

    FingerprintScannerPrompt {
        anchors.bottom: parent.top
        anchors.bottomMargin: -135
        rotation: 180
        prompt: "Scan your index finger to start"
    }
    FingerprintScannerPrompt {
        anchors.top: parent.bottom
        anchors.topMargin: -135
        prompt: "Scan your index finger to start"
    }
    //
    //
    //
    function start() {
        blobs.start();
        //info.start();
    }
    function stop() {
        blobs.stop();
        //info.stop();
    }
    //
    //
    //
    function setup( param ) {
        blobs.setup(param);
        start();
        //
        //
        //
        for ( var i = 0; i < materialScanners.length; i++ ) {
            materialScanners[ i ].barcode = "";
        }
    }
    function close() {
        stop();
    }
    MouseArea { // TODO: disable for production
        //
        //
        //
        property string userId: "{fb8592f5-7e49-49ba-b190-77e39381cfbd}"

        anchors.fill: parent
        onClicked: {
            //WebDatabase.getUser(userId);
        }
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
            WebDatabase.getUser(id);
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
    // WebDatabase
    //
    function webDatabaseSuccess( command, result ) {
        if ( enrollFingerprint.visible ) {
            enrollFingerprint.webDatabaseSuccess( command, result );
        }
        if ( command.indexOf('/user/') === 0 ) {
            var user = {
                id: result.fingerprint,
                username: result.username,
                email: result.email
            };
            console.log( 'Validated user : ' + JSON.stringify(user) );
            var param = {
                user: user
            };
            appWindow.go("Home", param);
        }
    }
    function webDatabaseError( command, error ) {
        /*
        if ( enrollFingerprint.visible ) {
            enrollFingerprint.webDatabaseError( command, error );
        }
        */
    }
}
