import QtQuick 2.4
import SodaControls 1.0
import QtWebEngine 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import "Utils.js" as Utils

SketchForm {
    id: sketchContainer

    sketch.onPressed: {
        /* JONS: moved this to trap it in first move, this is to allow pressAndHold puck action
        if ( tool === "draw" ) {
            drawing.startLine(Qt.point(mouse.x,mouse.y),drawColour);
            appWindow.requestUpdate();
        }
        */
    }

    sketch.onReleased: {
        if ( tool === "draw" ) {
            drawingLine = false;
            drawing.endLine(Qt.point(mouse.x,mouse.y));
            appWindow.requestUpdate();
        }
    }

    sketch.onPositionChanged: {
        if ( tool === "draw" ) {
            if ( !drawingLine ) {
                drawingLine = true;
                drawing.startLine(Qt.point(mouse.x,mouse.y),drawColour);
            } else {
                drawing.addPoint(Qt.point(mouse.x,mouse.y));
                appWindow.requestUpdate();
            }

        }
    }

    sketch.onClicked: {
        if ( tool === "text" || tool === "image" ) {
            if ( activeEditor ) {
                setActiveEditor(null);
            } else {
                var source = tool === "image" ? "ImageItem.qml" : "TextItem.qml";
                createSketchItem(source, { x: mouse.x, y: mouse.y } );
            }
        } else {
            if ( tool === "delete" ) {
                var index = drawing.pathAt(Qt.point(mouse.x,mouse.y));
                if ( index >= 0 ) {
                    drawing.deletePath(index);
                }
            }
        }
    }

    sketch.onPressAndHold: {
        if ( !drawingLine ) {
            puck.visible = !puck.visible;
            if( puck.visible ) {
                puck.x = mouse.x - puck.width / 2;
                puck.y = mouse.y - puck.height / 2;
            }
        }
    }

    Drawing {
        id: drawing
        anchors.fill: parent
    }

    DropArea {
        id: imageDrop
        anchors.fill: parent
        onDropped: {
            var source;
            var position = { x: drop.x, y: drop.y };
            if ( drop.hasUrls ) { // TODO: derive drop type from extension ???
                var count = drop.urls.length;
                for ( var i = 0; i < count; i++ ) {
                    console.log("url:" + drop.urls[ 0 ]);
                }
                source = tool === "image" ? "ImageItem.qml" : "TextItem.qml";
                createSketchItem(source, position, function(item) {
                    /*
                      https://www.google.com/imgres?imgurl=https%3A%2F%2Fstatic.pexels.com%2Fphotos%2F139306%2Fpexels-photo-139306.jpeg&imgrefurl=https%3A%2F%2Fwww.pexels.com%2Fsearch%2Fwood%2F&docid=ObSyaY-oy3jODM&tbnid=0mF206UesQ2xoM%3A&vet=1&w=4256&h=2832&bih=1000&biw=928&q=wood&ved=0ahUKEwiUxsr9jvTRAhXJKMAKHRveCqQQMwhaKAEwAQ&iact=mrc&uact=8
                      */
                    var fullLink = drop.urls[ 0 ];
                    var imgUrlStartIndex = fullLink.indexOf('imgurl=');
                    if ( imgUrlStartIndex > 0 ) {
                        imgUrlStartIndex += 'imgurl='.length;
                        var imageUrlEndIndex = fullLink.indexOf('&',imgUrlStartIndex);
                        fullLink = decodeURIComponent(fullLink.substring( imgUrlStartIndex, imageUrlEndIndex ));
                        console.log("full link:" + fullLink);
                    }

                    //console.log("url:" + drop.urls[ 0 ]);
                    //var url = Qt.resolvedUrl(fullLink);
                    //console.log("resolved url:" + url);
                    item.setContent(fullLink);
                    setActiveEditor(item);
                });
                drop.accept();
            } else if ( drop.hasText ) {
                console.log( "drop : " + drop.text )
                source = "TextItem.qml";
                tool = "text";
                createSketchItem(source, position, function(item) {
                    item.setContent( drop.text );
                    setActiveEditor(item);
                });
                drop.accept();
            }

        }
    }
    //
    // group list
    //
    Item {
        height: 64
        anchors.top: parent.bottom
        anchors.topMargin: -( height + 8 )
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.right: parent.horizontalCenter
        Row {
            id: bottomUserList
            spacing: 8
        }
    }
    Item {
        height: 64
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
        rotation: 180
        Row {
            id: topUserList
            spacing: 8
        }
    }
    //
    // colour choosers
    //
    ColourChooser {
        id: colourChooserTop
        width: 240
        height: 240
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: 8
        enabled: true;
        visible: false
        onColourChanged: {
            drawColour = colour;
            colourChooserBottom.setColour(colour);
        }
    }

    ColourChooser {
        id: colourChooserBottom
        width: 240
        height: 240
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: 8
        enabled: true;
        visible: false
        onColourChanged: {
            drawColour = colour;
            colourChooserTop.setColour(colour);
        }
    }
    //
    // Puck
    //
    Puck {
        id: puck
        visible: true
        onPerformAction: {
            //console.log( "puck action" + JSON.stringify(action) );
        }
        onAction: {
            console.log( "action from puck : " + action )
            setTool(action);
        }
    }


    property string tool: ""
    property bool drawingLine: false
    //
    //
    //
    property var drawColour: colourChooserTop.getColour();
    property var textFont: Qt.font({
                                       family: "Helvetica",
                                       bold: 0,
                                       italic: 0,
                                       pixelSize: 48
                                   });
    property var textColour: "black"
    //
    // item creation
    // TODO: create component registry on load
    //
    property var component: null
    property var componentPosition: null
    property var activeEditor: null
    property var componentCallback: null
    function createSketchItem(source,posn,callback) {
        console.log( 'loading component' );
        component = Qt.createComponent(source);
        componentPosition = {
            x : posn.x,
            y : posn.y
        }
        componentCallback = callback;
        switch( component.status ) {
        case Component.Error :
            console.log("error loading component '" + source + ":", component.errorString());
            break;
        case Component.Ready :
            finishCreation();
            break;
        default:
            component.statusChanged.connect(finishCreation);
        }
    }

    function finishCreation() {
        console.log( 'creating component' );
        if (component.status === Component.Ready) {
            var item = component.createObject(sketch);
            if (item !== null) {
                //
                // fit item on screen
                //
                item.x = componentPosition.x - ( item.width / 2 );
                item.y = componentPosition.y - ( item.height / 2 );
                item.x = Math.max( 0,Math.min(item.x,sketch.width-item.width));
                item.y = Math.max( 0,Math.min(item.y,sketch.height-item.height));
                //item.state = "edit"
                setActiveEditor(item);
                if ( componentCallback ) {
                    componentCallback( item );
                    componentCallback = null;
                }
            } else {
                // Error Handling
                console.log("Error creating object");
            }
        } else if (component.status === Component.Error) {
            // Error Handling
            console.log("Error loading component:", component.errorString());
        }
    }

    function setActiveEditor( item ) {
        if ( activeEditor ) {
            if ( !activeEditor.hasContent() ) {
                activeEditor.destroy();
            }
            activeEditor.state = "display"
        }
        if ( tool === "delete" ) {
            if ( item ) item.destroy();
        } else {
            activeEditor = item;
            if ( activeEditor ) {
                activeEditor.state = "edit"
            }
        }
    }

    function setTool( newTool ) {
        tool = newTool;
        setActiveEditor(null);
        colourChooserTop.visible = false;
        colourChooserBottom.visible = false;
        enableSketchItems();
        drawingLine = false;
        switch( tool ) {
        case "image" :
            imageBrowser.show();
            break;
        case "text" :
            break;
        case "draw" :
            colourChooserTop.visible = true;
            colourChooserBottom.visible = true;
            disableSketchItems();
            break;
        case "back" :
            save();
            var param = {
                user: user
            };
            appWindow.go("Home",param);
            break;
        case "delete" :
            break;
        }
    }

    function enableSketchItems() {
        var count = sketch.children.length;
        for ( var i = 0; i < count; i++ ) {
            sketch.children[ 0 ].enabled = true;
        }
    }

    function disableSketchItems() {
        var count = sketch.children.length;
        for ( var i = 0; i < count; i++ ) {
            sketch.children[ 0 ].enabled = false;
        }
    }
    //
    //
    //
    property var user: null
    property var group: []
    property string sketchId: ''
    property var material: null
    //
    //
    //
    function setup(param) {
        //
        // reset UI
        //
        setTool( "" );
        puck.reset();
        //
        // clear sketch
        //
        clear();
        //
        // process params
        //
        console.log('setup : ' + JSON.stringify(param));
        if ( param ) {
            //
            // store user
            //
            user = param.user;
            group = [];
            //
            //
            //
            material = null;
            if ( param.material ) {
                //
                //
                //
                console.log( 'material : ' + param.material );
                material = param.material;
                if ( material.image ) {
                    console.log( 'Sketch image : ' + material.image);
                    if (  param.new_sketch ) {
                        var source = "ImageItem.qml";
                        var position = {
                            x: sketchContainer.width / 2,
                            y: sketchContainer.height / 2
                        };
                        createSketchItem(source, position, function(item) {
                            console.log("url:" + material.image);
                            item.setContent(material.image);
                        });
                    }
                }
            }
            if ( param.sketch ) {
                //
                // store id for save
                //
                sketchId = param.sketch.id;
                material = param.sketch.material;
                group = param.sketch.group;
                //
                // rebuild sketch
                //
                load(param.sketch);
            } else {
                //
                // add sketch creator to group
                //
                group.push(user.id);
            }
            resetGroupIndicators();
        }
    }

    function close() {
        save();
    }

    function save() {
        if ( material === null ) return;
        console.log( 'saving sketch' );
        //
        // save items
        //
        var items = [];
        var count = sketch.children.length;
        for ( var i = 0; i < count; i++ ) {
            if ( sketch.children[ i ].save ) {
                items.push( sketch.children[ i ].save() )
            }
        }
        //
        // save drawing
        //
        var lines = drawing.save();
        //
        //
        //
        console.log( 'saving group' );
        for ( i = 0; i < group.length; i++ ) {
            console.log( 'user : ' + group[ i ] );
        }

        var object = {
            user_id: user.id,
            group: group,
            icon: material.image,
            material: material,
            items: items,
            drawing: lines
        };
        //console.log( 'saving sketch : ' + JSON.stringify(object) );
        if ( sketchId ) {
            object.id = sketchId;
            Database.updateSketch(object);
        } else {

            Database.putSketch(object);
        }
    }

    function load(object) {
        //
        //
        //
        if ( object.items ) {
            var count = object.items.length;
            for ( var i = 0; i < count; i++ ) {
                var source = '';
                switch(object.items[i].type) {
                case 'image' :
                    source = 'ImageItem.qml';
                    break;
                case 'text' :
                    source = 'TextItem.qml';
                    break;
                }
                if ( source.length > 0 ) {
                    loadItem(source,object.items[i]);
                }
            }
        }
        //
        //
        //
        if ( object.drawing ) {
            drawing.load(object.drawing);
        }
    }
    //
    // TODO: integrate this into createSketchItem
    //
    function loadItem(source,param) {
        //
        //
        //
        function initialiseItem() {
            if (component.status === Component.Ready) {
                var item = component.createObject(sketch);
                if (item !== null) {
                    //
                    // initialise item
                    //
                    item.setup(param);
                } else {
                    // Error Handling
                    console.log("Error creating object");
                }
            } else if (component.status === Component.Error) {
                // Error Handling
                console.log("Error loading component:", component.errorString());
            }

        }
        //
        //
        //
        console.log( 'loading component' );
        var component = Qt.createComponent(source);
        switch( component.status ) {
        case Component.Error :
            console.log("error loading component '" + source + ":", component.errorString());
            break;
        case Component.Ready :
            initialiseItem();
            break;
        default:
            component.statusChanged.connect(initialiseItem);
        }
    }

    function clear() {
        //
        // clear current sketch
        //
        var count = sketch.children.length;
        for ( var i = 0; i < count; i++ ) {
            sketch.children[i].destroy();
        }
        drawing.clear();

    }
    //
    // barcode handling
    //
    function barcodeNewCode(port,barcode) {
        materialBrowser.show(barcode);
    }

    function addMaterial( material ) {
        if ( material ) {
            var source = "ImageItem.qml";
            var position = {
                x: sketchContainer.width / 2,
                y: sketchContainer.height / 2
            };
            createSketchItem(source, position, function(item) {
                console.log("url:" + material.image);
                item.setContent(material.image);
            });
        }
    }
    //
    // fingerprint handling
    //
    function fingerPrintValidated(device,id) {
        console.log( 'Valid finger : ' + id );
        //
        // go to user home
        //
        if ( !enrollFingerprint.visible ) { // no enrollment in progress
            if ( id !== user.id ) addUserToGroup(id)
        }
    }
    function fingerPrintValidationFailed(device,error) {
        //
        // show enrollment dialog
        //
        console.log( 'validation failed : ' + error );
        if ( !enrollFingerprint.visible ) { // no enrollment in progress
            var param = {
                device: device
            }
            enrollFingerprint.setup(param);
            enrollFingerprint.visible = true;
        }
    }
    function fingerPrintEnrolled(device,id) {
        addUserToGroup(id);
    }

    function addUserToGroup(id) {
        if ( group.indexOf(id) < 0 ) {
            group.push(id);
        }
        var param = {
            user_id: id,
            creator: id === user.id,
            container: topUserList,
            source: "UserIcon.qml",
            delete_callback: removeUserFromGroup
        }
        Utils.loadQML(param);
        param.container = bottomUserList;
        Utils.loadQML(param);
    }
    function removeUserFromGroup(id) {
        var index = group.indexOf(id);
        if ( index > 0 ) {
            group.splice(index,1);
        }

        var count = topUserList.children.length;
        for ( var i = 0; i < count; i++ ) {
            if ( topUserList.children[ i ].user && topUserList.children[ i ].user.id === id ) {
                console.log('removing user ' + id + ' from topUserList');
                topUserList.children[ i ].destroy();
                break;
            }
        }
        count = bottomUserList.children.length;
        for ( i = 0; i < count; i++ ) {
            if ( bottomUserList.children[ i ].user &&  bottomUserList.children[ i ].user.id === id ) {
                bottomUserList.children[ i ].destroy();
                break;
            }
        }
    }
    function resetGroupIndicators() {
        //
        // clear indicators
        //
        var count = topUserList.children.length;
        for ( var i = 0; i < count; i++ ) {
            topUserList.children[ i ].destroy();
        }
        count = bottomUserList.children.length;
        for ( i = 0; i < count; i++ ) {
            bottomUserList.children[ i ].destroy();
        }
        //
        // add users from group
        //
        group.forEach(function(id){
            addUserToGroup(id);
        });
    }
}
