import QtQuick 2.0

ListModel {
    ListElement {
        name: "rotate"
        icon: "icons/rotate.png"
    }
    ListElement {
        name: "docs"
        icon: "icons/docs.png"
        type: "action"
        action: "browsedocuments"
    }
    ListElement {
        name: "add"
        icon: "icons/add.png"
        type: "submenu"
        model: "AddItem.qml"
    }
    ListElement {
        name: "user"
        icon: "icons/user.png"
    }
    ListElement {
        name: "search"
        icon: "icons/search.png"
    }
    ListElement {
        name: "create"
        icon: "icons/create.png"
    }
    ListElement {
        name: "image"
        icon: "icons/image.png"
    }
    ListElement {
        name: "text"
        icon: "icons/text.png"
    }
}
