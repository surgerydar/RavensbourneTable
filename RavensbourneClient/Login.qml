import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Item {
    anchors.fill: parent
    Rectangle {
        anchors.fill: parent
        color: colourYellow
    }

    RotatableDialog {
        id: loginDialog
        width: parent.width > parent.height ? parent.width / 2 : parent.height / 2
        height: parent.width > parent.height ? parent.width / 2 : parent.height / 2
        anchors.centerIn: parent;
        //
        //
        //
        Text {
            id: prompt;
            width: Math.sqrt( (parent.width*parent.width) / 2. )
            height: ( Math.sqrt( (parent.width*parent.width) / 2. ) / 2 ) - 48
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 48
            text: "Login"
            font.family: ravensbourneBold.name
            font.pixelSize: 32
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }

        TextField {
            id: username
            width: parent.width - parent.width / 6
            height: textFieldHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 4
            placeholderText: "username"
            text: "jonsmiddleright"
            background: Rectangle {
                radius: height / 2
                color: "white"
                border.color: "transparent"
            }
            font.pixelSize: textFieldFontsize
            onAccepted: {
                if ( text.length > 0 ) {
                    WebDatabase.getUser( text, 'byname' )
                }
            }
        }
        TextField {
            id: email
            enabled: false
            width: parent.width - parent.width / 6
            height:textFieldHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: 4
            placeholderText: "email"
            text: "jonsmiddleright@gmail.com"
            inputMethodHints: Qt.ImhEmailCharactersOnly
            background: Rectangle {
                radius: height / 2
                color: "white"
                border.color: "transparent"
            }
            font.pixelSize: textFieldFontsize
            onAccepted: {
                if ( text.length > 0 && username.text.length > 0 ) {
                    WebDatabase.getUser( text, 'byemail' )
                }
            }
        }
        Button {
            id: action
            enabled: false
            anchors.top: email.bottom
            anchors.topMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Login"
            onClicked: {
                if ( email.text.length > 0 ) {
                    WebDatabase.getUser( email.text, 'byemail' );
                }
            }
        }
    }
    //
    //
    //
    function setup(param) {
        username.text = "jonsmiddleright";
        username.focus = true;
        email.text = "jonsmiddleright@gmail.com";
        email.enabled = false;
        action.enabled = false;
    }
    //
    //
    // WebDatabase
    //
    function webDatabaseSuccess( command, result ) {
        console.log( 'Login.WebDatabase : success : ' + command );
        if ( result ) {
            console.log( 'Login.WebDatabase : result : ' + JSON.stringify( result ) );
        }
        if ( command.indexOf('/user/byname/') >= 0 ) {
            email.enabled = true;
            email.focus = true;
            action.enabled = true;
        } else if ( command.indexOf('/user/byemail/') >= 0 ) {
            email.focus = false;
            username.focus = false;
            var param = {
                user: {
                    id : result.fingerprint,
                    username: result.username,
                    email: result.email
                }
            }
            go('Home',param);
        }
    }
    function webDatabaseError( command, error ) {
        console.log( 'Login.WebDatabase : error : ' + command + ':' + error );
    }}
