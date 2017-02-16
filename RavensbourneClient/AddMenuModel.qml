import QtQuick 2.0

ListModel {
    ListElement {
        name: "text"
        icon: "icons/text.png"
        type: "action"
        action: "set_mode_draw"
    }
    ListElement {
        name: "image"
        icon: "icons/image.png"
        type: "action"
        action: "set_mode_image"
    }
    ListElement {
        name: "draw"
        icon: "icons/create.png"
        type: "action"
        action: "set_mode_draw"
    }
}
