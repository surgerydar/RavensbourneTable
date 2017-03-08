import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: container
    //
    // geometry
    //
    x: -1920
    width: parent.width * ( 2./3. )
    anchors.top: inputPanelTop.bottom
    anchors.bottom: inputPanelBottom.top
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        color: colourGreen
    }

    RowLayout {
        id: controls
        height: 48
        anchors.left: parent.left
        anchors.leftMargin: parent.rotation === 0 ? 8 : 32
        anchors.right: parent.right
        anchors.rightMargin: parent.rotation === 0 ? 32 : 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 72

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
                    FlickrImageListModel.search(term,1,pageSize);
                }
            }

        }
    }

    Label {
        id: pageCount
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: controls.bottom

    }

    GridView {
        id: imageList
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: controls.top
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 64
        anchors.bottomMargin: 24

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
        pageSize = Math.max( 6, Math.floor(parent.height / cellDim) * 6 );
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
