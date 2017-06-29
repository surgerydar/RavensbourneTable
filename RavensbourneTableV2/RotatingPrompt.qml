import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
    id: container
    clip: true
    width: radius
    height: radius
    //
    //
    //
    property alias prompt: model.text
    property alias background: background.color
    property real radius: parent.height / 2
    //
    //
    //
    Rectangle {
        id: background
        anchors.fill: parent
        radius: height / 2
        color: "white"
    }

    FontMetrics {
          id: metrics
          font.family:ravensbourneBold.name
          font.pixelSize: 32
      }

    PathView {
        id: list
        anchors.fill: parent
        anchors.margins: 32
        offset: 0.
        pathItemCount: ( width * Math.PI ) / metrics.averageCharacterWidth;
        path: Path {
            startX: list.width / 2; startY: 0

            PathAttribute { name: "rotation"; value: -180 }
            PathArc {
                   x: list.width / 2
                   y: list.width
                   radiusX: list.width / 2
                   radiusY: list.width / 2
                   useLargeArc: true
                   direction: PathArc.CounterClockwise
            }
            PathAttribute { name: "rotation"; value: 0 }
            PathArc {
                   x: list.width / 2
                   y: 0
                   radiusX: list.width / 2
                   radiusY: list.width / 2
                   useLargeArc: true
                   direction: PathArc.CounterClockwise
            }
            PathAttribute { name: "rotation"; value: 180 }

        }
        model: model
        delegate: Label {
            width: metrics.advanceWidth(model.letter) / 2.
            //height: metrics.tightBoundingRect(model.letter).height
            rotation: PathView.rotation
            text: model.letter
            font.family:ravensbourneBold.name
            font.pixelSize: 32
        }
    }

    ListModel {
        id: model
        //
        //
        //
        property string text: ""
        //
        //
        //
        onTextChanged: {
            reset();
        }
        //
        //
        //
        function reset() {
            clear();
            var count = text.length;
            for ( var i = count - 1; i >= 0 ; i-- ) {
                append( { letter: text.charAt(i) } );
            }
            append( { letter: ' ' } );
        }
    }
    Timer {
        id: animation
        interval: 16
        repeat: true
        running: false
        property real previousTime: 0
        property real frameTime: 25.0
        onTriggered: {
            list.offset += 0.1;
            //if ( list.offset > 1.0 ) list.offset = 0.;
        }
    }
    Component.onCompleted: {
        model.reset();
    }
    function start() {
       animation.start();
    }
    function stop() {
       animation.stop();
    }

}

