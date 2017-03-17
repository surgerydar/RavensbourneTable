import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.VirtualKeyboard 2.0

ApplicationWindow {
    id: appWindow
    //
    //
    //
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
    //
    //
    Rectangle {
        anchors.fill: parent
        color: colourYellow
    }
    //
    // attractor
    //
    Item {
        id: attractor
        anchors.fill: parent
        visible: true
        //
        // blob animation
        //
        Item {
            id: blobs
            anchors.fill: parent
            Blob {

            }
            Blob {

            }
            Blob {

            }
            Blob {

            }
            Blob {

            }
            Blob {

            }
            Blob {

            }
            Blob {

            }
            Blob {

            }
            Blob {

            }
            Blob {

            }
            Blob {

            }
        }
        Image {
            anchors.fill: parent
            anchors.margins: 0
            source: "icons/rectangular-frame.svg"
        }
        //
        // prompts
        //
        Rectangle {
            height: 120//parent.height / 6
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            color:"transparent"
            opacity: .75
            rotation: 180
            Text {
                anchors.fill: parent
                anchors.margins: 8
                font.family:ravensbourneBold.name
                font.pixelSize: parent.height / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "place a material under a scanner to begin"
            }
        }
        Rectangle {
            height: 120//parent.height / 6
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16
            color:"transparent"
            opacity: .75
            Text {
                anchors.fill: parent
                anchors.margins: 8
                font.family:ravensbourneBold.name
                font.pixelSize: parent.height / 2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: "place a material under a scanner to begin"
            }
        }
        //
        //
        //
        Timer {
            id: blobAnimation
            interval: 16
            repeat: true
            running: false
            property real previousTime: 0
            property real frameTime: 25.0
            onTriggered: {
                var currentTime = new Date().getTime()
                var elapsed = previousTime > 0 ? currentTime - previousTime : frameTime;
                previousTime = currentTime;
                var factor = elapsed / frameTime;
                var count = blobs.children.length;
                var energy = 0;
                for ( var i = 0; i < count; i++ ) {
                    if ( blobs.children[i].type && blobs.children[i].type === 'blob' ) {
                        //
                        // apply forces
                        //
                        for ( var j = 0; j < count; j++ ) {
                            if ( i !== j && blobs.children[j].type && blobs.children[j].type === 'blob' ) {
                                blobs.children[i].applyForces( blobs.children[j], factor );
                            }
                        }
                        //
                        // update
                        //
                        energy += blobs.children[i].update(factor);
                    }
                }
                if ( energy < count * 0.5 ) {
                    for ( i = 0; i < count; i++ ) {
                        if ( blobs.children[i].type && blobs.children[i].type === 'blob' ) {
                            blobs.children[i].nudge();
                        }
                    }

                }
            }
        }
        //
        //
        //
        function start() {
            blobAnimation.start();
        }
        function stop() {
            blobAnimation.stop();
        }
        //
        //
        //
        function setup() {
            var count = blobs.children.length;
            for ( var i = 0; i < count; i++ ) {
                if ( blobs.children[i].type && blobs.children[i].type === 'blob' ) {
                    blobs.children[i].setup();
                }
            }
            start();
        }
    }
    //
    //
    //
    DemoMaterialBrowser {
        id: materialBrowser
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        x: -width
    }
    //
    // input panels
    //
    InputPanel {
        id: inputPanelBottom
        y: active ? parent.height - height : parent.height;
        anchors.left: parent.left
        anchors.leftMargin: parent.width * .75//parent.width / 3
        anchors.right: parent.right
        anchors.rightMargin: 0//parent.width / 3
        rotation: 0
        z: 4
        //
        //
        //
        //
        //
        //
        /*
        function show( itemBounds, itemOrientation ) {
            y = parent.height - height;
        }
        function hide() {
            y = parent.height;
        }
        */
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
        //y: parent.y - height
        y: active ? parent.y : parent.y - height
        anchors.left: parent.left
        anchors.leftMargin: 0//parent.width / 3
        anchors.right: parent.right
        anchors.rightMargin: parent.width * .75//parent.width / 3
        rotation: 180
        z: 4
        //
        //
        //
        /*
        function show( itemBounds, itemOrientation ) {
            y = parent.y;
        }
        function hide() {
            y = parent.y - height;
        }
        */
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
        materialBrowser.hide();
        attractor.setup();
    }
    //
    // Barcode signal handling
    //
    Connections {
        target: BarcodeScanner
        onNewCode: {
            Timeout.registerEvent();
            materialBrowser.show(barcode);
        }
    }
    //
    //
    //
    Connections {
        target: Timeout
        onTimeout: {
            if ( materialBrowser.x >= 0 ) {
                timeoutDialog.show( function() {
                    materialBrowser.hide();
                    //inputPanelTop.hide();
                    //inputPanelBottom.hide();
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
            /*
            if ( hasFocus ) {
                inputPanelTop.show(itemBounds,itemOrientation);
                inputPanelBottom.show(itemBounds,itemOrientation);
            } else {
                inputPanelTop.hide();
                inputPanelBottom.hide();
            }
            */
        }
    }
}
