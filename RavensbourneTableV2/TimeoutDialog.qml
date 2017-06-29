import QtQuick 2.0
import QtQuick.Controls 2.0

RotatableDialog {
    //
    // geometry
    //
    width: parent.width / 4
    height: parent.width / 4
    anchors.centerIn: parent
    visible: false
    opacity: 1.0
    colour: colourRed
    //
    // properties
    //
    property var callback: null
    property int countdown: 0
    //
    // layout
    //
    Text {
        id: prompt;
        width: Math.sqrt( (parent.width*parent.width) / 2. )
        height: 64
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.family: ravensbourneBold.name
        font.pixelSize: 32
        fontSizeMode: Text.Fit
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }

    TextButton {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: prompt.bottom
        anchors.topMargin: 16
        text: 'Yes'
        onClicked: {
            hide();
        }
    }

    Timer {
        id: timeoutTimer
        interval: 1000 // 2 second
        repeat: true
        onTriggered: {
            if ( --countdown <= 0 ) {
                if ( callback ) {
                    callback();
                    hide();
                }
            } else {
                updatePrompt();
            }
        }
    }
    //
    // functions
    //
    function show(timeoutCallback) {
        callback = timeoutCallback;
        countdown = 30;
        updatePrompt();
        timeoutTimer.start();
        visible = true;
    }

    function hide() {
        timeoutTimer.stop();
        visible = false;
    }

    function updatePrompt() {
        prompt.text = 'Closing in ' + countdown + ' seconds, do you want to continue?'
    }
}
