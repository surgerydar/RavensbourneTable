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
        color: "gray" // export
    }
    //
    // menu item delegate
    //
    Component {
        id: delegate
        Rectangle {
            id: wrapper
            width: 64;
            height: 64;
            radius: 32;
            color: "gray"
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
                    //
                    // TODO: interpret action
                    //
                    /*
                    if ( action ) {
                        container.performAction(action);
                    }
                    */
                }
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
            drag.maximumX: appWindow.width - container.width;
            drag.minimumY: 0;
            drag.maximumY: appWindow.height - container.height;
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
            }
            onReleased: {
                if ( mode == "flick" ) {

                }
            }

            onPositionChanged: {
                var dx = mouse.x - previousX
                var dy = mouse.y - previousY
                var velocity = Math.sqrt(dx*dx+dy*dy)
                if ( velocity > 20 ) {
                    mode = "flick"
                } else {
                    mode = "drag"
                }
            }
        }
    }
    Behavior on x { enabled: container.animated; SpringAnimation { spring: 3; damping: 0.3; mass: 1.0 } }
    Behavior on y { enabled: container.animated; SpringAnimation { spring: 3; damping: 0.3; mass: 1.0 } }}
