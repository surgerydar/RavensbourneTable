import QtQuick 2.0
//import QtWebEngine 1.0
import QtQuick.Controls 2.0
import QtWebView 1.1
import QtQuick.Layouts 1.3

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
        MouseArea {
            onClicked: {

            }
        }
    }

    RowLayout {
        height: 48
        anchors.left: parent.left
        anchors.leftMargin: parent.rotation === 0 ? 8 : 32
        anchors.right: parent.right
        anchors.rightMargin: parent.rotation === 0 ? 32 : 8
        anchors.top: parent.top
        anchors.topMargin: 8
        Rectangle {
            width: 48
            height: 48
            visible: webBrowser.canGoBack
            color: "transparent"
            Image {
                anchors.fill: parent
                source: "icons/back_arrow-black.png"
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        webBrowser.goBack();
                    }
                }
            }
        }
        Rectangle {
            width: 48
            height: 48
            visible: webBrowser.canGoForward
            color: "transparent"
            Image {
                anchors.fill: parent
                source: "icons/forward_arrow-black.png"
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        webBrowser.goForward();
                    }
                }
            }
        }

        TextField {
            id: urlBar
            height: textFieldHeight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            placeholderText: "enter search or url"
            background: Rectangle {
                radius: height / 2
                color: "white"
                border.color: "transparent"
            }
            font.pixelSize: textFieldFontsize
            //
            //
            //
            onAccepted: {
                var url = this.text;
                if ( url.indexOf( 'http://' ) !== 0 ||  url.indexOf( 'https://' ) !== 0 ) {
                    //
                    //
                    url = 'http://google.com/search?tbm=isch&q=' + url.replace( ' ', '+' );
                }
                console.log( 'ImageBrowser : navigating to : ' + url );
                webBrowser.url = url;
            }
            /*
            onFocusChanged: {
                if( urlBar.focus ) {
                    if ( parent.rotation > 0 ) {
                        inputPanel.y        = inputPanel.parent.y;
                        inputPanel.rotation = 180;
                    } else {
                        inputPanel.y        = inputPanel.parent.height - inputPanel.height;
                        inputPanel.rotation = 0;
                    }
                } else {
                    inputPanel.y = inputPanel.parent.height;
                    inputPanel.rotation = 0;
                }
            }
            */
        }
    }
    //WebEngineView {
    WebView {
        id: webBrowser
        anchors.fill: parent
        anchors.rightMargin: parent.rotation === 0 ? 32 : 0
        anchors.leftMargin: parent.rotation === 0 ? 0 : 32
        anchors.topMargin: 80

        /*
        backgroundColor: colourTurquoise
        onNewViewRequested: function(request) { // open all
            request.openIn(webBrowser);
        }
        */
        onLoadingChanged: {
            switch( loadRequest.status ) {
            case WebView.LoadStartedStatus :
                console.log( 'ImageBrowser : webBrowser : loading started');
                busyIndicator.visible = true;
                break;
            case WebView.LoadSucceededStatus :
                console.log( 'ImageBrowser : webBrowser : loading succeeded');
                // "rshdr" - google images nav bar ???
                // "sfbgg" - google images search bar
                //webBrowser.runJavaScript("var _nav_bar = document.querySelector('#rshdr'); if ( _nav_bar ) _nav_bar.style.display='none';");
                //webBrowser.runJavaScript("var _search_bar = document.querySelector('#qbc'); if ( _search_bar ) _search_bar.style.display='none';");
                webBrowser.runJavaScript("function getImages() { var collection = document.getElementsByTagName('img'); var images = []; for ( var i = 0; i < collection.length; i++ ) images.push('\"'+collection[i].src+'\"'); return images; } JSON.stringify(getImages());", function( result ) {
                    //console.log('result : ' + result );
                    /*
                    console.log('result : ' + result );
                    var images = eval('[' + result + ']');
                    var count = images.length();
                    for ( var i = 0; i < count; i++ ) {
                        console.log('image = ' + images[ i ] );
                    }
                    if ( count === 0 ) console.log('result : ' + result );
                    */
                });
                //urlBar.text = this.url;
                busyIndicator.visible = false;
                break;
            case WebView.LoadFailedStatus :
                console.log( 'ImageBrowser : webBrowser : loading failed : ' + loadRequest.errorString );
                break;
            default:
                busyIndicator.visible = false;
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
    AnimatedImage {
        id: busyIndicator
        width: 48
        height: 48
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        source:"icons/spinner.gif"
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
    //
    // Rotation controls
    //
    /*
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
    */
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
    property var materialImage: null
    //
    //
    //
    Component.onCompleted: {
        me = this; // JONS: do I need this ? I think all properties are in scope
    }
    //
    //
    //
    signal addMaterial( string name, string image )
    //
    //
    //
    function show() {
        me.x = 0;
    }

    function hide() {
        me.x = -(me.width+24);
        webBrowser.url = "";
        webBrowser.focus = false;
        urlBar.focus = false;
    }
}
