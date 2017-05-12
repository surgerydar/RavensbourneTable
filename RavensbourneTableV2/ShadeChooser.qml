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
            GradientStop { position: 0.0; color: "black" }
            GradientStop { position: 1.0; color: "white" }
        }
    }
    MouseArea {
        anchors.fill: parent
        onPressed: {
            parent.parent.parent.interactive = false;
            parent.positionChanged(mouse.x,mouse.y);
            colourChanged( shadeFromPosition(mouse.x,mouse.y) );
        }
        onPositionChanged: {
            parent.positionChanged(mouse.x,mouse.y);
            colourChanged( shadeFromPosition(mouse.x,mouse.y) );
        }
        onReleased: {
            parent.parent.parent.interactive = true;

        }
        //
        //
        //
        function shadeFromPosition( x, y ) {
            var l = x / width;
            return Qt.hsla( 0,0,l, 1.);
        }
    }
    //
    //
    //
    signal colourChanged( color colour )
    signal positionChanged( real x, real y)
}
