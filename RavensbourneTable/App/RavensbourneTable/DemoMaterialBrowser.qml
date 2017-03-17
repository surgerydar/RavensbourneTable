import QtQuick 2.0
import QtWebEngine 1.4
import QtQuick.Controls 2.0

Item {
    //
    //
    //
    /*
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "white"
    }
    */

    WebEngineView {
        id: webBrowser
        width: parent.width * .5
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        backgroundColor: "white"
        //
        //
        //
        onNewViewRequested: function(request) { // open all
            request.openIn(webBrowser);
        }
        onLoadingChanged: {
            // default image id "ctl00_phMain_imgMain"
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
                webBrowser.runJavaScript("var _login_bar = document.querySelector('#ctl00_tblHeader'); if ( _login_bar ) _login_bar.style.display='none';");
                break;
            }
        }
    }
    AnimatedImage {
        id: busyIndicator
        width: parent.width / 2
        height: parent.width / 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        source:"icons/spinner.gif"
    }
    //
    // navigation
    //
    Rectangle {
        width: 48
        height: 48
        radius: 24
        anchors.right: rotateLeft.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 16
        color: "white"
        visible: webBrowser.canGoBack
        Image {
            anchors.fill: parent
            source: "icons/back_arrow-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
               webBrowser.goBack();
            }
        }
    }

    Rectangle {
        width: 48
        height: 48
        radius: 24
        anchors.left: rotateRight.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 16
        color: "white"
        visible: webBrowser.canGoForward
        Image {
            anchors.fill: parent
            source: "icons/forward_arrow-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
               webBrowser.goForward();
            }
        }
    }    
    //
    // rotation buttons
    //
    Rectangle {
        id: rotateLeft
        width: 48
        height: 48
        radius: 24
        anchors.right: webBrowser.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 16
        color: "white"
        Image {
            anchors.fill: parent
            source: "icons/rotate-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.parent.rotation = parent.parent.rotation === 0 ? parent.parent.rotation = 180 : parent.parent.rotation = 0;
            }
        }
    }

    Rectangle {
        id: rotateRight
        width: 48
        height: 48
        radius: 24
        anchors.left: webBrowser.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 16
        color: "white"
        Image {
            anchors.fill: parent
            source: "icons/rotate-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.parent.rotation = parent.parent.rotation === 0 ? parent.parent.rotation = 180 : parent.parent.rotation = 0;
            }
        }
    }
    //
    // behaviours
    //
    Behavior on x {
        NumberAnimation {
            duration: 500
        }
    }
    Behavior on rotation {
        NumberAnimation {
            duration: 500
        }
    }
    //
    //
    //
    //
    //
    //
    function show(barcode) {
        if ( barcode.indexOf('library.materialconnexion.com') >= 0 ) {
            var url =  "http://" + barcode;
            webBrowser.url = url;
            x = 0;
        } else {
            console.log( 'MaterialBrowser.show : rejecting barcode : ' + barcode)
        }
    }

    function hide() {
        x = -width;
        webBrowser.url = "blank.html";
        webBrowser.focus = false;
    }
}
