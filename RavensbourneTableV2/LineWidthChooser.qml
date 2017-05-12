import QtQuick 2.7

Image {
    width: 138
    height: 46
    source: "icons/line-width.png"
    fillMode: Image.PreserveAspectFit
    //
    //
    //
    property real minWidth: 4.
    property real maxWidth: 24.
    //
    //
    //
    MouseArea {
        anchors.fill: parent
        onPressed: {
            parent.parent.parent.interactive = false;
            lineWidthChanged( lineWidthFromPosition(mouse.x,mouse.y) );
        }
        onPositionChanged: {
            lineWidthChanged( lineWidthFromPosition(mouse.x,mouse.y) );
        }
        onReleased: {
            parent.parent.parent.interactive = true;

        }
        //
        //
        //
        function lineWidthFromPosition( x, y ) {
            return minWidth + ( maxWidth - minWidth ) * ( x / width );
        }
    }
    //
    //
    //
    signal lineWidthChanged( real lineWidth )
}
