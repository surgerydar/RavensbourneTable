import QtQuick 2.0

Rectangle {
    id: container
    x: 120
    y: 120
    z: 2
    width: 324
    height: 324
    color: "transparent"
    //
    // exported properties
    //
    property alias menu: menu
    //
    // methods
    //
    function setModel( model ) {
        menu.model = model;
    }
    //
    // signals
    //
    signal performAction( string action )
    //
    // background
    //
    Rectangle {
        anchors.centerIn: parent;
        width: 240
        height: 240
        radius: 120
        color: colourTurquoise
    }
    //
    // menu item delegate
    //
    Component {
        id: delegate
        //property string action: action
        Rectangle {
            id: wrapper
            width: 64;
            height: 64;
            radius: 32;
            color: colourTurquoise
            border.color: "transparent"
            rotation: PathView.itemRotation
            Image {
                anchors.fill: parent
                anchors.margins: 8
                anchors.centerIn: parent
                transformOrigin: Item.Center
                source: icon
                fillMode: Image.PreserveAspectFit
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    //
                    // TODO: action, show submenu or set mode
                    //
                    var view = parent.PathView.view;
                    for(var i = 0; i < view.children.length; ++i) {
                          if(view.children[i] === parent ){
                            console.log(i + " is current item")
                            view.children[i].state = "selected";
                          } else {
                            view.children[i].state = "";
                          }
                    }
                    console.log( 'puck action : ' + action );
                    container.action(action);
                }
            }
            function getAction() {
                return action;
            }

            Behavior on width {
                NumberAnimation {
                    id: bouncebehavior
                    easing.type:  Easing.OutElastic
                    duration: 500
                }
            }
            Behavior on height {
                animation: bouncebehavior
            }
            Behavior on radius {
                animation: bouncebehavior
            }

            states: [
                State {
                    name: "selected"
                    PropertyChanges {
                        target: wrapper;
                        width: 84
                    }
                    PropertyChanges {
                        target: wrapper;
                        height: 84
                    }
                    PropertyChanges {
                        target: wrapper;
                        radius: 42
                    }
                    PropertyChanges {
                        target: wrapper;
                        border.color: "white"
                        border.width: 4
                    }
                }
             ]
        }
     }
    //
    // menu
    //
    PathView {
        id: menu
        //anchors.margins: 42
        //anchors.fill: parent
        anchors.centerIn: parent
        width: 240
        height: 240
        model: MenuModel {}
        delegate: delegate
        dragMargin: 32
        transformOrigin: Item.Center
        path: Path {
            startX: 120; startY: 0
            PathAttribute { name: "itemRotation"; value: -180 }
            PathArc {
                   x: 120; y: 240
                   radiusX: 120; radiusY: 120
                   useLargeArc: true
            }
            PathAttribute { name: "itemRotation"; value: 0 }
            PathArc {
                   x: 120; y: 0
                   radiusX: 120; radiusY: 120
                   useLargeArc: true
            }
            PathAttribute { name: "itemRotation"; value: 180 }
        }
    }
    //
    //
    //
    Image {
        anchors.centerIn: parent
        source: 'icons/move.png'
        MouseArea {
            anchors.fill: parent
            preventStealing: true
            drag.target: container
            drag.minimumX: 0;
            drag.maximumX: container.parent.width - container.width;
            drag.minimumY: 0;
            drag.maximumY: container.parent.height - container.height;
            //
            //
            //
            property int previousX
            property int previousY
            property string mode: "drag"
            onPressed: {
                mode = "drag"
                previousX = mouse.x
                previousY = mouse.y
                flickAnimation.stop()
                previousTime = new Date().getTime()
            }
            onReleased: {
                if ( mode == "flick" ) {
                    previousTime = new Date().getTime()
                    flickAnimation.start()
                }
            }

            onPositionChanged: {
                var currentTime = new Date().getTime()
                frameTime = currentTime - previousTime
                previousTime = currentTime
                vX = mouse.x - previousX
                vY = mouse.y - previousY
                previousX = mouse.x
                previousY = mouse.y
                var velocity = Math.sqrt(vX*vX+vY*vY)
                //console.log( 'velocity=' + velocity )
                if ( velocity > 5 ) {
                    mode = "flick"
                } else {
                    mode = "drag"
                }
            }
        }
    }
    //
    // flick animation
    //
    property real vX: 0
    property real vY: 0
    property real friction: 0.9
    property int previousTime: 0
    property real frameTime: 0
    Timer {
        id: flickAnimation
        interval: 16
        repeat: true
        running: false
        onTriggered: {
            var currentTime = new Date().getTime()
            var elapsed = currentTime - previousTime
            previousTime = currentTime
            var factor = elapsed / frameTime
            parent.x += vX * factor
            parent.y += vY * factor
            vX *= friction;
            vY *= friction;
            if ( parent.x < 0 ) {
                parent.x = 0
                vX *= -1;
            } else if ( parent.x + parent.width > parent.parent.width ) {
                parent.x = parent.parent.width - parent.width
                vX *= -1;
            }
            if ( parent.y <= 0 ) {
                parent.y = 0
                vY *= -1;
            } else if ( parent.y + parent.height >= parent.parent.height ) {
                parent.y = parent.parent.height - parent.height
                vY *= -1;
            }
            var velocity = Math.sqrt(vX*vX+vY*vY)
            if ( velocity <=  1 ) {
                stop();
            }
            //console.log( 'vX=' + vX + ' vY=' + vY + ' factor=' + factor + ' frameTime=' + frameTime + ' elapsed=' + elapsed )
        }
    }
    //
    //
    //
    function reset() {
        var view = menu;
        if ( view ) {
            var count = view.children.length;
            for(var i = 0; i < count; ++i) {
                view.children[i].state = "";
            }
        } else {
            console.log('unable to reset puck, no view');
        }
    }
    function selectTool( tool ) {
        var view = menu;
        if ( view ) {
            console.log( 'setting puck tool' );
            var count = view.children.length;
            for(var i = 0; i < count; ++i) {
                console.log( 'puck tool : ' + view.children[i].getAction );
                if ( view.children[i].getAction ) {
                    view.children[i].state = view.children[i].getAction() === tool ? "selected" : "";
                }
            }
        } else {
            console.log('unable to set puck tool, no view');
        }

    }
    //
    // signals
    //
    signal action( string action );
}
