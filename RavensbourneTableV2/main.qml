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
    title: qsTr("Pinch Test")
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
        // universal material icons
        //
        Rectangle {
            width: 58
            height: 58
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: parent.height / 3
            radius: height / 2.
            color: currentScene === sketch && scanner0.visible ? colourGreen : "transparent"
            MaterialIcon {
                id: scanner0
                anchors.centerIn: parent
                visible: currentScene !== attractor && barcode.length > 0
                onClicked: {
                    materialBrowser.show(barcode)
                }
            }
        }
        Rectangle {
            width: 58
            height: 58
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.bottom
            anchors.verticalCenterOffset: -parent.height / 3
            radius: height / 2.
            color: currentScene === sketch && scanner1.visible ? colourGreen : "transparent"
            MaterialIcon {
                id: scanner1
                anchors.centerIn: parent
                visible: currentScene !== attractor && barcode.length > 0
                onClicked: {
                    materialBrowser.show(barcode)
                }
            }
        }
        Rectangle {
            width: 58
            height: 58
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: parent.height / 3
            radius: height / 2.
            color: currentScene === sketch && scanner2.visible ? colourGreen : "transparent"
            MaterialIcon {
                id: scanner2
                anchors.centerIn: parent
                visible: currentScene !== attractor && barcode.length > 0
                onClicked: {
                    materialBrowser.show(barcode)
                }
            }
        }
        Rectangle {
            width: 58
            height: 58
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: parent.height / 3
            radius: height / 2.
            color: currentScene === sketch && scanner3.visible ? colourGreen : "transparent"
            MaterialIcon {
                id: scanner3
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.bottom
                anchors.verticalCenterOffset: -parent.height / 3
                visible: currentScene !== attractor && barcode.length > 0
                onClicked: {
                    materialBrowser.show(barcode)
                }
            }
        }
        //
        //
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
        //
        //
        MaterialMetadataViewer {
            id: metadataViewer
            anchors.top: parent.bottom
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.bottom: inputPanel ? inputPanel.top : parent.bottom
            anchors.bottomMargin: inputPanel  ? 48 : 16
            anchors.right: parent.right
            anchors.rightMargin: 16
        }
        EnrollFingerprint {
            id: enrollFingerprint
            z: 2
        }
        //
        // universal help
        //
        Rectangle {
            width: 58
            height: 58
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
        HelpViewer {
            id: helpViewer
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
        Rectangle {
            width: 58
            height: 58
            radius: height / 2.
            color: currentScene === sketch ? colourGreen : "transparent"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 16
            StandardButton {
                anchors.centerIn: parent
                icon: "icons/rotate-black.png"
                onClicked: {
                    container.rotation = container.rotation === 0. ? 180. : 0.;
                }
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
    /*
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
    Connections {
        target: BarcodeScanner
        onNewCode: {
            Timeout.registerEvent();
            console.log( 'barcode:' + barcode + ' device:' + portname );
            for ( var scanner = 0; scanner < materialScanners.length; scanner++ ) {
                if ( materialScanners[scanner].device === portname ) {
                    materialScanners[scanner].barcode = barcode;
                    break;
                }
            }
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
              var scanner = Math.floor(Math.random() * ( materialScanners.length - 1 ));
              var code = Math.floor(Math.random() * ( codes.length - 1 ));
              materialScanners[ scanner ].barcode = codes[ code ];
              console.log( 'setting scanner:' + scanner + ' to:' + codes[ code ] );
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
