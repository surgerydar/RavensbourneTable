import QtQuick 2.4

SketchForm {
    sketch.onPressed: {
        console.log('pressed [' + mouse.x + ',' + mouse.y + ']');
    }

    sketch.onReleased: {
        console.log('released [' + mouse.x + ',' + mouse.y + ']');
    }

    sketch.onPositionChanged: {
        console.log('moved [' + mouse.x + ',' + mouse.y + ']');
    }

    sketch.onClicked: {
        if ( tool !== "draw" ) {
            var source = tool === "image" ? "ImageItem.qml" : "TextItem.qml";
            createSketchItem(source, { x: mouse.x, y: mouse.y } );
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

    Puck {
        id: puck
        onPerformAction: {
            console.log( "puck action" + JSON.stringify(action) );
        }
    }

    /*
    Canvas {
        id:canvas
        anchors.fill: parent;
        property color strokeStyle:  Qt.darker(fillStyle, 1.4)
        property color fillStyle: "#b40000" // red
        property int lineWidth: 2
        property bool fill: true
        property bool stroke: true
        property real alpha: 1.0
        antialiasing: true

        onPaint: {
            var ctx = canvas.getContext('2d');
            var originX = 85
            var originY = 75
            ctx.save();
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.translate(originX, originX);
            ctx.globalAlpha = canvas.alpha;
            ctx.strokeStyle = canvas.strokeStyle;
            ctx.fillStyle = canvas.fillStyle;
            ctx.lineWidth = canvas.lineWidth;

            ctx.translate(originX, originY)
            ctx.scale(canvas.scale, canvas.scale);
            ctx.rotate(canvas.rotate);
            ctx.translate(-originX, -originY)

            //! [0]
            ctx.beginPath();
            ctx.moveTo(75,40);
            ctx.bezierCurveTo(75,37,70,25,50,25);
            ctx.bezierCurveTo(20,25,20,62.5,20,62.5);
            ctx.bezierCurveTo(20,80,40,102,75,120);
            ctx.bezierCurveTo(110,102,130,80,130,62.5);
            ctx.bezierCurveTo(130,62.5,130,25,100,25);
            ctx.bezierCurveTo(85,25,75,37,75,40);
            ctx.closePath();
            //! [0]
            if (canvas.fill)
                ctx.fill();
            if (canvas.stroke)
                ctx.stroke();
            ctx.restore();
        }
    }
    */
    property var tool: "draw"
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
