import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "Utils.js" as Utils
import SodaControls 1.0
import QtQuick.VirtualKeyboard 2.0

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
    // Styles
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
        Attractor {
            id: attractor
            anchors.fill: parent
            visible: false
        }
        //
        //
        //
        Home {
            id: home
            visible: false
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: inputPanel ? inputPanel.top : parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: inputPanel  ? 32 : 0
        }
        //
        //
        //
        Sketch {
            id: sketch
            visible: false
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: inputPanel ? inputPanel.top : parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: inputPanel  ? 32 : 0
        }
        //
        // universal material browser
        //
        MaterialBrowser {
            id: materialBrowser
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.bottom
            anchors.bottom: parent.bottom
            anchors.margins: 16
            onAddMaterial: {
                if ( currentScene.addMaterial ) {
                    currentScene.addMaterial( material );
                }
            }
        }
        //
        // universal material metadata viewer
        //
        MaterialMetadataViewer {
            id: metadataViewer
            //z: 1
            anchors.top: parent.bottom
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.bottom: inputPanel ? inputPanel.top : parent.bottom
            anchors.bottomMargin: inputPanel  ? 48 : 16
            anchors.right: parent.right
            anchors.rightMargin: 16
        }
        //
        // universal material icons
        //
        MaterialIcon {
            id: scanner0
            anchors.left: parent.left
            //anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -( 28 + height / 2 )
            //color: currentScene === sketch ? colourGreen : "transparent"
            visible: callibrationMode || ( currentScene !== attractor && barcode.length > 0 )
            onShowMaterial: {
                showMaterialBrowser(barcode,0)
            }
        }
        MaterialIcon {
            id: scanner1
            anchors.left: parent.left
            //anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: ( 28 + height / 2 )
            //color: currentScene === sketch ? colourGreen : "transparent"
            visible: callibrationMode || ( currentScene !== attractor && barcode.length > 0 )
            onShowMaterial: {
                showMaterialBrowser(barcode,1)
            }
        }
        MaterialIcon {
            id: scanner2
            anchors.right: parent.right
            //anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -( 28 + height / 2 )
            //color: currentScene === sketch ? colourGreen : "transparent"
            alignment: "right"
            visible: callibrationMode || ( currentScene !== attractor && barcode.length > 0 )
            onShowMaterial: {
                showMaterialBrowser(barcode,2)
            }
        }
        MaterialIcon {
            id: scanner3
            anchors.right: parent.right
            //anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: ( 28 + height / 2 )
            //color: currentScene === sketch ? colourGreen : "transparent"
            alignment: "right"
            visible: callibrationMode || ( currentScene !== attractor && barcode.length > 0 )
            onShowMaterial: {
                showMaterialBrowser(barcode,3)
            }
        }
        //
        //
        //
        EnrollFingerprint {
            id: enrollFingerprint
            z: 2
        }
        //
        // universal confirm dialog
        //
        ConfirmDialog {
            id: confirmDialog
            backgroundColour: colourRed //currentScene === sketch ? colourGreen : "white"
        }
        //
        // universal help
        //
        StandardButton {
            z: 2
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 22
            icon: "icons/help-black.png"
            color: colourTurquoise
            onClicked: {
                helpViewer.show(currentScene.help);
            }
        }
        HelpViewer {
            id: helpViewer
            z: 3
            anchors.top: parent.bottom
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.bottom: inputPanel ? inputPanel.top : parent.bottom
            anchors.bottomMargin: inputPanel  ? 48 : 16
            anchors.right: parent.right
            anchors.rightMargin: 16
        }
        //
        // universal rotate
        //
        StandardButton {
            z: 3
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 22
            icon: "icons/rotate-black.png"
            color: colourTurquoise
            onClicked: {
                container.rotation = container.rotation === 0. ? 180. : 0.;
            }
        }
        //
        // Keyboard
        //
        InputPanel {
            id: inputPanel
            y: active ? parent.height - height : parent.height + 32;
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 3
            anchors.right: parent.right
            anchors.rightMargin: parent.width / 3
            z: 4
            opacity: active ? 1. : 0.
            //
            //
            //
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
            Behavior on opacity {
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
        // setup barcode scanners
        //
        setupBarcodeScanners();
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
        enrollFingerprint.cancel();
        materialBrowser.hide();
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
    /* TODO: re-enable for release
    //
    // fingerprint signal handling
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
    */
    //
    // Barcode signal handling
    //
    property var materialScanners: [scanner0, scanner1, scanner2, scanner3]
    function setupBarcodeScanners() {
        for ( var i = 0; i < materialScanners.length; i++ ) {
            var scannerName = 'scanner' + i;
            var device = Settings.get('barcode/' + scannerName, 'COM0');
            console.log( scannerName + ':device:' + device);
            materialScanners[i].device = device;
        }
    }
    function showMaterialBrowser(barcode,scanner) {
        selectBarcodeScanner(scanner);
        materialBrowser.show(barcode);
    }
    function selectBarcodeScanner( scanner ) {
        for ( var i = 0; i < materialScanners.length; i++ ) {
            materialScanners[ i ].selected = i === scanner;
        }
    }

    Connections {
        target: BarcodeScanner
        onNewCode: {
            Timeout.registerEvent();
            console.log( 'barcode:' + barcode + ' device:' + portname );
            if ( callibrationMode ) {
                var scannerName = 'scanner' + callibrationScanner;
                Settings.set('barcode/' + scannerName, portname);
                materialScanners[callibrationScanner].device = portname;
                callibrationScanner++;
                if ( callibrationScanner >= materialScanners.length ) callibrationScanner = 0;
                selectBarcodeScanner(callibrationScanner);
            } else {
                for ( var scanner = 0; scanner < materialScanners.length; scanner++ ) {
                    if ( materialScanners[scanner].device === portname ) {
                        materialScanners[scanner].barcode = barcode;
                        break;
                    }
                }
            }
        }
    }
    property bool callibrationMode: false
    property int callibrationScanner: 0
    Shortcut {
        sequence: "Ctrl+C"
        onActivated: {
            callibrationMode = !callibrationMode;
            callibrationScanner = 0;
            selectBarcodeScanner(callibrationMode?callibrationScanner:-1);
        }
    }
    Shortcut {
        sequence: "Ctrl+B"
        onActivated: {
            var codes = [
                        "library.materialconnexion.com/ProductPage.aspx?mc=754501",
                        "library.materialconnexion.com/ProductPage.aspx?mc=697702",
                        "library.materialconnexion.com/ProductPage.aspx?mc=754502",
                        "library.materialconnexion.com/ProductPage.aspx?mc=256712"
                    ];
            var scanner = Math.floor(Math.random() * 100.) % 4;
            var code = Math.floor(Math.random() * ( codes.length - 1 ));
            materialScanners[ scanner ].barcode = codes[ code ];
            console.log( 'setting scanner:' + scanner + ' to:' + codes[ code ] );
        }
    }
    Shortcut {
        sequence: "Ctrl+F"
        onActivated: {
            var fingerprints = [
                        "{fb8592f5-7e49-49ba-b190-77e39381cfbd}",
                        "{558d676c-6849-4a30-8ab3-156f01a82c7b}",
                        "{4e03829b-c8d2-4928-8ac9-0edc61f1364e}",
                        "{3128772e-51c5-4955-8a87-0e71114a90e3}",
                        "{e3e635cc-100a-4465-83df-b99c7314b8bc}",
                        "{d71341c3-9849-4546-93a1-7bfa6eb094da}",
                        "{78b28cad-bd7a-4c08-bb6b-b7cea6d7be89}",
                        "{f26081e3-0df2-4d91-91e0-c4c232eac2e9}",
                        "{49a1c250-ed0b-4260-b691-faffac4eb3c3}",
                        "{c84560ea-4704-477c-aaa8-0f9c9b164636}",
                        "{ef5851ce-de64-4659-9251-faf138bf8756}",
                        "{a579ee68-420b-44a2-812f-69387539ecde}",
                        "{509c6b8d-319e-46a2-a398-a0680dfadf44}",
                        "{101adb71-eb00-4a04-a17d-7e7d51121dd9}",
                        "{0d99989b-1175-417d-9344-1371ae635017}",
                        "{1dee3ff9-bcb2-4cd0-8777-2f1c2a647562}"
                    ];
            var fingerprint = Math.floor(Math.random() * ( fingerprints.length - 1 ));
            if ( currentScene.fingerPrintValidated) {
                currentScene.fingerPrintValidated("simulation",fingerprints[fingerprint]);
            }
        }
    }
    Shortcut {
        sequence: "Ctrl+S"
        onActivated: {
            go('Sketch',{ user: { id: 'test' } });
        }
    }
    //
    //
    //
    Connections {
        target: Timeout
        onTimeout: {
            /* TODO: re-enable for release
            if ( currentScene !== attractor ) {
                timeoutDialog.show( function() {
                    go( 'Attractor' );
                });
            }
            */
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
