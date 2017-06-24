import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "Utils.js" as Utils
import SodaControls 1.0

Item {
    id: container
    //
    // metadata
    //
    property var user: null
    property string sketchId: ""
    property var material: null
    //
    // runtime variable
    //
    property bool newSketch: false
    property var currentSelection: null
    Flickable { // TODO: contentWidth / contentHeight
        id: sketch
        anchors.fill: parent
        //
        //
        //
        Rectangle {
            id: background
            x: 0
            y: 0
            width: sketch.contentWidth
            height: sketch.contentHeight
            color: "white"
        }

        //
        //
        //
        function getTransformedContentRect() {
            var min = Qt.point(Number.MAX_VALUE,Number.MAX_VALUE);
            var max = Qt.point(Number.MIN_VALUE,Number.MIN_VALUE);
            var count = contentItem.children.length;
            for ( var i = 0; i < count; i++ ) {
                var child = contentItem.children[ i ];
                if (child.getTransformedBounds) {
                    var bounds = child.getTransformedBounds();
                    if ( bounds.x < min.x ) min.x = bounds.x;
                    if ( bounds.y < min.y ) min.y = bounds.y;
                    if ( bounds.x + bounds.width > max.x ) max.x = bounds.x + bounds.width;
                    if ( bounds.y + bounds.height > max.y ) max.y = bounds.y + bounds.height;
                } else {
                    //console.log("child doesn't impliment getTransformedBounds");
                }
            }
            return Qt.rect(min.x,min.y,max.x-min.x,max.y-min.y);
        }
        function adjustContentRect() {
            var transformedContentRect = getTransformedContentRect();
            contentWidth = Math.max( Math.abs(transformedContentRect.x)+transformedContentRect.width, width );
            contentHeight = Math.max( Math.abs(transformedContentRect.y)+transformedContentRect.height, height );
            var offset = transformedContentRect.x < 0. || transformedContentRect.y < 0.;
            if ( transformedContentRect.x < 0. ) {
                contentX += Math.abs(transformedContentRect.x);
            }
            if ( transformedContentRect.y < 0. ) {
                contentY += Math.abs(transformedContentRect.y);
            }
            if ( offset ) {
                var count = contentItem.children.length;
                var p = Qt.point(transformedContentRect.x < 0.?Math.abs(transformedContentRect.x) : 0.,transformedContentRect.y < 0.?Math.abs(transformedContentRect.y) : 0.);
                console.log( 'offset[' + p.x + ',' + p.y + ']')
                for ( var i = 0; i < count; i++ ) {
                    var child = contentItem.children[ i ];
                    try {
                        child.moveBy(p);
                    } catch( err ) {
                        console.log( 'unable to offset child : ' + err );
                    }
                }
            }
        }
        function findItemWithId( itemId ) {
            var count = contentItem.children.length;
            for ( var i = 0; i < count; i++ ) {
                if ( contentItem.children[ i ].itemId === itemId ) {
                    return contentItem.children[ i ];
                }
            }
            return null;
        }

        function getItemIndex( item ) {
            var count = contentItem.children.length;
            for ( var i = 0; i < count; i++ ) {
                if ( contentItem.children[ i ].itemId === item.itemId ) return i;
            }
            return -1;
        }
        function deleteItemWithId( itemId ) {
            var item = findItemWithId(itemId);
            if ( item ) {
                //
                //
                //
                SessionClient.sendMessage(item.sessionCommand('deleteitem',sketchId,user.id));
                //
                //
                //
                item.destroy();
            }
        }
        function restoreItem( data, callback ) {
            data.container = sketch.contentItem;
            switch( data.type ) {
            case "image" :
                data.source = "ImageItem.qml";
                break;
            case "text" :
                data.source = "TextItem.qml";
                break;
            }
            data.callback = callback;
            Utils.loadQML(data);
        }
        function restoreItemAtIndex( index, data ) {
            restoreItem( data, function() {
                var current = data.container.children.length - 1;
                while( current > 0 && current > index ) {
                    console.log( 'swapping item ' + current + ' with ' + ( current -1 ) );
                    var temp = data.container.children[ current ];
                    data.container.children[ current ] = data.container.children[ current - 1 ];
                    data.container.children[ current - 1 ] = temp;
                    current--;
                }
                //
                //
                //
                SessionClient.sendMessage(item.sessionCommand('additem',sketchId,user.id));
            });
        }
        function restoreItemWithId( itemId, data ) {
            var item = findItemWithId(itemId);
            if ( item ) {
                item.setup(data);
                //
                //
                //
                SessionClient.sendMessage(item.sessionCommand('additem',sketchId,user.id));
            }
        }
        function editItem( item ) {
            currentSelection = item;
        }
        function deleteItem( item ) {
            var itemIndex = getItemIndex(item);
            if ( itemIndex >= 0 ) {
                toolBar.undoManager.push("delete item", { data: item.save(), id: item.itemId },
                                         function( param ) { // redo
                                             sketch.deleteItemWithId(param.id);
                                         },
                                         function( param ) { // undo
                                             sketch.restoreItemAtIndex(param.index,param.data);
                                         });
            }
            //
            //
            //
            SessionClient.sendMessage(item.sessionCommand('deleteitem',sketchId,user.id));
            //
            //
            //
            item.destroy();
            toolBar.selectTool("select");
        }
        function lockItemWithId( itemId, lock ) {
            var item = findItemWithId(itemId);
            if ( item ) {
                item.locked = lock;
            }
        }

        function itemPressed( item ) {
            if ( toolBar.tool === "delete" ) {
                deleteItem(item);
            }
        }
        function itemDoubleClicked( item ) {
            /*
            if ( toolBar.tool !== "delete" ) {
                editItem(item)
            }
            */
        }
        function itemPressAndHold( item ) {
            if ( toolBar.tool !== "delete" ) {
                editItem(item);
            }
        }
        function itemBeginTransform( item ) {
            item.storeState();
            SessionClient.sendMessage(item.sessionCommand('lock',sketchId,user.id));
        }
        function itemEndTransform( item ) {
            if ( item.hasChanged() ) {
                toolBar.undoManager.push("transform item", { id: item.itemId, current: item.save(), previous: item.storedState },
                                         function( param ) { // redo
                                             sketch.restoreItemWithId(param.id,param.current);
                                         },
                                         function( param ) { // undo
                                             sketch.restoreItemWithId(param.id,param.previous);
                                         });
                item.clearStoredState()
                //
                //
                //
                SessionClient.sendMessage(item.sessionCommand('updateitem',sketchId,user.id));
                SessionClient.sendMessage(item.sessionCommand('unlock',sketchId,user.id));
            }
        }
        function itemShowInfo( item ) {
            switch( item.type ) {
            case "image" :
                if ( item.metadata ) {
                    metadataViewer.show(item.metadata);
                }
            }
        }
        //
        // TODO: move this to external qml or include properties + functions in c++
        //
        Drawing {
            id: drawing
            anchors.fill: parent
            z: 1 // ensure drawing is above items
            //
            //
            //
            property string type: "draw"
            //
            //
            //
            property int selectedLine: -1
            property var storedState: null
            //
            //
            //
            property color colour: "black"
            property real lineWidth: 4.
            //
            //
            //
            onColourChanged: {
                //console.log( 'colourChanged: ' + colour + " selectedLine: " + selectedLine );
                if ( selectedLine >= 0 ) {
                    setLineColourAtIndex(selectedLine,colour);
                }
            }
            onLineWidthChanged: {
                //console.log( 'lineWidthChanged: ' + lineWidth + " selectedLine: " + selectedLine );
                if ( selectedLine >= 0 ) {
                    setLineWidthAtIndex(selectedLine,lineWidth);
                }
            }
            //
            //
            //
            function storeState() {
                storedState = save();
                //console.log( 'stored drawing state:' + storedState );
            }
            function hasChanged() {
                var state = save();
                return state !== storedState;
            }
            function clearStoredState() {
                //console.log( 'clear drawing state:' + storedState );
                console.trace();
                storedState = null;
            }
            function restoreStoredState() {
                if ( storedState ) {
                    load(storedState);
                    clearStoredState();
                }
            }
            //
            //
            //
            //
            // session commands
            //
            function sessionCommand( command, sketchId, userId, lineId ) {
                //
                // base command
                //
                var param = {
                    command: command,
                    sketchid: sketchId,
                    userid: userId,
                    lineid: lineId || getLineId(selectedLine),
                };
                //
                // command specific data
                //
                switch ( command ) {
                case 'insertline' :
                case 'addline' :
                case 'updateline' :
                    param.lineindex = getLineIndex(param.lineid);
                    param.data = getLine(param.lineid);
                    break;
                }
                //
                // return string
                //
                try {
                    //console.log( 'session command: ' + JSON.stringify(param) );
                    return JSON.stringify(param);
                } catch( err ) {
                    console.log( "unable to build session command '" + command + "' error : " + err );
                    return '{ "command" : "void"  }';
                }
            }
        }
        //
        //
        //
        PinchArea {
            id: pinch
            anchors.fill: parent
            property real initialWidth: 1.
            property real initialHeight: 1.
            property real initialScale: 1.
            property real minScale: .5
            property real maxScale: 10.
            property var cachedItem: null
            onPinchStarted: {
                //console.log( 'pinch started' );
                if ( toolBar.tool === "select" ) {
                    /*
                    initialScale = sketch.scale;
                    initialWidth = sketch.contentWidth;
                    initialHeight = sketch.comtentHeight;
                    minScale = Math.min(sketch.width / sketch.contentWidth, sketch.height / sketch.contentHeight);
                    */
                    var line1 = drawing.lineIndexAt(pinch.point1);
                    var line2 = drawing.lineIndexAt(pinch.point2);
                    if ( line1 >= 0 ) {
                        drawing.selectedLine = line1;
                    } else if ( line2 >= 0 ) {
                        drawing.selectedLine = line2;
                    } else {
                        drawing.selectedLine = -1;
                    }
                    if ( drawing.selectedLine >= 0 ) {
                        cachedItem = drawing.getLineAtIndex(drawing.selectedLine);
                    }
                    //console.log( 'pinch : selectedLine:' + drawing.selectedLine );
                }
            }
            onPinchUpdated: {
                if ( toolBar.tool === "select" ) {
                    if ( drawing.selectedLine >= 0 ) {
                        var newScale = 1. + ( pinch.scale - pinch.previousScale );
                        //console.log( 'previousScale:' + pinch.previousScale + ' scale:' + pinch.scale + ' newScale:' + newScale );
                        drawing.scaleLineAtIndex( drawing.selectedLine, pinch.center, newScale );

                        var rotation = -( pinch.angle-pinch.previousAngle );
                        //console.log( 'previousAngle:' + pinch.previousAngle + ' angle:' + pinch.angle + ' rotation:' + rotation );
                        drawing.rotateLineAtIndex( drawing.selectedLine, pinch.center, rotation);

                        var by = Qt.point( pinch.center.x - pinch.previousCenter.x, pinch.center.y - pinch.previousCenter.y );
                        drawing.moveLineAtIndex(drawing.selectedLine,by);
                    } else {
                        /*
                        var newScale = initialScale * pinch.scale;
                        if ( newScale > minScale && newScale < maxScale ) {
                            //sketch.scale = newScale;
                            //sketch.resizeContent(initialWidth * pinch.scale, initialHeight * pinch.scale, pinch.center)
                        }
                        console.log('currentScale:' + sketch.scale + 'newScale:' + newScale);
                        */
                    }
                }
            }
            onPinchFinished: {
                if ( toolBar.tool === "select" ) {
                    if ( drawing.selectedLine >= 0 ) {
                        toolBar.undoManager.push("transform line", {data: drawing.getLineAtIndex(drawing.selectedLine), cachedItem: cachedItem, index: drawing.selectedLine },
                                                 function( param ) {
                                                     drawing.restoreLineAtIndex(param.index,param.data);
                                                     SessionClient.sendMessage(drawing.sessionCommand('updateline',sketchId,user.id,drawing.getLineId(param.index)));
                                                 },
                                                 function( param ) {
                                                     drawing.restoreLineAtIndex(param.index,param.cachedItem);
                                                     SessionClient.sendMessage(drawing.sessionCommand('updateline',sketchId,user.id,drawing.getLineId(param.index)));
                                                 });
                        SessionClient.sendMessage(drawing.sessionCommand('updateline',sketchId,user.id,drawing.getLineId(drawing.selectedLine)));
                        sketch.adjustContentRect();
                        drawing.selectedLine = -1;
                    }
                }
            }
            MouseArea {
                anchors.fill: parent
                property point previousMouse;
                property bool dragging: false
                onPressed: {
                    var p = Qt.point(mouse.x,mouse.y);
                    var selectedLine = drawing.lineIndexAt(p);
                    dragging = false
                    switch( toolBar.tool ) {
                    case "draw" :
                        sketch.interactive = false;
                        drawing.startLine(p,drawing.lineWidth,drawing.colour);
                        mouse.accepted = true;
                        break;
                    case "select" :
                        drawing.selectedLine = selectedLine;//drawing.lineIndexAt(p);
                        //console.log('selected line:' + drawing.selectedLine)
                        mouse.accepted = drawing.selectedLine >= 0;
                        previousMouse = p;
                        if ( currentSelection ) SessionClient.sendMessage(currentSelection.sessionCommand('unlock',sketchId,user.id));
                        currentSelection = null; // TODO: find a better way
                        if ( drawing.selectedLine >= 0 ) {
                            parent.cachedItem = drawing.getLineAtIndex(drawing.selectedLine);
                        }
                        break;
                    case "delete" :
                        var lineIndex = drawing.lineIndexAt(p);
                        if ( lineIndex >= 0 ) {
                            toolBar.undoManager.push("delete line", { data: drawing.getLineAtIndex(lineIndex), index: lineIndex },
                                                     function( param ) {
                                                         drawing.deleteLineAtIndex(param.index);
                                                         SessionClient.sendMessage(drawing.sessionCommand('deleteline',sketchId,user.id,drawing.getLineId(param.index)));
                                                     },
                                                     function( param ) {
                                                         drawing.insertLineAtIndex(param.index,param.data);
                                                         SessionClient.sendMessage(drawing.sessionCommand('insertline',sketchId,user.id,drawing.getLineId(param.index)));
                                                     });
                            SessionClient.sendMessage(drawing.sessionCommand('deleteline',sketchId,user.id,drawing.getLineId(lineIndex)));
                            drawing.deleteLineAtIndex(lineIndex);
                        }
                        sketch.adjustContentRect();
                        break;
                    }

                }
                onPositionChanged:  {
                    dragging = true;
                    var p = Qt.point(mouse.x,mouse.y);
                    switch(toolBar.tool) {
                    case "draw" :
                        drawing.addPoint(p);
                        break;
                    case "select" :
                        if ( drawing.selectedLine >= 0 ) {
                            drawing.moveLineAtIndex(drawing.selectedLine,Qt.point(p.x-previousMouse.x,p.y-previousMouse.y));
                            previousMouse = p;
                        }
                        break;
                    }
                }
                onReleased: {
                    dragging = false;
                    var p = Qt.point(mouse.x,mouse.y);
                    switch(toolBar.tool) {
                    case "draw" :
                        sketch.interactive = true;
                        if ( drawing.isLineOpen() ) {
                            var lineId = drawing.endLine(p);
                            /*
                            toolBar.undoManager.push("add line", {id: lineId, data: drawing.getLine(lineId), index: drawing.getLineIndex(lineId) },
                                                     function( param ) {
                                                         drawing.insertLineAtIndex(param.index,param.data);
                                                     },
                                                     function( param ) {
                                                         drawing.deleteLine(param.id);
                                                     });
                            */
                            SessionClient.sendMessage(drawing.sessionCommand('addline',sketchId,user.id,lineId));
                            sketch.adjustContentRect();
                        }
                        break;
                    case "select" :
                        if ( drawing.selectedLine >= 0 ) {
                            drawing.moveLineAtIndex(drawing.selectedLine,Qt.point(mouse.x-previousMouse.x,mouse.y-previousMouse.y));
                            sketch.adjustContentRect();
                            toolBar.undoManager.push("move line", {data: drawing.getLineAtIndex(drawing.selectedLine), cachedItem: parent.cachedItem, index: drawing.selectedLine },
                                                     function( param ) {
                                                         drawing.restoreLineAtIndex(param.index,param.data);
                                                         SessionClient.sendMessage(drawing.sessionCommand('updateline',sketchId,user.id,drawing.getLineId(param.index)));

                                                     },
                                                     function( param ) {
                                                         drawing.restoreLineAtIndex(param.index,param.cachedItem);
                                                         SessionClient.sendMessage(drawing.sessionCommand('updateline',sketchId,user.id,drawing.getLineId(param.index)));
                                                     });
                            SessionClient.sendMessage(drawing.sessionCommand('updateline',sketchId,user.id,drawing.getLineId(drawing.selectedLine)));
                        }
                        if ( currentSelection ) SessionClient.sendMessage(currentSelection.sessionCommand('unlock',sketchId,user.id));
                        currentSelection = null; // TODO: find a better way
                        drawing.selectedLine = -1;
                        break;
                    }
                }
                onPressAndHold: {
                    drawing.selectedLine = drawing.lineIndexAt(Qt.point(mouse.x,mouse.y));
                    switch(toolBar.tool) {
                    /*
                    case "draw" :
                        if ( drawing.selectedLine >= 0 ) {
                            drawing.cancelLine();
                            toolBar.selectTool("draw", drawing );
                        }
                        break;
                    */
                    case "select" :
                        if ( !dragging && drawing.selectedLine >= 0 ) {
                            //toolBar.selectTool("draw", drawing );
                            currentSelection = drawing;
                        }
                        break;
                    }
                }
            }
        }
        //
        //
        //
        Connections {
            target: sketch.contentItem
            onChildrenChanged : {
                //console.log('sketch.contentItem.childrenChanged');
                var count = sketch.contentItem.children.length;
                for ( var i = 0; i < count; i++ ) {
                    if ( sketch.contentItem.children[ i ].transformChanged ) {
                        //console.log('connecting to transform changed');
                        //
                        //
                        //
                        sketch.contentItem.children[ i ].transformChanged.disconnect(sketch.adjustContentRect);
                        sketch.contentItem.children[ i ].beginTransform.disconnect(sketch.itemBeginTransform);
                        sketch.contentItem.children[ i ].endTransform.disconnect(sketch.itemEndTransform);
                        sketch.contentItem.children[ i ].pressed.disconnect(sketch.itemPressed);
                        sketch.contentItem.children[ i ].doubleClicked.disconnect(sketch.itemDoubleClicked);
                        sketch.contentItem.children[ i ].pressAndHold.disconnect(sketch.itemPressAndHold);
                        sketch.contentItem.children[ i ].showInfo.disconnect(sketch.itemShowInfo);
                        //
                        //
                        //
                        sketch.contentItem.children[ i ].transformChanged.connect(sketch.adjustContentRect);
                        sketch.contentItem.children[ i ].beginTransform.connect(sketch.itemBeginTransform);
                        sketch.contentItem.children[ i ].endTransform.connect(sketch.itemEndTransform);
                        sketch.contentItem.children[ i ].pressed.connect(sketch.itemPressed);
                        sketch.contentItem.children[ i ].doubleClicked.connect(sketch.itemDoubleClicked);
                        sketch.contentItem.children[ i ].pressAndHold.connect(sketch.itemPressAndHold);
                        sketch.contentItem.children[ i ].showInfo.connect(sketch.itemShowInfo);
                    }
                }
                sketch.adjustContentRect();
            }
        }
    }
    //
    // editors
    //
    FlickrImageBrowser {
        id: imageBrowser
        anchors.left: toolBar.left
        anchors.right: toolBar.right
        anchors.top: toolBar.top
        anchors.bottom: toolBar.bottom
        onConfirm: {
            addItem(getContent());
        }
    }
    //
    //
    //
    TextEditor {
        id: textEditor
        anchors.left: toolBar.left
        anchors.right: toolBar.right
        anchors.top: toolBar.top
        anchors.bottom: toolBar.bottom
        onConfirm: {
            addItem(getContent());
        }
    }
    //
    // toolbar
    //
    SketchToolbar {
        id: toolBar
        anchors.bottom: parent.bottom
        imageEditor: imageBrowser
        textEditor: textEditor
        drawing: drawing
        onToolChanged: {
            //currentSelection = null;
        }
        onGoHome: {
            save();
        }
        onShowInfo: {
            metadataViewer.show(material);
        }
    }
    //
    //
    //
    onCurrentSelectionChanged: {
        //
        // update selection indicator
        //
        var count = sketch.contentItem.children.length;
        for ( var i = 0; i < count; i++ ) {
            if ( sketch.contentItem.children[ i ].selected !== undefined ) {
                sketch.contentItem.children[ i ].selected = sketch.contentItem.children[ i ] === currentSelection;
            }
        }

        if ( currentSelection ) {
            toolBar.selectTool(currentSelection.type,currentSelection);
        }
    }
    //
    //
    //
    function addItem(param,blockUndo) {
        if ( currentSelection && currentSelection.type === param.type ) {
            switch( param.type ) {
            case "image" :
                currentSelection.content = param.content;
                break;
            case "text" :
                currentSelection.content = param.content;
                currentSelection.colour = param.colour;
                currentSelection.font = param.font;
                currentSelection.alignment = param.alignment;
                break;
            }
        } else {
            param.container = sketch.contentItem;
            switch( param.type ) {
            case "image" :
                param.source = "ImageItem.qml";
                break;
            case "text" :
                param.source = "TextItem.qml";
                break;
            }
            if ( !blockUndo ) {
                param.callback = function( item ) {
                    toolBar.undoManager.push("add item", { data: param, id: item.itemId },
                                             function( p ) { // redo
                                                 sketch.restoreItem( p.data );
                                             },
                                             function( p ) { // undo
                                                 sketch.deleteItemWithId(p.id);
                                             });
                };
            }
            Utils.loadQML(param);
        }
        currentSelection = null;
    }
    //
    //
    //
    function setup(param) {
        clear();
        //
        // process params
        //
        if ( param ) {
            //
            // store user
            //
            user = param.user;
            toolBar.group.clear();
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
                        addItem({
                                    type: "image",
                                    content: material.image,
                                    metadata: material
                                },true);
                    }
                }
            }
            if ( param.sketch ) {
                console.log( 'loading sketch : ' + param.sketch.id );
                //
                // store id for save
                //
                sketchId    = param.sketch.id;
                material    = param.sketch.material;
                if ( param.sketch.group ) {
                    param.sketch.group.forEach( function(u) {
                        //console.log('group member : ' + JSON.stringify(u));
                        toolBar.group.addUser(u,u.id === user.id);
                    });

                }
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
                toolBar.group.addUser(user,true);
            }
            //resetGroupIndicators();
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
        //save(); //????
        clear();
        user        = null;
        sketchId    = '';
        material    = null;
    }
    //
    //
    //
    function save() {
        if ( material === null ) return;
        //
        // save items
        //
        var items = [];
        var count = sketch.contentItem.children.length;
        for ( var i = 0; i < count; i++ ) {
            var item = sketch.contentItem.children[ i ];
            if ( sketch.contentItem.children[i].type === "image" || sketch.contentItem.children[i].type === "text" ) {
                items.push( item.save() )
            }
        }
        //
        // save drawing
        //
        var lines = drawing.save();
        //
        //
        //
        //console.log( 'generating sketch icon' );
        sketch.grabToImage(function(icon) {
            //console.log( 'sketch icon done' );
            //sketch.contentItem.grabToImage(function(icon) {
            var iconPath = PathUtils.temporaryDirectory() + '/icon-temp.png';
            console.log( 'saving icon to : ' + iconPath );
            icon.saveToFile(iconPath);
            var object = {
                id: sketchId,
                user_id: user.id,
                group: toolBar.group.getUsers(),
                icon: ImageEncoder.uriEncode(iconPath,"PNG"),
                material: material,
                items: items,
                drawing: lines
            };
            if ( !newSketch ) {
                //console.log('updating sketch : ' + sketchId );
                WebDatabase.updateSketch(object);
            } else {
                newSketch = false;
                //console.log('putting new sketch' );
                WebDatabase.putSketch(object);
            }
        },
        Qt.size(192, 108));
    }
    function load(object) {
        toolBar.undoManager.clear();
        //
        // read items
        //
        if ( object.items ) {
            var count = object.items.length;
            for ( var i = 0; i < count; i++ ) {
                addItem(object.items[i],true);
            }
        }
        //
        // read drawing
        //
        if ( object.drawing ) {
            drawing.load(object.drawing);
        }
    }
    function clear() {
        //
        // clear current sketch
        //
        var count = sketch.contentItem.children.length;
        for ( var i = 0; i < count; i++ ) {
            if ( sketch.contentItem.children[i].type === "image" || sketch.contentItem.children[i].type === "text" ) {
                sketch.contentItem.children[i].destroy();
            }
        }
        drawing.clear();
        toolBar.group.clear();

    }
    //
    // WebDatabase
    //
    function webDatabaseSuccess( command, result ) {
        var params;
        if ( command.indexOf('/sketch') === 0 ) { // Sketch save OK
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
            toolBar.group.addUser(newUser);
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
                toolBar.group.addUser(enrollFingerprint.user);
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
    //
    // Barcode / material
    //
    /*
    function barcodeNewCode(port,barcode) {
        console.log( 'Sketch.barcodeNewCode(' + barcode + ')');
        materialBrowser.show(barcode);
    }
    */
    function addMaterial( material ) {
        //
        // TODO: add image or create new sketch
        //
        var param = {
            type: "image",
            content: material.image,
            metadata: material
        };
        addItem(param);
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
        //
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
    // SessionClient
    //
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
                                toolBar.group.setUserLoggedIn(userId,true);
                            });
                        }
                        //
                        // process locks
                        //
                        if ( command.locks ) {
                            command.locks.forEach( function(lock) {
                                if ( lock.userid !== user.id ) { // don't lock my items, TODO: need to deal with multiple logins
                                    lockItemWithId(lock.itemid,true);
                                }
                            });
                        }
                    } else {
                        toolBar.group.setUserLoggedIn(userId,true);
                    }
                    break;
                case 'userlist' :
                    if( command.userlist ) {
                        command.userlist.forEach( function( userId) {
                            toolBar.group.setUserLoggedIn(userId,true);
                        });
                    }
                    break;
                case 'leave' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        toolBar.group.setUserLoggedIn(userId,false);
                    }
                    break;
                case 'lock' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                        console.log('received invalid lock');
                    } else {
                        // lock item
                        lockItemWithId(command.itemid,true);
                    }
                    break;
                case 'unlock' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                        console.log('received invalid unlock');
                    } else {
                        // lock item
                        lockItemWithId(command.itemid,false);
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
                case 'updateitem' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // update item
                        updateItem( command.itemid, command.data );
                    }
                    break;
                case 'addline' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        drawing.addLine(command.data);
                    }
                    break;
                case 'deleteline' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // delete line
                        drawing.deleteLine(command.lineid);
                    }
                    break;
                case 'updateline' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // delete line
                        drawing.restoreLine(command.lineid,command.data);
                    }
                    break;
                case 'insertline' :
                    if ( command.userid === user.id ) {
                        // me, do nothing
                    } else {
                        // delete line
                        drawing.insertLineAtIndex(command.lineindex,command.data);
                    }
                    break;
                }
            }
        }
    }
}
