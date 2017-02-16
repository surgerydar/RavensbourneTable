import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: appWindow
    //
    //
    //
    property ApplicationWindow appWindow : appWindow
    property MaterialBrowser materialBrowser: materialBrowser
    property FontLoader ravensbourneRegular: ravensbourneRegular
    property FontLoader ravensbourneBold: ravensbourneBold
    property FontLoader ravensbourneExtraBold: ravensbourneExtraBold
    //
    //
    //
    visible: true
    width: 1024
    height: 768
    //
    // Fonts
    //
    FontLoader {
        id: ravensbourneRegular
        source: "fonts/RavensbourneSans-Regular.otf"
    }
    FontLoader {
        id: ravensbourneBold
        source: "fonts/RavensbourneSans-Bold.otf"
    }
    FontLoader {
        id: ravensbourneExtraBold
        source: "fonts/RavensbourneSans-ExtraBold.otf"
    }
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
    //
    //
    property int  textFieldHeight: 48
    property int textFieldFontsize: 18
    //
    //
    //
    title: qsTr("Ravensbourne Table")

    Item {
        id: swipeView
        anchors.fill: parent

        Login {
            id: login
            anchors.fill: parent
            visible: false
        }

        Home {
            id: home
            anchors.fill: parent
            visible: false
        }

        SketchContainer {
            id: sketch
            anchors.fill: parent
            visible: false
        }
        /*
        Sketch {
            id: sketch
            anchors.fill: parent
            visible: false
        }
        */

    }

    MaterialBrowser {
        id: materialBrowser
        onAddMaterial: {
            console.log( 'onAddMaterial : ' + JSON.stringify(material) )
            if ( currentScene.addMaterial ) {
                currentScene.addMaterial(material);
            }
        }
    }

    ImageBrowser {
        id: imageBrowser
    }

    Component.onCompleted: {
        appWindow.showFullScreen();
        go('Login');
    }

    Component.onDestruction: {
    }
    //
    //
    //
    property var currentScene : login
    property var scenes : [
        {
            id: login,
            name: "Login"
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
        // NOTE: perhaps load from disk?
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
    function logout() {
        go('Login');
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
