import QtQuick 2.0
import "GeometryUtils.js" as GeometryUtils

Rectangle {
    color: "white"
    width: 0
    height: 0
    radius: 0
    visible: true

    property string type : 'blob'
    property real vX: 0
    property real vY: 0

    function setup( param ) {
        if ( param && param.dim ) {
            width = height = param.dim;
        } else {
            width = height = 40 + Math.random() * 120;
        }
        radius = width / 2;
        if ( param && param.x ) {
            x = param.x;
        } else {
            x = Math.random() * ( parent.width - width );
        }

        if ( param && param.y ) {
            y = param.y
        } else {
            y = Math.random() * ( parent.height - height );
        }
        vX = -1 + Math.random() * 2.;
        vY = -1 + Math.random() * 2.;

        if ( width !== height ) {
            var err = new Error();
            console.log('Blob [x:' + x + ', y:' + y + ', width:' + width + ', height:' + height + ']');
            console.log( err.stack );
        }
    }

    function applyForces( other, t ) {
        var r_a = width / 2.;
        var r_b = other.width / 2.;
        var a = { x: x + r_a, y: y + r_a };
        var b = { x: other.x + r_b, y: other.y + r_b };
        var d = GeometryUtils.subtract( a, b );
        var distance = GeometryUtils.length(d);
        var threshold = r_a + r_b;
        if ( distance < threshold ) {
            if ( distance <= 0.0 ) {
                distance = 0.001;
                d.x = -0.001 + Math.random() * 0.002;
                d.y = -0.001 + Math.random() * 0.002;
            }
            var v = { x: vX, y: vY };
            var factor = 1. - ( distance / threshold );
            d.x /= distance; // normalise
            d.y /= distance;
            vX = v.x * ( 1. - factor ) + d.x * factor;
            vY = v.y * ( 1. - factor ) + d.y * factor;
        }
    }

    function update( t ) {
        //
        // update position
        //
        x += vX * t;
        y += vY * t;
        //
        // bounce off parent bounds
        //
        if ( x <= 0 || x + width >= parent.width ) {
            vX *= -1;
            x = Math.max( 1, Math.min( x, parent.width - ( width + 1 ) ) );
        }

        if ( y <= 0 || y + height >= parent.height ) {
            vY *= -1;
            y = Math.max( 1, Math.min( y, parent.height - ( height + 1 ) ) );
        }
        return Math.sqrt(vX*vX+vY*vY);
    }

    function nudge() {
        vX += -.25 + Math.random() * .5;
        vY += -.25 + Math.random() * .5;
    }

    function stop() {
        vX = vY = 0.;
    }
    /*
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
    */
}
