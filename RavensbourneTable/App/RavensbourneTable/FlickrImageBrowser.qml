import QtQuick 2.7
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
        color: colourGreen
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
                FlickrImageListModel.search(term,1,100); // TODO: implement paging
            }

        }
    }

    GridView {
        id: imageList
        anchors.fill: parent
        anchors.rightMargin: parent.rotation === 0 ? 32 : 8
        anchors.leftMargin: parent.rotation === 0 ? 8 : 32
        anchors.topMargin: 80
        clip: true
        //
        //
        //
        cellWidth: 136
        cellHeight: 136
        //
        //
        //
        model: FlickrImageListModel
        delegate: Rectangle {
            id: container
            height: 128
            width: 128

            Image {
                id: image
                anchors.fill: parent
                source: display
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                drag.target: draggable
            }
            Item {
                id: draggable
                anchors.fill: parent
                Drag.active: mouseArea.drag.active
                Drag.hotSpot.x: 0
                Drag.hotSpot.y: 0
                Drag.mimeData: { "text/uri-list": image.source, "image/jpg" : image }
                Drag.dragType: Drag.Automatic
                Drag.onDragStarted: {
                }
                Drag.onDragFinished: {
                    if (dropAction == Qt.CopyAction) {
                        //item.display = ""
                    }
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
        color: colourGreen
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
        color: colourGreen
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
        color: colourGreen
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
    signal addMaterial( string name, string image )
    //
    //
    //
    function show() {
        x = 0;
    }

    function hide() {
        x = -(width+24);
        urlBar.focus = false;
    }
}
