import QtQuick 2.7
import "GeometryUtils.js" as GU

Rectangle {
    id: container
    width: 256
    height: 256
    color: "transparent"
    border.width: 2
    border.color: "transparent"
    //
    //
    //
    property var itemId: null
    property var storedState: null
    property bool selected: false
    property bool locked: false
    //
    //
    //
    signal transformChanged
    signal pressed( Item item )
    signal released( Item item )
    signal doubleClicked( Item item )
    signal pressAndHold( Item item )
    signal editItem( Item item )
    signal deleteItem( Item item )
    signal showInfo( Item item )
    //
    //
    //
    signal beginTransform( Item item )
    signal endTransform( Item item )
    //
    //
    //
    Image {
        anchors.right: parent.left
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: -8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -8
        source: "icons/selection-brace.svg"
        //fillMode: Image.
        visible: selected
        onStatusChanged: {
            if ( status === Image.Error ) {
                source = "icons/selection-brace.png"
            }
        }
    }
    Image {
        anchors.left: parent.right
        anchors.leftMargin: 8
        anchors.top: parent.top
        anchors.topMargin: -8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -8
        source: "icons/selection-brace.svg"
        //fillMode: Image.PreserveAspectFit
        mirror: true
        visible: selected
        onStatusChanged: {
            if ( status === Image.Error ) {
                source = "icons/selection-brace.png"
            }
        }
    }
    //
    // lock indicator
    //
    Rectangle {
        z: 1
        width: 46
        height: 46
        radius: height / 2.
        anchors.centerIn: parent
        color: "#FF6666"
        visible: locked
        Image {
            width: 38
            height: 38
            anchors.centerIn: parent
            source: "icons/lock-black.png"
            fillMode: Image.PreserveAspectFit
        }
    }
    //
    //
    //
    PinchArea {
        anchors.fill: parent
        //pinch.target: container
        pinch.minimumRotation: -360
        pinch.maximumRotation: 360
        pinch.minimumScale: 0.1
        pinch.maximumScale: 10
        pinch.dragAxis: Pinch.XAndYAxis
        property var previousCenter: null
        onPinchStarted: {
            if ( locked ) return;
            //select();
            previousCenter = null;
            beginTransform( container );
        }
        onPinchUpdated: {
            if ( locked ) return;
            var cp = container.mapToItem(container.parent,pinch.center.x,pinch.center.y);
            if ( previousCenter ) {
                container.x += cp.x - previousCenter.x;
                container.y += cp.y - previousCenter.y;
            }
            previousCenter = cp;
            container.scale += pinch.scale - pinch.previousScale;
            container.rotation -= pinch.angle - pinch.previousAngle;
        }
        onPinchFinished: {
            if ( locked ) return;
            previousCenter = null;
            //deselect();
            transformChanged();
            endTransform( container );
        }
        //
        //
        //
        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: container
            property bool blockRelease: false
            onPressed: {
                if ( locked ) return;
                container.pressed(container);
                beginTransform( container );
                blockRelease = false;
            }
            onReleased: {
                if ( locked ) return;
                if ( !blockRelease ) { // TODO: fudge, find better way
                    container.released(container);
                    transformChanged();
                    endTransform( container );
                }
                blockRelease = false;
            }
            onDoubleClicked: {
                if ( locked ) return;
                container.doubleClicked(container);
            }
            onPressAndHold: {
                if ( locked ) return;
                blockRelease = true;
                container.pressAndHold(container);
            }
        }
    }
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
            scale: container.scale,
            itemid: container.itemId
        };
    }
    function setGeometry(param) {
        container.x = param.x || parent.width / 2;
        container.y = param.y || parent.height / 2;
        container.width = param.width || 256;
        container.height = param.height || 256;
        container.rotation = param.rotation || 0;
        container.scale = param.scale || 1;
        container.itemId = param.itemid || GUIDGenerator.generate();
    }
    //
    //
    //
    function adjustAspectRatio( w, h ) {
        var hscale = width / w;
        var vscale = height / h;
        if ( hscale < vscale ) {
            height = h * hscale;
        } else {
            width = w * vscale;
        }
    }
    function getTransformedBounds() {
        return mapToItem(parent,0,0,width,height);
    }
    function moveBy( by ) {
        container.x += by.x;
        container.y += by.y;
    }
}
