import QtQuick 2.4
import SodaControls 1.0

SketchForm {

    sketch.onPressed: {
        console.log('pressed [' + mouse.x + ',' + mouse.y + ']');
        if ( tool === "draw" ) {
            drawing.startLine(Qt.point(mouse.x,mouse.y),drawColour);
            appWindow.requestUpdate();
        }
    }

    sketch.onReleased: {
        console.log('released [' + mouse.x + ',' + mouse.y + ']');
        if ( tool === "draw" ) {
            drawing.endLine(Qt.point(mouse.x,mouse.y));
            appWindow.requestUpdate();
        }
    }

    sketch.onPositionChanged: {
        //console.log('moved [' + mouse.x + ',' + mouse.y + ']');
        if ( tool === "draw" ) {
            drawing.addPoint(Qt.point(mouse.x,mouse.y));
            appWindow.requestUpdate();
        }
    }

    sketch.onClicked: {
        if ( tool === "text" || tool === "image" ) {
            var source = tool === "image" ? "ImageItem.qml" : "TextItem.qml";
            createSketchItem(source, { x: mouse.x, y: mouse.y } );
        } else {
            if ( tool === "delete" ) {
                var index = drawing.pathAt(Qt.point(mouse.x,mouse.y));
                if ( index >= 0 ) {
                    drawing.deletePath(index);
                }
            }
        }
    }

    sketch.onDoubleClicked: {
        puck.visible = !puck.visible;
        if( puck.visible ) {
            puck.x = mouse.x - puck.width / 2;
            puck.y = mouse.y - puck.height / 2;
        }
    }


    textButton.onCheckedChanged: {
        if ( textButton.checked ) {
            tool = "text";
        }
    }
    imageButton.onCheckedChanged: {
        if ( imageButton.checked ) {
            tool = "image";
        }
    }
    drawButton.onCheckedChanged: {
        if ( drawButton.checked ) {
            tool = "draw";
        }
    }
    selectButton.onCheckedChanged: {
        if ( selectButton.checked ) {
            tool = "select";
        }
    }
    deleteButton.onCheckedChanged: {
        if ( deleteButton.checked ) {
            tool = "delete";
        }
    }

    Drawing {
        id: drawing
        anchors.fill: parent
    }

    ColourChooser {
        id: colourChooser
        width: 240
        height: 240
        anchors.right: parent.right;
        anchors.top: parent.top;
        enabled: true;
        onColourChanged: {
            drawColour = colour;
        }
    }

    FontChooser {
        id: fontChooser
        width: 240
        height: 240
        anchors.left: parent.left;
        anchors.top: parent.top;
        enabled: true;
        onFontChanged: {
            textFont = font;
            textColour = colour;
        }
    }

    Puck {
        id: puck
        onPerformAction: {
            console.log( "puck action" + JSON.stringify(action) );
        }
    }


    property var tool: "draw"
    //
    //
    //
    property var drawColour: colourChooser.getColour();
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
    function createSketchItem(source,posn) {
        console.log( 'loading component' );
        component = Qt.createComponent(source);
        componentPosition = {
            x : posn.x,
            y : posn.y
        }
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
        if (component.status == Component.Ready) {
            var item = component.createObject(sketch);
            if (item !== null) {
                item.x = componentPosition.x - ( item.width / 2 );
                item.y = componentPosition.y - ( item.height / 2 );
                item.state = "edit"
            } else {
                // Error Handling
                console.log("Error creating object");
            }
        } else if (component.status == Component.Error) {
            // Error Handling
            console.log("Error loading component:", component.errorString());
        }
    }
}
