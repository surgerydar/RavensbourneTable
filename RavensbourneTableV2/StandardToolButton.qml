import QtQuick 2.7
import QtQuick.Controls 2.1

Button {
    id: button
    width: 48
    height: 48
    //
    //
    //
    background: Rectangle {
        width: button.width
        height: button.width
        color: button.checked ? button.checkedColor : button.color
    }
    //
    //
    //
    Image {
        anchors.fill: parent
        anchors.margins: 4
        source: button.checked ? button.checkedIcon : button.icon
        fillMode: Image.PreserveAspectFit
    }
    //
    //
    //
    property color color: "lightGray"
    property color checkedColor: "darkGray"
    property string icon: ""
    property string checkedIcon: ""
}
