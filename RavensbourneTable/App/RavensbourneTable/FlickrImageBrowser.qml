import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    //
    // geometry
    //
    x: -( 24 + 1920 / 2 )
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
        id: controls
        height: 48
        anchors.left: parent.left
        anchors.leftMargin: parent.rotation === 0 ? 8 : 32
        anchors.right: parent.right
        anchors.rightMargin: parent.rotation === 0 ? 32 : 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12

        Rectangle {
            id: previousPage
            width: 48
            height: 48
            color: "transparent"
            enabled: false
            Image {
                anchors.fill: parent
                source: "icons/back_arrow-black.png"
                fillMode: Image.PreserveAspectFit
                opacity: parent.enabled ? 1.0 : 0.5
                MouseArea {
                    enabled: parent.parent.enabled
                    anchors.fill: parent
                    onClicked: {
                        var term = encodeURIComponent(urlBar.text);
                        FlickrImageListModel.search(term,FlickrImageListModel.page()-1,pageSize); // TODO: implement paging
                    }
                }
            }
        }
        Rectangle {
            id: nextPage
            width: 48
            height: 48
            color: "transparent"
            enabled: false
            Image {
                anchors.fill: parent
                source: "icons/forward_arrow-black.png"
                fillMode: Image.PreserveAspectFit
                opacity: parent.enabled ? 1.0 : 0.5
                MouseArea {
                    enabled: parent.parent.enabled
                    anchors.fill: parent
                    onClicked: {
                        var term = encodeURIComponent(urlBar.text);
                        FlickrImageListModel.search(term,FlickrImageListModel.page()+1,pageSize); // TODO: implement paging
                    }
                }
            }
        }

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
                if ( term.length > 0 ) {
                    console.log( 'image search : ' + term );
                    FlickrImageListModel.search(term,1,pageSize); // TODO: implement paging
                }
            }

        }
    }

    Label {
        id: pageCount
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.top: controls.bottom
    }

    GridView {
        id: imageList
        anchors.fill: parent
        anchors.rightMargin: parent.rotation === 0 ? 32 : 8
        anchors.leftMargin: parent.rotation === 0 ? 8 : 32
        anchors.topMargin: 8
        anchors.bottomMargin: 68
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
            height: imageList.cellWidth - 16
            width: imageList.cellWidth - 16

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
                Drag.mimeData: { "text/uri-list": image.source }
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
    Component.onCompleted: {
        var cellDim = imageList.width / 6;
        imageList.cellWidth = imageList.cellHeight = cellDim;
        pageSize = Math.floor(imageList.height / cellDim) * 6;
    }
    //
    //
    //
    property int pageSize: 100
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
        FlickrImageListModel.clear();
    }
    //
    //
    //
    Connections {
        target: FlickrImageListModel
        onModelReset: {
            previousPage.enabled = FlickrImageListModel.page() > 1;
            nextPage.enabled = FlickrImageListModel.page() < FlickrImageListModel.pageCount() - 1;
            pageCount.text = FlickrImageListModel.page() + ' of ' + FlickrImageListModel.pageCount();
        }
    }
}
