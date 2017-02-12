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
            var lineId = drawing.endLine(Qt.point(mouse.x,mouse.y));
            var sessionCommand = {
                command: 'addline',
                sketchid: sketchId,
                userid: user.id,
                lineid: lineId,
                data: drawing.getLine(lineId)
            };
            SessionClient.sendMessage(JSON.stringify(sessionCommand));

            appWindow.requestUpdate();
        }
    }

    sketch.onPositionChanged: {
        if ( tool === "draw" ) {
            if ( !drawingLine ) {
                drawingLine = true;
                drawing.startLine(Qt.point(mouse.x,mouse.y),drawLineWidth,drawColour);
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
                    var lineId = drawing.deletePath(index);
                    var sessionCommand = {
                        command: 'deleteline',
                        sketchid: sketchId,
                        userid: user.id,
                        lineid: lineId
                    };
                    SessionClient.sendMessage(JSON.stringify(sessionCommand));
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
                /*
                  https://www.google.com/imgres?imgurl=https%3A%2F%2Fstatic.pexels.com%2Fphotos%2F139306%2Fpexels-photo-139306.jpeg&imgrefurl=https%3A%2F%2Fwww.pexels.com%2Fsearch%2Fwood%2F&docid=ObSyaY-oy3jODM&tbnid=0mF206UesQ2xoM%3A&vet=1&w=4256&h=2832&bih=1000&biw=928&q=wood&ved=0ahUKEwiUxsr9jvTRAhXJKMAKHRveCqQQMwhaKAEwAQ&iact=mrc&uact=8
                  */
                var imageLink = drop.urls[ 0 ];
                var imgUrlStartIndex = imageLink.indexOf('imgurl=');
                if ( imgUrlStartIndex > 0 ) {
                    imgUrlStartIndex += 'imgurl='.length;
                    var imageUrlEndIndex = imageLink.indexOf('&',imgUrlStartIndex);
                    imageLink = decodeURIComponent(imageLink.substring( imgUrlStartIndex, imageUrlEndIndex ));
                    console.log("full link:" + imageLink);
                }
                if ( activeEditor && activeEditor.type === "image" ) {
                    activeEditor.setContent(imageLink)
                } else {
                    source = tool === "image" ? "ImageItem.qml" : "TextItem.qml";
                    createSketchItem(source, position, function(item) {

                        //console.log("url:" + drop.urls[ 0 ]);
                        //var url = Qt.resolvedUrl(fullLink);
                        //console.log("resolved url:" + url);
                        item.setContent(imageLink);
                        setActiveEditor(item);
                    });
                }
                drop.accept();
            } else if ( drop.hasText ) {
                console.log( "drop : " + drop.text );
                if ( activeEditor && activeEditor.type === "text" ) {
                    activeEditor.setContent( drop.text );
                } else {
                    source = "TextItem.qml";
                    tool = "text";
                    createSketchItem(source, position, function(item) {
                        item.setContent( drop.text );
                        setActiveEditor(item);
                    });
                }
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
    // line style chooser
    //
    LineStyleChooser {
        id: lineStyleChooserTop
        width: 240
        height: 240
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.margins: 8
        enabled: true;
        visible: false
        onStyleChanged: {
            drawColour = colour;
            drawLineWidth = lineWidth;
            lineStyleChooserBottom.setStyle(lineWidth,colour);
        }
    }

    LineStyleChooser {
        id: lineStyleChooserBottom
        width: 240
        height: 240
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        anchors.margins: 8
        enabled: true;
        visible: false
        onStyleChanged: {
            drawColour = colour;
            drawLineWidth = lineWidth;
            lineStyleChooserTop.setStyle(lineWidth,colour);
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
            setActiveEditor(null)
            setTool(action);
        }
    }


    property string tool: ""
    property bool drawingLine: false
    //
    //
    //
    property var drawColour: lineStyleChooserTop.getColour()
    property var drawLineWidth: lineStyleChooserTop.getWidth()
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
    //
    // TODO: replace this with Utils.loadQML
    //
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
                item.itemId = GUIDGenerator.generate();

                //item.state = "edit"
                setActiveEditor(item);
                if ( componentCallback ) {
                    componentCallback( item );
                    componentCallback = null;
                }
                //
                //
                //
                var sessionCommand = {
                    command: 'additem',
                    sketchid: sketchId,
                    userid: user.id,
                    itemid: item.itemId,
                    data: item.save()
                }
                SessionClient.sendMessage( JSON.stringify(sessionCommand) );
            } else {
                // Error Handling
                console.log("Error creating object");
            }
        } else if (component.status === Component.Error) {
            // Error Handling
            console.log("Error loading component:", component.errorString());
        }
    }

    function setActiveEditor( item, itemTool, param ) {
        var sessionCommand = {
            sketchid : sketchId,
            userid : user.id,
        };
        if ( activeEditor ) {
            sessionCommand.itemid = activeEditor.itemId;
            if ( !activeEditor.hasContent() ) { // Remove empty items
                activeEditor.destroy();
                sessionCommand.command = 'deleteitem';
                SessionClient.sendMessage( JSON.stringify(sessionCommand) );
            } else {
                activeEditor.state = "display"
                sessionCommand.command = 'updateitem';
                sessionCommand.data = activeEditor.save();
                SessionClient.sendMessage( JSON.stringify(sessionCommand) );
                sessionCommand.command = 'unlock';
                sessionCommand.data = '';
                SessionClient.sendMessage( JSON.stringify(sessionCommand) );
            }
        }
        if ( tool === "delete" ) {
            if ( item ) item.destroy();
        } else {
            activeEditor = item;
            if ( activeEditor ) {
                activeEditor.state = "edit"
                sessionCommand.itemid = activeEditor.itemId;
                sessionCommand.command = 'lock';
                sessionCommand.data = null;
                SessionClient.sendMessage( JSON.stringify(sessionCommand) );
            }
        }
        if ( itemTool ) {
            setTool( itemTool, param );
            puck.selectTool(itemTool); // only set puck if tool is specified
        }
    }

    function setTool( newTool, param ) {
        tool = newTool;
        /*
        colourChooserTop.visible = false;
        colourChooserBottom.visible = false;
        */
        lineStyleChooserTop.visible = false;
        lineStyleChooserBottom.visible = false;
        enableSketchItems();
        drawingLine = false;
        switch( tool ) {
        case "image" :
            if ( !param || !param.no_options ) imageBrowser.show();
            break;
        case "text" :
            break;
        case "draw" :
            /*
            colourChooserTop.visible = true;
            colourChooserBottom.visible = true;
            */
            lineStyleChooserTop.visible = true;
            lineStyleChooserBottom.visible = true;
            disableSketchItems();
            break;
        case "back" :
            save();
            /*
            var homeParams = {
                user: user
            };
            appWindow.go("Home",homeParams);
            break;
            */
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
        console.log( 'Sketch.setup : params : ' + JSON.stringify(param) );
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
                //console.log( 'material : ' + param.material );
                material = param.material;
                if ( material.image ) {
                    //console.log( 'Sketch image : ' + material.image);
                    if (  param.new_sketch ) {
                        var source = "ImageItem.qml";
                        var position = {
                            x: sketchContainer.width / 2,
                            y: sketchContainer.height / 2
                        };
                        createSketchItem(source, position, function(item) {
                            //console.log("url:" + material.image);
                            item.setContent(material.image);
                        });
                    }
                }
            }
            if ( param.sketch ) {
                console.log( 'loading sketch : ' + param.sketch.id );
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
                console.log( 'creating new sketch' );
                //
                // add sketch creator to group
                //
                sketchId = '';
                group.push(user.id);
            }
            resetGroupIndicators();
            //
            //
            //
            var serssionCommand = {
                command: 'join',
                sketchid: sketchId,
                userid: user.id
            }
            SessionClient.sendMessage( JSON.stringify(serssionCommand) );
        }
    }

    function close() {
        //
        //
        //
        if ( user && sketchId ) {
            var serssionCommand = {
                command: 'leave',
                sketchid: sketchId,
                userid: user.id
            }
            SessionClient.sendMessage( JSON.stringify(serssionCommand) );
        }
        //save();
        user        = null;
        group       = [];
        sketchId    = '';
        material    = null;
    }

    function save() {
        if ( material === null ) return;
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
        // TODO: other sketch metadata
        //
        var object = {
            user_id: user.id,
            group: group,
            icon: material.image,
            material: material,
            items: items,
            drawing: lines
        };
        if ( sketchId.length > 0 ) {
            console.log('updating sketch : ' + sketchId );
            object.id = sketchId;
            WebDatabase.updateSketch(object);
        } else {
            console.log('putting new sketch' );
            object.id = GUIDGenerator.generate();
            WebDatabase.putSketch(object);
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
    // TODO: integrate this into createSketchItem and replace with generic Utils.loadQML
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
    function findItem( itemId ) {
        var count = sketch.children.length;
        for ( var i = 0; i < count; i++ ) {
            if ( sketch.children[ i ].itemId === itemId ) {
                return sketch.children[ i ];
            }
        }
    }
    function addItem( data ) {
        var source;
        if ( data.type === "image" ) {
            source = 'ImageItem.qml';
        } else {
            source = 'TextItem.qml';
        }
        loadItem(source,data);
    }

    function deleteItem( itemId ) {
        var item = findItem( itemId );
        if ( item ) item.destroy();
    }
    function lockItem( itemId ) {
        var item = findItem( itemId );
        if ( item ) item.state = "locked";
    }
    function unlockItem( itemId ) {
        var item = findItem( itemId );
        if ( item ) item.state = "";
    }
    //
    //
    //
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
                item.setContent(material.image);
            });
        }
    }
    //
    // fingerprint handling
    //
    function fingerPrintEnrollmentStage(device,stage) {
        if ( enrollFingerprint.visible ) enrollFingerprint.fingerPrintEnrollmentStage( device, stage );
    }
    function fingerPrintEnrolled(device,id) {
        if ( enrollFingerprint.visible ) enrollFingerprint.fingerPrintEnrolled( device, id );
    }
    function fingerPrintEnrollmentFailed(device) {
        if ( enrollFingerprint.visible ) enrollFingerprint.fingerPrintEnrollmentFailed( device );
    }
    function fingerPrintValidated(device,id) {
        console.log( 'Sketch.Valid finger : ' + id );
        //
        // go to user home
        //
        if ( !enrollFingerprint.visible ) { // no enrollment in progress
            if ( user === null || user.id !== id ) // not current user
                WebDatabase.getUser(id);
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
    //
    //
    //
    function addUserToGroup(newUser) {
        if ( group.indexOf(newUser.id) < 0 ) {
            group.push(newUser.id);
        }
        var param = {
            user: newUser,
            creator: newUser.id === user.id,
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
        // queue getUser requests
        //
        group.forEach(function(id){
            WebDatabase.getUser(id);
        });
    }

    /* TODO: integrate undo
    UndoManager {
        id: undoManager
    }
    */
    function webDatabaseSuccess( command, result ) {
        var params;
        if ( command.indexOf('/sketch') === 0 ) {
            params = {
                user: user
            };
            appWindow.go("Home",params);
        } else if (command.indexOf('/user/') === 0 && result ) {
            var newUser = {
                id: result.fingerprint,
                username: result.username,
                email: result.email
            };
            addUserToGroup(newUser)
        } else if (command.indexOf('/user') === 0 && enrollFingerprint.visible) {
            if ( enrollFingerprint.user ) {
                addUserToGroup(enrollFingerprint.user)
            }
            enrollFingerprint.visible = false;
        }
    }
    function webDatabaseError( command, error ) {
        //
        // TODO: handle error
        //
        if ( command.indexOf('/sketch') === 0 ) {
            var params = {
                user: user
            };
            appWindow.go("Home",params);
        }
        enrollFingerprint.visible = false;
    }
    Connections {
        target: SessionClient
        //
        //
        //
        onClosed : {
            console.log( 'SessionClient : closed' );
        }
        onMessageReceived : {
            console.log( 'SessionClient : MessageReceived : ' + message );
            var command = JSON.parse(message);
            if ( command && command.sketchid === sketchId ) {
                switch( command.command ) {
                case 'join' :
                    if ( command.userid === user.id ) {
                        // me, update userlist
                    } else {
                        // someone else, add to userlist
                    }
                break;
                case 'leave' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // someone else, add to userlist
                    }
                break;
                case 'lock' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // lock item
                        lockItem(command.itemid)
                    }
                break;
                case 'unlock' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // lock item
                        unlockItem(command.itemid)
                    }
                break;
                case 'additem' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        addItem(command.data);
                    }
                break;
                case 'deleteitem' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // lock item
                        deleteItem(command.itemid)
                    }
                break;
                case 'addline' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                    }
                break;
                case 'deleteline' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // delete line

                    }
                break;
                }
            }
        }
    }
 }
