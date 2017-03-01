import QtQuick 2.0
import SodaControls 1.0
import QtWebEngine 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import "Utils.js" as Utils

Item {
    anchors.fill: parent
    Flickable {
        id: sketchScroller
        anchors.fill: parent
        Item {
            id: sketchContainer
            //
            //
            //
            MouseArea {
                id: sketchMouseArea
                anchors.fill: parent
                enabled: true
                //
                //
                //
                onPressed: {
                    console.log('sketchContainer.onPressed');
                }

                onReleased: {
                    console.log('sketchContainer.onReleased');
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

                onPositionChanged: {
                    console.log('sketchContainer.onPositionChanged');
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

                onClicked: {
                    console.log('sketchContainer.onClicked');
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
                                var lineId = drawing.deletePathAtIndex(index);
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
                /*
                onPressAndHold: {
                    console.log('sketchContainer.onPressAndHold');
                    if ( !drawingLine ) {
                        puck.visible = !puck.visible;
                        if( puck.visible ) {
                            puck.x = mouse.x - puck.width / 2;
                            puck.y = mouse.y - puck.height / 2;
                        }
                    }
                }
                */
            }
            Rectangle {
                anchors.fill: parent
                color: "white"
            }
            Item {
                id: sketch
                anchors.fill: parent
            }
            Drawing {
                id: drawing
                anchors.fill: parent
            }
            DropArea {
                id: dropZone
                anchors.fill: parent

                onEntered: {

                }

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
        }
    }
    //
    // puck controls
    //
    Rectangle {
        width: 64
        height: 64
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: 4
        color: colourTurquoise
        radius: width / 2
        Image {
            width: 48
            height: 48
            anchors.centerIn: parent
            source: "icons/puck-white.png"
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    puck.visible = !puck.visible
                }
            }
        }
    }
    Rectangle {
        width: 64
        height: 64
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: parent.verticalCenter
        anchors.topMargin: 4
        color: colourTurquoise
        radius: width / 2
        Image {
            width: 48
            height: 48
            anchors.centerIn: parent
            source: "icons/puck-white.png"
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    puck.visible = !puck.visible
                }
            }
        }
    }
    //
    //
    // sketch info controls
    //
    Rectangle {
        width: 64
        height: 64
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.top: parent.verticalCenter
        anchors.topMargin: 4
        color: colourTurquoise
        radius: width / 2
        Image {
            width: 48
            height: 48
            anchors.centerIn: parent
            rotation: 180
            source: "icons/info-white.png"
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    // show / hide info box
                }
            }
        }
    }
    Rectangle {
        width: 64
        height: 64
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: 4
        color: colourTurquoise
        radius: width / 2
        Image {
            width: 48
            height: 48
            anchors.centerIn: parent
            source: "icons/info-white.png"
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    // show / hide info box
                }
            }
        }
    }
    //
    // group lists
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
    //
    //
    //
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
                // fit item on screen ???
                //
                item.x = componentPosition.x - ( item.width / 2 );
                item.y = componentPosition.y - ( item.height / 2 );
                item.x = Math.max( 0,Math.min(item.x,sketchScroller.width-item.width));
                item.y = Math.max( 0,Math.min(item.y,sketchScroller.height-item.height));
                item.itemId = GUIDGenerator.generate();

                //item.state = "edit"
                setActiveEditor(item);
                if ( componentCallback ) {
                    componentCallback( item );
                    componentCallback = null;
                }
                updateSketchBounds();
                item.itemDestroyed.connect(updateSketchBounds);
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
            if ( item ) {
                item.destroy();
                sessionCommand.itemid = item.itemId;
                sessionCommand.command = 'deleteitem';
                SessionClient.sendMessage( JSON.stringify(sessionCommand) );
            }
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
            puck.selectTool(itemTool);
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
        sketchScroller.interactive = false;
        sketchMouseArea.enabled = true;
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
        case "pan" :
            sketchScroller.interactive = true;
            sketchMouseArea.enabled = false;
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
    property bool newSketch: false
    //
    //
    //
    function setup(param) {
        //console.log( 'Sketch.setup : params : ' + JSON.stringify(param) );
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
                            x: sketchScroller.width / 2,
                            y: sketchScroller.height / 2
                        };
                        createSketchItem(source, position, function(item) {
                            //console.log("url:" + material.image);
                            item.setContent(material.image);
                            item.state = "display";
                        });
                    }
                }
            }
            if ( param.sketch ) {
                newSketch = false;
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
                newSketch = true;
                sketchId = GUIDGenerator.generate();
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

        sketchContainer.grabToImage(function(icon) {
            //console.log( 'sketch icon url:' + icon.url );
            icon.saveToFile("icon-temp.png");
            var object = {
                id: sketchId,
                user_id: user.id,
                group: group,
                //icon: material.image,
                icon: ImageEncoder.uriEncode("icon-temp.png","PNG"),
                material: material,
                items: items,
                drawing: lines
            };
            console.log( 'sketch icon:' + object.icon );
            if ( !newSketch ) {
                console.log('updating sketch : ' + sketchId );
                WebDatabase.updateSketch(object);
            } else {
                newSketch = false;
                console.log('putting new sketch' );
                WebDatabase.putSketch(object);
            }
        },
        Qt.size(192, 108));
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
                    //
                    //
                    //
                    updateSketchBounds();
                    item.itemDestroyed.connect(updateSketchBounds);
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
        console.log('finding item : ' + itemId );
        var count = sketch.children.length;
        for ( var i = 0; i < count; i++ ) {
            if ( sketch.children[ i ].itemId === itemId ) {
                console.log('found item : ' + itemId );
                return sketch.children[ i ];
            } else {
                console.log( 'item id:' + sketch.children[ i ].itemId );
            }
        }
        return undefined;
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

    function updateItem( itemId, data ) {
        console.log('updating item : ' + itemId );
        var item = findItem( itemId );
        if ( item ) item.setup(data);
    }

    function deleteItem( itemId ) {
        console.log('deleting item : ' + itemId );
        var item = findItem( itemId );
        if ( item ) item.destroy();
    }
    function lockItem( itemId ) {
        console.log('locking item : ' + itemId );
        var item = findItem( itemId );
        if ( item ) item.state = "locked";
    }
    function unlockItem( itemId ) {
        console.log('unlocking item : ' + itemId );
        var item = findItem( itemId );
        if ( item ) item.state = "display";
    }

    function updateSketchBounds() {
        //
        // get sketch item bounds
        //
        var min_x = Number.MAX_VALUE;
        var max_x = Number.MIN_VALUE;
        var min_y = Number.MAX_VALUE;
        var max_y = Number.MIN_VALUE;
        var count = sketch.children.length;
        for ( var i = 0; i < count; i++ ) {
            var x = sketch.children[ i ].x;
            var y = sketch.children[ i ].y;
            var width = sketch.children[ i ].width;
            var height = sketch.children[ i ].height;
            //console.log( 'item x=' + x + ' y=' + y + ' width=' + width + ' height=' + height);
            if ( x < min_x ) min_x = x;
            if ( x + width > max_x ) max_x = x + width;
            if ( y < min_y ) min_x = y;
            if ( y + height > max_y ) max_y = y + height;
        }
        //
        // drawing bounds
        //
        var drawingBounds = drawing.getBounds();
        //
        //
        //
        var newWidth = Math.max( sketchScroller.width, Math.max( max_x - min_x,  drawingBounds.width));
        var newHeight = Math.max( sketchScroller.height, Math.max( max_y - min_y,  drawingBounds.height));
        console.log( 'sketch width=' + newWidth + ',' + newHeight );
        sketchContainer.width = newWidth;
        sketchContainer.height = newHeight;
        sketchScroller.contentWidth = newWidth;
        sketchScroller.contentHeight = newHeight;

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
    function setUserLoggedIn( userId, loggedIn ) {
        var count = topUserList.children.length;
        for ( var i = 0; i < count; i++ ) {
            if ( topUserList.children[ i ].user && topUserList.children[ i ].user.id === userId ) {
                topUserList.children[ i ].setLoggedIn(loggedIn);
                break;
            }
        }
        count = bottomUserList.children.length;
        for ( i = 0; i < count; i++ ) {
            if ( bottomUserList.children[ i ].user &&  bottomUserList.children[ i ].user.id === userId ) {
                bottomUserList.children[ i ].setLoggedIn(loggedIn);
                break;
            }
        }
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
            addUserToGroup(newUser);
            //
            // request loggedin userlist
            //
            var sessionCommand = {
                command: 'userlist',
                sketchid: sketchId
            };
            SessionClient.sendMessage(JSON.stringify(sessionCommand));
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
                        //
                        // process user list
                        // user indicators not loaded at this point:
                        // request
                        //
                        if ( command.users ) {
                            command.users.forEach( function(userId) {
                                setUserLoggedIn(userId,true);
                            });
                        }
                        //
                        // process locks
                        //
                        if ( command.locks ) {
                            command.locks.forEach( function(lock) {
                                if ( lock.userid !== user.id ) { // don't lock my items, TODO: need to deal with multiple logins
                                    lockItem(lock.itemid);
                                }
                            });
                        }
                    } else {
                        setUserLoggedIn(command.userid,true);
                    }
                break;
                case 'userlist' :
                    if( command.userlist ) {
                        command.userlist.forEach( function( userId) {
                            setUserLoggedIn(userId,true);
                        });
                    }
                    break;
                case 'leave' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        setUserLoggedIn(command.userid,false);
                    }
                break;
                case 'lock' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                        console.log('received invalid lock');
                    } else {
                        // lock item
                        lockItem(command.itemid)
                    }
                break;
                case 'unlock' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                        console.log('received invalid unlock');
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
                        // delete item
                        deleteItem(command.itemid)
                    }
                break;
                case 'addline' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        drawing.addPath(command.data);
                    }
                break;
                case 'deleteline' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // delete line
                        drawing.deletePath(command.lineid);
                    }
                break;
                case 'updateitem' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // update item
                        updateItem( command.itemid, command.data );
                    }
                }
            }
        }
    }
}
