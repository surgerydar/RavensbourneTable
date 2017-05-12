import QtQuick 2.7
import QtQuick.Controls 2.1

Rectangle {
    id: container
    height: 58
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 16
    radius: height / 2
    color: colourGreen
    clip: true
    //
    //
    //
    property alias imageEditor: imageTool.editor
    property alias textEditor: textTool.editor
    property alias drawingEditor: drawTool.editor
    property string tool: "select"
    property Editor currentEditor: null
    property var drawing: null
    property alias undoManager: undoManager
    //
    //
    //
    signal goHome
    signal showInfo
    //
    //
    //
    StandardButton {
        id: homeButton
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        icon: "icons/home-black.png"
        onClicked: {
            container.goHome();
        }
    }
    StandardButton {
        id: infoButton
        anchors.left: homeButton.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        icon: "icons/info-black.png"
        onClicked: {
            container.showInfo();
        }
    }
    ImageTool {
        id: imageTool
        anchors.left: infoButton.right
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        state: tool === "image" ? "open" : "closed";
        onStateChanged: {
            if ( state === "open" ) {
                currentEditor = editor;
            }
        }
        onSelected: { // TODO: use property for this, move into tool
            state = "open";
            tool = "image";
        }
        onClosed: {
            console.log( 'imageTool closed' );
            if ( target ) {
                target.restoreStoredState();
            }
            tool = "select";
            target = null;
        }
        onConfirmed: {
            console.log( 'imageTool confirmed' );
            if ( target ) {
                // TODO: undo state
                if ( target.hasChanged() ) {
                    undoManager.push("edit item", { item: target, current: target.save(), previous: target.storedState },
                                         function( param ) { // redo
                                            param.item.setup(param.current);
                                         },
                                         function( param ) { // undo
                                            param.item.setup(param.previous);
                                         });
                }
                target.clearStoredState();
            }
            tool = "select";
            target = null;
        }
    }
    TextTool {
        id: textTool
        anchors.left: imageTool.right
        anchors.leftMargin: -4
        anchors.verticalCenter: parent.verticalCenter
        state: tool === "text" ? "open" : "closed"
        onStateChanged: {
            if ( state === "open" ) {
                currentEditor = editor;
            }
        }
        onSelected: {
            state = "open";
            tool = "text";
        }
        onTargetChanged: {
            console.log( "textTool target changed to : " + target );
            if ( target ) {
                target.storeState();
            }
        }
        onClosed: {
            console.log( 'textTool closed' );
            if ( target ) {
                target.restoreStoredState();
            }
            tool = "select";
            target = null;
        }
        onConfirmed: {
            console.log( 'textTool confirmed' );
            if ( target ) {
                if ( target.hasChanged() ) {
                    undoManager.push("edit item", { item: target, current: target.save(), previous: target.storedState },
                                         function( param ) { // redo
                                            param.item.setup(param.current);
                                         },
                                         function( param ) { // undo
                                            param.item.setup(param.previous);
                                         });
                }
                target.clearStoredState();
            }
            tool = "select";
            target = null;
        }
    }
    DrawTool {
        id: drawTool
        anchors.left: textTool.right
        anchors.leftMargin: -4
        anchors.verticalCenter: parent.verticalCenter
        state: tool === "draw" ? "open" : "closed";
        onStateChanged: {
            if ( state === "open" ) {
                currentEditor = null;
            }
        }
        onSelected: {
            state = "open";
            tool = "draw";
            console.log( 'draw tool selected' );
            if ( drawing ) drawing.storeState();
        }
        onClosed: {
            console.log( 'drawTool closed' );
            if ( drawing ) {
                drawing.restoreStoredState();
            }
            tool = "select";
            target = null;
        }
        onConfirmed: {
            console.log( 'drawTool closed' );
            if ( drawing ) {
                if ( drawing.hasChanged() ) {
                    undoManager.push("edit drawing", { drawing: drawing, current: drawing.save(), previous: drawing.storedState },
                                         function( param ) { // redo
                                            param.drawing.load(param.current);
                                         },
                                         function( param ) { // undo
                                            param.drawing.load(param.previous);
                                         });
                }
                drawing.clearStoredState();
            }
            tool = "select";
            target = null;
        }
        onColourChanged: {
            if ( drawing ) {
                drawing.colour = colour;
            }
        }
        onLineWidthChanged: {
            if ( drawing ) {
                drawing.lineWidth = lineWidth;
            }
        }
    }
    //
    //
    //
    StandardButton {
        id: selectButton
        anchors.left: drawTool.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        checkable: true
        checked: tool === "select"
        icon: "icons/select-black.png"
        onClicked: {
            tool = "select";
            //target = undefined;
        }
    }
    StandardButton {
        id: deleteButton
        anchors.left: selectButton.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        checkable: true
        checked: tool === "delete"
        icon: "icons/delete-black.png"
        onClicked: {
            tool = "delete";
            //target = undefined;
        }
    }
    //
    //
    //
    StandardButton {
        id: undoButton
        anchors.left: deleteButton.right
        anchors.leftMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        icon: "icons/undo-black.png"
        enabled: undoManager.canUndo
        onClicked: {
            undoManager.undo();
        }
    }
    StandardButton {
        id: redoButton
        anchors.left: undoButton.right
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        icon: "icons/redo-black.png"
        enabled: undoManager.canRedo
        onClicked: {
            undoManager.redo();
        }
    }
    //
    //
    //
    onToolChanged: {
        console.log('tool has changed to:' + tool ); // ????
    }

    //
    //
    //
    function selectTool( newTool, newTarget ) {
        console.log( 'selectTool: ' + newTool + ' newTarget: ' + newTarget );
        //
        // TODO: how to open content editor?
        //
        var forceEditor = false;
        tool = newTool;
        switch ( tool ) {
        case "image" :
            if ( imageTool.target === newTarget ) {
                forceEditor = true;
            } else {
                imageTool.target = newTarget;
            }
            imageTool.state = "open";
            break;
        case "text" :
            if ( textTool.target === newTarget ) {
                forceEditor = true;
            } else {
                textTool.target = newTarget;
            }
            textTool.state = "open";
            break;
        case "draw" :
            //drawTool.target = target;
            if ( drawing ) drawing.storeState();
            drawTool.state = "open";
            break;

        }
        if ( forceEditor && currentEditor ) {
            currentEditor.show(newTarget);
        }
    }
    //
    //
    //
    UndoManager {
        id: undoManager
        onCanRedoChanged: {
            redoButton.enabled = canRedo;
            console.log('canRedo: ' + canRedo );
        }
        onCanUndoChanged: {
            undoButton.enabled = canUndo;
            console.log('canUndo: ' + canUndo );
        }
    }

}
