import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "Utils.js" as Utils
import SodaControls 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 1920
    height: 1080
    title: qsTr("Pinch Test")
    //
    // Colours TODO: move these to Style.qml singleton
    //
    property string colourBlue: "#4FC3F7"
    property string colourTurquoise: "#00D2C2"
    property string colourGreen: "#6EDD17"
    property string colourYellow: "#FFB300"
    property string colourRed: "#FF6666"
    property string colourPink: "#FF80AB"
    property string colourGrey: "#EEEDEB"
    //
    //
    //
    property int  textFieldHeight: 48
    property int textFieldFontsize: 18
    //
    // TODO: move all of this into sketch???
    //
    Item {
        id: container
        anchors.fill: parent
        //
        //
        //
        Sketch {
            id: sketch
            anchors.fill: parent
        }
        //
        // universal rotate
        //
        Rectangle {
            width: 58
            height: 58
            radius: height / 2.
            color: colourGreen
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 16
            StandardButton {
                anchors.centerIn: parent
                icon: "icons/rotate-black.png"
                onClicked: {
                    container.rotation = container.rotation === 0. ? 180. : 0.;
                }
            }
        }
        //
        //
        //
        Behavior on rotation {
            NumberAnimation {
                duration: 500
            }
        }
    }
}
