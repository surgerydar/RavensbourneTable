import QtQuick 2.0
import QtWebEngine 1.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    //
    // geometry
    //
    x: -( width + 24 )
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
    WebEngineView {
        id: webBrowser
        anchors.fill: parent
        anchors.rightMargin: parent.rotation === 0 ? 32 : 0
        anchors.leftMargin: parent.rotation === 0 ? 0 : 32
        anchors.topMargin: 80
        backgroundColor: colourTurquoise
        onNewViewRequested: function(request) { // open all
            request.openIn(webBrowser);
        }
        onLoadingChanged: {
            switch( loadRequest.status ) {
            case WebEngineView.LoadStartedStatus :
                busyIndicator.visible = true;
                break;
            case WebEngineView.LoadSucceededStatus :
                // "rshdr" - google images nav bar ???
                // "sfbgg" - google images search bar
                webBrowser.runJavaScript("var _nav_bar = document.querySelector('#rshdr'); if ( _nav_bar ) _nav_bar.style.display='none';");
                webBrowser.runJavaScript("var _search_bar = document.querySelector('#qbc'); if ( _search_bar ) _search_bar.style.display='none';");
                //urlBar.text = this.url;
                var imageScript = "var _list_images = function() { var _image_elements }"

                busyIndicator.visible = false;
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
    property var materialImage: null
    //
    //
    //
    Component.onCompleted: {
    }
    //
    //
    //
    signal addMaterial( string name, string image )
    //
    //
    //
    function show() {
        x = 0;
    }

    function hide() {
        x = -(width+24);
        webBrowser.url = "blank.html";
        webBrowser.focus = false;
        urlBar.focus = false;
    }
}
