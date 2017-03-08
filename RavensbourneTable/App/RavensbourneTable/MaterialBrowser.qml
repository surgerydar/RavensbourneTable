import QtQuick 2.0
import QtWebEngine 1.4
import QtQuick.Controls 2.0

Item {
    id: container
    //
    // geometry
    //
    x: -1920
    width: parent.width//( parent.width - 48 )
    anchors.top: inputPanelTop.bottom //parent.top
    anchors.bottom: inputPanelBottom.top //parent.bottom
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: colourGreen
    }
    //
    //
    //
    WebEngineView {
        id: webBrowser
        anchors.fill: parent
        anchors.topMargin: 72
        anchors.bottomMargin: 72
        backgroundColor: "transparent"
        onNewViewRequested: function(request) { // open all in same pane TODO: tabs
            request.openIn(webBrowser);
        }
        onLoadingChanged: {
            console.log( 'material url : ' + loadRequest.url );
            //
            // default image id "ctl00_phMain_imgMain"
            // product name "ctl00_phMain_lblProductName" / "ctl00_phMain_lblProductName"
            // product manufacturer "ctl00_phMain_lblManufacturerName" /
            // product code "ctl00_phMain_lblMCNumber" library code
            // product description "ctl00_phMain_lblDesc"
            // physical attributes : name "physAttribName" value "physAttribValue"
            // product images "img" class "preload"
            //
            switch( loadRequest.status ) {
            case WebEngineView.LoadStartedStatus :
                busyIndicator.visible = true;
                addTop.visible = addBottom.visible = false;
                break;
            case WebEngineView.LoadStoppedStatus :
            case WebEngineView.LoadFailedStatus :
                busyIndicator.visible = false;
                break;
            case WebEngineView.LoadSucceededStatus :
                busyIndicator.visible = false;
                var url = webBrowser.url.toString();
                if ( url.indexOf('library.materialconnexion.com') >= 0 ) {
                    //
                    // scrape metadata
                    //
                    console.log( "loaded" );
                    webBrowser.runJavaScript("var _login_bar = document.querySelector('#ctl00_tblHeader'); if ( _login_bar ) _login_bar.style.display='none';");
                    webBrowser.runJavaScript("document.querySelector('#ctl00_phMain_imgMain').src;", function( image ) {
                        //console.log( 'Material Browser : image: ' + image );
                        material.image = image;
                        if ( image ) {
                            addTop.visible = addBottom.visible = true;
                        }
                    });
                    webBrowser.runJavaScript("document.querySelector('#ctl00_phMain_lblProductName').innerHTML;", function( name ) {
                        //console.log( 'Material Browser : name: ' + name );
                        material.name = name.replace(/[^A-Za-z 0-9 \.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]*/g, '');
                    });
                    webBrowser.runJavaScript("document.querySelector('#ctl00_phMain_lblManufacturerName').innerHTML;", function( manufacturer ) {
                        console.log( 'Material Browser : manufacturer: ' + manufacturer );
                        material.manufacturer = manufacturer.replace(/[^A-Za-z 0-9 \.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]*/g, '');
                    });
                    webBrowser.runJavaScript("document.querySelector('#ctl00_phMain_lblDesc').innerHTML;", function( description ) {
                        //console.log( 'Material Browser : description: ' + description );
                        material.description = description.replace(/[^A-Za-z 0-9 \.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]*/g, '');
                    });
                    webBrowser.runJavaScript("var imageArray = []; document.querySelectorAll('.preload').forEach( function( image ) { imageArray.push(image.src); } ); imageArray.join();", function( productImages ) {
                        material.images = productImages.split(',');
                    });
                    webBrowser.runJavaScript("var attribNames = document.querySelectorAll('.physAttribName'); var attribValues = document.querySelectorAll('.physAttribValue'); var attribList = []; for ( var i = 0; i < attribNames.length; i++ ) { attribList.push( attribNames[ i ].innerHTML.trim() + '|' + attribValues[ i ].innerHTML.trim() ) }; attribList.join('~');", function( productAttributes ) {
                        material.attributes = [];
                        //console.log( 'productAttributes=' + productAttributes );
                        if ( productAttributes.length > 0 ) {
                            productAttributes.split('~').forEach( function( attribute ) {
                                //console.log( 'attribute=' + attribute );
                                var attributeArray = attribute.split('|');
                                if ( attributeArray.length > 0 ) {
                                    material.attributes.push( { name: attributeArray[ 0 ].replace(/[^A-Za-z 0-9 \.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]*/g, ''), value: attributeArray[ 1 ].replace(/[^A-Za-z 0-9 \.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]`~]*/g, '') } );
                                }
                            });
                        }
                        //console.log( 'attribute list=' + JSON.stringify(material.attributes));
                    });
                }
                break;
            }
        }
    }
    //
    // add buttons
    //
    Rectangle {
        id: addTop
        width: 48
        height: 48
        radius: 24
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 12
        color: colourGreen
        Image {
            anchors.fill: parent
            source: "icons/add-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if ( material.image ) {
                    container.addMaterial(material);
                    container.hide();
                }
            }
        }
    }
    Rectangle {
        id: addBottom
        width: 48
        height: 48
        radius: 24
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        color: colourGreen
        Image {
            anchors.fill: parent
            source: "icons/add-black.png"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if ( material.image ) {
                    container.addMaterial(material);
                    container.hide();
                }
            }
        }
    }
    //
    // close buttons
    //
    Rectangle {
        width: 48
        height: 48
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 12
        radius: width / 2
        color: colourGreen
        Image {
            anchors.fill: parent
            source: "icons/close-black.png"
            MouseArea {
                anchors.fill: parent
                onClicked : {
                    hide();
                }
            }
        }
    }
    Rectangle {
        width: 48
        height: 48
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 12
        radius: width / 2
        color: colourGreen
        Image {
            anchors.fill: parent
            source: "icons/close-black.png"
            MouseArea {
                anchors.fill: parent
                onClicked : {
                    hide();
                }
            }
        }
    }
    //
    // rotate buttons
    //
    Rectangle {
        width: 48
        height: 48
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 12
        radius: width / 2
        color: colourGreen
        Image {
            anchors.fill: parent
            source: "icons/rotate-black.png"
            MouseArea {
                anchors.fill: parent
                onClicked : {
                    container.rotation = container.rotation === 0 ? 180 : 0;
                }
            }
        }
    }
    Rectangle {
        width: 48
        height: 48
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 12
        radius: width / 2
        color: colourGreen
        Image {
            anchors.fill: parent
            source: "icons/rotate-black.png"
            MouseArea {
                anchors.fill: parent
                onClicked : {
                    container.rotation = container.rotation === 0 ? 180 : 0;
                }
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
    property var material: null
    //
    //
    //
    Component.onCompleted: {
        x = -width;
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
            addTop.visible = addBottom.visible = false;
            x = 0;
        } else {
            console.log( 'MaterialBrowser.show : rejecting barcode : ' + barcode)
        }
    }

    function hide() {
        x = -width;
        //
        // hide current materal
        //
        webBrowser.url = "blank.html";
        material = null;
        webBrowser.focus = false;
        addTop.visible = addBottom.visible = false;
    }
}
