import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Editor {
    id: container
    //
    //
    //
    Rectangle {
        id: mainImageBackground
        width: parent.width / 3
        height: parent.height / 2
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 72
        radius: 24
        color: "white"
        Image {
            id: mainImage
            anchors.fill: parent
            anchors.margins: 12
            fillMode: Image.PreserveAspectFit
        }
    }
    //
    //
    //
    Rectangle {
        id: productNameBackground
        height: 48
        anchors.left: mainImageBackground.right
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 72
        radius: 24
        color: "white"
        Text {
            id: productName
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            font.family: ravensbourneRegular.name
            font.pixelSize: 18
            verticalAlignment: Text.AlignVCenter
        }
    }
    Rectangle {
        id: productManufacturerBackground
        height: 48
        anchors.left: mainImageBackground.right
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.top: productNameBackground.bottom
        anchors.topMargin: 24
        radius: 24
        color: "white"
        Text {
            id: productManufacturer
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            font.family: ravensbourneRegular.name
            font.pixelSize: 18
            verticalAlignment: Text.AlignVCenter
        }
    }
    //
    //
    //
    Rectangle {
        id: imageListBackground
        height: parent.height / 4
        anchors.left: mainImageBackground.right
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.bottom: mainImageBackground.bottom
        radius: 24
        color: "white"
        ListView {
            id: imageList
            anchors.fill: parent
            anchors.margins: 12
            clip: true
            //
            //
            //
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem
            spacing: 0
            //
            //
            //
            model: ListModel {}
            //
            //
            //
            delegate: Item {
                width: 104
                height: 104
                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: url
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            mainImage.source = parent.source;
                        }
                    }
                }
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: productDescriptionBackground
        width: ( parent.width * .66 ) - 48
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: imageListBackground.bottom
        anchors.topMargin: 24
        //anchors.bottom: productTagsBackground.top
        anchors.bottom: productTags.top
        anchors.bottomMargin: 24
        radius: 24
        color: "white"
        Text {
            id: productDescription
            anchors.fill: parent
            anchors.margins: 12
            font.family: ravensbourneRegular.name
            font.pixelSize: 14
            textFormat: Text.AutoText
            wrapMode: Text.WordWrap
        }
    }
    //
    //
    //
    Rectangle {
        anchors.left: productDescriptionBackground.right
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.top: imageListBackground.bottom
        anchors.topMargin: 24
        //anchors.bottom: productTagsBackground.top
        anchors.bottom: productTags.top
        anchors.bottomMargin: 24
        radius: 24
        color: "white"
        ListView {
            id: productAttributes
            anchors.fill: parent
            clip: true
            //
            //
            //
            orientation: ListView.Vertical
            snapMode: ListView.SnapOneItem
            spacing: 8
            //
            //
            //
            model: ListModel {}
            //
            //
            //
            delegate: Item {
                width: productAttributes.width
                height: 48
                Text {
                   anchors.left: parent.left
                   anchors.right: parent.horizontalCenter
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.rightMargin: 8
                   font.family: ravensbourneRegular.name
                   font.pixelSize: 12
                   horizontalAlignment: Text.AlignRight
                   verticalAlignment: Text.AlignVCenter
                   textFormat: Text.AutoText
                   color: "darkGray"
                   text: name
                }
                Text {
                   anchors.left: parent.horizontalCenter
                   anchors.right: parent.right
                   anchors.top: parent.top
                   anchors.bottom: parent.bottom
                   anchors.leftMargin: 8
                   font.family: ravensbourneRegular.name
                   font.pixelSize: 12
                   horizontalAlignment: Text.AlignLeft
                   verticalAlignment: Text.AlignVCenter
                   textFormat: Text.AutoText
                   baseUrl: "http://library.materialconnexion.com"
                   text: value
                }
            }
        }
    }
    //
    //
    //
    TextField  {
        id: productTags
        height: 48
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 72
        background: Rectangle {
            radius: height / 2
            color: "white"
            border.color: "transparent"
        }
        font.family: ravensbourneRegular.name
        font.pixelSize: 18
        //verticalAlignment: Text.AlignVCenter
        placeholderText: "comma separated list of tags ..."
        //
        //
        //
        onAccepted: {
            material.tags = text.split(',');
            focus = false;
        }
    }
    //
    // close button
    //
    StandardButton {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8
        icon: "icons/close-black.png"
        onClicked : {
            hide();
        }
    }
    //
    //
    property var material: null
    //
    //
    //
    function show( materialMetadata ) {
        state = "open";
        //
        //
        //
        material = materialMetadata;
        //
        //
        //
        mainImage.source = "";
        imageList.model.clear();
        if ( material.images ) {
            mainImage.source = material.images[0];
            material.images.forEach( function( image ) {
                imageList.model.append( {url: image} );
            });
        }
        productName.text = "";
        if ( material.name ) {
            productName.text = material.name;
        }
        productManufacturer.text = "";
        if ( material.manufacturer ) {
            productManufacturer.text = material.manufacturer;
        }
        productDescription.text = "";
        if ( material.description ) {
            productDescription.text = material.description;
        }
        productAttributes.model.clear();
        if ( material.attributes ) {
            material.attributes.forEach( function( attribute ) {
                productAttributes.model.append({"name":attribute.name,"value":attribute.value});
            });
        }
        productTags.text = "";
        if ( material.tags ) {
            productTags.text = material.tags.join();
        }
        //
        //
        //
        state = "open";
    }

    function hide() {
        state = "closed"
        productTags.focus = false;
    }
}
