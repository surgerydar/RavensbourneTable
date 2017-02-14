import QtQuick 2.0
import QtQuick.Layouts 1.3

Item {
    id: container
    width: 64
    height: 64
    //
    //
    //
    property var user: null
    property bool creator: false
    property var deleteCallback: null
    //
    //
    //
    Rectangle {
        id: icon
        anchors.fill: parent
        radius: width / 2
        color: "#00D2C2"
        border.color: creator ? "#FF6666" : "transparent"
        border.width: creator ? 4 : 1
        Image {
            width: Math.sqrt( (parent.width*parent.width) / 2. )
            height: Math.sqrt( (parent.width*parent.width) / 2. )
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source: "icons/user.png"
        }
        MouseArea {
            anchors.fill: parent
            //
            //
            //
            onClicked: {
                //
                // show user bubble
                //
                if ( popup.visible ) {
                    hidePopup();
                } else {
                    showPopup();
                }
            }
        }
    }
    Rectangle {
        id: loggedIndicator
        width: 8
        height: 8
        anchors.top: parent.top
        anchors.left: parent.left
        radius: 4
        color: "#FF6666"
        visible: false
    }
    Rectangle {
        id: popup
        height: 64
        width: username.implicitWidth + 32 + ( creator ? 0 : 48 )
        anchors.left: icon.horizontalCenter
        anchors.bottom: icon.top
        anchors.bottomMargin: 8
        radius: 32
        visible: false
        color: "#00D2C2"
        Text {
            id: username
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 24
            verticalAlignment: Text.AlignVCenter
        }
        Rectangle {
            id: deleteButton
            width: 48
            height: 48
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            visible: !creator
            color:"transparent"
            Image {
                anchors.fill: parent
                source: "icons/delete-white.png"
            }
            MouseArea {
                anchors.fill: parent
                //
                //
                //
                onClicked: {
                    if ( deleteCallback ) deleteCallback(user.id);
                }
            }
        }
    }
    //
    //
    //
    function setup(param) {
        user = param.user;
        if ( user ) {
            username.text = user.username
        }
        creator = param.creator;
        deleteCallback = param.delete_callback;
    }
    //
    //
    //
    function showPopup() {
        var count = container.parent.children.length;
        for ( var i = 0; i < count; i++ ) {
            console.log('hiding popup : ' + i);
            if ( parent.children[ i ] !== container && parent.children[ i ].hidePopup ) {
                parent.children[ i ].hidePopup();
            }
        }
        popup.visible = true;
    }
    function hidePopup() {
        popup.visible = false;
    }
    function setLoggedIn( loggedIn ) {
        loggedIndicator.visible = loggedIn;
    }

}
