import QtQuick 2.0
import QtWebEngine 1.4
import QtQuick.Controls 2.0

Item {
    //
    // geometry
    //
    width: parent.height - 64
    height: parent.height - 64
    x: -(parent.height+64);
    y: (parent.height / 2)-((parent.height - 64)/2)
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: colourTurquoise
    }

    WebEngineView {
        id: webBrowser
        width: Math.sqrt( (parent.width*parent.width) / 2. )
        height: Math.sqrt( (parent.width*parent.width) / 2. )
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        backgroundColor: colourTurquoise
        //
        //
        //
        onNewViewRequested: function(request) { // open all
            request.openIn(webBrowser);
        }
        onLoadingChanged: {
            // default image id "ctl00_phMain_imgMain"
            switch( loadRequest.status ) {
                case WebEngineView.LoadSucceededStatus : {
                    console.log( "loaded" );
                    webBrowser.runJavaScript("var _login_bar = document.querySelector('#ctl00_tblHeader'); if ( _login_bar ) _login_bar.style.display='none';");
                    webBrowser.runJavaScript("document.querySelector('#ctl00_phMain_imgMain').src;", function( image ) {
                        console.log( 'Material Browser : image: ' + image );
                        materialImage = image;
                    });
                }
            }
        }
    }


    Rectangle {
        width: 48
        height: 48
        radius: 24
        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: colourTurquoise
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
        anchors.horizontalCenter: parent.right
        anchors.verticalCenter: parent.verticalCenter
        color: colourTurquoise
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

    Rectangle {
        width: 48
        height: 48
        radius: 24
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.top
        anchors.topMargin: 16
        color: colourTurquoise
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
        width: 48
        height: 48
        radius: 24
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.bottom
        anchors.topMargin: 16
        color: colourTurquoise
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
    // behavious
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
    property var me: null
    //
    //
    //
    Component.onCompleted: {
        me = this;
    }
    //
    //
    //
    function show(barcode) {
        var url =  "http://" + barcode;
        console.log( 'url:' + url);
        console.log( 'webBrowser.url:' + webBrowser.url );
        if ( webBrowser.url != url ) {
            webBrowser.url = "http://" + barcode;
        }
        me.x = (parent.width/2) - (width/2);
    }

    function hide() {
        me.x = -(me.width+64);
        var html = '<html><head></head><body></body></html>';
        var base = 'file://';
        webBrowser.loadHtml(html,base);

    }
}
