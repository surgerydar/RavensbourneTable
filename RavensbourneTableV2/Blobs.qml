import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
    id: container
    //
    //
    //
    property alias count: blobs.model
    //
    // blobs
    //
    Repeater {
        id: blobs
        anchors.fill: parent
        model: 12
        Blob {
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.go('Home');
                    //materialMetadataViewer.show();
                }
            }
        }
    }
    //
    // animation
    //
    Timer {
        id: animation
        interval: 16
        repeat: true
        running: false
        property real previousTime: 0
        property real frameTime: 25.0
        onTriggered: {
            var currentTime = new Date().getTime()
            var elapsed = previousTime > 0 ? currentTime - previousTime : frameTime;
            previousTime = currentTime;
            var factor = elapsed / frameTime;
            var count = blobs.count;
            var energy = 0;
            for ( var i = 0; i < count; i++ ) {
                if ( blobs.itemAt(i).type === 'blob' ) {
                    //
                    // apply forces
                    //
                    for ( var j = 0; j < count; j++ ) {
                        if ( i !== j && blobs.itemAt(j).type === 'blob' ) {
                            blobs.itemAt(i).applyForces( blobs.itemAt(j), factor );
                        }
                    }
                    //
                    // update
                    //
                    energy += blobs.itemAt(i).update(factor);
                }
            }
            if ( energy < count * 0.5 ) {
                for ( i = 0; i < count; i++ ) {
                    if ( blobs.itemAt(i).type === 'blob' ) {
                        blobs.itemAt(i).nudge();
                    }
                }

            }
        }
    }
    //
    //
    //
    function start() {
        animation.start();
    }
    function stop() {
        animation.stop();
    }
    function setup(param) {
        var count = blobs.count;
        for ( var i = 0; i < count; i++ ) {
            blobs.itemAt(i).setup(param);
        }
    }
}
