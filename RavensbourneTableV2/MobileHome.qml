import QtQuick 2.7
import QtQuick.Controls 2.0

Item {
    id: container
    //
    // layout
    //
    Rectangle {
        anchors.fill: parent
        color: colourYellow
    }
    //
    // blobs
    //
    Blobs {
        id: blobs
        anchors.fill: parent
        count: 12
    }
    //
    //
    //
    ListView {
        id: sketches
        anchors.fill: parent
        anchors.margins: 64

        clip: true
        model: sketchModel
        spacing: 4

        delegate: Item { // TODO: move this to external QML
            width: sketches.width
            height: model.collapse ? 0 : 96
            clip: true
            Rectangle {
                anchors.fill: parent
                radius: 29
                color: colourGreen
                opacity: 0.75
            }
            Image {
                id: icon
                width: 80
                height: 80
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 8
                fillMode: Image.PreserveAspectFit
                source: model.sketch.icon
            }
            Text {
                id: name
                clip: true
                anchors.top: parent.top
                anchors.left: icon.right
                anchors.right: deleteButton.left
                anchors.margins: 8
                font.family: ravensbourneBold.name
                font.pixelSize: 18
                wrapMode: Text.WordWrap
                text: model.sketch.material.name
            }
            Text {
                id: description
                clip: true
                anchors.top: name.bottom
                anchors.left: icon.right
                anchors.bottom: parent.bottom
                anchors.right: deleteButton.left
                anchors.margins: 8
                font.family: ravensbourneRegular.name
                font.pixelSize: 18
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                text: model.sketch.material.description || ""
            }
            MouseArea {
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.right: deleteButton.left
                onClicked: {
                    container.editSketch(model.sketch);
                }
            }
            StandardButton {
                id: deleteButton
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 8
                icon:"icons/delete-black.png"
                onClicked: {
                    var sketchId = model.sketch.id
                    confirmDialog.show( "are you sure you want to delete sketch '" + model.sketch.material.name + "' ?", function() {
                        container.deleteSketch(sketchId);
                    });

                }
            }
            Behavior on height {
                NumberAnimation { duration: 250 }
            }
        }
    }
    //
    //
    //
    ListModel {
        id: sketchModel
    }
    //
    //
    //
    HomeToolbar {
        id: toolBar
        anchors.bottom: parent.bottom
        onLogout: {
            appWindow.go('Attractor');
        }
        onSearch: {
            searchSketches(term);
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
            toolBar.username = user.username
            //
            //
            //
            blobs.setup();
            blobs.start();
        } else {
            console.log( "Home.setup : no user specified" );
        }
    }

    function close() {
        blobs.stop();
    }

    function clearSketches() {
        if ( sketches.model ) sketches.model.clear();
    }

    function loadSketches(userId) {
        //
        //
        //
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
        var count = sketchModel.count;
        var i;
        if ( text.length > 0 ) {
            var regex = new RegExp(text, "i");
            for ( i = 0; i < count; i++ ) {
                var item = sketchModel.get(i);
                item.collapse = !searchSketchMetadata(item.sketch.material,regex);
            }
        } else {
            for ( i = 0; i < count; i++ ) {
                sketchModel.get(i).collapse = false;
            }
        }
        sketches.forceLayout();
    }

    function setPromptText() {
        var welcomeText = '';//"Hi " + user.username + ' ';
        var sketchText = userSketches && userSketches.length > 0 ? ' or tap one of your previous sketches to edit' : ''
        var promptText = welcomeText + 'place a material under a scanner to create a new sketch' + sketchText;
        toolBar.prompt = promptText;
    }

    function deleteSketch(sketchId) {
        console.log( 'deleting sketch : ' + sketchId );
        //
        //
        //
        var count = sketchModel.count;
        for ( var i = 0; i < count; i++ ) {
            if( sketchModel.get(i).sketch.id === sketchId ) {
                sketchModel.remove(i);
                break;
            }
        }
        //
        // remove from database
        //
        WebDatabase.deleteSketch(sketchId);
    }
    function editSketch(sketch) {
        var param = {
            user: user,
            sketch: sketch
        };
        appWindow.go('Sketch',param);
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
            sketchModel.clear();
            var count = userSketches.length;
            console.log( 'user sketches : ' + count );
            for ( var i = 0; i < count; i++ ) {
                sketchModel.append({sketch:userSketches[i],collapse:false});
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
    // Barcode
    //
    /*
    function barcodeNewCode(port,barcode) {
        console.log( 'Home.barcodeNewCode(' + barcode + ')');
        materialBrowser.show(barcode);
    }
    */
    function addMaterial( material ) {
        if ( material ) {
            var param = {
                new_sketch: true,
                material: material,
                user: user
            };
            appWindow.go("Sketch",param);
        }
    }
}
