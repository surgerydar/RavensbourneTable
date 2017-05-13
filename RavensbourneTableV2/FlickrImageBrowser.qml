import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Editor {
    //
    // navigation
    //
    RowLayout { // TODO: remove RowLayout
        id: controls
        height: 48
        anchors.left: previousPage.right
        anchors.leftMargin: 12
        anchors.right: nextPage.left
        anchors.rightMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 72
        //
        //
        //
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

    GridView {
        id: imageList
        anchors.left: previousPage.right
        anchors.right: nextPage.left
        anchors.top: parent.top
        anchors.bottom: controls.top
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        anchors.topMargin: 64
        anchors.bottomMargin: 24
        //
        //
        //
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
            id: wrapper
            height: imageList.cellWidth - 16
            width: imageList.cellWidth - 16
            z: 0

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    onClicked: {
                        parent.GridView.view.currentIndex = index;
                    }
                }
            }

            Image {
                id: image
                anchors.fill: parent
                anchors.bottomMargin: 8
                source: display
                fillMode: Image.PreserveAspectFit
            }

            property Image image: image
        }
        onCurrentIndexChanged: {
            if ( currentItem ) {
                previewImage.show(currentItem);
            } else {
                previewImage.hide();
            }
            contentChanged();
        }
    }

    Label {
        id: pageCount
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: imageList.bottom
        verticalAlignment: Label.AlignVCenter
        visible: false
    }

    AnimatedImage {
        id: activityIndicator
        width: 96
        height: 96
        anchors.horizontalCenter: imageList.horizontalCenter
        anchors.verticalCenter: imageList.verticalCenter
        visible: false
        source: "icons/spinner.gif"
        fillMode: Image.PreserveAspectFit
    }
    Rectangle {
        id: previewImage
        anchors.top: imageList.currentItem ? imageList.currentItem.top : parent.bottom
        anchors.left: imageList.currentItem ? imageList.currentItem.left : parent.left
        anchors.bottom: imageList.currentItem ? imageList.currentItem.bottom : parent.bottom
        anchors.right: imageList.currentItem ? imageList.currentItem.right : parent.left
        opacity: 0.
        color: "white"
        //
        // trap clicks
        //
        MouseArea {
            anchors.fill: parent
        }
        //
        //
        //
        Image {
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: previewImage.source
        }
        //
        //
        //
        StandardButton {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 12
            radius: 24
            icon: "icons/down_arrow-black.png"
            color: "white"
            onClicked: {
                previewImage.hide();
            }
        }
        states: [
            State {
                name: "expanded"
                AnchorChanges { target: previewImage; anchors.top: imageList.top; anchors.left: imageList.left; anchors.bottom: imageList.bottom; anchors.right: imageList.right; }
                PropertyChanges { target: previewImage; opacity: 1. }
            }
        ]
        transitions: [
            Transition {
                to: "expanded"
                NumberAnimation {
                    duration: 200;
                    properties: "opacity"
                }
            },
            Transition {
                AnchorAnimation { duration: 500; easing.type: Easing.InOutQuad; }
            }
        ]
        property string source: ""
        function show( item ) {
            if ( state !== "expanded" ) {
                var p = imageList.mapToItem(container,item.x,item.y);
                x = p.x;
                y = p.y;
                width = item.image.width;
                height = item.image.height;
                state = "expanded";
            }
            source = item.image.source.toString().replace('_m.jpg','_c.jpg');
            //
            // swap navigation mode to item
            //
            previousPage.enabled = imageList.currentIndex > 0;
            previousPage.color = "white"
            nextPage.enabled = imageList.currentIndex < imageList.count - 1;
            nextPage.color = "white"
            //nextPage.borderColor = "black"
        }
        function hide() {
            if ( imageList.currentIndex >= 0 ) {
                imageList.currentIndex = -1;
            } else {
                state = "";
                //
                // swap navigation mode to page
                // TODO: may be able to bind this to preview image state
                //
                previousPage.enabled = FlickrImageListModel.page() > 1;
                previousPage.color = "transparent"
                nextPage.enabled = FlickrImageListModel.page() < FlickrImageListModel.pageCount();// - 1;
                nextPage.color = "transparent"
            }
        }
    }
    //
    // page / item navigation
    //
    StandardButton {
        id: previousPage
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: imageList.verticalCenter
        radius: 24
        icon: "icons/back_arrow-black.png"
        color: "transparent"
        enabled: false
        opacity: enabled ? 1. : 0
        onClicked: {
            if ( previewImage.state === "expanded" ) { // TODO: move back to previous page if there is one
                imageList.currentIndex--;
            } else {
                var term = encodeURIComponent(urlBar.text);
                FlickrImageListModel.search(term,FlickrImageListModel.page()-1,pageSize);
            }
        }
        transitions: [
            Transition {
                NumberAnimation {
                    duration: 200;
                    properties: "colour,opacity"
                }
            }
        ]
    }
    StandardButton {
        id: nextPage
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: imageList.verticalCenter
        radius: 24
        icon: "icons/forward_arrow-black.png"
        color: "transparent"
        enabled: false
        opacity: enabled ? 1. : 0
        onClicked: {
            if ( previewImage.state === "expanded" ) { // TODO: move on to next page if there is one
                imageList.currentIndex++;
            } else {
                var term = encodeURIComponent(urlBar.text);
                FlickrImageListModel.search(term,FlickrImageListModel.page()+1,pageSize);
            }
        }
        transitions: [
            Transition {
                NumberAnimation {
                    duration: 200;
                    properties: "colour,opacity"
                }
            }
        ]
    }
    //
    //
    //
    onHeightChanged: {
        var cellDim = imageList.width / 6;
        var rowCount = Math.ceil(imageList.height / cellDim);
        imageList.cellWidth = imageList.cellHeight = cellDim;
        pageSize = Math.max( 6, rowCount * 6 );
    }
    //
    //
    //
    property int pageSize: 100
    //
    //
    //
    function show() {
        state = "open"
    }
    function hide() {
        state = "closed"
        urlBar.focus = false;
        urlBar.text = "";
        FlickrImageListModel.clear();
        previewImage.hide();
        pageCount.visible = false;
    }
    function hasContent() {
        return imageList.currentItem;
    }
    function getContent() {
        if ( imageList.currentItem ) {
            return { type: "image", content: imageList.currentItem.image.source };
        }
        console.trace();
        return null;
    }
    function save() {
        confirm();
    }
    //
    //
    //
    Connections {
        target: FlickrImageListModel
        onModelReset: {
            previousPage.enabled = FlickrImageListModel.page() > 1;
            nextPage.enabled = FlickrImageListModel.page() < FlickrImageListModel.pageCount() - 1;
            pageCount.visible = FlickrImageListModel.pageCount() > 1;
            pageCount.text = 'page ' + FlickrImageListModel.page() + ' of ' + FlickrImageListModel.pageCount();
        }
        onStartSearch : {
            activityIndicator.visible = true;
        }
        onEndSearch : {
            activityIndicator.visible = false;
        }
    }
}
