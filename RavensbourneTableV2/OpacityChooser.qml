import QtQuick 2.7
import QtGraphicalEffects 1.0

Rectangle {
    width: 144
    height: 46
    radius: height /2.
    clip: true
    LinearGradient {
        anchors.fill: parent
        source: parent
        start: Qt.point(0,0)
        end: Qt.point(parent.width,0)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(255,255,255,255) }
            GradientStop { position: 1.0; color: Qt.rgba(255,255,255,0) }
        }
    }
    MouseArea {
        anchors.fill: parent
        onPressed: {
            parent.parent.parent.interactive = false;
            opacityChanged( opacityFromPosition(mouse.x,mouse.y) );
        }
        onPositionChanged: {
            opacityChanged( opacityFromPosition(mouse.x,mouse.y) );
        }
        onReleased: {
            parent.parent.parent.interactive = true;

        }
        //
        //
        //
        function opacityFromPosition( x, y ) {
            return x / width;
        }
    }
    //
    //
    //
    signal opacityChanged( real opacity )
}
