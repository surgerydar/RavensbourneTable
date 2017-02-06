import QtQuick 2.0
import QtWebEngine 1.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    //
    // geometry
    //
    x: -(width+24)
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
        /*
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
        */
        TextField {
            id: urlBar
            height: textFieldHeight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            placeholderText: "search for images of ..."
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
                var term = encodeURIComponent(text);
                console.log( 'image search : ' + term )
                GoogleImageListModel.search(term);
            }

        }
    }

    GridView {
        id: imageList
        anchors.fill: parent
        anchors.rightMargin: parent.rotation === 0 ? 32 : 0
        anchors.leftMargin: parent.rotation === 0 ? 0 : 32
        anchors.topMargin: 80
        //
        //
        //
        cellWidth: 136
        cellHeight: 136
        //
        //
        //
        model: GoogleImageListModel
        delegate: Rectangle {
            height: 128
            width: 128
            Image {
                anchors.fill: parent
                source: display
                fillMode: Image.PreserveAspectFit
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
    property var me: null
    property var materialImage: null
    //
    //
    //
    Component.onCompleted: {
        me = this;
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
    }
}
