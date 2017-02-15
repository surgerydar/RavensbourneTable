import QtQuick 2.6
import QtQuick.Controls 2.0
import "../GeometryUtils.js" as GU

Item {
    id: container
    width: 320
    height: 240
    transformOrigin: Item.Center
    antialiasing: true
    //
    //
    //
    property Image propertyToggle: propertyToggle
    property string itemId: ""
    //
    //
    //
    Item {
        id: controls
        anchors.fill: parent
        Image {
            id: move
            width: 46
            height: 46
            anchors.top: parent.top
            anchors.left: parent.left
            source: "../icons/move-black.png"
            fillMode: Image.PreserveAspectFit
            /*
            Rectangle {
                anchors.fill: parent
                border.color: 'green'
            }
            */
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                drag.target: container
                onClicked : {
                    console.log( 'hello' );
                }
            }
        }

        Image {
            id: rotate
            width: 46
            height: 46
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            source: "../icons/rotate-black.png"
            fillMode: Image.PreserveAspectFit
            /*
            Rectangle {
                anchors.fill: parent
                border.color: 'blue'
            }
            */
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                onPressed : {
                    console.log('rotate pressed [' + mouse.x + ',' + mouse.y + ']')
                    var center = {
                        x: container.x + ( container.width / 2 ),
                        y: container.y + ( container.height / 2 )
                    };
                    var globalCoord = rotate.mapToItem(sketch,mouse.x,mouse.y)
                    container.startAngle = GU.angleBetween(center,globalCoord)
                    container.startRotation = container.rotation
                }
                onReleased : {
                    console.log('rotate released [' + mouse.x + ',' + mouse.y + ']')
                }
                onPositionChanged : {
                    var center = {
                        x: container.x + ( container.width / 2 ),
                        y: container.y + ( container.height / 2 )
                    };
                    var globalCoord = rotate.mapToItem(sketch,mouse.x,mouse.y)
                    var angle = GU.angleBetween(center,globalCoord)
                    console.log( 'start angle=' + container.startAngle + ' current=' + angle);
                    var dAngle = angle - container.startAngle;
                    container.rotation = GU.wrapAngle(container.startRotation,dAngle);

                    console.log( 'rotation=' + container.rotation + ' dAngle=' + dAngle );
                }

            }

        }

        Image {
            id: scale
            width: 46
            height: 46
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            source: "../icons/scale-black.png"
            fillMode: Image.PreserveAspectFit
            /*
            Rectangle {
                anchors.fill: parent
                border.color: 'red'
            }
            */
            MouseArea {
                anchors.fill: parent
                preventStealing: true
                onPressed : {
                    console.log('scale pressed [' + mouse.x + ',' + mouse.y + ']')
                     var globalCoord = scale.mapToItem(sketch,mouse.x,mouse.y)
                    startScaling(globalCoord);
                 }
                onReleased : {
                    console.log('scale released [' + mouse.x + ',' + mouse.y + ']')
                }
                onPositionChanged : {
                    var globalCoord = scale.mapToItem(sketch,mouse.x,mouse.y)
                    updateScaling(globalCoord)
                }

            }

        }

        Image {
            id: propertyToggle
            width: 46
            height: 46
            anchors.top: parent.top
            anchors.right: parent.right
            source: "../icons/puck-black.png"
            fillMode: Image.PreserveAspectFit
            /*
            Rectangle {
                anchors.fill: parent
                border.color: 'green'
            }
            */
            MouseArea {
                anchors.fill: parent
                preventStealing: true

                onClicked: {
                    if( showPropertyEditor ) showPropertyEditor(); // defined in subcalsses
                }

            }
        }
    }

    Rectangle {
        id: lockIndicator
        anchors.fill: parent
        anchors.margins: 23
        radius: 8
        color: "transparent"
        border.width: 4
        border.color: "red"
        visible: false
    }

    //
    //
    //
    state: "display"
    states: [
        State {
            name: "edit"
            PropertyChanges {
                target: lockIndicator
                visible: false
            }
            PropertyChanges {
                target: controls;
                visible: true
            }
            PropertyChanges {
                target: editor;
                visible: true
            }
            PropertyChanges {
                target: content;
                visible: false
            }
            PropertyChanges {
                target: container
                z: 1
            }
        },
        State {
            name: "display"
            PropertyChanges {
                target: lockIndicator
                visible: false
            }
            PropertyChanges {
                target: controls;
                visible: false
            }
            PropertyChanges {
                target: editor;
                visible: false
            }
            PropertyChanges {
                target: content;
                visible: true
            }
            PropertyChanges {
                target: container
                z: 0
            }
        },
        State {
            name: "locked"
            PropertyChanges {
                target: lockIndicator
                visible: true
            }
            PropertyChanges {
                target: controls;
                visible: false
            }
            PropertyChanges {
                target: editor;
                visible: false
            }
            PropertyChanges {
                target: content;
                visible: true
            }
            PropertyChanges {
                target: container
                z: 0
            }
        }
    ]
    //
    // TODO: move all this into rotating params
    //
    property var startAngle: 0
    property var startRotation: 0

    property var scalingParams: undefined;

    function startScaling( mp ) {
        //
        // get left and bottom
        //
        var p0 = GU.point( container.x + container.width, container.y + container.height );
        var p1 = GU.point( container.x + container.width, container.y );
        var p2 = GU.point( container.x, container.y + container.height );
        var cp = GU.point( container.x + container.width / 2, container.y + container.height / 2 );
        var left = GU.line( p0, p1 );
        var bottom = GU.line( p0, p2 );
        //
        // rotate left and bottom
        //
        left = GU.rotateLine(cp,left,container.rotation);
        bottom = GU.rotateLine(cp,bottom,container.rotation);
        //
        // find closest point
        //
        var positionLeft = GU.positionOnLine(left,mp);
        var positionBottom = GU.positionOnLine(bottom,mp);
        //
        // store values for update
        //
        container.scalingParams = {
            x: container.x,
            y: container.y,
            width: container.width,
            height: container.height,
            left: left,
            bottom: bottom,
            positionLeft: positionLeft,
            positionBottom: positionBottom
        }
    }

    function updateScaling( mp ) {
        //
        // find closest point
        //
        var positionLeft = GU.positionOnLine(container.scalingParams.left,mp);
        var positionBottom = GU.positionOnLine(container.scalingParams.bottom,mp);
        //
        //
        //
        var dWidth = ( container.scalingParams.positionBottom - positionBottom ) * container.scalingParams.width;
        var dHeight = ( container.scalingParams.positionLeft - positionLeft ) * container.scalingParams.height;

        container.width = container.scalingParams.width + dWidth * 1.5;
        container.height = container.scalingParams.height + dHeight * 1.5;
        container.x = container.scalingParams.x + ( -1 * ( dWidth / 2 ) );
        container.y = container.scalingParams.y + ( -1 * ( dHeight / 2 ) );
    }

    function getGeometry() {
        return {
            x: container.x,
            y: container.y,
            width: container.width,
            height: container.height,
            rotation: container.rotation,
            itemid: container.itemId
        };
    }

    function setGeometry(param) {
        container.x = param.x;
        container.y = param.y;
        container.width = param.width;
        container.height = param.height;
        container.rotation = param.rotation;
        container.itemId = param.itemid || GUIDGenerator.generate();
        console.log( 'restoring item : ' + param.itemid + ' with id : ' + container.itemId);
    }
    //
    //
    //
    signal itemDestroyed();
    Component.onDestruction: {
        itemDestroyed();
    }
}
