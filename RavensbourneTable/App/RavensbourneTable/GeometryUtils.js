function point( x, y ) {
    return {
        x : x, y : y
    }
}

function line( a, b ) {
    return {
        a : a, b : b
    }
}

function dot( a, b ) {
    return a.x * b.x + a.y * b.y
}

function cross( a, b ) {
    return undefined
}

function add( a, b ) {
    if ( isNaN(b) ) {
        return {
            x : a.x + b.x,
            y : a.y + b.y
        }
    } else {
        return {
            x : a.x + b,
            y : a.y + b
        }
     }
}

function subtract( a, b ) {
    if ( isNaN(b) ) {
        return {
            x : a.x - b.x,
            y : a.y - b.y
        }
    } else {
        return {
            x : a.x - b,
            y : a.y - b
        }
    }
}

function product( a, b ) {
    if ( isNaN(b) ) {
        return {
            x : a.x * b.x,
            y : a.y * b.y
        }
    } else {
        return {
            x : a.x * b,
            y : a.y * b
        }
    }
}

function distance( a, b ) {
    var d = subtract( a, b );
    return Math.sqrt( d.x * d.x + d.y * d.y )
}

function length( a ) {
    return Math.sqrt( a.x * a.x + a.y * a.y )
}

function distanceSquared( a, b ) {
    var d = subtract( a, b );
    return d.x * d.x + d.y * d.y
}

function wrapAngle( a, d ) {
    var ar = a + d;
    if ( ar > 360 ) {
        ar = ar - 360;
    } else if ( ar < 0 ) {
        ar = 360 + ar;
    }
    return ar;
}

function angleBetween( c, p ) {
    var d = point(p.x - c.x,p.y - c.y);
    var deg = radToDeg(Math.atan(d.x / d.y));
    if (d.x > 0 && d.y > 0) {
        console.log( 'seg 1:' + deg );
        deg = 90 - Math.abs (deg);
    } else if (d.x > 0 && d.y < 0) {
        console.log( 'seg 4 :' + deg );
        deg = 270 + Math.abs (deg);
    } else if (d.x < 0 && d.y > 0) {
        console.log( 'seg 2:' + deg );
        deg = 90 + Math.abs (deg);
    } else if (d.x < 0 && d.y < 0) {
        console.log( 'seg 3:' + deg );
        deg = 270 - Math.abs (deg);
    }
    return deg;
}

function radToDeg( rad ) {
    return (rad * 180 / Math.PI);
}

function degToRad( deg ) {
    return deg * Math.PI / 180;
}

function rotatePoint( c, p, deg ) {
    var rad = degToRad(deg);
    var pr = point(p.x-c.x,p.y-c.y);

    return point(
        ( pr.x * Math.cos(rad) - pr.y * Math.sin(rad) ) + c.x,
        ( pr.y * Math.cos(rad) + pr.x * Math.sin(rad) ) + c.y
    );
}

function rotateLine( c, l, deg ) {
    return {
        a : rotatePoint( c, l.a, deg ),
        b : rotatePoint( c, l.b, deg )
    }
}

function positionOnLine( line, point, clip ) {
    var ap = subtract( point, line.a );
    var ab = subtract( line.b, line.a );

    var len = distanceSquared(line.b, line.a);
    var product = dot(ap, ab);
    var dist = product / len;

    if ( clip ) {
        return Math.max( 0, Math.min( 1, dist ) );
    }
    return dist;
}

function closestPoint( line, point, clip ) {
    return add( line.a, product( ab, positionOnLine( line, point, clip ) ) );
}
