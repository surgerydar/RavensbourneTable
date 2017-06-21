import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "Utils.js" as Utils
import SodaControls 1.0

ApplicationWindow {
    id: appWindow
    visible: true
    width: 1920
    height: 1080
    //
    //
    //
    title: qsTr("Ravensbourne Table")
    //
    // Colours
    //
    property string colourBlue: "#4FC3F7"
    property string colourTurquoise: "#00D2C2"
    property string colourGreen: "#6EDD17"
    property string colourYellow: "#FFB300"
    property string colourRed: "#FF6666"
    property string colourPink: "#FF80AB"
    property string colourGrey: "#EEEDEB"
    //
    // Fonts
    //
    property FontLoader ravensbourneRegular: FontLoader {
        source: "fonts/RavensbourneSans-Regular.otf"
    }
    property FontLoader ravensbourneBold: FontLoader {
        source: "fonts/RavensbourneSans-Bold.otf"
    }
    property FontLoader ravensbourneExtraBold: FontLoader {
        source: "fonts/RavensbourneSans-ExtraBold.otf"
    }
    //
    //
    //
    property int  textFieldHeight: 48
    property int textFieldFontsize: 18
    //
    //
    //
    Item {
        id: container
        anchors.fill: parent
        //
        // main scenes
        //
        MobileAttractor {
            id: attractor
            anchors.fill: parent
            visible: false
        }
        //
        //
        //
        MobileHome {
            id: home
            visible: false
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 0
        }
        //
        //
        //
        Sketch {
            id: sketch
            visible: false
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 0
        }
        //
        //
        //
        MaterialMetadataViewer {
            id: metadataViewer
            z: 1
            anchors.top: parent.bottom
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
        }
        //
        // universal confirm dialog
        //
        ConfirmDialog {
            id: confirmDialog
            backgroundColour: currentScene === sketch ? colourGreen : "white"
        }
        //
        //
        //
        StandardButton {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 16
            icon: "icons/help-black.png"
            onClicked: {
                ImagePicker.show();
            }
        }

        //
        //
        //
        //
        // universal help
        //
        /*
        Rectangle {
            width: 58
            height: 58
            z: 2
            radius: height / 2.
            color: currentScene === sketch ? colourGreen : "transparent"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 16
            StandardButton {
                anchors.centerIn: parent
                icon: "icons/help-black.png"
                onClicked: {
                    helpViewer.show(currentScene.help);
                }
            }
        }
        */
        /*
        HelpViewer {
            id: helpViewer
            z: 3
            anchors.top: parent.bottom
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
        }
        */
        //
        //
        //
        Behavior on rotation {
            NumberAnimation {
                duration: 500
            }
        }
    }
    //
    //
    //
    Component.onCompleted: {
        //
        // setup WebDatabase
        //
        var baseURL = Settings.get('webdatabase/url','http://178.62.110.55:3000');
        WebDatabase.setBaseURL(baseURL);
        //
        //
        //
        go('Attractor');
    }
    //
    //
    //
    property var currentScene : attractor
    property var scenes : [
        {
            id: attractor,
            name: "Attractor"
        },
        {
            id: home,
            name: "Home"
        },
        {
            id: sketch,
            name: "Sketch"
        }
    ];
    function sceneId( sceneName ) {
        for ( var i = 0; i < scenes.length; i++ ) {
            if ( scenes[ i ].name === sceneName ) return scenes[ i ].id;
        }
        return null;
    }

    function go( sceneName, param ) {
        console.log( 'going to scene : ' + sceneName );
        //
        // hide browsers
        //
        metadataViewer.hide();
        //
        //
        //
        var id = sceneId(sceneName);
        if ( id ) {
            var scene = null;
            for ( var i = 0; i < scenes.length; i++ ) {
                scenes[i].id.visible = scenes[i].id === id;
                if ( scenes[i].id.visible ) {
                    scene = scenes[i].id;
                }
            }
            if ( scene !== currentScene && currentScene.close ) {
                //
                // clean up current scene
                //
                currentScene.close();
            }

            if ( scene && scene.setup ) {
                //
                // setup new scene
                //
                scene.setup(param);
            }
            currentScene = scene;
        } else {
            console.log( 'Invalid scene : ' + sceneName );
        }
    }
    //
    //
    //
    Connections {
        //
        //
        //
        target: WebDatabase
        //
        //
        //
        onSuccess: {
            console.log( 'WebDatabase : success : ' + command );
            if ( result ) {
                //console.log( 'WebDatabase : result : ' + JSON.stringify( result ) );
            }
            if (currentScene.webDatabaseSuccess) currentScene.webDatabaseSuccess( command, result );
        }
        onError: {
            console.log( 'WebDatabase : error : ' + command + ':' + error );
            if (currentScene.webDatabaseError) currentScene.webDatabaseError( command, error );
        }

    }
    //
    //
    //
    Connections {
        target: SessionClient
        //
        //
        //
        onClosed : {
            //
            // reconnect
            //
            console.log( 'session disconnected' );
            SessionClient.open();
        }
    }
}
