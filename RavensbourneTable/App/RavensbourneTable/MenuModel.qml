import QtQuick 2.0

ListModel {
    ListElement {
        name: "rotate"
        icon: "icons/rotate.png"
    }
    ListElement {
        name: "draw"
        icon: "icons/create.png"
        action: "draw"
    }
    ListElement {
        name: "image"
        icon: "icons/image.png"
        action: "image"
    }
    ListElement {
        name: "text"
        icon: "icons/text.png"
        action: "text"
    }
    ListElement {
        name: "delete"
        icon: "icons/delete-white.png"
        action: "delete"
    }
    ListElement {
        name: "back"
        icon: "icons/down_arrow-white.png"
        action: "back"
    }
}
