import QtQuick 2.7
import QtQuick.Controls 2.1

Item {
    id: container
    //
    //
    //
    property var user: null
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
        count: 4
    }
    //
    // frame
    //
    /*
    Image {
        anchors.fill: parent
        source: "icons/rectangular-frame.svg"
        fillMode: Image.PreserveAspectFit
    }
    */
    //
    // prompts
    //
    Rectangle {
        height: Math.min(parent.height,parent.width) * .75
        width: height
        anchors.centerIn: parent
        radius: height / 2
        color: colourTurquoise
        opacity: .8
        //
        //
        //
        Item {
            id: authentication
            height: 48 * 2 + 8
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            TextField {
                id: email
                height: 48
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                background: Rectangle {
                    radius: height / 2
                    color: "white"
                    border.color: "transparent"
                }
                placeholderText: "email"
                onAccepted: {
                    WebDatabase.getUser(email.text,"byemail");
                }
            }
            TextField {
                id: code
                height: 48
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                background: Rectangle {
                    radius: height / 2
                    color: "white"
                    border.color: "transparent"
                }
                placeholderText: "code ( from welcome email )"
                onAccepted: {
                    WebDatabase.getUser(code.text,"byid");
                }
            }
        }
    }
    //
    //
    //
    function start() {
        blobs.start();
    }
    function stop() {
        blobs.stop();
    }
    //
    //
    //
    function setup( param ) {
        email.text = "";
        email.focus = true;
        code.text = "";
        code.enabled = false;
        blobs.setup(param);
        start();
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
            WebDatabase.getUser(userId);
        }
    }
    //
    // WebDatabase
    //
    function webDatabaseSuccess( command, result ) {
        if ( command.indexOf('/user/byemail/') === 0 ) {
            user = result;
            code.enabled = true;
            code.focus = true;
        } else if ( command.indexOf('/user/byid/') ) {
            if ( user ) {
                if ( result.fingerprint === user.fingerprint ) {
                    var param = {
                        user: {
                            id: result.fingerprint,
                            username: result.username,
                            email: result.email
                        }
                    };
                    appWindow.go("Home", param);
                }
            }
        }
    }
    function webDatabaseError( command, error ) {
    }
}
