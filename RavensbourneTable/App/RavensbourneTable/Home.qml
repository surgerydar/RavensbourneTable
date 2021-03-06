import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

import "Utils.js" as Utils

Item {

    Rectangle {
        anchors.fill: parent
        color: colourYellow
    }

    Image {
        anchors.fill: parent
        anchors.margins: 0
        source: "icons/rectangular-frame.svg"
        fillMode: Image.PreserveAspectFit
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
            text: "Place a material on the scanner to create a new sketch\nor\nselect one of your previous sketches"
            font.family: ravensbourneBold.name
            font.pixelSize: 32
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
        }
        TextButton {
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
    //
    //
    //
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
    TextField {
        id: searchFieldTop
        width: parent.width / 4
        height: 48
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 8
        rotation: 180
        background: Rectangle {
            radius: height / 2
            color: "white"
            border.color: "transparent"
        }
        font.family: ravensbourneRegular.name
        font.pixelSize: 18
        placeholderText: "search ..."
        //
        //
        //
        onAccepted: {
            searchFieldBottom.text = text;
            searchSketches( text );
            focus = false;
        }
    }
    TextField {
        id: searchFieldBottom
        width: parent.width / 4
        height: 48
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        background: Rectangle {
            radius: height / 2
            color: "white"
            border.color: "transparent"
        }
        font.family: ravensbourneRegular.name
        font.pixelSize: 18
        placeholderText: "search ..."
        //
        //
        //
        onAccepted: {
            searchFieldTop.text = text;
            searchSketches( text );
            focus = false;
        }
    }
    //
    //
    //
    property var user: null;
    property var userSketches: null;
    function setup(param) {
        user = null;
        userSketches = null;
        searchFieldBottom.text = searchFieldTop.text = "";
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
            setPromptText();
            //
            //
            //
            var userIconParams = {
                user: user,
                creator: true
            };
            userIconTop.setup(userIconParams);
            userIconBottom.setup(userIconParams);
            start();
        } else {
            console.log( "Home.setup : no user" );
        }
    }

    function close() {
        stop();
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
        /*
        userSketches = Database.getUserSketches(userId);
        var count = userSketches.length;
        console.log( 'user sketches : ' + count );
        for ( var i = 0; i < count; i++ ) {
            var param = {
                source: "SketchIcon.qml",
                container: sketches,
                sketch : userSketches[i],
                user : user,
                dim : 128,
                x : width / 2,
                y : height / 2,
                app: appWindow,
                home: this,
                callback : function( item, param ) {
                    item.icon.source = param.sketch.icon;
                    item.sketch = param.sketch;
                    item.user = param.user;
                    item.app = param.app;
                    item.home = appWindow.sceneId('Home');
                    item.name.text = param.sketch.material.name || param.sketch.icon;
                }
            }
            Utils.loadQML(param);
            //console.log( 'loading user sketch : ' + userSketches[i].id );
        }
        */
        WebDatabase.getUserSketches(userId);
    }
    function searchSketchMetadata( material, regex ) {
        //console.log('searching for :' + regex.toString() );
        if ( material.name && material.name.search(regex) >= 0 ) return true;
        if ( material.manufacturer && material.manufacturer.search(regex) >= 0 ) return true;
        if ( material.description && material.description.search(regex) >= 0 ) return true;
        if ( material.tags ) {
            var found = false;
            material.tags.forEach( function( tag ) {
                found = tag.search(regex) >= 0;
            });
            if ( found ) return true;
        }
        return false;
    }

    function searchSketches( text ) {
        var count = sketches.children.length;
        if ( text.length > 0 ) {
            var regex = new RegExp(text, "i");
            for ( var i = 0; i < count; i++ ) {
                if( sketches.children[ i ].sketch ) {
                    sketches.children[ i ].visible = searchSketchMetadata(sketches.children[ i ].sketch.material,regex);
                }
            }
        } else {
            for ( var i = 0; i < count; i++ ) {
                if( sketches.children[ i ].sketch ) {
                    sketches.children[ i ].visible = true;
                }
            }
        }
    }

    function setPromptText() {
        var welcomeText = "Hi " + user.username;
        var sketchText = userSketches && userSketches.length > 0 ? '\nor select one of your previous sketches' : ''
        var promptText = welcomeText + "\nPlace a material under a scanner to create a new sketch" + sketchText;
        prompt.text = promptText;
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
        WebDatabase.deleteSketch(sketchId);
    }

    function barcodeNewCode(port,barcode) {
        console.log( 'Home.barcodeNewCode(' + barcode + ')');
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
            var energy = 0;
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
                    energy += sketches.children[i].update(factor);
                }
            }
            if ( energy < count * 0.25 ) {
                for ( i = 0; i < count; i++ ) {
                    if ( sketches.children[i].type && sketches.children[i].type === 'blob' ) {
                        sketches.children[i].nudge();
                    }
                }
            }
        }
    }
    //
    //
    // WebDatabase
    //
    function webDatabaseSuccess( command, result ) {
        console.log( 'Home.WebDatabase : success : ' + command );
        if ( result ) {
            //console.log( 'Home.WebDatabase : result : ' + JSON.stringify( result ) );
        }
        if ( command.indexOf('/usersketches/') >= 0 && result ) {
            userSketches = result;
            var count = userSketches.length;
            console.log( 'user sketches : ' + count );
            for ( var i = 0; i < count; i++ ) {
                var param = {
                    source: "SketchIcon.qml",
                    container: sketches,
                    sketch : userSketches[i],
                    user : user,
                    dim : 128,
                    x : width / 2,
                    y : height / 2,
                    app: appWindow,
                    home: this,
                    callback : function( item, param ) {
                        item.icon.source = param.sketch.icon;
                        item.sketch = param.sketch;
                        item.user = param.user;
                        item.app = param.app;
                        item.home = appWindow.sceneId('Home');
                        item.name.text = param.sketch.material.name || param.sketch.icon;
                    }
                }
                Utils.loadQML(param);
                //console.log( 'loading user sketch : ' + userSketches[i].id );
            }
            setPromptText();
        }
    }
    function webDatabaseError( command, error ) {
        console.log( 'Home.WebDatabase : error : ' + command + ':' + error );
        if ( command.indexOf('/usersketches/') >= 0 ) {
            //user = null;
            //prompt.text = message;
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
}
