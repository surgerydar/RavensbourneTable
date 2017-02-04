import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

RotatableDialog {
    z: 2
    width: parent.width / 4
    height: parent.width / 4
    anchors.centerIn: parent;
    visible: false

    Text {
        id: prompt;
        height: parent.height / 6
        width: parent.width - 16
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: ( parent.height / 12  ) + 16
        anchors.horizontalCenter: parent.horizontalCenter
        text: "place your index finger on the scanner"
        font.pixelSize: 24
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        wrapMode: Text.WordWrap
    }

    Item {
        id: enrollmentGroup
        anchors.fill: parent

        RowLayout {
            id: printIndicators
            height: parent.height / 6
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            //
            //
            //
            Rectangle {
                width: parent.height
                height: parent.height
                radius: width / 2
                color: "white"
                Image {
                    anchors.fill: parent
                    anchors.margins: 8
                    visible: false
                    source:"icons/fingerprint-black.png"
                }
            }
            Rectangle {
                width: parent.height
                height: parent.height
                radius: width / 2
                color: "white"
                Image {
                    anchors.fill: parent
                    anchors.margins: 8
                    visible: false
                    source:"icons/fingerprint-black.png"
                }
            }
            Rectangle {
                width: parent.height
                height: parent.height
                radius: width / 2
                color: "white"
                Image {
                    anchors.fill: parent
                    anchors.margins: 8
                    visible: false
                    source:"icons/fingerprint-black.png"
                }
            }
            Rectangle {
                width: parent.height
                height: parent.height
                radius: width / 2
                color: "white"
                Image {
                    anchors.fill: parent
                    anchors.margins: 8
                    visible: false
                    source:"icons/fingerprint-black.png"
                }
            }
        }

    }
    Item {
        id: registrationGroup
        anchors.fill: parent
        visible : false

        TextField {
            id: username
            width: parent.width - parent.width / 6
            height: textFieldHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: 4
            placeholderText: "username"
            background: Rectangle {
                radius: height / 2
                color: "white"
                border.color: "transparent"
            }
            font.pixelSize: textFieldFontsize
            /*
            onFocusChanged: {
                if( username.focus ) {
                    if ( parent.parent.parent.rotation > 0 ) {
                        inputPanel.y        = inputPanel.parent.y;
                        inputPanel.rotation = 180;
                    } else {
                        inputPanel.y        = inputPanel.parent.height - inputPanel.height;
                        inputPanel.rotation = 0;
                    }
                } else if ( !email.focus ){
                    inputPanel.y = inputPanel.parent.height;
                    inputPanel.rotation = 0;
                }
            }
            */
        }
        TextField {
            id: email
            width: parent.width - parent.width / 6
            height:textFieldHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: 4
            placeholderText: "email"
            inputMethodHints: Qt.ImhEmailCharactersOnly
            background: Rectangle {
                radius: height / 2
                color: "white"
                border.color: "transparent"
            }
            font.pixelSize: textFieldFontsize
            /*
            onFocusChanged: {
                if( email.focus ) {
                    if ( parent.parent.parent.rotation > 0 ) {
                        inputPanel.y        = inputPanel.parent.y;
                        inputPanel.rotation = 180;
                    } else {
                        inputPanel.y        = inputPanel.parent.height - inputPanel.height;
                        inputPanel.rotation = 0;
                    }
                } else if ( !username.focus ){
                    inputPanel.y = inputPanel.parent.height;
                    inputPanel.rotation = 0;
                }
            }
            */
        }
    }

    Button {
        id: action
        anchors.top: parent.verticalCenter
        anchors.topMargin: ( parent.height / 12 ) + 16
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Cancel"
        onClicked: {
            if( enrolled ) {
                //
                //
                //
                if ( userId.length > 0 && username.text.length > 0 && email.text.length > 0 ) {
                    //
                    // go to user home
                    //
                    var user = {
                        id: userId,
                        username: username.text,
                        email: email.text
                    }
                    console.log( 'registering user : ' + JSON.stringify(user) );
                    if ( Database.putUser( user ) ) {
                        parent.visible = false;
                        var param = {
                            user : user
                        };
                        appWindow.go('Home',param);
                    } else {
                        prompt.text = "username or email already registered";
                    }
                } else {
                     prompt.text = "you must fill in both fields";
                }
            } else {
                //
                // cancel enrollment
                //
                FingerprintScanner.cancelEnrollment();
                //
                // return to attractor
                //
                parent.visible = false
            }
        }
    }

    //
    // reset interface
    //
    property bool enrolled: false
    property bool registered: false
    property string userId: ''
    onVisibleChanged: {
        //
        // TODO : consider moving this to setup
        //
    }
    onRotationChanged: {
        if( registrationGroup.visible && ( user.focus || email.focus ) ) {
            if ( rotation > 0 ) {
                inputPanel.y        = inputPanel.parent.y;
                inputPanel.rotation = 180;
            } else {
                inputPanel.y        = inputPanel.parent.height - inputPanel.height;
                inputPanel.rotation = 0;
            }
        } else {
            inputPanel.y = inputPanel.parent.height;
            inputPanel.rotation = 0;
        }

    }

    Connections {
        target: FingerprintScanner

        onEnrollmentStage: {
            console.log( 'enrollment stage : ' + stage );
            switch( stage ) {
            case 0 :
                prompt.text = 'place your middle finger on the scanner';
                break;
            default :
                prompt.text = 'and again...';
                printIndicators.children[ stage - 1 ].children[0].visible = true;
                break;
            }
            if ( stage >= 4 ) {
                prompt.text = 'one more time';
            }
        }

        onEnrolled: {
            //
            //
            //
            userId = id;
            enrolled = true;
            //
            // show registration
            //
            enrollmentGroup.visible = false;
            registrationGroup.visible = true;
            prompt.text = "we need some more information to complete your registration";
            action.text = "Register";
        }

        onEnrollmentFailed: {
            console.log( 'enrollment failed' );
            prompt.text = 'I have had trouble scanning your fingerprint, please try again';
            var count = printIndicators.children.length;
            for ( var i = 0; i < count; i++ ) {
                printIndicators.children[ i ].children[0].visible = false;
            }
            FingerprintScanner.enroll(device);
        }

    }
    //
    //
    //
    //
    // fingerprint handling
    //
    function fingerPrintEnrollmentStage(device,stage) {
        console.log( 'enrollment stage : ' + stage );
        switch( stage ) {
        case 0 :
            prompt.text = 'place your middle finger on the scanner';
            break;
        default :
            prompt.text = 'and again...';
            printIndicators.children[ stage - 1 ].children[0].visible = true;
            break;
        }
        if ( stage >= 4 ) {
            prompt.text = 'one more time';
        }
    }
    function fingerPrintEnrolled(device,id) {
        //
        //
        //
        userId = id;
        enrolled = true;
        //
        // show registration
        //
        enrollmentGroup.visible = false;
        registrationGroup.visible = true;
        prompt.text = "we need some more information to complete your registration";
        action.text = "Register";
    }
    function fingerPrintEnrollmentFailed(device) {
        console.log( 'enrollment failed' );
        prompt.text = 'I have had trouble scanning your fingerprint, please try again';
        var count = printIndicators.children.length;
        for ( var i = 0; i < count; i++ ) {
            printIndicators.children[ i ].children[0].visible = false;
        }
        FingerprintScanner.enroll();
    }
    function setup( param ) {
        username.text = '';
        email.text = '';
        enrollmentGroup.visible = true;
        registrationGroup.visible = false;
        enrolled = false;
        registered = false;
        userId = '';
        parent.rotation = 0
        var count = printIndicators.children.length;
        for ( var i = 0; i < count; i++ ) {
            printIndicators.children[ i ].children[0].visible = false;
        }
        if ( param && param.device ) {
            FingerprintScanner.enroll(param.device);
        }
    }
    function cancel() {
        if ( visible ) {
            visible = false;
            FingerprintScanner.cancelEnrollment();
        }
    }
}
