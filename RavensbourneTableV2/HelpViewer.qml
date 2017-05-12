import QtQuick 2.7
import QtWebEngine 1.4
import QtQuick.Controls 2.0

Editor {
    id: container
    //
    //
    //
    WebEngineView {
        id: webBrowser
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 64
        anchors.bottomMargin: 64
        backgroundColor: "transparent"
        onNewViewRequested: function(request) { // open all in same pane TODO: tabs
            request.openIn(webBrowser);
        }
        onLoadingChanged: {
            switch( loadRequest.status ) {
            case WebEngineView.LoadStartedStatus :
                busyIndicator.visible = true;
                break;
            case WebEngineView.LoadStoppedStatus :
            case WebEngineView.LoadFailedStatus :
                busyIndicator.visible = false;
                break;
            case WebEngineView.LoadSucceededStatus :
                busyIndicator.visible = false;
            }
        }
    }
    //
    // close button
    //
    StandardButton {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8
        icon: "icons/close-black.png"
        onClicked : {
            hide();
        }
    }
    //
    //
    //
    AnimatedImage {
        id: busyIndicator
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        source:"icons/spinner.gif"
    }
    //
    //
    //
    function show(page) {
        var url = "http://178.62.110.55:3000/help";
        if ( page ) url += page + ".html";
        webBrowser.url = url;
        state = "open";
    }
    function hide() {
        state = "closed";
        //
        // hide current page
        //
        webBrowser.url = "blank.html";
    }
}
