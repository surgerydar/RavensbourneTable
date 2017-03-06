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
    //property InputPanel inputPanel : inputPanelTop
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
    //
    // mail scenes
    //
    /*
    Item {
        id: swipeView
        anchors.fill: parent
    */
    Attractor {
        id: attractor
        anchors.fill: parent
        visible: false
    }

    Home {
        id: home
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: inputPanelTop.bottom
        anchors.bottom: inputPanelBottom.top
        visible: false
    }

    SketchContainer {
        id: sketch
        anchors.fill: parent
        visible: false
    }
    /*
    }
    */
    //
    //
    //
    MaterialBrowser {
        id: materialBrowser
        onAddMaterial: {
            console.log( 'onAddMaterial : ' + JSON.stringify(material) )
            if ( currentScene.addMaterial ) {
                currentScene.addMaterial(material);
            }
        }
    }

    FlickrImageBrowser {
        id: imageBrowser
    }

    MaterialMetadataViewer {
        id: metadataViewer
    }

    EnrollFingerprint {
        id: enrollFingerprint
        z: 2
    }
    //
    // input panels
    //
    InputPanel {
        id: inputPanelBottom
        y: parent.height;
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
            y = parent.height - height;
        }
        function hide() {
            y = parent.height;
        }
        Behavior on x {
            NumberAnimation {
                duration: 250
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: 250
            }
        }
    }

    InputPanel {
        id: inputPanelTop
        y: parent.y - height;
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 3
        anchors.right: parent.right
        anchors.rightMargin: parent.width / 3
        rotation: 180
        z: 4
        //
        //
        //
        function show( itemBounds, itemOrientation ) {
            y = parent.y;
        }
        function hide() {
            y = parent.y - height;
        }
        Behavior on x {
            NumberAnimation {
                duration: 250
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: 250
            }
        }
    }
    //
    //
    //
    TimeoutDialog {
        id: timeoutDialog
    }
    //
    //
    //
    Component.onCompleted: {
        appWindow.showFullScreen();
        WindowControl.setAlwaysOnTop(true);
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
        // hide browsers
        //
        materialBrowser.hide();
        imageBrowser.hide();
        metadataViewer.hide();
        //
        // JONS: perhaps load from disk?
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
                    inputPanelTop.hide();
                    inputPanelBottom.hide();
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
                inputPanelTop.show(itemBounds,itemOrientation);
                inputPanelBottom.show(itemBounds,itemOrientation);
            } else {
                inputPanelTop.hide();
                inputPanelBottom.hide();
            }
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
            if (currentScene.webDatabaseError) currentScene.webDatabaseSuccess( command, error );
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
