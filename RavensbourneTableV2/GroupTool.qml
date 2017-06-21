import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQml.Models 2.2

Tool {
    id: container
    toolIcon: "icons/user-black.png"
    //
    //
    //
    property var owner: null
    //
    //
    //
    property color colour: "white"
    //
    //
    //
    property ImageItem target: null
    //
    //
    //
    options: VisualDataModel {
        id: userList

        model: ListModel {

        }
        delegate: Item {
            height: 48
            width: icon.width + label.width + 24
            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: colourGrey
            }
            Image {
              id: icon
              width: height
              anchors.top: parent.top
              anchors.left: parent.left
              anchors.bottom: parent.bottom
              anchors.margins: 4
              fillMode: Image.PreserveAspectFit
              source: "icons/user-black.png"
            }
            Label {
                id: label
                width: contentWidth
                anchors.top: parent.top
                anchors.left: icon.right
                anchors.bottom: parent.bottom
                anchors.margins: 4
                verticalAlignment: Label.AlignVCenter
                font.family: ravensbourneRegular.name
                font.pixelSize: 14
                text: model.username
            }
            Rectangle {
                width: 4
                height: width
                radius: height / 2
                anchors.top: icon.top
                anchors.right: icon.right
                color: colourRed
                visible: false // TODO: model.loggedIn
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var userId = model.id;
                    confirmDialog.show( "are you sure you want to remove user '" + model.username + "' from this sketch?", function() {
                        removeUserWithId(userId);
                    });
                }
            }
        }
    }
    //
    //
    //
    onStateChanged: {
        if ( state === "open" ) {
            editor = null;
        }
    }
    function getUsers() {
        var users = [];
        for ( var i = 0; i < userList.model.count; i++ ) {
            var user = userList.model.get(i);
            users.push( {
                id: user.id,
                username: user.username
            });
        }
        return users;
    }
    function clear() {
        userList.model.clear();
    }
    function userIndex( userId ) {
        for ( var i = 0; i < userList.model.count; i++ ) {
            if ( userList.model.get(i).id === userId ) {
                return i;
            }
        }
        return -1;
    }
    function addUser( user, isOwner ) {
        console.log('adding user:' + user.id );
        if ( isOwner ) {
            owner = user;
        } else {
            if ( userIndex( user.id ) < 0 ) {
                userList.model.append(user);
            }
        }
    }
    function removeUser( user ) {
        removeUserWithId( user.id );
    }
    function removeUserWithId( userId ) {
        console.log('removing user' + userId);
        var index = userIndex(userId);
        if ( index >= 0 ) {
            userList.model.remove(index,1);
        }
    }
    function setUserLoggedIn( userId, loggedIn ) {
        if ( owner && owner.id === userId ) {
            owner.loggedIn = loggedIn;
        } else {
            var index = userIndex(userId);
            if ( index >= 0 ) {
                userList.model.get(index).loggedIn = loggedIn;
            }
        }
    }
}
