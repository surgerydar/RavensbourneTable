import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
    id: container
    clip: true
    //
    //
    //
    property alias radius: background.radius
    property alias prompt: model.text
    property alias background: background.color
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
        offset: 0.
        pathItemCount: width / metrics.averageCharacterWidth;
        path: Path {
            startX: 0; startY: list.height / 2
            PathLine { x: list.width; y: list.height / 2 }
        }
        model: model
        delegate: Label {
            width: metrics.advanceWidth(model.letter)
            //height: metrics.tightBoundingRect(model.letter).height
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
            for ( var i = 0; i < count; i++ ) {
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

