import QtQuick 2.0
import QtWebEngine 1.4
import QtQuick.Controls 2.0

Item {
    //
    // geometry
    //
    x: -( parent.width / 2 + 24 )
    width: parent.width / 2
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: colourTurquoise
    }

    WebEngineView {
        id: webBrowser
        anchors.fill: parent
        anchors.rightMargin: parent.rotation === 0 ? 32 : 0
        anchors.leftMargin: parent.rotation === 0 ? 0 : 32
        backgroundColor: "transparent"
        onNewViewRequested: function(request) { // open all in same pane TODO: tabs
            request.openIn(webBrowser);
        }
        onLoadingChanged: {
            // default image id "ctl00_phMain_imgMain"
            // product name "ctl00_phMain_lblProductName" / "ctl00_phMain_lblProductName"
            // product manufacturer "ctl00_phMain_lblManufacturerName" /
            // product code "ctl00_phMain_lblMCNumber" library code
            // product description "ctl00_phMain_lblDesc"
            //
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
                var url = webBrowser.url.toString();
                if ( url.indexOf('library.materialconnexion.com') >= 0 ) {
                    console.log( "loaded" );
                    webBrowser.runJavaScript("var _login_bar = document.querySelector('#ctl00_tblHeader'); if ( _login_bar ) _login_bar.style.display='none';");
                    webBrowser.runJavaScript("document.querySelector('#ctl00_phMain_imgMain').src;", function( image ) {
                        console.log( 'Material Browser : image: ' + image );
                        material.image = image;
                        if ( image ) {
                            add.visible = true;
                        }
                    });
                    webBrowser.runJavaScript("document.querySelector('#ctl00_phMain_lblProductName').innerHTML;", function( name ) {
                        console.log( 'Material Browser : name: ' + name );
                        material.name = name;
                    });
                    webBrowser.runJavaScript("document.querySelector('#ctl00_phMain_lblManufacturerName').innerHTML;", function( manufacturer ) {
                        console.log( 'Material Browser : manufacturer: ' + manufacturer );
                        material.manufacturer = manufacturer;
                    });
                }
                break;
            }
        }
        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: 500
            }
        }
        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: 500
            }
        }
    }
    /*
    Rectangle {
        id: activityIndicator
        width: 48
        height: 48
        anchors.verticalCenter: we
    }
    */
    Rectangle {
        id: add
        width: 48
        height: 48
        radius: 24
        anchors.horizontalCenter: parent.rotation === 0 ? parent.right : parent.left
        anchors.bottom: parent.verticalCenter
        color: colourTurquoise
        Image {
            anchors.fill: parent
            source: "icons/add-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if ( material.image ) {
                    parent.parent.addMaterial(material);
                    parent.parent.hide();
                }
            }
        }
    }

    Rectangle {
        width: 48
        height: 48
        radius: 24
        anchors.horizontalCenter: parent.rotation === 0 ? parent.right : parent.left
        anchors.top: parent.verticalCenter
        color: colourTurquoise
        Image {
            anchors.fill: parent
            source: parent.parent.rotation === 0 ? "icons/back_arrow-black.png" : "icons/forward_arrow-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.parent.hide();
            }
        }
    }

    Rectangle {
        width: 48
        height: 48
        radius: 24
        anchors.horizontalCenter: parent.rotation === 0 ? parent.right : parent.left
        anchors.top: parent.top
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
        anchors.horizontalCenter: parent.rotation === 0 ? parent.right : parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
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
    property var material: null
    //
    //
    //
    Component.onCompleted: {
        x = -(width+24);
    }
    //
    // signals
    //
    signal addMaterial( var param )
    //
    //
    //
    function show(barcode) {
        //
        // TODO: rationalise this
        //
        if ( barcode.indexOf('library.materialconnexion.com') >= 0 ) {
            var newMaterial = {};
            newMaterial.url =  "http://" + barcode;
            var productCodeIndex = newMaterial.url.lastIndexOf('mc=');
            if ( productCodeIndex >= 0 ) {
                newMaterial.code = newMaterial.url.substring(productCodeIndex);
                console.log( 'material code : ' + newMaterial.code );
            }
            if ( !material || material.url !== newMaterial.url ) {
                material = newMaterial;
                webBrowser.url = newMaterial.url;
            }
            add.visible = false;
            x = 0;
        } else {
            console.log( 'MaterialBrowser.show : rejecting barcode : ' + barcode)
        }
    }

    function hide() {
        x = -(width+24);
        //
        // hide current materal
        //
        /*
        var html = '<html><head></head><body></body></html>';
        var base = 'file://';
        webBrowser.loadHtml(html,base);
        */
        webBrowser.url = "blank.html";
        material = null;
        webBrowser.focus = false;
    }
}
