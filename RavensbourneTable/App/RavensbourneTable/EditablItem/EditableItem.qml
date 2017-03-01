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
    property string type: "unknown"
    //
    //
    //
    property Image propertyToggle: propertyToggle
    property string itemId: ""
    //
    //
    //

    Rectangle {
        anchors.fill: parent
        color: "green"
        opacity: 0.5
    }

    //
    //
    //
    Item {
        id: controls
        anchors.fill: parent
        Rectangle {
            id: commit
            width: 46
            height: 46
            anchors.top: parent.bottom
            anchors.left: parent.left
            Image {
                anchors.fill: parent
                source: "../icons/done-black.png"
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log('EditableItem.commit clicked');
                        commitEditing();
                        setActiveEditor();
                    }
                }
            }
        }
        Rectangle {
            id: cancel;
            width: 46
            height: 46
            anchors.top: parent.bottom
            anchors.left: commit.right
            anchors.leftMargin: 8
            Image {
                anchors.fill: parent
                source: "../icons/close-black.png"
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log('EditableItem.cancel clicked');
                        cancelEditing();
                        setActiveEditor();
                    }
                }
            }
        }
    }
    //
    //
    //
    MultiPointTouchArea {
        id: multiTouchArea
        anchors.fill: parent
        mouseEnabled: true
        maximumTouchPoints: 2

        property string mode: 'none'
        property real startRotation: container.rotation
        property real startWidth: container.width
        property real startHeight: container.height
        property real startAngle: 0
        property real startDistance: 0
        property real startX: container.x + container.width / 2.;
        property real startY: container.y + container.height / 2.;
        property string scaleMode: "both"

        onGestureStarted: {
            gesture.grab();
        }

        onTouchUpdated : {

        }

        onUpdated: {
            var mp, sp, md, ma, sd, sa, da, s;
            if ( TouchUtilities.hasTouchScreen() ) {
                //
                // handle multipoint
                //
                if ( mode === 'pinch' ) {
                    var p0 = GU.point(touchPoints[ 0 ].x, touchPoints[ 0 ].y);
                    var p1 = GU.point(touchPoints[ 1 ].x, touchPoints[ 1 ].y);
                    var sp0 = GU.point(touchPoints[ 0 ].startX, touchPoints[ 0 ].startY);
                    var sp1 = GU.point(touchPoints[ 1 ].startX, touchPoints[ 1 ].startY);
                    sd = GU.distance( sp0, sp1 );
                    sa = GU.angleBetween( sp0, sp1 );
                    md = GU.distance( p0, p1 );
                    ma = GU.angleBetween( p0, p1 );
                    da = ma - sa;
                    s = ma / sa;
                } else {
                     mp = container.mapToItem(sketch,touchPoints[ 0 ].x, touchPoints[ 0 ].y);
                }
            } else {
                var cp = GU.point( container.x + container.width / 2, container.y + container.height / 2 );
                mp = container.mapToItem(sketch,touchPoints[ 0 ].x, touchPoints[ 0 ].y);
                //sp = GU.point(touchPoints[ 0 ].startX, touchPoints[ 0 ].startY);
                md = GU.distance( cp, mp );
                ma = GU.angleBetween( cp, mp );
                //sd = GU.distance( cp, sp );
                //sa = GU.angleBetween( cp, sp );
                da = ma - startAngle;
                s = md / startDistance;
                console.log( 'start angle=' + startAngle + ' current=' + ma);
                console.log( 'start distance=' + startDistance + ' current=' + md);
                console.log( 'touch [' + touchPoints[ 0 ].x + ',' + touchPoints[ 0 ].y +  ']')
                console.log( 'mp [' + mp.x + ',' + mp.y +  ']');
                console.log( 'da=' + da + ' s=' + s );
            }
            switch( mode ) {
            case 'pan' :
                container.x = mp.x - container.width / 2;
                container.y = mp.y - container.height / 2;
                editTimer.restart();
                break;
            case 'pinch' :
                container.rotation = GU.wrapAngle(startRotation,da);
                if ( scaleMode === "scalex" || scaleMode === "both" ) {
                    container.width = startWidth * s;
                }
                if ( scaleMode === "scaley" || scaleMode === "both" ) {
                    container.height = startHeight * s;
                }
                container.x = startX - container.width / 2;
                container.y = startY - container.height / 2;
                break;
            }
        }

        onPressed: {
            startRotation = container.rotation;
            startWidth = container.width;
            startHeight = container.height;
            startX = container.x + container.width / 2.;
            startY = container.y + container.height / 2.;
            if ( TouchUtilities.hasTouchScreen() ) {
                //
                // handle multipoint
                //
                mode = touchPoints.length > 1 ? 'pan' : 'pinch';
                var p0 = GU.point(touchPoints[ 0 ].x, touchPoints[ 0 ].y);
                var p1 = GU.point(touchPoints[ 1 ].x, touchPoints[ 1 ].y);
                startAngle = GU.angleBetween( p0, p1 );
            } else {
                var cp = GU.point( container.x + container.width / 2, container.y + container.height / 2 );
                var gp = container.mapToItem(sketch,touchPoints[ 0 ].x, touchPoints[ 0 ].y);
                var mp = GU.point(gp.x, gp.y);
                var d = GU.distance( cp, mp );
                var dx = Math.abs( mp.x - cp.x );
                var dy = Math.abs( mp.y - cp.y );
                mode = dx < width / 4 && dy < height / 4 ? 'pan' : 'pinch'; // TODO: this should be closer to edge or closer to center
                startDistance = d;
                startAngle = GU.angleBetween(cp,mp);
                console.log( 'd=' + d );
            }
            console.log( 'mode=' + mode );
            if ( mode === 'pan' ) {
                //
                // start double click timer
                //
                editTimer.restart();
            } else {
                if ( startAngle > 340 || startAngle < 20 || ( startAngle > 160 && startAngle < 200 ) ) {
                    scaleMode = "scalex";
                } else if ( ( startAngle > 70 && startAngle < 110 ) || ( startAngle > 250 && startAngle < 290 ) ) {
                    scaleMode = "scaley";
                } else {
                    scaleMode = "both";
                }
                editTimer.stop();
            }
        }

        onReleased: {
            mode = 'none';
            editTimer.stop();
            commitEditing();
        }
    }

    Timer {
        id: editTimer
        interval: 500
        onTriggered: {
            console.log('edit timer fired fpr type : ' + type);
            setActiveEditor(container,type);
            startEditing();
        }
    }

    Rectangle {
        id: lockIndicator
        width: 48
        height: 48
        anchors.centerIn: parent
        visible: false
        radius: width / 2
        color: "#FF6666"
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "../icons/lock-white.png"
        }
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
                z: 0
            }
            PropertyChanges {
                target: controls;
                visible: true
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
                z: 0
            }
            PropertyChanges {
                target: controls;
                visible: false
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
                z: 1
            }
            PropertyChanges {
                target: controls;
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
    //
    //
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
        //console.log( 'restoring item : ' + param.itemid + ' with id : ' + container.itemId);
    }
    //
    //
    //
    function enableEditing() {
        multiTouchArea.enabled = true;
    }

    function diableEditing() {
        multiTouchArea.enabled = false;
    }
    //
    //
    //
    signal itemDestroyed();
    Component.onDestruction: {
        itemDestroyed();
    }
}
