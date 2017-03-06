import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4

Item {
    id: container
    x: -1920
    width: parent.width//( parent.width - 48 )
    anchors.top: inputPanelTop.bottom //parent.top
    anchors.topMargin: 24
    anchors.bottom: inputPanelBottom.top //parent.bottom
    anchors.bottomMargin: 24
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
    Rectangle {
        id: imageListBackground
        height: 128
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 72
        radius: 24
        color: "white"
        ListView {
            id: imageList
            anchors.fill: parent
            anchors.margins: 12
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
                }
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: productNameBackground
        height: 48
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 12
        anchors.top: imageListBackground.bottom
        anchors.topMargin: 24
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
        anchors.left: parent.horizontalCenter
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.top: imageListBackground.bottom
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
        id: productDescriptionBackground
        width: ( parent.width * .66 ) - 48
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: productNameBackground.bottom
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
    //
    //
    //
    Rectangle {
        anchors.left: productDescriptionBackground.right
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.top: productNameBackground.bottom
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
    /*
    Rectangle {
        id: productTagsBackground
        height: 48
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 72
        radius: 24
        color: "white"

        TextInput  {
            id: productTags
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            font.family: ravensbourneRegular.name
            font.pixelSize: 18
            verticalAlignment: Text.AlignVCenter
        }
        Label {
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter
            visible: !productTags.focus && productTags.text.length === 0
            font.family: ravensbourneRegular.name
            font.pixelSize: 18
            verticalAlignment: Text.AlignVCenter
            color: "lightGray"
            text: "comma separated list of tags ..."
        }

    }
    */
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
    function show( materialMetadata ) {
        //
        //
        //
        material = materialMetadata;
        //
        //
        //
        imageList.model.clear();
        if ( material.images ) {
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
        x = 0;
    }

    function hide() {
        x = -width
        productTags.focus = false;
    }
}
