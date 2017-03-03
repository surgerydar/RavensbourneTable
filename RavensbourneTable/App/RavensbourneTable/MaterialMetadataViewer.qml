import QtQuick 2.7
import QtQuick.Controls 1.4

Item {
    x: -1920
    width: ( parent.width - 128 )
    anchors.top: parent.top
    anchors.topMargin: 64
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 64
    //
    //
    //
    Rectangle {
        anchors.fill: parent
        radius: 48
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
        anchors.topMargin: 24
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
        anchors.right: parent.right
        anchors.rightMargin: 24
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
    //
    //
    //
    Rectangle {
        id: productDescriptionBackground
        width: ( parent.width * .75 ) - 48
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: productNameBackground.bottom
        anchors.topMargin: 24
        anchors.bottom: productTagsBackground.top
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
        anchors.bottom: productTagsBackground.top
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
                   text: value
                }
            }
        }
    }
    //
    //
    //
    Rectangle {
        id: productTagsBackground
        height: 48
        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
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
    //
    //
    //
    Rectangle {
        width: 48
        height: 48
        anchors.right: parent.right
        anchors.top: parent.top
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
        if ( material.name ) {
            productName.text = material.name;
        }
        if ( material.description ) {
            productDescription.text = material.description;
        }
        productAttributes.model.clear();
        if ( material.attributes ) {
            material.attributes.forEach( function( attribute ) {
                productAttributes.model.append({"name":attribute.name,"value":attribute.value});
            });
        }
        if ( material.tags ) {
            productTags.text = material.tags.join();
        }
        //
        //
        //
        x = 64;
    }

    function hide() {
        x = - 1920
    }
}
