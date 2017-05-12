import QtQuick 2.7
import QtGraphicalEffects 1.0

Rectangle {
    //width: 144
    width: 288
    height: 46
    radius: height /2.
    clip: true
    LinearGradient {
        anchors.fill: parent
        source: parent
        start: Qt.point(0,0)
        end: Qt.point(parent.width,0)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.hsla(0,1.,.5,1.) }
            GradientStop { position: 0.25; color: Qt.hsla(0.25,1.,.5,1.) }
            GradientStop { position: 0.5; color: Qt.hsla(0.5,1.,.5,1.) }
            GradientStop { position: 0.75; color: Qt.hsla(0.75,1.,.5,1.) }
            GradientStop { position: 1.0; color: Qt.hsla(1.,1.,.5,1.) }
        }
    }
    MouseArea {
        anchors.fill: parent
        onPressed: {
            parent.parent.parent.interactive = false;
            parent.positionChanged(mouse.x,mouse.y);
            colourChanged( hslFromPosition(mouse.x,mouse.y) );

        }
        onPositionChanged: {
            parent.positionChanged(mouse.x,mouse.y);
            colourChanged( hslFromPosition(mouse.x,mouse.y) );
        }
        onReleased: {
            parent.parent.parent.interactive = true;
        }
        function hslFromPosition( x, y ) {
            var h = x / width;
            var l = 1. - (y / height);
            return Qt.hsla( h,1.,l, 1.);
        }
    }
    //
    //
    //
    signal colourChanged( color colour )
    signal positionChanged( real x, real y )
}
