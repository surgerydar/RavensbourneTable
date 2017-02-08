import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.VirtualKeyboard 2.0

ApplicationWindow {
    id: appWindow
    //
    //
    //
    property ApplicationWindow appWindow : appWindow
    property InputPanel inputPanel : inputPanel
    property EnrollFingerprint enrollFingerprint : enrollFingerprint
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

        Attractor {
            id: attractor
            anchors.fill: parent
            visible: false
        }

        Home {
            id: home
            anchors.fill: parent
            visible: false
        }

        Sketch {
            id: sketch
            anchors.fill: parent
            visible: false
        }

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

    /*
    GoogleImageBrowser {
        id: imageBrowser
    }
    */
    EnrollFingerprint {
        id: enrollFingerprint
        z: 2
    }

    InputPanel {
        id: inputPanel
        y: parent.height;//Qt.inputMethod.visible ? parent.height - inputPanel.height : parent.height
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 3
        anchors.right: parent.right
        anchors.rightMargin: parent.width / 3
        rotation: 0
        z: 4
        //
        //
        //
        function show( itemBounds, itemOrientation ) {
            //
            // TODO: shift keyboard to avoid itemBounds
            //
            if ( itemOrientation > 0 ) {
                y           = parent.y;
                rotation    = 180;
            } else {
                y           = parent.height - height;
                rotation    = 0;
            }

        }
        function hide() {
            //
            // TODO: check nothing else has focus
            //
            y = parent.height;
            rotation = 0;
        }
    }

    TimeoutDialog {
        id: timeoutDialog
    }
    /*
    //
    // TODO: loose this in production
    //
    footer: TabBar {
        id: tabbar
        //currentIndex: swipeView.currentIndex
        currentIndex: 0
        TabButton {
            text: qsTr("Attractor")
        }
        TabButton {
            text: qsTr("Home")
        }
        TabButton {
            text: qsTr("Sketch")
        }
        onCurrentIndexChanged: {
            appWindow.go(scenes[tabbar.currentIndex].name,null,true);
        }
    }
    */
    Component.onCompleted: {
        appWindow.showFullScreen();
        Timeout.registerEvent();
        go('Attractor');
    }

    Component.onDestruction: {
        Database.saveDatabase();
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
        go('Attractor');
    }
    //
    // finger print signal handling
    //
    Connections {
        target: FingerprintScanner

        onEnrollmentStage: {
            Timeout.registerEvent();
            if ( currentScene.fingerPrintEnrollmentStage) {
                currentScene.fingerPrintEnrollmentStage(device,stage);
            }
        }

        onEnrolled: {
            Timeout.registerEvent();
            if ( currentScene.fingerPrintEnrollmentStage) {
                currentScene.fingerPrintEnrolled(device,id);
            }
         }

        onEnrollmentFailed: {
            Timeout.registerEvent();
            if ( currentScene.fingerPrinEnrollmentFailed) {
                currentScene.fingerPrintEnrollmentFailed(device);
            }
        }

        onValidated: {
            Timeout.registerEvent();
            if ( currentScene.fingerPrintValidated) {
                currentScene.fingerPrintValidated(device,id);
            }
        }

        onValidationFailed: {
            Timeout.registerEvent();
            if ( currentScene.fingerPrintValidationFailed) {
                currentScene.fingerPrintValidationFailed(device);
            }
        }
    }
    //
    // Barcode signal handling
    //
    Connections {
        target: BarcodeScanner
        onNewCode: {
            Timeout.registerEvent();
            if ( currentScene.barcodeNewCode) {
                currentScene.barcodeNewCode(portname,barcode);
            } else {

            }
        }
    }
    //
    //
    //
    Connections {
        target: Timeout
        onTimeout: {
            if ( currentScene !== attractor ) {
                timeoutDialog.show( function() {
                    enrollFingerprint.cancel();
                    materialBrowser.hide();
                    imageBrowser.hide();
                    inputPanel.hide();
                    go( 'Attractor' );
                });
            }
        }
    }
    //
    //
    //
    Connections {
        target: KeyboardFocusListener
        onFocusChanged: {
            //
            // TODO: prevent keyboard from overlapping focus item
            //
            if ( hasFocus ) {
                inputPanel.show(itemBounds,itemOrientation);
            } else {
                inputPanel.hide();
            }
        }
    }
    //
    //
    //
    Connections {
        target: WebDatabase
        //
        //
        //
        onSuccess: {
            console.log( 'WebDatabase : success : ' + command );
            if ( result ) {
                console.log( 'WebDatabase : result : ' + JSON.stringify( result ) );
            }
        }
        onError: {
            console.log( 'WebDatabase : error : ' + command + ':' + error );
        }

    }

}
