import QtQuick 2.0
import QtQuick.Controls 2.0
import "Utils.js" as Utils

Item {

    Rectangle {
        anchors.fill: parent
        color: "orange"
    }

    Item {
        id: sketches
        anchors.fill: parent
    }

    RotatableDialog {
        id: dialog
        width: parent.width / 4
        height: parent.width / 4
        anchors.centerIn: parent;
        //
        //
        //
        Text {
            id: prompt;
            width: Math.sqrt( (parent.width*parent.width) / 2. )
            height: Math.sqrt( (parent.width*parent.width) / 2. ) - 48
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "place a material on the scanner to create a new sketch\nor\nselect one of your previous sketches"
            font.family: ravensbourneBold.name
            font.pixelSize: 32
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }
        Button {
            id: action
            anchors.top: prompt.bottom
            anchors.topMargin: 16
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Logout"
            onClicked: {
                appWindow.logout();
            }
        }
    }

    UserIcon {
        id: userIconTop
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        rotation: 180
    }
    UserIcon {
        id: userIconBottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 8
     }

    //
    //
    //
    property var user: null;
    property var userSketches: null;
    function setup(param) {
        user = null;
        userSketches = null;
        clearSketches();
        if ( param && param.user ) {
            //
            // store user
            //
            user = param.user;
            //
            // load user sketches
            //
            loadSketches(user.id);
            //
            // build prompt text
            //
            var welcomeText = "Hi\n" + param.user.username;
            var sketchText = userSketches.length > 0 ? '\nor\nselect one of your previous sketches' : ''
            var promptText = welcomeText + "\nPlace a material under a scanner to create a new sketch" + sketchText;
            prompt.text = promptText;
            //
            //
            //
            var userIconParams = {
                user_id: user.id,
                creator: true
            };
            userIconTop.setup(userIconParams);
            userIconBottom.setup(userIconParams);
        } else {
            console.log( "no user" );
        }
    }
    function clearSketches() {
        var count = sketches.children.length;
        for ( var i = 0; i < count; i++ ) {
            sketches.children[ i ].destroy();
        }
    }

    function loadSketches(userId) {
        //
        //
        //
        userSketches = Database.getUserSketches(userId);
        var count = userSketches.length;
        console.log( 'user sketches : ' + count );
        console.log('this : ' + this );
        for ( var i = 0; i < count; i++ ) {
            var param = {
                source: "SketchIcon.qml",
                container: sketches,
                sketch : userSketches[i],
                user : user,
                dim : 128,
                app: appWindow,
                home: this,
                callback : function( item, param ) {
                    item.icon.source = param.sketch.icon;
                    item.sketch = param.sketch;
                    item.user = param.user;
                    item.app = param.app;
                    item.home = param.home;
                    item.name.text = param.sketch.material.name || param.sketch.icon;
                }
            }
            Utils.loadQML(param);
        }
    }

    function deleteSketch(sketchId) {
        console.log( 'deleting sketch : ' + sketchId )
        //
        // remove sketch icon
        //
        var count = sketches.children.length;
        for ( var i = 0; i < count; i++ ) {
            if( sketches.children[ i ].sketch && sketches.children[ i ].sketch.id === sketchId ) {
                sketches.children[ i ].destroy();
                break;
            }
        }
        //
        // remove from users userSketches
        //
        count = userSketches.length;
        for ( i = 0; i < count; i++ ) {
            if( userSketches[ i ].id === sketchId ) {
                userSketches.splice( i, 1 );
                break;
            }
        }
        //
        // remove from database
        //
        Database.deleteSketch(sketchId);
    }

    function barcodeNewCode(port,barcode) {
        materialBrowser.show(barcode);
    }

    function addMaterial( material ) {
        console.log( 'Home.addMaterial : ' + JSON.stringify( material) );
        if ( material ) {
            var param = {
                new_sketch: true,
                material: material,
                user: user
            };
            appWindow.go("Sketch",param);
        }
    }

    Timer {
        id: iconAnimation
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
            var count = sketches.children.length;
            for ( var i = 0; i < count; i++ ) {
                if ( sketches.children[i].type && sketches.children[i].type === 'blob' ) {
                    //
                    // apply forces
                    //
                    sketches.children[i].applyForces( dialog, factor );
                    for ( var j = 0; j < count; j++ ) {
                        if ( i !== j && sketches.children[j].type && sketches.children[j].type === 'blob' ) {
                            sketches.children[i].applyForces( sketches.children[j], factor );
                        }
                    }
                    //
                    // update
                    //
                    sketches.children[i].update(factor);
                }
            }
        }
    }
    //
    //
    //
    function start() {
        iconAnimation.start();
    }
    function stop() {
        iconAnimation.stop();
    }
    onVisibleChanged: {
        if ( visible ) {
            start();
        } else {
            stop();
        }
    }
}